#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

source /etc/ces/functions.sh

# get variables for templates
FQDN=$(doguctl config --global fqdn)
DATABASE_TYPE=postgresql
DATABASE_IP=postgresql
DATABASE_USER=$(doguctl config -e sa-postgresql/username)
DATABASE_USER_PASSWORD=$(doguctl config -e sa-postgresql/password)
DATABASE_DB=$(doguctl config -e sa-postgresql/database)
RAILS_ENV=production
REDMINE_LANG=en
DOMAIN=$(doguctl config --global domain)
RELAYHOST="postfix"

function sql(){
  PGPASSWORD="${DATABASE_USER_PASSWORD}" psql --host "${DATABASE_IP}" --username "${DATABASE_USER}" --dbname "${DATABASE_DB}" -1 -c "${1}"
  return $?
}

# adjust redmine database.yml
render_template "${WORKDIR}/config/database.yml.tpl" > "${WORKDIR}/config/database.yml"
# Install Redmine Gemfile
bundle install --gemfile=${WORKDIR}/Gemfile
# insert secret_key_base into secrets.yml
SECRETKEYBASE=$(grep secret_key_base ${WORKDIR}/config/initializers/secret_token.rb | awk -F \' '{print $2}' )
render_template "${WORKDIR}/config/secrets.yml.tpl" > "${WORKDIR}/config/secrets.yml"
# insert fqdn into cas auth source template
render_template "${WORKDIR}/app/models/auth_source_cas.rb.tpl" > ${WORKDIR}/app/models/auth_source_cas.rb

# Check if Redmine has been installed already
if 2>/dev/null 1>&2 sql "select count(*) from settings;"; then
  echo "Redmine (database) has been installed already."
  # update FQDN in settings
  sql "UPDATE settings SET value=E'--- !ruby/hash:ActionController::Parameters \nenabled: 1 \ncas_url: https://${FQDN}/cas \nattributes_mapping: firstname=givenName&lastname=surname&mail=mail \nautocreate_users: 1' WHERE name='plugin_redmine_cas';"
else

  # Create the database structure
  echo "Creating database structure..."
  RAILS_ENV=$RAILS_ENV rake db:migrate --trace -f ${WORKDIR}/Rakefile

  # Insert default configuration data into database
  # Adjust to your language at REDMINE_LANG parameter above
  echo "Inserting default configuration data into database..."
  RAILS_ENV=$RAILS_ENV REDMINE_LANG="$REDMINE_LANG" rake redmine:load_default_data --trace -f ${WORKDIR}/Rakefile

  echo "Writing cas plugin settings to database..."
  sql "INSERT INTO settings (name, value, updated_on) VALUES ('plugin_redmine_cas', E'--- !ruby/hash:ActionController::Parameters \nenabled: 1 \ncas_url: https://${FQDN}/cas \nattributes_mapping: firstname=givenName&lastname=surname&mail=mail \nautocreate_users: 1', now());"
  sql "INSERT INTO settings (name, value, updated_on) VALUES ('login_required', 1, now());"

  # Enabling REST API
  sql "INSERT INTO settings (name, value, updated_on) VALUES ('rest_api_enabled', 1, now());"

  # Insert auth_sources record for AuthSourceCas authentication source
  sql "INSERT INTO auth_sources VALUES (DEFAULT, 'AuthSourceCas', 'Cas', 'cas.example.com', 1234, 'myDbUser', 'myDbPass', 'dbAdapter:dbName', 'name', 'firstName', 'lastName', 'email', true, false, null, null);"

  # Write base url to database
  sql "INSERT INTO settings (name, value, updated_on) VALUES ('host_name','https://$FQDN/redmine/', now());"

  # set theme to cloudogu, do this only on installation not on a upgrade
  # because the user should be able to change the theme
  sql "INSERT INTO settings (name, value, updated_on) VALUES ('ui_theme','Cloudogu', now());"

  # Remove default admin account
  sql "DELETE FROM users WHERE login='admin';"

  # Install Redmine CAS plugin
  echo "installing CAS plugin"
  curl -L -o casplugin${RMCASPLUGINVERSION}.tar.gz https://github.com/cloudogu/redmine_cas/archive/${RMCASPLUGINVERSION}.tar.gz \
    && tar -xzf casplugin${RMCASPLUGINVERSION}.tar.gz \
    && mv redmine_cas-${RMCASPLUGINVERSION} ${WORKDIR}/plugins/redmine_cas \
    && rm casplugin${RMCASPLUGINVERSION}.tar.gz
  
  # Install redmine_activerecord_session_store plugin to make Single Sign-Out work
  echo "installing redmine_activerecord_session_store plugin"
  curl -L -o redmine_AR_session_store.tar.gz https://github.com/pencil/redmine_activerecord_session_store/archive/v0.0.1.tar.gz \
    && tar -xzf redmine_AR_session_store.tar.gz \
    && mv redmine_activerecord_session_store-0.0.1 ${WORKDIR}/plugins/redmine_activerecord_session_store \
    && rm redmine_AR_session_store.tar.gz

  echo "Running plugins migrations..."
  rake redmine:plugins:migrate RAILS_ENV=$RAILS_ENV -f ${WORKDIR}/Rakefile
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

# remove old pid
RPID="${WORKDIR}/tmp/pids/server.pid"
if [ -f "${RPID}" ]; then
  rm -f "${RPID}"
fi

# unzip theme
mkdir -p /usr/share/webapps/redmine/public/themes/Cloudogu
unzip -o /usr/share/webapps/redmine/public/themes/Cloudogu.zip -d /usr/share/webapps/redmine/public/themes/Cloudogu

# Start redmine
echo "Starting redmine..."
exec bundle exec ruby bin/rails server webrick -e production -b 0.0.0.0
