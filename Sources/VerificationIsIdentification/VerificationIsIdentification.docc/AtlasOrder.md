# In what order to read

A claim can be judged once its premises are judged. This page puts the
whole lattice in that order. A claim at a step rests only on claims from
earlier steps, so a reader who takes the steps from the first meets every
premise before the claim that asks for it.

Step 0 has the claims with no premises. A claim appears at the step that
counts the longest way down from it to step 0, so one move above a step 0
claim is step 1. A row names
the premises its claim declares itself. Everything deeper than those is
at an earlier step by the same rule, so the row is the whole of what is
new to check.

<doc:Atlas> gives the same claims by load, heaviest first, which answers a
different question: what falls if one of them falls. This page answers
where to start.

## The order, premises before what they carry

### Step 0

- ``HasSigma``
- ``Structure``

### Step 1

- ``Close``, after ``Structure``
- ``HasCache``, after ``HasSigma``
- ``HasCost``, after ``HasSigma``
- ``HasDistance``, after ``HasSigma``
- ``HasEfficiency``, after ``HasSigma``
- ``HasEncoding``, after ``HasSigma``
- ``HasGauge``, after ``HasSigma``
- ``HasLaw``, after ``HasSigma``
- ``HasLibrary``, after ``HasSigma``
- ``HasPath``, after ``HasSigma``
- ``HasSolutions``, after ``HasSigma``
- ``HasTime``, after ``HasSigma``
- ``Open``, after ``Structure``

### Step 2

- ``CostIsPathLength``, after ``HasDistance``, ``HasPath``
- ``CostReadsGauge``, after ``HasDistance``, ``HasGauge``
- ``Digit``, after ``Open``
- ``DistanceIsMetric``, after ``HasCache``, ``HasDistance``
- ``EmissionAccumulates``, after ``HasPath``
- ``EncodingForgets``, after ``HasEncoding``
- ``EncodingInvents``, after ``HasEncoding``
- ``FaithfulEncoding``, after ``HasEncoding``
- ``HasAlpha``, after ``HasDistance``
- ``HasBasis``, after ``HasLibrary``
- ``HasCompositionalNorm``, after ``HasDistance``
- ``HasGrammar``, after ``HasEncoding``
- ``HasSaturation``, after ``HasLibrary``
- ``Pair``, after ``Open``

### Step 3

- ``ColourIsQuotient``, after ``EncodingForgets``
- ``Decidable``, after ``Pair``
- ``IntegerValued``, after ``Pair``
- ``LinearArbiter``, after ``CostIsPathLength``
- ``Measurable``, after ``Pair``
- ``MetricProperty``, after ``Pair``
- ``Monotone``, after ``Pair``
- ``Null``, after ``Pair``
- ``OperationsClosed``, after ``Pair``
- ``Permanent``, after ``Pair``
- ``ReachIsPath``, after ``HasBasis``, ``HasPath``
- ``SeparatorIdentifies``, after ``EncodingForgets``
- ``SpaceFromDifference``, after ``DistanceIsMetric``, ``HasGrammar``
- ``StructuresFinite``, after ``HasSigma``, ``Pair``

### Step 4

- ``CachePermanent``, after ``HasCache``, ``OperationsClosed``, ``StructuresFinite``
- ``ComparisonsAreBounded``, after ``StructuresFinite``
- ``DistanceOnStructures``, after ``HasDistance``, ``StructuresFinite``
- ``EqualityDecidable``, after ``StructuresFinite``
- ``GamutIsCone``, after ``ColourIsQuotient``
- ``IdentityCollapse``, after ``HasSolutions``, ``Null``
- ``InvalidStepFolds``, after ``HasPath``, ``Null``
- ``NoSelfReference``, after ``OperationsClosed``
- ``QualitiesAreFinite``, after ``HasEncoding``, ``IntegerValued``
- ``Resistant``, after ``Decidable``, ``HasDistance``
- ``ResultDeterministic``, after ``OperationsClosed``
- ``RevealsNotCreates``, after ``Measurable``, ``OperationsClosed``
- ``StepsTerminate``, after ``StructuresFinite``
- ``Unique``, after ``Monotone``, ``Null``

### Step 5

