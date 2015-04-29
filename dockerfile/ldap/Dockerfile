FROM cesi/base

MAINTAINER stephan christann <stephan.christann@christann.net>

# INSTALL SOFTWARE
RUN apt-get -y update \
    && apt-get -y install slapd ldap-utils

# ADD resources
ADD resources /resources

# ADD LDAP RUN
ADD startup.sh /startup.sh
RUN chmod 755 /startup.sh

# VOLUMES
VOLUME ["/var/lib/ldap", "/etc/ceslap"]

# MYSQL PORT
EXPOSE 389

# FIRE IT UP
CMD ["/bin/bash", "/startup.sh"]
