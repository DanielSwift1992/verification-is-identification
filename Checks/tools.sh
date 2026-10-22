#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
. Checks/build-tools.sh
bin=$(vi_check_tools_bin)
exec "$bin/Tools" "$@"
