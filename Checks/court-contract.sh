#!/usr/bin/env bash
# Use this run’s completed build, or build before a standalone judgement.
set -euo pipefail
cd "$(dirname "$0")/.."
. Checks/build-tools.sh
court_contract_bin="$(vi_check_tools_bin)/Tools"
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
python3 Checks/court-contract.py \
    --manifest Contracts/Court/context-names-v1/module-fragment.json \
    --command-json "$court_contract_command" \
    --implementation-id "local SwiftPM Tools build" \
    --compiler "$(command -v swiftc)" "$@"
python3 Checks/court-contract.py \
    --manifest Contracts/Court/context-names-v1/fragment.json \
    --command-json "$court_contract_command" \
    --implementation-id "local SwiftPM Tools build" \
    --compiler "$(command -v swiftc)" "$@"
python3 Checks/court-contract.py \
    --manifest Contracts/Court/context-names-v1/owner-views.json \
    --command-json "$court_contract_command" \
    --implementation-id "local SwiftPM Tools build" \
    --compiler "$(command -v swiftc)" "$@"
python3 Checks/court-contract.py \
    --manifest Contracts/Court/context-names-v1/owner-members.json \
    --command-json "$court_contract_command" \
    --implementation-id "local SwiftPM Tools build" \
    --compiler "$(command -v swiftc)" "$@"
python3 Checks/court-contract.py \
    --manifest Contracts/Court/context-names-v1/bindings.json \
    --command-json "$court_contract_command" \
    --implementation-id "local SwiftPM Tools build" \
    --compiler "$(command -v swiftc)" "$@"
python3 Checks/court-contract.py --roster --tools "$court_contract_bin"
bash Checks/press-contract.sh
