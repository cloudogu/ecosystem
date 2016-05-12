<?xml version='1.0' encoding='UTF-8'?>
<hudson>
  <disabledAdministrativeMonitors/>
  <version>1.609.2</version>
  <numExecutors>2</numExecutors>
  <mode>NORMAL</mode>
  <useSecurity>true</useSecurity>
  <authorizationStrategy class=\"hudson.security.ProjectMatrixAuthorizationStrategy\">
    <permission>com.cloudbees.plugins.credentials.CredentialsProvider.Create:${ADMINGROUP}</permission>
    <permission>com.cloudbees.plugins.credentials.CredentialsProvider.Delete:${ADMINGROUP}</permission>
    <permission>com.cloudbees.plugins.credentials.CredentialsProvider.ManageDomains:${ADMINGROUP}</permission>
    <permission>com.cloudbees.plugins.credentials.CredentialsProvider.Update:${ADMINGROUP}</permission>
    <permission>com.cloudbees.plugins.credentials.CredentialsProvider.View:${ADMINGROUP}</permission>
    <permission>hudson.model.Computer.Build:${ADMINGROUP}</permission>
    <permission>hudson.model.Computer.Configure:${ADMINGROUP}</permission>
    <permission>hudson.model.Computer.Connect:${ADMINGROUP}</permission>
    <permission>hudson.model.Computer.Create:${ADMINGROUP}</permission>
    <permission>hudson.model.Computer.Delete:${ADMINGROUP}</permission>
    <permission>hudson.model.Computer.Disconnect:${ADMINGROUP}</permission>
    <permission>hudson.model.Hudson.Administer:${ADMINGROUP}</permission>
    <permission>hudson.model.Hudson.ConfigureUpdateCenter:${ADMINGROUP}</permission>
    <permission>hudson.model.Hudson.Read:${ADMINGROUP}</permission>
    <permission>hudson.model.Hudson.RunScripts:${ADMINGROUP}</permission>
    <permission>hudson.model.Hudson.UploadPlugins:${ADMINGROUP}</permission>
    <permission>hudson.model.Item.Build:${ADMINGROUP}</permission>
    <permission>hudson.model.Item.Cancel:${ADMINGROUP}</permission>
    <permission>hudson.model.Item.Configure:${ADMINGROUP}</permission>
    <permission>hudson.model.Item.Create:${ADMINGROUP}</permission>
    <permission>hudson.model.Item.Delete:${ADMINGROUP}</permission>
    <permission>hudson.model.Item.Discover:${ADMINGROUP}</permission>
    <permission>hudson.model.Item.Read:${ADMINGROUP}</permission>
    <permission>hudson.model.Item.Workspace:${ADMINGROUP}</permission>
    <permission>hudson.model.Run.Delete:${ADMINGROUP}</permission>
    <permission>hudson.model.Run.Update:${ADMINGROUP}</permission>
    <permission>hudson.model.View.Configure:${ADMINGROUP}</permission>
    <permission>hudson.model.View.Create:${ADMINGROUP}</permission>
    <permission>hudson.model.View.Delete:${ADMINGROUP}</permission>
    <permission>hudson.model.View.Read:${ADMINGROUP}</permission>
  </authorizationStrategy>
  <securityRealm class=\"org.jenkinsci.plugins.cas.CasSecurityRealm\" plugin=\"cas-plugin@1.3.0-CES-1\">
    <casServerUrl>https://${FQDN}/cas/</casServerUrl>
    <casProtocol class=\"org.jenkinsci.plugins.cas.protocols.Saml11Protocol\">
      <authoritiesAttribute>groups,roles</authoritiesAttribute>
      <fullNameAttribute>cn</fullNameAttribute>
      <emailAttribute>mail</emailAttribute>
      <tolerance>5000</tolerance>
    </casProtocol>
    <forceRenewal>false</forceRenewal>
    <enableRestApi>true</enableRestApi>
    <enableSingleSignOut>true</enableSingleSignOut>
  </securityRealm>
  <disableRememberMe>true</disableRememberMe>
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
