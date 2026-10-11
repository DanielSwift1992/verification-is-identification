#!/usr/bin/env bash
# The example asks two questions: agreement of actual count readings, and
# nominal type identity. The where court must keep the four nominal refusals.
set -euo pipefail
cd "$(dirname "$0")/.."

ladder_tmp=$(mktemp -d "${TMPDIR:-/tmp}/vi-rydberg.XXXXXX")
trap 'rm -rf "$ladder_tmp"' EXIT

if ! swift build --product Tools >"$ladder_tmp/build.log" 2>&1; then
    cat "$ladder_tmp/build.log"
    exit 1
fi
if ! swift test --filter RydbergCountTests >"$ladder_tmp/count.log" 2>&1; then
    cat "$ladder_tmp/count.log"
    exit 1
fi
for ladder_test in testDeclaredEnergyStitchesThroughTheirOwnCountReading testEqualCountsDoNotIdentifyTheirSources; do
    if ! grep -Eq "$ladder_test.*passed" "$ladder_tmp/count.log"; then
        cat "$ladder_tmp/count.log"
        echo "Rydberg: the requested count test did not run: $ladder_test" >&2
        exit 1
    fi
done
ladder_bin=$(swift build --show-bin-path)

if "$ladder_bin/Tools" judge where Sources/Examples/RydbergLadder.swift \
    Sources/VerificationIsIdentification/Primitive.swift >"$ladder_tmp/where.log" 2>&1; then
    echo "Rydberg: the where court accepted distinct count constructions as one type" >&2
    exit 1
else
    ladder_status=$?
fi
if [ "$ladder_status" -ne 1 ]; then
    cat "$ladder_tmp/where.log"
    echo "Rydberg: the where court did not return its nominal refusal verdict" >&2
    exit 1
fi

# Accept only these four addressed refusals. An extra refusal, missing one,
# parsing failure or different premise is a failed check, not an exception.
python3 - "$ladder_tmp/where.log" <<'PY'
from pathlib import Path
import re, sys
expected = {
    'ThirdFloorStitch', 'SecondFloorStitch',
    'GroundFloorStitch', 'TwoRoadsOneDrop',
}
lines = Path(sys.argv[1]).read_text().splitlines()
pattern = re.compile(r"^\u2717 '([A-Za-z]+) = EnergySum<.*\[EnergyClosed\]$")
matches = [pattern.fullmatch(line) for line in lines]
if len(lines) != len(expected) or any(m is None for m in matches):
    raise SystemExit('Rydberg: unexpected where-court output')
if {m.group(1) for m in matches} != expected:
    raise SystemExit('Rydberg: missing or duplicated nominal refusal')
PY

# Naming EnergySum's type is legal Swift; granting EnergyClosed is the
# stronger claim. Check the same four failed grants with the actual compiler.
for ladder_site in ThirdFloorStitch SecondFloorStitch GroundFloorStitch TwoRoadsOneDrop; do
    cat >"$ladder_tmp/$ladder_site.swift" <<SWIFT
import Examples
enum RequireClosed<T: EnergyClosed> {}
typealias Rejected = RequireClosed<$ladder_site>
SWIFT
    if swiftc -typecheck -I "$ladder_bin/Modules" \
        -module-cache-path "$ladder_tmp/cache" "$ladder_tmp/$ladder_site.swift" \
        >"$ladder_tmp/$ladder_site.log" 2>&1; then
        echo "Rydberg: Swift unexpectedly granted EnergyClosed to $ladder_site" >&2
        exit 1
    fi
    if ! grep -Eq "requires the types .* be equivalent" "$ladder_tmp/$ladder_site.log"; then
        cat "$ladder_tmp/$ladder_site.log"
        echo "Rydberg: $ladder_site failed for a different reason" >&2
        exit 1
    fi
done

cat >"$ladder_tmp/positive.swift" <<'SWIFT'
import Examples
import VerificationIsIdentification
let accepted: LadderStitched.Type =
    LadderStep<FloorThreeByLadder, Plus<FloorFourDepth, PaschenAlphaDrop>>.self
SWIFT
if ! swiftc -typecheck -I "$ladder_bin/Modules" \
    -module-cache-path "$ladder_tmp/cache" "$ladder_tmp/positive.swift" \
    >"$ladder_tmp/positive.log" 2>&1; then
    cat "$ladder_tmp/positive.log"
    exit 1
fi

echo "✓ THE LADDER holds: actual count readings agree; four nominal grants are refused by both courts; the written type witness compiles."
