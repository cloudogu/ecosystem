# cesi/nginx
FROM cesi/base
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

# dockerfile is based on https://github.com/dockerfile/nginx and https://github.com/bellycard/docker-loadbalancer

ENV CONFD_VERSION 0.10.0
COPY dist/nginx /usr/sbin/nginx

# install runtime dependencies
RUN apk --update add openssl pcre zlib \
 && rm -rf /var/cache/apk/*

RUN adduser nginx -D

# install confd, use wget because of add is not cached
RUN wget https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64 -O /bin/confd

#RUN rm -v /etc/nginx/conf.d/*

ADD resources/nginx.conf /etc/nginx/nginx.conf
ADD resources/mime.types /etc/nginx/conf/mime.types
ADD resources/default.conf /etc/nginx/conf.d/default.conf
ADD resources/nginx.toml /etc/confd/conf.d/nginx.toml
ADD resources/apps.conf.tmpl /etc/confd/templates/apps.conf.tmpl
ADD resources/warp.conf /etc/nginx/include.d/warp.conf
ADD resources/ssl.conf.tpl /etc/nginx/include.d/ssl.conf.tpl

# add warp
ADD warp /var/www/html/warp

# add static resources
ADD _static /var/www/html/_static

ADD startup.sh /startup.sh

# make confd executable and force log to stdout and stderr
RUN chmod +x /startup.sh /bin/confd \
 && mkdir -p /var/log/nginx \
 && ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log

# Define mountable directories.
VOLUME ["/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

# Define working directory.
WORKDIR /etc/nginx

# Define default command.
CMD ["/startup.sh"]

# Expose ports.
EXPOSE 80
EXPOSE 443
