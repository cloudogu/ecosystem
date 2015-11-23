# cesi/sonar
FROM cesi/java
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

ENV SONAR_VERSION 5.2
ENV SONARQUBE_HOME /opt/sonar

# mark as webapp for nginx
ENV SERVICE_TAGS webapp

RUN apt-get update -y \
    && apt-get -y install procps mysql-client \
    && cd /tmp \
    && curl -L -O https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-${SONAR_VERSION}.zip \
    && unzip sonarqube-${SONAR_VERSION}.zip \
    && mv sonarqube-${SONAR_VERSION} ${SONARQUBE_HOME} \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# copy templates
ADD conf/sonar.properties ${SONARQUBE_HOME}/conf/sonar.properties.tpl

# copy sonar-cas plugin (into wrong folder; correct folder would be: /var/lib/sonar/extensions/plugins/)
# is moved to right folder via startup.sh
COPY sonar-cas-plugin-0.3-TRIO-SNAPSHOT.jar ${SONARQUBE_HOME}/sonar-cas-plugin-0.3-TRIO-SNAPSHOT.jar

# create user
RUN useradd -d "$SONARQUBE_HOME" -u 1000 -m -s /bin/bash sonar
RUN chown -R sonar:sonar ${SONARQUBE_HOME}

# add startscript
ADD ./startup.sh /startup.sh
RUN chmod +x /startup.sh

EXPOSE 9000
CMD /startup.sh
