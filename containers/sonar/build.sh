#!/bin/bash
docker build -t cesi/sonar $(cd "$(dirname "${BASH_SOURCE[0]}")/docker" && pwd)