- ``AnchorGraph``, after ``DistanceOnStructures``, ``HasLibrary``
- ``AxesCoOriented``, after ``CachePermanent``, ``ResultDeterministic``
- ``BehaviorIsStructure``, after ``DistanceOnStructures``, ``HasTime``
- ``CacheOnlyGrows``, after ``CachePermanent``, ``StepsTerminate``
- ``CandidatesOnlyLeave``, after ``CachePermanent``, ``HasSolutions``
- ``CommunicationBounded``, after ``ComparisonsAreBounded``, ``HasCache``
- ``ContentIsGaugeInvariant``, after ``HasEncoding``, ``HasGauge``, ``RevealsNotCreates``
- ``DiagnosticsAccumulate``, after ``CachePermanent``, ``ResultDeterministic``
- ``DistanceIsCost``, after ``DistanceOnStructures``, ``HasCost``
- ``ExactlyOneSurvives``, after ``EqualityDecidable``, ``HasSolutions``
- ``GradientInComparison``, after ``Decidable``, ``DistanceOnStructures``
- ``KnowledgeAccumulates``, after ``CachePermanent``, ``HasLibrary``
- ``LawLivesInSigma``, after ``DistanceOnStructures``, ``HasLaw``
- ``LibrarySaturates``, after ``CachePermanent``, ``HasSaturation``
- ``MembershipDecidable``, after ``EqualityDecidable``, ``HasSolutions``
- ``NullIsOrigin``, after ``DistanceOnStructures``, ``Null``
- ``PipelineTotal``, after ``StepsTerminate``
- ``PresentedLaw``, after ``DistanceOnStructures``, ``HasLaw``
- ``ResistanceHasMagnitude``, after ``DistanceOnStructures``, ``Resistant``
- ``ResultsIrreversible``, after ``CachePermanent``, ``EqualityDecidable``
- ``SaturationIncorruptible``, after ``CachePermanent``
- ``ScopeBoundedByEncoding``, after ``ResultDeterministic``

### Step 6

- ``BallSaturation``, after ``DistanceOnStructures``, ``LibrarySaturates``
- ``BasisIsFinite``, after ``HasBasis``, ``LibrarySaturates``
- ``DiscoveryIsRevelation``, after ``ExactlyOneSurvives``, ``LibrarySaturates``
- ``EdgesCarryTheJudgement``, after ``BehaviorIsStructure``, ``PresentedLaw``
- ``EmissionIsAutoregressive``, after ``HasEncoding``, ``HasPath``, ``ScopeBoundedByEncoding``
- ``EncodingSelectionSaturates``, after ``HasEncoding``, ``LibrarySaturates``
- ``FormIsInvariant``, after ``PresentedLaw``
- ``GaugeCollapse``, after ``ContentIsGaugeInvariant``, ``LinearArbiter``
- ``GreedyDescentTerminates``, after ``AnchorGraph``, ``Monotone``
- ``HolesCarryAddresses``, after ``AnchorGraph``, ``Decidable``
- ``IntelligenceRises``, after ``HasEfficiency``, ``LibrarySaturates``
- ``InterferenceIsSubstitution``, after ``PresentedLaw``
- ``LiquidPhase``, after ``KnowledgeAccumulates``, ``Monotone``
- ``NoInverse``, after ``KnowledgeAccumulates``
- ``OrderIsOnlyFreedom``, after ``AxesCoOriented``, ``IdentityCollapse``
- ``PassImpliesMembership``, after ``PipelineTotal``, ``ResultDeterministic``
- ``PerspectiveIsEncoding``, after ``HasEncoding``, ``Measurable``, ``ScopeBoundedByEncoding``
- ``PreconditionsGuaranteePass``, after ``ExactlyOneSurvives``
- ``RulesCompose``, after ``KnowledgeAccumulates``
- ``SaturationDynamics``, after ``ComparisonsAreBounded``, ``LibrarySaturates``
- ``StandardIsType``, after ``PresentedLaw``
- ``SystemCrystallizes``, after ``CandidatesOnlyLeave``, ``MembershipDecidable``, ``ResultsIrreversible``
- ``Universality``, after ``ExactlyOneSurvives``, ``HasEncoding``

### Step 7

- ``AtomBasis``, after ``BasisIsFinite``, ``HasCompositionalNorm``, ``RulesCompose``
- ``Converges``, after ``NoInverse``, ``SystemCrystallizes``
- ``CrystallizationFront``, after ``DistanceOnStructures``, ``LiquidPhase``, ``NoInverse``
- ``DarknessIsNormalForm``, after ``InterferenceIsSubstitution``
- ``DiscriminatorAndGenerator``, after ``OrderIsOnlyFreedom``, ``PassImpliesMembership``
- ``ErasureIsRecession``, after ``EmissionAccumulates``, ``NoInverse``
- ``GateIsZeroOfLoss``, after ``DistanceOnStructures``, ``PassImpliesMembership``
- ``GatedConstruction``, after ``EmissionAccumulates``, ``SystemCrystallizes``
- ``GaugeFixing``, after ``CostReadsGauge``, ``SystemCrystallizes``
- ``InterferenceIsIntelligence``, after ``IntelligenceRises``, ``OrderIsOnlyFreedom``
- ``LibraryCrystallizes``, after ``LibrarySaturates``, ``SystemCrystallizes``
- ``MeasureIsCount``, after ``StandardIsType``
- ``OrderByDistance``, after ``DistanceOnStructures``, ``OrderIsOnlyFreedom``
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
- ``PressIsIdentification``, after ``PassIsIdentification``, ``PresentedLaw``
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
