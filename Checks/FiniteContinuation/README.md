# Acquiring a sufficient continuation

The reader consumers listed in [WhereV2](../Archive/WhereV2/README.md) are frozen research code. Their canon-v2 results are historical observations, not current Court proofs; live sibling readers and environment overrides are forbidden. Existing descriptions below retain their historical scope. The modern Court contract rejects three claims accepted by this archived reader.

For the fixed ideal T/X case, the source now lives in
`Sources/Examples/FinitePauliTSource.swift`. `build_from_source.py` reads its
actual fields through the existing court, searches, and checks the resulting
applications against all sixteen current rows using both JS and native courts.
See the [source-binding report](../../Research/2026-09-14-current-source-continuation.md).
The broader models described below remain separately scoped research code.

An offline finite constructor, separate from the existing Swift producer and
IBM submission path. It receives a finite family, an output contract and
available deterministic probes; it returns a decision tree of acquisitions and
continuations. The actual family member is available only to the test fixture.

```sh
private/ibm-runtime-venv/bin/python Checks/FiniteContinuation/audit.py \
  --output Research/Artifacts/finite-continuation-20260914.json
```

Only the auditor needs NumPy/Qiskit, already present in the IBM environment.
The model and planner use the standard library. No network or credentials.

Build a program from a new public request without a hidden-module argument:

```sh
python3 Checks/FiniteContinuation/build.py --connector t \
  --consumer terminal --axis X --output private/finite-X-program.json
```

Optionally supply `--old-memory 00` only if the two declared old neutral X/Z
probes were actually acquired from the same reusable modules. The export
contains contacts, branches and correction/readout instructions; it omits the
fixture's response tables. `planner.execute(program['plan'], read_probe)` then
consumes only replies requested by the program. This abstract protocol still
needs a separately justified physical acquisition adapter.
`audit.audit_program(program, expected_request)` checks the export against a
separately supplied caller request, its full source family, the actual native
instruction fields and all reachable continuations. A matching action label
alone is not enough.

`model.py` specifies two unknown, fixed, reusable Pauli modules A and B around
a known connector U. The actual channel is B U A; the desired channel is U.
Fresh probe preparations have trusted Pauli preparation/readout. Only probes
deterministic for every admitted source are offered. No expectation-value oracle
is counted as a one-shot measurement. Physical noise, changing modules and
unknown acquisition instruments are outside this model.

`planner.py` does not contain quantum matrices, connector-specific strategies or
a realized-source argument. It minimizes the worst-case number of probes until
one admissible action works for every remaining possibility. Other reported
resource components are bounds for the selected plan, not a general optimal
weighted cost. Leaf corrections are shortest in the declared Clifford library.

Consumer capabilities are explicit inputs:

* `bare`: deliver the requested live state, with no residual frame;
* `pauli_frame`: deliver state and an accepted Pauli frame;
* `clifford_frame`: deliver state and an accepted Clifford frame;
* `terminal`: implement the fixed X or Z question through signed Pauli readout.

The constructor chooses within these declared capabilities. It does not invent
an interface language or establish that a real recipient supports a frame.
Changing a terminal question into a live-state request is not allowed.

`audit.py` independently rebuilds the native two-dimensional unitaries with
Qiskit, tests all admissible corrections and frames, verifies every reachable
leaf and old-memory fiber, and checks minima by a separate bounded-tree search.
It also enumerates fixed probes, checks known ordinary frame strategies, and
rejects stale or forged continuations. These checks concern mathematical
semantics, not Swift conformance or physical hardware accuracy.

See [the result](../../Research/2026-09-14-synthesized-continuation.md) for the
two-adaptive-versus-three-fixed result, its algebraic explanation, and the
comparison with an equally capable conventional frame method.

## Noisy acquisitions

`noisy.py` keeps a confidence family under a declared conditional bit-error
bound, including adaptive contact selection and stopping at completed batch
boundaries. It never treats a majority vote as an exact bit. All counts remain
in the record, duplicate receipts are rejected, and budget exhaustion returns
`needs_evidence`. The noise relation is an assumption about acquisition; the
controller does not establish it merely by seeing consistent samples.

```sh
private/ibm-runtime-venv/bin/python Checks/FiniteContinuation/noisy_checks.py \
  --output Research/Artifacts/finite-noisy-local-20260914.json
private/ibm-runtime-venv/bin/python Checks/FiniteContinuation/hardware_checks.py
```

These commands are offline. See the
[statistical protocol](../../Research/2026-09-14-noisy-acquisition-protocol.md)
for the proof, counterexample without the instrument relation, and exact scope.

`hardware.py` is a separate, bounded IBM Open adapter. Initialization fixes 16
opaque episodes, the T/X request, 16-shot acquisition batches, at most four
acquisition rounds, and one two-input validation. Maximum allowance: five
jobs, each capped at 20 free QPU seconds. It reuses `pilot.service_open` to
reject paid instances. A pre-submission ledger prevents accidental resubmission
after a lost network response. Each succeeding round can only be prepared
after collecting the preceding actual result.

