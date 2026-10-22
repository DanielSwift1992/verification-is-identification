# A second court in Rust

`vi-court` is a second implementation of the court CLI that [questions suite 0.1](../v0.1/README.md) and [capacity suite 0.2](../v0.2/README.md) bind. It reads the same bare Swift declarations as `Sources/Court` and answers the two passes the driver appends, `where` and `count`, with the same exit codes and the same addressed text. It exists to show that the contract can be met from outside the Swift package by a program the package does not build. It is not the judge the package ships, and it is not a product.

## What was checked

`Checks/court-contract.py` matched all thirteen cases of `vi.court.questions/0.1` and all twelve cases of `vi.court.questions/0.2` against both the native binary and the wasm module through Node. The count question remains `vi.count.unit-never-plus/1`. The driver's report records the manifest hash, the executable hash, and every command with its actual output.

`diff-court.py` now includes the capacity suite alongside the repository's where and count fixtures (`Checks/where-*`, `Checks/rydberg-count`), the Examples the laws judge (Light, Grants, the Rydberg ladder), and the earlier contract fixtures. Of 336 invocations, 335 answered alike in exit, stdout and stderr, byte for byte. The one difference is the text of the missing-file diagnostic of `count`: the Swift court prints Foundation's error, this binary prints the operating system's, and the contract permits platform detail in that line. The Swift court admits 50 with exit 0, refuses 26 claims with exit 1 and declines to read 260 with exit 2, so most of the agreement is on what both courts decline to read. `diff-court.py` names the permitted missing-file difference and exits 0 when it is the only one.

Four laws that take a court path pass with this binary: `where-tokens.py`, `where-nested-applications.py`, `where-application-names.py` and `where-memberships.py`.

Agreement on these invocations is evidence for these invocations. It does not establish that the two readers agree on every Swift text.

## What is ported, file by file

- `src/expression.rs` follows `DefinitionReduction.swift`: the term grammar, the world a court read, validation and expansion against that world, the five derivation rules and their replay, with the same depth and node limits.
- `src/lexical.rs` and `src/where_judge.rs` follow `WhereJudge.swift`: the scan that blanks comments and string contents, the omission of blocks under a plain flag, the flat reader with its named refusals, the preparation that lends definitions and refuses an application of a gated head outside the places the court reads, and the judgement over certificates, uses and conformers, memberships included.
- `src/structural.rs` and `src/count_court.rs` follow `StructuralSource.swift` and `CountCourt.swift`: the token reader, the declaration table with its defaults, the check that binds the Unit/Never/Plus interpretation to the presented `Primitive.swift`, and the count derivation replayed against the source.
- `src/shared_count.rs` follows `DefinitionDAG.swift` and `CountDAG.swift` for count alone. It shares terms and derivations, then replays them in a fresh table against the source and requested roots. Ordered arguments, projection owners and head/full mode remain distinct. Construction and replay have separate work accounts. Addition uses `i64::checked_add`, including on wasm32. The six internal test groups alter proofs and premises, exercise budgets and cycles, and reject overflow.

Offsets are bytes here where the Swift reader counts UTF-16 units. Both place a boundary only between a word and a non-word, so the texts they cut out coincide on the checked invocations. This does not establish agreement on every Unicode input.

## What is not here

The structured route of [the where response contract](../where-response-v1.md), `where-report` and `where-admit`, is not implemented, and `Checks/where-response.py` does not pass with this binary. The `Press` term grammar that other Tools commands use is not ported. The binary carries no other Tools command. The regular expressions the Swift reader writes with look-around are written here with the `regex` crate and an explicit check of the byte before a match, in `lexical.rs` and in the unread-application scan of `where_judge.rs`.

## Run

From the repository root, with a Rust toolchain (built here with rustc 1.83.0):

```sh
cargo build --release --manifest-path Contracts/Court/rust-sample/Cargo.toml
```

