#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# Disable shellcheck as functions.sh is in ces-commons package
# shellcheck disable=SC1091
source /etc/ces/functions.sh

URL="http://$(get_ip):8080"

cat << EOF
Setup daemon has started and can be accessed at ${URL}
Logs can be viewed by running the following command:

journalctl -u ces-setup.service

To follow the logs append the "-f" flag:

journalctl -u ces-setup.service -f
EOF
