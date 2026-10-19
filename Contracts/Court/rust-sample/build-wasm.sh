#!/usr/bin/env bash
# Build the court for wasm32 and bind it for node and for the web. The last
# lines are the SHA-256 of the module, the line a pin record keeps beside the
# revision it was built from. Run from anywhere; the outputs land in pkg/.
set -euo pipefail
cd "$(dirname "$0")"

pinned=$(sed -n 's/^wasm-bindgen = "=\(.*\)"$/\1/p' Cargo.toml)
installed=$(wasm-bindgen --version | awk '{print $2}')
if [ "$pinned" != "$installed" ]; then
    echo "build-wasm: the wasm-bindgen tool is $installed, Cargo.toml pins the crate at $pinned; install the matching tool" >&2
    exit 2
fi
if ! rustup target list --installed | grep -qx wasm32-unknown-unknown; then
    echo "build-wasm: the wasm32-unknown-unknown target is not installed (rustup target add wasm32-unknown-unknown)" >&2
    exit 2
fi

cargo build --release --target wasm32-unknown-unknown
wasm-bindgen --target nodejs --out-dir pkg/node target/wasm32-unknown-unknown/release/vi_court.wasm
wasm-bindgen --target web --out-dir pkg/web target/wasm32-unknown-unknown/release/vi_court.wasm

echo "toolchain: $(rustc --version); wasm-bindgen $installed"
echo "source: $(git rev-parse HEAD 2>/dev/null || echo unknown)$(git diff --quiet 2>/dev/null || echo ' (working tree has changes)')"
shasum -a 256 pkg/node/vi_court_bg.wasm pkg/web/vi_court_bg.wasm
