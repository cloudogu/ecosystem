#!/bin/bash
docker build -t cesi/redmine $(cd "$(dirname "${BASH_SOURCE[0]}")/docker" && pwd)
