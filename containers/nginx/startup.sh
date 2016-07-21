#!/bin/bash
source /etc/ces/functions.sh

echo "[nginx] booting container. ETCD: $ETCD"



etcdctl

# get certificates
doguctl config --global certificate/server.crt > "/etc/ssl/server.crt"
doguctl config --global certificate/server.key > "/etc/ssl/server.key"

# include fqdn in ssl.conf
FQDN=$(doguctl config --global fqdn)
render_template "/etc/nginx/include.d/ssl.conf.tpl" > "/etc/nginx/include.d/ssl.conf"

# include default_dogu in default-dogu.conf
DEFAULT_DOGU=$(doguctl config --global default_dogu)
if [[ $? != 0 ]]; then
  DEFAULT_DOGU="cockpit"
fi
render_template "/etc/nginx/include.d/default-dogu.conf.tpl" > "/etc/nginx/include.d/default-dogu.conf"

# Loop until confd has updated the nginx config
ces-confd -e "http://$(cat /etc/ces/node_master):4001" &
echo "[nginx] ces-confd is listening for changes on etcd..."

# Start nginx
echo "[nginx] starting nginx service..."
exec /usr/sbin/nginx -c /etc/nginx/nginx.conf -g "daemon off;"
