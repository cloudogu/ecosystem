#!/bin/bash
docker build -t cesi/etcd $(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
