# vim:set ft=ldif:
#
version: 1

dn: cn=UniverseAdministrators,ou=Groups,o=${LDAP_DOMAIN},${OPENLDAP_SUFFIX}
cn: UniverseAdministrators
description: Members of the UniverseAdministrators have full access to the universe administration application
member: uid=${ADMIN_USERNAME},ou=People,o=${LDAP_DOMAIN},${OPENLDAP_SUFFIX}
member: cn=__dummy
objectClass: top
objectClass: groupOfNames

dn: cn=universalAdmin,ou=Groups,o=${LDAP_DOMAIN},${OPENLDAP_SUFFIX}
cn: universalAdmin
description: This group grants administrative rights to all development applications of SCM-Manager Universe (except Bugzilla)
member: cn=__dummy
objectClass: top
objectClass: groupOfNames

dn: cn=universalWrite,ou=Groups,o=${LDAP_DOMAIN},${OPENLDAP_SUFFIX}
cn: universalWrite
description: This group grants write permissions to all projects in SCM-Manager Universe
member: cn=__dummy
objectClass: top
objectClass: groupOfNames

dn: cn=universalRead,ou=Groups,o=${LDAP_DOMAIN},${OPENLDAP_SUFFIX}
cn: universalRead
description: This group grants read access to all projects in SCM-Manager Universe
member: cn=__dummy
objectClass: top
objectClass: groupOfNames
