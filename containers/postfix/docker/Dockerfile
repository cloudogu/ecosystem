FROM cesi/base

MAINTAINER	stephan christann	<stephan.christann@christann.net>

# INSTALL POSTFIX
RUN apk add --update postfix openrc \
	&& rm -rf /var/cache/apk/*

# Add POSTFIX RUN
ADD startup.sh /startup.sh
RUN chmod 755 /startup.sh

# VOLUMES
VOLUME  ["/tmp", "/etc/ces/", "/etc/postfix"]

# POSTFIX PORT
EXPOSE 25/tcp 587/tcp

# FIRE IT UP
CMD ["/bin/bash", "/startup.sh"]
