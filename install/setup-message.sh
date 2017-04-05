#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

source /etc/ces/functions.sh

# write current ip
source /etc/environment
export PATH

URL=http://$(get_ip):8080
echo "the setup daemon has started and can be accessed at $URL"
echo "The setup runs in background and writes its logs to /var/log/upstart/ces-setup.log"
