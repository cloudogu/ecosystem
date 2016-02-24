#!/bin/bash
VERSION=4.0.2-1

DATADIR="/var/lib/ces/cas"
if [ ! -d "$DATADIR" ]; then
  btrfs subvolume create "$DATADIR"
  mkdir "$DATADIR/data"
  chown -R 1000:1000 "$DATADIR"
  chmod -R 755 "$DATADIR"
fi

docker rm cas
docker create \
  --name cas \
  -h cas \
  -v /etc/ces:/etc/ces \
  -v "$DATADIR/data":/var/lib/cas \
  --log-driver="syslog" \
  --log-opt='syslog-tag=cas' \
  --net=cesnet1 \
  registry.cloudogu.com/official/cas:4.0.2-1 
