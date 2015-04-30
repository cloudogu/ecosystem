#!/bin/bash
docker build -t cesi/universeadm $(cd "$(dirname "${BASH_SOURCE[0]}")/docker" && pwd)
