# this dockerfile makes the service icoordinator.com available
# It uses registry.cloudogu.com/official/base as base container
FROM registry.cloudogu.com/official/base:3.3-1
MAINTAINER Thomas Grosser <thomas.grosser@cloudogu.com>

# Install nginx
RUN apk add --update nginx && rm -rf /var/cache/apk/*

# Replace default index file
RUN rm -f /usr/share/nginx/html/*.html \
 && mkdir -p /usr/share/nginx/html/icoordinator

ADD resources/index.html /usr/share/nginx/html/icoordinator/index.html

ENV SERVICE_TAGS webapp
ADD startup.sh /startup.sh

# Define default command.
CMD ["/startup.sh"]

# Expose ports.
EXPOSE 80
