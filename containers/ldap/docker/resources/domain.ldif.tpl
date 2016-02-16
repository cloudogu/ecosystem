version: 1
dn: o=${LDAP_DOMAIN},${SUFFIX}
o: ${LDAP_DOMAIN}
objectClass: top
objectClass: organization
description: Root entry for domain ${LDAP_DOMAIN}

dn: ou=People,o=${LDAP_DOMAIN},${SUFFIX}
ou: People
description: Root entry for persons
objectClass: top
objectClass: organizationalUnit

dn: uid=${ADMIN_USERNAME},ou=People,o=${LDAP_DOMAIN},${SUFFIX}
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

dn: uid=${SYSTEM_USERNAME},ou=People,o=${LDAP_DOMAIN},${SUFFIX}
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

dn: ou=Groups,o=${LDAP_DOMAIN},${SUFFIX}
ou: Groups
description: Root entry for groups
objectClass: top
objectClass: organizationalUnit

dn: cn=UniverseAdministrators,ou=Groups,o=${LDAP_DOMAIN},${SUFFIX}
cn: UniverseAdministrators
description: Members of the UniverseAdministrators have full access to the universe administration application
member: uid=${ADMIN_USERNAME},ou=People,o=${LDAP_DOMAIN},${SUFFIX}
member: cn=dummy
objectClass: top
objectClass: groupOfNames

dn: cn=universalAdmin,ou=Groups,o=${LDAP_DOMAIN},${SUFFIX}
cn: universalAdmin
description: This group grants administrative rights to all development applications of SCM-Manager Universe (except Bugzilla)
member: cn=dummy
objectClass: top
objectClass: groupOfNames

dn: cn=universalWrite,ou=Groups,o=${LDAP_DOMAIN},${SUFFIX}
cn: universalWrite
description: This group grants write permissions to all projects in SCM-Manager Universe
member: cn=dummy
objectClass: top
objectClass: groupOfNames

dn: cn=universalRead,ou=Groups,o=${LDAP_DOMAIN},${SUFFIX}
cn: universalRead
description: This group grants read access to all projects in SCM-Manager Universe
member: cn=dummy
objectClass: top
objectClass: groupOfNames

dn: ou=Special Users,o=${LDAP_DOMAIN},${SUFFIX}
ou: Special Users
description: Root entry for persons
objectClass: top
objectClass: organizationalUnit
