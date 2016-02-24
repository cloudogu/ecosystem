#!/bin/bash
source /etc/ces/functions.sh

# variables
DOMAIN=$(get_domain)
FQDN=$(get_fqdn)
IP=$(get_ip)

# create ssl directory
if [ ! -d /etc/ces/ssl ]; then
  mkdir /etc/ces/ssl
fi

# create ssl certificate
SSL_CONF=$(mktemp)
render_template "/etc/ces/ssl.conf.tpl" > "$SSL_CONF"
openssl req -x509 -days 3650 -nodes -newkey rsa:2048 -sha256 -keyout /etc/ces/ssl/server.key -out /etc/ces/ssl/server.crt -config "$SSL_CONF"
rm -f "$SSL_CONF"

# copy jdk truststore
docker run --rm -v /etc/ces/ssl:/etc/ces/ssl cesi/java \
  cp  /opt/jdk/jre/lib/security/cacerts /etc/ces/ssl/truststore.jks

# add generated certificate to truststore
docker run --rm -v /etc/ces/ssl:/etc/ces/ssl cesi/java \
  keytool -keystore /etc/ces/ssl/truststore.jks -storepass changeit -alias ces \
  -import -file /etc/ces/ssl/server.crt -noprompt
