# ``Examples``

Worked examples of the framework: supplied physical encodings, learning interfaces, structural witnesses and a constraint-derived schedule. The compiler checks their actual type equations. Physical interpretation and any mathematical domain argument must be established separately.

## Overview

**Start with the scheduler.** It asks for no physics: tasks, two machines, and
conflicts that force each task onto the opposite machine. PinnedScheduleIsForced
derives the assignment of arbitrary tasks satisfying the pin and chain edges.
ClosingConflict separately checks the remaining edge. Start with ``Pinned``,
``Conflicts`` and ``Require`` in `Coloring.swift`. This example has a direct
uniqueness proof, independently of its legacy SystemCrystallizes witness.

**Then inspect the domain examples.** Their type equations have different scopes:
a supplied count, an admitted transition or an interface witness. Matter §5
separates them from the physical claims and gives explicit conditional calculations
for a projective measurement branch and the Higgs scalar potential. The central
membership-to-identification result is in
[`VerificationIsIdentification`](https://danielswift1992.github.io/verification-is-identification/documentation/verificationisidentification).

**What you can check here.** Each example exposes its stated type constraints:

- **Inspect the ice-rule vertices.** The example declares six local two-in/two-out patterns. A local vertex count alone does not derive the entropy of a complete lattice.
- **Show why hydrogen's 2s state is long-lived.** The jump that would empty it is forbidden by a rule on which light an atom can emit, so it survives far longer than its neighbours. The compiler rejects the `2s → 1s` transition for breaking the rule (`Δℓ = 0`, not `±1`).
- **Check the declared baryon-number rule.** The proposed `p → e⁺ + π⁰` transition fails that constraint. This does not prove an unrestricted physical prohibition of proton decay.
- **Derive a pinned schedule.** The conflict equations force its assignment. A conflicting additional edge is rejected. Without the pin, two assignments can both be valid.
- **Check a learning interface's coordinates.** The compiler accepts or rejects its actual type constraints. A missing Unique conformance does not establish a language model's candidate count or correctness. Program Is Path PiP7 separates admissibility from identification.

**How it works.** The type checker performs three operations on a finite structure,
and each corresponds to a question.

| operation | the question | how | examples |
| --- | --- | --- | --- |
| count | How many? | a fold that adds one per structural step | degeneracy `n² = 4`, Goldstones `= 3`, `\|S\| = 6` |
| select | Is it allowed? | a `where` clause on a relation | `Δℓ = ±1`, `2-in/2-out`, `baryon in == baryon out` |
| propagate | What is forced? | a chain reduced to its forced value | the pinned conflict graph |

A count reduces a `Succ`-chain to a number. A select compiles when the case is
allowed, or is rejected with the violated rule named. A propagation gives the
forced value under its input equations. A rejection concerns the attempted
construction. A complete ambiguity or impossibility result needs the domain
argument, such as the pinned schedule's forced coordinates and closing edge.

**How to use it.** There are three steps.

1. Run the demos. `swift test` checks the declared examples and presentation
   data. The focused checks in Checks verify generic implications and refusals.
2. See a rejection. Rebuild with a flag and read the named error:
   `swift build -Xswiftc -DSHOW_FORBIDDEN` for the forbidden spectral lines and
   proton decay, `-DSHOW_REJECT` for the legacy interface gates, or
   `-DSHOW_UNSAT` for the incompatible schedule edge. `-DSHOW_AMBIGUOUS`
   checks an incompatible Unique coordinate, without counting schedules.
3. Encode your own question. Choose the operation, write it as types, and read the build. The `DipoleAllowed.Type` annotation asks the compiler to check the selection rule in the conditional conformance. The allowed transition satisfies its `where` clause. The forbidden transition fails it. The `Lowers` and `Orbital` types below are real, in `Sources/Examples/Hydrogen.swift`:

   ```swift
   // The dipole rule Δℓ = ±1, written as a where clause.
   let allowed: DipoleAllowed.Type = Lowers<Orbital2p, Orbital1s>.self      // compiles: Δℓ = −1
   // let forbidden: DipoleAllowed.Type = Lowers<Orbital2s, Orbital1s>.self // rejected: Δℓ = 0, so 2s is metastable
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

### Verdicts — an answer without source identification

Two beams share a visible answer while their infrared answers differ. The
certificates join finite groups, retain an actual member, and reorder branches.
`bash Checks/verdict.sh` checks the generic implications and requires the
compiler to reject broken premises independently.
The same check probes the finite-structure boundary with two explicit floor
refusals, recorded in `Checks/FiniteBoundary.swift`.

- ``JoinedVerdict``
- ``DirectAnswerRecord``
- ``SingletonVerdict``
- ``CertifiedGroup``
- ``ReversedVerdict``
- ``ReorderVerdict``
- ``RetainLeftVerdict``
- ``RetainRightVerdict``
- ``VisibleReading``
- ``InfraredReading``
- ``VisibleVerdict``
- ``ThreeBeamVerdict``

### Coverage and sufficient observations

A declared three-beam tree rejects missing and repeated replacements even
when their answers agree. A generic factorization recovers the alpha answer
from the visible image for any beam. An entire red-visible family shares one
answer without enumerating its hidden coordinate. A symbolic operation that
exposes that coordinate demonstrates the limit of reusing an invariant.
`Checks/Coverage.swift` checks these boundaries alongside the verdict checks.

The [published visible claim](https://danielswift1992.github.io/verification-is-identification/documentation/documentkitdemo/coveredvisibleclaim) reads its support,
question, encoding and answer from a root-bound coverage application.
`swift run DocumentKitDemo claim --write` regenerates that page.

- ``CandidateLeaf``
- ``CandidateNode``
- ``CandidateSiblingRemovalsCommute``
- ``CandidateFork``
- ``CoveredLeaf``
- ``CoveredJoin``
- ``CoveredGroup``
- ``CheckedCoverage``
- ``ThreeBeamsCovered``
- ``AlphaFactors``
- ``SharedVisibleImage``
- ``AnswersThroughSharedDecoder``
- ``RedVisibleBeam``
- ``RedWithHidden``
- ``RedFamilyVerdict``
- ``ExposeHidden``
- ``SwapVisible``
- ``SwapFactors``
- ``SharedSwappedImage``

### Transport between representation codes

A native pair, a reversed wire pair and a scalar preserve one payload
question. The original codes remain in tagged input addresses. A generic
join derives the final factorization through the same actual intermediate
reading. `Checks/Transport.swift` checks the implications and independent
refusals. The factorization arguments are in Verdict Is Invariant.

- ``AddressedRepresentation``
- ``AddressedReading``
- ``JoinedFactorization``
- ``IdentityFactorization``
- ``LayoutFactorization``
- ``PayloadFactorization``

### Certified saturation under mixed operations

Two coordinate swaps are separately compatible with smaller observations.
Their mixed continuations require all three active coordinates. The completed
image retains the alpha question and supports both image updates. Generic
path constructors cover every finite interleaving. `Checks/Saturation.swift`
checks these implications and refuses the insufficient image and wrong order.
VI VC44–VC45 prove closure and future-question factorization directly.

- ``FullSpectrumReading``
- ``SpectrumAlphaFactors``
- ``SpectrumFirstTransition``
- ``SpectrumSecondTransition``
- ``AppendSpectrumFirst``
- ``AppendSpectrumSecond``
- ``SpectrumFirstAgreement``
- ``SpectrumSecondAgreement``

### Interactions with a resident condition

Liquid LQ13 derives the boundary that an internal replacement must preserve.
The exchange uses a resident reserve and retains the actual partner. Three
equality contacts force the fourth corner, while the vacancy constructors
retain a relation that cannot be represented by shared equality alone.

- ``PairRecombination``
- ``ReversedCutAgreement``
- ``ResidentCutExchange``
- ``EqualityContactCut``
- ``ThreeContactsForceFourth``
- ``IndependentContactOrders``
- ``AdjacentSwapConjugation``
- ``FramePolarityFlip``
- ``LowerFrameFlip``
- ``PairedQuarterTurn``
- ``CrossedQuarterTurn``
- ``SameCommutatorDifferentSquares``
- ``ResidentContactExchange``
- ``RetainedPartnerForcesBoundary``
- ``FirstVacancy``
- ``SecondVacancy``
- ``ThirdVacancy``

LQ16 recovers two roles from exact self-contact and contextual substitution.
The pair constructors derive its field identities without a runtime. Keeping
both complementary outputs recovers the canonical resident sources. In the
vacancy relation one crossed output can be admitted while its complement is
forbidden; shared equality forces that complement from the other three contacts.

A partial swap is available where two source fields agree. The complete
image carries that same relation, while the visible pair can conflate an
available source with an unavailable one. The next step checks the condition
at its actual successor. VI VC46–VC49 give exact descent and the minimal
six-class image of the binary fragment.

- ``MatchedSwapOperation``
- ``MatchedSwapSource``
- ``MatchedSwapImage``
- ``MatchedSwapTransition``
- ``TwiceMatchedSwap``
- ``AlphaAfterMatchedSwap``
- ``ZeroSuccessorDistinction``
- ``BlockedAlpha``
- ``ReadyAlpha``
- ``InteractionClassQuestion``
- ``ReadySpectrumClass``
- ``ZeroBlockedSpectrumClass``
- ``SuccessorBlockedSpectrumClass``
- ``ReadyClassFactors``
- ``ZeroBlockedClassFactors``
- ``SuccessorBlockedClassFactors``
- ``ReadyClassReading``
- ``ZeroBlockedClassReading``
- ``SuccessorBlockedClassReading``
- ``RepeatReadyImage``
- ``ZeroToSuccessorImage``
- ``SuccessorToZeroImage``

### Knowledge through a minimal interaction image

A fact of the complete image supplies the minimal class and every certified
future question through existing evidence composition. Changing representation
before or after composing a path gives the same boundary readings. Adding the
total swap splits the old six classes into eight. The retained complete fact
can answer the newly exposed question. VI VC50–VC54 contain the arguments.

- ``RepeatSpectrumClassTransition``
- ``ZeroSuccessorSpectrumClassTransition``
- ``SuccessorZeroSpectrumClassTransition``
- ``RepeatClassTransition``
- ``ZeroSuccessorClassTransition``
- ``SuccessorZeroClassTransition``
- ``ReadyAlphaFactors``
- ``ZeroBlockedAlphaFactors``
- ``SuccessorBlockedAlphaFactors``
- ``AppendRepeatClass``

### An internal participant acquires a missing distinction

The old ready class already determines the complete source image. A blocked
class needs one beta reading, placed in a prepared slot beside the retained
source and old memory. The output supplies the new image and its future
questions. VC55–VC57 prove the acquisition and least refinement. M43–M44
separate accessible knowledge, whole entropy and the order of records.

- ``BetaQuestion``
- ``SpectrumBetaSource``
- ``ChannelOf``
- ``PreparedTraceExtension``
- ``RewindPreparedTrace``
- ``PreparedPredecessor``
- ``AnswerInReadyWhole``
- ``ReadyClassTrace``
- ``ZeroBlockedTrace``
- ``OneBlockedTrace``
- ``AcquireZeroBlockedBeta``
- ``AcquireOneBlockedBeta``
- ``ReadyObserverWhole``
- ``KeepReadyKnowledge``
- ``ReadyClassSpectrum``
- ``ReadyClassRecoversSpectrum``
- ``ReadySpectrumFromOldTrace``
- ``ZeroBlockedMemorySpectrum``
- ``OneBlockedMemorySpectrum``
- ``ZeroBlockedPreparedSpectrum``
- ``OneBlockedPreparedSpectrum``

### Resident resources and retained experimental answers

A decision reads the acquired class before selecting the declared channel.
An occupied workspace is prepared by moving its content to a resident slot.
The acquired fact then moves to another slot, leaving the instrument ready
and the answer accessible. VC58–VC59 and M45 separate this finite storage
account from entropy and from the retention of every historical occurrence.

- ``AcquisitionChoice``
- ``ChooseBlockedBeta``
- ``ChooseReadyReuse``
- ``SelectedTraceExtension``
- ``StepBeside``
- ``PrepareTraceFromResidentSlot``
- ``ParkAcquiredTrace``
- ``ResidentTraceMemory``
- ``AnswerFromResidentArchive``

### Recoverable construction with an admitted boundary

The retained predecessor contains context and two addressed operands. Its
record recovers the operand answer even when histories or local results
differ. A local result can merge inputs while the complete record separates
them. A diagonal family admits only equal operands. EiF EF8–EF9 distinguish
unique decomposition, constructor availability and fresh occurrence.

- ``RetainedConstruction``
- ``RecordedOperands``
- ``ConstructionRecoversOperands``
- ``SameBoundaryForcesOperands``
- ``RetainedOutputIdentifiesSource``
- ``DiagonalConstruction``

### A common answer determines its admissible boundary

A uniform verdict constructs a shared fact decoder. A shared decoder in
turn forces a verdict. Both actual sources remain in the retained record.
Ordered constructor obstructions certify incompatible answers. The binary
common-answer interface has three classes while its full records retain
the direction of disagreement. VI VC60–VC61 state the exact contracts.

- ``SharedFactFromVerdict``
- ``CommonFactConstruction``
- ``CommonFactFromSharedDecoder``
- ``CommonAnswerAcrossRealizations``
- ``ZeroSuccessorBoundary``
- ``SuccessorZeroBoundary``
- ``ZeroSuccessorBoundaryRecord``
- ``SuccessorZeroBoundaryRecord``
- ``ZeroSuccessorBoundaryImage``
- ``SuccessorZeroBoundaryImage``

### Acquire a common answer inside the whole

An established agreement between two applications on the same resident source
lets one acquired trace answer both. Preparation and archive access use the
existing resident relations. The first fact alone does not establish that
agreement on an unrestricted source family. VI VC62–VC63 separate these duties.

- ``BoundaryFirstAlpha``
- ``BoundarySecondAlpha``
- ``AnswerThroughAgreement``
- ``PreparedCommonTrace``
- ``CommonAnswerFromTrace``

### Establish agreement from acquired memory

The two component readings use initially resident slots. Their memory
decoders derive source agreement or a positive obstruction through the same
actual observation. Three classification images suffice for the common-answer
request while the full trace retains orientation. VI VC64–VC65 prove the
transfer and the exact second-reading requirement on the binary domain.

- ``AdvancePreparedTrace``
- ``AgreementFromMemory``
- ``ZeroSuccessorFromMemory``
- ``CommonBoundaryQuestion``
- ``AgreedMemoryBoundary``
- ``ZeroSuccessorMemoryBoundary``
- ``SuccessorZeroMemoryBoundary``

### Transport a boundary through an intervention

An acquired pair of answers determines a scoped future class through a
source-bound square. Side exchange preserves the three-class image. An
exchange with a resident zero separates the old failure orientations, while
the displaced answer remains available in the changed source. VI VC66–VC67
state the exact initial domain and distinguish it from repeated operation.

- ``JointEvidenceFromMemory``
- ``BoundaryPairReading``
- ``SwapBoundaryReading``
- ``SwapBoundaryTransition``
- ``KeepBoundaryUnderSwap``
- ``FirstFieldsOperation``
- ``ExchangedBoundaryFirst``
- ``ExchangeBoundaryFirst``
- ``BoundaryFirstZeroImage``
- ``BoundaryFirstZeroTransition``
- ``SecondEvidenceImage``
- ``AgreedBoundaryPairClass``
- ``ZeroSuccessorBoundaryPairClass``
- ``SuccessorZeroBoundaryPairClass``
- ``AgreedBoundarySwap``
- ``ZeroSuccessorBoundarySwap``
- ``SuccessorZeroBoundarySwap``

### Close the common-answer object under internal interactions

VC68–VC72 derive the coordinate and comparison-table updates, the exact
15/13 behavioral images, acquired future answers and a new internal
connection that forces 16/14 without changing the common question.
The source, command tape and retained evidence are internal components.
`Checks/BoundaryClosure.swift` checks the generic compositions, complete
binary table family, separating continuations and acquisition boundaries.

- ``BoundaryCoordinates``
- ``BoundaryCoordinatesQuestion``
- ``BoundaryTableQuestion``
- ``ExchangeFirstImage``
- ``BoundaryCoordinatesExchange``
- ``BoundaryCoordinatesSwap``
- ``BoundaryTable``
- ``ExchangeTableRows``
- ``TransposeBoundaryTable``
- ``ReverseBoundaryComparison``
- ``BoundaryTableExchange``
- ``BoundaryTableSwap``
- ``ReadBoundaryTable``
- ``ResidentBoundaryCommand``
- ``RecordedBoundaryCommand``
- ``CrossBoundaryOperation``
- ``CrossBoundaryReading``
- ``CrossBoundaryImage``
- ``BoundaryCoordinatesCross``
- ``BoundaryBeam``
- ``BoundaryWorking``
- ``Boundary00``
- ``Boundary01``
- ``Boundary10``
- ``Boundary11``
- ``Boundary0000``
- ``Boundary0001``
- ``Boundary0010``
- ``Boundary0011``
- ``Boundary0100``
- ``Boundary0101``
- ``Boundary0110``
- ``Boundary0111``
- ``Boundary1000``
- ``Boundary1001``
- ``Boundary1010``
- ``Boundary1011``
- ``Boundary1100``
- ``Boundary1101``
- ``Boundary1110``
- ``Boundary1111``
- ``BoundaryReverse00``
- ``BoundaryReverse01``
- ``BoundaryReverse10``
- ``BoundaryReverse11``
- ``BoundaryFirstBeta``
- ``BoundarySecondBeta``
- ``AcquiredBoundaryCoordinates``
- ``IdentityCoordinateImage``
- ``PreparedBoundaryCoordinatesImage``
- ``PreparedBoundaryCoordinatesFromAlpha``

### Acquire a law from a prepared probe

VC73 factors the E/K law through one common output question. The acquired
fact contains the response without the mechanism's tag. Preparation, the
admitted law family and the actual application remain explicit premises.

- ``MechanismOutputQuestion``
- ``MechanismLawQuestion``
- ``MechanismOutput``
- ``MechanismLaw``
- ``ExchangeFromZeroProbe``
- ``CrossFromOneProbe``
- ``ExchangeLawFromProbe``
- ``CrossLawFromProbe``
- ``AcquiredExchangeLaw``
- ``AcquiredCrossLaw``
- ``PreparedMechanismProbe``
- ``ExchangeLawFromTrace``
- ``CrossLawFromTrace``

### Recover four-address routing from two probe images

VC74 derives routing coordinates from two complete, addressed binary images.
The generic decoder also covers repeated address selections. Fixed routing
across probes is required. A changing internal schedule can mimic a valid
permutation's record. Reconstruction does not identify the whole mechanism.

- ``RoutingQuestion``
- ``FirstRoutingProbeQuestion``
- ``SecondRoutingProbeQuestion``
- ``RoutingCoordinates``
- ``FirstRoutingProbe``
- ``SecondRoutingProbe``
- ``RoutingProbeImages``
- ``RoutingFromProbeImages``
- ``RoutingFromProbes``
- ``AcquiredRouting``
- ``RoutingAddress00``
- ``RoutingAddress01``
- ``RoutingAddress10``
- ``RoutingAddress11``
- ``IdentityRouting``
- ``RoutingProbeP``
- ``RoutingProbeQ``
- ``SelectionCalibration00``
- ``SelectionCalibration01``
- ``SelectionCalibration10``
- ``SelectionCalibration11``
- ``CalibratedRoutingBasis``

### Reuse routing with read input data

VC75 transports a factorization beside an explicitly supplied input. Four
address clauses select arbitrary data values from acquired routing evidence.
The decoder receives both the law record and data, and can supply the existing
common-answer table at its actual new input.

- ``SuppliedInputQuestion``
- ``RoutedValueQuestion``
- ``RoutedOutputQuestion``
- ``ReadingBesideInput``
- ``EvidenceBesideInput``
- ``Route00``
- ``Route01``
- ``Route10``
- ``Route11``
- ``RoutingApplication``
- ``RoutingApplicationFromProbes``
- ``RoutingMemoryBesideInput``

### Acquire two probe records inside one prepared whole

VC76 retains one source and both instruments through acquisition, internal
focus exchange and acquisition. The two records supply routing and reuse.
M48 counts conditional law uncertainty under explicit finite preparations.

- ``FollowedPair``
- ``ExchangeResidentInstruments``
- ``TwoResidentReadings``
- ``ResidentProbeFacts``
- ``TwoRecordedAnswers``
- ``ObserveTwoResidentFacts``
- ``TwoResidentAnswers``
- ``AnswerInResidentProbePair``

### Transport acquired law through an internal mechanism change

VC77 derives law preservation while internal module state changes. A source
pullback preserves the decoder, and a commuting square carries its evidence
to a new application. Replacing the routing itself from a resident reserve
provides the contrasting future-law boundary counted by M49.

- ``FactorOnSource``
- ``RoutingModule``
- ``ResidentRoutingSource``
- ``ResidentRoutingFactors``
- ``ModuleStateExchangeOperation``
- ``ExchangeModuleState``
- ``KeepRoutingOnModuleExchange``
- ``RoutingModuleExchange``
- ``TransitionBesideInput``
- ``RoutingReserveExchangeOperation``
- ``ExchangeRoutingWithReserve``

### Derive the input demand of an acquired routing

VC78 factors the repeated-first application through its law record and one
input coordinate. Unused values and branch structure disappear from the
decoder. The restricted observation fails for the identity route.

- ``PairedSourceReadings``
- ``FirstDataCoordinateQuestion``
- ``FirstDataCoordinate``
- ``RepeatedFirstRouting``
- ``RepeatFromFirstRecord``
- ``RepeatedFirstFromObservation``

### Identify routing through an internal output frame

VC79 derives equal probe records when an exchange moves between the module
routing and the instrument's output connection. The composite remains
predictable while its decomposition requires a calibration relation.

- ``DirectOutputFrame``
- ``CrossedOutputFrame``
- ``ProbeThroughDirectFrame``
- ``ProbeThroughCrossedFrame``
- ``RoutingFrameAgreement``

### Objects and action paths

A source step and an image step agree by a commuting square. A generic join
composes two certified squares, and an identity supplies the empty path. Swap,
hidden erasure and a second swap return the original image while losing a
source coordinate. The exact action-domain condition is VI VC46. VC54 shows
how an added action splits the previously sufficient operational objects.

- ``OperationSequence``
- ``TwoMacroExpansion``
- ``PostPairReading``
- ``PostPairAgreement``
- ``SequentialReading``
- ``JoinedTransition``
- ``ReobservedTransition``
- ``IdentityTransition``
- ``SwapTransition``
- ``ForgetTransition``
- ``AppendSwap``
- ``QuestionAlongTransition``
- ``FutureOnEvidence``
- ``ExposeHiddenAsBeta``

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

IceVertex requires two In and two Out slots. Induction on the finite constructor grammar and choosing two of four positions gives exactly the six listed local words. Matter §5 separately characterizes global configurations by agreement on shared edges and states which probability law turns their count into entropy. IceOxygen's interface does not derive a unique physical ground state.

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

Broken adds one slot to a supplied count, and Electroweak supplies three. Matter §5 separately proves the unique norm at the minimum of the stated scalar potential and shows that each nonzero norm labels one pointwise doublet orbit under SU(2). HiggsGaugeInvariant's interface does not derive those facts or determine the complete gauge-field configuration. The three broken directions are not three additional physical massless scalar particles.

- ``HiggsGaugeInvariant``
- ``HiggsFieldComponents``
- ``BrokenSymmetry``
- ``Unbroken``
- ``Broken``
- ``ThreeGoldstones``
- ``Counted``

### Quantum measurement — degeneracy

For the ideal Lüders update on an unrestricted input domain, a nonzero projector gives the same conditional output for every admitted input exactly when it has rank one. Matter §5 proves this and distinguishes the resulting ray from the pre-measurement state. One certain outcome does not suffice: the identity projector leaves every input unchanged. Quantum.swift checks supplied dimension expressions. Dimension g counts basis directions, not all state rays.

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

### Dynamics — the worlds a button can move

The terms allowed in a state file's slots: the lamp's two faces, the counter's floor and wrap, the keypad's five stages. A slot marker drops its `Slot` suffix to name the alias a state file declares. The rules that move a world between these terms are rewrite triples beside the world itself (`Sources/DynamicsDemo/Rules.swift`) on the dynamics medium (`DocumentKit`), and pressing one is `swift run Tools press <Rule>`: compare, substitute, or stand.

- ``LampModeSlot``
- ``LampOff``
- ``LampOn``
- ``Counting``
- ``CountSlot``
- ``Tick``
- ``PinProgressSlot``
- ``PinStage0``
- ``PinStage1``
- ``PinStage2``
- ``PinStage3``
- ``PinUnlocked``

### One lattice, many domains

The following declarations share the SystemCrystallizes interface, allowing a generic construction to use its equations. This does not establish identical physical dynamics across their intended domains. Chosen SolutionSet coordinates do not certify candidate counts. Matter §5 separates the physical obligations, while V=I U2–U2b supplies actual support and constraint-derived identification constructions.

- ``CrystallizingDomain``
- ``IceCrystal``
- ``HiggsCrystal``
- ``QuantumCrystal``
- ``FormCrystal``
- ``PackingUnderCost``
- ``PackingUnderContent``

### The grant world — the domain genre on one page

Access over declared realms: a realm is an atom (the fourth is one line, not a schema change), a verb set is a protocol class whose containment is conformance, and one gate carries two tiers at once. The compiler decides the key's class, and the second judge decides the posting equality from the world's own declarations.

- ``Reads``
- ``Writes``
- ``Administers``
- ``ReaderKey``
- ``WriterKey``
- ``WardenKey``
- ``Realm``
- ``Archive``
- ``Foundry``
- ``Harbor``
- ``Keeper``
- ``Room``
- ``Ledger``
- ``Anvil``
- ``Clerk``
- ``Scribe``
- ``Smith``
- ``Warden``
- ``Entered``
- ``Enter``
- ``SmithAtTheAnvil``
- ``ScribeAtTheLedger``

### The Rydberg ladder — energy as a judged integer lattice

Hydrogen's energy, recorded as one number per floor (144/n² in units of R/144) and judged as a lattice: every jump's drop is held to its two floors, and the two roads down from the fourth floor are one drop. The arithmetic equalities are judged by the second judge's counting canon (`swift run Tools judge where`), the ladder spelling is proved by the compiler itself, and the numerals are the lattice's own ladder, read from `VerificationIsIdentification`.

- ``FloorOneDepth``
- ``FloorTwoDepth``
- ``FloorThreeDepth``
- ``FloorFourDepth``
- ``PaschenAlphaDrop``
- ``BalmerAlphaDrop``
- ``BalmerBetaDrop``
- ``LymanAlphaDrop``
- ``EnergyClosed``
- ``EnergySum``
- ``FloorThreeByLadder``
- ``LadderStitched``
- ``LadderStep``

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

These ordinary Swift witnesses give concrete models beside the pure type relations.

- ``Cell``
- ``Succ``
- ``Grew``
- ``Shrank``
- ``Path``
- ``Measured``
- ``Verdict``
- ``ConcreteAgent``

### The closed whole

- ``ReadyLawState``
- ``RecordedLawState``
- ``ReadPreparedLawSource``
- ``ExtendLawRecord``
- ``RetainedWhole``
- ``RecordedSwapReturn``
- ``RetainedOccurrenceContrast``
- ``MutualRecordUpdate``
- ``ConstantResetQuestion``
- ``ConstantResetReading``
- ``DuplicateParityOperation``
- ``EqualPairParity``
- ``ZeroOneParity``
- ``OneZeroParity``
- ``ReadingWithResidentLaw``
- ``EarlierFirstQuestion``
- ``EarlierSecondQuestion``
- ``EarlierFirstThroughSwap``
- ``EarlierSecondThroughSwap``
- ``EarlierPairThroughSwap``
- ``SelfRetainingRecord``
- ``StationaryRetention``
- ``InternalSwap``
- ``RotateThree``
- ``ExposeNext``
- ``RewindExposure``
- ``BeamWithResidual``
- ``SwapWindow``
- ``GluedEqualities``
- ``AnswerWithItsEvidence``
- ``SpendSuccessor``
- ``ZeroInputClaimTail``
- ``AppendedCacheReading``
- ``CacheByAppending``

### Discovering an initial state

- ``ExperimentQuiet``
- ``ExperimentSignal``
- ``TrapExperiment``
- ``ReversibleExperiment``
- ``TwoQuestionTrace``
- ``RecordedFirstQuestion``
- ``AdvanceQuestionTag``
- ``RecordedControllerStep``
- ``PreparedObservation``

### Learning a declared law

- ``ConstantTable``
- ``SecondTableQuestion``
- ``FirstTableQuestion``
- ``FirstTableReading``
- ``SecondTableReading``
- ``PredictionsFromConstantTables``
- ``SyntheticConstantRecord``
- ``DiagonalReadings``

### Acquisition and reuse without runtime

The question, record, refinement and repeated answer are type relations. The compiler derives the consequences and rejects the broken premises in `Checks/Acquisition.swift`.

- ``AnswerFact``
- ``RecordReading``
- ``AcquireAnswer``
- ``QuestionOnObservation``
- ``AnswerFromAcquiredObservation``
- ``RefineAnswer``
- ``JointEvidenceRetainsFirst``
- ``ConstantSecondFactors``
- ``StartObservations``
- ``AppendObservation``
- ``TraceEvidenceIn``
- ``TraceEvidence``
- ``LastAnswerFromTrace``
- ``ConstantSecondFromTrace``
- ``AnswerInTrace``
- ``RetainTraceAnswer``

### When existing knowledge is sufficient

One resident acquisition chain separates memory reuse, a required new reading and closure under mixed coordinate exchanges. See `Checks/KnowledgeClosure.swift`.

- <doc:KnowledgeClosure>

- ``HiddenCoordinateQuestion``
- ``HiddenCoordinateReading``
- ``FocusThirdInstrument``
- ``ThreeResidentReadings``
- ``ResidentThreeFacts``
- ``KnowledgeAcquisition``
- ``KnowledgeOldObservation``
- ``KnowledgeObservation``
- ``KnowledgeCoordinates``
- ``KnowledgeFromThree``
- ``KnowledgeOldFacts``
- ``KnowledgeRetainsOld``
- ``KnowledgeCurrent``
- ``KnowledgeSwapDecoder``
- ``KnowledgeSwapFromTwo``
- ``KnowledgeMixedPath``
- ``KnowledgeMixedQuestion``
- ``KnowledgeMixedFromThree``
- ``FocusKnowledgeCommand``
- ``KnowledgeResidentRun``

### Data determines sufficient law evidence

- ``FirstSelectionProbe``
- ``SelectionWithResidentProbe``
- ``RowRepeatedData``
- ``SelectionProbeMemory``
- ``FirstRowFromRecord``
- ``SecondRowFromRecord``
- ``RowSelection00``
- ``RowSelection01``
- ``RowSelection10``
- ``RowSelection11``
- ``ConstantSelectionEvidence``
- ``ConstantSelectionAnswer``
- ``ExchangeSelectionReserve``
- ``SelectionAfterReserveChange``
- ``SelectionChangeDecoder``
- ``RowLawChangePreservesAnswer``
- ``ExchangeObservedSelection``
- ``ScopedLawResidentRun``

### Relational return forces an answer

- ``SwapReturnForcesAgreement``
- ``DiagonalSwapReturn``
- ``SwapReturnBoundary``
- ``IdentityPairReturn``
- ``DoubleSwapReturn``
- ``ResidentTransportContact``
- ``ThreePhaseContactsForceCollapse``

### Relative agreement without absolute frame calibration

- ``PairRelationQuestion``
- ``SharedDirectPairFrame``
- ``SharedCrossedPairFrame``
- ``SharedFrameAgreement``
- ``MixedPairFrame``
- ``ReversedMixedPairFrame``
- ``SecondPairReaddressing``
- ``RelativeFrameQuestion``
- ``RelativeProbeBit``
- ``FrameConnectionExchange``
- ``ExchangeFrameConnections``
- ``CommonFirstFrameSource``
- ``SharedFrameFactDecoder``
- ``MixedFrameFactDecoder``
- ``MixedFrameReplayAfterExchange``
- ``ReaddressSecondPair``
- ``MixedFrameCorrection``
- ``ReversedMixedFrameCorrection``
