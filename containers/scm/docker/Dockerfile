# cesi/scm
FROM cesi/java
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>


# scm-server environment
ENV SCM_VERSION 1.46
ENV SCM_PKG_URL https://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/scm-server/${SCM_VERSION}/scm-server-${SCM_VERSION}-app.tar.gz
ENV SCM_HOME /var/lib/scm
ADD default /etc/default/scm-server

## install scm-server
RUN apk add --update mercurial \
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

# run scm-manager
WORKDIR ${SCM_HOME}
VOLUME ${SCM_HOME}
EXPOSE 8080
USER scm
CMD ["/opt/scm-server/bin/scm-server"]
