import jenkins.model.*;
import hudson.*
import hudson.model.*
import hudson.tasks.*
import hudson.tools.*

def instance = Jenkins.getInstance();

def mavenDesc = instance.getDescriptor("hudson.tasks.Maven");
def installations = mavenDesc.getInstallations();
boolean isMavenInstalled = false;
if (installations != null) {
  installations.each { installation ->
    def inst = "${installation}"
    if (inst.contains("Maven3")) {
      isMavenInstalled = true;
    }
  }
}
if (!isMavenInstalled) {
  def mvInstaller = new Maven.MavenInstaller("3.3.9");
  def instSourcProp = new InstallSourceProperty([mvInstaller]);
  def mavenInst = new Maven.MavenInstallation("Maven3", null, [instSourcProp]);
  mavenInstallations = instance.getExtensionList(hudson.tasks.Maven.DescriptorImpl.class)[0];
  mavenInstallationsList = (mavenInstallations.installations as List);
  mavenInstallationsList.add(mavenInst);
  mavenInstallations.installations=mavenInstallationsList;
  mavenInstallations.save()
  instance.save();
}
