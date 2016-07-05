// this script configures the redmine plugin

import groovy.json.JsonSlurper;
import javax.xml.bind.*;

// TODO sharing ?
def getValueFromEtcd(String key){
  String ip = new File("/etc/ces/node_master").getText("UTF-8").trim();
	URL url = new URL("http://${ip}:4001/v2/keys/${key}");
	def json = new JsonSlurper().parseText(url.text)
	return json.node.value
}

try {
    def redmine = injector.getInstance(Class.forName("sonia.scm.redmine.RedmineIssueTracker"));
		String fqdn = getValueFromEtcd("config/_global/fqdn");

		JAXBContext jaxbContext = JAXBContext.newInstance(Class.forName("sonia.scm.redmine.config.RedmineGlobalConfiguration"));
    Unmarshaller unmarshaller = jaxbContext.createUnmarshaller();
    String configXml = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>" +
     "<redmine>" +
       "<autoClose>true</autoClose>" +
       "<updateIssues>true</updateIssues>" +
       "<usernameTransformPattern>{0}</usernameTransformPattern>" +
       "<disableRepositoryConfiguration>false</disableRepositoryConfiguration>" +
       "<url>https://${fqdn}/redmine</url>" +
     "</redmine>";
    StringReader configReader = new StringReader(configXml);
    def newConfig = unmarshaller.unmarshal(configReader);
    redmine.setGlobalConfiguration(newConfig);
} catch( JAXBException | ClassNotFoundException e ) {
    println "redmine plugin seems not to be installed"
}
