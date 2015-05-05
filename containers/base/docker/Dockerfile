# cesi/base
FROM debian:wheezy
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

# fix some apt installation problems
ENV DEBIAN_FRONTEND noninteractive

# install common packages
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends openssl wget curl zip unzip ca-certificates mysql-client \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# etcd version
# TODO use same as system (install-etcd.sh)
ENV CES_ETCD_VERSION 2.0.10

# install etcd
ADD https://github.com/coreos/etcd/releases/download/v${CES_ETCD_VERSION}/etcd-v${CES_ETCD_VERSION}-linux-amd64.tar.gz /tmp/etcd.tar.gz
RUN mkdir /tmp/etcd \
    && tar xzvf /tmp/etcd.tar.gz -C /tmp/etcd --strip=1 \
    && mv /tmp/etcd/etcdctl /bin \
    && mv /tmp/etcd/etcd /sbin \
    && rm -rf /tmp/etcd*
