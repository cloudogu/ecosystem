#!/bin/bash
#set -o errexit
#set -o nounset
set -o pipefail

source /etc/ces/functions.sh

# variables
ADMINGROUP=$(get_config admin_group)
DOMAIN=$(get_config domain)
FQDN=$(get_fqdn)

# create truststore
TRUSTSTORE="/var/lib/nexus/truststore.jks"
create_truststore.sh "${TRUSTSTORE}" > /dev/null

START_NEXUS="java \
  -server -Djava.net.preferIPv4Stack=true -Xms256m -Xmx1g \
  -Djavax.net.ssl.trustStore=${TRUSTSTORE} \
	-Djavax.net.ssl.trustStorePassword=changeit \
  -Dnexus-work=/var/lib/nexus -Dnexus-webapp-context-path=/nexus \
  -cp conf/:`(echo lib/*.jar) | sed -e "s/ /:/g"` \
  org.sonatype.nexus.bootstrap.Launcher ./conf/jetty.xml ./conf/jetty-requestlog.xml"

# Copy files at first start
if ! [ -e /var/lib/nexus/conf/security-configuration.xml ]; then
  mkdir -p /var/lib/nexus/conf
  cp /opt/sonatype/nexus/resources/security-configuration.xml /var/lib/nexus/conf/security-configuration.xml
  cp /opt/sonatype/nexus/resources/lvo-plugin.xml /var/lib/nexus/conf/lvo-plugin.xml
fi

# Install cas-plugin
if ! [ -d /var/lib/nexus/plugin-repository/nexus-cas-plugin-${CAS_PLUGIN_VERSION} ]; then
  mkdir -p /var/lib/nexus/plugin-repository
  cp -a /opt/sonatype/nexus/resources/nexus-cas-plugin-${CAS_PLUGIN_VERSION}/ /var/lib/nexus/plugin-repository/
fi

FQDN=$(get_fqdn)
echo "render_template"
# update cas url
render_template "/opt/sonatype/nexus/resources/cas-plugin.xml.tpl" > "/var/lib/nexus/conf/cas-plugin.xml"
render_template "/opt/sonatype/nexus/resources/nexus.xml.tpl" > "/var/lib/nexus/conf/nexus.xml"
render_template "/opt/sonatype/nexus/resources/security.xml.tpl" > "/var/lib/nexus/conf/security.xml"
sed -i.bak 's/version=1.0 encoding=UTF-8/version="1.0" encoding="UTF-8"/g' /var/lib/nexus/conf/nexus.xml
sed -i.bak 's/version=1.0 encoding=UTF-8/version="1.0" encoding="UTF-8"/g' /var/lib/nexus/conf/security.xml
exec $START_NEXUS
