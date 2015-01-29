#!/bin/bash

source /etc/ces/functions.sh

docker rm registrator
docker run -d \
  --name registrator \
  -h registrator \
  -v /var/run/docker.sock:/var/run/docker.sock \
  cesi/registrator \
  -internal \
  etcd://$(get_ip):4001/services

# consul://$(get_ip):8500
