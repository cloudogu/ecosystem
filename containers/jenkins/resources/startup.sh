#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# set state to installing
doguctl state 'installing'

function copy_cas_plugin() {
  # Checking if /var/lib/jenkins/cas-plugin exists
  if [ ! -f /var/lib/jenkins/plugins/cas-plugin.hpi ]; then
  	# Making directory, if not already existing
  	mkdir -p /var/lib/jenkins/plugins
  	# Copy plugin
    cp /var/tmp/resources/cas-plugin.hpi /var/lib/jenkins/plugins/
  fi
}

function install_plugin() {
  PLUGIN="${1}.hpi"
  # Checking if /var/lib/jenkins/cas-plugin exists
  if [ ! -f "/var/lib/jenkins/plugins/${PLUGIN}" ]; then
  	# Making directory, if not already existing
  	mkdir -p /var/lib/jenkins/plugins
  	# Copy plugin
    curl -Lks "https://updates.jenkins-ci.org/latest/${PLUGIN}" -o "/var/lib/jenkins/plugins/${PLUGIN}"
  fi
}

# manually resolve cas plugin dependencies
# TODO find a better way as manually resolve transitive dependencies
install_plugin "structs"
install_plugin "junit"
install_plugin "display-url-api"
install_plugin "mailer"

# copy custom jenkins cas plugin
copy_cas_plugin

# create truststore for java processes
TRUSTSTORE="/var/lib/jenkins/truststore.jks"
create_truststore.sh /var/lib/jenkins/truststore.jks > /dev/null

# create ca store for git, mercurial and subversion
create-ca-certificates.sh /var/lib/jenkins/ca-certificates.crt

# copy init scripts
cp -rf /var/tmp/resources/init.groovy.d /var/lib/jenkins/

# set initial setting for slave-to-master-security
# see https://wiki.jenkins-ci.org/display/JENKINS/Slave+To+Master+Access+Control
SLAVE_TO_MASTER_SECURITY="/var/lib/jenkins/secrets/slave-to-master-security-kill-switch"
if [ ! -f "${SLAVE_TO_MASTER_SECURITY}" ]; then
  SECRETS_DIRECTORY=$(dirname "${SLAVE_TO_MASTER_SECURITY}")
  if [ ! -d "${SECRETS_DIRECTORY}" ]; then
    mkdir -p "${SECRETS_DIRECTORY}"
  fi
  echo 'false' > "${SLAVE_TO_MASTER_SECURITY}"
fi

# starting jenkins
java -Djava.awt.headless=true \
  -Djava.net.preferIPv4Stack=true \
  -Djavax.net.ssl.trustStore="${TRUSTSTORE}" \
  -Djavax.net.ssl.trustStorePassword=changeit \
  -Djenkins.install.runSetupWizard=false \
  -jar /jenkins.war --prefix=/jenkins
