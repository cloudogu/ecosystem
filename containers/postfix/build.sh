#!/bin/bash
docker build -t registry.cloudogu.com/official/postfix:3.0.4-1 $(cd "$(dirname "${BASH_SOURCE[0]}")/docker" && pwd)
