FROM debian:wheezy

MAINTAINER	stephan christann	<stephan.christann@christann.net>

# INSTALL SOFTWARE
RUN apt-get -y update && apt-get -y install slapd ldap-utils

# ADD LDAP RUN
ADD startup.sh /startup.sh
RUN chmod 755 /startup.sh

# ADD LDIF FILES
ADD default.ldif /default.ldif

# VOLUMES 
VOLUME  ["/tmp", "/etc/ldap"]

# MYSQL PORT
EXPOSE 389

# FIRE IT UP
CMD ["/bin/bash", "/startup.sh"]
