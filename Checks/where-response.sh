#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
. Checks/build-tools.sh
response_bin=$(vi_check_tools_bin)
python3 Checks/where-response.py --tools "$response_bin/Tools" "$@"
