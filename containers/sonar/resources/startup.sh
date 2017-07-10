#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

ADMINGROUP=$(doguctl config --global admin_group)
SONAR_PROPERTIESFILE=/opt/sonar/conf/sonar.properties

function move_sonar_dir(){
  DIR="$1"
  if [ ! -d "/var/lib/sonar/$DIR" ]; then
    mv /opt/sonar/$DIR /var/lib/sonar
    ln -s /var/lib/sonar/$DIR /opt/sonar/$DIR
  elif [ ! -L "/opt/sonar/$DIR" ] && [ -d "/opt/sonar/$DIR" ]; then
    rm -rf /opt/sonar/$DIR
    ln -s /var/lib/sonar/$DIR /opt/sonar/$DIR
  fi
}

function render_template(){
  FILE="$1"
  if [ ! -f "$FILE.tpl" ]; then
    echo "could not find template $FILE.tpl"
    exit 1
  fi

  if [ -f "$FILE" ]; then
    rm -f "$FILE"
  fi

  echo "render template $FILE.tpl to $FILE"

  # render template
  eval "echo \"$(cat $FILE.tpl)\"" | egrep -v '^#' | egrep -v '^\s*$' > "$FILE"
}

function setProxyConfiguration(){
  removeProxyRelatedEntriesFrom ${SONAR_PROPERTIESFILE}
  # Write proxy settings if enabled in etcd
  if [ "true" == "$(doguctl config --global proxy/enabled)" ]; then
    if PROXYSERVER=$(doguctl config --global proxy/server) && PROXYPORT=$(doguctl config --global proxy/port); then
      writeProxyCredentialsTo ${SONAR_PROPERTIESFILE}
      if PROXYUSER=$(doguctl config --global proxy/username) && PROXYPASSWORD=$(doguctl config --global proxy/password); then
        writeProxyAuthenticationCredentialsTo ${SONAR_PROPERTIESFILE}
      else
        echo "Proxy authentication credentials are incomplete or not existent."
      fi
    else
      echo "Proxy server or port configuration missing in etcd."
    fi
  fi
}

function removeProxyRelatedEntriesFrom() {
  sed -i '/http.proxyHost=.*/d' $1
  sed -i '/http.proxyPort=.*/d' $1
  sed -i '/http.proxyUser=.*/d' $1
  sed -i '/http.proxyPassword=.*/d' $1
}

function writeProxyCredentialsTo(){
  echo http.proxyHost=${PROXYSERVER} >> $1
  echo http.proxyPort=${PROXYPORT} >> $1
}

function writeProxyAuthenticationCredentialsTo(){
  # Check for java option and add it if not existent
  if [ -z "$(grep sonar.web.javaAdditionalOpts= $1 | grep Djdk.http.auth.tunneling.disabledSchemes=)" ]; then
    sed -i '/^sonar.web.javaAdditionalOpts=/ s/$/ -Djdk.http.auth.tunneling.disabledSchemes=/' $1
  fi
  # Add proxy authentication credentials
  echo http.proxyUser=${PROXYUSER} >> ${SONAR_PROPERTIESFILE}
  echo http.proxyPassword=${PROXYPASSWORD} >> ${SONAR_PROPERTIESFILE}
}

# End of function declaration, work is done now...


move_sonar_dir conf
move_sonar_dir extensions
move_sonar_dir data
move_sonar_dir logs
move_sonar_dir temp

# get variables for templates
FQDN=$(doguctl config --global fqdn)
DOMAIN=$(doguctl config --global domain)
DATABASE_TYPE=postgresql
DATABASE_IP=postgresql
DATABASE_PORT=5432
DATABASE_USER=$(doguctl config -e sa-postgresql/username)
DATABASE_USER_PASSWORD=$(doguctl config -e sa-postgresql/password)
DATABASE_DB=$(doguctl config -e sa-postgresql/database)

# wait until postgresql passes all health checks
echo "wait until postgresql passes all health checks"
if ! doguctl healthy --wait --timeout 120 postgresql; then
  echo "timeout reached by waiting of postgresql to get healthy"
  exit 1
