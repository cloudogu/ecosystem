# registry.cloudogu.com/official/usermgt
FROM registry.cloudogu.com/official/java:8u77-1
MAINTAINER Sebastian Sdorra <sebastian.sdorra@cloudogu.com>

# mark as webapp for nginx
ENV SERVICE_TAGS webapp

# tomcat version
ENV TOMCAT_MAJOR_VERSION 8
ENV TOMCAT_VERSION 8.0.33

# usermgt version
ENV USERMGT_VERSION 1.3.0
ENV VERSION_POSTFIX -20160512.095335-1

# home directory
ENV UNIVERSEADM_HOME /var/lib/usermgt/conf

# create user
RUN addgroup -S -g 1000 tomcat && adduser -S -h /opt/apache-tomcat -s /bin/bash -G tomcat -u 1000 tomcat


# install tomcat
#RUN curl --fail --silent --location --retry 3 \
RUN curl --fail --location --retry 3 \
		http://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz \
		| gunzip \
		| tar x -C /opt \
		&& mv /opt/apache-tomcat-${TOMCAT_VERSION}/* /opt/apache-tomcat \
		&& chown -R tomcat:tomcat /opt/apache-tomcat \
		&& rm -rf /opt/apache-tomcat/logs \
		&& mkdir /var/lib/usermgt \
		&& ln -s /var/lib/usermgt/logs /opt/apache-tomcat/logs \
		&& rm -rf /opt/apache-tomcat/webapps/*


# add setenv.sh
ADD resources/setenv.sh /opt/apache-tomcat/bin/setenv.sh
RUN chmod +x /opt/apache-tomcat/bin/setenv.sh

# install usermgt
RUN mkdir -p /opt/apache-tomcat/webapps/usermgt \
    && cd /opt/apache-tomcat/webapps/usermgt \
		# TODO release on github
    && wget https://universe.triology.de/nexus/content/repositories/snapshots/com/cloudogu/ces/usermgt/${USERMGT_VERSION}-SNAPSHOT/usermgt-${USERMGT_VERSION}${VERSION_POSTFIX}.war \
		&& unzip usermgt-${USERMGT_VERSION}${VERSION_POSTFIX}.war \
		&& rm -f usermgt-${USERMGT_VERSION}${VERSION_POSTFIX}.war \
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
