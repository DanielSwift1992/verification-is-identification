#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
continuation_tmp="$(mktemp -d "${TMPDIR:-/tmp}/vi-structural-compiler.XXXXXX")"
trap 'rm -rf "$continuation_tmp"' EXIT

# Court only: no Examples serialization, old binary, JS or modeled payloads.
swiftc Sources/Court/*.swift Checks/StructuralContinuation.swift -o "$continuation_tmp/check"
"$continuation_tmp/check" "$continuation_tmp"

continuation_input=(Sources/Notation/Primitive.swift
    Sources/Examples/TargetFrameTransport.swift Sources/Examples/ContinuationRequests.swift)
"$continuation_tmp/check" --judge continue --certificate "$continuation_tmp/frame.json" \
    ContinuationFrameRequest "${continuation_input[@]}" > "$continuation_tmp/CLI.swift"
"$continuation_tmp/check" --judge replay-continuation "$continuation_tmp/frame.json" \
    ContinuationFrameRequest "${continuation_input[@]}" > "$continuation_tmp/Replayed.swift"
cmp "$continuation_tmp/CLI.swift" "$continuation_tmp/Replayed.swift"
if "$continuation_tmp/check" --judge continue --certificate "$continuation_tmp/lost.json" \
    ContinuationLostRequest "${continuation_input[@]}" > "$continuation_tmp/Absent.swift" 2> "$continuation_tmp/absent.log"; then
    printf '%s\n' 'unexpected continuation after loss' >&2; exit 1
else
    [ "$?" -eq 1 ]
fi
rg -q 'Minimum additional source leaves: 2' "$continuation_tmp/absent.log"
"$continuation_tmp/check" --judge replay-continuation --retain "$continuation_tmp/lost.json" \
    ContinuationLostRequest "${continuation_input[@]}" > "$continuation_tmp/Retained.swift"
sed 's/Question = Paired<Source.Left, Source.Right.Left>/Question = Paired<Source.Right.Left, Source.Left>/' \
    Sources/Examples/ContinuationRequests.swift > "$continuation_tmp/Changed.swift"
if "$continuation_tmp/check" --judge replay-continuation "$continuation_tmp/frame.json" \
    ContinuationFrameRequest "${continuation_input[0]}" "${continuation_input[1]}" "$continuation_tmp/Changed.swift" \
    > "$continuation_tmp/ChangedOutput.swift" 2> "$continuation_tmp/changed.log"; then
    printf '%s\n' 'replayed certificate accepted a changed question' >&2; exit 1
else
    [ "$?" -eq 2 ]
fi
rg -q 'certificate body differs from the live source' "$continuation_tmp/changed.log"
printf '%s\n' 'CLI export/replay, exact obstruction, pre-loss retention and changed-source refusal passed'

mkdir -p "$continuation_tmp/Modules"
swiftc -emit-module -parse-as-library -module-name Notation \
    Sources/Notation/*.swift \
    -module-cache-path "$continuation_tmp/cache" \
    -emit-module-path "$continuation_tmp/Modules/Notation.swiftmodule"
swiftc -emit-module -parse-as-library -module-name VerificationIsIdentification \
    -I "$continuation_tmp/Modules" \
    Sources/VerificationIsIdentification/*.swift \
    -emit-module-path "$continuation_tmp/Modules/VerificationIsIdentification.swiftmodule"
continuation_sources=()
for continuation_source in Sources/Examples/*.swift; do
    if [ "$continuation_source" != Sources/Examples/ContinuationRequests.swift ]; then
        continuation_sources+=("$continuation_source")
    fi
done
continuation_sdk=()
if command -v xcrun >/dev/null 2>&1; then
    continuation_sdk=(-sdk "$(xcrun --show-sdk-path)")
fi
swiftc -frontend -typecheck -module-name Examples "${continuation_sdk[@]}" \
    -I "$continuation_tmp/Modules" -module-cache-path "$continuation_tmp/cache" \
    -primary-file Sources/Examples/ContinuationRequests.swift \
    -primary-file "$continuation_tmp/Generated.swift" "${continuation_sources[@]}"
printf '%s\n' 'generated generic programs and source-bound proofs compile against current declarations'
