# cesi/scm
FROM registry.cloudogu.com/official/java:8u121-4
MAINTAINER Sebastian Sdorra <sebastian.sdorra@cloudogu.com>

# Dockerfile based on https://github.com/cloudbees/jenkins-ci.org-docker/blob/f313389f8ab728d7b4207da36804ea54415c830b/1.580.1/Dockerfile

    # jenkins home configuration
ENV JENKINS_HOME=/var/lib/jenkins \
    # mark as webapp for nginx
    SERVICE_TAGS=webapp \
    # jenkins version
    JENKINS_VERSION=2.60.1 \
    # glibc for alpine version
    GLIBC_VERSION=2.23-r3

# Jenkins is ran with user `jenkins`, uid = 1000
# If you bind mount a volume from host/volume from a data container,
# ensure you use same uid
RUN set -x \
 && addgroup -S -g 1000 jenkins \
 && adduser -S -h "$JENKINS_HOME" -s /bin/bash -G jenkins -u 1000 jenkins \
 # install coreutils, ttf-dejavu, openssh and scm clients
 # coreutils and ttf-dejavu is required because of java.awt.headless problem: 
 # - https://wiki.jenkins.io/display/JENKINS/Jenkins+got+java.awt.headless+problem
 && apk add --no-cache coreutils ttf-dejavu openssh-client git subversion mercurial \
 # could use ADD but this one does not check Last-Modified header
 # see https://github.com/docker/docker/issues/8331
 && curl -L http://mirrors.jenkins-ci.org/war-stable/${JENKINS_VERSION}/jenkins.war -o /jenkins.war \
 # set git system ca-certificates
 && git config --system http.sslCaInfo /var/lib/jenkins/ca-certificates.crt \
 # set mercurial system ca-certificates
 && mkdir /etc/mercurial \
 && printf "[web]\ncacerts = /var/lib/jenkins/ca-certificates.crt\n" > /etc/mercurial/hgrc \
 # set subversion system ca-certificates
 && mkdir /etc/subversion \
 && printf "[global]\nssl-authority-files=/var/lib/jenkins/ca-certificates.crt\n" > /etc/subversion/server \

 # install glibc for alpine
 # that jenkins is able to execute Oracle JDK, which can be installed over the global tool installer
 && apk add --no-cache libstdc++ \
 && curl -Lo /tmp/glibc.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" \
 && apk add --no-cache --allow-untrusted /tmp/glibc.apk \
 && curl -Lo /tmp/glibc-bin.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" \
 && apk add --no-cache --allow-untrusted /tmp/glibc-bin.apk \
 && curl -Lo /tmp/glibc-i18n.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-i18n-${GLIBC_VERSION}.apk" \
 && apk add --no-cache --allow-untrusted /tmp/glibc-i18n.apk \

 # do not abort https://github.com/sgerrand/alpine-pkg-glibc/issues/5
 && (/usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true ) \
 && echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh \
 && /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib \

 # cleanup
 && rm -rf /tmp/* /var/cache/apk/*

# Jenkins home directoy is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME /var/lib/jenkins

# add jenkins config file template, including changes for cas plugin and mailConfiguration
COPY ./resources /

# switch to jenkins user
USER jenkins

# for main web interface:
EXPOSE 8080

# start jenkins
CMD ["/startup.sh"]
