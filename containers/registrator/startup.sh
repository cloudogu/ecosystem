#!/bin/bash
/bin/registrator -internal etcd://$(cat /etc/ces/ip_addr):4001/services
