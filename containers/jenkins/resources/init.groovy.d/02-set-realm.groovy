import hudson.model.*;
import jenkins.model.*;
import org.jenkinsci.plugins.cas.CasSecurityRealm;
import org.jenkinsci.plugins.cas.protocols.Saml11Protocol;
import groovy.json.JsonSlurper;

def getValueFromEtcd(String key){
	String ip = new File("/etc/ces/node_master").getText("UTF-8").trim();
	URL url = new URL("http://${ip}:4001/v2/keys/${key}");
	def json = new JsonSlurper().parseText(url.text)
	return json.node.value
}

String fqdn = getValueFromEtcd("config/_global/fqdn");
def protocol = new Saml11Protocol("groups,roles", "cn", "mail", 5000);
def realm = new CasSecurityRealm("https://${fqdn}/cas", protocol, false, true, true);

def instance = Jenkins.getInstance();
instance.setSecurityRealm(realm);
instance.setDisableRememberMe(true);
instance.save();
