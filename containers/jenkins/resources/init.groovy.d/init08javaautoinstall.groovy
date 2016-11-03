import hudson.model.JDK
import hudson.tools.JDKInstaller
import hudson.tools.InstallSourceProperty
import jenkins.model.Jenkins

def descriptor = new JDK.DescriptorImpl();

if (!descriptor.getInstallations()) {
    def jdkInstaller = new JDKInstaller('jdk-8u112-oth-JPR', true)
    def jdk = new JDK("jdk8u112", null, [new InstallSourceProperty([jdkInstaller])])
    descriptor.setInstallations(jdk)
}
