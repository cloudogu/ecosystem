#!/bin/bash

ETCD_VERSION=v2.1.3

function install_etcd(){
  curl -L  https://github.com/coreos/etcd/releases/download/${ETCD_VERSION}/etcd-${ETCD_VERSION}-linux-amd64.tar.gz -o /tmp/etcd.tar.gz
  mkdir -p /opt/ces/etcd
  tar xfz /tmp/etcd.tar.gz -C /opt/ces/etcd --strip-components=1
  mkdir -p /opt/ces/bin
  ln -s /opt/ces/etcd/etcdctl /opt/ces/bin/etcdctl
  rm -f /tmp/etcd-${ETCD_VERSION}-linux-amd64.tar.gz

  # write upstart start script
  cat << 'EOF' >> /etc/init/etcd.conf
description "CES etcd container"
author "Sebastian Sdorra <sebastian.sdorra@triology.de>"
start on starting docker
stop on (runlevel [!2345] and stopped docker)
respawn

script
  mkdir -p /var/lib/ces/etcd/data
  /opt/ces/etcd/etcd  --data-dir /var/lib/ces/etcd/data -addr=$(cat /etc/ces/ip_addr):4001
end script

post-start script
  CIP=$(docker inspect --format '{{.NetworkSettings.IPAddress}}' etcd)
  for C in $(seq 1 30); do
    if $(nc -z "$CIP" 4001); then
      continue
    else
      sleep 0.1
    fi
  done
end script

EOF

  # make it executable
  chmod +x /etc/init/etcd.conf
}

if [ ! -d "/opt/ces/etcd" ]; then
  install_etcd
fi
