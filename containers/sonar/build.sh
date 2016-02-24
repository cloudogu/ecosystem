#!/bin/bash
docker build -t registry.cloudogu.com/official/java/sonar:5.3-1 $(cd "$(dirname "${BASH_SOURCE[0]}")/docker" && pwd)
