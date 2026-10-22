#!/usr/bin/env bash
# An unread generic membership is not a negative membership verdict.
set -euo pipefail
cd "$(dirname "$0")/.."
. Checks/build-tools.sh
membership_bin=$(vi_check_tools_bin)
python3 Checks/where-memberships.py --tools "$membership_bin/Tools"
