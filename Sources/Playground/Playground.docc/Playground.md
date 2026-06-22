# ``Playground``

Worked examples of the framework: physics reproduced as types, learning machines located by their coordinates, the concrete models that inhabit the markers, and a working solver — each settled by compiling, nothing run.

## Overview

**Start with the lattice.** `VerificationIsIdentification` states the framework's one result: when a finite
test has a single passing answer, *checking* that answer is the same act as *finding*
it. The papers call this Verification Is Identification. This `Playground` is the
applied layer that puts those protocols to work on concrete systems. If you are new,
read [`VerificationIsIdentification`](/documentation/verificationisidentification) first. This page shows what is built on it.

**What you can do here.** The type checker settles each of these by compiling, with
no program run:

- Reproduce the residual entropy of ice — the count of two-in/two-out configurations, `|S| = 6` per vertex.
- Show that hydrogen's 2s state is metastable — the `2s → 1s` transition breaks the dipole rule `Δℓ = ±1`.
- Show that the proton is stable — `p → e⁺ + π⁰` does not conserve baryon number.
- Solve a constraint graph — it reduces to one forced assignment, or the compiler proves that none exists.
- Locate a learning machine by its coordinates — a gated, append-only learner conforms to the crystallizing lattice, and one without a gate (a language model with `|S| > 1`) is rejected with the missing coordinate named.

**How it works.** The type checker performs three operations on a finite structure,
and each corresponds to a question.

| operation | the question | how | examples |
| --- | --- | --- | --- |
| count | How many? | a fold that adds one per structural step | degeneracy `n² = 4`, Goldstones `= 3`, `|S| = 6` |
| select | Is it allowed? | a `where` clause on a relation | `Δℓ = ±1`, `2-in/2-out`, `baryon in == baryon out` |
| propagate | What is forced? | a chain reduced to its forced value | the conflict graph, `|S| = 0/1/>1` |

A count reduces a `Succ`-chain to a number. A select compiles when the case is
allowed, or is rejected with the violated rule named. A propagation gives the
forced value when one is determined, and otherwise reports the result as ambiguous
or impossible.

**How to use it.** There are three steps.

1. Run the demos. `swift test` exercises them and pins the numbers the build
   settled — the residual entropy of ice, the hydrogen spectrum, the scheduler.
2. See a rejection. Rebuild with a flag and read the named error:
   `swift build -Xswiftc -DSHOW_FORBIDDEN` for the forbidden spectral lines and
   proton decay, `-DSHOW_REJECT` for the `|S| > 1` gates, `-DSHOW_UNSAT` or
   `-DSHOW_AMBIGUOUS` for the solver.
3. Encode your own question. Choose the operation, write it as types, and read the
   build. A selection rule is a `where` clause. The cases that satisfy it compile,
   and one that does not is rejected:

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

### Count — how many?

A fold on the `IntegerValued` ladder. The number is the normal form it reduces to.

- ``Survivor``
- ``Eigenstate``
- ``Broken``
- ``Bonds``

### Select — is it allowed?

A `where` clause on a relation. The cases that satisfy it compile, and one that does not is rejected.

- ``Orbital``
- ``DipoleAllowed``
- ``Side``
- ``Conserved``

### Propagate — what is forced?

A chain reduced to its forced value. The result is `|S| = 0`, `1`, or greater than `1`.

- ``Machine``
- ``Task``
- ``CrystallizedSchedule``

### The physical instances — Matter §5 gates

A domain crystallizes when `|S| = 1` or carries a residual when `|S| > 1`, and the encoding is what fixes it.

- ``IceOxygen``
- ``QuantumMeasurement``
- ``HiggsGaugeInvariant``

### Learning machines — the projection

A learner is located by which coordinates it has. A gated, append-only machine conforms to the crystallizing lattice. One without the gate cannot, and the compiler names what is missing.

- ``CertifiedSelfPlay``
- ``LanguageModel``

### One lattice, many domains

Ice, the hydrogen spectrum, and the Higgs vacuum each certify the same `SystemCrystallizes` structure, so a construction written over it applies to all of them at once.

- ``CrystallizingDomain``

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
