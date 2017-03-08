// this script configures the webhook plugin

import groovy.json.JsonSlurper;
import javax.xml.bind.*;
import sonia.scm.*;

// TODO sharing ?
def getValueFromEtcd(String key){
  String ip = new File("/etc/ces/node_master").getText("UTF-8").trim();
	URL url = new URL("http://${ip}:4001/v2/keys/${key}");
	def json = new JsonSlurper().parseText(url.text)
	return json.node.value
}

def deleteOldSmeagolNotifyEntry(config){
  def iter = config.iterator();
  while(iter.hasNext()){
    def hook = iter.next();
    String url = hook.getUrlPattern();
    if(url.endsWith("notify?id=\${repository.id}")) {
      iter.remove();
    }
  }
}

def addNewSmeagolNotifyEntry(globalConfig){
  String fqdn = getValueFromEtcd("config/_global/fqdn");
  String url = "https://${fqdn}/smeagol/rest/api/v1/notify?id=\${repository.id}";
  boolean executeOnEveryCommit = false;
  boolean sendCommitData = false;
  String httpMethod = "GET";
  
  def properties = new BasicPropertiesAware();
  properties.setProperty("webhooks",url+";"+executeOnEveryCommit+";"+sendCommitData+";"+httpMethod);
  println("properties:"+ properties.getProperty("webhooks"));
  def webHookConfigurationClass = Class.forName("sonia.scm.webhook.WebHookConfiguration");
  def config = webHookConfigurationClass.newInstance(properties);
  println("webhook availabile: "+config.isWebHookAvailable())
  return globalConfig.merge(config);
}

try {

    def webHookContext = injector.getInstance(Class.forName("sonia.scm.webhook.WebHookContext"));
		def globalConfig = webHookContext.getGlobalConfiguration();

    deleteOldSmeagolNotifyEntry(globalConfig);
    def newGlobalConfig = addNewSmeagolNotifyEntry(globalConfig);
    println("webhook availabile: "+newGlobalConfig.isWebHookAvailable())
    webHookContext.setGlobalConfiguration(newGlobalConfig);

} catch( JAXBException | ClassNotFoundException e ) {
    println "webhook plugin seems not to be installed"
}
