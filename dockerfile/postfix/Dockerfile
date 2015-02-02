FROM cesi/base

MAINTAINER	stephan christann	<stephan.christann@christann.net>

# SORRY DOCKER - WE WANT INIT
RUN dpkg-divert --local --rename --add /sbin/initctl

# POSTFIX TYPE AND MAILNAME
run echo "postfix postfix/main_mailer_type string Internet site" > preseed.txt
run echo "postfix postfix/mailname string cloudogu.com" >> preseed.txt
run debconf-set-selections preseed.txt

# INSTALL SOFTWARE
RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get -yq install postfix

# SAVE DEFAULT CONFIG
RUN tar cvfz /postfix.tgz /etc/postfix

# NETMASK TO CIDR CONVERTER
ADD mask2cidr.sh /mask2cidr.sh
RUN chmod 755 /mask2cidr.sh

# Add POSTFIX RUN
ADD startup.sh /startup.sh
RUN chmod 755 /startup.sh

# VOLUMES
VOLUME  ["/tmp", "/etc/ces/", "/etc/postfix"]

# POSTFIX PORT
EXPOSE 25

# FIRE IT UP
CMD ["/bin/bash", "/startup.sh"]
