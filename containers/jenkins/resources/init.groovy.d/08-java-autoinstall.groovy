import hudson.model.JDK
import hudson.tools.JDKInstaller
import hudson.tools.InstallSourceProperty
import jenkins.model.Jenkins

def descriptor = new JDK.DescriptorImpl();

if (!descriptor.getInstallations()) {
    def jdkInstaller = new JDKInstaller('jdk-8u102-oth-JPR', true)
    def jdk = new JDK("jdk8u102", null, [new InstallSourceProperty([jdkInstaller])])
    descriptor.setInstallations(jdk)
}
