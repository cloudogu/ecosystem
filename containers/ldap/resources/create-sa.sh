#!/bin/bash -e
source /etc/ces/functions.sh

SERVICE="$1"
TYPE="$2"

if [ "${SERVICE}" == "" ]; then
  echo "usage create-sa.sh servicename"
  exit 1
fi

OU="Bind Users"
if [ "${TYPE}" == "rw" ]; then
  OU="Special Users"
fi

LDAP_DOMAIN=$(doguctl config --global domain)
# proposal: use doguctl config openldap_suffix in future
OPENLDAP_SUFFIX="dc=cloudogu,dc=com"

# create random schema suffix and password
USERNAME="${SERVICE}_$(doguctl random -l 6)"
PASSWORD=$(doguctl random)
render_template /srv/openldap/new-user.ldif.tpl > /srv/openldap/new-user.ldif
ldapadd -f "/srv/openldap/new-user.ldif"

# print details
echo "username: uid=${USERNAME},ou=${OU},o=${LDAP_DOMAIN},${OPENLDAP_SUFFIX}"
echo "password: ${PASSWORD}"
