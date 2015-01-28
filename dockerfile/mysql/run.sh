#!/bin/sh

dbDir="/var/lib/ces/mysql"

if ! [ -d $dbDir ]; then
	btrfs subvolume create $dbDir
	if ! [ -d $dbDir/data ]; then
		mkdir $dbDir/data
		chown 1000:1000 $dbDir/data
	fi
fi

docker run -d -p 3306:3306 -v $dbDir/data:/var/lib/mysql cesi/mysql
