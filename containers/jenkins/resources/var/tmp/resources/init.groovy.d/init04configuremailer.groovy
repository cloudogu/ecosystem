import jenkins.model.*;

// based on https://github.com/r-hub/rhub-jenkins/blob/master/docker-entrypoint.sh#L87

def instance = Jenkins.getInstance();

// configure mail server
def mailer = instance.getDescriptor("hudson.tasks.Mailer");
// mailer.setReplyToAddress("");
mailer.setSmtpHost("postfix");
mailer.setUseSsl(false);
mailer.setSmtpPort("25");
mailer.setCharset("UTF-8");
// mailer.setSmtpAuth("", "");
mailer.save();


instance.save();
