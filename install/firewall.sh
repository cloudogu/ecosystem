#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

#all errors at this point are expected, hence we redirect output of ufw to stdout

# allow only ssh, http, https, 8080 and the communication through docker_gwbridge to any port 4001
ufw allow ssh 2>&1
ufw allow http 2>&1
ufw allow https 2>&1
ufw allow 8080 2>&1
# set docker_gwbridge address dynamically so that this rule is always able to work after possible change of docker_gwbridge address
ufw allow from $(docker network inspect docker_gwbridge -f '{{(index .IPAM.Config 0).Subnet}}') to any port 4001 2>&1
ufw --force enable 2>&1
