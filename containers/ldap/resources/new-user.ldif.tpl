dn: cn=${USERNAME},ou=${OU},o=${LDAP_DOMAIN},${OPENLDAP_SUFFIX}
cn: ${USERNAME}
objectClass: organizationalRole
objectClass: simpleSecurityObject
userPassword: ${ENC_PASSWORD}
