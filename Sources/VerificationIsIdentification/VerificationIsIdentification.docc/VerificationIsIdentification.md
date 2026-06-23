# ``VerificationIsIdentification``

A theory of when checking an answer is the same as knowing it — written as pure Swift types, with the compiler as the proof checker.

## Overview

**Why it exists.** Correctness is usually a second artifact — a proof kept beside the system, drifting from it. This collapses the two: you write the structure, and the writing is the proof. The goal and the method behind that collapse are one page, <doc:Purpose>. This page is the result.

**What it is.** Take a finite set of candidates and a test. If exactly one candidate passes, then "it passed" and "it is the answer" say the same thing — to check the lone survivor is to identify it. (Of `a, b, c`, if only `c` passes, then "`c` passed" and "the answer is `c`" are one fact.) That collapse is the result, ``PassIsIdentification``. It is written as pure Swift types, so the compiler is the proof checker. You write a claim as a protocol, and if it compiles, the claim holds. Nothing runs.

**Why it matters.** Checking an answer is the cheap, mechanical half of knowing. Finding it is the hard half. Where the two collapse, a system that only *checks* thereby *finds* — and since a passing check is a proof, its answer is certain, never confident-but-wrong. This is not one problem's trick: whatever is determinate is a finite structure, so the collapse holds wherever anything is determinate, and it marks the exact line between what can be known for sure and what must be supplied from outside. It is the opposite of a system that guesses fluently yet cannot tell a proof from a guess.

**Where to start.** Four type pages make a plain on-ramp, read in order: ``PassIsIdentification`` (the result), ``SystemCrystallizes`` (a system that settles to one answer), ``Matter`` (what it leaves behind), and ``PlayIsProof`` (the capstone). Everything else under Topics is a reference to dip into — each page stands on its own.

For the derivations, the result is proved and extended across eighteen papers (full list in <doc:Sources>):

- <doc:existence_is_finite> — the ground: to be is to be a finite structure.
- <doc:verification_is_identification> — the result itself, proved.
- <doc:intelligence_is_inevitable> — its first consequence: a learner that must saturate.

From there, pick a thread — matter, distance, learning, dynamics.

**How it is built.** From one act and one fixpoint:

- term **The seed:** a single act of distinction — ``Pair``. Its fixpoint, where the two sides close, is ``Null``.
- term **The move:** two directions and no third — *expand* opens a degree of freedom (`associatedtype`), *compress* closes one (`where`).
- term **The floor:** every space is finite — width (``Pair`` has two sides) × depth (every chain reaches ``Null``).

![The construction law: one seed, two moves, one floor.](law)

**The law applied.** To see the framework used rather than stated, open [the `Playground` module](/verification-is-identification/documentation/playground): the physics of *Matter* §5 reproduced as types — the residual entropy of ice, hydrogen's metastable 2s, the stable proton — and a working solver. A green build is the proof there too.

### What is on this page

The types below are grouped by what each one does: the seed, the markers, the kernel, the four axes, and the theorems built on them. That is the framework's core. The papers carry the rest and are linked from <doc:Sources>. Every type's page stands on its own — a tag like `[Nav N5]` points to its proof in a paper, never something you must read first.

(The page is not ordered by paper: the order the papers were written is one walk through the types, while this lists them by the move each one makes. A fuller account of that organization is in ``Law``.)

> Important: The compiler is the engine. A green build is a proof that type-checked, not a test that passed. When a type conforms to ``SystemCrystallizes``, its compilation is the certificate. When a theorem's premise breaks, every dependent stops compiling.

> Note: The whole tree obeys one construction law (see ``Law``), enforced on every build by the package's linter. The spine and routes below are *induced* from the types: `tree-sort` computes each symbol's group from the `associatedtype`/`where` it declares, and `tree-sort --check` holds the page equal to the types. Nothing is grouped by hand.

## Topics

### Why it exists

- <doc:Purpose>

### Start here

- ``PassIsIdentification``
- ``SystemCrystallizes``
- ``Matter``
- ``PlayIsProof``

### The seed — the two undefined terms

- ``Null``
- ``Pair``

### The medium — markers, the functions on Pair

- ``Permanent``
- ``Monotone``
- ``Decidable``
- ``MetricProperty``
- ``IntegerValued``
- ``Measurable``
- ``Unique``

### The kernel — the V=I core (Pair / Σ-rooted)

- ``StructuresFinite``
- ``OperationsClosed``
- ``EqualityDecidable``
- ``StepsTerminate``
- ``ResultDeterministic``
- ``NoSelfReference``
- ``ComparisonsAreBounded``
- ``RevealsNotCreates``
- ``PipelineTotal``
- ``ScopeBoundedByEncoding``
- ``PassImpliesMembership``

### Identification — the HasSolutions axis

- ``HasSolutions``
- ``IdentityCollapse``
- ``ExactlyOneSurvives``
- ``MembershipDecidable``
- ``PreconditionsGuaranteePass``
- ``PassIsIdentification``
- ``AgentPathCertified``

### The cache — the HasCache axis

- ``HasCache``
- ``CachePermanent``
- ``CacheOnlyGrows``
- ``DiagnosticsAccumulate``
- ``AxesCoOriented``
- ``SaturationIncorruptible``
- ``ResultsIrreversible``
- ``CommunicationBounded``

### The metric — the HasDistance axis

- ``HasDistance``
- ``DistanceOnStructures``
- ``Resistant``
- ``NullIsOrigin``
- ``GradientInComparison``
- ``ResistanceHasMagnitude``
- ``GateIsZeroOfLoss``

### The lens — the HasEncoding axis

- ``HasEncoding``
- ``QualitiesAreFinite``
- ``PerspectiveIsEncoding``

### The axes — pure generators

- ``HasSigma``
- ``HasAlpha``
- ``HasBasis``
- ``HasCompositionalNorm``
- ``HasCost``
- ``HasEfficiency``
- ``HasGrammar``
- ``HasLaw``
- ``HasLibrary``
- ``HasSaturation``
- ``HasTime``

### The floor — what it delegates, where it stops

- ``EncoderConditions``
- ``ConditionalSolving``
- ``DifficultyIsEncoder``
- ``MeasuredGeometry``

### Projection — the framework instantiated on machines

- ``GateWrapper``
- ``AllCoordinatesPresent``
- ``SaturationMap``

### The papers — the routes

- <doc:Sources>
