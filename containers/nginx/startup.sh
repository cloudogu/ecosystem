#!/bin/bash
source /etc/ces/functions.sh

echo "[nginx] booting container. ETCD: $ETCD"

ETCD=http://$(cat /etc/ces/node_master):4001
FQDN=$(get_fqdn)

# include fqdn in ssl.conf
render_template "/etc/nginx/include.d/ssl.conf.tpl" > "/etc/nginx/include.d/ssl.conf"

# Loop until confd has updated the nginx config
ces-confd -e $ETCD &
echo "[nginx] ces-confd is listening for changes on etcd..."

# Start nginx
echo "[nginx] starting nginx service..."
exec /usr/sbin/nginx -c /etc/nginx/nginx.conf -g "daemon off;"
