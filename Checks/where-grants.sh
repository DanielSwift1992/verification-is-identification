#!/usr/bin/env bash
# Judge the declared source modules, rather than inventing an import graph.
set -euo pipefail
cd "$(dirname "$0")/.."
. Checks/build-tools.sh
grants_bin=$(vi_check_tools_bin)
grants_inputs=()
while IFS= read -r path; do grants_inputs+=("$path"); done < <(python3 Checks/where-contexts.py Grants)
grants_result=$(mktemp "${TMPDIR:-/tmp}/vi-grants.XXXXXX")
trap 'rm -f "$grants_result"' EXIT
"$grants_bin/Tools" judge where "${grants_inputs[@]}" --context Checks/where-contexts/Grants.json --report >"$grants_result"
python3 - "$grants_result" <<'PY'
import json, sys
report = json.load(open(sys.argv[1]))
assert report['outcome'] == 'holds' and not report['diagnostics'], report
assert len(report['results']) == 1, report
row = report['results'][0]
assert (row['equalities'], row['memberships'], row['diagnostics']) == (3, 3, []), row
print('✓ Grants: 3 equalities and 3 memberships hold in the declared owner context')
PY
