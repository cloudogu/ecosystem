#!/bin/bash
docker build -t registry.cloudogu.com/official/java:8u73-1 $(cd "$(dirname "${BASH_SOURCE[0]}")/docker" && pwd)
