#!/usr/bin/env bash
# shellcheck disable=SC1091
#
set -euo pipefail

source .venv/bin/activate
# make clean
# make html
make serve
