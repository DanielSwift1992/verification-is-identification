#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
. Checks/build-tools.sh
python3 Checks/lawcheck-policy.py --tools "$(vi_check_tools_bin)/Tools"
