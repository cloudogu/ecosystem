#!/bin/bash
source /etc/ces/functions.sh

# general variables for templates
DOMAIN=$(get_domain)
FQDN=$(get_fqdn)
LDAP_HOST='ldap'
LDAP_PORT=389
LDAP_BASE_DN="ou=People,o=${DOMAIN},dc=cloudogu,dc=com"
LDAP_BIND_DN="cn=admin,dc=cloudogu,dc=com"
LDAP_BIND_PASSWORD=$(get_ces_pass ldap_root | sed 's@/@\\\\/@g')

# render templates
sed "s@%DOMAIN%@$DOMAIN@g;\
s@%FQDN%@$FQDN@g;\
s@%LDAP_HOST%@$LDAP_HOST@g;\
s@%LDAP_PORT%@$LDAP_PORT@g;\
s@%LDAP_BASE_DN%@$LDAP_BASE_DN@g;\
s@%LDAP_BIND_DN%@$LDAP_BIND_DN@g;\
s@%LDAP_BIND_PASSWORD%@$LDAP_BIND_PASSWORD@g"\
 /resources/cas.properties.tpl > /opt/apache-tomcat/webapps/cas/WEB-INF/cas.properties

# startup tomcat
exec su - cas -c "export JAVA_HOME="/opt/jdk" && ${CATALINA_SH} run"