The separately frozen campaign is `private/ibm-adaptive-acquisition-20260914`.
Do not initialize or resubmit it to repeat an experiment. `collect` is idempotent.
`analyse_hardware.py` reads official raw SDK bits, reconstructs the controller's
decisions without the fixture settings, then opens those settings to evaluate
the chosen actions. The complete source snapshot is saved with the campaign.

This is a host-controlled sequence of jobs on configured modules. The adapter
does not claim an autonomous QPU learner or a certified unknown physical
process. Its assumed 20% conditional probe-error ceiling is explicit and
unverified independently; logical selection risk and actual validation
accuracy remain separate questions.

## Additional research models

`environment.py --output NEW_DIRECTORY` compiles one continuing local
controller for the live phase family and all 24 Clifford requests. It retains
the complete current family, transports it through seven declared change
relations, and chooses fresh contacts only when needed. The running
`Environment` consumes port receipts and a journal; it performs no search,
compilation or LLM call between tasks. Current Swift fields supply the contact,
frame and transition semantics through the existing courts. See the
[whole-cycle result](../../Research/2026-09-14-continuing-local-environment.md)
for the induction, memory counterexample and exact execution scope.

```sh
private/ibm-runtime-venv/bin/python Checks/FiniteContinuation/environment.py \
  --output NEW_BUILD_DIRECTORY
private/ibm-runtime-venv/bin/python Checks/FiniteContinuation/environment_checks.py \
  --input NEW_BUILD_DIRECTORY --output NEW_AUDIT_DIRECTORY
node Checks/FiniteContinuation/environment_court_checks.js NEW_BUILD_DIRECTORY
```

The fixture keeps a two-qubit payload through whole task streams and obtains
acquisition bits from separate ideal preparations. Its hidden module pair is
not an argument to the controller. Journals are bound to one software resident
handle and one owning executor; interrupted uncertain calls require explicit
reconciliation. These identities do not establish physical stability. This is
an offline ideal environment, separate from the frozen noisy IBM campaign.

### Same-module access and action without new acquisition

`routed.py` adds a standalone call of the **same** A used inside every `F_C=BCA`.
It searches common words, compares their declared prices with fresh acquisition,
and submits actual current-source compositions to both existing courts.
`RoutedEnvironment` inherits acquisition, changes and journal replay from
`Environment`; it adds a checked route output and a same-A capability binding.
It takes no realized hidden pair. Applying a common word preserves the whole
family of possible sources; it does not create a fictitious observation.

```sh
private/ibm-runtime-venv/bin/python Checks/FiniteContinuation/environment.py \
  --output NEW_BASE_DIRECTORY
private/ibm-runtime-venv/bin/python Checks/FiniteContinuation/routed.py \
  --base NEW_BASE_DIRECTORY --output NEW_ROUTE_DIRECTORY
private/ibm-runtime-venv/bin/python Checks/FiniteContinuation/routed_checks.py \
  --base NEW_BASE_DIRECTORY --input NEW_ROUTE_DIRECTORY --output NEW_AUDIT_DIRECTORY
node Checks/FiniteContinuation/routed_court_checks.js NEW_ROUTE_DIRECTORY
```

The verified current base is
`Research/Artifacts/continuing-environment-routed-base-20260914`, with routes in
`Research/Artifacts/routed-access-final-20260914` and independent execution in
`Research/Artifacts/routed-access-verified-20260914`. Builds bind implementation
and source hashes; earlier artifacts remain historical, not silently reusable
after the interpreter changes. Use fresh directories when reproducing builds.

The exact word search is bounded to at most two standalone A and two payload F
calls, at least one F, and external Paulis. It optimizes the current Clifford
request under declared comparison prices, not unknown future workloads or
measured hardware error. Phase requests retain the previous base policy.
The same-A binding checks software ownership; it cannot prove a hidden device
has retained its actual channel. See the
[proofs, eight-goal refinement and execution result](../../Research/2026-09-14-same-module-continuation.md).

### Joint-return accuracy with retained quantum memory

`joint_returns.py` admits a joint word from actual source-derived return
operators and full-DE convex mixtures before comparing declared prices. It
reuses the existing selector and courts. `joint_return_checks.py` independently
checks primitive meanings, channels with a reference, actual memory replacement,
and the difference between generic diamond bounds and mixture-weight bounds.

```sh
private/ibm-runtime-venv/bin/python Checks/FiniteContinuation/joint_returns.py \
  --output NEW_JOINT_DIRECTORY
private/ibm-runtime-venv/bin/python Checks/FiniteContinuation/joint_return_checks.py \
  --input NEW_JOINT_DIRECTORY
```

Current result: `Research/Artifacts/joint-returns-complete-20260914`.
The [joint-return report](../../Research/2026-09-14-joint-return-admission.md)
states the theorem, the changing-memory positive example, the identical-local-
channels counterexample, and the explicit error contract. Rates and costs are
parameters of a constructed offline model, not measurements of hardware.

