import jenkins.model.*;
import hudson.*
import hudson.model.*
import hudson.tasks.*
import hudson.tools.*

def instance = Jenkins.getInstance();

def mavenDesc = instance.getDescriptor("hudson.tasks.Maven");
def installations = mavenDesc.getInstallations();
println "DEBUG: Existing Maven installations:";
boolean mavenInstalled = false;
if (installations != null) {
  installations.each { installation ->
    println "DEBUG: installation name: ${installation}";
    def inst = "${installation}"
    if (inst.contains("Maven_3.3.9")) {
      println "DEBUG: Maven is already installed";
      mavenInstalled = true;
    } else {
      println "DEBUG: That's not Maven";
    }
  }
} else {
  println "DEBUG: no maven installations";
}
if (!mavenInstalled) {
  def mvInstaller = new Maven.MavenInstaller("3.3.9");
  def instSourcProp = new InstallSourceProperty([mvInstaller]);
  def mavenInst = new Maven.MavenInstallation("Maven_3.3.9", null, [instSourcProp]);
  mavenDesc.setInstallations(mavenInst);
  mavenDesc.save();
  instance.save();
}
