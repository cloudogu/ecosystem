#!/bin/bash
source /etc/ces/functions.sh

# install redmine database
#MYSQL_ROOT_PASSWORD=$(create_or_get_ces_pass mysql_root)


# get variables for templates
FQDN=$(get_fqdn)
MYSQL_IP=mysql
MYSQL_ADMIN="root"
MYSQL_ADMIN_PASSWORD=$(get_ces_pass mysql_root)
MYSQL_USER="redmine"
MYSQL_USER_PASSWORD=$(create_or_get_ces_pass mysql_redmine)
MYSQL_DB="redmine"
# prepare database
if [ $(mysql -N -s -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "select count(*) from information_schema.tables where table_schema='${MYSQL_DB}';") -eq 1 ]; then
  echo "redmine database is already installed"
else
  echo "install redmine database"
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "CREATE DATABASE ${MYSQL_DB} CHARACTER SET utf8;"
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "CREATE USER '${MYSQL_USER}'@'${MYSQL_IP}' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';"
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" "${MYSQL_DB}" -e "grant all on ${MYSQL_DB}.* to \"${MYSQL_USER}\"@\"172.17.%\" identified by \"${MYSQL_USER_PASSWORD}\";FLUSH PRIVILEGES;"
fi

# adjust redmine database.yml
sed -i "s/\"\"/${MYSQL_USER_PASSWORD}/g" /usr/src/redmine/config/database.yml


# start redmine
rails server -b 0.0.0.0
