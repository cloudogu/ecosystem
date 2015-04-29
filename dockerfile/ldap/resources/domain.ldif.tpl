version: 1
dn: o=${LDAP_DOMAIN},dc=cloudogu,dc=com
o: ${LDAP_DOMAIN}
objectClass: top
objectClass: organization
description: Root entry for domain ${LDAP_DOMAIN}

dn: ou=Groups,o=${LDAP_DOMAIN},dc=cloudogu,dc=com
ou: Groups
description: Root entry for groups
objectClass: top
objectClass: organizationalUnit

dn: ou=People,o=${LDAP_DOMAIN},dc=cloudogu,dc=com
ou: People
description: Root entry for persons
objectClass: top
objectClass: organizationalUnit

dn: ou=Special Users,o=${LDAP_DOMAIN},dc=cloudogu,dc=com
ou: Special Users
description: Root entry for persons
objectClass: top
objectClass: organizationalUnit
