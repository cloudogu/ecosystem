import jenkins.model.*;
import groovy.json.JsonSlurper;

// https://github.com/r-hub/rhub-jenkins/blob/master/docker-entrypoint.sh#L117

def getValueFromEtcd(String key){
	String ip = new File("/etc/ces/node_master").getText("UTF-8").trim();
	URL url = new URL("http://${ip}:4001/v2/keys/${key}");
	def json = new JsonSlurper().parseText(url.text)
	return json.node.value
}

def instance = Jenkins.getInstance();

// configure jenkins location
String domain = getValueFromEtcd("config/_global/domain");
String fqdn = getValueFromEtcd("config/_global/fqdn");

def location = JenkinsLocationConfiguration.get()
location.setAdminAddress("jenkins@${domain}");
location.setUrl("https://${fqdn}/jenkins");
location.save()

instance.save();
