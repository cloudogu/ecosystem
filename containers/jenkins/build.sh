#!/bin/bash
docker build -t registry.cloudogu.com/official/jenkins:1.609.2-1 $(cd "$(dirname "${BASH_SOURCE[0]}")/docker" && pwd)
