#!/bin/bash
docker build -t cesi/nexus $(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
