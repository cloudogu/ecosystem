#!/bin/bash

domain=$(cat /etc/ces/domain)
ldapDir=/etc/ldap

# LDAP ALREADY INITIALIZED?
if ! [ -f $ldapDir/ldap.conf  ]; then

fi

# START LDAP
