#!/bin/bash

source /etc/ces/functions.sh

ADMINGROUP=$(doguctl config --global admin_group)

function move_sonar_dir(){
  DIR="$1"
  if [ ! -d "/var/lib/sonar/$DIR" ]; then
    mv /opt/sonar/$DIR /var/lib/sonar
    ln -s /var/lib/sonar/$DIR /opt/sonar/$DIR
  elif [ ! -L "/opt/sonar/$DIR" -a -d "/opt/sonar/$DIR" ]; then
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
if ! [ "$(cat /opt/sonar/conf/sonar.properties | grep sonar.security.realm)" == "sonar.security.realm=cas" ]; then
	# prepare config
	REALM="cas"
	render_template "/opt/sonar/conf/sonar.properties"

	# move cas plugin to right folder
	if [ -f "/opt/sonar/sonar-cas-plugin-0.3-TRIO-SNAPSHOT.jar" ]; then
		mv /opt/sonar/sonar-cas-plugin-0.3-TRIO-SNAPSHOT.jar /var/lib/sonar/extensions/plugins/
	fi

	# start in background
	su - sonar -c "/opt/jdk/bin/java -jar /opt/sonar/lib/sonar-application-$SONAR_VERSION.jar" &

  # wait until database is installed
  N=0
  until [ $N -ge 24 ]; do
    #TODO: Adapt sql function so it is usable with -t parameter here
    SELECTION=$(PGPASSWORD="${DATABASE_USER_PASSWORD}" psql -t --host "${DATABASE_IP}" --username "${DATABASE_USER}" --dbname "${DATABASE_DB}" -1 -c "SELECT count(1) FROM information_schema.tables WHERE table_type='BASE TABLE' AND table_schema NOT IN ('pg_catalog', 'information_schema') AND table_name='properties';")
    if [ "${SELECTION}" -eq 1 ] ; then
      break
    else
      N=$[$N+1]
      sleep 10
    fi
  done

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

  # wait for sonar
  wait
else
  # refresh base url
  sql "UPDATE properties SET text_value='https://${FQDN}/sonar' WHERE prop_key='sonar.core.serverBaseURL';"

  # refresh FQDN
	sed -i "/sonar.cas.casServerLoginUrl=.*/c\sonar.cas.casServerLoginUrl=https://${FQDN}/cas/login" /opt/sonar/conf/sonar.properties
  sed -i "/sonar.cas.casServerUrlPrefix=.*/c\sonar.cas.casServerUrlPrefix=https://${FQDN}/cas" /opt/sonar/conf/sonar.properties
  sed -i "/sonar.cas.sonarServerUrl=.*/c\sonar.cas.sonarServerUrl=https://${FQDN}/sonar" /opt/sonar/conf/sonar.properties
  sed -i "/sonar.cas.casServerLogoutUrl=.*/c\sonar.cas.casServerLogoutUrl=https://${FQDN}/cas/logout" /opt/sonar/conf/sonar.properties

  # fire it up
  exec su - sonar -c "exec /opt/jdk/bin/java -jar /opt/sonar/lib/sonar-application-$SONAR_VERSION.jar"
fi
