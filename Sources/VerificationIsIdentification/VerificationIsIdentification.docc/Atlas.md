# Atlas

The Atlas is one table with one row per claim of the theory: the claim's
premises, and the count of claims that depend on it. The table is
generated from the compiler's dependency record.

Five companion pages read the same lattice, each for one question:

- <doc:AtlasOrder> puts every claim after its premises: the reading order.
- <doc:AtlasAblation> records which premises the core build enforces.
- <doc:AtlasRepeats> counts premises declared twice.
- <doc:AtlasArgued> ties each argued edge to the paragraph that argues it.
- <doc:AtlasUnfolded> expands every Carries count into its list.

Each claim is one Swift protocol. A premise is a protocol the claim
refines, so the compiler already has the full dependency graph, and this
page prints it. **Premises** lists the direct parents. **Carries** counts
the claims that depend on this one, directly or through others: the
claim's cone in the graph. **Kind** is computed from the row's position,
not assigned: a *seed* is one of the two base primitives, an *axis* opens
a coordinate, a *bridge* joins two or more axes, a *marker* names a
property used as a constraint, a *kernel* is machinery between the seed
and the axes.

The table is checked two ways. Remove a claim's declaration and the
module fails to build. And tree-sort check recounts every cone in both
directions, down the children and up the parents, on every run: when the
two counts differ, the check fails and the page is not reported.
<doc:AtlasAblation> tests the premises one at a time: each is cut from
its line, the core module is rebuilt, and the result is recorded.

Carries measures structure, not importance. It is the number of
dependents in the type graph. A claim with a small cone can be central
to a paper's argument, and that judgement is made in the papers, not by
this number.

A cycle between claims cannot exist here: a circular protocol hierarchy
does not compile. Acyclicity is built into the language.

