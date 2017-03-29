FROM registry.cloudogu.com/official/base:3.5-2

MAINTAINER	stephan christann	<stephan.christann@christann.net>

# INSTALL SOFTWARE
RUN apk add --update mysql mysql-client && rm -rf /var/cache/apk/*

# bind server to 0.0.0.0
RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

# Add MySQL RUN
COPY startup.sh /startup.sh
COPY create-sa.sh /create-sa.sh

# VOLUMES
VOLUME "/var/lib/mysql"

# MYSQL PORT
EXPOSE 3306

# FIRE IT UP
CMD ["/bin/bash", "/startup.sh"]
