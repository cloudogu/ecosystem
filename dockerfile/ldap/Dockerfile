FROM cesi/base

MAINTAINER	stephan christann	<stephan.christann@christann.net>

# SORRY DOCKER - WE WANT INIT
RUN dpkg-divert --local --rename --add /sbin/initctl

# ADD EMPTY STANDARD LDAP
COPY resources/ldappackage.tgz /ldappackage.tgz

# INSTALL SOFTWARE
RUN apt-get -y update && apt-get -y install slapd ldap-utils

# ADD LDAP RUN
ADD startup.sh /startup.sh
RUN chmod 755 /startup.sh

# VOLUMES 
VOLUME  ["/tmp", "/etc/ldap", "/etc/ces/", "/var/lib/ldap"]

# MYSQL PORT
EXPOSE 389

# FIRE IT UP
CMD ["/bin/bash", "/startup.sh"]
