#!/bin/bash

BACKUP_PATH=/backup

service slapd stop
mkdir /var/lib/ldap/accesslog
slapadd -F /etc/ldap/slapd.d -n 0 -l ${BACKUP_PATH}/config.ldif
slapadd -F /etc/ldap/slapd.d -n 1 -l ${BACKUP_PATH}/meinedomain.local.ldif
slapadd -F /etc/ldap/slapd.d -n 2 -l ${BACKUP_PATH}/access.ldif
chown -R openldap:openldap /etc/ldap/slapd.d/
chown -R openldap:openldap /var/lib/ldap/
service slapd start
