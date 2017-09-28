#IPTABLES="/sbin/iptables"
#
#echo "building up a firewall"
#
#
#
## drop everything by default
#$IPTABLES -P INPUT DROP
#
#
## allow Ports 22, 80, 443, 8080
#$IPTABLES -A INPUT -p tcp --dport 22 -j ACCEPT
#$IPTABLES -A INPUT -p tcp --dport 80 -j ACCEPT
#$IPTABLES -A INPUT -p tcp --dport 443 -j ACCEPT
#$IPTABLES -A INPUT -p tcp --dport 8080 -j ACCEPT
#
#$IPTABLES -A INPUT -i lo -j ACCEPT
#$IPTABLES -A INPUT -p tcp -s localhost -j ACCEPT
#$IPTABLES -A INPUT -s `docker network inspect docker_gwbridge -f '{{(index .IPAM.Config 0).Subnet}}'` -j ACCEPT
#
## enable logging
#$IPTABLES -A INPUT -j REJECT


docker network create docker_gwbridge -d bridge --gateway 172.18.0.1 --subnet 172.18.0.0/16 --opt com.docker.network.bridge.enable_icc=false --opt com.docker.network.bridge.enable_ip_masquerade=true --opt com.docker.network.bridge.name=docker_gwbridge

ufw allow ssh
ufw allow http
ufw allow https
ufw allow 8080
ufw allow from `docker network inspect docker_gwbridge -f '{{(index .IPAM.Config 0).Subnet}}'` to any port 4001
ufw --force enable