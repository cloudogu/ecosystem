#!/bin/bash

# Start nginx
echo "[nginx] starting nginx service..."
exec /usr/sbin/nginx -c /etc/nginx/nginx.conf -g "daemon off;"
