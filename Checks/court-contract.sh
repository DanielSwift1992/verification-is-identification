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
    court_contract_manifest="Contracts/Court/$suite/contract.json"
    case "$suite" in v0.1) court_contract_manifest="Contracts/Court/v0.1/context-fragment-v4.json" ;; v0.4) court_contract_manifest="Contracts/Court/v0.4/resolution-v4.json" ;; v0.5) court_contract_manifest="Contracts/Court/$suite/resolution-v3.json" ;; esac
    python3 Checks/court-contract.py \
        --manifest "$court_contract_manifest" \
        --command-json "$court_contract_command" \
        --implementation-id "local SwiftPM Tools build" \
        --compiler "$(command -v swiftc)" "$@"
done
python3 Checks/court-contract.py \
    --manifest Contracts/Court/v0.5/count-bindings-v1.json \
    --command-json "$court_contract_command" \
    --implementation-id "local SwiftPM Tools build" \
    --compiler "$(command -v swiftc)" "$@"
python3 Checks/court-contract.py \
    --manifest Contracts/Court/context-names-v1/module-fragment-v3.json \
    --command-json "$court_contract_command" \
    --implementation-id "local SwiftPM Tools build" \
    --compiler "$(command -v swiftc)" "$@"
python3 Checks/court-contract.py \
    --manifest Contracts/Court/context-names-v1/fragment-v4.json \
    --command-json "$court_contract_command" \
    --implementation-id "local SwiftPM Tools build" \
    --compiler "$(command -v swiftc)" "$@"
python3 Checks/court-contract.py \
    --manifest Contracts/Court/context-names-v1/view-fragment.json \
    --command-json "$court_contract_command" \
    --implementation-id "local SwiftPM Tools build" \
    --compiler "$(command -v swiftc)" "$@"
python3 Checks/court-contract.py \
    --manifest Contracts/Court/context-names-v1/owner-members-v2.json \
    --command-json "$court_contract_command" \
    --implementation-id "local SwiftPM Tools build" \
    --compiler "$(command -v swiftc)" "$@"
python3 Checks/court-contract.py \
    --manifest Contracts/Court/context-names-v1/bindings-v2.json \
    --command-json "$court_contract_command" \
    --implementation-id "local SwiftPM Tools build" \
    --compiler "$(command -v swiftc)" "$@"
python3 Checks/court-contract.py \
    --manifest Contracts/Court/context-names-v1/extension-owners.json \
    --command-json "$court_contract_command" \
    --implementation-id "local SwiftPM Tools build" \
    --compiler "$(command -v swiftc)" "$@"
python3 Checks/court-contract.py \
    --manifest Contracts/Court/context-names-v1/resolution.json \
    --command-json "$court_contract_command" \
    --implementation-id "local SwiftPM Tools build" \
    --compiler "$(command -v swiftc)" "$@"
python3 Checks/court-contract.py \
    --manifest Contracts/Court/context-names-v1/review-v5.json \
    --command-json "$court_contract_command" \
    --implementation-id "local SwiftPM Tools build" \
    --compiler "$(command -v swiftc)" "$@"
python3 Checks/court-contract.py \
    --manifest Contracts/Court/bound-questions-v1/contract.json \
    --command-json "$court_contract_command" \
    --implementation-id "local SwiftPM Tools build" \
    --compiler "$(command -v swiftc)" "$@"
python3 Checks/court-contract.py \
    --manifest Contracts/Court/conditional-conformances-v1/contract.json \
    --command-json "$court_contract_command" \
    --implementation-id "local SwiftPM Tools build" \
    --compiler "$(command -v swiftc)" "$@"
python3 Checks/court-contract.py \
    --manifest Contracts/Court/nested-carriers-v1/contract.json \
    --command-json "$court_contract_command" \
    --implementation-id "local SwiftPM Tools build" \
    --compiler "$(command -v swiftc)" "$@"
python3 Checks/court-contract.py \
    --manifest Contracts/Court/witness-priority-v1/contract.json \
    --command-json "$court_contract_command" \
    --implementation-id "local SwiftPM Tools build" \
    --compiler "$(command -v swiftc)" "$@"
python3 Checks/court-contract.py --roster --tools "$court_contract_bin"
bash Checks/press-contract.sh
