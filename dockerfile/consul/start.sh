#!/bin/bash
/consul/bin/consul agent -config-dir=/consul/config -advertise=$(cat /etc/ces/ip_addr) -server -bootstrap
