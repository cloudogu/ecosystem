#
# DO NOT USE base:3.5 RIGHT NOW TO AVOID DATABASE UPDATE
#
FROM registry.cloudogu.com/official/base:3.3-4
MAINTAINER Sebastian Sdorra <sebastian.sdorra@cloudogu.com>

# install postgresql and gosu
RUN apk add --update postgresql \
 && curl -o /usr/local/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64" \
 && chmod +x /usr/local/bin/gosu \
 && rm -rf /var/cache/apk/*

ENV LANG en_US.utf8
ENV PGDATA /var/lib/postgresql

# Add PostgreSQL RUN
COPY startup.sh /startup.sh
COPY create-sa.sh /create-sa.sh

# VOLUMES
VOLUME "/var/lib/postgresql"

# MYSQL PORT
EXPOSE 5432

# FIRE IT UP
CMD ["/bin/bash", "/startup.sh"]
