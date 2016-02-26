# vim:set ft=ldif:
#
version: 1

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
mail: ${ADMIN_USERNAME}@${LDAP_DOMAIN}
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
mail: ${SYSTEM_USERNAME}@${LDAP_DOMAIN}
userPassword: ${SYSTEM_PASSWORD}
