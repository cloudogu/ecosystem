# registry.cloudogu.com/official/nexus
FROM registry.cloudogu.com/official/java:8u151-2
MAINTAINER Sebastian Sdorra <sebastian.sdorra@cloudogu.com>

# dockerfile based on https://registry.hub.docker.com/u/sonatype/nexus/dockerfile/

# The version of nexus to install
ENV TINI_VERSION=0.15.0 \
    NEXUS_VERSION=2.14.3-02 \
    NEXUS_CLAIM_VERSION=0.1.0 \
    CAS_PLUGIN_VERSION=1.2.2-SNAPSHOT \
    SERVICE_TAGS=webapp
    

RUN set -x \
  # add nexus user and group
  && addgroup -S -g 1000 nexus \
  && adduser -S -h /var/lib/nexus -s /bin/false -G nexus -u 1000 nexus \

  # install tini
  && curl --fail --silent --location --retry 3 -o /bin/tini \
    https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64 \
  && chmod +x /bin/tini \

  # install nexus
  && mkdir -p /opt/sonatype/nexus \
  && curl --fail --silent --location --retry 3 \
    http://download.sonatype.com/nexus/oss/nexus-${NEXUS_VERSION}-bundle.tar.gz \
  | gunzip \
  | tar x -C /tmp nexus-${NEXUS_VERSION} \
  && mv /tmp/nexus-${NEXUS_VERSION}/* /opt/sonatype/nexus/ \
  && rm -rf /tmp/nexus-${NEXUS_VERSION} \

  # install nexus-claim
  && curl --fail --silent --location --retry 3 \
    https://github.com/cloudogu/nexus-claim/releases/download/v${NEXUS_CLAIM_VERSION}/nexus-claim-${NEXUS_CLAIM_VERSION}.tar.gz \
  | gunzip \
  | tar x -C /usr/bin

VOLUME /var/lib/nexus

COPY resources /

EXPOSE 8081

USER nexus

WORKDIR /opt/sonatype/nexus

ENTRYPOINT [ "/bin/tini", "--" ]
CMD ["/startup.sh"]
