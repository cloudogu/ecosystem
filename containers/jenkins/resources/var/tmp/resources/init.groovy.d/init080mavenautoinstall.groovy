// creates a global tool installer for maven.

import jenkins.model.*
import hudson.*
import hudson.model.*
import hudson.tasks.*
import hudson.tools.*

// the name M3 is chosen, because of the GitHub + Maven Pipeline sample
def mavenName = "M3"
def mavenVersion = "3.5.0"

def boolean isMavenAlreadyInstalled(def mavenName) {
  def descriptor = Jenkins.instance.getDescriptor("hudson.tasks.Maven")
  def installations = descriptor.getInstallations()
  if (installations != null) {
    installations.each { installation ->
      def inst = "${installation}"
      if (inst.contains(mavenName)) {
        return true
      }
    }
  }
  return false
}

def createMavenInstallation(def mavenName, def mavenVersion) { 
  def mvnInstaller = new Maven.MavenInstaller(mavenVersion)
  def instSourcProp = new InstallSourceProperty([mvnInstaller])
  return new Maven.MavenInstallation(mavenName, null, [instSourcProp])
}

def addMavenToInstallations(def installation) {
  mavenInstallations = Jenkins.instance.getExtensionList(hudson.tasks.Maven.DescriptorImpl.class)[0]
  mavenInstallationsList = (mavenInstallations.installations as List)
  mavenInstallationsList.add(installation)
  mavenInstallations.installations = mavenInstallationsList
  mavenInstallations.save()
  Jenkins.instance.save()
}

if (!isMavenAlreadyInstalled(mavenName)) {
  def installation = createMavenInstallation(mavenName, mavenVersion)
  addMavenToInstallations(installation)
}
