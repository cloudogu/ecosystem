#!/bin/bash

function get_ip(){
  IPS=$(/sbin/ifconfig | grep eth -A1 | grep addr: | awk '{print $2}' | awk -F':' '{print $2}')
  COUNT=$(echo $IPS | wc -w)
  if [ $COUNT -gt 1 ]; then
    TYPE=$(cat /etc/ces/type)
    if [ $TYPE = "vagrant" ]; then
      VIP=$(echo $IPS | awk '{print $1}')
      for IP in $IPS; do
        echo $IP | grep 192\.168\.115\. > /dev/null
        if [ $? -eq 0 ]; then
          VIP="$IP"
        fi
      done
      echo $VIP
    else
      echo $IPS | awk '{print $1}'
    fi
  else
    echo $IPS
  fi
}

export -f get_ip

function get_domain(){
  cat /etc/ces/domain
}

export -f get_domain

function get_fqdn(){
  if [ -f '/etc/ces/fqdn' ]; then
    cat /etc/ces/fqdn
  else
    get_ip
  fi
}

export -f get_fqdn
