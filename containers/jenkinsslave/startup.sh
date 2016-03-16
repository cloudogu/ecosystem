#!/bin/bash

source /etc/ces/functions.sh
keys="rsa dsa ecdsa ed25519"

# GENERATE KEYS for SSHD
for key in ${keys}; do
  if ! [ -f "/etc/ssh/ssh_host_${key}_key" ]; then
    echo "INFO - ${key} key not found - key will now be generated"
    ssh-keygen -t ${key} -f /etc/ssh/ssh_host_${key}_key -N ''
  fi
done

# IMPORT JENKINS PUBLIC KEY FROM ETCD [ /config/jenkins/pubkey ]
echo "INFO - retrieving public key of jenkins master from etcd"
if ! [ -d "/home/jenkins/.ssh" ]; then
	su - jenkins -c "mkdir -p /home/jenkins/.ssh"
fi
su - jenkins -c "etcdctl --peers $(cat /etc/ces/node_master):4001 get /config/jenkins/pubkey > /home/jenkins/.ssh/authorized_keys"


# IDC CONFIGURE JENKINS MASTER TO USE THIS SLAVE [ NODECONFIG, JAVAPATH ... ]
echo "CONFIGURE JENKINS MASTER TI USE THIS SLAVE - TBD"

# SSHD START WITH CONFIG IN /etc/ssh/sshd_config NOT DAEMONIZING (-D) writing debug logs to standard error (-e)
exec /usr/sbin/sshd -D -e -f /etc/ssh/sshd_config
