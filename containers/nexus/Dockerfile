# registry.cloudogu.com/official/nexus
FROM registry.cloudogu.com/official/java:8u77-1
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

# dockerfile based on https://registry.hub.docker.com/u/sonatype/nexus/dockerfile/

# The version of nexus to install
ENV NEXUS_VERSION 2.11.1-01
ENV CAS_PLUGIN_VERSION 1.2.2-SNAPSHOT

RUN mkdir -p /opt/sonatype/nexus \
  && curl --fail --silent --location --retry 3 \
    http://download.sonatype.com/nexus/oss/nexus-${NEXUS_VERSION}-bundle.tar.gz \
  | gunzip \
  | tar x -C /tmp nexus-${NEXUS_VERSION} \
  && mv /tmp/nexus-${NEXUS_VERSION}/* /opt/sonatype/nexus/ \
  && rm -rf /tmp/nexus-${NEXUS_VERSION}

RUN addgroup -S -g 1000 nexus && adduser -S -h /var/lib/nexus -s /bin/false -G nexus -u 1000 nexus

VOLUME /var/lib/nexus

ENV SERVICE_TAGS webapp

# startscript
ADD ./startup.sh /startup.sh
ADD ./groupMapping.sh /groupMapping.sh
RUN chmod +x /startup.sh
RUN chmod +x /groupMapping.sh

# cas plugin
ADD resources/nexus-cas-plugin-${CAS_PLUGIN_VERSION} /opt/sonatype/nexus/resources/nexus-cas-plugin-${CAS_PLUGIN_VERSION}/
ADD resources/cas-plugin.xml.tpl /opt/sonatype/nexus/resources/cas-plugin.xml.tpl

EXPOSE 8081
USER nexus
WORKDIR /opt/sonatype/nexus
CMD /startup.sh
