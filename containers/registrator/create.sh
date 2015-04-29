#!/bin/bash

source /etc/ces/functions.sh

docker rm registrator

# the -internal flag is used to publish the internal container ips to nginx.
# In a cluster mode we have to use -ip with the public ip of the node, we must
# also publish the ports of the applications with -p or with -P.

docker create \
  --name registrator \
  -h registrator \
  -v /var/run/docker.sock:/var/run/docker.sock \
  cesi/registrator \
  -internal \
  etcd://$(get_ip):4001/services
