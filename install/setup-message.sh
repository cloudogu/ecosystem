#!/bin/bash
source /etc/ces/functions.sh

# write current ip
source /etc/environment
export PATH

if [ -f "/vagrant/setup.json" ]; then
  echo "The unattenden setup has started with instruction from /vagrant/setup.json"
else
  URL=http://$(get_ip):8080
  echo "the setup daemon has started and can be accessed at $URL"
fi
echo "The setup runs in background and writes its logs to /var/log/upstart/ces-setup.log"
