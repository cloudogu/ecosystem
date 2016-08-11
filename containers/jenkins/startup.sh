#!/bin/bash
source /etc/ces/functions.sh

# Checking if /var/lib/jenkins/cas-plugin exists
if [ ! -f /var/lib/jenkins/plugins/cas-plugin.hpi ]; then
	# Making directory, if not already existing
	mkdir -p /var/lib/jenkins/plugins
	# Copy plugin
  cp /var/tmp/cas-plugin.hpi /var/lib/jenkins/plugins/
fi

# create truststore
TRUSTSTORE="/var/lib/jenkins/truststore.jks"
create_truststore.sh "${TRUSTSTORE}" > /dev/null

# copy init scripts
cp -rf /var/tmp/resources/init.groovy.d /var/lib/jenkins/

# starting jenkins
java -Djava.awt.headless=true \
  -Djava.net.preferIPv4Stack=true \
  -Djavax.net.ssl.trustStore="${TRUSTSTORE}" \
	-Djavax.net.ssl.trustStorePassword=changeit \
	-Djenkins.install.runSetupWizard=false \
  -jar /jenkins.war --prefix=/jenkins
