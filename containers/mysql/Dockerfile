FROM registry.cloudogu.com/official/base:3.5-2

MAINTAINER Stephan Christann <stephan.christann@cloudogu.com>

# Add user and install software
RUN adduser -S -h "/var/lib/mysql" -s /sbin/nologin -u 1000 mysql \
  && apk add --update mysql mysql-client \
  && rm -rf /var/cache/apk/*

# Bind server to 0.0.0.0
RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

COPY resources/ /

VOLUME "/var/lib/mysql"

EXPOSE 3306

# FIRE IT UP
CMD ["/bin/bash", "/startup.sh"]
