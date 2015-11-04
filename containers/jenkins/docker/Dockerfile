# cesi/scm
FROM cesi/java
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

# Dockerfile based on https://github.com/cloudbees/jenkins-ci.org-docker/blob/f313389f8ab728d7b4207da36804ea54415c830b/1.580.1/Dockerfile

ENV JENKINS_HOME /var/lib/jenkins

# Jenkins is ran with user `jenkins`, uid = 1000
# If you bind mount a volume from host/vloume from a data container,
# ensure you use same uid
RUN useradd -d "$JENKINS_HOME" -u 1000 -m -s /bin/bash jenkins

# Jenkins home directoy is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME /var/lib/jenkins

# jenkins version
ENV JENKINS_VERSION 1.609.2

# could use ADD but this one does not check Last-Modified header
# see https://github.com/docker/docker/issues/8331
RUN curl -L http://mirrors.jenkins-ci.org/war-stable/${JENKINS_VERSION}/jenkins.war -o /jenkins.war

# add cas-plugin
RUN curl -L http://updates.jenkins-ci.org/latest/cas-plugin.hpi -o /cas-plugin.hpi
RUN chown jenkins:jenkins /cas-plugin.hpi
RUN chmod 755 /cas-plugin.hpi

# add jenkins config file template, including changes for cas plugin
ADD ./resources/var/lib/jenkins/config.xml.tpl /config.xml.tpl

# mark as webapp for nginx
ENV SERVICE_TAGS webapp

# startscript
ADD ./startup.sh /startup.sh
RUN chmod +x /startup.sh

# for main web interface:
EXPOSE 8080

USER jenkins

# start jenkins
CMD /startup.sh
