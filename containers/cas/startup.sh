#!/bin/bash
source /etc/ces/functions.sh

# general variables for templates
DOMAIN=$(get_domain)
FQDN=$(get_fqdn)
LDAP_TYPE=$(doguctl config --global ldap/ds_type)
LDAP_SERVER=$(doguctl config --global ldap/server)
LDAP_PORT=389
if [[ "$LDAP_TYPE" == 'external' ]]; then
  LDAP_HOST=$(doguctl config --global ldap/url)
  LDAP_BASE_DN=$(doguctl config --global ldap/base_dn)
  LDAP_BIND_DN=$(doguctl config --global ldap/connection_dn)
  LDAP_BIND_PASSWORD=$(doguctl config --global ldap/password | sed 's@/@\\\\/@g')
  if [[ "$LDAP_SERVER" == 'activeDirectory' ]]; then
    LDAP_ATTRIBUTE_USERNAME='sAMAccountName'
    LDAP_SEARCH_FILTER='(\&(objectClass=person)(sAMAccountName={user}))'
  fi
else
  LDAP_HOST='ldap'
  LDAP_BASE_DN="ou=People,o=${DOMAIN},dc=cloudogu,dc=com"
  LDAP_BIND_DN=$(doguctl config -e sa-ldap/username)
  LDAP_BIND_PASSWORD=$(doguctl config -e sa-ldap/password | sed 's@/@\\\\/@g')
  LDAP_ATTRIBUTE_USERNAME='uid'
  # \& instead of & because of sed
  LDAP_SEARCH_FILTER='(\&(objectClass=person)(uid={user}))'
fi


STAGE=$(doguctl config --global stage)
REQUIRE_SECURE='true'
if [[ "$STAGE" == 'development' ]]; then
  REQUIRE_SECURE='false'
fi

# render templates

sed "s@%DOMAIN%@$DOMAIN@g;\
s@%FQDN%@$FQDN@g;\
s@%REQUIRE_SECURE%@$REQUIRE_SECURE@g;\
s@%LDAP_HOST%@$LDAP_HOST@g;\
s@%LDAP_PORT%@$LDAP_PORT@g;\
s@%LDAP_ATTRIBUTE_USERNAME%@$LDAP_ATTRIBUTE_USERNAME@g;\
s@%LDAP_SEARCH_FILTER%@$LDAP_SEARCH_FILTER@g;\
s@%LDAP_BASE_DN%@$LDAP_BASE_DN@g;\
s?%LDAP_BIND_DN%?$LDAP_BIND_DN?g;\
s@%LDAP_BIND_PASSWORD%@$LDAP_BIND_PASSWORD@g"\
 /resources/cas.properties.tpl > /opt/apache-tomcat/webapps/cas/WEB-INF/cas.properties

# create truststore, which is used in the setenv.sh
create_truststore.sh > /dev/null

# startup tomcat
exec su - cas -c "export JAVA_HOME='/opt/jdk' && ${CATALINA_SH} run"
