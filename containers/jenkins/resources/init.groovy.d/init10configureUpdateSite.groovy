import jenkins.model.*;
import hudson.model.*
import groovy.json.JsonSlurper;

def getValuesFromEtcd(String key){
	String ip = new File("/etc/ces/node_master").getText("UTF-8").trim();
	URL url = new URL("http://${ip}:4001/v2/keys/${key}");
	def json = new JsonSlurper().parseText(url.text);
	return convertNodesToUpdateSites(json.node.nodes, json.node.key.length());
}

def convertNodesToUpdateSites(Object nodes, int parentKeyOffset) {
	List<hudson.model.UpdateSite> updateSites = [];
	nodes.each{ node ->
		// trim the directory from the nodes key
		def name = node.key.substring(parentKeyOffset+1);
		def url = node.value;
		println "found update site: "+name+" "+url;
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
	def sites = updateCenter.getSites();
	sites.clear();
	println "add new update sites";
	for(hudson.model.UpdateSite site : updateSites) {
		sites.add(site);
	}
	println "save instance";
	instance.save();
}