This is a bounded admission layer with SDK execution, not a replacement for
the persistent Pauli `Environment` journal. Its history must describe actual
earlier admitted mixtures. The old sixteen Pauli rows do not describe CZ with
an entangled memory, so an old calibration key is not used as an invented
fallback when a joint return is unestablished. No cloud calls occur.

### Whole-word frames and acquired admission

`whole_word_frame.js` applies the existing court to `WholeWordFrame.swift`:
24 Clifford goals × four external Pauli choices × two memory constructions.
It derives the matching end control and checks 192 exact operator equalities
(ordinary-channel phases are explicit), plus three refusals in both courts.
No control is inserted inside the synthesized word.

`whole_word_admission.py` acquires one fixed simulated Bell record and derives
a full-DE product-family error allowance from its one-sided binomial endpoint
and the actual calibration preparation. `LocalContinuation` owns the evolving
state and history; it reuses the existing selector, executes admitted maps
through Qiskit `DensityMatrix.evolve`, and leaves state unchanged upon refusal.
The complete fixed simulator supplies the calibration-to-use relation. This
does not interpret past IBM frequencies as a stable future law.

```sh
private/ibm-runtime-venv/bin/python Checks/FiniteContinuation/whole_word_admission.py \
  --output Research/Artifacts/whole-word-admission-20260914
private/ibm-runtime-venv/bin/python Checks/FiniteContinuation/whole_word_checks.py \
  --output Research/Artifacts/whole-word-admission-20260914
```

The [result and analytical proofs](../../Research/2026-09-14-whole-word-admission.md)
separate the court's finite equations from the norm theorem, CP-instrument
composition bound, simulator statistics and hardware obligations. The product
bound uses the actual Pauli/quantum-memory branches; a bare scalar diamond bound
does not suffice. The local construction exports no seed, assumes no free
direct target gate, and adds no cloud submission path. `whole_word_checks.py`
also verifies arbitrary finite CPTP maps, bad memory directions, visible/leaked
seeds, destroyed cross-word cancellation and the acquired three-use limit.

The old frozen IBM campaign has completed; its monitor is paused. The
[separate hardware analysis](../../Research/2026-09-14-adaptive-acquisition-hardware-result.md)
records 16/16 correct logical decisions and 8025/8192 expected validation
outcomes. It does not test the new standalone A access.

`contact_synthesis.py --output NEW_DIRECTORY` constructs contact words through
the existing type court. The separate interface exposes only A [middle] B,
with H/S middle controls and no individual module access. The generated S
contact resolves a question that the complete neutral channel cannot answer.
Its exact scope, 3-versus-4 bounds, current-row applications and independent
SDK execution are in [the contact result](../../Research/2026-09-14-composed-contact-result.md).
`contact_court_checks.js PROPOSAL` checks refusals and an equivalent longer word.
This ideal contact-synthesis route is separate from the frozen noisy QPU run.

`reuse_scope.py --output NEW_DIRECTORY` returns the three ideal composed-port
acquisitions to eight shared keys in the current source. Each key supports a
whole family of live phase rotations and bit-flipped phase rotations, with an
exact boundary and a one-probe route to full pair identification. The key is
checked by both courts; the continuous recovery law is separately proved, not
asserted by a protocol name. See the [reuse result](../../Research/2026-09-14-reusable-phase-scope.md).
This is an ideal offline result with a richer live-output consumer, not an
extension of the running QPU campaign or a reuse of its unacquired data.

`renewal.py --output NEW_DIRECTORY` propagates the old key's complete family
through an explicitly declared Pauli change relation, synthesizes fresh probes
and submits every admitted old/new edge to both existing courts. Known changes
can transport the key with no probes; partial change constraints give exact
0/1/2/3 refresh costs. `renewal_detection.py` separately compares the cost of
checking old-key applicability with rebuilding the key. The
[renewal report](../../Research/2026-09-14-phase-key-renewal.md) states the
temporal premises, positive repair and truthful-but-mixed-epoch counterexample.
These are offline ideal results; a profile name does not certify real drift.

`certify_acquisition.py --input CAMPAIGN --output NEW_DIRECTORY` replays the
raw acquired prefix against the current Swift T/X source and submits one common
continuation to both existing courts for EVERY retained source row. Pending
jobs add no evidence; empty families and unresolved questions publish no action.
The archive entry never accepts a caller-selected subset. This is an offline
conditional certificate, not a change to the frozen IBM execution campaign.
Source membership and the acquisition-noise bound are not proved by the courts.
See [the acquired-family result](../../Research/2026-09-14-acquired-family-continuation.md).
`acquisition_bridge_checks.py` checks synthetic noisy archives, partial prefixes,
common-action applications and refusals without cloud access.

`batched.py` chooses batch boundaries under explicitly priced rounds and
deterministic reusable probes. Its exact finite scope and the independent
nonquantum case are in the [batch report](../../Research/2026-09-14-batched-continuation.md).
`instrument_symmetry_checks.py` expands the source with an unknown common
readout inversion; its [three-versus-four result](../../Research/2026-09-14-instrument-symmetry.md)
does not establish a noisy physical instrument model. Neither extension is
currently admitted by the T/X type-application bridge or the frozen QPU run.
