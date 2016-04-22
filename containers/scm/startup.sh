#!/bin/bash
source /etc/ces/functions.sh

# create truststore, which is used in the default file
create_truststore.sh /opt/scm-server/conf/truststore.jks > /dev/null

if ! [ -d "/var/lib/scm/config" ];  then
	mkdir -p "/var/lib/scm/config"
fi

# Final startup
exec /opt/scm-server/bin/scm-server
