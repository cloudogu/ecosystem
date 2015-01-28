#!/bin/bash

domain=$(cat /etc/ces/domain)
ldapDir=/etc/ldap

# LDAP ALREADY INITIALIZED?
if ! [ -f $ldapDir/ldap.conf  ]; then
	if ! [ -d $ldapDir ]; then
		mkdir -p $ldapDir
	fi
	mv /ldap.tgz /etc/ldap/ldap.tgz
	cd /etc/ldap/
	tar xvfz ldap.tgz
	mv ldap.tgz/* .
	rm -rf ldap.tgz
fi

# START LDAP
/usr/sbin/slapd -h "ldap:///" -u openldap -g openldap -d 0
