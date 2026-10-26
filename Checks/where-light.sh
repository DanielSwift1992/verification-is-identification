#!/usr/bin/env bash
# The declared owner context retains the three unread multiline applications.
# Its remaining source instantiates Self with the generic owner's parameters.
# Native package tests still judge the actual Light declarations.
set -euo pipefail
cd "$(dirname "$0")/.."

light_tmp=$(mktemp -d "${TMPDIR:-/tmp}/vi-where-light.XXXXXX")
trap 'rm -rf "$light_tmp"' EXIT

. Checks/build-tools.sh
light_bin=$(vi_check_tools_bin)
light_context=Checks/where-contexts/Light.json
light_inputs=()
while IFS= read -r path; do light_inputs+=("$path"); done < <(python3 Checks/where-contexts.py Light)
said=0
"$light_bin/Tools" judge where "${light_inputs[@]}" --context "$light_context" --report \
    >"$light_tmp/light.json" 2>"$light_tmp/light.err" || said=$?
python3 - "$said" "$light_tmp/light.json" <<'PYREPORT'
import json, sys
report = json.load(open(sys.argv[2]))
across = "applies a gated head in a use written across lines, which this court reads on one line"
expected = [f"cannot read line {line} of 'Sources/Examples/Light.swift': '{name}' {across}"
            for line, name in [(249, 'OppositePair'), (304, 'Halves'), (314, 'Halves')]]
assert int(sys.argv[1]) == 2 and not report['diagnostics'], report
assert len(report['results']) == 1 and report['results'][0]['diagnostics'] == expected, report
PYREPORT

# The rest of Light: the same file without the three named claims.
python3 - Sources/Examples/Light.swift "$light_tmp/Light.swift" <<'PY'
from pathlib import Path
import json, sys
text = Path(sys.argv[1]).read_text()
record = json.loads(Path('Checks/where-contexts/Light-omissions.json').read_text())
assert record['source'] == sys.argv[1]
for row in record['fragments']:
    assert text.count(row['bytes']) == 1, row['name']
    text = text.replace(row['bytes'], '', 1)
Path(sys.argv[2]).write_text(text)
PY
light_rest=()
while IFS= read -r path; do light_rest+=("$path"); done < <(python3 Checks/where-contexts.py Light --project "$light_tmp/Light.swift" --output "$light_tmp/context.json")
said=0
"$light_bin/Tools" judge where "${light_rest[@]}" --context "$light_tmp/context.json" --report >"$light_tmp/rest.json" || said=$?
python3 - "$said" "$light_tmp/rest.json" <<'PYREPORT'
import json, sys
report = json.load(open(sys.argv[2]))
assert int(sys.argv[1]) == 0 and not report['diagnostics'], report
assert len(report['results']) == 1, report
row = report['results'][0]
assert row['outcome'] == 'holds' and not row['diagnostics'], row
assert row['equalities'] == 64 and row['memberships'] == 18, row
PYREPORT
echo "✓ where-light: three multiline claims retain their addresses; generic Self instantiates MatteReading and the remaining 64 equalities and 18 memberships hold"
