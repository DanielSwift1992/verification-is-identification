#!/usr/bin/env bash
# Fresh core module and current Examples source declarations. Typecheck only
# the affected proof and fixtures; do not serialize the entire Examples module.
# No modeled object code, cached Examples module or payload-state search.
set -euo pipefail
cd "$(dirname "$0")/.."
continuation_tmp="$(mktemp -d "${TMPDIR:-/tmp}/vi-least-continuation.XXXXXX")"
trap 'rm -rf "$continuation_tmp"' EXIT
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
    if [ "$continuation_source" != Sources/Examples/LeastContinuation.swift ]; then
        continuation_sources+=("$continuation_source")
    fi
done
continuation_sdk=()
if command -v xcrun >/dev/null 2>&1; then
    continuation_sdk=(-sdk "$(xcrun --show-sdk-path)")
fi

continuation_check() {
    swiftc -frontend -typecheck -module-name Examples "${continuation_sdk[@]}" \
        -I "$continuation_tmp/Modules" -module-cache-path "$continuation_tmp/cache" \
        -D LEAST_CURRENT_DECLARATIONS \
        -primary-file Sources/Examples/LeastContinuation.swift \
        -primary-file Checks/LeastContinuation.swift "${continuation_sources[@]}" "$@"
}

continuation_check
printf '%s\n' 'least continuation: generic construction and its actual next use compile'

for continuation_case in \
    LEAST_DIFFERENT_MEMORY:RejectedUnjoinedObservationEncodings \
    LEAST_CURRENT_ONLY:RejectedPresentAnswerAsFutureAnswer \
    LEAST_WRONG_JOINT:RejectedResidualFromAnotherJointView \
    LEAST_WHOLE_RETURN:RejectedThreeCallsAsWholeSourceReturn \
    LEAST_INDEPENDENT_REPEATS:RejectedIndependentActionsAsOnePreservedAction \
    LEAST_REWRITTEN_TARGET:RejectedPresentAgreementAsOriginalTaskCompletion \
    LEAST_RELATION_AS_VALUE:RejectedPreservedAgreementAsPreservedValue
do
    continuation_flag="${continuation_case%%:*}"
    continuation_name="${continuation_case#*:}"
    if continuation_check -D "$continuation_flag" >"$continuation_tmp/refusal.log" 2>&1; then
        printf 'unexpected admission: %s\n' "$continuation_name" >&2
        exit 1
    fi
    if ! rg -q "$continuation_name" "$continuation_tmp/refusal.log" \
        || ! rg -q 'error:' "$continuation_tmp/refusal.log"; then
        cat "$continuation_tmp/refusal.log" >&2
        printf 'unrelated failure: %s\n' "$continuation_name" >&2
        exit 1
    fi
    printf 'refused: %s\n' "$continuation_name"
done
