# cesi/nginx
FROM cesi/base
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

# dockerfile is based on https://github.com/dockerfile/nginx and https://github.com/bellycard/docker-loadbalancer

ENV CONFD_VERSION 0.7.1
ADD resources/repo.list /etc/apt/sources.list.d/nginx.list

# Install Nginx.
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ABF5BD827BD9BF62 \
  && apt-get update \
  && apt-get install -y nginx \
  && apt-get autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install confd, use wget because of add is not cached
RUN wget https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64 -O /bin/confd

RUN rm -v /etc/nginx/conf.d/*

ADD resources/nginx.conf /etc/nginx/nginx.conf
ADD resources/default.conf /etc/nginx/conf.d/default.conf
ADD resources/nginx.toml /etc/confd/conf.d/nginx.toml
ADD resources/apps.conf.tmpl /etc/confd/templates/apps.conf.tmpl

ADD startup.sh /startup.sh
RUN chmod +x /startup.sh /bin/confd

# force log to stdout and stderr
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# Define mountable directories.
VOLUME ["/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

# Define working directory.
WORKDIR /etc/nginx

# Define default command.
CMD ["/startup.sh"]

# Expose ports.
EXPOSE 80
EXPOSE 443
