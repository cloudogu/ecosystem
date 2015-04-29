FROM cesi/base

MAINTAINER	stephan christann	<stephan.christann@christann.net>

# SORRY DOCKER - WE WANT INIT
RUN dpkg-divert --local --rename --add /sbin/initctl

# INSTALL SOFTWARE
RUN apt-get update && apt-get -yq install mysql-server
RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

# Add MySQL RUN
ADD startup.sh /startup.sh
RUN chmod 755 /startup.sh

# VOLUMES
VOLUME "/var/lib/mysql"

# MYSQL PORT
EXPOSE 3306

# FIRE IT UP
CMD ["/bin/bash", "/startup.sh"]
