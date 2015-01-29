# cesi/etcd
FROM debian:wheezy
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

ENV CES_ETCD_VERSION 2.0.0

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

RUN curl -L https://github.com/coreos/etcd/releases/download/v${CES_ETCD_VERSION}/etcd-v${CES_ETCD_VERSION}-linux-amd64.tar.gz -o /tmp/etcd.tar.gz \
    && mkdir /etcd \
    && cd /etcd \
    && tar xzvf /tmp/etcd.tar.gz --strip=1 \
    && rm -f /tmp/etcd.tar.gz

RUN useradd -d /var/lib/etcd -u 1000 -m -s /bin/bash etcd

VOLUME /var/lib/etcd

USER etcd
ENTRYPOINT ["/etcd/etcd", "--data-dir", "/var/lib/etcd", "-bind-addr=0.0.0.0:4001"]
