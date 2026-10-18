#!/usr/bin/env bash
# A conformance stated in an unconditional extension is the conformer's
# conformance. The court reads the extension's protocols and the aliases of
# its body: a refinement stated there is judged at its gate, a premise added
# there is worn, and a premise it does not add is still missing. The header
# carries the conformance even when the body is beyond the reader, and a
# comment, a string or a disabled branch carries none. The compiler gives
# the same verdicts on the same files.
set -euo pipefail
cd "$(dirname "$0")/.."

extension_tmp=$(mktemp -d "${TMPDIR:-/tmp}/vi-where-extension.XXXXXX")
trap 'rm -rf "$extension_tmp"' EXIT

if ! swift build --product Tools >"$extension_tmp/build.log" 2>&1; then
    cat "$extension_tmp/build.log"
    exit 1
fi
extension_bin=$(swift build --show-bin-path)

# The compiler refuses both refinements, each for the loose bound, and the
# demand for the premise the extension does not add. It accepts the control.
if swiftc -typecheck -module-cache-path "$extension_tmp/cache" \
    Checks/where-extension/refused.swift >"$extension_tmp/refused-swift.log" 2>&1; then
    echo "where-extension: Swift accepted a conformance whose premise fails" >&2
    exit 1
fi
python3 - "$extension_tmp/refused-swift.log" <<'PY'
from pathlib import Path
import re, sys
expected = {
    "error: type 'Later' does not conform to protocol 'StrictlyBanded'",
    "error: 'StrictlyBanded' requires the types 'Later.Band' (aka 'Loose') and 'Tight' be equivalent",
    "error: type 'Drifted' does not conform to protocol 'StrictlyBanded'",
    "error: 'StrictlyBanded' requires the types 'Drifted.Band' (aka 'Loose') and 'Tight' be equivalent",
    "error: global function 'need' requires that 'TaskAnswerOnly.In' (aka 'AnswerOnlyClass') conform to 'FullMatrixBound'",
}
pattern = re.compile(r"^Checks/where-extension/refused\.swift:\d+:\d+: (error: .*)$")
errors = [m.group(1) for m in map(pattern.match, Path(sys.argv[1]).read_text().splitlines()) if m]
if len(errors) != len(expected) or set(errors) != expected:
    print(Path(sys.argv[1]).read_text())
    raise SystemExit("where-extension: Swift did not refuse exactly the two refinements and the one demand")
PY
if ! swiftc -typecheck -module-cache-path "$extension_tmp/cache" \
    Checks/where-extension/admitted.swift >"$extension_tmp/admitted-swift.log" 2>&1; then
    cat "$extension_tmp/admitted-swift.log"
    echo "where-extension: Swift refused the control" >&2
    exit 1
fi

# The court refuses the same three: each refinement at its gated protocol,
# and the claim whose setting wears the extension's premise but not the
# gate's.
if "$extension_bin/Tools" judge where Checks/where-extension/refused.swift >"$extension_tmp/refused.log" 2>&1; then
    cat "$extension_tmp/refused.log"
    echo "where-extension: the where court admitted a conformance whose premise fails" >&2
    exit 1
else
    extension_status=$?
fi
if [ "$extension_status" -ne 1 ]; then
    cat "$extension_tmp/refused.log"
    echo "where-extension: the where court did not return its refusal verdict" >&2
    exit 1
fi
python3 - "$extension_tmp/refused.log" <<'PY'
from pathlib import Path
import sys
expected = [
    "✗ 'Use_12_RL_on_answer_only = UseRL<TaskAnswerOnly>' requires the type 'T.In' (aka 'AnswerOnlyClass') "
    "conform to 'FullMatrixBound', and 'AnswerOnlyClass: StationaryUnitary, AnswerFactorBound' "
    "does not carry it [GroundedByRL]",
    "✗ 'Drifted: StrictlyBanded' requires the types 'Band' (aka 'Loose') and 'Tight' (aka 'Tight') be equivalent",
    "✗ 'Later: StrictlyBanded' requires the types 'Band' (aka 'Loose') and 'Tight' (aka 'Tight') be equivalent",
]
lines = Path(sys.argv[1]).read_text().splitlines()
if lines != expected:
    print("\n".join(lines))
    raise SystemExit("where-extension: the court did not refuse exactly the two refinements and the one claim")
PY

