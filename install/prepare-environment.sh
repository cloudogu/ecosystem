#!/bin/bash -e
source /etc/ces/functions.sh

# write current ip
source /etc/environment
export PATH

echo "writing ip to master node file"
get_ip > /etc/ces/node_master

# prepare syslog and restart
echo "prepare syslog and restart"
if [ ! -d /var/log/docker ]; then
  mkdir /var/log/docker
fi
chown syslog /var/log/docker
service rsyslog restart

# modify sudoers save path
echo "modify sudoers"
if [ -f "/etc/sudoers" ]; then
  if ! grep "/opt/ces/bin" /etc/sudoers &>/dev/null; then
    if sed 's@secure_path="/usr@secure_path="/opt/ces/bin:@g' /etc/sudoers > /tmp/sudoers.new; then
      if visudo -c -f /tmp/sudoers.new &>/dev/null; then
        cp /tmp/sudoers.new /etc/sudoers
        chown root:root /etc/sudoers
        chmod 0440 /etc/sudoers
      else
        >&2 echo 'ERR: sudoers file is not valid'
      fi
    else
      >&2 echo "ERR: failed to modify sudoers"
    fi
    rm -f /tmp/sudoers.new
  else
    >&2 echo 'sudoers file is already prepared'
  fi
else
  >&2 echo 'ERR: sudoers file does not exists'
fi
