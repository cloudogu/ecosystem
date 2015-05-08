# cesi/etcd
FROM cesi/base
MAINTAINER Sebastian Sdorra <sebastian.sdorra@triology.de>

# create etcd user
RUN useradd -d /var/lib/etcd -u 1000 -m -s /bin/bash etcd

# expose volume
VOLUME /var/lib/etcd

# use etcd user
USER etcd

# expose port
EXPOSE 4001

# start etcd
ENTRYPOINT ["/sbin/etcd", "--data-dir", "/var/lib/etcd", "-bind-addr=0.0.0.0:4001"]
