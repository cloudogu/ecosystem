#!/bin/bash

# github helper

function github_download(){
  # cesmarvin access token
  AUTH_TOKEN="5dfbee7fba188abb6f9c28ccbf32fc0e7c8bd8a8"

  # parameters
  URL="$1"
  TARGET="$2"

  # get required parts from the browser download url
  USER=$(echo $URL | awk -F'/' '{print $4}')
  REPO=$(echo $URL | awk -F'/' '{print $5}')
  TAG=$(echo $URL | awk -F'/' '{print $8}')
  ASSET=$(echo $URL | awk -F'/' '{print $9}')

  # get asset url
  DOWNLOAD_URL=$(curl -s -H "Authorization: token ${AUTH_TOKEN}" "https://api.github.com/repos/${USER}/${REPO}/releases" | jq ".[] | select(.name==\"${TAG}\") | .assets[] | select(.name==\"${ASSET}\") | .url" --raw-output)
  # download asset
  if [ "$TARGET" != "" ]; then
    curl -H "Accept: application/octet-stream" -L "${DOWNLOAD_URL}?access_token=${AUTH_TOKEN}" -o "${TARGET}"
  else
    curl -H "Accept: application/octet-stream" -L "${DOWNLOAD_URL}?access_token=${AUTH_TOKEN}"
  fi
}

export -f github_download

# configuration helper functions

function get_config(){
  KEY=$1
  VALUE=$(eval echo \$CONFIG_${KEY^^})
  if [ "$VALUE" == "" ]; then
    VALUE=$(get_config_local $KEY)
    if [ "$VALUE" == "" ]; then
      VALUE=$(get_config_global $KEY)
    fi
  fi
  echo $VALUE
}

export -f get_config

function get_config_local(){
  KEY=$1
  if [ $(etcdctl --peers $(cat /etc/ces/node_master):4001 ls "/config" | grep "/config/$(hostname)$" | wc -l) -eq 1 ]; then
    if [ $(etcdctl --peers $(cat /etc/ces/node_master):4001 ls "/config/$(hostname)" | grep "/config/$(hostname)/$KEY$" | wc -l) -eq 1 ]; then
  	  VALUE=$(etcdctl --peers $(cat /etc/ces/node_master):4001 get "/config/$(hostname)/$KEY")
    fi
  fi
  echo $VALUE
}

export -f get_config_local

function del_config_local(){
  KEY=$1
  $(etcdctl --peers $(cat /etc/ces/node_master):4001 rm "/config/$(hostname)/$KEY")
}

export -f del_config_local

function get_config_global(){
  KEY=$1
  if [ $(etcdctl --peers $(cat /etc/ces/node_master):4001 ls "/config/_global" | grep "/config/_global/$KEY$" | wc -l) -eq 1 ]; then
    VALUE=$(etcdctl --peers $(cat /etc/ces/node_master):4001 get "/config/_global/$KEY")
  else
    echo "ERROR KEY $1 not found in /config/$(hostname) or /config/_global"
  fi
  echo $VALUE
}

export -f get_config_global

function get_enc_config(){
  KEY=$1
  VALUE_ENC=$(get_config_local $KEY)
  VALUE=$(decrypt $VALUE_ENC $(get_private_secret))
  echo $VALUE
}

export -f get_enc_config

function set_config(){
  KEY=$1
  VALUE=$2
  SERVICE_NAME=$(hostname)
  etcdctl --peers $(cat /etc/ces/node_master):4001 set "/config/$SERVICE_NAME/$KEY" "$VALUE"
}

export -f set_config

function set_enc_config(){
  KEY=$1
  VALUE=$2
  VALUE_ENC=$(encrypt $VALUE $(get_private_secret))
  set_config $KEY $VALUE_ENC
}

export -f set_enc_config

function set_config_global(){
  KEY=$1
  VALUE=$2
  etcdctl --peers $(cat /etc/ces/node_master):4001 set "/config/_global/$KEY" "$VALUE"
}

export -f set_config_global


# fqdn functions

function get_ip(){
  IPS=$(/sbin/ifconfig | grep eth -A1 | grep addr: | awk '{print $2}' | awk -F':' '{print $2}')
  COUNT=$(echo $IPS | wc -w)
  if [ $COUNT -gt 1 ]; then
    TYPE=$(cat /etc/ces/type)
    if [ $TYPE = "vagrant" ]; then
      VIP=$(echo $IPS | awk '{print $1}')
      for IP in $IPS; do
        echo $IP | grep 192\.168\. > /dev/null
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
  echo $(get_config domain)
}

export -f get_domain

function get_fqdn(){
  VALUE=$(get_config "fqdn")
  if [ "$VALUE" == "" ]; then
    echo $(cat /etc/ces/node_master)
    else
      echo $VALUE
  fi

}

export -f get_fqdn

# utils functions

function render_template(){
  FILE="$1"
  if [ ! -f "$FILE" ]; then
    echo >&2 "could not find template $FILE"
    exit 1
  fi

  # render template
  eval "echo \"$(cat $FILE)\""
}

export -f render_template

function render_template_clean(){
  # render template
  render_template "$1" | egrep -v '^#' | egrep -v '^\s*$' > "$FILE"
}

export -f render_template_clean

# encryption & decryption

function generate_secret(){
  openssl rand -base64 32 | cut -c1-32
}
export -f generate_secret

function get_private_secret(){
  if [ ! -f '/private/secret' ]; then
    mkdir '/private'
    touch '/private/secret'
    $(generate_secret) > '/private/secret'
  fi
  cat '/private/secret'
}

export -f get_private_secret

function get_secret_key(){
  if [ ! -f '/etc/ces/.secretkey' ]; then
    $(generate_secret) > '/etc/ces/.secretkey'
  fi
  cat '/etc/ces/.secretkey'
}
export -f get_secret_key

function encrypt(){
  VALUE="$1"
  KEY="$2"
  if [ $KEY == "" ];then
    KEY=$(get_secret_key)
  fi
  echo $VALUE | openssl enc -aes-128-cbc -a -salt -pass "pass:$KEY"
}

export -f encrypt

function decrypt(){
  VALUE="$1"
  KEY="$2"
  if [ $KEY == "" ];then
    KEY=$(get_secret_key)
  fi
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

# services

function get_service(){
  NAME=$1
  PORT=$2

  etcdctl --peers $(cat /etc/ces/node_master):4001 get "/services/$NAME/registrator:$NAME:$PORT" | sed -e 's@.*"service"\s*:\s*"\([0-9\.:]*\)".*@\1@g'
}

export -f get_service

function get_service_ip(){
  get_service "$1" "$2" | awk -F':' '{print $1}'
}

export -f get_service_ip
