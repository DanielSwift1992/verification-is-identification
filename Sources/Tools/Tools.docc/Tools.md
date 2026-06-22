# ``Tools``

The build-time helpers — internal tooling, not a product.

## Overview

One executable with two subcommands, run by the package's plugins, never by hand.

- `lint` enforces the construction law on the `VerificationIsIdentification` sources: pure types (§0′),
  no renames (§1), every axis closed (§2), and resolved provenance tags. The
  LawCheck build plugin runs it over `VerificationIsIdentification` on every build, so a violation fails
  compilation rather than slipping through review.
- `tree-sort` reads the compiler's symbol graph and induces the `VerificationIsIdentification` landing's
  Topics tree from the move each type makes — an axis, a theorem, a bridge.
  `swift package tree-sort check` holds the page equal to the types, and
  `tree-sort write` regenerates it. Nothing in the tree is grouped by hand.
