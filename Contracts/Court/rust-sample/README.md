# A second court in Rust

`vi-court` is a second implementation of the court CLI that [the questions suite 0.1](../v0.1/README.md) binds. It reads the same bare Swift declarations as `Sources/Court` and answers the two passes the driver appends, `where` and `count`, with the same exit codes and the same addressed text. It exists to show that the contract can be met from outside the Swift package by a program the package does not build. It is not the judge the package ships, and it is not a product.

## What was checked

`Checks/court-contract.py` ran the thirteen cases of `vi.court.questions/0.1` against this binary and matched all thirteen. The driver's report records the manifest hash, the executable hash, and every command with its actual output.

`diff-court.py` ran the Swift court and this binary on 318 invocations built from the repository's where and count fixtures (`Checks/where-*`, `Checks/rydberg-count`), the Examples the laws judge (Light, Grants, the Rydberg ladder), and the contract fixtures, each world judged alone and beside its definitions files. 317 invocations answered alike in exit, stdout and stderr, byte for byte. The one difference is the text of the missing-file diagnostic of `count`: the Swift court prints Foundation's error, this binary prints the operating system's, and the contract permits platform detail in that line. The rest of Light without its three claims written across lines also answers alike.

Four laws that take a court path pass with this binary: `where-tokens.py`, `where-nested-applications.py`, `where-application-names.py` and `where-memberships.py`.

Agreement on these invocations is evidence for these invocations. It does not establish that the two readers agree on every Swift text.

## What is ported, file by file

- `src/expression.rs` follows `DefinitionReduction.swift`: the term grammar, the world a court read, validation and expansion against that world, the five derivation rules and their replay, with the same depth and node limits.
- `src/lexical.rs` and `src/where_judge.rs` follow `WhereJudge.swift`: the scan that blanks comments and string contents, the omission of blocks under a plain flag, the flat reader with its named refusals, the preparation that lends definitions and refuses an application of a gated head outside the places the court reads, and the judgement over certificates, uses and conformers, memberships included.
- `src/structural.rs` and `src/count_court.rs` follow `StructuralSource.swift` and `CountCourt.swift`: the token reader, the declaration table with its defaults, the check that binds the Unit/Never/Plus interpretation to the presented `Primitive.swift`, and the count derivation replayed against the source.

Offsets are bytes here where the Swift reader counts UTF-16 units. Both place a boundary only between a word and a non-word, so the texts they cut out coincide on the 318 invocations. A text on which the two counts would differ has not been constructed.

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

```sh
swift build --product Tools && python3 Contracts/Court/rust-sample/diff-court.py --swift "$(swift build --show-bin-path)/Tools" --other "$PWD/Contracts/Court/rust-sample/target/release/vi-court"
```

`Cargo.lock` pins the one dependency. The driver's report binds a result to the executable's hash and the manifest's hash, not to this source; a build receipt that names the toolchain and the lock file belongs beside the report.

## Next step

The next step the contract names is the structured response route. Until it is ported, this binary answers the text CLI of suite 0.1 and nothing else.
