#!/bin/bash

# fqdn functions

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

# encryption & decryption

function get_secret_key(){
  if [ ! -f '/etc/ces/.secretkey' ]; then
    uuidgen | shasum | awk '{print $1}' > '/etc/ces/.secretkey'
  fi
  cat '/etc/ces/.secretkey'
}

export -f get_secret_key

function encrypt(){
  VALUE="$1"
  KEY=$(get_secret_key)
  echo $VALUE | openssl enc -aes-128-cbc -a -salt -pass "pass:$KEY"
}

export -f encrypt

function decrypt(){
  VALUE="$1"
  KEY=$(get_secret_key)
  echo $VALUE | openssl enc -aes-128-cbc -a -d -salt -pass "pass:$KEY"
}

export -f decrypt

# ces passwd

function add_ces_user(){
  CESUSER="$1"
  CESPASS="$2"
  echo "$CESUSER:"$(encrypt "$CESPASS") >> /etc/ces/.passwd
}

export -f add_ces_user

function get_ces_pass(){
  CESUSER="$1"
  if [ -f "/etc/ces/.passwd" ]; then
    CESPASS=$(cat /etc/ces/.passwd | grep "$CESUSER" | awk -F':' '{print $2}')
    if [ $? = 0 ]; then
      decrypt "$CESPASS"
    else
      exit 1
    fi
  else
    exit 2
  fi
}

export -f get_ces_pass

function generate_password(){
  openssl rand -base64 16 | cut -c1-16
}

export -f generate_password

function create_or_get_ces_pass(){
  CESUSER="$1"
  CESPASS=$(get_ces_pass $CESUSER)
  if [ $? != 0 ]; then
    CESPASS=$(generate_password)
    add_ces_user "$CESUSER" "$CESPASS"
    echo $CESPASS
  else
    echo $CESPASS
  fi
}

export -f create_or_get_ces_pass
