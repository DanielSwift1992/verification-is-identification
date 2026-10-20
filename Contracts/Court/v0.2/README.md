# Court contract · questions suite 0.2

A named sum can repeat the same definition many times. The tree reader expanded every occurrence and declined the 10,048 and 16,384 controls before comparing their counts. This release exercises a reader that shares those occurrences, and replays the proposed derivation against the supplied source in a separate arena.

The question remains **`vi.count.unit-never-plus/1`**: the supplied primitive rules give Never zero, Unit one and Plus addition. An unresolved reading was not a numeric answer. This release changes capacity, not that question. [Suite 0.1](../v0.1/README.md), its hashes and all thirteen expectations are unchanged. Definition equality and the where canon remain separate; this change does not put the where reader on the shared representation.

`contract.json` binds twelve cases to exact inputs and addressed outcomes. The driver registers its complete manifest hash under `vi.court.questions/0.2`, and the input selection is `vi.count.shared-definition-fixtures/1`. The CLI response contract stays `vi.court.cli-text/1`.

| Control | Expected outcome |
| --- | --- |
| 9,984, 10,048, 16,384 and 57,344 on each side | One accepted reading per file |
| All 26 original D65 IDs from gate `61422112396ff7e3406c2cf1c1c6fe3bc9da213e` | 66 accepted readings, retaining every relation of each ID |
| 16,384 against 16,385 | Addressed numeric refusal |
| Equal counts with different ordered Right/Answer trees | Right == Answer refusal |
| Opaque Times on large names | Outside the count fragment |
| 2^63 through direct Plus aliases | Checked signed 64-bit overflow, unresolved |
| The deeper Twice spelling of 2^63 | Definition depth limit, unresolved |
| Recursive source alias | Cycle, unresolved |
| Changed Unit primitive | The arithmetic premise is not supplied |

`arithmetic.json` contains independently evaluated integer pairs and the complete D65 ID-to-relation map. `Checks/count-dag-arithmetic.py` evaluates the explicit fixture aliases with Python integers and checks all 66 D65 pairs against the original page's stated coefficients and arguments. It neither asks a court for expected answers nor treats equal integers as equal types. The pinned original page is preserved in `origins/`; every normative input and arithmetic record has a manifest hash. The 57,344 fixture covers the obstructing contrast constant. It does not convert or certify the playground world; that content change belongs to T-0023.

## Work and replay

Within each discovered reading, the count reader owns an immutable source and fresh construction/replay accounts. A term key includes its constructor or projection owner and ordered arguments. Reduction memo keys also include head/full mode. Shared proof references must point backward. Replay validates every reference and reconstructs the five reduction rules from the current definitions, then computes zero, one and checked addition itself. Its table starts empty; it does not use the builder's numeric cache. Requested roots are checked against the original expressions.

The limits are **50,000 construction units and 100,000 replay units per reading**. The unit is now work on shared representations: a new term or proof node, its edges, a source instantiation and every visit, including memo hits. These are separate accounts, not a cap on the integer answer. Counts of nodes, edges, instantiations and visits are exposed internally for measurement. Expanding a diagnostic is bounded separately; it cannot recreate an unbounded tree. Expression depth remains 128, definition recursion 128, proof depth below 512, and discovery below 20,000. Growing instantiations, cycles, resource exhaustion and arithmetic overflow remain unresolved; none establishes an impossible count.

On the measured 9,984/10,048/16,384/57,344 inputs and the 66 D65 readings, maximum per-reading work was 2,226 construction units and 2,883 replay units. These limits were retained after that measurement. They are not a bound on all future sources. The exact measured inputs, temporary baseline instrumentation and per-reader counters are retained in the T-0032 research package.

Swift `CountDAGTests` and Rust `shared_count::tests` additionally mutate proof rules, operands, roots, term/proof references and source definitions. They exercise separate head/full keys, parameter and owner binding, changed primitive rules, finite accounts, memo-hit cost and checked overflow. These are internal proof controls, not new commands in the public CLI.

## Run and interpret

`./check.sh --only contract` runs the driver controls, independent arithmetic, and **both** releases. A separate implementation is checked with `Checks/court-contract.py --manifest Contracts/Court/v0.2/contract.json` and the same `--command-json` interface as v0.1. Build it first. Also run Swift tests, Rust tests, and the extended `rust-sample/diff-court.py`; repeat both contracts and the differential run through the wasm Node loader. Preserve executable/module hashes and toolchain receipts beside the driver reports.

Passing this finite suite does not establish full language coverage, general equivalence, the playground's entire contrast page, or permission to remove a consumer's residual IDs. Gate must translate and check every relation of an original ID, including a negative control, before removing its unsupported marker. The primitive checks, nominal question, consumer obligations and original research question do not disappear when the reader becomes cheaper.
