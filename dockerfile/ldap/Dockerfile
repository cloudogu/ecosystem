FROM debian:wheezy

MAINTAINER	stephan christann	<stephan.christann@christann.net>

# ADD EMPTY STANDARD LDAP
ADD resources/ldap.tgz /ldap.tgz

# INSTALL SOFTWARE
RUN apt-get -y update && apt-get -y install slapd ldap-utils

# ADD LDAP RUN
ADD startup.sh /startup.sh
RUN chmod 755 /startup.sh

# VOLUMES 
VOLUME  ["/tmp", "/etc/ldap", "/etc/ces/"]

# MYSQL PORT
EXPOSE 389

# FIRE IT UP
CMD ["/bin/bash", "/startup.sh"]
