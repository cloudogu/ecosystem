# registry.cloudogu.com/official/redmine
FROM registry.cloudogu.com/official/base:3.5-2
MAINTAINER Robert Auer <robert.auer@cloudogu.com>

# set environment variables
ENV REDMINE_VERSION=3.3.2 \
    RMCASPLUGINVERSION=1.2.10 \
    RUBYCASVERSION=2.3.13 \
    USER=redmine \
    BASEDIR=/usr/share/webapps \
    WORKDIR=/usr/share/webapps/redmine \
    SERVICE_TAGS=webapp

# copy resource files
COPY resources/ /

RUN \
 # add user and group
 addgroup -S "${USER}" \
 && adduser -S -G "${USER}" -u 1000 "${USER}" \

 # install runtime packages
 && apk --no-cache add --virtual /.run-deps \
    postgresql-client \
		sqlite-libs \
    imagemagick \
    tzdata \
    ruby \
		ruby-bigdecimal \
		ruby-bundler \
    tini \
    libffi \
    su-exec \
    git \

 # install build dependencies
 && apk --no-cache add --virtual /.build-deps \
    build-base \
    ruby-dev \
    libxslt-dev \
    imagemagick-dev \
    postgresql-dev \
    sqlite-dev \
    linux-headers \
    patch \
    coreutils \
    libffi-dev \

 # update ruby gems
 && echo 'gem: --no-document' > /etc/gemrc \
 && 2>/dev/null 1>&2 gem update --system --quiet \

 # install redmine
 && mkdir -p ${WORKDIR} \
 && curl -L http://www.redmine.org/releases/redmine-${REDMINE_VERSION}.tar.gz | tar xfz - --strip-components=1 -C ${WORKDIR} \

 # set temporary database configuration for bundle install
 && DATABASE_TYPE=postgresql \
    DATABASE_IP=localhost \
    DATABASE_DB=redmine \
    DATABASE_USER=redmine \
    DATABASE_USER_PASSWORD=redmine \
    eval "echo \"$(cat  ${WORKDIR}/config/database.yml.tpl)\"" > ${WORKDIR}/config/database.yml \

 # install redmine required gems
 && echo 'gem "activerecord-session_store"' >> ${WORKDIR}/Gemfile \
 && echo 'gem "activerecord-deprecated_finders", require: "active_record/deprecated_finders"' >> ${WORKDIR}/Gemfile \
 && cd ${WORKDIR}; RAILS_ENV="production" bundle install \

 # Generate secret session token
 && rake generate_secret_token --trace -f ${WORKDIR}/Rakefile \

 # override environment to run redmine with a context path "/redmine"
 && mv ${WORKDIR}/config/environment.ces.rb ${WORKDIR}/config/environment.rb \

 # Install (available) rubycas-client version
 && git clone https://github.com/cloudogu/rubycas-client.git \
 && cd rubycas-client \
 && gem build rubycas-client.gemspec \
 && gem install rubycas-client-${RUBYCASVERSION}.gem \
 && cd ..; rm -rf rubycas-client \

 # fix permissions
 && chown -R ${USER}:${USER} ${BASEDIR} \
 && mkdir -m 755 /etc/redmine \
 && chown ${USER}:${USER} /etc/redmine \

 # cleanup
 && rm -rf /root/* /tmp/* $(gem env gemdir)/cache \
 && apk --purge del /.build-deps \
 && rm -rf /var/cache/apk/* \

 && ln -s /dev/stdout /usr/share/webapps/redmine/log/production.log

# switch to redmine user
USER ${USER}

# set workdir
WORKDIR ${WORKDIR}

# expose application port
EXPOSE 3000

# start
CMD /startup.sh
