# registry.cloudogu.com/official/redmine
FROM registry.cloudogu.com/official/base:3.3-3
MAINTAINER Robert Auer <robert.auer@cloudogu.com>

RUN apk add --update ruby-io-console build-base ruby-dev postgresql-dev \
  imagemagick-dev ruby-irb ruby-pg git ruby-sqlite postgresql-client \
  ruby-bundler ruby ruby-actionpack-action_caching4.2 zlib-dev libffi-dev \
  ruby-actionpack-xml_parser4.2 ruby-bigdecimal ruby-coderay ruby-fastercsv \
  ruby-i18n ruby-jquery-rails4.2 ruby-json ruby-mocha ruby-net-ldap ruby-openid \
  ruby-rack ruby-rack-openid ruby-rails4.2 ruby-rbpdf ruby-rdoc ruby-redcarpet \
  ruby-request_store ruby-rmagick ruby-protected_attributes4.2 binutils ruby-io-console \
  && rm -rf /tmp/* /var/cache/apk/*

ENV REDMINE_VERSION 3.3.1
ENV WORKDIR /usr/share/webapps/redmine
ENV RMCASPLUGINVERSION 1.2.9
ENV RUBYCASVERSION 2.3.13

# Get Redmine
RUN mkdir -p -m 755 ${WORKDIR}
RUN curl -L -o ${WORKDIR}.tar.gz http://www.redmine.org/releases/redmine-${REDMINE_VERSION}.tar.gz \
  && tar -xzf ${WORKDIR}.tar.gz && mv redmine-${REDMINE_VERSION}/* ${WORKDIR} \
  && rm -rf redmine-${REDMINE_VERSION} ${WORKDIR}.tar.gz

RUN gem install activerecord-session_store
RUN echo 'gem "activerecord-session_store"' >> /usr/share/webapps/redmine/Gemfile
RUN gem install activerecord-deprecated_finders
RUN echo 'gem "activerecord-deprecated_finders", require: "active_record/deprecated_finders"' >> /usr/share/webapps/redmine/Gemfile

COPY ./resources/workdir/ ${WORKDIR}/

# Install (available) rubycas-client version
RUN git clone https://github.com/cloudogu/rubycas-client.git && cd /rubycas-client \
  && gem build rubycas-client.gemspec && gem install rubycas-client-${RUBYCASVERSION}.gem

# Install Redmine CAS plugin
RUN curl -L -o /casplugin${RMCASPLUGINVERSION}.tar.gz https://github.com/cloudogu/redmine_cas/archive/${RMCASPLUGINVERSION}.tar.gz \
  && tar -xzf /casplugin${RMCASPLUGINVERSION}.tar.gz && mv /redmine_cas-${RMCASPLUGINVERSION} ${WORKDIR}/plugins/redmine_cas \
  && rm /casplugin${RMCASPLUGINVERSION}.tar.gz

# Install redmine_activerecord_session_store plugin to make Single Sign-Out work
RUN curl -L -o /redmine_AR_session_store.tar.gz https://github.com/pencil/redmine_activerecord_session_store/archive/v0.0.1.tar.gz \
  && tar -xzf /redmine_AR_session_store.tar.gz && mv /redmine_activerecord_session_store-0.0.1 ${WORKDIR}/plugins/redmine_activerecord_session_store \
  && rm /redmine_AR_session_store.tar.gz

# startscript
COPY ./startup.sh /startup.sh

# mark as webapp for nginx
ENV SERVICE_TAGS webapp

EXPOSE 3000

# start
CMD /startup.sh
