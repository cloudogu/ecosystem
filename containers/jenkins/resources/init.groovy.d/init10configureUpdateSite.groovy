import jenkins.model.*;
import hudson.model.*
import groovy.json.JsonSlurper;

def getValueFromEtcd(String key){
	String ip = new File("/etc/ces/node_master").getText("UTF-8").trim();
	URL url = new URL("http://${ip}:4001/v2/keys/${key}");
	def json = new JsonSlurper().parseText(url.text)
	return json.node.value
}

def instance = Jenkins.getInstance();

String updateSiteUrl = getValueFromEtcd("config/jenkins/update_site_url");

// TODO: check if already done?
if(updateSiteUrl != null && !updateSiteUrl.isEmpty()) {
	println "set signatureCheck=false";
	hudson.model.DownloadService.signatureCheck = false;
	updateCenter = instance.getUpdateCenter();
	println "change Update Site URL";
	def customUpdateSite = new hudson.model.UpdateSite("default", updateSiteUrl)
	def sites = updateCenter.getSites();
	sites.clear()
    sites.add(customUpdateSite);
	println "save instance"
	instance.save();
}
