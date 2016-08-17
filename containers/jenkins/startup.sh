#!/bin/bash
source /etc/ces/functions.sh

### functions

function copy_cas_plugin() {
  # Checking if /var/lib/jenkins/cas-plugin exists
  if [ ! -f /var/lib/jenkins/plugins/cas-plugin.hpi ]; then
  	# Making directory, if not already existing
  	mkdir -p /var/lib/jenkins/plugins
  	# Copy plugin
    cp /var/tmp/cas-plugin.hpi /var/lib/jenkins/plugins/
  fi
}

### functions end

# copy custom jenkins cas plugin
copy_cas_plugin

# create truststore for java processes
TRUSTSTORE="/var/lib/jenkins/truststore.jks"
create_truststore.sh /var/lib/jenkins/truststore.jks > /dev/null

# create ca store for git, mercurial and subversion
create-ca-certificates.sh /var/lib/jenkins/ca-certificates.crt

# copy init scripts
cp -rf /var/tmp/resources/init.groovy.d /var/lib/jenkins/

# starting jenkins
java -Djava.awt.headless=true \
  -Djava.net.preferIPv4Stack=true \
  -Djavax.net.ssl.trustStore="${TRUSTSTORE}" \
  -Djavax.net.ssl.trustStorePassword=changeit \
  -jar /jenkins.war --prefix=/jenkins
