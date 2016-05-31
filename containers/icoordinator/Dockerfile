# this dockerfile makes the service icoordinator.com available
# It uses registry.cloudogu.com/official/base as base container
FROM registry.cloudogu.com/official/base:3.3-1
MAINTAINER Thomas Grosser <thomas.grosser@cloudogu.com>

# Install icoordinator app
COPY dist/icoordinator /usr/sbin/icoordinator
COPY startup.sh /startup.sh

# mark as webapp for nginx
ENV SERVICE_TAGS webapp

# Start icoordinator app
CMD ["/startup.sh"]

# Expose ports
EXPOSE 80
