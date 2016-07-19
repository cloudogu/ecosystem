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

dn: ou=Special Users,o=${LDAP_DOMAIN},${OPENLDAP_SUFFIX}
ou: Special Users
description: Root entry for Special Users
objectClass: top
objectClass: organizationalUnit

dn: ou=Bind Users,o=${LDAP_DOMAIN},${OPENLDAP_SUFFIX}
ou: Bind Users
description: Root entry for Bind Users
objectClass: top
objectClass: organizationalUnit
