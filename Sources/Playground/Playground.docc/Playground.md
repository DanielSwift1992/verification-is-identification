# ``Playground``

Worked examples of the framework: physics reproduced as types, learning machines located by their coordinates, the concrete models that inhabit the markers, and a working solver — each one checked by the compiler, nothing run.

## Overview

**Start with the scheduler.** It asks for no physics: tasks, two machines, and
conflicts that force each task onto the opposite machine. The compiler propagates
the one consistent assignment and certifies it, or refuses an impossible schedule
by name — ``Pinned``, ``Conflicts``, ``Require``, all in `Coloring.swift`. Read it
first; every other example is the same three operations on a harder board.

**Then dive in.** Every example here is a finished result you can read on its own:
the residual entropy of ice, hydrogen's metastable 2s, the stable proton. The one
idea underneath, that checking a single-survivor answer is the same act as finding
it, lives in
[`VerificationIsIdentification`](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification) — but the examples do not wait on it.

**What you can do here.** You do not need the physics. Each example is a real, known
result, and the point is that the compiler reproduces it by type-checking, with no
program run:

- **Reproduce the residual entropy of ice.** Ice keeps a little disorder even when cooled to absolute zero, a fact known since the 1930s. The compiler counts the allowed arrangements of its atoms and gets the number: `|S| = 6` per vertex.
- **Show why hydrogen's 2s state is long-lived.** The jump that would empty it is forbidden by a rule on which light an atom can emit, so it survives far longer than its neighbours. The compiler rejects the `2s → 1s` transition for breaking the rule (`Δℓ = 0`, not `±1`).
- **Show why the proton never decays**, the reason ordinary matter holds together. Its one possible decay would break a conservation law. The compiler finds `p → e⁺ + π⁰` does not conserve baryon number.
- **Solve a constraint graph.** It reduces to one forced assignment, or the compiler proves that none exists.
- **Locate a learning machine by its coordinates.** A gated, append-only learner conforms to the crystallizing lattice. One without a gate (a language model, `|S| > 1`) is rejected, with the missing coordinate named.

**How it works.** The type checker performs three operations on a finite structure,
and each corresponds to a question.

| operation | the question | how | examples |
| --- | --- | --- | --- |
| count | How many? | a fold that adds one per structural step | degeneracy `n² = 4`, Goldstones `= 3`, `\|S\| = 6` |
| select | Is it allowed? | a `where` clause on a relation | `Δℓ = ±1`, `2-in/2-out`, `baryon in == baryon out` |
| propagate | What is forced? | a chain reduced to its forced value | the conflict graph, `\|S\| = 0/1/>1` |

A count reduces a `Succ`-chain to a number. A select compiles when the case is
allowed, or is rejected with the violated rule named. A propagation gives the
forced value when one is determined, and otherwise reports the result as ambiguous
or impossible.

**How to use it.** There are three steps.

1. Run the demos. `swift test` exercises them and pins the numbers the build
   produced — the residual entropy of ice, the hydrogen spectrum, the scheduler.
2. See a rejection. Rebuild with a flag and read the named error:
   `swift build -Xswiftc -DSHOW_FORBIDDEN` for the forbidden spectral lines and
   proton decay, `-DSHOW_REJECT` for the `|S| > 1` gates, `-DSHOW_UNSAT` or
   `-DSHOW_AMBIGUOUS` for the solver.
3. Encode your own question. Choose the operation, write it as types, and read the
   build. A selection rule is a `where` clause. The cases that satisfy it compile,
   and one that does not is rejected. The `Lowers` and `Orbital` types below are real,
   in `Sources/Playground/Hydrogen.swift`:

   ```swift
   // The dipole rule Δℓ = ±1, written as a where clause.
   let allowed = Lowers<Orbital2p, Orbital1s>.self      // compiles: Δℓ = −1
   // let forbidden = Lowers<Orbital2s, Orbital1s>.self // rejected: Δℓ = 0, so 2s is metastable
   ```

   A count is a fold (``Bonds``) and a forcing is a chain (``Machine``). The
   vocabulary (`Succ`, `Pair`, `Unique`, `SystemCrystallizes`) comes from the
   `VerificationIsIdentification` lattice.

**The boundary.** The framework expresses any determinate property: a discrete law
is a relation on finite structures (Law §3), checked for a concrete system. Two
things are left to the encoder (E2): the search for which structure satisfies a
relation when more than one survives (`|S| > 1`), and the encoding of a continuous
magnitude into a finite structure. The type checker verifies. The encoder searches.

## Topics

### The solver — a certified scheduler

Constraints propagate to one forced assignment (`|S| = 1`), or the graph reports as ambiguous (`|S| > 1`) or impossible (`|S| = 0`). Nothing is searched at runtime. The answer is a type reduction.

- ``Machine``
- ``MachineA``
- ``MachineB``
- ``Task``
- ``CrystallizedSchedule``
- ``AmbiguousSchedule``
- ``Conflict``
- ``Conflicts``
- ``Separated``
- ``Pinned``
- ``Require``

