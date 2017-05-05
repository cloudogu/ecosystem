# cesi/sonar
FROM registry.cloudogu.com/official/java:8u121-3
MAINTAINER Sebastian Sdorra <sebastian.sdorra@cloudogu.com>

ENV SONAR_VERSION=5.6.3 \
    SONARQUBE_HOME=/opt/sonar \
    # mark as webapp for nginx
    SERVICE_TAGS=webapp
# Copy resources
# Includes copying sonar-cas plugin (into wrong folder; correct folder would be: /var/lib/sonar/extensions/plugins/)
# is moved to right folder via startup.sh
COPY ./resources /

# there seems to be an ssl problem with curl and bintray.com, that is why the
# --insecure flag was passed to curl. we should keep this in mind and try to
# remove it in the future
RUN apk add --update procps postgresql-client \
    && cd /tmp \
    && curl --insecure -L -O https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-${SONAR_VERSION}.zip \
    && unzip sonarqube-${SONAR_VERSION}.zip \
    && mv sonarqube-${SONAR_VERSION} ${SONARQUBE_HOME} \
    && rm -rf /var/cache/apk/* \

    # create user
    && addgroup -S -g 1000 sonar && adduser -S -h "$SONARQUBE_HOME" -s /bin/bash -G sonar -u 1000 sonar \
    #RUN useradd -d "$SONARQUBE_HOME" -u 1000 -m -s /bin/bash sonar
    && chown -R sonar:sonar ${SONARQUBE_HOME}

EXPOSE 9000

CMD ["/startup.sh"]
