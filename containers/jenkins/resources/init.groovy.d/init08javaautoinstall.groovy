import hudson.model.JDK
import hudson.tools.JDKInstaller
import hudson.tools.InstallSourceProperty
import jenkins.model.Jenkins

def descriptor = new JDK.DescriptorImpl();

if (!descriptor.getInstallations()) {
    def jdkInstaller = new JDKInstaller('jdk-8u121-oth-JPR', true)
    def jdk = new JDK("OracleJDK8", null, [new InstallSourceProperty([jdkInstaller])])
    descriptor.setInstallations(jdk)
}
