# ``VerificationIsIdentification``

A theory of when checking an answer is the same act as finding it, written as pure Swift types, with the compiler as the proof checker.

## Overview

Take a finite set of candidates and a test. If exactly one candidate passes, "it passed" and "it is the answer" state the same fact: checking the lone survivor identifies it. (Of `a, b, c`, if only `c` passes, "`c` passed" and "the answer is `c`" say one thing.) That collapse is the result, ``PassIsIdentification``, and it is written as pure Swift types: a claim is a protocol, a claim that compiles is true, and nothing runs. Correctness stops being a second artifact kept in sync beside the system: the writing is the proof.

**Where to go.** Pick by what you came for.

- term **Try it:** [the playground](https://danielswift1992.github.io/typed-playground/) runs in the browser, nothing to install: Swift types on the left, their reading on the right, and the judge names every broken claim at the keystroke. In the compiler, the scheduler in [Examples](https://danielswift1992.github.io/verification-is-identification/documentation/examples) is a proof in nine lines: it derives the one consistent schedule and refuses an impossible one by name. Five minutes either way.
- term **See it at scale:** [Organization](https://danielswift1992.github.io/verification-is-identification/documentation/organization) is a whole company in the notation: browse the site its build rendered, walk a login keypad, read the access verdicts. <doc:Curve> measures the build as the company grows, to 12800 employees.
- term **See why it is true:** <doc:verification_is_identification> proves the result from one postulate, <doc:existence_is_finite> grounds it, and <doc:intelligence_is_inevitable> follows one consequence out. <doc:Neighbors> sets the result beside partial evaluation, Datalog, and total languages.
- term **Build your own:** <doc:Purpose> states what the notation buys and where it stops, <doc:Encoding> maps your part of a system onto it, and ``Law`` is the grammar you write in. These pages are themselves rendered by [DocumentKit](https://danielswift1992.github.io/verification-is-identification/documentation/documentkit): the site is written in the notation it documents.

Two longer threads run through the papers: learning machines, <doc:intelligence_is_inevitable> → <doc:play_is_proof> → <doc:architecture_of_learning_machines>, and the emitted path (token by token, gated or not), <doc:program_is_path>. The type pages under Topics are reference.

**How it is built.** From one act and one fixpoint:

- term **The seed:** a single act of distinction, ``Pair``. Its fixpoint, where the two sides close, is ``Null``.
- term **The move:** two directions and no third: *expand* opens a degree of freedom (`associatedtype`), *compress* closes one (`where`).
- term **The floor:** every space is finite: width (``Pair`` has two sides) × depth (every chain reaches ``Null``).

![The construction law: one seed, two moves, one floor.](law)

### What is on this page

The types below are grouped by what each one does: the seed, the markers, the kernel, the four axes, and the theorems built on them. That is the framework's core. The papers carry the rest and are linked from <doc:Sources>. Every type's page is enough on its own. A tag like `[Nav N5]` points to its proof in a paper, never something you must read first.

(The page is not ordered by paper: the order the papers were written is one walk through the types, while this lists them by the move each one makes. A fuller account of that organization is in ``Law``.)

> Important: The compiler is the engine. A green build is a proof that type-checked, not a test that passed. When a type conforms to ``SystemCrystallizes``, its compilation is the certificate. When a theorem's premise breaks, every dependent stops compiling.

> Note: The whole tree obeys one construction law (see ``Law``), enforced on every build by the package's linter. The spine and routes below are *induced* from the types: `tree-sort` computes each symbol's group from the `associatedtype`/`where` it declares, and `tree-sort --check` holds the page equal to the types. Nothing is grouped by hand.

## Topics

### Why it exists

- <doc:Purpose>
### Encode your own

- <doc:Encoding>
### How these pages read

- <doc:Reading>
### Where it is

- <doc:Neighbors>
### How far it reaches

- <doc:Curve>
### Start here

- ``PassIsIdentification``
- ``SystemCrystallizes``
- ``Matter``
- ``PlayIsProof``
### The seed: one act and its fixpoint

- ``Null``
- ``Pair``
### The medium: markers, the functions on Pair

- ``Structure``
- ``Permanent``
- ``Monotone``
- ``Decidable``
- ``MetricProperty``
- ``IntegerValued``
- ``Measurable``
- ``Unique``
### The kernel: the V=I core (Pair / Σ-rooted)

- ``Open``
- ``Close``
- ``Digit``
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
### Identification: the HasSolutions axis

- ``HasSolutions``
- ``IdentityCollapse``
- ``ExactlyOneSurvives``
- ``MembershipDecidable``
- ``PreconditionsGuaranteePass``
- ``PassIsIdentification``
- ``AgentPathCertified``
### The cache: the HasCache axis

- ``HasCache``
- ``CachePermanent``
- ``CacheOnlyGrows``
- ``DiagnosticsAccumulate``
- ``AxesCoOriented``
- ``SaturationIncorruptible``
- ``ResultsIrreversible``
- ``CommunicationBounded``
### The metric: the HasDistance axis

- ``HasDistance``
- ``DistanceOnStructures``
- ``Resistant``
- ``NullIsOrigin``
- ``GradientInComparison``
- ``ResistanceHasMagnitude``
- ``GateIsZeroOfLoss``
### The lens: the HasEncoding axis

- ``HasEncoding``
- ``FaithfulEncoding``
- ``QualitiesAreFinite``
- ``PerspectiveIsEncoding``
### The axes: pure generators

- ``HasSigma``
- ``ColourIsQuotient``
- ``EncodingForgets``
- ``EncodingInvents``
- ``GamutIsCone``
- ``HasAlpha``
- ``HasBasis``
- ``HasCompositionalNorm``
- ``HasCost``
- ``HasEfficiency``
- ``HasGauge``
- ``HasGrammar``
- ``HasLaw``
- ``HasLibrary``
- ``HasSaturation``
- ``HasTime``
- ``SeparatorIdentifies``
### The floor: what it delegates, where it stops

- ``EncoderConditions``
- ``ConditionalSolving``
- ``DifficultyIsEncoder``
- ``MeasuredGeometry``
### Projection: the framework instantiated on machines

- ``GateWrapper``
- ``AllCoordinatesPresent``
- ``SaturationMap``
### The atlas: what carries what

- <doc:Atlas>
- <doc:AtlasUnfolded>
### The papers: the routes

- <doc:Sources>
