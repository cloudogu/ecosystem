#!/bin/bash
source /etc/ces/functions.sh

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

#TODO: check if mysql is available already

# echo "su - redmine -c touch /var/lib/redmine/secret_token.rb..."
# chown redmine:root /var/lib/redmine
# chmod 755 /var/lib/redmine
# su - redmine -c "touch /var/lib/redmine/secret_token.rb"

# generate secret session token
#echo "generating secret session token"
echo "su - redmine -c rake generate_secret_token --trace..."
su - redmine -c "rake generate_secret_token --trace"

# adjust redmine database.yml
echo "adjusting redmine database.yml..."
sed -i s~\"\"~${MYSQL_USER_PASSWORD}~g $WORKDIR/config/database.yml

# insert secret_key_base into secrets.yml
echo "inserting secret_key_base into secrets.yml..."
sed -i s/X/$(grep secret_key_base $WORKDIR/config/initializers/secret_token.rb | awk -F \' '{print $2}' )/g $WORKDIR/config/secrets.yml

# prepare database
if [ $(mysql -N -s -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "select count(*) from information_schema.schemata where schema_name='${MYSQL_DB}';") -eq 1 ]; then
  echo "redmine database is already installed"
else
  echo "installing redmine database..."
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "CREATE DATABASE ${MYSQL_DB} CHARACTER SET utf8;"
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "CREATE USER '${MYSQL_USER}'@'${MYSQL_IP}' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';"
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "GRANT ALL ON ${MYSQL_DB}.* TO \"${MYSQL_USER}\"@\"%\" identified by \"${MYSQL_USER_PASSWORD}\"; FLUSH PRIVILEGES;" #  "${MYSQL_DB}" -e
fi

echo "cd $WORKDIR..."
cd $WORKDIR
echo "chown -R redmine:root $WORKDIR..."
chown -R redmine:root $WORKDIR
echo "chown -R redmine:root /var/lib/redmine/..."
chown -R redmine:root /var/lib/redmine/


# echo "su - redmine -c mkdir -p /var/lib/redmine/db/ && touch /var/lib/redmine/db/schema.rb..."
# su - redmine -c "mkdir -p /var/lib/redmine/db/ && touch /var/lib/redmine/db/schema.rb"

# Create the database structure
#echo "creating database structure..."
echo "su - redmine -c RAILS_ENV=$RAILS_ENV rake db:migrate --trace..."
su - redmine -c "RAILS_ENV=$RAILS_ENV rake db:migrate --trace"

# Insert default configuration data in database
# Adjust to your language at REDMINE_LANG parameter
echo "su - redmine -c RAILS_ENV=$RAILS_ENV REDMINE_LANG=$REDMINE_LANG rake redmine:load_default_data --trace"
su - redmine -c "RAILS_ENV=$RAILS_ENV REDMINE_LANG="$REDMINE_LANG" rake redmine:load_default_data --trace"


# start redmine
echo "starting redmine..."
bundle exec ruby bin/rails server webrick -e production -b 0.0.0.0
#rails server -b 0.0.0.0
#/etc/init.d/unicorn start

#TODO: remove this! just for debug purposes!
while true; do sleep 10; echo "delete while(true) loop from startup.sh!"; done
