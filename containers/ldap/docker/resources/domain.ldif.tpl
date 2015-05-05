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

dn: uid=${ADMIN_USERNAME},ou=People,o=${LDAP_DOMAIN},dc=cloudogu,dc=com
uid: ${ADMIN_USERNAME}
description: Universe Administrator
givenName: Universe
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
sn: Administrator
cn: Universe Administrator
mail: admin@${LDAP_DOMAIN}
userPassword: ${ADMIN_PASSWORD}

dn: uid=${SYSTEM_USERNAME},ou=People,o=${LDAP_DOMAIN},dc=cloudogu,dc=com
uid: ${SYSTEM_USERNAME}
description: Universe system account
givenName: Universe
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
sn: System
cn: Universe System
mail: system@${LDAP_DOMAIN}
userPassword: ${SYSTEM_PASSWORD}

dn: ou=Special Users,o=${LDAP_DOMAIN},dc=cloudogu,dc=com
ou: Special Users
description: Root entry for persons
objectClass: top
objectClass: organizationalUnit
