// this script configures some basic settings for scm-manager to work with the
// ecosystem.

import sonia.scm.config.ScmConfiguration;
import sonia.scm.util.ScmConfigurationUtil;
import groovy.json.JsonSlurper;

// TODO sharing ???
def getValueFromEtcd(String key){
	String ip = new File("/etc/ces/node_master").getText("UTF-8").trim();
	URL url = new URL("http://${ip}:4001/v2/keys/${key}");
	def json = new JsonSlurper().parseText(url.text)
	return json.node.value
}

def config = injector.getInstance(ScmConfiguration.class);

// set admin group
if (config.getAdminGroups() == null){
	config.setAdminGroups(new HashSet());
} else {
	config.getAdminGroups().clear();
}
String adminGroup = getValueFromEtcd("config/_global/admin_group");
if (adminGroup != null && adminGroup.length() > 0){
	config.getAdminGroups().add(adminGroup);
}

// set base url
String fqdn = getValueFromEtcd("config/_global/fqdn");
config.setBaseUrl("https://${fqdn}/scm");

// store configuration
ScmConfigurationUtil.getInstance().store(config);
