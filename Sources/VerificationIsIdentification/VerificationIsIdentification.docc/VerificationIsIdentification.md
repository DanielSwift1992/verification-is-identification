# ``VerificationIsIdentification``

The framework is a notation for questions, their grounds, checked constructions and the conditions of continued use.

## Overview

The notation starts from a distinction, represented by two addressed roles. A question reads a distinction in each description, and its answer is the value read there. The compatible cases are the descriptions the given relations admit. An answer is determined when at least one compatible case exists and every one of them gives that answer. For a question q and compatible cases S, this is S≠∅ and q(S)={a}. Complete candidate identification is the case q=id. Application to the intended source requires a justified source relation (U2c and §1b of <doc:verification_is_identification>).

**A schedule.** Four tasks use machine labels A and B, with opposite(A)=B and opposite(B)=A. Pinning the first task to A and requiring three successive conflicts forces this assignment:

```text
task:       1   2   3   4
machine:    A   B   A   B
```

The last and first tasks satisfy the closing conflict: B opposite A. An extra conflict between first and third is incompatible: A against A. This proof identifies machine coordinates. Execution requires actual tasks and admissible operations. The construction and named refusal are in <doc:Encoding>.

**The loop.** The proposer supplies the original question, grounds and construction. The checker checks the construction under those grounds:

```text
question + grounds → proposed construction → checked consequence
                                          → named refusal
                                          → open proof obligation
```

A named refusal concerns that attempt. Continued use requires the actual result and its applicable grounds, with a justified relation to the original question (§1b of <doc:verification_is_identification>).

**The notation.**

- term **The seed:** the seed is a pair of addressed roles, ``Pair``. Equality of their types is the ``Null`` constraint.
- term **The moves:** *expand* opens an axis. *compress* constrains axes with a stated relation (``Law`` §1).
- term **The floor:** each term in the finite constructor interpretation reaches a declared leaf. Recursive Swift conformances need not terminate, and a family of finite terms can be infinite. Equality of ``Pair``'s sides, expressed by ``Null``, does not identify every such form with the leaf.

**The Swift reading.** The compiler checks a generic construction that requires the premises and derives the conclusion from its actual fields (``Law`` §T). An interface requirement states the claim. Its derivation needs the construction. The full-candidate interface is ``PassIsIdentification``.

**Where to go.**

- term **Try it:** [the playground](https://danielswift1992.github.io/typed-playground/) runs in the browser, nothing to install: Swift types on the left, their reading on the right, and the judge names every broken claim at the keystroke. In the compiler, the scheduler in [Examples](https://danielswift1992.github.io/verification-is-identification/documentation/examples) is a proof in nine lines: it derives the one consistent schedule and refuses an impossible one by name. Five minutes either way.
- term **See it at scale:** [Organization](https://danielswift1992.github.io/verification-is-identification/documentation/organization) is a whole company in the notation: browse its generated dashboard and catalogs, walk a login keypad, read the access verdicts. <doc:Curve> measures the build as the company grows, to 12800 employees.
- term **See the grounds:** <doc:verification_is_identification> states the verification contracts, <doc:existence_is_finite> proves representation under explicit constructor and generation premises, and <doc:learning_is_liquid> studies which internal relations determine contacts, roles and permitted changes. <doc:Neighbors> sets the notation beside partial evaluation, Datalog, and total languages.
- term **Check it:** <doc:AtlasOrder> orders every claim after its premises. <doc:Atlas> counts each claim's dependents, <doc:AtlasAblation> records which premises the core build enforces (58 of 349 explicit premises), <doc:AtlasRepeats> counts premises declared twice, and <doc:AtlasArgued> counts the edges whose argument carries a record.
- term **Build your own:** <doc:Purpose> states what the notation buys and where it stops, <doc:Encoding> maps your part of a system onto it, and ``Law`` is the grammar you write in. These pages are themselves rendered by [DocumentKit](https://danielswift1992.github.io/verification-is-identification/documentation/documentkit): the site is written in the notation it documents.

Two longer threads run through the papers: learning machines, <doc:intelligence_is_inevitable> → <doc:play_is_proof> → <doc:architecture_of_learning_machines>, and the emitted path (token by token, gated or not), <doc:program_is_path>. The type pages under Topics are reference.

![The construction law: one seed, two moves, one floor.](law)

### What is on this page

The framework's core types are grouped by what each one does: the seed, the markers, the kernel, the four axes, and the theorems built on them. The papers carry the rest and are linked from <doc:Sources>. Every type's page is enough on its own. A tag like `[Nav N5]` points to its proof in a paper, never something you must read first.

The page's order follows each type's move. The papers' writing order gives a different walk through the types. ``Law`` gives a fuller account of that organization.

> Important: The compiler checks the relations expressed in each concrete or generic construction. The source-bound schedule and contact examples derive their conclusions from those relations. The legacy ``SystemCrystallizes`` coordinates alone do not establish a unique actual schedule or completion of an arbitrary search. A refusal identifies the incompatible construction whose premises were changed.

> Note: The package's linter checks the construction law in ``Law``. `check.sh` runs the lattice checks. `tree-sort` derives every group in the spine and routes below from the types' `associatedtype`/`where` declarations, and `tree-sort check` checks the page against that generated form.

## Topics

### Why it exists

- <doc:Purpose>
### Encode your own

- <doc:Encoding>
### How these pages read

- <doc:Reading>
- <doc:Results>
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
- ``ComparedReadings``
- ``ObservationTrace``
- ``Unique``
- ``RetainedReadingRecord``
### The kernel: the V=I core (Pair / Σ-rooted)

- ``Open``
- ``Close``
- ``Digit``
- ``SharedBoundaryContinuation``
- ``StructuresFinite``
- ``OperationsClosed``
- ``RootedRecordReadings``
- ``SharedDeclaredTick``
- ``VerdictRetainsLeft``
- ``VerdictRetainsRight``
- ``VerdictReorders``
- ``CoverageMatchesDeclaration``
- ``SharedDecoder``
- ``EvidenceRefinesQuestion``
- ``EqualityDecidable``
- ``StepsTerminate``
- ``ResultDeterministic``
- ``NoSelfReference``
- ``ComparisonsAreBounded``
- ``RevealsNotCreates``
- ``RefinementPreservesAnswer``
- ``EmptyObservationTrace``
- ``ExtendedObservationTrace``
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
- ``ObservedTransition``
- ``QualitiesAreFinite``
- ``CommutingTransition``
- ``EncodingInvents``
- ``ConservedReadingStep``
- ``PerspectiveIsEncoding``
### The axes: pure generators

- ``HasSigma``
- ``HasAlpha``
- ``HasBasis``
- ``HasCandidates``
- ``HasCompositionalNorm``
- ``HasCost``
- ``HasEfficiency``
- ``HasGauge``
- ``HasGrammar``
- ``HasLaw``
- ``HasLibrary``
- ``HasSaturation``
- ``HasStrategy``
- ``HasTime``
- ``HasVerdict``
- ``StrategyBecomesTarget``
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
### The papers: the routes

- <doc:Sources>
