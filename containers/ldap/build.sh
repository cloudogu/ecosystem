#!/bin/bash
docker build -t cesi/ldap $(cd "$(dirname "${BASH_SOURCE[0]}")/docker" && pwd)
