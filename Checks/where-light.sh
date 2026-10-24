#!/usr/bin/env bash
# The second judge reads Light beside Primitive and states its exact
# outcome. Three of Light's claims are metatypes whose generic arguments run
# across lines, a use this court reads only on one line, so it gives no
# verdict over the file and names those three lines and their reason; the
# rest of Light, read without them, holds with the equalities and uses
# counted here. Either half moving is visible: a court that learns to read
# a claim changes the named lines, and one that stops reading another
# changes them too, or the count the rest holds with.
set -euo pipefail
cd "$(dirname "$0")/.."

light_tmp=$(mktemp -d "${TMPDIR:-/tmp}/vi-where-light.XXXXXX")
trap 'rm -rf "$light_tmp"' EXIT

. Checks/build-tools.sh
light_bin=$(vi_check_tools_bin)
primitive=Sources/Notation/Primitive.swift

across="applies a gated head in a use written across lines, which this court reads on one line"
said=0
"$light_bin/Tools" judge where Sources/Examples/Light.swift "$primitive" \
    >"$light_tmp/light.out" 2>"$light_tmp/light.err" || said=$?
expected="✗ THE WHERE: cannot read line 249 of 'Sources/Examples/Light.swift': 'OppositePair' $across
✗ THE WHERE: cannot read line 304 of 'Sources/Examples/Light.swift': 'Halves' $across
✗ THE WHERE: cannot read line 314 of 'Sources/Examples/Light.swift': 'Halves' $across"
if [ "$said" -ne 2 ] || [ -s "$light_tmp/light.out" ] || [ "$(cat "$light_tmp/light.err")" != "$expected" ]; then
    cat "$light_tmp/light.out" "$light_tmp/light.err"
    echo "where-light: the court did not name exactly Light's three unread claims" >&2
    exit 1
fi

# The rest of Light: the same file without the three named claims.
python3 - Sources/Examples/Light.swift "$light_tmp/Light.swift" <<'PY'
from pathlib import Path
import re, sys
text = Path(sys.argv[1]).read_text()
for name in ("darkFringe", "diagonalHalvingChecked", "threePanesRevive"):
    text, count = re.subn(r"public let " + name + r":[^=]*=.*?>\.self\n", "", text, flags=re.S)
    if count != 1:
        raise SystemExit(f"where-light: Light no longer spells the claim {name} once")
Path(sys.argv[2]).write_text(text)
PY
if ! "$light_bin/Tools" judge where "$light_tmp/Light.swift" "$primitive" >"$light_tmp/rest.out" 2>&1; then
    cat "$light_tmp/rest.out"
    echo "where-light: the rest of Light does not hold" >&2
    exit 1
fi
if [ "$(cat "$light_tmp/rest.out")" != "THE WHERE scope: conditional compilation blocks are excluded.
✓ THE WHERE holds: 14 equalities and 0 memberships judged across 11 uses, the certificates, and the gated conformers, source-replayed definition reductions (canon v4)." ]; then
    cat "$light_tmp/rest.out"
    echo "where-light: the rest of Light holds with other counts" >&2
    exit 1
fi
echo "✓ where-light: three claims across lines are named at their lines, and the rest of Light holds with 14 equalities across 11 uses"
