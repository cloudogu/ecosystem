#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# perl -p -i -e 's#http://us.archive.ubuntu.com/ubuntu#http://mirror.rackspace.com/ubuntu#gi' /etc/apt/sources.list

# Update the box
DEBIAN_FRONTEND=noninteractive apt-get -y update
DEBIAN_FRONTEND=noninteractive apt-get -y install \
  curl \
  ctop \
  mg \
  jq \
  unzip \
  btrfs-tools \
  apt-transport-https \
  ca-certificates \
  linux-headers-"$(uname -r)" \
  linux-image-extra-"$(uname -r)" \
  linux-image-extra-virtual
#  dmsetup \
#  facter \
#  build-essential \
#  zlib1g-dev \
#  libssl-dev \
#  libreadline-gplv2-dev \
#  htop \
#  iftop \
#  ruby \
#  ruby-dev
