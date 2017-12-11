<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<cas>
  <service>https://${FQDN}/usermgt/login/cas</service>
  <server-url>https://${FQDN}/cas</server-url>
  <failure-url>https://${FQDN}/usermgt/error/auth.html</failure-url>
  <login-url>https://${FQDN}/cas/login?service=https://${FQDN}/usermgt/login/cas</login-url>
  <logout-url>https://${FQDN}/cas/logout</logout-url>
  <role-attribute-names>groups</role-attribute-names>
  <administrator-role>cesManager</administrator-role>
</cas>
