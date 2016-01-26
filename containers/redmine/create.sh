#!/bin/bash

DATADIR="/var/lib/ces/redmine"
if [ ! -d "$DATADIR" ]; then
  btrfs subvolume create "$DATADIR"
  mkdir "$DATADIR/data"
  chown -R 1000:1000 "$DATADIR"
  chmod -R 755 "$DATADIR"
fi

docker rm redmine
docker create \
  --name redmine \
  -h redmine \
  -v /etc/ces:/etc/ces \
  -v "$DATADIR/data":/var/lib/redmine \
  --log-driver="syslog" \
  --log-opt='syslog-tag=redmine' \
  --net=cesnet1 \
  cesi/redmine
