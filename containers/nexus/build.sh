#!/bin/bash
docker build -t registry.cloudogu.com/official/nexus:2.11.4-1 $(cd "$(dirname "${BASH_SOURCE[0]}")/docker" && pwd)
