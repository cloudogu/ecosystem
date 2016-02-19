#!/bin/bash
source /etc/ces/functions.sh

# install redmine database
#MYSQL_ROOT_PASSWORD=$(create_or_get_ces_pass mysql_root)

# wait for mysql database to initialize
#TODO: do not sleep, but check if mysql is available instead
#sleep 30

# get variables for templates
FQDN=$(get_fqdn)
MYSQL_IP=mysql
MYSQL_ADMIN="root"
MYSQL_ADMIN_PASSWORD=$(get_ces_pass mysql_root)
MYSQL_USER="redmine"
MYSQL_USER_PASSWORD=$(create_or_get_ces_pass mysql_redmine)
MYSQL_DB="redmine"
WORKDIR=/usr/share/webapps/redmine
RAILS_ENV=production
REDMINE_LANG=en

# prepare database
if [ $(mysql -N -s -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "select count(*) from information_schema.schemata where schema_name='${MYSQL_DB}';") -eq 1 ]; then
  echo "redmine database is already installed"
else
  echo "install redmine database"
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "CREATE DATABASE ${MYSQL_DB} CHARACTER SET utf8;"
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "CREATE USER '${MYSQL_USER}'@'${MYSQL_IP}' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';"
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "GRANT ALL ON ${MYSQL_DB}.* TO \"${MYSQL_USER}\"@\"redmine\" identified by \"${MYSQL_USER_PASSWORD}\"; FLUSH PRIVILEGES;" #  "${MYSQL_DB}" -e
fi

#echo "copy unicorn config file..."
#cp /etc/unicorn/redmine.conf.rb.sample /etc/unicorn/redmine.conf.rb
#echo "edit unicorn conf.d file..."
#sed -i s#\"\"#/etc/unicorn/redmine.conf.rb#g /etc/conf.d/unicorn
echo "cd $WORKDIR..."
cd $WORKDIR
echo "chown -R redmine:root $WORKDIR..."
chown -R redmine:root $WORKDIR
echo "chown -R redmine:root /var/lib/redmine/..."
chown -R redmine:root /var/lib/redmine/
echo "chown -R redmine:root /usr/src/redmine/..."
chown -R redmine:root /usr/src/redmine/

#echo "su - redmine -c touch /var/lib/redmine/secret_token.rb..."
#su - redmine -c "touch /var/lib/redmine/secret_token.rb"
echo "su - redmine -c mkdir -p /var/lib/redmine/db/ && touch /var/lib/redmine/db/schema.rb..."
su - redmine -c "mkdir -p /var/lib/redmine/db/ && touch /var/lib/redmine/db/schema.rb"


echo "su - redmine -c rake generate_secret_token --trace..."
su - redmine -c "rake generate_secret_token --trace"
echo "su - redmine -c RAILS_ENV=$RAILS_ENV rake db:migrate --trace..."
su - redmine -c "RAILS_ENV=$RAILS_ENV rake db:migrate --trace"
echo "su - redmine -c RAILS_ENV=$RAILS_ENV rake redmine:load_default_data"
su - redmine -c "RAILS_ENV=$RAILS_ENV rake redmine:load_default_data"

# adjust redmine database.yml
echo "adjusting redmine database.yml"
su - redmine -c 'sed -i s/\"\"/${MYSQL_USER_PASSWORD}/g /usr/src/redmine/config/database.yml'

#echo "installing io-console"
#gem install io-console

# generate secret session token
#echo "generating secret session token"
#bundle exec rake generate_secret_token
#rake generate_secret_token --trace

# insert secret_key_base into secrets.yml
echo "inserting secret_key_base into secrets.yml"
sed -i s/X/$(grep secret_key_base /usr/src/redmine/config/initializers/secret_token.rb | awk -F \' '{print $2}' )/g /usr/src/redmine/config/secrets.yml

# Create the database structure
#echo "creating database structure..."
#RAILS_ENV=production bundle exec rake db:migrate

# Insert default configuration data in database
# Adjust to your language at REDMINE_LANG parameter
#echo "inserting default configuration data into database"
#RAILS_ENV=production REDMINE_LANG=en bundle exec rake redmine:load_default_data



# set links
# if [ ! -e /usr/src/redmine/public/redmine ]
#   then
#   ln -s /usr/src/redmine/ /usr/src/redmine/public/
# fi
# if [ ! -e /usr/src/redmine/javascripts ]
#   then
#   ln -s /usr/src/redmine/public/* /usr/src/redmine/
# fi

# if [ ! -e /usr/src/redmine/javascripts ]
#   then
#   ln -s /usr/src/redmine/public/javascripts /usr/src/redmine/
# fi
# if [ ! -e /usr/src/redmine/stylesheets ]
#   then
#   ln -s /usr/src/redmine/public/stylesheets /usr/src/redmine/
# fi

# start redmine
echo "starting redmine..."
bundle exec ruby bin/rails server webrick -e production -b 0.0.0.0
#rails server -b 0.0.0.0
#/etc/init.d/unicorn start

#TODO: remove this! just for debug purposes!
while true; do sleep 10; echo "delete while(true) loop from startup.sh!"; done
