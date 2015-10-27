#!/bin/sh

mailDir="/var/lib/ces/postfix"

if ! [ -d $mailDir ]; then
	btrfs subvolume create $mailDir
	if ! [ -d $dbDir/conf ]; then
		mkdir $dbDir/conf
		chown 1000:1000 $dbDir/conf
	fi
fi

docker create \
	--name postfix \
	-h mail \
	-v /etc/ces:/etc/ces \
	-v $mailDir/conf:/etc/postfix \
	--log-driver="syslog" \
	--log-opt='syslog-tag=postfix' \
	cesi/postfix
