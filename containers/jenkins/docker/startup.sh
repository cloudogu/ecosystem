#!/bin/bash

echo "Checking if /var/lib/jenkins/cas-plugin exists..."
if [ ! -f /var/lib/jenkins/plugins/cas-plugin.hpi ]; then
	echo "Making directory, if not already existing"
	mkdir -p /var/lib/jenkins/plugins
        echo "Copying /cas-plugin.hpi to /var/lib/jenkins/plugins"
        cp /cas-plugin.hpi /var/lib/jenkins/plugins/
fi
#echo "startup script is done."
echo "Starting jenkins now..."



java -Djava.awt.headless=true \
  -Djava.net.preferIPv4Stack=true \
  -Djavax.net.ssl.trustStore=/etc/ces/ssl/truststore.jks \
  -Djavax.net.ssl.trustStorePassword=changeit \
  -jar /jenkins.war --prefix=/jenkins

#sleep 100

#if [ ! -d /var/lib/jenkins/plugins ]; then
#        echo "Directory /var/lib/jenkins/plugins does not exist."
#	mkdir -p /var/lib/jenkins/plugins
#fi

#echo "Checking if /var/lib/jenkins/cas-plugin exists..."
#if [ ! -f /var/lib/jenkins/plugins/cas-plugin.hpi ]; then
#        echo "Copying /cas-plugin.hpi to /var/lib/jenkins/plugins"
#        cp /cas-plugin.hpi /var/lib/jenkins/plugins/
#fi
#echo "startup script is done."
