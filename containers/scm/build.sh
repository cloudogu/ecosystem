#!/bin/bash
docker build -t cesi/scm $(cd "$(dirname "${BASH_SOURCE[0]}")/docker" && pwd)
