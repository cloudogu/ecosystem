#!/bin/bash
docker build -t cesi/bugzilla $(cd "$(dirname "${BASH_SOURCE[0]}")/docker" && pwd)
