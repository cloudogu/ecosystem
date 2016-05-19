import hudson.model.*;
import jenkins.model.*;


// configuration
def plugins = ['git','mercurial','workflow-aggregator','simple-theme-plugin'];

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
      plugin.deploy(false).get();
  }
}

if (updateCenter.isRestartRequiredForCompletion()) {
  jenkins.restart();
}
