#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# Returns the default network cesnet1, except cesnet1 is an overlay network
# then the docker_gwbridge gets returnes. This is because we have to allow
# the subnet which is used to communicate with the host/internet.
function get_gateway_network(){
  NETWORK="cesnet1"
  DRIVER=$(docker network inspect ${NETWORK} -f '{{.Driver}}')
  if [ "${DRIVER}" == "overlay" ]; then
    NETWORK="docker_gwbridge"
  fi
  echo "${NETWORK}"
}

function apply_firewall_rules(){

	# allow only ssh, http, https, 8080 and the communication through docker_gwbridge to any port 4001
	ufw allow ssh
	ufw allow http
	ufw allow https
	ufw allow 8080

  GW_NETWORK=$(get_gateway_network)

	# set gateway network address dynamically so that this rule is always able to work after possible change of gateway network address
	ufw allow from "$(docker network inspect ${GW_NETWORK} -f '{{(index .IPAM.Config 0).Subnet}}')" to any port 4001
	ufw --force enable
}

#all errors at this point are expected, hence we redirect output of ufw to stdout
apply_firewall_rules 2>&1
