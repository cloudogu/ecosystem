import jenkins.model.*;
import hudson.model.*
import groovy.json.JsonSlurper;

def getValuesFromEtcd(String key){
	String ip = new File("/etc/ces/node_master").getText("UTF-8").trim();
	URL url = new URL("http://${ip}:4001/v2/keys/${key}");
	def json = new JsonSlurper().parseText(url.text);
	println json;
	return convertNodesToUpdateSites(json.node.nodes, json.node.key.length());
}

def convertNodesToUpdateSites(Object nodes, int keyOffset) {
	println "convertNodesToUpdateSites";
	List<hudson.model.UpdateSite> updateSites = [];
	nodes.each{ node ->
		def name = node.key.substring(keyOffset+1);
		def url = node.value;
		println "UpdateSite: "+name+" "+url;
		site = new hudson.model.UpdateSite(name,url);
		updateSites.add(site);
	}
	return updateSites;
}

def instance = Jenkins.getInstance();

List<hudson.model.UpdateSite> updateSites = getValuesFromEtcd("config/jenkins/updateSiteUrl");

// TODO: check if already done?
if(updateSites.size() > 0) {
	println "set signatureCheck=false";
	hudson.model.DownloadService.signatureCheck = false;
	updateCenter = instance.getUpdateCenter();
	println "change Update Site URL";
	def sites = updateCenter.getSites();
	sites.clear();
	for(hudson.model.UpdateSite site : updateSites) {
		sites.add(site);
	}
	println "save instance";
	instance.save();
}