#!/bin/bash
source /etc/ces/functions.sh

# install redmine database
#MYSQL_ROOT_PASSWORD=$(create_or_get_ces_pass mysql_root)

# wait for mysql database to initialize
#TODO: do not sleep, but check if mysql is available instead
sleep 30

# get variables for templates
FQDN=$(get_fqdn)
MYSQL_IP=mysql
MYSQL_ADMIN="root"
MYSQL_ADMIN_PASSWORD=$(get_ces_pass mysql_root)
MYSQL_USER="redmine"
MYSQL_USER_PASSWORD=$(create_or_get_ces_pass mysql_redmine)
MYSQL_DB="redmine"
# prepare database
if [ $(mysql -N -s -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "select count(*) from information_schema.schemata where schema_name='${MYSQL_DB}';") -eq 1 ]; then
  echo "redmine database is already installed"
else
  echo "install redmine database"
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "CREATE DATABASE ${MYSQL_DB} CHARACTER SET utf8;"
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "CREATE USER '${MYSQL_USER}'@'${MYSQL_IP}' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';"
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "GRANT ALL ON ${MYSQL_DB}.* TO \"${MYSQL_USER}\"@\"redmine\" identified by \"${MYSQL_USER_PASSWORD}\"; FLUSH PRIVILEGES;" #  "${MYSQL_DB}" -e
fi

# adjust redmine database.yml
sed -i s/\"\"/${MYSQL_USER_PASSWORD}/g /usr/src/redmine/config/database.yml

# generate secret session token
bundle exec rake generate_secret_token

# insert secret_key_base into secrets.yml
sed -i s/X/$(grep secret_key_base /usr/src/redmine/config/initializers/secret_token.rb | awk -F \' '{print $2}' )/g /usr/src/redmine/config/secrets.yml

# Create the database structure
echo "creating database structure..."
RAILS_ENV=production bundle exec rake db:migrate

# Insert default configuration data in database
# TODO: set correct language at REDMINE_LANG parameter
echo "inserting default configuration data into database"
RAILS_ENV=production REDMINE_LANG=en bundle exec rake redmine:load_default_data

if [ ! -e /usr/src/redmine/public/redmine ]
  then
  echo "Creating link to /usr/src/redmine/ in /usr/src/redmine/public/"
  ln -s /usr/src/redmine/ /usr/src/redmine/public/
fi

if [ ! -e /usr/src/redmine/javascripts ]
  then
  echo "Creating link to /usr/src/redmine/public/javascripts in /usr/src/redmine/"
  ln -s /usr/src/redmine/public/javascripts /usr/src/redmine/
fi

if [ ! -e /usr/src/redmine/stylesheets ]
  then
  echo "Creating link to /usr/src/redmine/public/stylesheets in /usr/src/redmine/"
  ln -s /usr/src/redmine/public/stylesheets /usr/src/redmine/
fi

# start redmine
rails server -b 0.0.0.0
