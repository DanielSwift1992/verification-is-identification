# In what order to read

A claim can be checked once its premises are checked, so this page
orders the whole lattice that way: every claim appears after all of its
premises.

Step 0 contains the claims with no premises. A claim's step is the
length of its longest path down to step 0. A row lists the claim and its
declared premises. Premises of premises are at earlier steps by the same
rule, so each row is the only new material at its step.

A step is a distance in the type graph, not a measure of difficulty or
of depth of argument. Claims at one step share that distance and
nothing else.

<doc:Atlas> sorts the same claims by cone size, which answers a
different question: how many claims depend on this one. This page
answers where to start reading.

## The order, premises before what they carry

### Step 0

- ``HasSigma``
- ``/Notation/Structure``

### Step 1

- ``/Notation/Close``, after ``/Notation/Structure``
- ``HasCache``, after ``HasSigma``
- ``HasCandidates``, after ``HasSigma``
- ``HasCost``, after ``HasSigma``
- ``HasDistance``, after ``HasSigma``
- ``HasEfficiency``, after ``HasSigma``
- ``HasEncoding``, after ``HasSigma``
- ``HasGauge``, after ``HasSigma``
- ``HasLaw``, after ``HasSigma``
- ``HasLibrary``, after ``HasSigma``
- ``HasPath``, after ``HasSigma``
- ``HasSolutions``, after ``HasSigma``
- ``HasStrategy``, after ``HasSigma``
- ``HasTime``, after ``HasSigma``
- ``/Notation/Open``, after ``/Notation/Structure``

### Step 2

- ``CostIsPathLength``, after ``HasDistance``, ``HasPath``
- ``/Notation/Digit``, after ``/Notation/Open``
- ``DistanceIsMetric``, after ``HasCache``, ``HasDistance``
- ``EmissionAccumulates``, after ``HasPath``
- ``HasAlpha``, after ``HasDistance``
- ``HasBasis``, after ``HasLibrary``
- ``HasCompositionalNorm``, after ``HasDistance``
- ``HasGrammar``, after ``HasEncoding``
- ``HasSaturation``, after ``HasLibrary``
- ``HasVerdict``, after ``HasEncoding``
- ``/Notation/Pair``, after ``/Notation/Open``
- ``StrategyBecomesTarget``, after ``HasStrategy``

### Step 3

- ``ComparedReadings``, after ``/Notation/Pair``
- ``CoverageMatchesDeclaration``, after ``/Notation/Pair``
- ``Decidable``, after ``/Notation/Pair``
- ``EvidenceRefinesQuestion``, after ``/Notation/Pair``
- ``/Notation/IntegerValued``, after ``/Notation/Pair``
- ``Measurable``, after ``/Notation/Pair``
- ``MetricProperty``, after ``/Notation/Pair``
- ``Monotone``, after ``/Notation/Pair``
- ``/Notation/Null``, after ``/Notation/Pair``
- ``ObservationTrace``, after ``/Notation/Pair``
- ``ObservedTransition``, after ``HasEncoding``, ``/Notation/Pair``
- ``OperationsClosed``, after ``/Notation/Pair``
- ``Permanent``, after ``/Notation/Pair``
- ``PredicateReading``, after ``HasVerdict``, ``/Notation/Pair``
- ``ReachIsPath``, after ``HasBasis``, ``HasPath``
- ``RootedRecordReadings``, after ``/Notation/Pair``
- ``SharedBoundaryContinuation``, after ``/Notation/Pair``
- ``SharedDeclaredTick``, after ``/Notation/Pair``
- ``SharedDecoder``, after ``/Notation/Pair``
- ``SpaceFromDifference``, after ``DistanceIsMetric``, ``HasGrammar``
- ``StructuresFinite``, after ``HasSigma``, ``/Notation/Pair``
- ``VerdictReorders``, after ``/Notation/Pair``
- ``VerdictRetainsLeft``, after ``/Notation/Pair``
- ``VerdictRetainsRight``, after ``/Notation/Pair``

### Step 4

