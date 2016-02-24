# cesi/redmine
FROM cesi/base
MAINTAINER Robert Auer <robert.auer@triology.de>

ENV WORKDIR /usr/share/webapps/redmine
ENV RMCASPLUGINVERSION 1.2.1

RUN apk add --update redmine ruby-io-console build-base ruby-dev \
  imagemagick-dev ruby-irb ruby-mysql2 sed \
  && rm -rf /tmp/* /var/cache/apk/*

# Reinstall RMagick to make it work
RUN gem uninstall rmagick && gem install rmagick -v 2.13.4

ADD ./resources/workdir/config ${WORKDIR}/config

RUN curl -L -o /casplugin${RMCASPLUGINVERSION}.tar.gz https://github.com/ninech/redmine_cas/archive/${RMCASPLUGINVERSION}.tar.gz \
  && tar -xzf /casplugin${RMCASPLUGINVERSION}.tar.gz && mv /redmine_cas-${RMCASPLUGINVERSION} ${WORKDIR}/plugins/redmine_cas \
  && rm /casplugin${RMCASPLUGINVERSION}.tar.gz

RUN sed -i s/2.3.10.rc1/2.3.9/g ${WORKDIR}/plugins/redmine_cas/Gemfile

RUN gem install rubycas-client

# startscript
ADD ./startup.sh /startup.sh
RUN chmod +x /startup.sh

# mark as webapp for nginx
ENV SERVICE_TAGS webapp

EXPOSE 3000

# start
CMD /startup.sh
