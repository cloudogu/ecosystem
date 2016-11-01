#!/bin/bash
source /etc/ces/functions.sh

CURRIP=$(get_ip)
echo ${CURRIP} > /etc/ces/node_master
end=$((SECONDS+20)) # wait for max. 20 seconds
LASTIP=$(/opt/ces/bin/etcdctl --peers ${CURRIP}:4001 get /config/_global/fqdn)
while [ $SECONDS -lt $end ] && [ -z $LASTIP ]; do
  echo "$(date +%T): etcd unavailable, trying again..."
  sleep 0.25
  LASTIP=$(/opt/ces/bin/etcdctl --peers ${CURRIP}:4001 get /config/_global/fqdn)
  CURRIP=$(get_ip)
  echo ${CURRIP} > /etc/ces/node_master
done

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
# or last IP was empty or not an IP
if [ "${LASTIP}" != "${CURRIP}" ] && [ ! -z $LASTIP ] && $(valid_ip ${LASTIP}); then
  echo "$(date +%T): IP has changed from >${LASTIP}< to >${CURRIP}<"
  # IP changed
  if $(valid_ip ${CURRIP}) ; then
    echo "$(date +%T): ${CURRIP} is a valid IP; setting fqdn"
    /opt/ces/bin/etcdctl --peers $(cat /etc/ces/node_master):4001 set "/config/_global/fqdn" "${CURRIP}"
    ETCDCTL_EXIT=$?
    end=$((SECONDS+20)) # wait for max. 20 seconds
    while [ "${ETCDCTL_EXIT}" -ne "0" ] && [ $SECONDS -lt $end ]; do # etcd is not ready yet
      echo "$(date +%T): Redo setting fqdn"
      /opt/ces/bin/etcdctl --peers $(cat /etc/ces/node_master):4001 set "/config/_global/fqdn" "${CURRIP}"
      ETCDCTL_EXIT=$?
      sleep 0.25
    done
  else
    echo "$(date +%T): ${CURRIP} is no valid IP!"
  fi
  # Reinstall certificates if self-signed
  CERT_TYPE=$(/opt/ces/bin/etcdctl --peers $(cat /etc/ces/node_master):4001 get /config/_global/certificate/type)
  if [ "$CERT_TYPE" == "selfsigned" ]; then
    echo "$(date +%T): certificate type is selfsigned"
    source /etc/environment;
    if [ $(cat /etc/ces/type) == "vagrant" ]; then
      end=$((SECONDS+20)) # wait for max. 20 seconds
      while [ ! -f ${INSTALL_HOME}/install/ssl.sh ] && [ $SECONDS -lt $end ]
      do
        sleep 0.25
        echo "$(date +%T): waiting for ${INSTALL_HOME}/install/ssl.sh to become available..."
      done
    fi
    if [ -f ${INSTALL_HOME}/install/ssl.sh ]; then
      ${INSTALL_HOME}/install/ssl.sh
    else
      echo "$(date +%T): ${INSTALL_HOME}/install/ssl.sh does not exist"
    fi
  else
    echo "$(date +%T): certificate type is not selfsigned"
  fi
else
  echo "$(date +%T): IP has not changed or last IP (${LASTIP}) is empty or not an IP. Current IP = $CURRIP"
fi
