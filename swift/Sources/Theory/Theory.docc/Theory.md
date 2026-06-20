# ``Theory``

A formal theory encoded as a lattice of pure Swift types — where the compiler *is* the proof checker.

![The construction law: one seed, two moves, one floor.](law)

## Overview

The theory grows from one act and one fixpoint.

- term **The seed:** a single act of distinction — ``Pair``. Its fixpoint, where the two sides close, is ``Null``.
- term **The move:** two directions and no third — *expand* opens a degree of freedom (`associatedtype`), *compress* closes one (`where`).
- term **The floor:** every space is finite — width (``Pair`` has two sides) × depth (every chain reaches ``Null``).

The central result is one line: when exactly one candidate survives verification, the verifier is already an identifier — ``PassIsIdentification``, encoded as `where Left == SolutionSet`. Nothing here runs; you read a fact by asking the type checker — *does `X` conform? what is `X.SolutionSet`?* — never by computing a value.

### How this is organized

Not by paper. The order the papers were written is one walk through the lattice, not its structure — so this is organized by the structure, measured from the lattice itself.

Every protocol makes one move, and that move *is* its place. A few **open an axis** (`associatedtype`) — a new degree of freedom; these *generators* are the only part that partitions cleanly, the lattice's **spine**. Every other protocol **pins** a fixpoint (`where`) or **intersects** several — a *bridge* like ``Matter`` or ``GateIsMembrane``, standing where axes meet, at home in no single subject. Most of the lattice is bridges, and they form a **cone**: the deeper a theorem sits, the more axes it weaves, until the capstones — ``PlayIsProof``, ``InteractiveDecomposition`` — braid nearly all of them at once.

So this is a small **basis** of axes spanned by a **web** of theorems — the framework's own *Basis Is Residue*, turned on itself. The split decides the page. The **spine** is here on this landing: the seed, the markers, the kernel, and the four axes with the theorems that hang on them. The **web** is carried by the papers — each paper page lists the bridges it proves, because a walk through the lattice is itself a certified object (*Order Is Object*). Territory here, routes there.

The papers these protocols encode — and why their order is deliberately not this one — are credited in <doc:Sources>. Each symbol's page stands on its own; a paper tag like `[Nav N5]` points to the formal proof, never something you must read first.

> Important: The compiler is the engine. A green build is not a test that passed — it is a proof that type-checked. Conform a type to ``SystemCrystallizes`` and its compilation *is* its certificate; break a theorem's premise and every dependent stops compiling.

> Note: The whole tree obeys one construction law — see ``Law`` — enforced on every build by a linter wired into the package. Pure types, no renames: structurally, not by anyone remembering. This page is the same law read one level up: the spine and the routes below are *induced* from the types — each symbol placed by the move it makes — never arranged by hand.

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
