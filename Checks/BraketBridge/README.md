# VI → checked continuation → local Braket

## Explicit evidence inputs and interpreter

Historical run names below are relative to the caller-supplied `hardware-runs` folder. Pass `--runs DIR` and `--manifest FILE` explicitly to readers of these inputs; neither has a local or neighboring default. `MANIFEST.json` supplies each input's SHA-256. Old machine-specific receipt keys are opaque: run files are resolved by that hash, and new references use a relative path inside the supplied folder. Raw provider payloads, saved receipts and the closed program wire formats are not rewritten. Reader implementation fingerprints include the shared evidence reader.

```sh
RUNS=/path/to/hardware-runs
EVIDENCE_MANIFEST=/path/to/MANIFEST.json
python3 Checks/hardware_runs.py --runs "$RUNS" --manifest "$EVIDENCE_MANIFEST" --check-evidence
```

This checksum mode imports no quantum SDK and makes no provider or hardware call. Evidence inputs reject writes. Fixed historical output slots are not assumed to be archived inputs: a prospective new run requires an explicit `--work DIR` outside the evidence store (and is not run by this task). For a fresh local preparation, choose a separate `--prepared-cache DIR` (or the bridge's explicit `--cache DIR`) outside the evidence store; an old cache is not silently requalified for changed sources or compilers. New output names in examples are examples, not selected destinations or permission to run another experiment.

Use the caller-selected Python 3.12 interpreter with `amazon-braket-sdk==1.98.0` and `amazon-braket-default-simulator==1.28.0`, the versions recorded by the saved SDK preflight. No environment is selected or installed by these scripts.


A bounded engineering implementation of IiS45–46. The same typed source constructs the H/S/Z path, its Pauli frame, the acquired record, and the final question. A finite planner proposes a decoder from the public joint law. Generated Swift applications check that decoder against the actual source fields before its operations are exported and executed in Amazon Braket's local density-matrix simulator.

This is not a general VI compiler, hardware experiment, or claim of quantum speedup.

The separate `--coherent` scope retains exact phases for an owned two-block controlled source. Checked `Data` and `Joint` applications select one versus two extra memory/data interactions without acquiring the memory bit. It emits commands from the checked program itself and verifies full two-input Choi states with the local SDK. Its control-only door excludes local memory phase gates; granting those changes the minimum. See the [coherent continuation report](../../Research/2026-09-14-coherent-continuation-result.md) for the constructor, runtime ownership, and conservative normalization limits.

## Run

### Ordinary terminal execution

```sh
BRAKET_PYTHON=/path/to/python Checks/BraketBridge/run.sh --execute --runs "$RUNS" --manifest "$EVIDENCE_MANIFEST" \
  --request AcquireZ --input plus --shots 256 --output my-terminal-run
```

This runs one actual sampled local SDK job, without the research oracle or regression suite. The first invocation builds the Swift library, derives the proposal, compiles its row applications, and re-exports from the checked consumer. Subsequent invocations reuse those exports only if current compiler inputs, compiler identity, build recipe and exported bytes still match. `--prepare` performs just that preparation; `--cache /absolute/directory` selects another cache. A corrupt/incomplete cache is refused, not silently used.

The first execution provider is deliberately limited to `Uniform2`, an actual parity record, H/S/Z actions and one retained Z producer. It prepares two control/shadow pairs inside a six-qubit circuit; the reduced controls realize the public uniform classical law. The parity record is copied before the source acts and measured at the end. The resident read is of the same wire that controls CZ. The decoder gets actual outcome bits, never a host-selected row or oracle value. This is a constructed local source, not calibration of an unknown external device.

Supported requests are `AcquireX`, `AcquireY`, `AcquireZ`, `RotatedX`, `RotatedY`, `RotatedZ`; the six input preparations are `zero`, `one`, `plus`, `minus`, `plus_i`, `minus_i`. The checked request selects whether the extra resident measurement is necessary. The initial parity measurement is separate from this additional-contact count. `State`, missing resident ports and unsupported laws fail before SDK submission. This entry point returns sampled classical counts, not a retained unknown quantum state or a cross-task qubit handle. The coherent scope remains a separate research entry point.

`result.json` records the checked build, execution code hashes, QASM digest, fresh occurrence ID, package versions, actual public records and decoded counts. `jobs.json` and `raw-result.json` preserve the submitted circuit and actual measurements. Result bits follow `measured_qubits`, not an assumed wire order. Repeating an identical circuit creates a new occurrence ID.

Cache hashes concern trusted local build reuse; they are not a proof kernel, a signature against a malicious cache writer, or evidence that hardware obeys the supplied law. Device capabilities and calibration are separate obligations. Changing QA or the unrelated coherent case declarations does not invalidate this acquisition compilation. Changing the source, question declarations, selected adapters or compiler does.

### Explicit hardware pilot

`qpu_pilot.py` is a separate, bounded hardware entry point. It never changes the cloud-free behavior of `--execute`. Its three fixed cases are `AcquireZ` with `plus` and `minus`, and `AcquireY` with `plus_i`, at 256 shots each. It uses an existing same-region Braket bucket and the existing `braket-user` profile. There is no bucket/IAM creation, reservation or paid simulator.

Prepare is read-only against AWS and runs the same circuits locally first. Submit creates paid tasks and requires an already authorized budget. Collect only retrieves results; repeating it cannot submit tasks. The ledger persists each client token before submission, and a transport retry uses the same token and body. It never retries with a new task ID to get a better answer.

```sh
/path/to/python Checks/BraketBridge/qpu_pilot.py --runs "$RUNS" --manifest "$EVIDENCE_MANIFEST" prepare \
  --budget-usd 5 --directory my-qpu-pilot
# Only after authorization and review of the prepared plan:
/path/to/python Checks/BraketBridge/qpu_pilot.py --runs "$RUNS" --manifest "$EVIDENCE_MANIFEST" submit --directory my-qpu-pilot
/path/to/python Checks/BraketBridge/qpu_pilot.py --runs "$RUNS" --manifest "$EVIDENCE_MANIFEST" collect --directory my-qpu-pilot
```

This pilot is priced for Cepheus on 2026-09-14: $1.2264 for all three QPU tasks, excluding tax and small ancillary S3 costs, with at least $1 left as a reserve. Recheck device prices and the remaining authorized budget before a later-day submission; the script is a dated pilot, not a general billing enforcement service. An uncertain ledger reservation is not an invoice or evidence of a completed task. `qpu_pilot_checks.py` tests budget and retry behavior with a fake AWS client and makes no paid calls.

The first real submission was rejected by AWS with `AccessDeniedException` before a task ARN was issued. No hardware result is claimed. The [diagnosis and prepared experiment](../../Research/2026-09-14-qpu-pilot-result.md) record what must be resolved before resuming.

### Full local research regression

From the repository root, with Swift and an existing Python environment containing `amazon-braket-sdk` and `amazon-braket-default-simulator`:

```sh
BRAKET_PYTHON=/path/to/python Checks/BraketBridge/run.sh --runs "$RUNS" --manifest "$EVIDENCE_MANIFEST" --output NEW_BUILD_DIRECTORY
```

`BRAKET_PYTHON` defaults to `python3`. The command installs nothing, reads no AWS profile, and imports only the local simulator. A new output directory must be passed explicitly with `--output`; archived evidence is read-only. `--output /absolute/new/directory` selects another empty destination. A timeout is an infrastructure failure, never an expected logical refusal.

The output includes current-source hashes, build/SDK versions and separate timings, `sources.json`, `audit.json`, generated `Certificates.swift`, checked `continuations.json`, OpenQASM jobs, numerical results, and the static-adversary report. A failed run preserves diagnostics and exits nonzero. Python files orchestrate builds, SDK calls, and independent numerical QA; the source/frame construction and continuation planner are Swift.

## Contract

- One arbitrary payload qubit, possibly entangled with an untouched reference.
- Known H/S gates and recorded classical Z controls. Four binary latent coordinates are available; coordinate 0 is the most significant bit of the 16-row public support table.
- A supplied nonnegative integer joint law, independent of the unknown payload. Zero weights use `Never`; positive weights are sums of explicit unit weights. The law and the memory acquisition mechanism are model premises, not facts acquired from hardware by this bridge.
- Actual record columns are source-bound XOR expressions. Arbitrary common correlations are represented by their joint weights; independence is never inferred from marginals.
- A final `State`, `ReadX`, `ReadY`, or `ReadZ` request. Measurement promises the distribution of one classical output, not recovery of a particular random outcome or of the postmeasurement quantum state.
- Known ideal computation is the H/S subsequence. Z contacts remain physically present in the test fixture, even if their eventual combined action is identity.

For `Z(s0) → H → Z(s1)`, the derived final frame is `X^s0 Z^s1`. Retaining only `r0=s0 XOR s1` supports exact Y by outcome relabelling. Under uniform independent controls, X, Z, and State have optimal error 1/2 in their respective metrics. Two genuine control records support exact State recovery. The input types differ only in the requested question or acquired record.

## What each layer establishes

1. **Analytic:** IiS46 supplies the classical Pauli-record formulas. For State the optimal half-diamond error is `1 - sum_r max_f P(r,f)`. For one Pauli question it is `sum_r min(P(r,0),P(r,1))`, the worst-case output-probability error. These are distinct metrics.
2. **Structural:** `QuantumContinuation.swift` composes actual predecessor types. H/S/Z derive frame rows; record toggles derive record rows. Program, memory and question must share the correct source and frame. The explicit adapter admits only supported constructors, rather than interpreting names or arbitrary `Pair` conformances.
3. **Checked application:** For each exact proposal, all 16 rows receive either an equality tying actual record and target to the emitted decision, or an equality tying the actual weight type to `Never`. Bounded proposals check record binding without pretending to prove the bound in Swift. Their integer error calculation is an executable application of the analytic formula.
4. **Foreign execution:** A second compiled consumer emits both the current source and the operations of the same decision entries. The fixture prepares a private branch; the controller accepts only its acquired record. The reference is untouched. No sampled latent index is a controller input.
5. **Numerical:** A separate literal 2×2-matrix oracle checks translation, including Y signs, order, conjugation, mixture weights, and reference⊗payload ordering. State uses normalized Choi outputs; measured questions use coherent test inputs. A Choi fidelity is not labelled a computed diamond norm.

The adapter, finite planner implementation, certificate generator, SDK translator, and experimental source binding remain explicitly trusted/tested code. Compilation does not establish that a physical device obeys the supplied law. The build manifest checks source stability, not theorem truth. No general Gate-reader certification or whole-project regression is claimed.

## Access boundary

| Participant | Available information |
|---|---|
| Planner | Typed process, question, acquisition expressions, complete **public joint model** of possibilities |
| Working continuation | Checked fixed plan and acquired record only |
| Fixture | Private control valuation, preparation and actual memory generation |
| Independent oracle | Fixture valuation and ideal semantics, solely for QA |

Enumerating hypothetical rows is not observing the active row. Witness rows in `audit.json` are countermodels, not runtime inputs. `continuations.json` contains no active valuation, source frame, seed or hidden state. It exposes a fixed decision table and the resources it consumes. Host branch expansion is counted as separate local executions; it is not free coherent control.

## Files

- `Sources/Examples/QuantumContinuation.swift`: pure finite source/record/frame construction.
- `Cases.swift`, `Extra.swift`: source constructions; the latter contains holdouts added after the base algorithm.
- `Adapter.swift`: explicit finite interpretation and operation emitter.
- `Planner.swift`: public-fiber optimization and generated application obligations.
- `Export.swift`: first export; generated checked consumer is the second export.
- `runner.py`: thin Braket/OpenQASM adapter; no planner or VI judge.
- `prepare.py`: bounded checked-build reuse; `build.py --prepare-only` preserves both Swift phases.
- `runtime.py`: shared oracle-free record binding; `execute.py`: explicit local source provider and ordinary terminal execution.
- `runtime_checks.py`: separate cache, occurrence, source, bit-order and SDK semantic QA of that execution path.
- `oracle.py`, `experiment.py`: independent numerical test fixtures and semantic comparisons.
- `static_checks.py`: controlled compiler adversaries; `build.py` and `run.sh`: fresh-build orchestration.

A new supported word is added as a typed construction in `Extra.swift`; the planner and translator do not dispatch on its scenario name. General optimality of gate counts is not claimed. Ordinary Pauli-frame tracking yields the same physical correction in this fragment; the contribution tested here is reuse and enforcement of memory/question applicability.

## Recorded result

The current 20-model run passed from fresh sources: 269 density jobs, then a fixed 8×512-shot series; maximum branch matrix discrepancy 2.233e−16. The complete scoped build and checks took 22.42 seconds. See [the session report](../../Research/2026-09-14-braket-continuation-result.md). These numbers describe this recorded run, not a guarantee about every machine or future sampling batch.

## Source-bound acquisition extension

Run `./Checks/BraketBridge/run.sh --acquisition --runs "$RUNS" --manifest "$EVIDENCE_MANIFEST" --output NEW_BUILD_DIRECTORY` (with the same `BRAKET_PYTHON` setting if needed). This freshly builds the extra `QuantumAcquisition.swift` fragment and its current-source row applications. The local terminal route reads the same retained memory wire that controlled source CZ. X/Z consume that actual reply; Y skips the contact. It returns a classical question output, not a corrected unknown quantum payload. A small installed-SDK capability probe records the independent mid-measurement limitation.

See [the acquisition result](../../Research/2026-09-14-braket-acquisition-result.md) for assumptions, the one-contact lower bound, and the wrong-carrier witness with identical public record statistics. The finite law is declared; no law learning or hardware experiment is claimed.
