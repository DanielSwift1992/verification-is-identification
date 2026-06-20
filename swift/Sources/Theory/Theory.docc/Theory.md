# ``Theory``

A theory of when checking an answer is the same as knowing it — written as pure Swift types, with the compiler as the proof checker.

![The construction law: one seed, two moves, one floor.](law)

## Overview

**The one idea.** When exactly one candidate can pass a test, then to pass the test *is* to be the answer: verification and identification are one act (``PassIsIdentification``). That single result is the whole of it; everything else is how far it reaches and what follows.

**Why it reaches everywhere.** Whatever is determinate — a concept no less than an object — is a finite structure (*Existence Is Finite*), and on finite structures the identity holds with no further argument. So it grounds, in the papers below, intelligence, matter, distance, and learning — each derived, none assumed.

**How it is checked.** Nothing here runs. The theory is encoded as pure Swift types, so reading a fact is asking the type checker — *does `X` conform? what is `X.SolutionSet`?* — never computing a value. A green build is not a test that passed; it is a proof that type-checked.

**How it is built — one act and one fixpoint:**

- term **The seed:** a single act of distinction — ``Pair``. Its fixpoint, where the two sides close, is ``Null``.
- term **The move:** two directions and no third — *expand* opens a degree of freedom (`associatedtype`), *compress* closes one (`where`).
- term **The floor:** every space is finite — width (``Pair`` has two sides) × depth (every chain reaches ``Null``).

### How to read this

Not by paper. The order the papers were written is one walk through the lattice, not its structure — so the page is organized by the structure, measured from the lattice itself.

Every protocol makes one move, and that move *is* its place. A few **open an axis** (`associatedtype`) — these *generators* are the lattice's **spine**, the only part that partitions cleanly. Every other protocol **pins** a fixpoint (`where`) or **intersects** several — a *bridge* like ``Matter`` or ``GateIsMembrane``, belonging to no single subject. Most of the lattice is bridges, deepening into a **cone**: the deeper a theorem, the more axes it intersects, until the capstones — ``PlayIsProof``, ``InteractiveDecomposition`` — intersect nearly all at once.

So a small **basis** of axes spanned by a **web** of theorems — the framework's own *Basis Is Residue*, turned on itself. The **spine** is on this landing: the seed, the markers, the kernel, and the four axes with the theorems that hang on them. The **web** is carried by the papers, each listing the bridges it proves (a walk through the lattice is itself a certified object — *Order Is Object*). Territory here, routes there. The papers are credited in <doc:Sources>; each symbol's page stands on its own, and a tag like `[Nav N5]` points to the proof, never something you must read first.

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
