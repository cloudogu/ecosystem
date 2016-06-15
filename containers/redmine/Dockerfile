# registry.cloudogu.com/official/redmine
FROM registry.cloudogu.com/official/base:3.3-1
MAINTAINER Robert Auer <robert.auer@triology.de>

RUN apk add --update redmine ruby-io-console build-base ruby-dev \
  imagemagick-dev ruby-irb ruby-mysql2 ruby-sqlite git \
  && rm -rf /tmp/* /var/cache/apk/*

ENV WORKDIR /usr/share/webapps/redmine
ENV RMCASPLUGINVERSION 1.2.8
ENV RUBYCASVERSION 2.3.13

# Reinstall RMagick to make it work
RUN gem uninstall rmagick && gem install rmagick -v 2.13.4

RUN gem install activerecord-session_store
RUN echo 'gem "activerecord-session_store"' >> /usr/share/webapps/redmine/Gemfile
RUN gem install activerecord-deprecated_finders
RUN echo 'gem "activerecord-deprecated_finders", require: "active_record/deprecated_finders"' >> /usr/share/webapps/redmine/Gemfile

COPY ./resources/workdir/ ${WORKDIR}/

# Install (available) rubycas-client version
RUN git clone https://github.com/robertauer/rubycas-client.git && cd /rubycas-client \
  && gem build rubycas-client.gemspec && gem install rubycas-client-${RUBYCASVERSION}.gem

# Install Redmine CAS plugin
RUN curl -L -o /casplugin${RMCASPLUGINVERSION}.tar.gz https://github.com/robertauer/redmine_cas/archive/${RMCASPLUGINVERSION}.tar.gz \
  && tar -xzf /casplugin${RMCASPLUGINVERSION}.tar.gz && mv /redmine_cas-${RMCASPLUGINVERSION} ${WORKDIR}/plugins/redmine_cas \
  && rm /casplugin${RMCASPLUGINVERSION}.tar.gz

# Install redmine_activerecord_session_store plugin to make Single Sign-Out work
RUN curl -L -o /redmine_AR_session_store.tar.gz https://github.com/pencil/redmine_activerecord_session_store/archive/v0.0.1.tar.gz \
  && tar -xzf /redmine_AR_session_store.tar.gz && mv /redmine_activerecord_session_store-0.0.1 ${WORKDIR}/plugins/redmine_activerecord_session_store \
  && rm /redmine_AR_session_store.tar.gz

# startscript
COPY ./startup.sh /startup.sh
RUN chmod +x /startup.sh

# mark as webapp for nginx
ENV SERVICE_TAGS webapp

EXPOSE 3000

# start
CMD /startup.sh
