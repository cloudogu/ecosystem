# cesi/cas
FROM registry.cloudogu.com/official/java:8u77-1
MAINTAINER Michael Behlendorf <michael.behlendorf@cloudogu.com>

ENV CAS_VERSION 4.0.7.6
ENV TOMCAT_MAJOR_VERSION 8
ENV TOMCAT_VERSION 8.0.36
ENV CATALINA_BASE /opt/apache-tomcat
ENV CATALINA_PID /var/run/tomcat7.pid
ENV CATALINA_SH ${CATALINA_BASE}/bin/catalina.sh

# create cas user
#RUN useradd -r -u 1000 -m -c "cas role account" -d /var/lib/cas -s /bin/bash cas
RUN addgroup -S -g 1000 cas && adduser -S -h /var/lib/cas -s /bin/bash -G cas -u 1000 cas

# install tomcat
RUN curl --fail --silent --location --retry 3 \
			http://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz \
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
    && curl -L https://github.com/cloudogu/cas/releases/download/v${CAS_VERSION}/cas-${CAS_VERSION}.war -o ${CATALINA_BASE}/webapps/cas/cas.war \
	  && cd ${CATALINA_BASE}/webapps/cas/ \
    && unzip cas.war \
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
