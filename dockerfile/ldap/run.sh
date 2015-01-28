#!/bin/sh

dbDir="/var/lib/ces/ldap"

if ! [ -d $dbDir ]; then
	btrfs subvolume create $dbDir
	if ! [ -d $dbDir/data ]; then
		mkdir $dbDir/data
		chown 1000:1000 $dbDir/data
	fi
fi

docker run -d -p 389:389 -v $dbDir/data:/etc/ldap -v /etc/ces:/etc/ces cesi/ldap
#docker run -p 389:389 -v $dbDir/data:/etc/ldap -v /etc/ces:/etc/ces cesi/ldap
#docker run -p 389:389 cesi/ldap
