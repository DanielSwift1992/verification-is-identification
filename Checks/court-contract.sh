#!/usr/bin/env bash
# The executable must be rebuilt before judging an unchanged source checkout.
set -euo pipefail
cd "$(dirname "$0")/.."
swift build --product Tools
court_contract_bin="$(swift build --show-bin-path)/Tools"
court_contract_command=$(python3 -c 'import json,sys; print(json.dumps([sys.argv[1], "judge"]))' "$court_contract_bin")
python3 Checks/court-contract-test.py
python3 Checks/count-dag-arithmetic.py
for suite in v0.1 v0.2 v0.3 v0.4 v0.5; do
    python3 Checks/court-contract.py \
        --manifest "Contracts/Court/$suite/contract.json" \
        --command-json "$court_contract_command" \
        --implementation-id "local SwiftPM Tools build" \
        --compiler "$(command -v swiftc)" "$@"
done
bash Checks/press-contract.sh
