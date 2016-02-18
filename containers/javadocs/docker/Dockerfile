#this dockerfile installs the jdk documentation from the Oracle website
#It uses cesi/base as base container
FROM cesi/base
MAINTAINER Thomas Grosser <thomas.grosser@triology.de>

# Documentation version
ENV JAVADOCS_VERSION 8u73
ENV JAVADOCS_URL http://download.oracle.com/otn-pub/java/jdk/${JAVADOCS_VERSION}-b02/jdk-8u73-docs-all.zip

# Install nginx.
RUN apt-get update \
  && apt-get -y install nginx \
	&& apt-get autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD startup.sh /startup.sh
RUN chmod +x /startup.sh

# force log to stdout and stderr
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# Get Java SE8 documentation from Oracle
RUN wget --no-cookies --no-check-certificate --header \
    "Cookie:oraclelicense=accept-securebackup-cookie" \
		${JAVADOCS_URL}

# Unzip documentation
RUN unzip jdk-${JAVADOCS_VERSION}-docs-all.zip -d /var/www/html

# Delete zip file
RUN rm jdk-${JAVADOCS_VERSION}-docs-all.zip

# Replace default index file
RUN rm /var/www/html/index*.html
ADD resources/index.html /var/www/html/index.html

ENV SERVICE_TAGS webapp

# Define default command.
CMD ["/startup.sh"]

# Expose ports.
EXPOSE 80
EXPOSE 443
