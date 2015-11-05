#!/bin/bash
source /etc/ces/functions.sh

# create environment for templates
FQDN=$(get_fqdn)

# render template
render_template "/config.xml.tpl" > "/var/lib/jenkins/config.xml"

# Checking if /var/lib/jenkins/cas-plugin exists
if [ ! -f /var/lib/jenkins/plugins/cas-plugin.hpi ]; then
	# Making directory, if not already existing
	mkdir -p /var/lib/jenkins/plugins
	# Copy plugin
        cp /cas-plugin.hpi /var/lib/jenkins/plugins/
fi

# starting jenkins
java -Djava.awt.headless=true \
  -Djava.net.preferIPv4Stack=true \
  -Djavax.net.ssl.trustStore=/etc/ces/ssl/truststore.jks \
  -Djavax.net.ssl.trustStorePassword=changeit \
  -jar /jenkins.war --prefix=/jenkins
