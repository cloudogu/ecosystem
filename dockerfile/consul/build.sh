#!/bin/bash
docker build -t cesi/consul $(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
