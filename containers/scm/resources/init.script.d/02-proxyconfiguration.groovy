// This script configures proxy settings from etcd

import sonia.scm.config.ScmConfiguration;
import sonia.scm.util.ScmConfigurationUtil;
import groovy.json.JsonSlurper;

def getValueFromEtcd(String key){
	String ip = new File("/etc/ces/node_master").getText("UTF-8").trim();
	URL url = new URL("http://${ip}:4001/v2/keys/${key}");
	def json = new JsonSlurper().parseText(url.text)
	return json.node.value
}

def configuration = injector.getInstance(ScmConfiguration.class);
boolean isProxyEnabledInEtcd = false;

try{
  isProxyEnabledInEtcd = "true".equals(getValueFromEtcd("config/_global/proxy/enabled"));
} catch (FileNotFoundException e){
  System.out.println("Etcd proxy configuration does not exist.");
}

if (isProxyEnabledInEtcd){
	enableProxy(configuration);
  setProxyServerSettings(configuration);
  setProxyAuthenticationSettings(configuration);
  setProxyExcludes(configuration);
}

def enableProxy(configuration){
  configuration.setEnableProxy(true);
}

def setProxyServerSettings(configuration){
  configuration.setProxyServer(getValueFromEtcd("config/_global/proxy/server"));
  configuration.setProxyPort(Integer.parseInt(getValueFromEtcd("config/_global/proxy/port")));
}

def setProxyAuthenticationSettings(configuration){
	// Authentication credentials are optional
	try{
		String proxyUser = getValueFromEtcd("config/_global/proxy/username");
		String proxyPassword = getValueFromEtcd("config/_global/proxy/password");
		configuration.setProxyUser(proxyUser);
		configuration.setProxyPassword(proxyPassword);
	} catch (FileNotFoundException e){
		System.out.println("Etcd proxy authentication configuration is incomplete or not existent.");
	}
}

def setProxyExcludes(configuration){
  Set<String> excludes = new HashSet<String>();
  excludes.add(getValueFromEtcd("config/_global/fqdn"));
  configuration.setProxyExcludes(excludes);
}

// store configuration
ScmConfigurationUtil.getInstance().store(configuration);
