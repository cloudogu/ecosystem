#!/bin/bash
source /etc/ces/functions.sh

# write current ip
get_ip > /etc/ces/ip_addr
set_config_global fqdn $(get_ip)

# prepare syslog and restart
mkdir /var/log/docker
chown syslog /var/log/docker
service rsyslog restart

# modify sudoers save path
echo "modify sudoers"
if [ -f "/etc/sudoers" ]; then
  grep "/opt/ces/bin" /etc/sudoers &>/dev/null
  if [ $? != 0 ]; then
    sed 's@secure_path="/usr@secure_path="/opt/ces/bin:@g' /etc/sudoers > /tmp/sudoers.new
    if [ $? = 0 ]; then
      visudo -c -f /tmp/sudoers.new &>/dev/null
      if [ $? = 0 ]; then
        cp /tmp/sudoers.new /etc/sudoers
        chown root:root /etc/sudoers
        chmod 0440 /etc/sudoers
      else
        echo 'ERR: sudoers file is not valid'
      fi
    else
      echo "ERR: failed to modify sudoers"
    fi
    rm -f /tmp/sudoers.new
  else
    echo 'sudoers file is already prepared'
  fi
else
  echo 'ERR: sudoers file does not exists'
fi
