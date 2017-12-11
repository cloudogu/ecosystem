#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# Setting for Security
echo 'AllowTcpForwarding no' >> /etc/ssh/sshd_config
echo 'ClientAliveCountMax 2' >> /etc/ssh/sshd_config
echo 'Compression no' >> /etc/ssh/sshd_config
echo 'MaxAuthTries 2' >> /etc/ssh/sshd_config
echo 'MaxSessions 2' >> /etc/ssh/sshd_config
echo 'AllowAgentForwarding no' >> /etc/ssh/sshd_config

# lines starting with "LogLevel" are changed to "LogLevel VERBOSE"
sed -i 's/^LogLevel.*$/LogLevel VERBOSE/' /etc/ssh/sshd_config
sed -i 's/^PermitRootLogin.*$/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^TCPKeepAlive.*$/TCPKeepAlive no/' /etc/ssh/sshd_config
sed -i 's/^X11Forwarding.*$/X11Forwarding no/' /etc/ssh/sshd_config

#sed -i 's/^Port 22.*$/Port 2222/' /etc/ssh/sshd_config