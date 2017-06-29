FROM registry.cloudogu.com/official/java:8u121-4
MAINTAINER Sebastian Sdorra <sebastian.sdorra@cloudogu.com>

# scm-server environment
ENV SCM_VERSION=1.54 \
    SCM_HOME=/var/lib/scm \
    SSL_CERT_FILE=/opt/scm-server/conf/ca-certificates.crt \
    # mark as webapp for nginx
    SERVICE_TAGS=webapp
ENV SCM_PKG_URL=https://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/scm-server/${SCM_VERSION}/scm-server-${SCM_VERSION}-app.tar.gz

## install scm-server
RUN set -x \
    && apk add --no-cache mercurial jq \
    && curl -Lks ${SCM_PKG_URL} -o /tmp/scm-server.tar.gz \
    && addgroup -S -g 1000 scm \
    && adduser -S -h /opt/scm-server -s /bin/bash -G scm -u 1000 scm \
    && gunzip /tmp/scm-server.tar.gz \
    && mkdir /opt \
    && tar -C /opt -xf /tmp/scm-server.tar \
    && cd /tmp \

    # install scm-script-plugin
    && mkdir -p WEB-INF/lib \
    && curl -Lks http://repo1.maven.org/maven2/org/codehaus/groovy/groovy-all/2.4.6/groovy-all-2.4.6.jar -o /tmp/WEB-INF/lib/groovy-all-2.4.6.jar \
    && curl -Lks http://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/plugins/scm-script-plugin/1.5/scm-script-plugin-1.5.jar -o /tmp/WEB-INF/lib/scm-script-plugin-1.5.jar \
    && zip -u /opt/scm-server/var/webapp/scm-webapp.war WEB-INF/lib/* \

    # cleanup
    && rm -rf /tmp/* /var/cache/apk/* \

    # set mercurial system ca-certificates
    # see https://github.com/cloudogu/ecosystem/issues/193
    && mkdir /etc/mercurial \
    && printf "[web]\ncacerts = /opt/scm-server/conf/ca-certificates.crt\n" > /etc/mercurial/hgrc

# copy resources after package installation, that we can override package defaults
COPY ./resources /

# set permissions
RUN mkdir -p ${SCM_HOME} \
    && chown scm:scm ${SCM_HOME} \
    && chown -R scm:scm /opt/scm-server

# run scm-manager
WORKDIR ${SCM_HOME}

VOLUME ${SCM_HOME}

EXPOSE 8080

USER scm

# start scm
CMD ["/startup.sh"]
