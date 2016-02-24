#!/bin/bash
docker build -t registry.cloudogu.com/official/ldap:2.4.43-1 $(cd "$(dirname "${BASH_SOURCE[0]}")/docker" && pwd)
