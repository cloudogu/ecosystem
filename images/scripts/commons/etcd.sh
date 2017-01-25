#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

ETCD_VERSION=v2.3.7
ETCD_DATA_DIR=/var/lib/ces/etcd/data

echo "installing etcd version $ETCD_VERSION"

curl -L  https://github.com/coreos/etcd/releases/download/${ETCD_VERSION}/etcd-${ETCD_VERSION}-linux-amd64.tar.gz -o /tmp/etcd.tar.gz
mkdir -p /opt/ces/etcd
tar xfz /tmp/etcd.tar.gz -C /opt/ces/etcd --strip-components=1
mkdir -p /opt/ces/bin
ln -s /opt/ces/etcd/etcdctl /opt/ces/bin/etcdctl
rm -f /tmp/etcd-${ETCD_VERSION}-linux-amd64.tar.gz

useradd etcd
mkdir -p ${ETCD_DATA_DIR}
chown root:etcd ${ETCD_DATA_DIR}
chmod 770 ${ETCD_DATA_DIR}

# write etcd start script
cat << 'EOF' >> /etc/etcdstart.sh
#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

ETCD_DATA_DIR=/var/lib/ces/etcd/data
IP=$(/bin/bash -c 'source /etc/ces/functions.sh; get_ip')

exec /opt/ces/etcd/etcd --data-dir ${ETCD_DATA_DIR} -addr="${IP}":4001
EOF
chown root:etcd /etc/etcdstart.sh
chmod 750 /etc/etcdstart.sh

# write systemd unit file
# from https://github.com/coreos/etcd/blob/2724c3946eb2f3def5ed38a127be982b62c81779/contrib/systemd/etcd.service
cat << 'EOF' >> /etc/systemd/system/etcd.service
[Unit]
Description=CES etcd container
After=network.target

[Service]
User=etcd
Type=notify
ExecStart=/etc/etcdstart.sh
Restart=always
RestartSec=10s
LimitNOFILE=40000

[Install]
WantedBy=multi-user.target

EOF

#description "CES etcd container"
#start on starting docker
#stop on (runlevel [!2345] and stopped docker)
#respawn
#
#script
#  IP=$(bash -c "source /etc/ces/functions.sh; get_ip")
#  mkdir -p /var/lib/ces/etcd/data
#  /opt/ces/etcd/etcd  --data-dir /var/lib/ces/etcd/data -addr="$IP":4001
#end script
#
#post-start script
#  for C in $(seq 1 30); do
#    if $(nc -z "127.0.0.1" 4001); then
#      continue
#    else
#      sleep 0.1
#    fi
#  done
#end script

#EOF

# make it executable
#chmod +x /etc/init/etcd.conf

echo "installing etc version $ETCD_VERSION - end"
