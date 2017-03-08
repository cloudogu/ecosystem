import hudson.model.JDK
import hudson.tools.JDKInstaller
import hudson.tools.InstallSourceProperty
import jenkins.model.Jenkins

def descriptor = new JDK.DescriptorImpl();
def javaInstallations = descriptor.getInstallations();
def isInstalled = false;
def jdkName = "OracleJDK8"

for (javaInstallation in javaInstallations) {
  if(jdkName.equals(javaInstallation.getName())){
    isInstalled = true;
  }
}

if (!isInstalled) {
    def jdkInstaller = new JDKInstaller('jdk-8u121-oth-JPR', true)
    def jdk = new JDK(jdkName, null, [new InstallSourceProperty([jdkInstaller])])
    //descriptor.setInstallations(jdk)
    def newInstallations = new JDK[javaInstallations.length + 1]
    for (int i = 0; i < javaInstallations.length; i++) {
      newInstallations[i] = javaInstallations[i];
    }
    newInstallations[javaInstallations.length] = jdk;
    descriptor.setInstallations(newInstallations);
}
