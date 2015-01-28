#!/bin/sh

dbDir="/var/lib/ces/mysql"

if ! [ -d $dbDir ]; then
	mkdir -p $dbDir
	chown 1000:1000 $dbDir
fi

docker run -d -p 3306:3306 -v $dbDir:/var/lib/mysql cesi/mysql
