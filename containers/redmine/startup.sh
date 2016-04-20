#!/bin/bash -e
source /etc/ces/functions.sh

# get variables for templates
FQDN=$(get_fqdn)
MYSQL_IP=mysql
MYSQL_ADMIN="root"
MYSQL_ADMIN_PASSWORD=$(get_ces_pass mysql_root)
MYSQL_USER="redmine"
MYSQL_USER_PASSWORD=$(create_or_get_ces_pass mysql_redmine)
MYSQL_DB="redmine"
RAILS_ENV=production
REDMINE_LANG=en
DOMAIN=$(get_config domain)
RELAYHOST="postfix"

# Generate secret session token
cd ${WORKDIR}
su - redmine -c "rake generate_secret_token --trace"
# adjust redmine database.yml
render_template "${WORKDIR}/config/database.yml.tpl" > "${WORKDIR}/config/database.yml"
# insert secret_key_base into secrets.yml
SECRETKEYBASE=$(grep secret_key_base ${WORKDIR}/config/initializers/secret_token.rb | awk -F \' '{print $2}' )
render_template "${WORKDIR}/config/secrets.yml.tpl" > "${WORKDIR}/config/secrets.yml"
# insert fqdn into cas auth source template
render_template "${WORKDIR}/app/models/auth_source_cas.rb.tpl" > ${WORKDIR}/app/models/auth_source_cas.rb

# Check if Redmine has been installed already
if [ $(mysql -N -s -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "select count(*) from information_schema.schemata where schema_name='${MYSQL_DB}';") -eq 1 ]; then
  echo "Redmine (database) has been installed already."
else
  echo "Creating redmine database..."
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "CREATE DATABASE ${MYSQL_DB} CHARACTER SET utf8;"
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "CREATE USER '${MYSQL_USER}'@'${MYSQL_IP}' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';"
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "GRANT ALL ON ${MYSQL_DB}.* TO \"${MYSQL_USER}\"@\"%\" identified by \"${MYSQL_USER_PASSWORD}\"; FLUSH PRIVILEGES;"

  # Create the database structure
  echo "Creating database structure..."
  su - redmine -c "RAILS_ENV=$RAILS_ENV rake db:migrate --trace"

  # Insert default configuration data into database
  # Adjust to your language at REDMINE_LANG parameter above
  echo "Inserting default configuration data into database..."
  su - redmine -c "RAILS_ENV=$RAILS_ENV REDMINE_LANG="$REDMINE_LANG" rake redmine:load_default_data --trace"
  # remove default admin user
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "DELETE FROM ${MYSQL_DB}.users WHERE firstname=\"Redmine\" AND lastname=\"Admin\";"

  echo "Writing cas plugin settings to database..."
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "INSERT INTO ${MYSQL_DB}.settings VALUES (NULL,\"plugin_redmine_cas\",\"--- !ruby/hash:ActionController::Parameters \nenabled: 1 \ncas_url: https://${FQDN}/cas \nattributes_mapping: firstname=givenName&lastname=surname&mail=mail \nautocreate_users: 1\",4);"
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "INSERT INTO ${MYSQL_DB}.settings VALUES (NULL,\"login_required\",1,4);"

  # Enabling REST API
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "INSERT INTO ${MYSQL_DB}.settings VALUES (NULL,\"rest_api_enabled\",1,4);"

  # Insert auth_sources record for AuthSourceCas authentication source
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "INSERT INTO ${MYSQL_DB}.auth_sources VALUES (NULL, 'AuthSourceCas', 'Cas', 'cas.example.com', 1234, 'myDbUser', 'myDbPass', 'dbAdapter:dbName', 'name', 'firstName', 'lastName', 'email', 1, 0, null, null);"

  echo "Writing base url to database..."
  mysql -h "${MYSQL_IP}" -u "${MYSQL_ADMIN}" "-p${MYSQL_ADMIN_PASSWORD}" -e "INSERT INTO ${MYSQL_DB}.settings VALUES (NULL,\"host_name\",\"https://$FQDN/redmine/\",4);"
fi

# Create links
if [ ! -e ${WORKDIR}/public/redmine ]; then
  ln -s ${WORKDIR} ${WORKDIR}/public/
fi
if [ ! -e ${WORKDIR}/stylesheets ]; then
  ln -s ${WORKDIR}/public/* ${WORKDIR}
fi

# Generate configuration.yml from template (e.g. for config of mail transport)
render_template "${WORKDIR}/config/configuration.yml.tpl" > "/etc/redmine/configuration.yml"

# Start redmine
echo "Starting redmine..."
exec bundle exec ruby bin/rails server webrick -e production -b 0.0.0.0
