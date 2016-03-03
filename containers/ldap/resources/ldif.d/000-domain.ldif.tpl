# vim:set ft=ldif:
#
version: 1

dn: ${OPENLDAP_SUFFIX}
objectClass: top
objectClass: domain

dn: o=${LDAP_DOMAIN},${OPENLDAP_SUFFIX}
o: ${LDAP_DOMAIN}
objectClass: top
objectClass: organization
description: Root entry for domain ${LDAP_DOMAIN}
