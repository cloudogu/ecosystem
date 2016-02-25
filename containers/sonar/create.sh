#!/bin/bash

DATADIR="/var/lib/ces/sonar"
if [ ! -d "$DATADIR" ]; then
  btrfs subvolume create "$DATADIR"
  mkdir "$DATADIR/data"
  chown -R 1000:1000 "$DATADIR"
  chmod -R 755 "$DATADIR"
fi

docker rm -f sonar
docker create \
  --name sonar \
  -h sonar \
  -v /etc/ces:/etc/ces \
  -v "$DATADIR/data":/var/lib/sonar \
  --log-driver="syslog" \
  --log-opt='syslog-tag=sonar' \
  --net=cesnet1 \
  cesi/sonar