fi

function sql(){
  PGPASSWORD="${DATABASE_USER_PASSWORD}" psql --host "${DATABASE_IP}" --username "${DATABASE_USER}" --dbname "${DATABASE_DB}" -1 -c "${1}"
  return $?
}

# create truststore, which is used in the sonar.properties file
create_truststore.sh > /dev/null

# pre cas authentication configuration
if ! [ "$(cat ${SONAR_PROPERTIESFILE} | grep sonar.security.realm)" == "sonar.security.realm=cas" ]; then
	# prepare config
	REALM="cas"
	render_template "${SONAR_PROPERTIESFILE}"
	# move cas plugin to right folder
	if [ -f "/opt/sonar/sonar-cas-plugin-0.3-TRIO-SNAPSHOT.jar" ]; then
		mv /opt/sonar/sonar-cas-plugin-0.3-TRIO-SNAPSHOT.jar /var/lib/sonar/extensions/plugins/
	fi
  # move german language pack to correct folder
  if [ -f "/opt/sonar/sonar-l10n-de-plugin-1.2.jar" ]; then
    mv /opt/sonar/sonar-l10n-de-plugin-1.2.jar /var/lib/sonar/extensions/plugins/
  fi

  setProxyConfiguration

	# start in background
	su - sonar -c "java -jar /opt/sonar/lib/sonar-application-$SONAR_VERSION.jar" &

  echo "wait until sonarqube has finished database migration"
  N=0
  until [ $N -ge 24 ]; do
    # we are waiting for the last known migration version
    if sql "SELECT 1 FROM schema_migrations WHERE version='1153';" &> /dev/null; then
      break
    else
      N=$[$N+1]
      sleep 10
    fi
  done

  # sleep 10 seconds more to sure migration has finished
  sleep 10

  echo "apply ces configurations"

	# set base url
  sql "INSERT INTO properties (prop_key, text_value) VALUES ('sonar.core.serverBaseURL', 'https://${FQDN}/sonar');"

  # remove default admin
  sql "DELETE FROM users WHERE login='admin';"

  # add admin group
  sql "INSERT INTO groups (name, description, created_at) VALUES ('${ADMINGROUP}', 'CES Administrator Group', now());"

  # add admin privileges to admin group
  sql "INSERT INTO group_roles (group_id, role) VALUES((SELECT id FROM groups WHERE name='${ADMINGROUP}'), 'admin');"

  # set email settings
  sql "INSERT INTO properties (prop_key, text_value) VALUES ('email.smtp_host.secured', 'postfix');"
  sql "INSERT INTO properties (prop_key, text_value) VALUES ('email.smtp_port.secured', '25');"
  sql "INSERT INTO properties (prop_key, text_value) VALUES ('email.from', 'sonar@${DOMAIN}');"
  sql "INSERT INTO properties (prop_key, text_value) VALUES ('email.prefix', '[SONARQUBE]');"

  # reattach to sonarqube process
  wait
else
  # refresh base url
  sql "UPDATE properties SET text_value='https://${FQDN}/sonar' WHERE prop_key='sonar.core.serverBaseURL';"

  # refresh FQDN
  sed -i "/sonar.cas.casServerLoginUrl=.*/c\sonar.cas.casServerLoginUrl=https://${FQDN}/cas/login" ${SONAR_PROPERTIESFILE}
  sed -i "/sonar.cas.casServerUrlPrefix=.*/c\sonar.cas.casServerUrlPrefix=https://${FQDN}/cas" ${SONAR_PROPERTIESFILE}
  sed -i "/sonar.cas.sonarServerUrl=.*/c\sonar.cas.sonarServerUrl=https://${FQDN}/sonar" ${SONAR_PROPERTIESFILE}
  sed -i "/sonar.cas.casServerLogoutUrl=.*/c\sonar.cas.casServerLogoutUrl=https://${FQDN}/cas/logout" ${SONAR_PROPERTIESFILE}

  setProxyConfiguration

  # fire it up
  exec su - sonar -c "exec java -jar /opt/sonar/lib/sonar-application-$SONAR_VERSION.jar"
fi
