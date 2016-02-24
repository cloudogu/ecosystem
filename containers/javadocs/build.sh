#!/bin/bash
docker build -t registry.cloudogu.com/official/javadocs:8u73-1 $(cd "$( dirname "${BASH_SOURCE[0]}" )/docker" && pwd)
