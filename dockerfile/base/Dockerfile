# cesi/base
FROM debian:wheezy
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

# fix some apt installation problems
ENV DEBIAN_FRONTEND noninteractive

# install common packages
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends openssl wget curl zip unzip ca-certificates \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
