#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

MAILRELAY=$(doguctl config relayhost)
NAME=$(hostname)
DOMAIN=$(doguctl config --global domain)
NET=""

# GATHERING NETWORKS FROM INTERFACES FOR MYNETWORKS
for i in $(netstat -nr | grep -v ^0 | grep -v Dest | grep -v Kern| awk '{print $1}' | xargs); do
  MASK=$(netstat -nr | grep ${i} | awk '{print $3}')
  CIDR=$(/mask2cidr.sh ${MASK})
  NET="${NET} ${i}/${CIDR}"
done

# POSTFIX CONFIG
postconf -e mydomain="localhost.local"
postconf -e myhostname="${NAME}.${DOMAIN}"
postconf -e mydestination="${NAME}.${DOMAIN}, localhost.localdomain, localhost"
postconf -e mynetworks="127.0.0.1 ${NET}"
postconf -e smtputf8_enable=no
postconf -e relayhost="${MAILRELAY}"
postconf -e smtpd_recipient_restrictions="permit_mynetworks,permit_sasl_authenticated,reject_unauth_destination"

# START POSTFIX
exec /usr/bin/supervisord -c /etc/supervisord.conf
