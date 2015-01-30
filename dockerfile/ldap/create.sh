#!/bin/sh

ldapDir="/var/lib/ces/ldap"

if ! [ -d $ldapDir ]; then
	btrfs subvolume create $ldapDir
	if ! [ -d $ldapDir/data ]; then
		mkdir -p $ldapDir/data/config
		mkdir -p $ldapDir/data/db
		chown -R 102:102 $ldapDir/data
	fi
fi

docker rm -f ldap
docker create --name ldap -h ldap -v $ldapDir/data/config:/etc/ldap -v /etc/ces:/etc/ces -v $ldapDir/data/db:/var/lib/ldap cesi/ldap
