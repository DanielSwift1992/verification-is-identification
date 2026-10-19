#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
swift build --product Tools
python3 Checks/where-response.py --tools "$(swift build --show-bin-path)/Tools" "$@"
