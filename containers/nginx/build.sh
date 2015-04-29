#!/bin/bash
docker build -t cesi/nginx $(cd "$(dirname "${BASH_SOURCE[0]}")/docker" && pwd)
