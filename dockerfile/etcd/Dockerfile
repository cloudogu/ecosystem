# cesi/etcd
FROM cesi/base
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

RUN useradd -d /var/lib/etcd -u 1000 -m -s /bin/bash etcd

VOLUME /var/lib/etcd

USER etcd

ENTRYPOINT ["/sbin/etcd", "--data-dir", "/var/lib/etcd", "-bind-addr=0.0.0.0:4001"]
