# this dockerfile makes the service icoordinator.com available
# It uses registry.cloudogu.com/official/base as base container
FROM registry.cloudogu.com/official/base:3.3-1
MAINTAINER Thomas Grosser <thomas.grosser@cloudogu.com>

# Install icoordinator app
COPY dist/icoordinator /usr/sbin/icoordinator

# Start icoordinator app
CMD /usr/sbin/icoordinator

# Expose ports.
EXPOSE 8080
