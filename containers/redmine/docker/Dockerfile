# cesi/redmine
FROM cesi/base
#MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

# Based on http://wiki.alpinelinux.org/wiki/Redmine
# and https://github.com/Ikke/docker-alpine-redmine/blob/master/Dockerfile

#RUN apk add --update ruby-dev build-base git ruby-sqlite ruby-unicorn ruby-io-console sqlite-dev ruby-mysql2 gmp gmp-dev gcc libgcc redmine\
#	&& rm -rf /tmp/* /var/cache/apk/*

#	RUN apk add --update openrc\
#		&& rm -rf /tmp/* /var/cache/apk/*

#RUN sed -Ei 's/v[0-9]\.[0-9]+/edge/' /etc/apk/repositories \
#    && apk upgrade --update-cache --available

RUN apk add --update redmine ruby-sqlite ruby-io-console
RUN apk add --update build-base ruby-dev imagemagick-dev ruby-irb

RUN rm -rf /tmp/* /var/cache/apk/*

RUN chown -R redmine:root /usr/share/webapps/redmine

RUN gem uninstall rmagick && gem install rmagick -v 2.13.4


ADD ./usr/src/redmine/config/database.yml /usr/src/redmine/config/database.yml
RUN chmod 664 /usr/src/redmine/config/database.yml
ADD ./usr/share/webapps/redmine/lib/tasks/load_default_data.rake /usr/share/webapps/redmine/lib/tasks/load_default_data.rake
RUN chmod 664 /usr/share/webapps/redmine/lib/tasks/load_default_data.rake







ADD ./usr/src/redmine/config/secrets.yml /usr/src/redmine/config/secrets.yml
ADD ./usr/src/redmine/config/environment.rb /usr/src/redmine/config/environment.rb

RUN chmod 664 /usr/src/redmine/config/secrets.yml
RUN chmod 664 /usr/src/redmine/config/environment.rb
#RUN chown redmine:redmine /usr/src/redmine/config/*

#RUN chmod 777 /usr/src/redmine/Gemfile.lock

# startscript
ADD ./startup.sh /startup.sh
RUN chmod +x /startup.sh

# mark as webapp for nginx
ENV SERVICE_TAGS webapp

EXPOSE 3000

# start jenkins
CMD /startup.sh
