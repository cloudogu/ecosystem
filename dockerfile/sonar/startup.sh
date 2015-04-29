#!/bin/bash

source /etc/ces/functions.sh

function move_sonar_dir(){
  DIR="$1"
  if [ ! -d "/var/lib/sonar/$DIR" ]; then
    mv /opt/sonar/$DIR /var/lib/sonar
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
MYSQL_IP=$(get_service mysql 3306 | awk -F':' '{print $1}')
MYSQL_ADMIN="root"
MYSQL_ADMIN_PASSWORD=$(get_ces_pass mysql_root)
MYSQL_USER="sonar"
MYSQL_USER_PASSWORD=$(create_or_get_ces_pass mysql_sonar)
MYSQL_DB="sonar"

# prepare config
render_template "/opt/sonar/conf/sonar.properties"
render_template "/opt/sonar/conf/wrapper.conf"

# prepare database
if [ $(mysql -N -s -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "select count(*) from information_schema.tables where table_schema='${MYSQL_DB}' and table_name='projects';") -eq 1 ]; then
  echo "sonar database is already installed"
else
  echo "install sonar database"
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "CREATE DATABASE ${MYSQL_DB} DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" "${MYSQL_DB}" -e "grant all on ${MYSQL_DB}.* to \"${MYSQL_USER}\"@\"172.17.%\" identified by \"${MYSQL_USER_PASSWORD}\";FLUSH PRIVILEGES;"
fi
su - sonar -c "/opt/sonar/bin/linux-x86-64/sonar.sh console"
