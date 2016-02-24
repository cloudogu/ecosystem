#!/bin/bash
docker build -t registry.cloudogu.com/official/universeadm:1.2.0-1 $(cd "$(dirname "${BASH_SOURCE[0]}")/docker" && pwd)
