# cesi/nginx
FROM debian:wheezy
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

# dockerfile is based on https://github.com/dockerfile/nginx and https://github.com/bellycard/docker-loadbalancer

ENV DEBIAN_FRONTEND noninteractive
ENV CONSULTPL_VERSION 0.6.0

ADD repo.list /etc/apt/sources.list.d/nginx.list

# Install Nginx.
RUN \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ABF5BD827BD9BF62 && \
  apt-get update && \
  apt-get install -y nginx curl runit

ENV CT_URL https://github.com/hashicorp/consul-template/releases/download/v${CONSULTPL_VERSION}/consul-template_${CONSULTPL_VERSION}_linux_amd64.tar.gz
RUN curl -L $CT_URL | tar -C /usr/local/bin --strip-components 1 -zxf -

ADD nginx.service /etc/service/nginx/run
ADD consul-template.service /etc/service/consul-template/run
RUN chmod +x /etc/service/*/run

RUN rm -v /etc/nginx/conf.d/*
ADD nginx.conf /etc/consul-templates/nginx.conf

# force log to stdout and stderr
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# Define mountable directories.
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

# Define working directory.
WORKDIR /etc/nginx

# Define default command.
CMD ["/usr/bin/runsvdir", "/etc/service"]

# Expose ports.
EXPOSE 80
EXPOSE 443
