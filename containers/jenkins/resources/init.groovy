import hudson.model.*;
import jenkins.model.*;

try {
    println "Install plugins"
    def j = Jenkins.instance;
    def p = j.pluginManager;
    def uc = j.updateCenter;

    p.doCheckUpdatesServer();
    ['git','mercurial','workflow-aggregator','simple-theme-plugin'].each { n ->
      j.updateCenter.getById('default').getPlugin(n).deploy(false).get();
    }

    p.doCheckUpdatesServer();

    System.exit(0);
} catch (Throwable t) {
    println "Error while installing plugins"
    t.printStackTrace();
    System.exit(1);
}
