#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
press_contract_tmp=$(mktemp -d)
trap 'rm -rf "$press_contract_tmp"' EXIT
. Checks/build-tools.sh
vi_check_record_module "$press_contract_tmp"
swiftc -I "$press_contract_tmp" "$press_contract_tmp/ContinuationRecord.o" -module-cache-path "$press_contract_tmp/modules" Sources/Court/*.swift Checks/press-contract/main.swift -o "$press_contract_tmp/press-owner"
python3 Checks/press-contract-test.py
python3 Checks/press-contract.py --command-json "[\"$press_contract_tmp/press-owner\"]" --implementation-id 'Swift owner build'
python3 Checks/press-contract.py --manifest Contracts/Press/v0.2/contract.json --command-json "[\"$press_contract_tmp/press-owner\"]" --implementation-id 'Swift owner build'
python3 Checks/press-contract/native-host.py "[\"$press_contract_tmp/press-owner\", \"--native\"]"