### Ice — residual entropy, counted

Ice keeps a little disorder even at absolute zero, and this counts it. Six of sixteen proton arrangements obey the two-in/two-out ice rule, a fold that counts them to `|S| = 6` per vertex. ``IceOxygen`` crystallizes (`|S| = 1`) while the hydrogen positions carry the residual.

- ``IceOxygen``
- ``IceHydrogen``
- ``IceVertex``
- ``Bonds``
- ``Survivor``
- ``In``
- ``Out``
- ``Vacuum``

### The hydrogen spectrum — selection by a where clause

Some jumps an electron could make are forbidden, which is why parts of an atom's light are missing. A transition emits a line when it satisfies the dipole rule `Δℓ = ±1`, a `where` clause the compiler checks. The `2s → 1s` step has `Δℓ = 0`, so it is rejected and 2s is long-lived.

- ``Orbital``
- ``Orbital1s``
- ``Orbital2s``
- ``Orbital2p``
- ``Orbital3s``
- ``Orbital3p``
- ``Orbital3d``
- ``Lowers``
- ``Raises``
- ``DipoleAllowed``

### The Higgs vacuum — broken symmetry, counted

When a symmetry of nature breaks, some directions cost nothing to shift, and this counts them. Electroweak breaking leaves three massless Goldstone directions, counted to `= 3`. ``HiggsGaugeInvariant`` is the gauge-invariant vacuum (`|S| = 1`) while the field components carry the residual.

- ``HiggsGaugeInvariant``
- ``HiggsFieldComponents``
- ``BrokenSymmetry``
- ``Unbroken``
- ``Broken``
- ``ThreeGoldstones``
- ``Counted``

### Quantum measurement — degeneracy

A measurement with a single possible outcome pins down one state. When several states share an outcome, a residual remains. A non-degenerate eigenvalue identifies a single state (`|S| = 1`). A degenerate level leaves a residual of `n²`, read by the same gate that certifies the other domains.

- ``QuantumMeasurement``
- ``DegenerateMeasurement``
- ``Eigenspace``
- ``Eigenstate``
- ``NoEigenstate``
- ``IdentifyingMeasurement``
- ``Identified``

### Conservation laws — what a reaction allows

A reaction can happen only if its books balance, the same totals on both sides. A process is allowed when its conserved quantities close across the arrow, a `where` clause on the totals. The proton is stable because `p → e⁺ + π⁰` conserves charge but not baryon number.

- ``Conserved``
- ``Reaction``
- ``Proton``
- ``Positron``
- ``Pion0``
- ``DeltaPlus``
- ``Side``
- ``Nothing``
- ``Allowed``

### Learning machines — the projection

A learner is located by which coordinates it has. A gated, append-only machine conforms to the crystallizing lattice. One without the gate cannot, and the compiler names what is missing.

- ``CertifiedSelfPlay``
- ``LanguageModel``

### One lattice, many domains

Ice, the hydrogen spectrum, the Higgs vacuum, and the packing of this package's own generated code each certify the same `SystemCrystallizes` structure, so a construction written over it applies to all of them at once — and the four crystals below prove it by compiling. It is one game on four boards, and the fourth board is the package itself: under the cost encoding the measured packings crystallize to one survivor, and under the content encoding they refuse to, because every packing renders the same bytes.

- ``CrystallizingDomain``
- ``IceCrystal``
- ``HiggsCrystal``
- ``QuantumCrystal``
- ``FormCrystal``
- ``PackingUnderCost``
- ``PackingUnderContent``

### The demo's own hands

The scheduler's four tasks, the readers the demos print with, and the named counts the examples pin.

- ``T0``
- ``T1``
- ``T2``
- ``T3``
- ``ClosingConflict``
- ``machineName(_:)``
- ``allowedReactions``
- ``hydrogenLines``
- ``Zero``
- ``One``
- ``Two``
- ``Three``

### The hydrogen ladder, named

The orbital angular momenta and the survivor sets the spectrum demo reads.

- ``EllS``
- ``EllP``
- ``EllD``
- ``HydrogenLevel2``
- ``HydrogenSurvivor1``
- ``HydrogenSurvivor2``
- ``HydrogenSurvivor3``
- ``HydrogenSurvivor4``
- ``HydrogenSurvivor5``
- ``HydrogenSurvivor6``
- ``NonDegenerate``
- ``LeftSurvivor``
- ``RightSurvivor``
- ``TwoSurvivors``
- ``Electroweak``
- ``ElectroweakGoldstones``

### The concrete machines

Ordinary-Swift witnesses beside the pure types: the learners the projection locates.

- ``CountedPath``
- ``EmittingPath``
- ``FreeBabbler``
- ``GatedSolver``
- ``HollowReach``

### The witnesses — concrete models of the markers

Non-trivial inhabitants that make the proof bite: the markers have rich models, not only the empty `Never`.

- ``Cell``
- ``Succ``
- ``Grew``
- ``Shrank``
- ``Path``
- ``Measured``
- ``Verdict``
- ``ConcreteAgent``
