# cesi/sonar
FROM cesi/java
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

ENV SONAR_VERSION 5.1
ENV SONAR_HOME /var/lib/sonar

# mark as webapp for nginx
ENV SERVICE_TAGS webapp

RUN apt-get update -y \
    && apt-get -y install procps mysql-client \
    && cd /tmp \
    && curl -L -O http://dist.sonar.codehaus.org/sonarqube-${SONAR_VERSION}.zip \
    && unzip sonarqube-${SONAR_VERSION}.zip \
    && mv sonarqube-${SONAR_VERSION} /opt/sonar \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# copy templates
ADD conf/sonar.properties /opt/sonar/conf/sonar.properties.tpl
ADD conf/wrapper.conf /opt/sonar/conf/wrapper.conf.tpl

# copy sonar-cas plugin (into wrong folder; correct folder would be: /var/lib/sonar/extensions/plugins/)
# is moved to right folder via startup.sh
ADD sonar-cas-plugin-0.3-TRIO-SNAPSHOT.jar /opt/sonar/sonar-cas-plugin-0.3-TRIO-SNAPSHOT.jar

# create user
RUN useradd -d "$SONAR_HOME" -u 1000 -m -s /bin/bash sonar
RUN chown -R sonar:sonar /opt/sonar

# add startscript
ADD ./startup.sh /startup.sh
RUN chmod +x /startup.sh

EXPOSE 9000
CMD /startup.sh
