#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

INIT_SCRIPT_FOLDER="/var/lib/jenkins/init.groovy.d"
# TODO rename resources to jenkins
MAIN_INIT_SCRIPTS_FOLDER="/var/tmp/resources/init.groovy.d"
CUSTOM_INIT_SCRIPTS_FOLDER="/var/lib/custom.init.groovy.d"

# set state to installing
doguctl state 'installing'

# create truststore for java processes
TRUSTSTORE="/var/lib/jenkins/truststore.jks"
create_truststore.sh /var/lib/jenkins/truststore.jks > /dev/null

# create ca store for git, mercurial and subversion
create-ca-certificates.sh /var/lib/jenkins/ca-certificates.crt

# copy init scripts

# remove old folder to be sure, 
# that it contains no script which is already removed from custom init script folder
if [ -d "${INIT_SCRIPT_FOLDER}" ]; then
  rm -rf "${INIT_SCRIPT_FOLDER}"
fi

# copy fresh main init scripts
cp -rf "${MAIN_INIT_SCRIPTS_FOLDER}" "${INIT_SCRIPT_FOLDER}"

# merge custom init scripts, if the volume is not empty
if [ "$(ls -A ${CUSTOM_INIT_SCRIPTS_FOLDER})" ]; then
  cp "${CUSTOM_INIT_SCRIPTS_FOLDER}"/* "${INIT_SCRIPT_FOLDER}"
fi

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

# Disable CLI over Remoting as advised with Jenkins LTS 2.46.2
# see https://jenkins.io/blog/2017/04/26/security-advisory/
CLI_CONFIG_FILE="/var/lib/jenkins/jenkins.CLI.xml"
if [ ! -f "${CLI_CONFIG_FILE}" ]; then
	cp /var/tmp/resources/jenkins.CLI.xml "${CLI_CONFIG_FILE}"
	chmod 0644 "${CLI_CONFIG_FILE}"
fi

# starting jenkins
java -Djava.awt.headless=true \
  -Djava.net.preferIPv4Stack=true \
  -Djavax.net.ssl.trustStore="${TRUSTSTORE}" \
  -Djavax.net.ssl.trustStorePassword=changeit \
  -Djenkins.install.runSetupWizard=false \
  -Djava.awt.headless=true \
  -jar /jenkins.war --prefix=/jenkins
