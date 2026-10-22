#!/usr/bin/env bash
# A claim meets the gate its definition names. A claim spelled through an
# intermediate alias or a member alias is refused for the direct claim's
# reason, and a claim through the same names whose premises hold is judged
# and admitted. The compiler gives the same two verdicts on the same files.
set -euo pipefail
cd "$(dirname "$0")/.."

alias_tmp=$(mktemp -d "${TMPDIR:-/tmp}/vi-where-alias.XXXXXX")
trap 'rm -rf "$alias_tmp"' EXIT

. Checks/build-tools.sh
alias_bin=$(vi_check_tools_bin)

# The compiler refuses the four demands for one missing conformance and
# accepts every demand of the control.
if swiftc -typecheck -module-cache-path "$alias_tmp/cache" \
    Checks/where-alias/refused.swift >"$alias_tmp/refused-swift.log" 2>&1; then
    echo "where-alias: Swift accepted a claim whose premise fails" >&2
    exit 1
fi
alias_errors=$(grep -c ': error: ' "$alias_tmp/refused-swift.log" || true)
alias_expected=$(grep -c "^Checks/where-alias/refused.swift:[0-9]*:[0-9]*: error: global function 'need' requires that 'TaskAnswerOnly.In' (aka 'AnswerOnlyClass') conform to 'FullMatrixBound'$" \
    "$alias_tmp/refused-swift.log" || true)
if [ "$alias_errors" -ne 4 ] || [ "$alias_expected" -ne 4 ]; then
    cat "$alias_tmp/refused-swift.log"
    echo "where-alias: Swift did not refuse exactly the four demands for FullMatrixBound" >&2
    exit 1
fi
if ! swiftc -typecheck -module-cache-path "$alias_tmp/cache" \
    Checks/where-alias/admitted.swift >"$alias_tmp/admitted-swift.log" 2>&1; then
    cat "$alias_tmp/admitted-swift.log"
    echo "where-alias: Swift refused the control" >&2
    exit 1
fi

# The court refuses five sites for one reason: the member certificate, the
# direct claim, both intermediate claims and the application.
if "$alias_bin/Tools" judge where Checks/where-alias/refused.swift >"$alias_tmp/refused.log" 2>&1; then
    cat "$alias_tmp/refused.log"
    echo "where-alias: the where court admitted a claim whose premise fails" >&2
    exit 1
else
    alias_status=$?
fi
if [ "$alias_status" -ne 1 ]; then
    cat "$alias_tmp/refused.log"
    echo "where-alias: the where court did not return its refusal verdict" >&2
    exit 1
fi
python3 - "$alias_tmp/refused.log" <<'PY'
from pathlib import Path
import re, sys
expected_sites = {
    "Claims.OnAnswerOnly = UseRL<TaskAnswerOnly>",
    "Use_1_RL_on_answer_only = UseRL<TaskAnswerOnly>",
    "Use_7_RL_via_alias = UseRLVia<TaskAnswerOnly>",
    "Use_9_RL_via_member = Claims.OnAnswerOnly",
    "UseRLVia<TaskAnswerOnly>",
}
reason = ("requires the type 'T.In' (aka 'AnswerOnlyClass') conform to 'FullMatrixBound', "
          "and 'AnswerOnlyClass: StationaryUnitary, AnswerFactorBound' does not carry it [GroundedByRL]")
lines = Path(sys.argv[1]).read_text().splitlines()
pattern = re.compile(r"^✗ '(.+)' (requires .*)$")
matches = [pattern.fullmatch(line) for line in lines]
if len(lines) != len(expected_sites) or any(m is None for m in matches):
    raise SystemExit("where-alias: unexpected where-court output")
if {m.group(1) for m in matches} != expected_sites:
    raise SystemExit("where-alias: a claim was not judged at its gate, or was judged twice")
if {m.group(2) for m in matches} != {reason}:
    raise SystemExit("where-alias: an intermediate claim was refused for a different reason")
PY

# The control is judged, not skipped: three certificates and one application,
# each one equality and two memberships at the gate.
if ! "$alias_bin/Tools" judge where Checks/where-alias/admitted.swift >"$alias_tmp/admitted.log" 2>&1; then
    cat "$alias_tmp/admitted.log"
    echo "where-alias: the where court refused the control" >&2
    exit 1
fi
if ! grep -q "^✓ THE WHERE holds: 4 equalities and 8 memberships judged across 1 uses" "$alias_tmp/admitted.log"; then
    cat "$alias_tmp/admitted.log"
    echo "where-alias: the control was not judged at its gate for every claim" >&2
    exit 1
fi
echo "✓ where-alias: intermediate claims meet their gate, five refusals share one reason, the control holds"