## The load, heaviest first

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``/Notation/Structure`` | marker | — | [172](<doc:AtlasUnfolded#Structure>) | Primitive |
| ``/Notation/Open`` | kernel | ``/Notation/Structure`` | [170](<doc:AtlasUnfolded#Open>) | Primitive |
| ``/Notation/Pair`` | seed | ``/Notation/Open`` | [168](<doc:AtlasUnfolded#Pair>) | Primitive |
| ``HasSigma`` | axis | — | [165](<doc:AtlasUnfolded#HasSigma>) | Core |
| ``StructuresFinite`` | kernel | ``/Notation/Pair``, ``HasSigma`` | [111](<doc:AtlasUnfolded#StructuresFinite>) | Identification |
| ``OperationsClosed`` | kernel | ``/Notation/Pair`` | [94](<doc:AtlasUnfolded#OperationsClosed>) | Identification |
| ``HasCache`` | axis | ``HasSigma`` | [84](<doc:AtlasUnfolded#HasCache>) | Core |
| ``CachePermanent`` | theorem | ``HasCache``, ``OperationsClosed``, ``StructuresFinite`` | [80](<doc:AtlasUnfolded#CachePermanent>) | Identification |
| ``HasDistance`` | axis | ``HasSigma`` | [73](<doc:AtlasUnfolded#HasDistance>) | Core |
| ``HasLibrary`` | axis | ``HasSigma`` | [66](<doc:AtlasUnfolded#HasLibrary>) | Core |
| ``HasSolutions`` | axis | ``HasSigma`` | [65](<doc:AtlasUnfolded#HasSolutions>) | Core |
| ``ResultDeterministic`` | kernel | ``OperationsClosed`` | [64](<doc:AtlasUnfolded#ResultDeterministic>) | Identification |
| ``DistanceOnStructures`` | theorem | ``HasDistance``, ``StructuresFinite`` | [56](<doc:AtlasUnfolded#DistanceOnStructures>) | Gradient |
| ``StepsTerminate`` | kernel | ``StructuresFinite`` | [53](<doc:AtlasUnfolded#StepsTerminate>) | Identification |
| ``PipelineTotal`` | kernel | ``StepsTerminate`` | [51](<doc:AtlasUnfolded#PipelineTotal>) | Identification |
| ``EqualityDecidable`` | kernel | ``StructuresFinite`` | [50](<doc:AtlasUnfolded#EqualityDecidable>) | Identification |
| ``PassImpliesMembership`` | kernel | ``PipelineTotal``, ``ResultDeterministic`` | [50](<doc:AtlasUnfolded#PassImpliesMembership>) | Identification |
| ``KnowledgeAccumulates`` | bridge | ``CachePermanent``, ``HasLibrary`` | [45](<doc:AtlasUnfolded#KnowledgeAccumulates>) | Intelligence |
| ``ExactlyOneSurvives`` | theorem | ``EqualityDecidable``, ``HasSolutions`` | [41](<doc:AtlasUnfolded#ExactlyOneSurvives>) | Identification |
| ``HasSaturation`` | axis | ``HasLibrary`` | [39](<doc:AtlasUnfolded#HasSaturation>) | Core |
| ``Decidable`` | marker | ``/Notation/Pair`` | [38](<doc:AtlasUnfolded#Decidable>) | Core |
| ``LibrarySaturates`` | bridge | ``CachePermanent``, ``HasSaturation`` | [38](<doc:AtlasUnfolded#LibrarySaturates>) | Intelligence |
| ``HasEncoding`` | axis | ``HasSigma`` | [37](<doc:AtlasUnfolded#HasEncoding>) | Core |
| ``PassIsIdentification`` | theorem | ``ExactlyOneSurvives``, ``PassImpliesMembership`` | [36](<doc:AtlasUnfolded#PassIsIdentification>) | Identification |
| ``/Notation/Null`` | seed | ``/Notation/Pair`` | [31](<doc:AtlasUnfolded#Null>) | Primitive |
| ``Resistant`` | theorem | ``Decidable``, ``HasDistance`` | [28](<doc:AtlasUnfolded#Resistant>) | Matter |
| ``IdentityCollapse`` | theorem | ``/Notation/Null``, ``HasSolutions`` | [27](<doc:AtlasUnfolded#IdentityCollapse>) | Core |
| ``AxesCoOriented`` | theorem | ``CachePermanent``, ``ResultDeterministic`` | [26](<doc:AtlasUnfolded#AxesCoOriented>) | Identification |
| ``Matter`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification``, ``Resistant`` | [26](<doc:AtlasUnfolded#Matter>) | Matter |
| ``OrderIsOnlyFreedom`` | bridge | ``AxesCoOriented``, ``IdentityCollapse`` | [25](<doc:AtlasUnfolded#OrderIsOnlyFreedom>) | Identification |
| ``HasTime`` | axis | ``HasSigma`` | [24](<doc:AtlasUnfolded#HasTime>) | Matter |
| ``AnchorGraph`` | bridge | ``DistanceOnStructures``, ``HasLibrary`` | [22](<doc:AtlasUnfolded#AnchorGraph>) | Map |
| ``Ignites`` | bridge | ``LibrarySaturates``, ``Matter`` | [22](<doc:AtlasUnfolded#Ignites>) | Matter |
| ``HasCost`` | axis | ``HasSigma`` | [20](<doc:AtlasUnfolded#HasCost>) | Matter |
| ``HasVerdict`` | axis | ``HasEncoding`` | [19](<doc:AtlasUnfolded#HasVerdict>) | Verdict |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``BallSaturation`` | bridge | ``DistanceOnStructures``, ``LibrarySaturates`` | [15](<doc:AtlasUnfolded#BallSaturation>) | Gradient |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``ComparedReadings`` | marker | ``/Notation/Pair`` | [13](<doc:AtlasUnfolded#ComparedReadings>) | Verdict |
| ``GateIsZeroOfLoss`` | theorem | ``DistanceOnStructures``, ``PassImpliesMembership`` | [12](<doc:AtlasUnfolded#GateIsZeroOfLoss>) | Gradient |
| ``HasAlpha`` | axis | ``HasDistance`` | [12](<doc:AtlasUnfolded#HasAlpha>) | Core |
| ``HasPath`` | axis | ``HasSigma`` | [12](<doc:AtlasUnfolded#HasPath>) | Path |
| ``StrategyLivesInSigma`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | [12](<doc:AtlasUnfolded#StrategyLivesInSigma>) | Strategy |
| ``AlignmentCoefficient`` | bridge | ``GateIsZeroOfLoss``, ``HasAlpha`` | [11](<doc:AtlasUnfolded#AlignmentCoefficient>) | Search |
| ``HasLaw`` | axis | ``HasSigma`` | [11](<doc:AtlasUnfolded#HasLaw>) | Dynamics |
| ``NoInverse`` | bridge | ``KnowledgeAccumulates`` | [11](<doc:AtlasUnfolded#NoInverse>) | Matter |
| ``VerdictIsInvariant`` | bridge | ``ComparedReadings``, ``HasVerdict`` | [11](<doc:AtlasUnfolded#VerdictIsInvariant>) | Verdict |
| ``HasBasis`` | axis | ``HasLibrary`` | [10](<doc:AtlasUnfolded#HasBasis>) | Core |
| ``LawLivesInSigma`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [10](<doc:AtlasUnfolded#LawLivesInSigma>) | Dynamics |
| ``Monotone`` | marker | ``/Notation/Pair`` | [10](<doc:AtlasUnfolded#Monotone>) | Core |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``HolesCarryAddresses`` | bridge | ``AnchorGraph``, ``Decidable`` | [9](<doc:AtlasUnfolded#HolesCarryAddresses>) | Map |
| ``BasisIsFinite`` | bridge | ``HasBasis``, ``LibrarySaturates`` | [7](<doc:AtlasUnfolded#BasisIsFinite>) | Intelligence |
| ``CandidatesOnlyLeave`` | bridge | ``CachePermanent``, ``HasSolutions`` | [7](<doc:AtlasUnfolded#CandidatesOnlyLeave>) | Identification |
| ``LiquidPhase`` | bridge | ``KnowledgeAccumulates``, ``Monotone`` | [7](<doc:AtlasUnfolded#LiquidPhase>) | Liquid |
| ``Measurable`` | marker | ``/Notation/Pair`` | [7](<doc:AtlasUnfolded#Measurable>) | Core |
| ``MembershipDecidable`` | theorem | ``EqualityDecidable``, ``HasSolutions`` | [7](<doc:AtlasUnfolded#MembershipDecidable>) | Intelligence |
| ``ResultsIrreversible`` | theorem | ``CachePermanent``, ``EqualityDecidable`` | [7](<doc:AtlasUnfolded#ResultsIrreversible>) | Intelligence |
| ``CertifiedRuleGenerates`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification`` | [6](<doc:AtlasUnfolded#CertifiedRuleGenerates>) | Play |
| ``PredicateReading`` | bridge | ``/Notation/Pair``, ``HasVerdict`` | [6](<doc:AtlasUnfolded#PredicateReading>) | Verdict |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``SystemCrystallizes`` | bridge | ``CandidatesOnlyLeave``, ``MembershipDecidable``, ``ResultsIrreversible`` | [6](<doc:AtlasUnfolded#SystemCrystallizes>) | Intelligence |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``CrystallizationFront`` | bridge | ``DistanceOnStructures``, ``LiquidPhase``, ``NoInverse`` | [5](<doc:AtlasUnfolded#CrystallizationFront>) | Liquid |
| ``DiscriminatorAndGenerator`` | bridge | ``OrderIsOnlyFreedom``, ``PassImpliesMembership`` | [5](<doc:AtlasUnfolded#DiscriminatorAndGenerator>) | Generation |
| ``EmissionAccumulates`` | theorem | ``HasPath`` | [5](<doc:AtlasUnfolded#EmissionAccumulates>) | Path |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
| ``ReadingFactors`` | bridge | ``VerdictIsInvariant`` | [5](<doc:AtlasUnfolded#ReadingFactors>) | Verdict |
| ``RevealsNotCreates`` | kernel | ``Measurable``, ``OperationsClosed`` | [5](<doc:AtlasUnfolded#RevealsNotCreates>) | Identification |
| ``ScopeBoundedByEncoding`` | kernel | ``ResultDeterministic`` | [5](<doc:AtlasUnfolded#ScopeBoundedByEncoding>) | Identification |
| ``SearchFlow`` | bridge | ``AlignmentCoefficient``, ``LiquidPhase`` | [5](<doc:AtlasUnfolded#SearchFlow>) | Liquid |
| ``HasCandidates`` | axis | ``HasSigma`` | [4](<doc:AtlasUnfolded#HasCandidates>) | Verdict |
| ``HasEfficiency`` | axis | ``HasSigma`` | [4](<doc:AtlasUnfolded#HasEfficiency>) | Intelligence |
| ``HasGauge`` | axis | ``HasSigma`` | [4](<doc:AtlasUnfolded#HasGauge>) | Gauge |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``StefanCoupling`` | bridge | ``CrystallizationFront``, ``SearchFlow`` | [4](<doc:AtlasUnfolded#StefanCoupling>) | Liquid |
| ``StrategyGate`` | bridge | ``PassImpliesMembership``, ``StrategyLivesInSigma`` | [4](<doc:AtlasUnfolded#StrategyGate>) | Strategy |
| ``ComparisonsAreBounded`` | kernel | ``StructuresFinite`` | [3](<doc:AtlasUnfolded#ComparisonsAreBounded>) | Identification |
| ``GateIsMembrane`` | bridge | ``StefanCoupling`` | [3](<doc:AtlasUnfolded#GateIsMembrane>) | Liquid |
| ``IntelligenceRises`` | bridge | ``HasEfficiency``, ``LibrarySaturates`` | [3](<doc:AtlasUnfolded#IntelligenceRises>) | Intelligence |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``StrategyIsUnique`` | bridge | ``ExactlyOneSurvives``, ``StrategyGate`` | [3](<doc:AtlasUnfolded#StrategyIsUnique>) | Strategy |
| ``CandidateReading`` | bridge | ``HasCandidates``, ``PredicateReading`` | [2](<doc:AtlasUnfolded#CandidateReading>) | Verdict |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``EncodingForgets`` | bridge | ``VerdictIsInvariant`` | [2](<doc:AtlasUnfolded#EncodingForgets>) | Seeing |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``HasCompositionalNorm`` | axis | ``HasDistance`` | [2](<doc:AtlasUnfolded#HasCompositionalNorm>) | Basis |
| ``HasGrammar`` | axis | ``HasEncoding`` | [2](<doc:AtlasUnfolded#HasGrammar>) | Space |
| ``ObservationTrace`` | marker | ``/Notation/Pair`` | [2](<doc:AtlasUnfolded#ObservationTrace>) | Verdict |
| ``ObservedTransition`` | theorem | ``/Notation/Pair``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#ObservedTransition>) | Transition |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``Reading`` | bridge | ``HasTime``, ``OrderIsOnlyFreedom``, ``RevealsNotCreates`` | [2](<doc:AtlasUnfolded#Reading>) | Reading |
| ``RulesCompose`` | bridge | ``KnowledgeAccumulates`` | [2](<doc:AtlasUnfolded#RulesCompose>) | Basis |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``AmbiguityIsExperiment`` | bridge | ``HolesCarryAddresses``, ``LawIsTarget`` | [1](<doc:AtlasUnfolded#AmbiguityIsExperiment>) | Dynamics |
| ``AtomBasis`` | bridge | ``BasisIsFinite``, ``HasCompositionalNorm``, ``RulesCompose`` | [1](<doc:AtlasUnfolded#AtomBasis>) | Basis |
| ``BehaviorIsStructure`` | bridge | ``DistanceOnStructures``, ``HasTime`` | [1](<doc:AtlasUnfolded#BehaviorIsStructure>) | Dynamics |
| ``CommutingTransition`` | theorem | ``ObservedTransition`` | [1](<doc:AtlasUnfolded#CommutingTransition>) | Transition |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``ContentIsGaugeInvariant`` | bridge | ``HasGauge``, ``ReadingFactors`` | [1](<doc:AtlasUnfolded#ContentIsGaugeInvariant>) | Gauge |
| ``CostIsPathLength`` | bridge | ``HasDistance``, ``HasPath`` | [1](<doc:AtlasUnfolded#CostIsPathLength>) | Path |
| ``CostReadsGauge`` | bridge | ``HasDistance``, ``HasGauge``, ``PredicateReading`` | [1](<doc:AtlasUnfolded#CostReadsGauge>) | Gauge |
| ``DistanceIsMetric`` | bridge | ``HasCache``, ``HasDistance`` | [1](<doc:AtlasUnfolded#DistanceIsMetric>) | Space |
| ``EmissionIsAutoregressive`` | bridge | ``HasEncoding``, ``HasPath``, ``ScopeBoundedByEncoding`` | [1](<doc:AtlasUnfolded#EmissionIsAutoregressive>) | Path |
| ``EvidenceRefinesQuestion`` | kernel | ``/Notation/Pair`` | [1](<doc:AtlasUnfolded#EvidenceRefinesQuestion>) | Verdict |
| ``GatedConstruction`` | bridge | ``EmissionAccumulates``, ``SystemCrystallizes`` | [1](<doc:AtlasUnfolded#GatedConstruction>) | Path |
| ``HasStrategy`` | axis | ``HasSigma`` | [1](<doc:AtlasUnfolded#HasStrategy>) | Level |
| ``/Notation/IntegerValued`` | marker | ``/Notation/Pair`` | [1](<doc:AtlasUnfolded#IntegerValued>) | IntegerValued |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``Permanent`` | marker | ``/Notation/Pair`` | [1](<doc:AtlasUnfolded#Permanent>) | Core |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``ReachIsPath`` | bridge | ``HasBasis``, ``HasPath`` | [1](<doc:AtlasUnfolded#ReachIsPath>) | Path |
| ``RepairsPermanent`` | bridge | ``AnchorGraph``, ``NoInverse`` | [1](<doc:AtlasUnfolded#RepairsPermanent>) | Map |
| ``StandardIsType`` | bridge | ``LawLivesInSigma`` | [1](<doc:AtlasUnfolded#StandardIsType>) | Ruler |
| ``AcquiresAnswer`` | bridge | ``ReadingFactors`` | 0 | Verdict |
| ``AdequateResidueContinuation`` | bridge | ``VerdictIsInvariant`` | 0 | Acquisition |
| ``AgentPathCertified`` | theorem | ``IdentityCollapse``, ``PassIsIdentification`` | 0 | Intelligence |
| ``AlignmentEnablesIntelligence`` | bridge | ``AlignmentCoefficient``, ``IntelligenceRises`` | 0 | Search |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``AtomnessIsTrajectory`` | bridge | ``AtomBasis``, ``NoInverse`` | 0 | Basis |
| ``CacheOnlyGrows`` | theorem | ``CachePermanent``, ``StepsTerminate`` | 0 | Identification |
| ``CandidateGroupReading`` | bridge | ``CandidateReading`` | 0 | Verdict |
| ``CandidateLeafReading`` | bridge | ``CandidateReading`` | 0 | Verdict |
| ``CheckedSpellingAdmission`` | bridge | ``ReadingFactors`` | 0 | Permission |
| ``/Notation/Close`` | kernel | ``/Notation/Structure`` | 0 | Primitive |
| ``ColourIsQuotient`` | bridge | ``EncodingForgets`` | 0 | Colour |
| ``CommunicationBounded`` | theorem | ``ComparisonsAreBounded``, ``HasCache`` | 0 | Space |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``CompletionIsSolutionSet`` | bridge | ``HasPath``, ``Reading`` | 0 | Path |
| ``ConservedReadingStep`` | theorem | ``CommutingTransition`` | 0 | Halt |
| ``ConstructionIsReading`` | bridge | ``EmissionAccumulates``, ``Reading`` | 0 | Path |
| ``Converges`` | bridge | ``NoInverse``, ``SystemCrystallizes`` | 0 | Matter |
| ``CoverageMatchesDeclaration`` | kernel | ``/Notation/Pair`` | 0 | Verdict |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``/Notation/Digit`` | kernel | ``/Notation/Open`` | 0 | Numeral |
| ``DiscoveryIsRevelation`` | bridge | ``ExactlyOneSurvives``, ``LibrarySaturates`` | 0 | Intelligence |
| ``DistanceIsCost`` | bridge | ``DistanceOnStructures``, ``HasCost`` | 0 | Gradient |
| ``EdgesCarryTheJudgement`` | bridge | ``BehaviorIsStructure``, ``LawLivesInSigma`` | 0 | Presentation |
| ``EmptyObservationTrace`` | kernel | ``ObservationTrace`` | 0 | Verdict |
| ``EncodingInvents`` | theorem | ``ComparedReadings``, ``HasEncoding`` | 0 | Voice |
| ``EncodingSelectionSaturates`` | bridge | ``HasEncoding``, ``LibrarySaturates`` | 0 | Intelligence |
| ``ErasureIsRecession`` | bridge | ``EmissionAccumulates``, ``NoInverse`` | 0 | Path |
| ``ExtendedObservationTrace`` | kernel | ``ObservationTrace`` | 0 | Verdict |
| ``FailureCurriculum`` | bridge | ``HolesCarryAddresses``, ``RepairsPermanent`` | 0 | Map |
| ``FaithfulEncoding`` | bridge | ``ReadingFactors`` | 0 | Voice |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``FormIsInvariant`` | bridge | ``LawLivesInSigma`` | 0 | Presentation |
| ``FreeGeneration`` | bridge | ``DiscriminatorAndGenerator``, ``EmissionAccumulates`` | 0 | Path |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``CostIsPathLength`` | 0 | Gauge |
| ``GaugeFixing`` | bridge | ``CostReadsGauge``, ``SystemCrystallizes`` | 0 | Gauge |
| ``GradientInComparison`` | theorem | ``Decidable``, ``DistanceOnStructures`` | 0 | Gradient |
| ``GreedyDescentTerminates`` | bridge | ``AnchorGraph``, ``Monotone`` | 0 | Map |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``InterferenceIsIntelligence`` | bridge | ``IntelligenceRises``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``InvalidStepFolds`` | theorem | ``/Notation/Null``, ``HasPath`` | 0 | Path |
| ``IsIsYIdentity`` | bridge | ``OrderIsOnlyFreedom``, ``PassIsIdentification`` | 0 | Interference |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``LibraryCrystallizes`` | bridge | ``LibrarySaturates``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``MeasureIsCount`` | bridge | ``StandardIsType`` | 0 | Ruler |
| ``MetricProperty`` | marker | ``/Notation/Pair`` | 0 | Core |
| ``NoSelfReference`` | kernel | ``OperationsClosed`` | 0 | Identification |
| ``NullIsOrigin`` | theorem | ``/Notation/Null``, ``DistanceOnStructures`` | 0 | Gradient |
| ``OrgansAreOneCompare`` | bridge | ``Decidable``, ``DiscriminatorAndGenerator`` | 0 | Generation |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``PerspectiveIsEncoding`` | theorem | ``HasEncoding``, ``Measurable``, ``ScopeBoundedByEncoding`` | 0 | Space |
| ``PipelineCrystallizes`` | bridge | ``PassIsIdentification``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``PreconditionsGuaranteePass`` | theorem | ``ExactlyOneSurvives`` | 0 | Identification |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |
| ``QualitiesAreFinite`` | theorem | ``/Notation/IntegerValued``, ``HasEncoding`` | 0 | Space |
| ``RecordedAnswerReading`` | bridge | ``PredicateReading`` | 0 | Verdict |
| ``RefinementPreservesAnswer`` | kernel | ``EvidenceRefinesQuestion`` | 0 | Verdict |
| ``ResistanceHasMagnitude`` | theorem | ``DistanceOnStructures``, ``Resistant`` | 0 | Gradient |
| ``RetainedReadingRecord`` | marker | ``Permanent`` | 0 | Verdict |
| ``RootedRecordReadings`` | kernel | ``/Notation/Pair`` | 0 | Record |
| ``SaturationDynamics`` | bridge | ``ComparisonsAreBounded``, ``LibrarySaturates`` | 0 | Intelligence |
| ``SaturationIncorruptible`` | theorem | ``CachePermanent`` | 0 | Identification |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``SeparatorIdentifies`` | bridge | ``EncodingForgets`` | 0 | Seeing |
| ``SharedBoundaryContinuation`` | kernel | ``/Notation/Pair`` | 0 | Continuation |
| ``SharedDeclaredTick`` | kernel | ``/Notation/Pair`` | 0 | Ruler |
| ``SharedDecoder`` | kernel | ``/Notation/Pair`` | 0 | Verdict |
| ``SpaceFromDifference`` | bridge | ``DistanceIsMetric``, ``HasGrammar`` | 0 | Space |
| ``StrategyBecomesTarget`` | axis | ``HasStrategy`` | 0 | Level |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |
| ``ThreeAxesOfCompare`` | bridge | ``Decidable``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``Unique`` | marker | ``/Notation/Null``, ``Monotone`` | 0 | Core |
| ``Universality`` | bridge | ``ExactlyOneSurvives``, ``HasEncoding`` | 0 | Identification |
| ``VerdictCoversBranches`` | bridge | ``HasCandidates``, ``VerdictIsInvariant`` | 0 | Verdict |
| ``VerdictReorders`` | kernel | ``/Notation/Pair`` | 0 | Verdict |
| ``VerdictRetainsLeft`` | kernel | ``/Notation/Pair`` | 0 | Verdict |
| ``VerdictRetainsRight`` | kernel | ``/Notation/Pair`` | 0 | Verdict |

## Topics

### The same lattice, read five ways

- <doc:AtlasUnfolded>
- <doc:AtlasAblation>
- <doc:AtlasRepeats>
- <doc:AtlasOrder>
- <doc:AtlasArgued>
