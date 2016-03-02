# vim:set ft=ldif:
#
version: 1

dn: ou=People,o=${LDAP_DOMAIN},${OPENLDAP_SUFFIX}
ou: People
description: Root entry for persons
objectClass: top
objectClass: organizationalUnit

dn: ou=Groups,o=${LDAP_DOMAIN},${OPENLDAP_SUFFIX}
ou: Groups
description: Root entry for groups
objectClass: top
objectClass: organizationalUnit
