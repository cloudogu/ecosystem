# cesi/base
FROM alpine:3.3
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>
RUN apk add --update bash curl openssl wget curl zip unzip mysql-client ca-certificates && \
rm -rf /var/cache/apk/*

# etcd version
ENV CES_ETCD_VERSION 2.1.3

# install etcd
ADD https://github.com/coreos/etcd/releases/download/v${CES_ETCD_VERSION}/etcd-v${CES_ETCD_VERSION}-linux-amd64.tar.gz /tmp/etcd.tar.gz
RUN mkdir /tmp/etcd \
    && tar xzvf /tmp/etcd.tar.gz -C /tmp/etcd \
    && mv /tmp/etcd/etcd-v${CES_ETCD_VERSION}-linux-amd64/etcdctl /bin \
    && mv /tmp/etcd/etcd-v${CES_ETCD_VERSION}-linux-amd64/etcd /sbin \
    && rm -rf /tmp/etcd*
