<?xml version='1.0' encoding='UTF-8'?>
<hudson>
  <disabledAdministrativeMonitors/>
  <version>1.0</version>
  <numExecutors>2</numExecutors>
  <mode>NORMAL</mode>
  <useSecurity>true</useSecurity>
  <authorizationStrategy class=\"hudson.security.ProjectMatrixAuthorizationStrategy\">
    <permission>com.cloudbees.plugins.credentials.CredentialsProvider.Create:universalAdmin</permission>
    <permission>com.cloudbees.plugins.credentials.CredentialsProvider.Delete:universalAdmin</permission>
    <permission>com.cloudbees.plugins.credentials.CredentialsProvider.ManageDomains:universalAdmin</permission>
    <permission>com.cloudbees.plugins.credentials.CredentialsProvider.Update:universalAdmin</permission>
    <permission>com.cloudbees.plugins.credentials.CredentialsProvider.View:universalAdmin</permission>
    <permission>hudson.model.Computer.Build:universalAdmin</permission>
    <permission>hudson.model.Computer.Configure:universalAdmin</permission>
    <permission>hudson.model.Computer.Connect:universalAdmin</permission>
    <permission>hudson.model.Computer.Create:universalAdmin</permission>
    <permission>hudson.model.Computer.Delete:universalAdmin</permission>
    <permission>hudson.model.Computer.Disconnect:universalAdmin</permission>
    <permission>hudson.model.Hudson.Administer:universalAdmin</permission>
    <permission>hudson.model.Hudson.ConfigureUpdateCenter:universalAdmin</permission>
    <permission>hudson.model.Hudson.Read:universalAdmin</permission>
    <permission>hudson.model.Hudson.RunScripts:universalAdmin</permission>
    <permission>hudson.model.Hudson.UploadPlugins:universalAdmin</permission>
    <permission>hudson.model.Item.Build:universalAdmin</permission>
    <permission>hudson.model.Item.Cancel:universalAdmin</permission>
    <permission>hudson.model.Item.Configure:universalAdmin</permission>
    <permission>hudson.model.Item.Create:universalAdmin</permission>
    <permission>hudson.model.Item.Delete:universalAdmin</permission>
    <permission>hudson.model.Item.Discover:universalAdmin</permission>
    <permission>hudson.model.Item.Read:universalAdmin</permission>
    <permission>hudson.model.Item.Workspace:universalAdmin</permission>
    <permission>hudson.model.Run.Delete:universalAdmin</permission>
    <permission>hudson.model.Run.Update:universalAdmin</permission>
    <permission>hudson.model.View.Configure:universalAdmin</permission>
    <permission>hudson.model.View.Create:universalAdmin</permission>
    <permission>hudson.model.View.Delete:universalAdmin</permission>
    <permission>hudson.model.View.Read:universalAdmin</permission>
  </authorizationStrategy>
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
