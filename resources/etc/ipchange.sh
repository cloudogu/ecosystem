#!/bin/bash
source /etc/ces/functions.sh

CURRIP=$(get_ip)
LASTIP=$(cat /etc/lastIP)
LOGFILE=/etc/ipchange.log

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
  echo "ip nach node_master? $?" >> ${LOGFILE}
  if $(valid_ip ${CURRIP}) ; then
    echo "${CURRIP} is a valid IP" >> ${LOGFILE}
    /opt/ces/bin/etcdctl --peers $(cat /etc/ces/node_master):4001 set "/config/_global/fqdn" "${CURRIP}"
    ETCDCTL_EXIT=$?
    echo "etcdctl command set fqdn? ${ETCDCTL_EXIT}" >> ${LOGFILE}
    while [ "${ETCDCTL_EXIT}" -ne "0" ]; do # etcd is not ready yet
      sleep 2
      echo "sleep 2? $?" >> ${LOGFILE}
      /opt/ces/bin/etcdctl --peers $(cat /etc/ces/node_master):4001 set "/config/_global/fqdn" "${CURRIP}"
      ETCDCTL_EXIT=$?
      echo "etcdctl command set fqdn? ${ETCDCTL_EXIT}" >> ${LOGFILE}
    done
  else
    echo "${CURRIP} is no valid IP" >> ${LOGFILE}
  fi
  # Reinstall certificates
  source /etc/environment; ${INSTALL_HOME}/install/ssl.sh
  echo "ssl-sh? $?" >> ${LOGFILE}
  # Save current IP address
  echo $CURRIP > /etc/lastIP
  echo "ip nach lastIP? $?" >> ${LOGFILE}
  echo "" >> ${LOGFILE}
fi
