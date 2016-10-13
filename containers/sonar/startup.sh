#!/bin/bash

source /etc/ces/functions.sh

# TODO get admin group from etcd
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

# get variables for templates
FQDN=$(doguctl config --global fqdn)
MYSQL_IP=mysql
MYSQL_USER=$(doguctl config -e sa-mysql/username)
MYSQL_USER_PASSWORD=$(doguctl config -e sa-mysql/password)
MYSQL_DB=$(doguctl config -e sa-mysql/database)

# create truststore, which is used in the sonar.properties file
create_truststore.sh > /dev/null

# pre cas authentication configuration
if ! [ "$(cat /opt/sonar/conf/sonar.properties | grep sonar.security.realm)" == "sonar.security.realm=cas" ]; then
	# prepare config
	REALM=""
	render_template "/opt/sonar/conf/sonar.properties"
	# start in background
	su - sonar -c "exec /opt/jdk/bin/java -jar /opt/sonar/lib/sonar-application-$SONAR_VERSION.jar" &
	# create and populate adminGroup
	/sonaradmingroup.sh "$ADMINGROUP"
	/sonarmailconfig.sh
  /sonarbaseurl.sh
	kill $!
	# move cas plugin to right folder
	if [ -f "/opt/sonar/sonar-cas-plugin-0.3-TRIO-SNAPSHOT.jar" ]; then
		mv /opt/sonar/sonar-cas-plugin-0.3-TRIO-SNAPSHOT.jar /var/lib/sonar/extensions/plugins/
	fi
	# prepare config
	REALM="cas"
	render_template "/opt/sonar/conf/sonar.properties"
else
  # refresh FQDN
	sed -i "/sonar.cas.casServerLoginUrl=.*/c\sonar.cas.casServerLoginUrl=https://${FQDN}/cas/login" /opt/sonar/conf/sonar.properties
  sed -i "/sonar.cas.casServerUrlPrefix=.*/c\sonar.cas.casServerUrlPrefix=https://${FQDN}/cas" /opt/sonar/conf/sonar.properties
  sed -i "/sonar.cas.sonarServerUrl=.*/c\sonar.cas.sonarServerUrl=https://${FQDN}/sonar" /opt/sonar/conf/sonar.properties
  sed -i "/sonar.cas.casServerLogoutUrl=.*/c\sonar.cas.casServerLogoutUrl=https://${FQDN}/cas/logout" /opt/sonar/conf/sonar.properties
fi

# fire it up
exec su - sonar -c "exec /opt/jdk/bin/java -jar /opt/sonar/lib/sonar-application-$SONAR_VERSION.jar"
