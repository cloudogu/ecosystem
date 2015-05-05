#this dockerfile shows how to deploy a WAR application within a tomcat
#It uses cesi/java as base container to provide a JDK
# cesi/cas
FROM cesi/java
MAINTAINER triology <cloudogu@triology.de>
ENV YOURAPPLICATION_VERSION 4.0.1
#RUN apt-get update && apt-get install -y tomcat7 -qq
ENV TOMCAT_MAJOR_VERSION 8
ENV TOMCAT_VERSION 8.0.21
ENV CATALINA_BASE /opt/apache-tomcat
ENV CATALINA_PID /var/run/tomcat7.pid
ENV CATALINA_SH ${CATALINA_BASE}/bin/catalina.sh

# create user for your application
#RUN /usr/sbin/useradd --home-dir /opt/apache-tomcat --shell /bin/bash tomcat

RUN useradd -r -u 1000 -m -c "application role account" -d /var/lib/yourapplication -s /bin/bash applicationuser
# install tomcat
RUN curl --fail --silent --location --retry 3 \
			http://mirror.arcor-online.net/www.apache.org/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz \
		| gunzip \
		| tar x -C /opt \
		&& mv /opt/apache-tomcat-* ${CATALINA_BASE} \
		&& rm -rf ${CATALINA_BASE}/webapps/*

WORKDIR /tmp/

RUN mkdir -p /tmp/YOURAPPLICATION/ \
   && mkdir ${CATALINA_BASE}/YOURAPPLICATION// \
   && curl --fail --silent --location --retry 3 -o YOURAPPLICATION.war \
    https://www.urltoyourdeployable.com/YOURAPPLICATION.war\
   && cp YOURAPPLICATION.war ${CATALINA_BASE}/webapps/YOURAPPLICATION/ \
   && cd ${CATALINA_BASE}/webapps/YOURAPPLICATION/ \
   && jar xvf YOURAPPLICATION.war \
   && rm -f YOURAPPLICATION.war \
   && rm -rf WEB-INF/sampleproperties.properties
   
RUN chown -R applicationuser:applicationuser ${CATALINA_BASE}

# copy resource templates
ADD resources/ /resources


ENV SERVICE_TAGS webapp
 
# start tomcat as user tomcat
CMD startup.sh
