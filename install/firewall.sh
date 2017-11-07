#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# create docker_gwbridge network since it is not created automatically by the ecosystem at this step but it is needed for firewall settings
docker network create docker_gwbridge -d bridge --gateway 172.18.0.1 --subnet 172.18.0.0/16 --opt com.docker.network.bridge.enable_icc=false --opt com.docker.network.bridge.enable_ip_masquerade=true --opt com.docker.network.bridge.name=docker_gwbridge

# allow only ssh, http, https, 8080 and the communication through docker_gwbridge to any port 4001
ufw allow ssh
ufw allow http
ufw allow https
ufw allow 8080
# set docker_gwbridge address dynamically so that this rule is always able to work after possible change of docker_gwbridge address
ufw allow from `docker network inspect docker_gwbridge -f '{{(index .IPAM.Config 0).Subnet}}'` to any port 4001
ufw --force enable
