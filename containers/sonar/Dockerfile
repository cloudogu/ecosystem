# cesi/sonar
FROM registry.cloudogu.com/official/java:8u77-1
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

ENV SONAR_VERSION 5.3
ENV SONARQUBE_HOME /opt/sonar

# mark as webapp for nginx
ENV SERVICE_TAGS webapp

# there seems to be an ssl problem with curl and bintray.com, that is why the
# --insecure flag was passed to curl. we should keep this in mind and try to
# remove it in the future
RUN apk add --update procps mysql-client \
    && cd /tmp \
    && curl --insecure -L -O https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-${SONAR_VERSION}.zip \
    && unzip sonarqube-${SONAR_VERSION}.zip \
    && mv sonarqube-${SONAR_VERSION} ${SONARQUBE_HOME} \
    && rm -rf /var/cache/apk/*

# copy templates
ADD conf/sonar.properties ${SONARQUBE_HOME}/conf/sonar.properties.tpl

# copy sonar-cas plugin (into wrong folder; correct folder would be: /var/lib/sonar/extensions/plugins/)
# is moved to right folder via startup.sh
COPY sonar-cas-plugin-0.3-TRIO-SNAPSHOT.jar ${SONARQUBE_HOME}/sonar-cas-plugin-0.3-TRIO-SNAPSHOT.jar

# create user
RUN addgroup -S -g 1000 sonar && adduser -S -h "$SONARQUBE_HOME" -s /bin/bash -G sonar -u 1000 sonar
#RUN useradd -d "$SONARQUBE_HOME" -u 1000 -m -s /bin/bash sonar
RUN chown -R sonar:sonar ${SONARQUBE_HOME}

# add startscript
ADD ./startup.sh /startup.sh
RUN chmod +x /startup.sh

# add user script
ADD ./resources/sonaradmingroup.sh /sonaradmingroup.sh
RUN chmod +x /sonaradmingroup.sh

# add mailconfig
ADD ./resources/sonarmailconfig.sh /sonarmailconfig.sh
RUN chmod +x /sonarmailconfig.sh

EXPOSE 9000
CMD /startup.sh
