# cesi/redmine
FROM cesi/base
#MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

# Dockerfile based on https://github.com/docker-library/redmine/blob/master/3.2/Dockerfile
#   which is based on https://github.com/docker-library/ruby/blob/master/2.2/slim/Dockerfile

# ruby:2.2-slim installation (see https://github.com/docker-library/ruby/blob/master/2.2/slim/Dockerfile)
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		bzip2 \
		ca-certificates \
		curl \
		libffi-dev \
		libgdbm3 \
		libopenssl-ruby1.8 \
		libssl-dev \
		libyaml-dev \
		procps \
		zlib1g-dev \
		imagemagick \
		libmysqlclient18 \
		libpq5 \
		libsqlite3-0 \
		bzr \
		git \
		mercurial \
		openssh-client \
		subversion
	#&& rm -rf /var/lib/apt/lists/*

ENV RUBY_MAJOR 2.2
ENV RUBY_VERSION 2.2.4
ENV RUBY_DOWNLOAD_SHA256 b6eff568b48e0fda76e5a36333175df049b204e91217aa32a65153cc0cdcb761
ENV RUBYGEMS_VERSION 2.5.1

# skip installing gem documentation
RUN echo 'install: --no-document\nupdate: --no-document' >> "$HOME/.gemrc"

# some of ruby's build scripts are written in ruby
# we purge this later to make sure our final image uses what we just built
RUN buildDeps=' \
		autoconf \
		bison \
		gcc \
		libbz2-dev \
		libgdbm-dev \
		libglib2.0-dev \
		libncurses-dev \
		libreadline-dev \
		libxml2-dev \
		libxslt-dev \
		make \
		ruby \
		libmagickcore-dev \
		libmagickwand-dev \
		libmysqlclient-dev \
		libpq-dev \
		libsqlite3-dev \
		patch \
	' \
	&& set -x \
	#&& apt-get update \
	&& apt-get install -y --no-install-recommends $buildDeps \
	&& rm -rf /var/lib/apt/lists/* \
	&& mkdir -p /usr/src/ruby \
	&& curl -fSL -o ruby.tar.gz "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.gz" \
	&& echo "$RUBY_DOWNLOAD_SHA256 *ruby.tar.gz" | sha256sum -c - \
	&& tar -xzf ruby.tar.gz -C /usr/src/ruby --strip-components=1 \
	&& rm ruby.tar.gz \
	&& cd /usr/src/ruby \
	&& autoconf \
	&& ./configure --disable-install-doc \
	&& make -j"$(nproc)" \
	&& make install \
	&& gem update --system $RUBYGEMS_VERSION \
	&& rm -r /usr/src/ruby
	#&& apt-get purge -y --auto-remove $buildDeps

# install things globally, for great justice
ENV GEM_HOME /usr/local/bundle
ENV PATH $GEM_HOME/bin:$PATH

ENV BUNDLER_VERSION 1.11.2

RUN gem install bundler --version "$BUNDLER_VERSION" \
	&& bundle config --global path "$GEM_HOME" \
	&& bundle config --global bin "$GEM_HOME/bin" \
	&& bundle config --global silence_root_warning true

# don't create ".bundle" in all our apps
ENV BUNDLE_APP_CONFIG $GEM_HOME


# redmine installation (see https://github.com/docker-library/redmine/blob/master/3.2/Dockerfile)
# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r redmine && useradd -r -g redmine redmine

# grab gosu for easy step-down from root
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
	&& curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
	&& gpg --verify /usr/local/bin/gosu.asc \
	&& rm /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu

RUN set -x \
	&& curl -fSL "https://github.com/krallin/tini/releases/download/v0.5.0/tini" -o /usr/local/bin/tini \
	&& chmod +x /usr/local/bin/tini \
	&& tini -h

ENV RAILS_ENV production
WORKDIR /usr/src/redmine

ENV REDMINE_VERSION 3.2.0
ENV REDMINE_DOWNLOAD_MD5 b1050c3a0e6effd5a704ef5003d9df06

RUN curl -fSL "http://www.redmine.org/releases/redmine-${REDMINE_VERSION}.tar.gz" -o redmine.tar.gz \
	#&& echo "$REDMINE_DOWNLOAD_MD5 redmine.tar.gz" | md5sum -c - \
	&& tar -xvf redmine.tar.gz --strip-components=1 \
	&& rm redmine.tar.gz files/delete.me log/delete.me \
	&& mkdir -p tmp/pdf public/plugin_assets \
	&& chown -R redmine:redmine ./

RUN set -ex \
	&& rm -rf /var/lib/apt/lists/* \
	&& bundle install --without development test \
	&& for adapter in mysql2 postgresql sqlite3; do \
		echo "$RAILS_ENV:" > ./config/database.yml; \
		echo "  adapter: $adapter" >> ./config/database.yml; \
		bundle install --without development test; \
	done \
	&& rm ./config/database.yml \
	&& apt-get purge -y --auto-remove $buildDeps


#VOLUME /usr/src/redmine/files

#COPY docker-entrypoint.sh /
#ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 3000


ADD ./usr/src/redmine/config/database.yml /usr/src/redmine/config/database.yml
ADD ./usr/src/redmine/config/secrets.yml /usr/src/redmine/config/secrets.yml

RUN chmod 664 /usr/src/redmine/config/database.yml
RUN chmod 664 /usr/src/redmine/config/secrets.yml


RUN chmod 777 /usr/src/redmine/Gemfile.lock


# startscript
ADD ./startup.sh /startup.sh
RUN chmod +x /startup.sh

# mark as webapp for nginx
ENV SERVICE_TAGS webapp

ADD ./usr/src/redmine/config/environment.rb /usr/src/redmine/config/environment.rb
RUN chmod 664 /usr/src/redmine/config/environment.rb
RUN chown redmine:redmine /usr/src/redmine/config/*

#USER redmine
#CMD ["rails", "server", "-b", "0.0.0.0"]
# start jenkins
CMD /startup.sh
