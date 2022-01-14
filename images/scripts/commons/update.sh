#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# dist upgrade
export DEBIAN_FRONTEND=noninteractive
apt-get -y update
apt-get -y upgrade -o Dpkg::Options::="--force-confnew"

reboot
