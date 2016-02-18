#!/bin/bash
docker rm nginx
docker create \
  --name nginx \
  -h nginx \
  -p 80:80 \
  -p 443:443 \
  -v /etc/ces:/etc/ces \
  --log-driver="syslog" \
  --log-opt='syslog-tag=nginx' \
  --net=cesnet1 \
  cesi/nginx
