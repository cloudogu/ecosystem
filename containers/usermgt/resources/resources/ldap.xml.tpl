<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<ldap>
  <host>${LDAP_HOST}</host>
  <port>${LDAP_PORT}</port>
  <bind-dn>${LDAP_BIND_DN}</bind-dn>
  <bind-password>${LDAP_BIND_PASSWORD}</bind-password>
  <user-base-dn>ou=People,${LDAP_BASE_DN}</user-base-dn>
  <group-base-dn>ou=Groups,${LDAP_BASE_DN}</group-base-dn>
  <disabled>false</disabled>
</ldap>
