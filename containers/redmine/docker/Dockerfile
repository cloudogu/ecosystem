# cesi/redmine
FROM cesi/base
MAINTAINER Robert Auer <robert.auer@triology.de>

ENV WORKDIR /usr/share/webapps/redmine

RUN apk add --update redmine ruby-io-console build-base ruby-dev \
  imagemagick-dev ruby-irb ruby-mysql2 \
  && rm -rf /tmp/* /var/cache/apk/*

# Reinstall RMagick to make it work
RUN gem uninstall rmagick && gem install rmagick -v 2.13.4

ADD ./resources/workdir/config ${WORKDIR}/config

# startscript
ADD ./startup.sh /startup.sh
RUN chmod +x /startup.sh

# mark as webapp for nginx
ENV SERVICE_TAGS webapp

EXPOSE 3000

# start
CMD /startup.sh