- ``CachePermanent``, after ``HasCache``, ``OperationsClosed``, ``StructuresFinite``
- ``CandidateReading``, after ``HasCandidates``, ``PredicateReading``
- ``CommutingTransition``, after ``ObservedTransition``
- ``ComparisonsAreBounded``, after ``StructuresFinite``
- ``CostReadsGauge``, after ``HasDistance``, ``HasGauge``, ``PredicateReading``
- ``DistanceOnStructures``, after ``HasDistance``, ``StructuresFinite``
- ``EmptyObservationTrace``, after ``ObservationTrace``
- ``EncodingInvents``, after ``ComparedReadings``, ``HasEncoding``
- ``EqualityDecidable``, after ``StructuresFinite``
- ``ExtendedObservationTrace``, after ``ObservationTrace``
- ``IdentityCollapse``, after ``HasSolutions``, ``/Notation/Null``
- ``InvalidStepFolds``, after ``HasPath``, ``/Notation/Null``
- ``NoSelfReference``, after ``OperationsClosed``
- ``QualitiesAreFinite``, after ``HasEncoding``, ``/Notation/IntegerValued``
- ``RecordedAnswerReading``, after ``PredicateReading``
- ``RefinementPreservesAnswer``, after ``EvidenceRefinesQuestion``
- ``Resistant``, after ``Decidable``, ``HasDistance``
- ``ResultDeterministic``, after ``OperationsClosed``
- ``RetainedReadingRecord``, after ``Permanent``
- ``RevealsNotCreates``, after ``Measurable``, ``OperationsClosed``
- ``StepsTerminate``, after ``StructuresFinite``
- ``Unique``, after ``Monotone``, ``/Notation/Null``
- ``VerdictIsInvariant``, after ``ComparedReadings``, ``HasVerdict``

### Step 5

- ``AdequateResidueContinuation``, after ``VerdictIsInvariant``
- ``AnchorGraph``, after ``DistanceOnStructures``, ``HasLibrary``
- ``AxesCoOriented``, after ``CachePermanent``, ``ResultDeterministic``
- ``BehaviorIsStructure``, after ``DistanceOnStructures``, ``HasTime``
- ``CacheOnlyGrows``, after ``CachePermanent``, ``StepsTerminate``
- ``CandidateGroupReading``, after ``CandidateReading``
- ``CandidateLeafReading``, after ``CandidateReading``
- ``CandidatesOnlyLeave``, after ``CachePermanent``, ``HasSolutions``
- ``CommunicationBounded``, after ``ComparisonsAreBounded``, ``HasCache``
- ``ConservedReadingStep``, after ``CommutingTransition``
- ``DistanceIsCost``, after ``DistanceOnStructures``, ``HasCost``
- ``EncodingForgets``, after ``VerdictIsInvariant``
- ``ExactlyOneSurvives``, after ``EqualityDecidable``, ``HasSolutions``
- ``GradientInComparison``, after ``Decidable``, ``DistanceOnStructures``
- ``KnowledgeAccumulates``, after ``CachePermanent``, ``HasLibrary``
- ``LawLivesInSigma``, after ``DistanceOnStructures``, ``HasLaw``
- ``LibrarySaturates``, after ``CachePermanent``, ``HasSaturation``
- ``MembershipDecidable``, after ``EqualityDecidable``, ``HasSolutions``
- ``NullIsOrigin``, after ``DistanceOnStructures``, ``/Notation/Null``
- ``PipelineTotal``, after ``StepsTerminate``
- ``ReadingFactors``, after ``VerdictIsInvariant``
- ``ResistanceHasMagnitude``, after ``DistanceOnStructures``, ``Resistant``
- ``ResultsIrreversible``, after ``CachePermanent``, ``EqualityDecidable``
- ``SaturationIncorruptible``, after ``CachePermanent``
- ``ScopeBoundedByEncoding``, after ``ResultDeterministic``
- ``VerdictCoversBranches``, after ``HasCandidates``, ``VerdictIsInvariant``

### Step 6

