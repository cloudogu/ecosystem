# cesi/redmine
FROM cesi/base
#MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

# Based on http://wiki.alpinelinux.org/wiki/Redmine
# and https://github.com/Ikke/docker-alpine-redmine/blob/master/Dockerfile

RUN apk add --update redmine ruby-sqlite ruby-io-console build-base ruby-dev imagemagick-dev ruby-irb ruby-mysql2

RUN rm -rf /tmp/* /var/cache/apk/*

RUN chown -R redmine:root /usr/share/webapps/redmine

# Reinstall RMagick to make it work
RUN gem uninstall rmagick && gem install rmagick -v 2.13.4

ENV workdir /usr/share/webapps/redmine

ADD ./usr/share/webapps/redmine/config ${workdir}/config
ADD ./usr/share/webapps/redmine/lib/tasks/load_default_data.rake ${workdir}/lib/tasks/load_default_data.rake
RUN chmod 664 ${workdir}/config/database.yml
RUN chmod 664 ${workdir}/lib/tasks/load_default_data.rake
RUN chmod 664 ${workdir}/config/secrets.yml
RUN chmod 664 ${workdir}/config/environment.rb

# startscript
ADD ./startup.sh /startup.sh
RUN chmod +x /startup.sh

# mark as webapp for nginx
ENV SERVICE_TAGS webapp

EXPOSE 3000

# start
CMD /startup.sh
