# cesi/universeadm
FROM cesi/java
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

# mark as webapp for nginx
ENV SERVICE_TAGS webapp

# tomcat version
ENV TOMCAT_MAJOR_VERSION 8
ENV TOMCAT_VERSION 8.0.22

# universeam version
ENV UNIVERSEADM_VERSION 1.2.0

# home directory
ENV UNIVERSEADM_HOME /var/lib/universeadm/conf

# create user
RUN /usr/sbin/useradd --home-dir /opt/apache-tomcat --shell /bin/bash tomcat

# install tomcat
RUN curl --fail --silent --location --retry 3 \
			http://mirror.arcor-online.net/www.apache.org/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz \
		| gunzip \
		| tar x -C /opt \
		&& mv /opt/apache-tomcat-* /opt/apache-tomcat \
		&& chown -R tomcat:tomcat /opt/apache-tomcat \
		&& rm -rf /opt/apache-tomcat/logs \
		&& ln -s /var/lib/universeadm/logs /opt/apache-tomcat/logs \
		&& rm -rf /opt/apache-tomcat/webapps/*


# add setenv.sh
ADD resources/setenv.sh /opt/apache-tomcat/bin/setenv.sh
RUN chmod +x /opt/apache-tomcat/bin/setenv.sh

# install universeadm
RUN mkdir /opt/apache-tomcat/webapps/universeadm \
    && cd /opt/apache-tomcat/webapps/universeadm \
    && wget https://universe.triology.de/nexus/content/repositories/releases/de/triology/scm/universe/universeadm/${UNIVERSEADM_VERSION}/universeadm-${UNIVERSEADM_VERSION}.war \
		&& jar xvf universeadm-${UNIVERSEADM_VERSION}.war \
		&& rm -f universeadm-${UNIVERSEADM_VERSION}.war \
		&& chmod +x WEB-INF/cipher.sh

# fix permissions
RUN chown -R tomcat:tomcat /opt/apache-tomcat

# copy resource templates
ADD resources/conf /resources

# create start script
ADD startup.sh /startup.sh
RUN chmod +x /startup.sh

# expose port
EXPOSE 8080

# execution
CMD /startup.sh
