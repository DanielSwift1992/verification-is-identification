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

# The count question's controls, compiler side. A false direct drop and a forged
# common answer have a legal shape; only the count reading can refuse them. Two
# different declared answers do not share one image, and Swift refuses that.
for ladder_shape in false-direct-drop fake-shared-answer; do
    if ! swiftc -typecheck -I "$ladder_bin/Modules" \
        -module-cache-path "$ladder_tmp/cache" "Checks/rydberg-count/$ladder_shape.swift" \
        >"$ladder_tmp/$ladder_shape.log" 2>&1; then
        cat "$ladder_tmp/$ladder_shape.log"
        echo "Rydberg: the count control $ladder_shape does not even have a legal shape" >&2
        exit 1
    fi
done
if swiftc -typecheck -I "$ladder_bin/Modules" \
    -module-cache-path "$ladder_tmp/cache" "Checks/rydberg-count/different-answers.swift" \
    >"$ladder_tmp/different-answers.log" 2>&1; then
    echo "Rydberg: Swift accepted two different answers as one shared image" >&2
    exit 1
fi
if ! grep -q "requirement specified as 'Self.Left.Answer' == 'Self.Right.Answer'" \
    "$ladder_tmp/different-answers.log"; then
    cat "$ladder_tmp/different-answers.log"
    echo "Rydberg: different answers failed for another reason" >&2
    exit 1
fi

# The count question, judged. The first file is the world whose readings are
# checked; the rest supply definitions. Every branch of the five level bindings
# is derived, and each forged control is refused with both numbers named.
count_args=(--predicate TickCountQuestion --encoding UnaryArithmeticEncoding --sigma RydbergLevels)
if ! "$ladder_bin/Tools" judge count Sources/Examples/RydbergLadder.swift \
    Sources/VerificationIsIdentification/Primitive.swift "${count_args[@]}" \
    >"$ladder_tmp/count-world.log" 2>&1; then
    cat "$ladder_tmp/count-world.log"
    echo "Rydberg: the count court refused a level binding" >&2
    exit 1
fi
if ! grep -q "^✓ COUNT holds: 10 source-bound readings checked" "$ladder_tmp/count-world.log"; then
    cat "$ladder_tmp/count-world.log"
    echo "Rydberg: the count court did not check exactly the ten binding branches" >&2
    exit 1
fi
count_refusal() {
    local control="$1" expected="$2"
    if "$ladder_bin/Tools" judge count "Checks/rydberg-count/$control.swift" \
        Sources/Examples/RydbergLadder.swift Sources/VerificationIsIdentification/Primitive.swift \
        "${count_args[@]}" >"$ladder_tmp/count-$control.log" 2>&1; then
        cat "$ladder_tmp/count-$control.log"
        echo "Rydberg: the count court accepted the forged control $control" >&2
        exit 1
    fi
    local got
    got=$(grep '^✗ COUNT:' "$ladder_tmp/count-$control.log" | sort)
    if [ "$got" != "$(printf '%s\n' "$expected" | sort)" ]; then
        cat "$ladder_tmp/count-$control.log"
        echo "Rydberg: the count court refused $control for another reason" >&2
        exit 1
    fi
}
count_refusal false-direct-drop \
    "✗ COUNT: 'FalseBalmerBetaBinding.Right' count Left = 37, but Answer = 36 [TickCountQuestion]"
count_refusal fake-shared-answer "$(printf '%s\n%s' \
    "✗ COUNT: 'ForgedFloorTwo.Left' count Left = 36, but Answer = 32 [TickCountQuestion]" \
    "✗ COUNT: 'ForgedFloorTwo.Right' count Left = 36, but Answer = 32 [TickCountQuestion]")"

echo "✓ THE LADDER holds: count readings agree in tests and in the count court; five level bindings are derived; a false drop and a forged image are refused with both numbers; two different answers do not share one image; four nominal grants are refused by both courts; the written type witness compiles."
