IPTABLES="/sbin/iptables"

echo "building up a firewall"

# drop everything by default
$IPTABLES -P INPUT DROP


# allow Ports 22, 80, 443, 8080
$IPTABLES -A INPUT -p tcp --dport 22 -j ACCEPT
$IPTABLES -A INPUT -p tcp --dport 80 -j ACCEPT
$IPTABLES -A INPUT -p tcp --dport 443 -j ACCEPT
$IPTABLES -A INPUT -p tcp --dport 8080 -j ACCEPT
$IPTABLES -A INPUT -i lo -j ACCEPT # ohne diesen Befehl laeuft cesnet1 nicht!

$IPTABLES -A INPUT -s `docker network inspect cesnet1 -f '{{(index .IPAM.Config 0).Subnet}}'` -j ACCEPT
$IPTABLES -A INPUT -p tcp -m tcp --dport 4001 -d `docker network inspect cesnet1 -f '{{(index .IPAM.Config 0).Subnet}}'` -j ACCEPT
$IPTABLES -A INPUT -p tcp -m tcp --sport 4001 -s `docker network inspect cesnet1 -f '{{(index .IPAM.Config 0).Subnet}}'` -j ACCEPT
$IPTABLES -A INPUT -p tcp -m tcp --sport 4001 -d `docker network inspect cesnet1 -f '{{(index .IPAM.Config 0).Subnet}}'` -j ACCEPT
$IPTABLES -A INPUT -s `docker network inspect cesnet1 -f '{{(index .IPAM.Config 0).Subnet}}'` -j ACCEPT
$IPTABLES -A INPUT -s `docker network inspect docker_gwbridge -f '{{(index .IPAM.Config 0).Subnet}}'` -j ACCEPT
$IPTABLES -A INPUT -p tcp -s localhost -j ACCEPT
$IPTABLES -A INPUT -p tcp -m tcp --dport 4001 -s `docker network inspect cesnet1 -f '{{(index .IPAM.Config 0).Subnet}}'` -j ACCEPT

# enable logging
$IPTABLES -A INPUT -j REJECT

#cd ../../vagrant/images/scripts/commons/


