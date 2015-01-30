#!/bin/bash
docker build -t cesi/mysql $(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
