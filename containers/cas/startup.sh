#!/bin/bash
source /etc/ces/functions.sh

# general variables for templates
DOMAIN=$(get_domain)
FQDN=$(get_fqdn)

LDAP_TYPE=$(doguctl config ldap/ds_type)
LDAP_SERVER=$(doguctl config ldap/server)
LDAP_HOST=$(doguctl config ldap/host)
LDAP_PORT=$(doguctl config ldap/port)
LDAP_ATTRIBUTE_USERNAME=$(doguctl config ldap/attribute_id)
# TODO: use fullname
LDAP_ATTRIBUTE_FULLNAME=$(doguctl config ldap/attribute_fullname)
LDAP_ATTRIBUTE_MAIL=$(doguctl config ldap/attribute_mail)
LDAP_ATTRIBUTE_GROUP=$(doguctl config ldap/attribute_group)
LDAP_STARTTLS='false'

# replace & with /& because of sed
LDAP_SEARCH_FILTER=$( echo "(&$(doguctl config ldap/search_filter)($LDAP_ATTRIBUTE_USERNAME={user}))" | sed 's@&@\\\&@g')

if [[ "$LDAP_TYPE" == 'external' ]]; then
  LDAP_BASE_DN=$(doguctl config ldap/base_dn)
  LDAP_BIND_DN=$(doguctl config ldap/connection_dn)
  LDAP_BIND_PASSWORD=$(doguctl config -e ldap/password | sed 's@/@\\\\/@g')
else
  # for embedded ldap
  LDAP_BASE_DN="ou=People,o=${DOMAIN},dc=cloudogu,dc=com"
  LDAP_BIND_DN=$(doguctl config -e sa-ldap/username)
  LDAP_BIND_PASSWORD=$(doguctl config -e sa-ldap/password | sed 's@/@\\\\/@g')
fi


STAGE=$(doguctl config --global stage)
REQUIRE_SECURE='true'
if [[ "$STAGE" == 'development' ]]; then
  REQUIRE_SECURE='false'
fi

# render templates

sed "s@%DOMAIN%@$DOMAIN@g;\
s@%LDAP_STARTTLS%@$LDAP_STARTTLS@g;\
s@%FQDN%@$FQDN@g;\
s@%REQUIRE_SECURE%@$REQUIRE_SECURE@g;\
s@%LDAP_HOST%@$LDAP_HOST@g;\
s@%LDAP_PORT%@$LDAP_PORT@g;\
s@%LDAP_SEARCH_FILTER%@$LDAP_SEARCH_FILTER@g;\
s@%LDAP_BASE_DN%@$LDAP_BASE_DN@g;\
s?%LDAP_BIND_DN%?$LDAP_BIND_DN?g;\
s@%LDAP_BIND_PASSWORD%@$LDAP_BIND_PASSWORD@g;\
s@%LDAP_ATTRIBUTE_USERNAME%@$LDAP_ATTRIBUTE_USERNAME@g;\
s?%LDAP_ATTRIBUTE_MAIL%?$LDAP_ATTRIBUTE_MAIL?g;\
s@%LDAP_ATTRIBUTE_GROUP%@$LDAP_ATTRIBUTE_GROUP@g"\
 /resources/cas.properties.tpl > /opt/apache-tomcat/webapps/cas/WEB-INF/cas.properties

# create truststore, which is used in the setenv.sh
create_truststore.sh > /dev/null

# startup tomcat
exec su - cas -c "export JAVA_HOME='/opt/jdk' && ${CATALINA_SH} run"