```sh
python3 Checks/court-contract.py --command-json "[\"$PWD/Contracts/Court/rust-sample/target/release/vi-court\", \"judge\"]" --implementation-id "vi-court rust sample" --compiler "$(command -v swiftc)" --report /tmp/vi-court-report.json
```

Repeat with `--manifest Contracts/Court/v0.2/contract.json` and a separate report path for the capacity release. Run `cargo test --manifest-path Contracts/Court/rust-sample/Cargo.toml` for the internal proof controls.

```sh
swift build --product Tools && python3 Contracts/Court/rust-sample/diff-court.py --swift "$(swift build --show-bin-path)/Tools" --other "$PWD/Contracts/Court/rust-sample/target/release/vi-court"
```

`Cargo.lock` pins the dependencies. The driver's report binds a result to the executable's hash and the manifest's hash, not to this source. A build receipt that names the toolchain and the lock file belongs beside the report.

## The same court in the browser and under node

`src/lib.rs` is the court as a library: the two passes read their sources through a loader the caller supplies and return an `Answer`, the exit code with the two output streams, so one judgement serves three roads. `src/main.rs` is the CLI over files. `src/wasm.rs` is the browser road: one exported function takes a request as JSON, the pass with its arguments as the CLI takes them and the texts the named sources stand for, and returns the answer as JSON. `node/vi-court.js` is the reference loader for node: it speaks the CLI words, reads the files itself and hands the texts to the module, so the contract driver and `diff-court.py` can run against the module unchanged.

```sh
Contracts/Court/rust-sample/build-wasm.sh
```

The script builds for `wasm32-unknown-unknown`, binds the module for node, for the web as an ES module and for the web as a classic script (`no-modules`, for a page opened from a file) into `pkg/`, which is not committed, and prints the toolchain, the source revision and the SHA-256 of the module. The wasm-bindgen tool must match the crate version `Cargo.toml` pins. The module is about 2.1 MB, unoptimized: the `regex` crate carries the Unicode tables the reader's word classes need.

Through the Node loader the module answers both releases, 13/13 and 12/12. The same differential run gives 335/336 exact matches and the permitted missing-file detail, as on the native binary. `web/index.html` is a test page that loads the web binding, judges a world with `where` and prints the CLI's lines and exit code. A browser run is a separate check from the Node run.

A consumer that pins this court takes the module the way it takes any judge: built from the pinned revision by `build-wasm.sh`, with the module's hash kept beside the revision. A module built from a working copy is a second, untracked pin.

## Next step

The next step the contract names is the structured response route. Until it is ported, this court answers the text CLI of suites 0.1 and 0.2 on every road.


Court v0.4 adds the owner's qualified nested-enum notation, closed Swift/1 intrinsic, and explicit `--context path.json` transport. Both native and wasm routes use the same source-context reader; the Node loader carries that JSON file through the ordinary file map. The owner and port bind original source bytes before constructing the disclosed borrowed-definition view. See [v0.4](../v0.4/README.md) for its bounded scope, negative twins, and the explicit pre-release expectation erratum. Earlier historical measurements above are not a receipt for v0.4.

Court v0.5 adds addressed own/borrowed source roles, separate module and namespace, the closed Swift/2 intrinsic, Document definition views, and the per-source `--report` response. Both questions use `court_notation.rs`, and nominal where equality shares the count proof DAG without substituting numerical equality for nominal equality. `generic_membership.rs` substitutes actual arguments into the declared bounds and conditions. The frozen stages under [v0.5](../v0.5/README.md) precede these changes; the historical measurements above are not a receipt for them.

The wasm `source_notation` helper takes named original files and an explicit subset of files whose PredicateReading selectors are requested. It returns source hashes, addressed imports and selectors from the same notation reader as the judges. These are declarations, not established answers. The browser uses them to rebuild questions after an edit; the caller must still submit the complete source/context input to `judge`.
