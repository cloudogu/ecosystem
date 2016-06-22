import jenkins.model.*;
import hudson.*
import hudson.model.*
import hudson.tasks.*
import hudson.tools.*

def instance = Jenkins.getInstance();

def mavenDesc = instance.getDescriptor("hudson.tasks.Maven");
def mvInstaller = new Maven.MavenInstaller("3.3.9");
def instSourcProp = new InstallSourceProperty([mvInstaller]);
def mavenInst = new Maven.MavenInstallation("Maven_3.3.9", null, [instSourcProp]);
mavenDesc.setInstallations(mavenInst);
mavenDesc.save();

instance.save();
