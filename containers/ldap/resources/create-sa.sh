#!/bin/bash -e

{
    source /etc/ces/functions.sh

    TYPE="$1"
    SERVICE="$2"

    if [ X"${SERVICE}" = X"" ]; then
        SERVICE="${TYPE}"
        TYPE=""
    fi
    
    if [ X"${SERVICE}" = X"" ]; then
        echo "usage create-sa.sh servicename"
        exit 1
    fi

    OU="Bind Users"
    if [ X"${TYPE}" = X"rw" ]; then
        OU="Special Users"
    fi

    LDAP_DOMAIN=$(doguctl config --global domain)
    # proposal: use doguctl config openldap_suffix in future
    OPENLDAP_SUFFIX="dc=cloudogu,dc=com"

    # create random schema suffix and password
    USERNAME="${SERVICE}_$(doguctl random -l 6)"
    PASSWORD=$(doguctl random)
    ENC_PASSWORD=$(slappasswd -s ${PASSWORD})
    render_template /srv/openldap/new-user.ldif.tpl > /srv/openldap/new-user_${USERNAME}.ldif
    ldapadd -f "/srv/openldap/new-user_${USERNAME}.ldif"

} >/dev/null 2>&1

# print details
echo "username: cn=${USERNAME},ou=${OU},o=${LDAP_DOMAIN},${OPENLDAP_SUFFIX}"
echo "password: ${PASSWORD}"
