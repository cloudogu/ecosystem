import hudson.model.*;
import jenkins.model.*;
import groovy.json.JsonSlurper;

def keyExists(String key){
	String ip = new File("/etc/ces/node_master").getText("UTF-8").trim();
	URL url = new URL("http://${ip}:4001/v2/keys/${key}");
	try {
		def json = new JsonSlurper().parseText(url.text)
	} catch (FileNotFoundException) {
		return false
	}
	return true
}

// configuration
def plugins = [
  'cas-plugin',
  'git',
  'mercurial',
  'subversion',
  'workflow-aggregator',
  'simple-theme-plugin',
  'matrix-auth',
  'maven'
];

// add sonar plugin to Jenkins if SonarQube is installed
if (keyExists("dogu/sonar/current")) {
  plugins.add('sonar');
}

// action
def jenkins = Jenkins.instance;
def pluginManager = jenkins.pluginManager;
def updateCenter = jenkins.updateCenter;

pluginManager.doCheckUpdatesServer();
def available = updateCenter.getAvailables();

for (def shortName : plugins){
  def plugin = updateCenter.getById('default').getPlugin(shortName);
  if (available.contains(plugin)){
      println "install missing plugin " + shortName;
      plugin.deploy(true).get();
  }
}

if (updateCenter.isRestartRequiredForCompletion()) {
  jenkins.restart();
}
