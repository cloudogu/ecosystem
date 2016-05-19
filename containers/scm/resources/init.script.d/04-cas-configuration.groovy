// this script configures the cas plugin

import groovy.json.JsonSlurper;

// TODO sharing ?
def getValueFromEtcd(String key){
  String ip = new File("/etc/ces/node_master").getText("UTF-8").trim();
	URL url = new URL("http://${ip}:4001/v2/keys/${key}");
	def json = new JsonSlurper().parseText(url.text)
	return json.node.value
}

try {
    def cas = injector.getInstance(Class.forName("de.triology.scm.plugins.cas.CasAuthenticationHandler"));
		def config = cas.getConfig();

		String fqdn = getValueFromEtcd("config/_global/fqdn");
		config.setCasServerUrl("https://${fqdn}/cas");

		config.setCasAttrUsername("username")
		config.setCasAttrDisplayName("displayName");
		config.setCasAttrMail("mail");
		config.setCasAttrGroup("groups");

		config.setTolerance("5000");
		config.setEnabled(true);

    cas.storeConfig(config);
} catch( ClassNotFoundException e ) {
    println "cas plugin seems not to be installed"
}
