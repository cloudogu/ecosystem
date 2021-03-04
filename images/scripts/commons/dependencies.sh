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
  btrfs-progs \
  apt-transport-https \
  ca-certificates \
  software-properties-common \
  linux-headers-"$(uname -r)" \
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

# install optional dependency linux-image-extra for the given kernel
# this package seems to be unavailable in some environments
IMAGE_EXTRA_PKG=linux-image-extra-"$(uname -r)"
if apt-cache search "${IMAGE_EXTRA_PKG}" | grep "${IMAGE_EXTRA_PKG}" &> /dev/null; then
  echo "installing optional package ${IMAGE_EXTRA_PKG}"
  DEBIAN_FRONTEND=noninteractive  apt-get -y install "${IMAGE_EXTRA_PKG}"
else
  echo "WARNING: could not find optional package ${IMAGE_EXTRA_PKG}"
fi