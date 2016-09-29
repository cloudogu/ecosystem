# cesi/scm
FROM registry.cloudogu.com/official/java:8u102-1
MAINTAINER Sebastian Sdorra <sebastian.sdorra@cloudogu.com>

# Dockerfile based on https://github.com/cloudbees/jenkins-ci.org-docker/blob/f313389f8ab728d7b4207da36804ea54415c830b/1.580.1/Dockerfile

    # jenkins home configuration
ENV JENKINS_HOME=/var/lib/jenkins \
    # mark as webapp for nginx
    SERVICE_TAGS=webapp \
    # jenkins version
    JENKINS_VERSION=2.7.4

# Jenkins is ran with user `jenkins`, uid = 1000
# If you bind mount a volume from host/volume from a data container,
# ensure you use same uid
RUN addgroup -S -g 1000 jenkins && adduser -S -h "$JENKINS_HOME" -s /bin/bash -G jenkins -u 1000 jenkins \
 # Install openssh and scm clients
 && apk add --update openssh-client git subversion mercurial \
 # could use ADD but this one does not check Last-Modified header
 # see https://github.com/docker/docker/issues/8331
 && curl -L http://mirrors.jenkins-ci.org/war-stable/${JENKINS_VERSION}/jenkins.war -o /jenkins.war \
 # add cas plugin to temp, will be installed by the startup script
 && curl -L https://github.com/sdorra/jenkins-cas-plugin/releases/download/cas-plugin-1.3.0-CES-1/cas-plugin.hpi -o /var/tmp/cas-plugin.hpi \
 # clear apk cache
 && rm -rf /var/cache/apk/* \
 # set git system ca-certificates
 && git config --system http.sslCaInfo /var/lib/jenkins/ca-certificates.crt \
 # set mercurial system ca-certificates
 && mkdir /etc/mercurial \
 && printf "[web]\ncacerts = /var/lib/jenkins/ca-certificates.crt\n" > /etc/mercurial/hgrc \
 # set subversion system ca-certificates
 && mkdir /etc/subversion \
 && printf "[global]\nssl-authority-files=/var/lib/jenkins/ca-certificates.crt\n" > /etc/subversion/server

# Jenkins home directoy is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME /var/lib/jenkins

# add jenkins config file template, including changes for cas plugin and mailConfiguration
ADD ./resources /var/tmp/resources

# startscript
ADD ./startup.sh /startup.sh

# switch to jenkins user
USER jenkins

# for main web interface:
EXPOSE 8080

# start jenkins
CMD /startup.sh
