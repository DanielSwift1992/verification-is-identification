#!/usr/bin/env bash
# The executable must be rebuilt before judging an unchanged source checkout.
set -euo pipefail
cd "$(dirname "$0")/.."
swift build --product Tools
court_contract_bin="$(swift build --show-bin-path)/Tools"
court_contract_command=$(python3 -c 'import json,sys; print(json.dumps([sys.argv[1], "judge"]))' "$court_contract_bin")
python3 Checks/court-contract-test.py
exec python3 Checks/court-contract.py \
    --command-json "$court_contract_command" \
    --implementation-id "local SwiftPM Tools build" \
    --compiler "$(command -v swiftc)" "$@"
