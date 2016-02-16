FROM cesi/base

MAINTAINER stephan christann <stephan.christann@christann.net>

# INSTALL SOFTWARE
RUN apk add --update openldap openldap-clients openldap-back-hdb openldap-back-bdb
RUN rm -rf /var/cache/apk/*

# ADD resources
ADD resources /resources

# ADD LDAP RUN
ADD startup.sh /startup.sh
RUN chmod 755 /startup.sh

# VOLUMES
VOLUME ["/var/lib/ldap", "/etc/cesldap"]

# MYSQL PORT
EXPOSE 389

# FIRE IT UP
CMD ping 127.0.0.1
# CMD ["/bin/bash", "/startup.sh"]
