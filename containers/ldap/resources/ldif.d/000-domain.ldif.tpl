# vim:set ft=ldif:
#
version: 1

dn: ${SUFFIX}
objectClass: top
objectClass: domain

dn: o=${LDAP_DOMAIN},${SUFFIX}
o: ${LDAP_DOMAIN}
objectClass: top
objectClass: organization
description: Root entry for domain ${LDAP_DOMAIN}
