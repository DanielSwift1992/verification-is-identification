#!/usr/bin/env bash
# Compile, link and call Court through its published SwiftPM library product.
set -euo pipefail
cd "$(dirname "$0")/.."
export VI_COURT_PACKAGE="$PWD"
consumer=$(mktemp -d "${TMPDIR:-/tmp}/vi-court-consumer.XXXXXX")
trap 'rm -rf "$consumer"' EXIT
mkdir -p "$consumer/Sources/Probe"
cat > "$consumer/Package.swift" <<'SWIFT'
// swift-tools-version: 5.9
import Foundation
import PackageDescription
let package = Package(
    name: "CourtConsumer", platforms: [.macOS(.v13)],
    dependencies: [.package(name: "Corpus", path: ProcessInfo.processInfo.environment["VI_COURT_PACKAGE"]!)],
    targets: [.executableTarget(name: "Probe", dependencies: [.product(name: "Court", package: "Corpus")])]
)
SWIFT
cat > "$consumer/Sources/Probe/main.swift" <<'SWIFT'
import Court
Judge.run(Array(CommandLine.arguments.dropFirst()))
SWIFT
swift build --package-path "$consumer" --product Probe
bin=$(swift build --package-path "$consumer" --show-bin-path)
"$bin/Probe" where "$VI_COURT_PACKAGE/Contracts/Court/v0.1/fixtures/alias-same-definition.swift"
