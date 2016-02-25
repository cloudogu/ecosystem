#!/bin/bash
source /etc/ces/functions.sh

ETCD=http://$(cat /etc/ces/node_master):4001
FQDN=$(get_fqdn)

# include fqdn in ssl.conf
render_template "/etc/nginx/include.d/ssl.conf.tpl" > "/etc/nginx/include.d/ssl.conf"

echo "[nginx] booting container. ETCD: $ETCD"

# Loop until confd has updated the nginx config
until confd -onetime -node $ETCD; do
  echo "[nginx] waiting for confd to refresh nginx.conf"
  sleep 5
done

# Run confd in the background to watch the upstream servers
confd -interval 10 -node $ETCD &
echo "[nginx] confd is listening for changes on etcd..."

# Start nginx
echo "[nginx] starting nginx service..."
exec /usr/sbin/nginx -c /etc/nginx/nginx.conf -g "daemon off;"
