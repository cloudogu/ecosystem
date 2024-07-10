#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# install dev dependencies
DEBIAN_FRONTEND=noninteractive apt-get -y install \
  build-essential \
  zlib1g-dev \
  libssl-dev \
  htop \
  iftop \
  jq \
  ruby \
  ruby-dev \
  facter \
  >/dev/null
