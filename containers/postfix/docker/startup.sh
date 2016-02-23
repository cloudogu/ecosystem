#!/bin/bash

source /etc/ces/functions.sh
MAILRELAY="192.168.115.24"

name=$(hostname)
domain=$(get_domain)

if [ ! -f /etc/postfix/configured ]; then
    net=$(ip route | tail -n1 | awk '{print $1}')
    # POSTFIX CONFIG
    postconf -e myhostname="${name}.${domain}"
    postconf -e mydestination="${name}.${domain}, ${domain}, localhost.localdomain, localhost"
    postconf -e mynetworks="127.0.0.1 ${net}"
    postconf -e smtputf8_enable=no
    postconf -e relayhost=$MAILRELAY
    touch /etc/postfix/configured
fi

# START POSTFIX
/usr/lib/postfix/master -d -c /etc/postfix >>/var/log/postfix.log 2>&1
