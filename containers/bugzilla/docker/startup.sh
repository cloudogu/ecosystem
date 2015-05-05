#!/bin/bash

source /etc/ces/functions.sh

# get variables for templates
FQDN=$(get_fqdn)
MYSQL_IP=$(get_service mysql 3306 | awk -F':' '{print $1}')
MYSQL_ADMIN="root"
MYSQL_ADMIN_PASSWORD=$(get_ces_pass mysql_root)
MYSQL_USER="bugzilla"
MYSQL_USER_PASSWORD=$(create_or_get_ces_pass mysql_bugzilla)
MYSQL_DB="bugzilla"

# prepare database
if [ $(mysql -N -s -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "select count(*) from information_schema.tables where table_schema='${MYSQL_DB}' and table_name='bugs';") -eq 1 ]; then
  echo "sonar database is already installed"
else
  echo "install bugzilla database"
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "CREATE DATABASE ${MYSQL_DB} DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" "${MYSQL_DB}" -e "grant all on ${MYSQL_DB}.* to \"${MYSQL_USER}\"@\"172.17.%\" identified by \"${MYSQL_USER_PASSWORD}\";FLUSH PRIVILEGES;"

  # bugzilla
	cd /bugzilla

	# modify localconfig
	sed -i"install" \
	  "s/\$db_host = 'localhost';/\$db_host = \"${MYSQL_IP}\";/g;\
     s/\$db_user = 'bugs';/\$db_user = \"${MYSQL_USER}\";/g;\
     s/\$db_pass = '';/\$db_pass = \"${MYSQL_USER_PASSWORD}\";/g;\
     s/\$db_name = 'bugzilla';/\$db_name = \"${MYSQL_DB}\";/g" \
		/bugzilla/localconfig

	perl ./checksetup.pl
fi
