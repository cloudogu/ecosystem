#!/bin/bash
source /etc/ces/functions.sh

# general variables for templates
DOMAIN=$(get_domain)
FQDN=$(get_fqdn)
MYSQL_IP=$(get_service mysql 3306 | awk -F':' '{print $1}')
MYSQL_ADMIN="root"
MYSQL_ADMIN_PASSWORD=$(get_ces_pass mysql_root)
MYSQL_USER="cas"
MYSQL_USER_PASSWORD=$(create_or_get_ces_pass mysql_cas)
MYSQL_DB="cas"

# template specific variables
SERVERNAME=$(get_fqdn)

#copy resource folder to target
cp -rf /resources/* /

# prepare database
if [ $(mysql -N -s -h "${MYSQL_IP}" -u "${MYSQL_eADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '${MYSQL_DB}'") -eq 1 ]; then
  echo "cas database is already installed"
else
  echo "install cas database"
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "CREATE DATABASE ${MYSQL_DB} DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
  #granting on ip 172.17.* cause its docker container standard ip address space.
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" "${MYSQL_DB}" -e "grant all on ${MYSQL_DB}.* to \"${MYSQL_USER}\"@\"172.17.%\" identified by \"${MYSQL_USER_PASSWORD}\";FLUSH PRIVILEGES;"
fi



# render templates
render_template "/opt/apache-tomcat/webapps/cas/WEB-INF/cas.properties.tpl" > "/opt/apache-tomcat/webapps/cas/WEB-INF/cas.properties"
