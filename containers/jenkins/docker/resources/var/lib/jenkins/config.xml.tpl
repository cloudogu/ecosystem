<?xml version='1.0' encoding='UTF-8'?>
<hudson>
  <disabledAdministrativeMonitors/>
  <version>1.0</version>
  <numExecutors>2</numExecutors>
  <mode>NORMAL</mode>
  <useSecurity>true</useSecurity>
  <authorizationStrategy class=\"hudson.security.AuthorizationStrategy\$Unsecured\"/>
  <securityRealm class=\"org.jenkinsci.plugins.cas.CasSecurityRealm\" plugin=\"cas-plugin@1.2.0\">
    <casServerUrl>https://${FQDN}/cas/</casServerUrl>
    <casProtocol class=\"org.jenkinsci.plugins.cas.protocols.Saml11Protocol\">
      <authoritiesAttribute>groups,roles</authoritiesAttribute>
      <fullNameAttribute>cn</fullNameAttribute>
      <emailAttribute>mail</emailAttribute>
      <tolerance>5000</tolerance>
    </casProtocol>
    <forceRenewal>false</forceRenewal>
    <enableSingleSignOut>true</enableSingleSignOut>
  </securityRealm>
  <disableRememberMe>false</disableRememberMe>
  <projectNamingStrategy class=\"jenkins.model.ProjectNamingStrategy\$DefaultProjectNamingStrategy\"/>
  <workspaceDir>${ITEM_ROOTDIR}/workspace</workspaceDir>
  <buildsDir>${ITEM_ROOTDIR}/builds</buildsDir>
  <markupFormatter class=\"hudson.markup.EscapedMarkupFormatter\"/>
  <jdks/>
  <viewsTabBar class=\"hudson.views.DefaultViewsTabBar\"/>
  <myViewsTabBar class=\"hudson.views.DefaultMyViewsTabBar\"/>
  <clouds/>
  <scmCheckoutRetryCount>0</scmCheckoutRetryCount>
  <views>
    <hudson.model.AllView>
      <owner class=\"hudson\" reference=\"../../..\"/>
      <name>All</name>
      <filterExecutors>false</filterExecutors>
      <filterQueue>false</filterQueue>
      <properties class=\"hudson.model.View\$PropertyList\"/>
    </hudson.model.AllView>
  </views>
  <primaryView>All</primaryView>
  <slaveAgentPort>0</slaveAgentPort>
  <label></label>
  <nodeProperties/>
  <globalNodeProperties/>
</hudson>
