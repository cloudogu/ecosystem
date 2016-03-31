#!/bin/bash
source /etc/ces/functions.sh

# enable strict mode
set -eo pipefail
IFS=$'\n\t'

echo "create certificate"

# variables
DOMAIN=$(get_domain)
FQDN=$(get_fqdn)
IP=$(get_ip)

# create ssl certificate
SSL_CONF=$(mktemp)
CERTIFICATE="$(mktemp)"
KEY="$(mktemp)"

render_template "/etc/ces/ssl.conf.tpl" > "$SSL_CONF"
openssl req -x509 -days 3650 -nodes -newkey rsa:2048 -sha256 -keyout "$KEY" -out "$CERTIFICATE" -config "$SSL_CONF" 2> /dev/null

# write certificate to etcd
echo "writing certificates to etcd"
etcdctl --peers "$(cat /etc/ces/node_master):4001" set /config/_global/certificate/type selfsigned > /dev/null
cat "${CERTIFICATE}" | etcdctl --peers "$(cat /etc/ces/node_master):4001" set /config/_global/certificate/server.crt > /dev/null
cat "${KEY}" | etcdctl --peers "$(cat /etc/ces/node_master):4001" set /config/_global/certificate/server.key > /dev/null

# remove temporary files
rm -f "$SSL_CONF" "$CERTIFICATE" "$KEY"
