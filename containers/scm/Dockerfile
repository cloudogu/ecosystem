# cesi/scm
FROM registry.cloudogu.com/official/java:8u77-1
MAINTAINER Sebastian Sdorra <sebastian.sdorra@cloudogu.com>


# scm-server environment
ENV SCM_VERSION 1.48
ENV SCM_PKG_URL https://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/scm-server/${SCM_VERSION}/scm-server-${SCM_VERSION}-app.tar.gz
ENV SCM_HOME /var/lib/scm
ADD default /etc/default/scm-server

## install scm-server
RUN apk add --update mercurial jq \
    && curl -Lks ${SCM_PKG_URL} -o /tmp/scm-server.tar.gz \
    && addgroup -S -g 1000 scm \
    && adduser -S -h /opt/scm-server -s /bin/bash -G scm -u 1000 scm \
    && gunzip /tmp/scm-server.tar.gz \
    && tar -C /opt -xf /tmp/scm-server.tar \
    && cd /tmp \

    # install scm-script-plugin
    && mkdir -p WEB-INF/lib \
    && curl -Lks http://repo1.maven.org/maven2/org/codehaus/groovy/groovy-all/2.4.6/groovy-all-2.4.6.jar -o /tmp/WEB-INF/lib/groovy-all-2.4.6.jar \
    && curl -Lks http://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/plugins/scm-script-plugin/1.5/scm-script-plugin-1.5.jar -o /tmp/WEB-INF/lib/scm-script-plugin-1.5.jar \
    && zip -u /opt/scm-server/var/webapp/scm-webapp.war WEB-INF/lib/* \

    # set permissions
    && chown -R scm:scm /opt/scm-server \
    && mkdir -p ${SCM_HOME} \
    && chown scm:scm ${SCM_HOME} \

    # cleanup
    && rm -rf /tmp/* /var/cache/apk/*

# modify server configuration
COPY resources/conf/* /opt/scm-server/conf/
COPY resources/utils/*.class /opt/scm-server/conf/sonia/scm/ces/
COPY resources/init.script.d /opt/scm-server/init.script.d

# startscript
COPY ./startup.sh /startup.sh

# mark as webapp for nginx
ENV SERVICE_TAGS webapp

# run scm-manager
WORKDIR ${SCM_HOME}
VOLUME ${SCM_HOME}
EXPOSE 8080
USER scm


# start scm
CMD /startup.sh
