#!/bin/bash
docker build -t cesi/registrator $(cd "$(dirname "${BASH_SOURCE[0]}")/docker" && pwd)
