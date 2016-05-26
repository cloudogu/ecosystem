# this dockerfile installs the jdk documentation from the Oracle website
# It uses registry.cloudogu.com/official/base as base container
FROM registry.cloudogu.com/official/base:3.3-1
MAINTAINER Thomas Grosser <thomas.grosser@cloudogu.com>

# Documentation version
ENV JAVADOCS_VERSION 8u73
ENV JAVADOCS_URL http://download.oracle.com/otn-pub/java/jdk/${JAVADOCS_VERSION}-b02/jdk-8u73-docs-all.zip

# Install nginx.
RUN apk add --update nginx \
  && rm -rf /var/cache/apk/*

ADD startup.sh /startup.sh
RUN chmod +x /startup.sh
RUN chmod 755 /startup.sh

# Get Java SE8 documentation from Oracle
RUN wget --no-cookies --no-check-certificate --header \
    "Cookie:oraclelicense=accept-securebackup-cookie" \
		${JAVADOCS_URL}

# Unzip documentation
RUN mkdir /usr/share/nginx/html/javadocs
RUN unzip jdk-${JAVADOCS_VERSION}-docs-all.zip -d /usr/share/nginx/html/javadocs

# Delete zip file
RUN rm jdk-${JAVADOCS_VERSION}-docs-all.zip

# Replace default index file
RUN rm /usr/share/nginx/html/index.html
RUN rm /usr/share/nginx/html/50x.html
ADD resources/index.html /usr/share/nginx/html/javadocs/index.html

ENV SERVICE_TAGS webapp

# Define default command.
CMD ["/startup.sh"]

# Expose ports.
EXPOSE 80
