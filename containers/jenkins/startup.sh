#!/bin/bash
source /etc/ces/functions.sh

# create environment for templates
FQDN=$(get_fqdn)
ADMINGROUP="$(get_config admin_group)"

if [ ! -f ${JENKINS_HOME}/config.xml ]; then
	# render template
	render_template "/config.xml.tpl" > /var/lib/jenkins/config.xml
else
	# refresh cas IP
	sed -i "s~<casServerUrl>.*</casServerUrl>~<casServerUrl>https://${FQDN}/cas/</casServerUrl>~" /var/lib/jenkins/config.xml
fi

# Checking if /var/lib/jenkins/cas-plugin exists
if [ ! -f /var/lib/jenkins/plugins/cas-plugin.hpi ]; then
	# Making directory, if not already existing
	mkdir -p /var/lib/jenkins/plugins
	# Copy plugin
        cp /cas-plugin.hpi /var/lib/jenkins/plugins/
fi

# starting jenkins
java -Djava.awt.headless=true \
	-Dhudson.model.UpdateCenter.never=true \
  -Djava.net.preferIPv4Stack=true \
  -Djavax.net.ssl.trustStore=/etc/ces/ssl/truststore.jks \
  -Djavax.net.ssl.trustStorePassword=changeit \
  -jar /jenkins.war --prefix=/jenkins
