#!/bin/bash
docker build -t registry.cloudogu.com/official/mysql:10.1.11-1 $(cd "$(dirname "${BASH_SOURCE[0]}")/docker" && pwd)
