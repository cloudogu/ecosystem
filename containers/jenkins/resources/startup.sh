#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# set state to installing
doguctl state 'installing'

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
  -jar /jenkins.war --prefix=/jenkins
