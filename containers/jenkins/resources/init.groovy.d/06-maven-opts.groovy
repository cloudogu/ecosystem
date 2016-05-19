import jenkins.model.*;
import hudson.security.*;

def opts = "-Djava.awt.headless=true -Djava.net.preferIPv4Stack=true "
opts    += "-Djavax.net.ssl.trustStore=\"/var/lib/jenkins/truststore.jks\" "
opts    += "-Djavax.net.ssl.trustStorePassword=changeit"

def instance = Jenkins.getInstance();

mms = instance.getDescriptor("hudson.maven.MavenModuleSet");
mms.setGlobalMavenOpts(opts);
mms.save();

instance.save();
