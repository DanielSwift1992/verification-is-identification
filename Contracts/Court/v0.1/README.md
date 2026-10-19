# Court contract · questions suite 0.1

This suite checks that a replacement reader preserves the questions and addressed outcomes in thirteen fixed cases. The fixtures, their hashes and their expected results are in [contract.json](contract.json). The supplied implementation is run against those inputs; its own declarations of success are not used as expectations. The driver binds the suite identifier to the exact manifest SHA-256. An edited or shortened manifest cannot keep the released suite identity. A new release needs an explicit registry entry.

## Questions and versions

| Part | Identifier | Scope |
| --- | --- | --- |
| Definition equality | `vi.where.definition-equality/1` | Expand supplied definitions; do not replace nominal equality with equal counts or an interpretation of a name. |
| Where inputs | `vi.where.questions-fixtures/1` | The listed equality fixtures and one explicitly unsupported nested application. This is not a grammar for arbitrary Swift. |
| Count question | `vi.count.unit-never-plus/1` | Check the stated count answer under the supplied primitive definitions and selected Sigma, Encoding and Predicate. |
| Count inputs | `vi.count.rydberg-fixtures/1` | The pinned finite Rydberg declarations, two false readings and the unsupported product. |
| CLI response | `vi.court.cli-text/1` | Exact exit and addressed stdout/stderr, allowing order changes only for declared independent refusals. The count missing-file diagnostic permits platform error detail. CRLF is normalized to LF; other line separators are rejected. |
| Conformance suite | `vi.court.questions/0.1` | All thirteen cases. Passing a subset is not passing this suite. |

The where normalization canon remains `4`. That number does not version the entire reader, the count question or the response format. VI owns these two questions and their controls. The organizational judge belongs with the showcase's policy; it is outside this suite. Gate supplies a callable implementation and delivery. A fourth package is unnecessary for this contract.

The count model uses zero for `Never`, one for `Unit` and addition for `Plus`, after checking the provided primitive declarations and getters. Its reference implementation uses checked `Int` addition, expression depth below 128, construction and replay budgets of 50,000, definition reduction/replay budgets of 50,000/100,000 and an application discovery budget below 20,000. The suite does not exercise every limit and is not a complete specification of the count reader.

## Run

Run `./check.sh --only contract` for the registered build, driver controls and full thirteen-case suite. For a separate invocation from the repository root, build the implementation before using it. A newer checkout can still contain an older cached executable.

```sh
swift build --product Tools
python3 Checks/court-contract.py \
  --command-json "[\"$(swift build --show-bin-path)/Tools\", \"judge\"]" \
  --implementation-id "local Swift build" \
  --compiler /usr/bin/swiftc \
  --report /tmp/court-contract.json
```

The command prefix is a JSON argv array. The driver appends the pass (`where` or `count`), relative fixture paths and the question parameters. A replacement implementation or explicit compatibility adapter can expose this CLI in any language. The driver does not invoke a shell. The optional compiler separately checks five equality fixtures and the accepted Swift neighbor whose nested application the reader declines to interpret.

The report retains each command, actual exit and output, failed expectations, duration, manifest hash and executable hash. `implementation-id` is a caller label. An interpreter or wrapper hash does not identify all code it loads; preserve a build receipt and dependency pins separately. A report supplies evidence for this finite suite, not a source-to-binary attestation.

## Read the result

`holds`, `not-established`, `unsupported` and `input-error` in the manifest describe these known fixtures. They are not classifications inferred from an arbitrary process exit. In particular, exit 1 is not a general proof of type inequality, and exit 2 does not distinguish an unsupported expression from an unavailable file. The driver checks the addressed reason as well. The where missing-file CLI reports only the unread filename; the test knows the file was deliberately absent.

The same Rydberg input has four nominal refusals under `where` and ten accepted readings under `count`. Two aliases with their actual definitions pass; three name/count shortcuts fail. The suite also distinguishes false numeric answers, an unsupported product, an unread nested application and two missing-file errors.

Passing is necessary for claiming conformance to this suite. It does not establish full Swift coverage, general equivalence of implementations, completion of the organizational migration or readiness to replace gate's judge. The existing alias, extension, conditional, lexical, scope, applications, Light and Rydberg laws remain separate obligations for a port. Structured request identities, per-obligation coverage and separate unsupported/tool-error results remain the response-contract task. The known generic-membership defect is not made normative here.

The initial expectations come from the independently checked T-0017 matrix and the accepted T-0014 nested-reader control. Frozen fixture copies make this release reproducible as the working examples evolve. A later semantic change requires a new version and an explicit account of the change.
