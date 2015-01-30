#!/bin/bash

domain=$(cat /etc/ces/domain)
ldapDir=/etc/ldap

# LDAP ALREADY INITIALIZED?
if ! [ -f $ldapDir/ldap.conf  ]; then
	if ! [ -d $ldapDir ]; then
		mkdir -p $ldapDir
	fi
	# DEPLOY STANDARD LDAP DB AND CONFIG
	# DC=CLOUDOGU,DC=COM
	cd /
	tar xvfz ldappackage.tgz
	cd /backup
	tar xvfz el.tgz
	tar xvfz vll.tgz
        cd /backup
	cd var/lib/ldap && mv * /var/lib/ldap/
        cd /backup
	cd etc/ldap && mv * /etc/ldap/
        cd /backup
	/backup/ldaprestore.sh
fi

# START LDAP
/usr/sbin/slapd -h "ldap:///" -4 -u openldap -g openldap -d 0
