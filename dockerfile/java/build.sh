#!/bin/bash
docker build -t cesi/java $(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
