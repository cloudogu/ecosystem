# cesi/nginx
FROM cesi/base
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

# dockerfile is based on https://github.com/dockerfile/nginx and https://github.com/bellycard/docker-loadbalancer

ENV CONFD_VERSION 0.12.0-alpha3

RUN apk --update add openssl pcre zlib \
 && adduser nginx -D \
 && wget https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64 -O /bin/confd \
 && chmod +x /bin/confd \
 && mkdir -p /var/log/nginx \
 && ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log \
 && rm -rf /var/cache/apk/*

# copy files
COPY dist/nginx /usr/sbin/nginx
COPY etc/nginx /etc/nginx
COPY etc/confd /etc/confd
COPY html /var/www/html
COPY startup.sh /startup.sh


# Define mountable directories.
VOLUME ["/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

# Define working directory.
WORKDIR /etc/nginx

# Define default command.
CMD ["/startup.sh"]

# Expose ports.
EXPOSE 80
EXPOSE 443
