#!/bin/bash
docker build -t cesi/javadocs $(cd "$( dirname "${BASH_SOURCE[0]}" )/docker" && pwd)
