#!/bin/bash
/bin/registrator -internal etcd://$(cat /etc/ces/node_master):4001/services
