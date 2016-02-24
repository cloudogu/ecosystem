#!/bin/bash
docker build -t registry.cloudogu.com/official/scm:1.46-1 $(cd "$(dirname "${BASH_SOURCE[0]}")/docker" && pwd)
