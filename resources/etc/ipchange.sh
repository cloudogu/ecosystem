#!/bin/bash
source /etc/ces/functions.sh

CURRIP=$(get_ip)
echo ${CURRIP} > /etc/ces/node_master
LASTIP=$(get_fqdn)

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
  if $(valid_ip ${CURRIP}) ; then
    /opt/ces/bin/etcdctl --peers $(cat /etc/ces/node_master):4001 set "/config/_global/fqdn" "${CURRIP}"
    ETCDCTL_EXIT=$?
    while [ "${ETCDCTL_EXIT}" -ne "0" ]; do # etcd is not ready yet
      sleep 2
      /opt/ces/bin/etcdctl --peers $(cat /etc/ces/node_master):4001 set "/config/_global/fqdn" "${CURRIP}"
      ETCDCTL_EXIT=$?
    done
  fi
  # Reinstall certificates if self-signed
  CERT_TYPE=$(/opt/ces/bin/etcdctl --peers $(cat /etc/ces/node_master):4001 get /config/_global/certificate/type)
  if [ "$CERT_TYPE" == "selfsigned" ]; then
    source /etc/environment; ${INSTALL_HOME}/install/ssl.sh
  fi
  # Save current IP address
  # echo $CURRIP > /etc/lastIP
fi
