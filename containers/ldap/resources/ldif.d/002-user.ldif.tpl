# vim:set ft=ldif:
#
version: 1

dn: uid=${ADMIN_USERNAME},ou=People,o=${LDAP_DOMAIN},${OPENLDAP_SUFFIX}
uid: ${ADMIN_USERNAME}
description: CES Administrator
givenName: ${ADMIN_GIVENNAME}
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
sn: ${ADMIN_SURNAME}
cn: ${ADMIN_DISPLAYNAME}
mail: ${ADMIN_MAIL}
userPassword: ${ADMIN_PASSWORD_ENC}

dn: uid=${SYSTEM_USERNAME},ou=People,o=${LDAP_DOMAIN},${OPENLDAP_SUFFIX}
uid: ${SYSTEM_USERNAME}
description: CES system account
givenName: CES
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
sn: System
cn: CES System
mail: ${SYSTEM_USERNAME}@${LDAP_DOMAIN}
userPassword: ${SYSTEM_PASSWORD}
