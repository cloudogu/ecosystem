#!/bin/bash

ETCD_VERSION=v2.1.3

function install_etcd(){
  curl -L  https://github.com/coreos/etcd/releases/download/${ETCD_VERSION}/etcd-${ETCD_VERSION}-linux-amd64.tar.gz -o /tmp/etcd.tar.gz
  mkdir -p /opt/ces/etcd
  tar xfz /tmp/etcd.tar.gz -C /opt/ces/etcd --strip-components=1
  mkdir -p /opt/ces/bin
  ln -s /opt/ces/etcd/etcdctl /opt/ces/bin/etcdctl
  rm -f /tmp/etcd-${ETCD_VERSION}-linux-amd64.tar.gz
}

if [ ! -d "/opt/ces/etcd" ]; then
  install_etcd
fi
