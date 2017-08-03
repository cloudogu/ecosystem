#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

source /etc/ces/functions.sh

# get variables for templates
FQDN=$(doguctl config --global fqdn)
DOMAIN=$(doguctl config --global domain)
ADMIN_GROUP=$(doguctl config --global 'admin_group')
RELAYHOST="postfix"

# database connection
DATABASE_TYPE=postgresql
DATABASE_IP=postgresql
DATABASE_USER=$(doguctl config -e sa-postgresql/username)
DATABASE_USER_PASSWORD=$(doguctl config -e sa-postgresql/password)
DATABASE_DB=$(doguctl config -e sa-postgresql/database)

# redmine environment
RAILS_ENV=production
REDMINE_LANG=en

# plugin locations
PLUGIN_STORE="/var/tmp/redmine/plugins"
PLUGIN_DIRECTORY="${WORKDIR}/plugins"

function sql(){
  PGPASSWORD="${DATABASE_USER_PASSWORD}" psql --host "${DATABASE_IP}" --username "${DATABASE_USER}" --dbname "${DATABASE_DB}" -1 -c "${1}"
}

function exec_rake() {
  RAILS_ENV="${RAILS_ENV}" REDMINE_LANG="${REDMINE_LANG}" rake --trace -f ${WORKDIR}/Rakefile $*
}

function install_plugins(){
  echo "installing plugins"
  for PLUGIN_PACKAGE in $(ls "${PLUGIN_STORE}"); do
    install_plugin "${PLUGIN_PACKAGE}"
  done

  # Install Plugins
  echo "running plugin migrations..."
  exec_rake redmine:plugins:migrate
  echo "plugin migrations... done"
}

# installs or upgrades the given plugin
function install_plugin(){
  PACKAGE="${1}"
  NAME=$(echo "${PACKAGE}" | awk -F'-' '{print $1}')
  VERSION=$(echo "${PACKAGE}" | awk -F'-' '{print $NF}' | sed -e 's/\.tar\.gz//g')
  DIRECTORY="${PLUGIN_DIRECTORY}/${NAME}"

  echo "install plugin ${NAME} in version ${VERSION}"
  if [ -d "${DIRECTORY}" ]; then
    rm -rf "${DIRECTORY}"  
  fi

  tar xvfz "${PLUGIN_STORE}/${PACKAGE}" -C "${PLUGIN_DIRECTORY}" > /dev/null 2>&1
}

# adjust redmine database.yml
render_template "${WORKDIR}/config/database.yml.tpl" > "${WORKDIR}/config/database.yml"

# insert secret_key_base into secrets.yml
SECRETKEYBASE=$(grep secret_key_base ${WORKDIR}/config/initializers/secret_token.rb | awk -F \' '{print $2}' )
render_template "${WORKDIR}/config/secrets.yml.tpl" > "${WORKDIR}/config/secrets.yml"

# export variables for auth_source_cas.rb
export FQDN
export ADMIN_GROUP

# wait until postgresql passes all health checks
echo "wait until postgresql passes all health checks"
if ! doguctl healthy --wait --timeout 120 postgresql; then
  echo "timeout reached by waiting of postgresql to get healthy"
  exit 1
fi

# wait some more time for PostgreSQL so the next check wont fail
# TODO: check why the if statement below sometimes fails if there is no sleep
sleep 10

# Check if Redmine has been installed already
if 2>/dev/null 1>&2 sql "select count(*) from settings;"; then
  echo "Redmine (database) has been installed already."
  # update FQDN in settings
  sql "UPDATE settings SET value=E'--- !ruby/hash:ActionController::Parameters \nenabled: 1 \ncas_url: https://${FQDN}/cas \nattributes_mapping: firstname=givenName&lastname=surname&mail=mail \nautocreate_users: 1' WHERE name='plugin_redmine_cas';" > /dev/null 2>&1
else

  # Create the database structure
  echo "Creating database structure..."
  exec_rake db:migrate

  # insert default configuration data into database
  echo "Inserting default configuration data into database..."
  exec_rake redmine:load_default_data

  echo "Writing cas plugin settings to database..."
  sql "INSERT INTO settings (name, value, updated_on) VALUES ('plugin_redmine_cas', E'--- !ruby/hash:ActionController::Parameters \nenabled: 1 \ncas_url: https://${FQDN}/cas \nattributes_mapping: firstname=givenName&lastname=surname&mail=mail \nautocreate_users: 1', now());"
  sql "INSERT INTO settings (name, value, updated_on) VALUES ('login_required', 1, now());"

  # Enabling REST API
  sql "INSERT INTO settings (name, value, updated_on) VALUES ('rest_api_enabled', 1, now());"

  # Insert auth_sources record for AuthSourceCas authentication source
  sql "INSERT INTO auth_sources VALUES (DEFAULT, 'AuthSourceCas', 'Cas', 'cas.example.com', 1234, 'myDbUser', 'myDbPass', 'dbAdapter:dbName', 'name', 'firstName', 'lastName', 'email', true, false, null, null);"

  # Write base url to database
  sql "INSERT INTO settings (name, value, updated_on) VALUES ('host_name','https://${FQDN}/redmine/', now());"

  # set theme to cloudogu, do this only on installation not on a upgrade
  # because the user should be able to change the theme
  sql "INSERT INTO settings (name, value, updated_on) VALUES ('ui_theme','Cloudogu', now());"

  # set default email address
  sql "INSERT INTO settings (name, value, updated_on) VALUES ('mail_from','redmine@${DOMAIN}', now());"

  # Remove default admin account
  sql "DELETE FROM users WHERE login='admin';"

fi

# Install base plugins for cloudogu
install_plugins

# Create links
if [ ! -e ${WORKDIR}/public/redmine ]; then
  ln -s ${WORKDIR} ${WORKDIR}/public/
fi
if [ ! -e ${WORKDIR}/stylesheets ]; then
  ln -s ${WORKDIR}/public/* ${WORKDIR}
fi

# Generate configuration.yml from template (e.g. for config of mail transport)
render_template "${WORKDIR}/config/configuration.yml.tpl" > "${WORKDIR}/config/configuration.yml"

# remove old pid
RPID="${WORKDIR}/tmp/pids/server.pid"
if [ -f "${RPID}" ]; then
  rm -f "${RPID}"
fi

# Start redmine
echo "Starting redmine..."
exec bundle exec ruby bin/rails server webrick -e production -b 0.0.0.0
