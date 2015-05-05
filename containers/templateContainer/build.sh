#!/bin/bash
docker build -t YOURCONTAINERNAME $(cd "$( dirname "${BASH_SOURCE[0]}" )/docker" && pwd)
