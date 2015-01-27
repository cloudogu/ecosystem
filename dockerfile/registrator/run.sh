#!/bin/bash

source /etc/ces/functions.sh

docker rm registrator
docker run \
  --name registrator \
  -h registrator \
  -v /var/run/docker.sock:/var/run/docker.sock \
  cesi/registrator \
  consul://$(get_ip):8500
