#!/bin/bash
docker build -t cesi/base $(cd "$(dirname "${BASH_SOURCE[0]}")/docker" && pwd)
