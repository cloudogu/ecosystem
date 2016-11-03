FROM registry.cloudogu.com/official/base:3.3-1
MAINTAINER	stephan christann	<stephan.christann@christann.net>

# INSTALL POSTFIX
RUN apk add --update postfix openrc \
	&& rm -rf /var/cache/apk/*

# Add POSTFIX RUN AND CIDR CALCULATOR
ADD startup.sh /startup.sh
ADD mask2cidr.sh /mask2cidr.sh

# VOLUMES
VOLUME  ["/tmp", "/etc/ces/", "/etc/postfix"]

# POSTFIX PORT
EXPOSE 25/tcp 587/tcp

# FIRE IT UP
CMD ["/bin/bash", "/startup.sh"]
