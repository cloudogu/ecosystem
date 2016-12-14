# vim:set ft=ldif:
#
version: 1

dn: cn=cesManager,ou=Groups,o=${LDAP_DOMAIN},${OPENLDAP_SUFFIX}
cn: cesManager
description: Members of the cesManager group have full access to the cloudogu administration applications
member: uid=${ADMIN_USERNAME},ou=People,o=${LDAP_DOMAIN},${OPENLDAP_SUFFIX}
member: cn=__dummy
objectClass: top
objectClass: groupOfNames

dn: cn=${ADMIN_GROUP},ou=Groups,o=${LDAP_DOMAIN},${OPENLDAP_SUFFIX}
cn: ${ADMIN_GROUP}
description: This group grants administrative rights to all development applications of cloudogu
member: cn=__dummy
objectClass: top
objectClass: groupOfNames

