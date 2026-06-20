# ``Theory``

A theory of when checking an answer is the same as knowing it — written as pure Swift types, with the compiler as the proof checker.

![The construction law: one seed, two moves, one floor.](law)

## Overview

**What it is.** A theory of when checking an answer is the same as knowing it. Take a finite set of candidates and a test: if exactly one passes, then "it passes" and "it is the answer" are the same fact — to check the lone survivor is to identify it. (Of `a, b, c`, if only `c` passes, then "`c` passed" and "the answer is `c`" say one thing.) That collapse is the result, ``PassIsIdentification``. It is written as pure Swift types, so the compiler is the proof checker: a claim is a protocol, its proof is that the protocol compiles, and nothing runs.

**Why it matters.** Checking is the cheap, mechanical half of knowing; identifying is the hard half. When the two collapse, a system that only *checks* answers thereby *finds* them — and because a passing check is a proof, the answer is **certain**, never confident-but-wrong. This is not a trick for one problem: whatever is determinate is a finite structure, so it holds wherever anything does, and it draws the exact line between what can be known for sure and what must be supplied from outside. It is the opposite shape from a system that guesses fluently and cannot tell a proof from a guess.

**Where to start.** The result is proved and extended across eighteen papers (full list in <doc:Sources>):

- <doc:0_existence_is_finite> — the ground: to be is to be a finite structure.
- <doc:1_verification_is_identification> — the result itself, proved.
- <doc:2_intelligence_is_inevitable> — its first consequence: a learner that must saturate.

From there, follow whichever thread you like — matter, distance, learning, dynamics.

**How it is built.** From one act and one fixpoint:

- term **The seed:** a single act of distinction — ``Pair``. Its fixpoint, where the two sides close, is ``Null``.
- term **The move:** two directions and no third — *expand* opens a degree of freedom (`associatedtype`), *compress* closes one (`where`).
- term **The floor:** every space is finite — width (``Pair`` has two sides) × depth (every chain reaches ``Null``).

### What is on this page

The types below are grouped by what each one does: the seed, the markers, the kernel, the four axes, and the theorems built on them. That is the framework's core; the papers carry the rest and are linked from <doc:Sources>. Every type's page stands on its own — a tag like `[Nav N5]` points to its proof in a paper, never something you must read first.

(The page is not ordered by paper: the order the papers were written is one walk through the types, while this lists them by the move each one makes. A fuller account of that organization is in ``Law``.)

> Important: The compiler is the engine. A green build is not a test that passed — it is a proof that type-checked. Conform a type to ``SystemCrystallizes`` and its compilation *is* its certificate; break a theorem's premise and every dependent stops compiling.

> Note: The whole tree obeys one construction law (see ``Law``), enforced on every build by the package's linter. The spine and routes below are *induced* from the types: `tree-sort` computes each symbol's group from the `associatedtype`/`where` it declares, and `tree-sort --check` holds the page equal to the types. Nothing is grouped by hand.

## Topics

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
- ``VI_Identity``
- ``MembershipDecidable``
- ``ExactlyOneSurvives``
- ``PreconditionsGuaranteePass``
- ``PassIsIdentification``
- ``AgentPathCertified``

### The cache — the HasCache axis

- ``HasCache``
- ``CachePermanent``
- ``ResultsIrreversible``
- ``CommunicationBounded``
- ``CacheOnlyGrows``
- ``DiagnosticsAccumulate``
- ``AxesCoOriented``
- ``SaturationIncorruptible``

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
- ``MeasuredGeometry``
- ``DifficultyIsEncoder``

### Projection — the framework instantiated on machines

- ``GateWrapper``
- ``AllCoordinatesPresent``
- ``SaturationMap``

### Witnesses — concrete models that make it bite

- ``Cell``
- ``ConcreteAgent``
- ``Grew``
- ``Measured``
- ``Path``
- ``Shrank``
- ``Succ``
- ``Verdict``

### The papers — the routes

- <doc:Sources>
