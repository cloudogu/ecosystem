# registry.cloudogu.com/official/usermgt
FROM registry.cloudogu.com/official/java:8u102-1
MAINTAINER Sebastian Sdorra <sebastian.sdorra@cloudogu.com>

# mark as webapp for nginx
ENV SERVICE_TAGS webapp

# tomcat version
ENV TOMCAT_MAJOR_VERSION 8
ENV TOMCAT_VERSION 8.0.38

# usermgt version
ENV USERMGT_VERSION 1.3.1

# home directory
ENV UNIVERSEADM_HOME /var/lib/usermgt/conf

# create user
RUN addgroup -S -g 1000 tomcat && adduser -S -h /opt/apache-tomcat -s /bin/bash -G tomcat -u 1000 tomcat

# install tomcat
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
    && curl -L https://github.com/cloudogu/usermgt/releases/download/v${USERMGT_VERSION}/usermgt-${USERMGT_VERSION}.war -o usermgt-${USERMGT_VERSION}.war \
	&& unzip usermgt-${USERMGT_VERSION}.war \
	&& rm -f usermgt-${USERMGT_VERSION}.war \
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
