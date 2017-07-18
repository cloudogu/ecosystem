import jenkins.model.*;
import hudson.slaves.EnvironmentVariablesNodeProperty;
import hudson.slaves.EnvironmentVariablesNodeProperty.Entry;

def jenkins = Jenkins.getInstance();

def opts = "-Djava.awt.headless=true -Djava.net.preferIPv4Stack=true "
opts    += "-Djavax.net.ssl.trustStore=/var/lib/jenkins/truststore.jks "
opts    += "-Djavax.net.ssl.trustStorePassword=changeit"

def found = false;
def globalNodeProperties = jenkins.getGlobalNodeProperties();
for ( def prop : globalNodeProperties){
  if (prop instanceof EnvironmentVariablesNodeProperty){
    def env = prop.getEnvVars();
    env.put("MAVEN_OPTS", opts);
    found = true;
  }
}

if (!found){
  def envProp = new EnvironmentVariablesNodeProperty(new Entry("MAVEN_OPTS", opts));
  globalNodeProperties.add(envProp);
}

jenkins.save();
