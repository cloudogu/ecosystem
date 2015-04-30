# cesi/scm
FROM cesi/java
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>


# scm-server environment
ENV SCM_VERSION 1.45
ENV SCM_PKG_URL https://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/scm-server/${SCM_VERSION}/scm-server-${SCM_VERSION}-app.tar.gz
ENV SCM_HOME /var/lib/scm

# install scm-server
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt-get update \
    && apt-get install -qq -y mercurial \
    && curl -Lks "$SCM_PKG_URL" -o /root/scm-server.tar.gz \
    && /usr/sbin/useradd --create-home --home-dir /opt/scm-server --shell /bin/bash scm \
    && tar zxf /root/scm-server.tar.gz --strip=1 -C /opt/scm-server \
    && rm -f /root/scm-server.tar.gz \
    && chown -R scm:scm /opt/scm-server \
    && mkdir -p /var/lib/scm \
    && chown scm:scm /var/lib/scm \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# mark as webapp for nginx
ENV SERVICE_TAGS webapp

# run scm-manager
WORKDIR /var/lib/scm
VOLUME /var/lib/scm
EXPOSE 8080
USER scm
CMD ["/opt/scm-server/bin/scm-server"]
