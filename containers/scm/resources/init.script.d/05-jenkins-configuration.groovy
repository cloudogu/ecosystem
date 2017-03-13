// this script configures the jenkins plugin

import groovy.json.JsonSlurper;

// TODO sharing ?
def getValueFromEtcd(String key){
  String ip = new File("/etc/ces/node_master").getText("UTF-8").trim();
	URL url = new URL("http://${ip}:4001/v2/keys/${key}");
	def json = new JsonSlurper().parseText(url.text)
	return json.node.value
}

try {
    def jenkins = injector.getInstance(Class.forName("sonia.scm.jenkins.JenkinsContext"));
		def config = jenkins.getConfiguration();

		String fqdn = getValueFromEtcd("config/_global/fqdn");
		config.url = "https://${fqdn}/jenkins";

    jenkins.storeConfiguration();
} catch( Exception e ) {
    println "jenkins plugin seems not to be installed"
}
