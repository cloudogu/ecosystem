#!/bin/bash -e
set -o errexit
set -o nounset
set -o pipefail

DEBIAN_FRONTEND=noninteractive apt-get -y install \
  open-vm-tools
