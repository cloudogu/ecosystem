#!/bin/bash
source /etc/ces/functions.sh

# variables
C=DE
ST=ND
L=brunswick
O=$(get_domain)
OU=$(get_domain)
HOST=$(get_fqdn)
DATE=$(date '+%Y%m%d')
CN=$(get_fqdn)

# create ssl directory
if [ ! -d /etc/ces/ssl ]; then
  mkdir /etc/ces/ssl
fi

# generate and sign certificate
openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
openssl rsa -passin pass:x -in server.pass.key -out /etc/ces/ssl/server.key
rm -f server.pass.key
openssl req -new -key /etc/ces/ssl/server.key -out /etc/ces/ssl/server.csr <<EOF
$C
$L
$ST
$O
$OU
$CN
ces@$CN
.
.
EOF
openssl x509 -req -days 3650 -in /etc/ces/ssl/server.csr -signkey /etc/ces/ssl/server.key -out /etc/ces/ssl/server.crt

# copy jdk truststore
docker run --rm -v /etc/ces/ssl:/etc/ces/ssl cesi/java \
  cp /usr/lib/jvm/java-8-oracle/jre/lib/security/cacerts /etc/ces/ssl/truststore.jks

# add generated certificate to truststore
docker run --rm -v /etc/ces/ssl:/etc/ces/ssl cesi/java \
  keytool -keystore /etc/ces/ssl/truststore.jks -storepass changeit -alias ces \
  -import -file /etc/ces/ssl/server.crt -noprompt
