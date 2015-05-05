# cesi/cas
FROM cesi/java
MAINTAINER triology <cloudogu@triology.de>
ENV CAS_VERSION 4.0.1
#RUN apt-get update && apt-get install -y tomcat7 -qq
ENV TOMCAT_MAJOR_VERSION 8
ENV TOMCAT_VERSION 8.0.21
ENV CATALINA_BASE /opt/apache-tomcat
ENV CATALINA_PID /var/run/tomcat7.pid
ENV CATALINA_SH ${CATALINA_BASE}/bin/catalina.sh

# create user
#RUN /usr/sbin/useradd --home-dir /opt/apache-tomcat --shell /bin/bash tomcat

RUN useradd -r -u 1000 -m -c "cas role account" -d /var/lib/cas -s /bin/bash cas
# install tomcat
RUN curl --fail --silent --location --retry 3 \
			http://mirror.arcor-online.net/www.apache.org/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz \
		| gunzip \
		| tar x -C /opt \
		&& mv /opt/apache-tomcat-* ${CATALINA_BASE} \
		&& rm -rf ${CATALINA_BASE}/webapps/*

WORKDIR /tmp/

RUN mkdir -p /tmp/cas/ \
   && mkdir ${CATALINA_BASE}/webapps/cas/ \
   && curl --fail --silent --location --retry 3 -o cas.war \
    https://universe.triology.de/nexus/service/local/repositories/releases/content/de/triology/scm/universe/scmm-universe-cas/${CAS_VERSION}-SCMMU/scmm-universe-cas-${CAS_VERSION}-SCMMU.war\
   && cp cas.war ${CATALINA_BASE}/webapps/cas/ \
   && cd ${CATALINA_BASE}/webapps/cas/ \
   && jar xvf cas.war \
   && rm -f cas.war \
   && rm -rf WEB-INF/cas.properties
   
#customize cas.properties
   
RUN chown -R cas:cas ${CATALINA_BASE}

# copy resource templates
ADD resources/ /resources


ENV SERVICE_TAGS webapp
 
# start tomcat as user tomcat
CMD su - cas -c "${CATALINA_SH} run"
