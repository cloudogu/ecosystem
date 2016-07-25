#!/bin/bash -e
source /etc/ces/functions.sh

# get variables for templates
FQDN=$(doguctl config --global fqdn)
MYSQL_IP=mysql
MYSQL_USER=$(doguctl config -e sa-mysql/username)
MYSQL_USER_PASSWORD=$(doguctl config -e sa-mysql/password)
MYSQL_DB=$(doguctl config -e sa-mysql/database)
RAILS_ENV=production
REDMINE_LANG=en
DOMAIN=$(doguctl config --global domain)
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
if [ $(mysql -N -s -h "${MYSQL_IP}" -u "${MYSQL_USER}" "-p${MYSQL_USER_PASSWORD}" -e "select count(*) from ${MYSQL_DB}.settings ;") -ge 1 ]; then
  echo "Redmine (database) has been installed already."
  # update FQDN in settings
  mysql -h "${MYSQL_IP}" -u "${MYSQL_USER}" "-p${MYSQL_USER_PASSWORD}" -e "UPDATE ${MYSQL_DB}.settings SET value=\"--- !ruby/hash:ActionController::Parameters \nenabled: 1 \ncas_url: https://${FQDN}/cas \nattributes_mapping: firstname=givenName&lastname=surname&mail=mail \nautocreate_users: 1\" WHERE name=\"plugin_redmine_cas\";"
else

  # Create the database structure
  echo "Creating database structure..."
  su - redmine -c "RAILS_ENV=$RAILS_ENV rake db:migrate --trace"

  # Insert default configuration data into database
  # Adjust to your language at REDMINE_LANG parameter above
  echo "Inserting default configuration data into database..."
  su - redmine -c "RAILS_ENV=$RAILS_ENV REDMINE_LANG="$REDMINE_LANG" rake redmine:load_default_data --trace"

  echo "Writing cas plugin settings to database..."
  mysql -h "${MYSQL_IP}" -u "${MYSQL_USER}" "-p${MYSQL_USER_PASSWORD}" -e "INSERT INTO ${MYSQL_DB}.settings VALUES (NULL,\"plugin_redmine_cas\",\"--- !ruby/hash:ActionController::Parameters \nenabled: 1 \ncas_url: https://${FQDN}/cas \nattributes_mapping: firstname=givenName&lastname=surname&mail=mail \nautocreate_users: 1\",4);"
  mysql -h "${MYSQL_IP}" -u "${MYSQL_USER}" "-p${MYSQL_USER_PASSWORD}" -e "INSERT INTO ${MYSQL_DB}.settings VALUES (NULL,\"login_required\",1,4);"

  # Enabling REST API
  mysql -h "${MYSQL_IP}" -u "${MYSQL_USER}" "-p${MYSQL_USER_PASSWORD}" -e "INSERT INTO ${MYSQL_DB}.settings VALUES (NULL,\"rest_api_enabled\",1,4);"

  # Insert auth_sources record for AuthSourceCas authentication source
  mysql -h "${MYSQL_IP}" -u "${MYSQL_USER}" "-p${MYSQL_USER_PASSWORD}" -e "INSERT INTO ${MYSQL_DB}.auth_sources VALUES (NULL, 'AuthSourceCas', 'Cas', 'cas.example.com', 1234, 'myDbUser', 'myDbPass', 'dbAdapter:dbName', 'name', 'firstName', 'lastName', 'email', 1, 0, null, null);"

  # Write base url to database
  mysql -h "${MYSQL_IP}" -u "${MYSQL_USER}" "-p${MYSQL_USER_PASSWORD}" -e "INSERT INTO ${MYSQL_DB}.settings VALUES (NULL,\"host_name\",\"https://$FQDN/redmine/\",4);"

  # Remove default admin account
  mysql -h "${MYSQL_IP}" -u "${MYSQL_USER}" "-p${MYSQL_USER_PASSWORD}" -e "DELETE FROM ${MYSQL_DB}.users WHERE login=\"admin\";"

  echo "Running plugins migrations..."
  su - redmine -c "rake redmine:plugins:migrate RAILS_ENV=$RAILS_ENV"
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
