# cesi/nexus
FROM cesi/java
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

# dockerfile based on https://registry.hub.docker.com/u/sonatype/nexus/dockerfile/

# The version of nexus to install
ENV NEXUS_VERSION 2.11.1-01

RUN mkdir -p /opt/sonatype/nexus \
  && curl --fail --silent --location --retry 3 \
    http://download.sonatype.com/nexus/oss/nexus-${NEXUS_VERSION}-bundle.tar.gz \
  | gunzip \
  | tar x -C /tmp nexus-${NEXUS_VERSION} \
  && mv /tmp/nexus-${NEXUS_VERSION}/* /opt/sonatype/nexus/ \
  && rm -rf /tmp/nexus-${NEXUS_VERSION}

RUN useradd -r -u 1000 -m -c "nexus role account" -d /var/lib/nexus -s /bin/false nexus

VOLUME /var/lib/nexus

ENV SERVICE_TAGS webapp

# startscript
ADD ./startup.sh /startup.sh
RUN chmod +x /startup.sh

# cas plugin
ADD resources/nexus-cas-plugin-1.2.2-SNAPSHOT /opt/sonatype/nexus/resources/nexus-cas-plugin-1.2.2-SNAPSHOT/
ADD resources/cas-plugin.xml.tpl /opt/sonatype/nexus/resources/cas-plugin.xml.tpl

EXPOSE 8081
USER nexus
WORKDIR /opt/sonatype/nexus
CMD /startup.sh
