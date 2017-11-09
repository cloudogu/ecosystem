#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

function applyFirewallRules(){

	# allow only ssh, http, https, 8080 and the communication through docker_gwbridge to any port 4001
	ufw allow ssh
	ufw allow http
	ufw allow https
	ufw allow 8080
	# set docker_gwbridge address dynamically so that this rule is always able to work after possible change of docker_gwbridge address
	ufw allow from "$(docker network inspect docker_gwbridge -f '{{(index .IPAM.Config 0).Subnet}}')" to any port 4001
	ufw --force enable
}

#all errors at this point are expected, hence we redirect output of ufw to stdout
applyFirewallRules 2>&1
