#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

source /etc/ces/functions.sh

# create environment for templates
FQDN=$(doguctl config --global fqdn)
DOMAIN=$(doguctl config --global domain)

LDAP_HOST=ldap
LDAP_PORT=389
LDAP_SERVICE=${LDAP_HOST}:${LDAP_PORT}
LDAP_BASE_DN="o=${DOMAIN},dc=cloudogu,dc=com"
LDAP_BIND_DN=$(doguctl config -e sa-ldap/username)
LDAP_BIND_PASSWORD=$(/opt/apache-tomcat/webapps/usermgt/WEB-INF/cipher.sh encrypt $(doguctl config -e sa-ldap/password) | tail -1)

# copy resources
if [ ! -d "/var/lib/usermgt/conf" ]; then
	mkdir -p /var/lib/usermgt/conf
	cp -rf /resources/* /var/lib/usermgt/conf/
fi

# create log directory
if [ ! -d "/var/lib/usermgt/logs" ]; then
	mkdir -p /var/lib/usermgt/logs
	chown -R tomcat:tomcat /var/lib/usermgt/logs
fi

# render templates
render_template "/var/lib/usermgt/conf/cas.xml.tpl" > "/var/lib/usermgt/conf/cas.xml"
render_template "/var/lib/usermgt/conf/ldap.xml.tpl" > "/var/lib/usermgt/conf/ldap.xml"

# create truststore, which is used in the setenv.sh
create_truststore.sh > /dev/null

# wait until ldap passed all health checks
echo "wait unit ldap passes all health checks"
if ! doguctl healthy --wait --timeout 120 ldap; then
  echo "timeout reached by waiting of ldap to get healthy"
  exit 1
fi

# start tomcat as user tomcat
su - tomcat -c "exec /opt/apache-tomcat/bin/catalina.sh run"
