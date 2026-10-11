#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
receiver_tmp="$(mktemp -d "${TMPDIR:-/tmp}/vi-receiver-continuation.XXXXXX")"
trap 'rm -rf "$receiver_tmp"' EXIT
mkdir -p "$receiver_tmp/Modules"
swiftc -emit-module -parse-as-library -module-name VerificationIsIdentification \
    Sources/VerificationIsIdentification/*.swift \
    -emit-module-path "$receiver_tmp/Modules/VerificationIsIdentification.swiftmodule"
receiver_sources=()
for receiver_source in Sources/Examples/*.swift; do
    if [ "$receiver_source" != Sources/Examples/ReceiverContinuation.swift ]; then
        receiver_sources+=("$receiver_source")
    fi
done
receiver_sdk=()
if command -v xcrun >/dev/null 2>&1; then
    receiver_sdk=(-sdk "$(xcrun --show-sdk-path)")
fi
receiver_check() {
    swiftc -frontend -typecheck -module-name Examples "${receiver_sdk[@]}" \
        -I "$receiver_tmp/Modules" -module-cache-path "$receiver_tmp/cache" \
        -primary-file Sources/Examples/ReceiverContinuation.swift \
        -primary-file Checks/ReceiverContinuation.swift "${receiver_sources[@]}" "$@"
}
receiver_check
printf '%s\n' 'receiver-derived seam and two actual uses compile'
for receiver_case in \
    RECEIVER_ANSWER_AS_INPUT:RejectedAnswerFactorAsInputRecovery \
    RECEIVER_ANSWER_AS_APPLICATION:RejectedAnswerAvailabilityAsReapplication \
    RECEIVER_UNJOINED_INPUT:RejectedEqualAnswersJoinDifferentInputs \
    RECEIVER_RETARGETED:RejectedChangedReceiverKeepsTheFormerAnswer
do
    receiver_flag="${receiver_case%%:*}"
    receiver_name="${receiver_case#*:}"
    if receiver_check -D "$receiver_flag" > "$receiver_tmp/refusal.log" 2>&1; then
        printf 'unexpected admission: %s\n' "$receiver_name" >&2; exit 1
    fi
    if ! rg -q "$receiver_name" "$receiver_tmp/refusal.log" || ! rg -q 'error:' "$receiver_tmp/refusal.log"; then
        cat "$receiver_tmp/refusal.log" >&2; exit 1
    fi
    printf 'refused: %s\n' "$receiver_name"
done
