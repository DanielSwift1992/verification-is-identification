#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
if [[ "${1:-}" == "--execute" ]]; then
    shift
    exec "${BRAKET_PYTHON:-python3}" "$SCRIPT_DIR/execute.py" "$@"
fi
if [[ "${1:-}" == "--prepare" ]]; then
    shift
    exec "${BRAKET_PYTHON:-python3}" "$SCRIPT_DIR/prepare.py" "$@"
fi
exec "${BRAKET_PYTHON:-python3}" "$SCRIPT_DIR/build.py" "$@"
