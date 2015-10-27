#!/bin/sh

dbDir="/var/lib/ces/mysql"

if ! [ -d $dbDir ]; then
	btrfs subvolume create $dbDir
	if ! [ -d $dbDir/data ]; then
		mkdir $dbDir/data
		chown 1000:1000 $dbDir/data
	fi
fi

docker create \
	--name mysql \
	-h mysql \
	-v /etc/ces:/etc/ces \
	-v $dbDir/data:/var/lib/mysql \
	--log-driver="syslog" \
	--log-opt='syslog-tag=mysql' \
	cesi/mysql
