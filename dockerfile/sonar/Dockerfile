# cesi/sonar
FROM cesi/java
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

ENV SONAR_VERSION 3.7.4
ENV SONAR_HOME /var/lib/sonar
# mark as webapp for nginx
ENV SERVICE_TAGS webapp

ADD ./startup.sh /startup.sh

RUN apt-get update -y \
    && apt-get -y install procps \
    && cd /tmp \
    && curl -L -O http://dist.sonar.codehaus.org/sonar-${SONAR_VERSION}.zip && unzip sonar-${SONAR_VERSION}.zip \
    && mv sonar-${SONAR_VERSION} /opt/sonar \
    && sed -i 's@#sonar.web.context.*@sonar.web.context: /sonar@g' /opt/sonar/conf/sonar.properties \
    && chmod +x /startup.sh

# create user
RUN useradd -d "$SONAR_HOME" -u 1000 -m -s /bin/bash sonar
RUN chown -R sonar:sonar /opt/sonar

USER sonar

EXPOSE 9000

CMD /startup.sh
