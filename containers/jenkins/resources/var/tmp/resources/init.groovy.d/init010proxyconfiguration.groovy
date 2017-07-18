// Script to activate proxy settings in jenkins if set in etcd

import jenkins.model.*
import groovy.transform.Field
import groovy.json.JsonSlurper;

def getValueFromEtcd(String key){
	String ip = new File("/etc/ces/node_master").getText("UTF-8").trim();
	URL url = new URL("http://${ip}:4001/v2/keys/${key}");
	def json = new JsonSlurper().parseText(url.text)
	return json.node.value
}

def instance = Jenkins.getInstance();
boolean isProxyEnabledInEtcd = false;
@Field boolean enableProxyInJenkins = false;
@Field String proxyName, noProxyHost, proxyUser, proxyPassword;
@Field int proxyPort;

try {
	isProxyEnabledInEtcd = "true".equals(getValueFromEtcd("config/_global/proxy/enabled"));
	} catch (FileNotFoundException e){
		System.out.println("Etcd proxy configuration does not exist.");
	}

	if (isProxyEnabledInEtcd){
		enableProxy();
		setProxyServerSettings();
		setProxyAuthenticationSettings();
		setProxyExcludes();
	}

	def enableProxy(){
		enableProxyInJenkins = true;
	}

	def disableProxy(){
		enableProxyInJenkins = false;
	}

	def setProxyServerSettings(){
		try{
			proxyName = getValueFromEtcd("config/_global/proxy/server")
			proxyPort = Integer.parseInt(getValueFromEtcd("config/_global/proxy/port"));
			} catch (FileNotFoundException e){
				System.out.println("Etcd proxy configuration is incomplete (server or port not found).");
				disableProxy();
			}
	}

	def setProxyAuthenticationSettings(){
			// Authentication credentials are optional
		try{
			proxyPassword = getValueFromEtcd("config/_global/proxy/password");
			proxyUser = getValueFromEtcd("config/_global/proxy/username");
		} catch (FileNotFoundException e){
			System.out.println("Etcd proxy authentication configuration is incomplete or not existent.");
		}
	}

	def setProxyExcludes(){
		noProxyHost = getValueFromEtcd("config/_global/fqdn")
	}

	if(enableProxyInJenkins){
		def proxyConfiguration = new hudson.ProxyConfiguration(proxyName, proxyPort, proxyUser, proxyPassword, noProxyHost)
		instance.proxy = proxyConfiguration
		instance.save()
	}