# this dockerfile makes the service icoordinator.com available
# It uses registry.cloudogu.com/official/base as base container
FROM registry.cloudogu.com/official/base:3.3-1
MAINTAINER Thomas Grosser <thomas.grosser@cloudogu.com>

# Install icoordinator app
ENV GOPATH /go
RUN mkdir -p "$GOPATH" \
  && mkdir -p "$GOPATH/tmpl" \
  && mkdir -p "$GOPATH/assets" \
  && mkdir -p "$GOPATH/assets/js" \
  && mkdir -p "$GOPATH/assets/css" \
  && mkdir -p "$GOPATH/assets/img" \
  && chmod -R 777 "$GOPATH"

COPY src/tmpl/* $GOPATH/tmpl/
COPY src/assets/js/* $GOPATH/assets/js/
COPY src/assets/css/* $GOPATH/assets/css/
COPY src/assets/img/* $GOPATH/assets/img/

COPY dist/icoordinator $GOPATH/
COPY startup.sh /startup.sh

# mark as webapp for nginx
ENV SERVICE_TAGS webapp

# Start icoordinator app
CMD ["/startup.sh"]

# Expose ports
EXPOSE 80
