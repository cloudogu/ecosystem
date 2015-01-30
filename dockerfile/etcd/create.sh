#!/bin/bash

source /etc/ces/functions.sh

DATADIR="/var/lib/ces/etcd"
if [ ! -d "$DATADIR" ]; then
  btrfs subvolume create "$DATADIR"
  mkdir "$DATADIR/data"
  chown -R 1000:1000 "$DATADIR"
  chmod -R 755 "$DATADIR"
fi

docker rm etcd
docker create \
  --name etcd \
  -h etcd \
  -p 4001:4001 \
  -v /etc/ces:/etc/ces \
  -v "$DATADIR/data":/var/lib/etcd \
  cesi/etcd \
  -addr=$(get_ip):4001
