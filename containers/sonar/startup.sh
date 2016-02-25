#!/bin/bash

source /etc/ces/functions.sh
ADMINGROUP="universalAdmin"

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
move_sonar_dir logs

# get variables for templates
FQDN=$(get_fqdn)
MYSQL_IP=mysql
MYSQL_ADMIN="root"
MYSQL_ADMIN_PASSWORD=$(get_ces_pass mysql_root)
MYSQL_USER="sonar"
MYSQL_USER_PASSWORD=$(create_or_get_ces_pass mysql_sonar)
MYSQL_DB="sonar"

# prepare database
if [ $(mysql -N -s -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "select count(*) from information_schema.tables where table_schema='${MYSQL_DB}' and table_name='projects';") -eq 1 ]; then
  echo "sonar database is already installed"
else
  echo "install sonar database"
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "CREATE DATABASE ${MYSQL_DB} DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" "${MYSQL_DB}" -e "grant all on ${MYSQL_DB}.* to \"${MYSQL_USER}\"@\"%\" identified by \"${MYSQL_USER_PASSWORD}\";FLUSH PRIVILEGES;"
fi

# pre cas authentication configuration
if ! [ "$(cat /opt/sonar/conf/sonar.properties | grep sonar.security.realm)" == "sonar.security.realm=cas" ]; then
	# prepare config
	REALM=""
	render_template "/opt/sonar/conf/sonar.properties"
	# start in background
	su - sonar -c "exec /opt/jdk/bin/java -jar /opt/sonar/lib/sonar-application-$SONAR_VERSION.jar" &
	# create and populate adminGroup
	/sonaradmingroup.sh "$ADMINGROUP"
	kill $!
	# move cas plugin to right folder
	if [ -f "/opt/sonar/sonar-cas-plugin-0.3-TRIO-SNAPSHOT.jar" ]; then
		mv /opt/sonar/sonar-cas-plugin-0.3-TRIO-SNAPSHOT.jar /var/lib/sonar/extensions/plugins/
	fi
	# prepare config
	REALM="cas"
	render_template "/opt/sonar/conf/sonar.properties"
fi

# fire it up
exec su - sonar -c "exec /opt/jdk/bin/java -jar /opt/sonar/lib/sonar-application-$SONAR_VERSION.jar"
