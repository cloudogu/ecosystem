# cesi/nginx
FROM registry.cloudogu.com/official/base:3.3-1
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

ENV CES_CONFD_VERSION=0.1.1

RUN apk --update add openssl pcre zlib \
 && adduser nginx -D \
 && github_download https://github.com/cloudogu/ces-confd/releases/download/v${CES_CONFD_VERSION}/ces-confd-v${CES_CONFD_VERSION}.tar.gz | gunzip | tar -x -O > /usr/bin/ces-confd \
 && chmod +x /usr/bin/ces-confd \
 && mkdir -p /var/log/nginx \
 && ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log \
 && rm -rf /var/cache/apk/*

# copy files
COPY dist/nginx /usr/sbin/nginx
COPY etc/nginx /etc/nginx
COPY etc/ces-confd /etc/ces-confd
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
