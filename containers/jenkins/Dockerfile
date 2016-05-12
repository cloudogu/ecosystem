# cesi/scm
FROM registry.cloudogu.com/official/java:8u77-1
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

# Dockerfile based on https://github.com/cloudbees/jenkins-ci.org-docker/blob/f313389f8ab728d7b4207da36804ea54415c830b/1.580.1/Dockerfile

ENV JENKINS_HOME /var/lib/jenkins

# Install openssh-client
RUN apk add --update openssh-client \
	&& rm -rf /var/cache/apk/*

# Jenkins is ran with user `jenkins`, uid = 1000
# If you bind mount a volume from host/volume from a data container,
# ensure you use same uid
RUN addgroup -S -g 1000 jenkins && adduser -S -h "$JENKINS_HOME" -s /bin/bash -G jenkins -u 1000 jenkins
# Jenkins home directoy is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME /var/lib/jenkins

# jenkins version
ENV JENKINS_VERSION 1.609.2

# could use ADD but this one does not check Last-Modified header
# see https://github.com/docker/docker/issues/8331
RUN curl -L http://mirrors.jenkins-ci.org/war-stable/${JENKINS_VERSION}/jenkins.war -o /jenkins.war

# add jenkins config file template, including changes for cas plugin and mailConfiguration
ADD ./resources /var/tmp/resources
RUN chown -R jenkins:jenkins /var/tmp/resources

# add cas-plugin
RUN curl -L https://github.com/sdorra/jenkins-cas-plugin/releases/download/cas-plugin-1.3.0-CES-1/cas-plugin.hpi -o /var/tmp/cas-plugin.hpi
RUN chown jenkins:jenkins /var/tmp/cas-plugin.hpi
RUN chmod 755 /var/tmp/cas-plugin.hpi

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
