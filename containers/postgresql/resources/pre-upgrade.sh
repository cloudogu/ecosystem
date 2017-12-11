#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

pg_dumpall -U postgres -f "${PGDATA}"/postgresqlFullBackup.dump
