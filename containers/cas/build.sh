#!/bin/bash
docker build -t cesi/cas $(cd "$( dirname "${BASH_SOURCE[0]}" )/docker" && pwd)
