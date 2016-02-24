#!/bin/sh

DATADIR="/var/lib/ces/ldap"

if ! [ -d $DATADIR ]; then
	btrfs subvolume create $DATADIR
	if ! [ -d $DATADIR/data ]; then
		mkdir -p $DATADIR/data/config
		mkdir -p $DATADIR/data/db
		chown -R 102:102 $DATADIR/data
	fi
fi

docker rm -f ldap
docker create \
  --name ldap \
  -h ldap \
	-v $DATADIR/data/config:/etc/ceslap \
	-v $DATADIR/data/db:/var/lib/openldap \
	-v /etc/ces:/etc/ces \
	--log-driver="syslog" \
	--log-opt='syslog-tag=ldap' \
	--net=cesnet1 \
	registry.cloudogu.com/official/ldap:2.4.43-1
