#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

/bin/registrator -internal etcd://$(cat /etc/ces/node_master):4001/services
