# IBM Open: fixed VI pilot

## Explicit evidence inputs and interpreter

Historical run names below are relative to the caller-supplied `hardware-runs` folder. Pass `--runs DIR` and `--manifest FILE` explicitly to readers of these inputs; neither has a local or neighboring default. `MANIFEST.json` supplies each input's SHA-256. Old machine-specific receipt keys are opaque: run files are resolved by their recorded hash and catalogue `origin` (ambiguous origins refuse), and new references use a relative path inside the supplied folder. Raw provider payloads, saved receipts and the closed program wire formats are not rewritten. Reader implementation fingerprints include the shared evidence reader.

Offline analysis commands may write fixed destinations in `Research/Artifacts`. Running them in the corpus can overwrite historical receipts with new path keys and reader fingerprints. Replay in a disposable checkout with a copy of the required artifacts; retain the original receipts unchanged.

```sh
RUNS=/path/to/hardware-runs
EVIDENCE_MANIFEST=/path/to/MANIFEST.json
python3 Checks/hardware_runs.py --runs "$RUNS" --manifest "$EVIDENCE_MANIFEST" --check-evidence
```

This checksum mode imports no quantum SDK and makes no provider or hardware call. Evidence inputs reject writes. Fixed historical output slots are not assumed to be archived inputs: a prospective new run requires an explicit `--work DIR` outside the evidence store (and is not run by this task). For a fresh local preparation, choose a separate `--prepared-cache DIR` (or the bridge's explicit `--cache DIR`) outside the evidence store; an old cache is not silently requalified for changed sources or compilers. New output names in examples are examples, not selected destinations or permission to run another experiment.

The saved IBM preparation `ready.json` records Python 3.12.11. Use a caller-selected interpreter compatible with the pinned [IBM requirements](requirements.txt). The offline continuation tools use that same caller-selected environment; no virtual-environment path is built into the scripts.


## Joint-return experiment with explicit quantum memory

`joint_memory.py` adds a separate, bounded experiment derived from the current `JointReturnSource.swift` through the existing joint-return reader and selector. It does not extend the old 16-source Pauli table by relabelling a CZ environment. Two Bell references test data and memory in one four-bit acquisition. Nine fixed circuits distinguish retention, physical replacement, a deliberately wrong memory target, and two consecutive uses without resetting between them.

```sh
python3 Checks/IBMBridge/joint_memory_checks.py --runs "$RUNS" --manifest "$EVIDENCE_MANIFEST"
python3 Checks/IBMBridge/joint_memory.py prepare \
  --output new-joint-memory
python3 Checks/IBMBridge/joint_memory.py submit \
  --output new-joint-memory
python3 Checks/IBMBridge/joint_memory.py collect \
  --output new-joint-memory
```

`joint_memory.py` operates on an explicitly selected `--output` directory and current corpus artifacts; it needs no archived input store. Its provider stages still require separate authorization. The saved `ibm-joint-memory-20260914` is read-only evidence; use offline replay rather than collecting or submitting it again. One job, 9×1024 shots, 45-second cap, Open/free only. Initial layout is a connected four-wire path; routing is prohibited, and all actual CZ contacts, resets and measurement wires are checked after compilation. Logical and ISA density-matrix results agree. The frozen source, proof, QPY, provider input circuits and returned metadata bind the readout to this experiment. Intent is written durably before submission; an uncertain reply permits reconciliation only, never an automatic second job.

The [prespecified protocol](../../Research/2026-09-14-joint-memory-hardware-protocol.md) defines all 27 Bernoulli questions and simultaneous uncertainty intervals. These concern average conditional pass probabilities during the executed tests, including preparation and readout. They do not become a full-DE diamond error bound or a guarantee of future applicability. All outcomes, including failures, are retained. The old adapters and their frozen campaign remain unchanged.

The [completed Kingston result](../../Research/2026-09-14-joint-memory-hardware-result.md) used 5 free QPU seconds. Its nine full count tables are in `Research/Artifacts/ibm-joint-memory-20260914.json`. Re-read the saved provider result and independently recompute all scores without contacting IBM:

```sh
python3 Checks/IBMBridge/joint_memory_checks.py --runs "$RUNS" --manifest "$EVIDENCE_MANIFEST" \
  --replay "$RUNS/ibm-joint-memory-20260914"
```

## Original terminal pilot

This adapter reuses `Checks/BraketBridge/execute.py` and its checked acquisition exports. `pilot.py` implements terminal measurement only. The separate local prototype `dynamic.py` implements mid-circuit feedforward in an ideal simulator; it has no hardware submission path. The terminal pilot remains unchanged in scope. `dynamic_run.py` now provides the separately checked hardware path. Its first 9 x 1024 experiment completed on Kingston; see the [hardware analysis](../../Research/2026-09-14-ibm-dynamic-hardware-result.md).

The fixed cases are AcquireZ/plus, AcquireZ/minus and AcquireY/plus_i, 256 shots each, in one Sampler job. No paid instance is admitted. An API key must be stored outside the repository at `~/.config/vi/ibm-open-api-key`, mode 0600. The adjacent `ibm-open.json` identifies the intended instance with a `crn` field. Both its `plan=open` and `pricing_type=free` are read from IBM before use. The API key itself inherits its IBM user's permissions; the Open restriction is enforced by this runner, not by the name of the key.

Use an environment compatible with the pinned [requirements](requirements.txt). Use the caller-selected interpreter; the repository selects no virtual environment. For a new experiment:

```sh
python3 Checks/IBMBridge/pilot.py --runs "$RUNS" --manifest "$EVIDENCE_MANIFEST" prepare \
  --output new-ibm-pilot --backend ibm_kingston
python3 Checks/IBMBridge/checks.py --runs "$RUNS" --manifest "$EVIDENCE_MANIFEST"
python3 Checks/IBMBridge/pilot.py --runs "$RUNS" --manifest "$EVIDENCE_MANIFEST" submit \
  --output new-ibm-pilot
python3 Checks/IBMBridge/pilot.py --runs "$RUNS" --manifest "$EVIDENCE_MANIFEST" collect \
  --output new-ibm-pilot
```

`prepare` contacts IBM only to read the free instance, quota, device status and hardware compilation target. It compiles the actual VI root, binds classical outputs through the hardware layout, and checks the compiled circuits with local ideal Aer. Idle hardware wires are removed only from that local check. The complete ISA circuit is retained in `isa.qpy` for submission.

`submit` records its intent before the network call. If a reply is lost, the next attempt can recover one tagged existing job; it will not submit again on an empty or ambiguous search. There is no automatic repeat-until-success loop. The job has a 30-second execution limit and requires at least 30 seconds of remaining Open quota. That limit is not a claim that hardware execution time equals physical circuit duration.

`collect` never submits. It binds the job ID, instance, backend, tag, remote input circuits and circuit metadata before decoding. IBM bit strings are reversed into the original VI output order. The same acquired shots are also read without the extra resident record for the Z comparisons; this is a postprocessing comparison, not a separate cheaper hardware run.

Collection records its own implementation fingerprint. Provider collection fixes may differ from the submitting script; the VI producer/decoder, archived payload and returned source must still match. The September 14 submitting script is preserved beside its plan for this reason.

`checks.py` is offline. It tests asymmetric bit patterns, source/measurement binding rejection, quota rejection, reply-loss recovery and complete result collection with a fake remote job. The final test uses an existing prepared pilot if available. Ideal local results and fake jobs are never hardware evidence.

## Local State continuation

`dynamic.py` consumes the existing checked `AcquireState` proposal. It first establishes that the State request has the same physical source, acquisitions and resident as the admitted terminal producer. It then replaces only terminal readout with actual mid-circuit measurements of parity and resident. The measured two-bit register chooses a checked Pauli correction using `if_test`. No realized hidden control value or expected answer enters this controller.

The fragment accepts an arbitrary payload on q0 and five fresh zero wires. It returns the payload unmeasured with target H applied. A Bell-pair caller tests preservation of a separate reference: it inverts the fixed target H, then reads XX, YY and ZZ. Two controls ignore or deliberately invert the resident reply. All policies physically perform the same two acquisitions. These are separate circuits with different feedback, not postprocessing of one hardware sample.

```sh
python3 Checks/IBMBridge/dynamic_checks.py --runs "$RUNS" --manifest "$EVIDENCE_MANIFEST"
python3 Checks/IBMBridge/dynamic.py --runs "$RUNS" --manifest "$EVIDENCE_MANIFEST" \
  --output new-dynamic-local --backend ibm_kingston
```

Omit `--backend` for a fully offline run. With it, the only IBM activity is reading the explicitly pinned Open instance and the device compilation target. The script saves logical QPY, local joint shot records, implementation hashes, the current checked-build receipt and optionally hardware-target QPY. It never creates a QPU job. The ISA file is compiled, **not simulated or hardware-tested**; the local simulation runs the seven-wire logical circuits.

Five offline dynamic checks cover all four classical source branches with standard SDK matrices, actual conditional execution with the reference, source and resident substitutions, absence of payload measurement in the returned fragment, and preservation of the legacy terminal State rejection. A deliberately wrong but shape-correct correction is rejected by the independent channel check. Matrix checks use floating-point arithmetic; the short analytic justification and the exact scope are in the [local report](../../Research/2026-09-14-ibm-dynamic-local.md).

The live payload exists only inside one circuit. It is not retained across jobs or delivered as a quantum object to Python. Terminal witness measurements consume it. The completed `dynamic_run.py` path validates dynamic ISA/record mapping and collection separately and uses the device-supported optimized mid-circuit readout. IBM documents the supported [`if_test` and mid-circuit measurement interface](https://quantum.cloud.ibm.com/docs/en/guides/execute-dynamic-circuits).

## Common physical source for Bell readings

The original independently compiled dynamic artifact uses pair 45–47 for XX/YY and 109–111 for ZZ. It was never submitted. On hardware those readings cannot automatically be treated as one state's Bell fidelity.

`dynamic_prepare.py` fixes this by compiling each policy's prefix once, copying it for all three bases, and appending native single-qubit analyzers without recompiling the prefix. All policies use a common input layout and output pair. The validator also requires the same physical acquisition sequence up to the first conditional gate. It does not infer intermediate measurement wires from the final quantum layout.

```sh
python3 Checks/IBMBridge/dynamic_prepare.py --runs "$RUNS" --manifest "$EVIDENCE_MANIFEST" \
  --output new-dynamic-common-prefix
python3 Checks/IBMBridge/dynamic_prepare_checks.py --runs "$RUNS" --manifest "$EVIDENCE_MANIFEST"
```

Preparation reads the Open backend target but never submits. The new compiled ISA is simulated locally with only idle physical labels removed; conditional bodies and classical bit addresses remain intact. The offline tests use the archived `ibm-dynamic-common-prefix-20260914` artifact and check native record-conditioned correlations plus rejection of changed prefixes/output pairs.

Identical physical instructions establish a common preparation recipe, not an unconditional claim of stationarity or perfect readout. The fixed proposed hardware criteria and an explicit counterexample to combining unrelated bases are in [the experiment note](../../Research/2026-09-14-dynamic-common-source.md).

## Completed dynamic hardware execution

`dynamic_run.py` prepares, sends once and collects the fixed nine-circuit family on verified free Open, with 1024 shots per circuit and a 60-second execution cap. It upgrades only the two intermediate readouts to supported `measure_2`, checks native ISA, and validates the ideal counterpart locally. Source implementations, QPY, analysis criteria and requested order are frozen before sending. Remote input matching includes conditional bodies and their scoped record addresses. Both output registers are decoded from paired shot records, not separately reconstructed marginals. The once-only ledger prevents response loss from becoming permission to resubmit.

The completed run is `ibm-dynamic-qpu-ready-20260914`, job `dak1h9j9k43c73ahrbug`. It consumed five free quota seconds. The original `ibm-dynamic-qpu-20260914` is an unsubmitted preparation interrupted while serializing calibration dates; it is not an additional hardware run.

```sh
python3 Checks/IBMBridge/dynamic_run_checks.py --runs "$RUNS" --manifest "$EVIDENCE_MANIFEST"
# Verify the copied evidence without a provider call:
python3 Checks/hardware_runs.py --runs "$RUNS" --manifest "$EVIDENCE_MANIFEST" --check-evidence
# Independent offline rational analysis of raw SDK bitstrings:
python3 Checks/IBMBridge/analyse_dynamic.py --runs "$RUNS" --manifest "$EVIDENCE_MANIFEST" \
  --input "$RUNS/ibm-dynamic-qpu-ready-20260914" \
  --output Research/Artifacts/ibm-dynamic-20260914-observations.json
```

The primary Bell score was 0.810059 versus 0.438965 with the extra record ignored. Both frozen conditional statistical criteria passed. An inverted record yielded 0.047852 for the intended Phi+ but 0.8125 for Psi−. This secondary reading shows a different expected quantum frame, not merely a lack of correlations. Physical fidelity and entanglement claims still require the stated common-state and Pauli measurement assumptions; the shot bounds do not establish those assumptions.
