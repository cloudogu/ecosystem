#!/bin/bash

# install dev dependencies
DEBIAN_FRONTEND=noninteractive apt-get -y install \
 linux-headers-$(uname -r) \
 build-essential \
 zlib1g-dev \
 libssl-dev \
 libreadline-gplv2-dev \
 htop \
 iftop \
 jq \
 ruby \
 ruby-dev \
 facter \
 >/dev/null