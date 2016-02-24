#!/bin/bash
docker build -t registry.cloudogu.com/official/redmine:3.0.5-1 $(cd "$(dirname "${BASH_SOURCE[0]}")/docker" && pwd)
