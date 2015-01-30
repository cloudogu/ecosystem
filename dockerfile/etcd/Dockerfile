# cesi/etcd
FROM cesi/base
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

ENV CES_ETCD_VERSION 2.0.0

ADD https://github.com/coreos/etcd/releases/download/v${CES_ETCD_VERSION}/etcd-v${CES_ETCD_VERSION}-linux-amd64.tar.gz /tmp/etcd.tar.gz
RUN mkdir /etcd \
    && cd /etcd \
    && tar xzvf /tmp/etcd.tar.gz --strip=1 \
    && rm -f /tmp/etcd.tar.gz


RUN useradd -d /var/lib/etcd -u 1000 -m -s /bin/bash etcd

VOLUME /var/lib/etcd

USER etcd

ENTRYPOINT ["/etcd/etcd", "--data-dir", "/var/lib/etcd", "-bind-addr=0.0.0.0:4001"]
