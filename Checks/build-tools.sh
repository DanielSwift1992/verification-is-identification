#!/usr/bin/env bash
# Reuse only the build that check.sh completed in this run. A standalone law
# still asks SwiftPM to build its Tools; callers do not keep a second receipt.
vi_check_tools_bin() {
    if [ -n "${VI_CHECK_BUILD_BIN:-}" ]; then
        if [ ! -x "$VI_CHECK_BUILD_BIN/Tools" ]; then
            echo "check: prepared Tools is missing: $VI_CHECK_BUILD_BIN/Tools" >&2
            return 1
        fi
        printf '%s\n' "$VI_CHECK_BUILD_BIN"
    else
        swift build --product Tools >&2 || return
        swift build --show-bin-path
    fi
}

# The raw-source Court controls link the same independent record module.
# This is a build transport, not another implementation of its U5/U6 rules.
vi_check_record_module() {
    local record_dir="$1"
    swiftc -parse-as-library -whole-module-optimization -emit-module -emit-object \
        -module-name ContinuationRecord Sources/ContinuationRecord/*.swift \
        -module-cache-path "$record_dir/cache" \
        -emit-module-path "$record_dir/ContinuationRecord.swiftmodule" \
        -o "$record_dir/ContinuationRecord.o"
}

# Sharing a build assumes a fixed input tree. Name drift instead of presenting
# a tool built before an edit as the check of the edited sources.
vi_check_source_key() {
    python3 - <<'PY'
from pathlib import Path
import hashlib
paths = [Path('Package.swift'), Path('Package.resolved'), Path('check.sh')]
for folder in ('Sources', 'Plugins', 'Tests', 'Checks'):
    paths.extend(path for path in Path(folder).rglob('*') if path.is_file()
                 and '__pycache__' not in path.parts and path.suffix != '.pyc')
result = hashlib.sha256()
for path in sorted(set(paths)):
    if path.is_file():
        result.update(str(path).encode() + b'\0' + hashlib.sha256(path.read_bytes()).digest())
print(result.hexdigest())
PY
}
