# registry.cloudogu.com/official/redmine
FROM registry.cloudogu.com/official/base:3.3-3
MAINTAINER Robert Auer <robert.auer@cloudogu.com>

RUN apk add --update binutils \
  build-base \
  git \
  imagemagick-dev \
  libffi-dev \
  postgresql-client \
  postgresql-dev \
  ruby \
  ruby-actionpack-action_caching4.2 \
  ruby-actionpack-xml_parser4.2 \
  ruby-bigdecimal \
  ruby-bundler \
  ruby-coderay \
  ruby-dev \
  ruby-fastercsv \
  ruby-i18n \
  ruby-io-console \
  ruby-irb \
  ruby-jquery-rails4.2 \
  ruby-json \
  ruby-mocha \
  ruby-net-ldap \
  ruby-openid \
  ruby-pg \
  ruby-protected_attributes4.2 \
  ruby-rack \
  ruby-rack-openid \
  ruby-rails4.2 \
  ruby-rbpdf \
  ruby-rdoc \
  ruby-redcarpet \
  ruby-request_store \
  ruby-rmagick \
  ruby-sqlite \
  zlib-dev \
  && rm -rf /tmp/* /var/cache/apk/*

ENV REDMINE_VERSION 3.3.1
ENV RMCASPLUGINVERSION 1.2.9
ENV RUBYCASVERSION 2.3.13
ENV USER redmine
ENV BASEDIR /usr/share/webapps
ENV WORKDIR ${BASEDIR}/redmine

# Create redmine user and workdir
RUN adduser -D ${USER}
RUN mkdir -p -m 755 ${WORKDIR}
RUN chown -R ${USER}:${USER} ${BASEDIR}
USER ${USER}
WORKDIR ${WORKDIR}

# Get Redmine
RUN curl -L -o ${WORKDIR}.tar.gz http://www.redmine.org/releases/redmine-${REDMINE_VERSION}.tar.gz \
  && tar -xzf ${WORKDIR}.tar.gz \
  && mv redmine-${REDMINE_VERSION}/* ${WORKDIR} \
  && rm -rf redmine-${REDMINE_VERSION} ${WORKDIR}.tar.gz

USER root
COPY ./resources/workdir/ ${WORKDIR}/
RUN gem install activerecord-session_store
RUN echo 'gem "activerecord-session_store"' >> ${WORKDIR}/Gemfile
RUN gem install activerecord-deprecated_finders
RUN echo 'gem "activerecord-deprecated_finders", require: "active_record/deprecated_finders"' >> ${WORKDIR}/Gemfile
RUN bundle install
RUN gem install pg -v '0.18.4'
RUN chown -R ${USER}:${USER} ${BASEDIR}
RUN mkdir -m 755 /etc/redmine && chown ${USER}:${USER} /etc/redmine
# Generate secret session token
RUN rake generate_secret_token --trace -f ${WORKDIR}/Rakefile

# Install (available) rubycas-client version
RUN git clone https://github.com/cloudogu/rubycas-client.git \
  && cd rubycas-client \
  && gem build rubycas-client.gemspec \
  && gem install rubycas-client-${RUBYCASVERSION}.gem \
  && rm -rf ../rubycas-client

# Install Redmine CAS plugin
USER ${USER}
RUN curl -L -o casplugin${RMCASPLUGINVERSION}.tar.gz https://github.com/cloudogu/redmine_cas/archive/${RMCASPLUGINVERSION}.tar.gz \
  && tar -xzf casplugin${RMCASPLUGINVERSION}.tar.gz \
  && mv redmine_cas-${RMCASPLUGINVERSION} ${WORKDIR}/plugins/redmine_cas \
  && rm casplugin${RMCASPLUGINVERSION}.tar.gz

# Install redmine_activerecord_session_store plugin to make Single Sign-Out work
RUN curl -L -o redmine_AR_session_store.tar.gz https://github.com/pencil/redmine_activerecord_session_store/archive/v0.0.1.tar.gz \
  && tar -xzf redmine_AR_session_store.tar.gz \
  && mv redmine_activerecord_session_store-0.0.1 ${WORKDIR}/plugins/redmine_activerecord_session_store \
  && rm redmine_AR_session_store.tar.gz

# startscript
COPY ./startup.sh /startup.sh

# theme
COPY ./resources/Cloudogu.zip /usr/share/webapps/redmine/public/themes

# mark as webapp for nginx
ENV SERVICE_TAGS webapp

EXPOSE 3000

# start
CMD /startup.sh
