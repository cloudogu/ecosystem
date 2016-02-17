# cesi/nexus

FROM cesi/java
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

# dockerfile based on https://registry.hub.docker.com/u/sonatype/nexus/dockerfile/

# The version of nexus to install
ENV NEXUS_VERSION 2.11.4-01

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

EXPOSE 8081
USER nexus
WORKDIR /opt/sonatype/nexus
CMD java \
  -server -XX:MaxPermSize=192m -Djava.net.preferIPv4Stack=true -Xms256m -Xmx1g \
  -Djavax.net.ssl.trustStore=/etc/ces/ssl/truststore.jks \
  -Djavax.net.ssl.trustStorePassword=changeit \
  -Djava.awt.headless=true \
  -Dnexus-work=/var/lib/nexus -Dnexus-webapp-context-path=/nexus \
  -cp conf/:`(echo lib/*.jar) | sed -e "s/ /:/g"` \
  org.sonatype.nexus.bootstrap.Launcher ./conf/jetty.xml ./conf/jetty-requestlog.xml
