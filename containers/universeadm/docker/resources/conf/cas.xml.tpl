<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<cas>
  <service>https://${FQDN}/universeadm/login/cas</service>
  <server-url>https://${FQDN}/cas</server-url>
  <failure-url>https://${FQDN}/universeadm/error/auth.html</failure-url>
  <login-url>https://${FQDN}/cas/login?service=https://${FQDN}/universeadm/login/cas</login-url>
  <logout-url>https://${FQDN}/cas/logout</logout-url>
  <role-attribute-names>groups</role-attribute-names>
  <administrator-role>UniverseAdministrators</administrator-role>
</cas>
