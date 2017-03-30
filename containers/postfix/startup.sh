#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

source /etc/ces/functions.sh
MAILRELAY=$(get_config relayhost)

name=$(hostname)
domain=$(get_domain)
net=""

if [ ! -f /etc/postfix/configured ]; then
    # GATHERING NETWORKS FROM INTERFACES FOR MYNETWORKS
    for i in $(netstat -nr | grep -v ^0 | grep -v Dest | grep -v Kern| awk '{print $1}' | xargs); do
      mask=$(netstat -nr | grep $i | awk '{print $3}')
      cidr=$(/mask2cidr.sh $mask)
      net="$net $i/$cidr"
    done
    # POSTFIX CONFIG
    postconf -e myhostname="${name}.${domain}"
    postconf -e mydestination="${name}.${domain}, localhost.localdomain, localhost"
    postconf -e mynetworks="127.0.0.1 ${net}"
    postconf -e smtputf8_enable=no
    postconf -e relayhost=$MAILRELAY
    postconf -e smtpd_recipient_restrictions="permit_mynetworks,permit_sasl_authenticated,reject_unauth_destination"
    touch /etc/postfix/configured
fi

# START POSTFIX
exec /usr/lib/postfix/master -d -c /etc/postfix >>/var/log/postfix.log 2>&1