- ``AcquiresAnswer``, after ``ReadingFactors``
- ``BallSaturation``, after ``DistanceOnStructures``, ``LibrarySaturates``
- ``BasisIsFinite``, after ``HasBasis``, ``LibrarySaturates``
- ``CheckedSpellingAdmission``, after ``ReadingFactors``
- ``ColourIsQuotient``, after ``EncodingForgets``
- ``ContentIsGaugeInvariant``, after ``HasGauge``, ``ReadingFactors``
- ``DiscoveryIsRevelation``, after ``ExactlyOneSurvives``, ``LibrarySaturates``
- ``EdgesCarryTheJudgement``, after ``BehaviorIsStructure``, ``LawLivesInSigma``
- ``EmissionIsAutoregressive``, after ``HasEncoding``, ``HasPath``, ``ScopeBoundedByEncoding``
- ``EncodingSelectionSaturates``, after ``HasEncoding``, ``LibrarySaturates``
- ``FaithfulEncoding``, after ``ReadingFactors``
- ``FormIsInvariant``, after ``LawLivesInSigma``
- ``GreedyDescentTerminates``, after ``AnchorGraph``, ``Monotone``
- ``HolesCarryAddresses``, after ``AnchorGraph``, ``Decidable``
- ``IntelligenceRises``, after ``HasEfficiency``, ``LibrarySaturates``
- ``LiquidPhase``, after ``KnowledgeAccumulates``, ``Monotone``
- ``NoInverse``, after ``KnowledgeAccumulates``
- ``OrderIsOnlyFreedom``, after ``AxesCoOriented``, ``IdentityCollapse``
- ``PassImpliesMembership``, after ``PipelineTotal``, ``ResultDeterministic``
- ``PerspectiveIsEncoding``, after ``HasEncoding``, ``Measurable``, ``ScopeBoundedByEncoding``
- ``PreconditionsGuaranteePass``, after ``ExactlyOneSurvives``
- ``RulesCompose``, after ``KnowledgeAccumulates``
- ``SaturationDynamics``, after ``ComparisonsAreBounded``, ``LibrarySaturates``
- ``SeparatorIdentifies``, after ``EncodingForgets``
- ``StandardIsType``, after ``LawLivesInSigma``
- ``SystemCrystallizes``, after ``CandidatesOnlyLeave``, ``MembershipDecidable``, ``ResultsIrreversible``
- ``Universality``, after ``ExactlyOneSurvives``, ``HasEncoding``

### Step 7

- ``AtomBasis``, after ``BasisIsFinite``, ``HasCompositionalNorm``, ``RulesCompose``
- ``Converges``, after ``NoInverse``, ``SystemCrystallizes``
- ``CrystallizationFront``, after ``DistanceOnStructures``, ``LiquidPhase``, ``NoInverse``
- ``DiscriminatorAndGenerator``, after ``OrderIsOnlyFreedom``, ``PassImpliesMembership``
- ``ErasureIsRecession``, after ``EmissionAccumulates``, ``NoInverse``
- ``GateIsZeroOfLoss``, after ``DistanceOnStructures``, ``PassImpliesMembership``
- ``GatedConstruction``, after ``EmissionAccumulates``, ``SystemCrystallizes``
- ``GaugeCollapse``, after ``ContentIsGaugeInvariant``, ``CostIsPathLength``
- ``GaugeFixing``, after ``CostReadsGauge``, ``SystemCrystallizes``
- ``InterferenceIsIntelligence``, after ``IntelligenceRises``, ``OrderIsOnlyFreedom``
- ``LibraryCrystallizes``, after ``LibrarySaturates``, ``SystemCrystallizes``
- ``MeasureIsCount``, after ``StandardIsType``
- ``PassIsIdentification``, after ``ExactlyOneSurvives``, ``PassImpliesMembership``
- ``Reading``, after ``HasTime``, ``OrderIsOnlyFreedom``, ``RevealsNotCreates``
- ``RepairsPermanent``, after ``AnchorGraph``, ``NoInverse``
- ``StrategyLivesInSigma``, after ``DistanceOnStructures``, ``OrderIsOnlyFreedom``
- ``ThreeAxesOfCompare``, after ``Decidable``, ``OrderIsOnlyFreedom``

### Step 8