# The control is judged, not skipped: the claim and the application, each
# one equality and two memberships at the gate, and the refinement, one
# equality read through the extension's body.
if ! "$extension_bin/Tools" judge where Checks/where-extension/admitted.swift >"$extension_tmp/admitted.log" 2>&1; then
    cat "$extension_tmp/admitted.log"
    echo "where-extension: the where court refused the control" >&2
    exit 1
fi
if ! grep -q "^✓ THE WHERE holds: 3 equalities and 4 memberships judged across 1 uses" "$extension_tmp/admitted.log"; then
    cat "$extension_tmp/admitted.log"
    echo "where-extension: the control was not judged through its extensions" >&2
    exit 1
fi
# Two more refused worlds, each read beside the compiler. In the mixed world
# a refinement sits in an extension whose body holds a method, next to one
# that holds: the court refuses the first rather than counting the second
# and passing the file. In the commented world the only conformances are in
# a nested block comment and in an outer #if whose inner #if closes first.
# In the strings world every literal form carries a comment marker or a
# declaration, and the real claim between two markers is still read.
extension_refused_world() {
    local world="$1" errors="$2" verdict="$3"
    if swiftc -typecheck -module-cache-path "$extension_tmp/cache" \
        "Checks/where-extension/$world.swift" >"$extension_tmp/$world-swift.log" 2>&1; then
        echo "where-extension: Swift accepted $world.swift" >&2
        exit 1
    fi
    if "$extension_bin/Tools" judge where "Checks/where-extension/$world.swift" \
        >"$extension_tmp/$world.log" 2>&1; then
        cat "$extension_tmp/$world.log"
        echo "where-extension: the where court admitted $world.swift" >&2
        exit 1
    else
        extension_status=$?
    fi
    if [ "$extension_status" -ne 1 ]; then
        cat "$extension_tmp/$world.log"
        echo "where-extension: the where court gave no refusal verdict on $world.swift" >&2
        exit 1
    fi
    python3 - "$world" "$extension_tmp/$world-swift.log" "$extension_tmp/$world.log" \
        "$errors" "$verdict" <<'PY'
from pathlib import Path
import re, sys
world, swift_log, court_log, errors, verdict = sys.argv[1:]
pattern = re.compile(r"^Checks/where-extension/" + re.escape(world) + r"\.swift:\d+:\d+: (error: .*)$")
said = [m.group(1) for m in map(pattern.match, Path(swift_log).read_text().splitlines()) if m]
if sorted(said) != sorted(errors.split("\n")):
    print(Path(swift_log).read_text())
    raise SystemExit(f"where-extension: Swift did not refuse {world}.swift for the expected reasons")
lines = Path(court_log).read_text().splitlines()
if lines != verdict.split("\n"):
    print("\n".join(lines))
    raise SystemExit(f"where-extension: the court did not refuse {world}.swift for the expected reasons")
PY
}
extension_refused_world mixed \
"error: type 'Later' does not conform to protocol 'StrictlyBanded'
error: 'StrictlyBanded' requires the types 'Later.Band' (aka 'Loose') and 'Tight' be equivalent" \
"✗ 'Later: StrictlyBanded' requires the types 'Band' (aka 'Loose') and 'Tight' (aka 'Tight') be equivalent"
extension_refused_world commented \
"error: global function 'need' requires that 'Commented' conform to 'Required'
error: global function 'need' requires that 'Disabled' conform to 'Required'" \
"✗ 'CommentedClaim = Use<Commented>' requires the type 'T' (aka 'Commented') conform to 'Required', and 'Commented: Setting' does not carry it [Admitted]
✗ 'DisabledClaim = Use<Disabled>' requires the type 'T' (aka 'Disabled') conform to 'Required', and 'Disabled: Setting' does not carry it [Admitted]"

extension_refused_world strings \
"error: global function 'need' requires that 'Bad' conform to 'Required'" \
"✗ 'BadClaim = Use<Bad>' requires the type 'T' (aka 'Bad') conform to 'Required', and 'Bad: Setting' does not carry it [Admitted]
✗ 'Use<Bad>' requires the type 'T' (aka 'Bad') conform to 'Required', and 'Bad: Setting' does not carry it [Admitted]"

echo "✓ where-extension: an extension's conformances are worn and judged from its header, comments, strings and disabled branches state none, every refusal matches the compiler, the control holds"
