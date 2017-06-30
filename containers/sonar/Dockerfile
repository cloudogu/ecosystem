FROM registry.cloudogu.com/official/java:8u121-4
MAINTAINER Sebastian Sdorra <sebastian.sdorra@cloudogu.com>

ENV SONAR_VERSION=5.6.3 \
    SONARQUBE_HOME=/opt/sonar \
    # mark as webapp for nginx
    SERVICE_TAGS=webapp

RUN set -x \
    && apk add --no-cache procps postgresql-client \
    && mkdir /opt \
    && cd /tmp \
    && curl -L -O https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-${SONAR_VERSION}.zip \
    && unzip sonarqube-${SONAR_VERSION}.zip \
    && mv sonarqube-${SONAR_VERSION} ${SONARQUBE_HOME} \
    && rm -rf /var/cache/apk/* \

    # create user
    && addgroup -S -g 1000 sonar \
    && adduser -S -h "$SONARQUBE_HOME" -s /bin/bash -G sonar -u 1000 sonar \
    && chown -R sonar:sonar ${SONARQUBE_HOME}

# Copy resources
# Includes copying sonar-cas plugin (into wrong folder; correct folder would be: /var/lib/sonar/extensions/plugins/)
# is moved to right folder via startup.sh
COPY ./resources /

EXPOSE 9000

CMD ["/startup.sh"]
