#!/bin/bash
docker build -t cesi/postfix $(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
