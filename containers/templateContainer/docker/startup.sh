#This script to prepare
#the environment of the application, e.g. preparing database settings,
#customizing application specific settings.
#More specifically it is for starting your container, it is part 
#of your docker file and will be executed every time
#your container is created.

#!/bin/bash
source /etc/ces/functions.sh

# general variables for templates
DOMAIN=$(get_domain)
FQDN=$(get_fqdn)
MYSQL_IP=mysql
MYSQL_ADMIN="root"
MYSQL_ADMIN_PASSWORD=$(get_ces_pass mysql_root)
MYSQL_USER="applicationMySqlUser"
MYSQL_USER_PASSWORD=$(create_or_get_ces_pass mysql_cas)
MYSQL_DB="applicationschemaname"

# template specific variables
SERVERNAME=$(get_fqdn)

#copy resource folder to target
cp -rf /resources/* /

# prepare database
# you can add more sophisticated checks or preparements for your database respectively.
if [ $(mysql -N -s -h "${MYSQL_IP}" -u "${MYSQL_eADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '${MYSQL_DB}'") -eq 1 ]; then
  echo "applicationschemaname database is already installed"
else
  echo "install applicationschemaname database"
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "CREATE DATABASE ${MYSQL_DB} DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
  #granting on ip 172.17.* cause its docker container standard ip address space.
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" "${MYSQL_DB}" -e "grant all on ${MYSQL_DB}.* to \"${MYSQL_USER}\"@\"172.17.%\" identified by \"${MYSQL_USER_PASSWORD}\";FLUSH PRIVILEGES;"
fi

# render specific properties for the application
render_template "/opt/apache-tomcat/webapps/YOURAPPLICATION/WEB-INF/settings.properties.tpl" > "/opt/apache-tomcat/webapps/YOURAPPLICATION/WEB-INF/settings.properties"

#finally start our application by running the tomcat
su - cas -c "${CATALINA_SH} run"
