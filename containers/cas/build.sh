#!/bin/bash
docker build -t registry.cloudogu.com/official/cas:4.0.2-1 $(cd "$( dirname "${BASH_SOURCE[0]}" )/docker" && pwd)
