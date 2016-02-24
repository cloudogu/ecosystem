#!/bin/bash
docker build -t registry.cloudogu.com/official/registrator:0.6.0 $(cd "$(dirname "${BASH_SOURCE[0]}")/docker" && pwd)
