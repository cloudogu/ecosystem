# cesi/cas
FROM cesi/java
MAINTAINER triology <cloudogu@triology.de>

ENV CAS_VERSION 4.0.1
ENV TOMCAT_MAJOR_VERSION 8
ENV TOMCAT_VERSION 8.0.22
ENV CATALINA_BASE /opt/apache-tomcat
ENV CATALINA_PID /var/run/tomcat7.pid
ENV CATALINA_SH ${CATALINA_BASE}/bin/catalina.sh

# create cas user
RUN useradd -r -u 1000 -m -c "cas role account" -d /var/lib/cas -s /bin/bash cas

# install tomcat
RUN curl --fail --silent --location --retry 3 \
			http://mirror.arcor-online.net/www.apache.org/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz \
		| gunzip \
		| tar x -C /opt \
		&& mv /opt/apache-tomcat-* ${CATALINA_BASE} \
		&& rm -rf ${CATALINA_BASE}/webapps/*

# copy server.xml to configure RemoteIpValve
ADD resources/server.xml ${CATALINA_BASE}/conf/server.xml

# copy setenv.sh to configure missing jvm settings
ADD resources/setenv.sh ${CATALINA_BASE}/bin/setenv.sh

# install cas webapp
RUN mkdir ${CATALINA_BASE}/webapps/cas/ \
    && curl --fail --silent --location --retry 3 -o ${CATALINA_BASE}/webapps/cas/cas.war \
		https://universe.triology.de/nexus/content/repositories/snapshots/de/triology/scm/universe/scmm-universe-cas/4.0.2-SCMMU-SNAPSHOT/scmm-universe-cas-4.0.2-SCMMU-20150507.125649-29.war \
    && cd ${CATALINA_BASE}/webapps/cas/ \
    && jar xvf cas.war \
    && rm -f cas.war

#customize cas.properties
RUN chown -R cas:cas ${CATALINA_BASE}

# copy resource templates
ADD resources/cas.properties.tpl /resources/cas.properties.tpl
ADD startup.sh /startup.sh
RUN chmod +x /startup.sh ${CATALINA_BASE}/bin/setenv.sh

# tag for nginx
ENV SERVICE_TAGS webapp

# expose tomcat port
EXPOSE 8080

# start tomcat as user tomcat
CMD /startup.sh
