# cesi/scm
FROM cesi/java
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
    && chown -R scm:scm /opt/scm-server \
    && mkdir -p ${SCM_HOME} \
    && chown scm:scm ${SCM_HOME} \
    && rm -rf /tmp/* /var/cache/apk/*

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