- ``AgentPathCertified``, after ``IdentityCollapse``, ``PassIsIdentification``
- ``AlignmentCoefficient``, after ``GateIsZeroOfLoss``, ``HasAlpha``
- ``AtomnessIsTrajectory``, after ``AtomBasis``, ``NoInverse``
- ``CertifiedRuleGenerates``, after ``KnowledgeAccumulates``, ``PassIsIdentification``
- ``CompletionIsSolutionSet``, after ``HasPath``, ``Reading``
- ``ConstructionIsReading``, after ``EmissionAccumulates``, ``Reading``
- ``FailureCurriculum``, after ``HolesCarryAddresses``, ``RepairsPermanent``
- ``FreeGeneration``, after ``DiscriminatorAndGenerator``, ``EmissionAccumulates``
- ``IsIsYIdentity``, after ``OrderIsOnlyFreedom``, ``PassIsIdentification``
- ``LawIsTarget``, after ``LawLivesInSigma``, ``PassIsIdentification``
- ``Matter``, after ``KnowledgeAccumulates``, ``PassIsIdentification``, ``Resistant``
- ``OrgansAreOneCompare``, after ``Decidable``, ``DiscriminatorAndGenerator``
- ``PipelineCrystallizes``, after ``PassIsIdentification``, ``SystemCrystallizes``
- ``ProgramIsPath``, after ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath``
- ``SkillsAreBalls``, after ``BallSaturation``, ``StrategyLivesInSigma``
- ``StrategyGate``, after ``PassImpliesMembership``, ``StrategyLivesInSigma``

### Step 9

- ``AlignmentEnablesIntelligence``, after ``AlignmentCoefficient``, ``IntelligenceRises``
- ``AmbiguityIsExperiment``, after ``HolesCarryAddresses``, ``LawIsTarget``
- ``AmbiguityNamesInput``, after ``CertifiedRuleGenerates``, ``HolesCarryAddresses``
- ``Ignites``, after ``LibrarySaturates``, ``Matter``
- ``InevitabilityIsDiscriminator``, after ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises``
- ``SearchFlow``, after ``AlignmentCoefficient``, ``LiquidPhase``
- ``StrategyIsUnique``, after ``ExactlyOneSurvives``, ``StrategyGate``

### Step 10

- ``SelfPlaySaturates``, after ``AmbiguityNamesInput``, ``BasisIsFinite``
- ``StefanCoupling``, after ``CrystallizationFront``, ``SearchFlow``
- ``StrategyCrystallizes``, after ``Matter``, ``StrategyIsUnique``
- ``Tower``, after ``HasCost``, ``HasTime``, ``Ignites``

### Step 11

- ``CompressionCriterion``, after ``DistanceOnStructures``, ``Tower``
- ``DepthIsBounded``, after ``HasGrammar``, ``Tower``
- ``FiniteDiscovery``, after ``ComparisonsAreBounded``, ``Tower``
- ``GateIsMembrane``, after ``StefanCoupling``
- ``LawfulDrift``, after ``LawIsTarget``, ``Tower``
- ``PhaseBecomesAmplitude``, after ``StrategyCrystallizes``
- ``SecondEncodingIsNovelty``, after ``ScopeBoundedByEncoding``, ``SelfPlaySaturates``
- ``TowerSelfPlay``, after ``Ignites``, ``SelfPlaySaturates``

### Step 12

- ``CompleteEntry``, after ``HasEncoding``, ``PhaseBecomesAmplitude``
- ``EncoderConditions``, after ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding``
- ``GateWrapper``, after ``DiscriminatorAndGenerator``, ``GateIsMembrane``
- ``OneBoundaryThreeFaces``, after ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion``
- ``PlayIsProof``, after ``RevealsNotCreates``, ``TowerSelfPlay``

### Step 13

- ``AllCoordinatesPresent``, after ``GateIsMembrane``, ``PlayIsProof``
- ``ConditionalSolving``, after ``EncoderConditions``
- ``FourthFace``, after ``OneBoundaryThreeFaces``, ``SkillsAreBalls``
- ``NavigationInevitable``, after ``OneBoundaryThreeFaces``
- ``SearchableIffClusteredAndAligned``, after ``AlignmentCoefficient``, ``OneBoundaryThreeFaces``

### Step 14

- ``DifficultyIsEncoder``, after ``ConditionalSolving``, ``ScopeBoundedByEncoding``
- ``MeasuredGeometry``, after ``FourthFace``, ``SearchableIffClusteredAndAligned``
- ``OrthogonalOrgans``, after ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned``
- ``PlanningIsNavigation``, after ``LawIsTarget``, ``NavigationInevitable``
- ``StrategyNavigation``, after ``NavigationInevitable``, ``SkillsAreBalls``

### Step 15

- ``MotorSkillsAreStrategies``, after ``PlanningIsNavigation``, ``SkillsAreBalls``
- ``SaturationMap``, after ``GateIsMembrane``, ``MeasuredGeometry``

### Step 16

- ``InteractiveDecomposition``, after ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies``
