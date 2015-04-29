#!/bin/bash
docker build -t cesi/jenkins $(cd "$(dirname "${BASH_SOURCE[0]}")/docker" && pwd)
