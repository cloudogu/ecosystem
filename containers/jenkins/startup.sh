#!/bin/bash
source /etc/ces/functions.sh

# create environment for templates
FQDN=$(get_fqdn)
ADMINGROUP="$(get_config admin_group)"
RELAYHOST="postfix"

if [ ! -f ${JENKINS_HOME}/config.xml ]; then
	# render template
	render_template "/config.xml.tpl" > /var/lib/jenkins/config.xml
	render_template "/hudson.tasks.Mailer.xml.tpl" > "/var/lib/jenkins/hudson.tasks.Mailer.xml"
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

# generating ssh key for usage in slaves and deployment in etcd
if ! [ -f "/var/lib/jenkins/.ssh/id_rsa" ]; then
	echo "INFO - no keys found in jenkins home /var/lib/jenkins/.ssh/ - keys will be generated"
	ssh-keygen -t rsa -f /var/lib/jenkins/.ssh/id_rsa -N ''
fi
echo "INFO - writing key to ETCD"
set_config pubkey "$(cat /var/lib/jenkins/.ssh/id_rsa.pub)"

# create truststore
TRUSTSTORE="/var/lib/jenkins/truststore.jks"
create_truststore.sh "${TRUSTSTORE}" > /dev/null

# starting jenkins
java -Djava.awt.headless=true \
	-Dhudson.model.UpdateCenter.never=true \
  -Djava.net.preferIPv4Stack=true \
  -Djavax.net.ssl.trustStore="${TRUSTSTORE}" \
	-Djavax.net.ssl.trustStorePassword=changeit \
  -jar /jenkins.war --prefix=/jenkins
