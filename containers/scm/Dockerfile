# cesi/scm
FROM registry.cloudogu.com/official/java:8u77-1
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>


# scm-server environment
ENV SCM_VERSION 1.46
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

# enable jetty restart hook
COPY resources/WebAppRestartHook.class /opt/scm-server/conf/sonia/scm/ces/WebAppRestartHook.class

# modify server configuration
COPY resources/logging.xml /opt/scm-server/conf/logging.xml
COPY resources/server-config.xml /opt/scm-server/conf/server-config.xml

# mark as webapp for nginx
ENV SERVICE_TAGS webapp

# startscript
ADD ./startup.sh /startup.sh
RUN chmod +x /startup.sh

# cas plugin
ADD resources/cas_plugin.xml.tpl /opt/scm-server/conf/cas_plugin.xml.tpl
ADD resources/mail.xml.tpl /opt/scm-server/conf/mail.xml.tpl
ADD resources/pluginlist /opt/scm-server/conf/pluginlist

# run scm-manager
WORKDIR ${SCM_HOME}
VOLUME ${SCM_HOME}
EXPOSE 8080
USER scm


# start scm
CMD /startup.sh
