#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

docker network create docker_gwbridge -d bridge --gateway 172.18.0.1 --subnet 172.18.0.0/16 --opt com.docker.network.bridge.enable_icc=false --opt com.docker.network.bridge.enable_ip_masquerade=true --opt com.docker.network.bridge.name=docker_gwbridge

ufw allow ssh
ufw allow http
ufw allow https
ufw allow 8080
ufw allow from `docker network inspect docker_gwbridge -f '{{(index .IPAM.Config 0).Subnet}}'` to any port 4001
ufw --force enable
