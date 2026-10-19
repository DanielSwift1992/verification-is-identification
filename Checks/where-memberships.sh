#!/usr/bin/env bash
# An unread generic membership is not a negative membership verdict.
set -euo pipefail
cd "$(dirname "$0")/.."
swift build --product Tools
membership_bin=$(swift build --show-bin-path)
python3 Checks/where-memberships.py --tools "$membership_bin/Tools"
