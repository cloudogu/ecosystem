#!/bin/bash
source /etc/ces/functions.sh
#  # Check if system has got a new IP after reboot
CURRIP=$(get_ip)
LASTIP=$(cat /etc/lastIP)
if [ "${LASTIP}" != "${CURRIP}" ]; then
  # IP changed, reinstall certificates
  $INSTALL_HOME/install/ssl.sh
  # Save current IP address
  echo $CURRIP > /etc/lastIP
fi
