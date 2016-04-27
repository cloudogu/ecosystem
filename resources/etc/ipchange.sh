#!/bin/bash
source /etc/ces/functions.sh

CURRIP=$(get_ip)
LASTIP=$(cat /etc/lastIP)

function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

# Check if system has got a new IP after reboot
if [ "${LASTIP}" != "${CURRIP}" ]; then
  # IP changed
  echo ${CURRIP} > /etc/ces/node_master
  if valid_ip ${CURRIP}; then set_config_global fqdn ${CURRIP}; fi
  # Reinstall certificates
  $INSTALL_HOME/install/ssl.sh
  # Save current IP address
  echo $CURRIP > /etc/lastIP
fi
