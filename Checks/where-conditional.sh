#!/usr/bin/env bash
# A conditional conformance is read as a gate or refused by name. A gate
# written on one line is the same gate and is judged; a conditional
# conformance listing two protocols, a conditional protocol whose where
# clause stands without an inheritance list, and a where clause that spells
# a function type are forms this court does not read, so it gives no verdict
# and names them instead of passing over them while a neighbour holds the
# file. The compiler refuses each world on the same files.
set -euo pipefail
cd "$(dirname "$0")/.."

conditional_tmp=$(mktemp -d "${TMPDIR:-/tmp}/vi-where-conditional.XXXXXX")
trap 'rm -rf "$conditional_tmp"' EXIT

. Checks/build-tools.sh
conditional_bin=$(vi_check_tools_bin)

# conditional_world <world> <court exit> <compiler errors> <court lines>:
# the compiler refuses the world for exactly these errors, and the court
# answers with this exit and exactly these lines, on stdout for a refusal
# and on stderr for a form it does not read.
conditional_world() {
    local world="$1" status="$2" errors="$3" verdict="$4"
    if swiftc -typecheck -module-cache-path "$conditional_tmp/cache" \
        "Checks/where-conditional/$world.swift" >"$conditional_tmp/$world-swift.log" 2>&1; then
        echo "where-conditional: Swift accepted $world.swift" >&2
        exit 1
    fi
    local said=0
    "$conditional_bin/Tools" judge where "Checks/where-conditional/$world.swift" \
        >"$conditional_tmp/$world.out" 2>"$conditional_tmp/$world.err" || said=$?
    if [ "$said" -ne "$status" ]; then
        cat "$conditional_tmp/$world.out" "$conditional_tmp/$world.err"
        echo "where-conditional: the where court answered $world.swift with exit $said, not $status" >&2
        exit 1
    fi
    local channel="$conditional_tmp/$world.out"
    [ "$status" -eq 2 ] && channel="$conditional_tmp/$world.err"
    python3 - "$world" "$conditional_tmp/$world-swift.log" "$channel" "$errors" "$verdict" <<'PY'
from pathlib import Path
import re, sys
world, swift_log, court_log, errors, verdict = sys.argv[1:]
pattern = re.compile(r"^Checks/where-conditional/" + re.escape(world) + r"\.swift:\d+:\d+: (error: .*)$")
said = [m.group(1) for m in map(pattern.match, Path(swift_log).read_text().splitlines()) if m]
if sorted(said) != sorted(errors.split("\n")):
    print(Path(swift_log).read_text())
    raise SystemExit(f"where-conditional: Swift did not refuse {world}.swift for the expected reasons")
lines = Path(court_log).read_text().splitlines()
if lines != verdict.split("\n"):
    print("\n".join(lines))
    raise SystemExit(f"where-conditional: the court did not answer {world}.swift in the expected words")
PY
}

conditional_world oneline 1 \
"error: global function 'need' requires that 'Bad' conform to 'Required'" \
"✗ 'BadClaim = Use<Bad>' requires the type 'T' (aka 'Bad') conform to 'Required', and 'Bad: Setting' does not carry it [Admitted]
✗ 'Use<Bad>' requires the type 'T' (aka 'Bad') conform to 'Required', and 'Bad: Setting' does not carry it [Admitted]"
conditional_world listed 2 \
"error: global function 'need' requires that 'Bad' conform to 'Required'" \
"✗ THE WHERE: cannot read conditional conformance 'Use: Admitted, Marked': this court reads one protocol per conditional extension"
conditional_world selfbound 2 \
"error: type 'Later' does not conform to protocol 'StrictlyBanded'
error: 'StrictlyBanded' requires the types 'Later.Band' (aka 'Loose') and 'Tight' be equivalent" \
"✗ THE WHERE: cannot read conditional protocol 'StrictlyBanded': this court reads a where clause after an inheritance list of plain names"
conditional_world arrow 2 \
"error: global function 'need' requires that 'Bad' conform to 'Required'
error: global function 'need' requires the types 'Int' and '(Int) -> Int' be equivalent" \
"✗ THE WHERE: cannot read the where clause conjunct 'F == (Int) -> Int': a function type is a term this court does not read"

echo "✓ where-conditional: a one-line gate is judged, three unread conditional forms are named, the compiler refuses all four"
