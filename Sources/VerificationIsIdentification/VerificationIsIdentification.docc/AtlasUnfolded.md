# Atlas, unfolded

This page expands every Carries number of the <doc:Atlas> into its list.
A claim's **cone** is the full set of claims that depend on it, directly
or through others, and every Carries number on the Atlas links to its
cone here.

Each section repeats the same table over its cone, largest first. A
number inside a cone opens a further cone, strictly smaller than the one
above, so the descent ends at claims nothing depends on. A cycle of
cones cannot appear, because a circular protocol hierarchy does not
compile.

## The cones

### Structure

``Structure`` carries 176 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``Open`` | kernel | ``Structure`` | [174](<doc:AtlasUnfolded#Open>) | Primitive |
| ``Pair`` | seed | ``Open`` | [172](<doc:AtlasUnfolded#Pair>) | Primitive |
| ``StructuresFinite`` | kernel | ``HasSigma``, ``Pair`` | [115](<doc:AtlasUnfolded#StructuresFinite>) | Identification |
| ``OperationsClosed`` | kernel | ``Pair`` | [97](<doc:AtlasUnfolded#OperationsClosed>) | Identification |
| ``CachePermanent`` | theorem | ``HasCache``, ``OperationsClosed``, ``StructuresFinite`` | [82](<doc:AtlasUnfolded#CachePermanent>) | Identification |
| ``ResultDeterministic`` | kernel | ``OperationsClosed`` | [67](<doc:AtlasUnfolded#ResultDeterministic>) | Identification |
| ``DistanceOnStructures`` | theorem | ``HasDistance``, ``StructuresFinite`` | [59](<doc:AtlasUnfolded#DistanceOnStructures>) | Gradient |
| ``StepsTerminate`` | kernel | ``StructuresFinite`` | [54](<doc:AtlasUnfolded#StepsTerminate>) | Identification |
| ``PipelineTotal`` | kernel | ``StepsTerminate`` | [52](<doc:AtlasUnfolded#PipelineTotal>) | Identification |
| ``EqualityDecidable`` | kernel | ``StructuresFinite`` | [51](<doc:AtlasUnfolded#EqualityDecidable>) | Identification |
| ``PassImpliesMembership`` | kernel | ``PipelineTotal``, ``ResultDeterministic`` | [51](<doc:AtlasUnfolded#PassImpliesMembership>) | Identification |
| ``KnowledgeAccumulates`` | bridge | ``CachePermanent``, ``HasLibrary`` | [45](<doc:AtlasUnfolded#KnowledgeAccumulates>) | Intelligence |
| ``ExactlyOneSurvives`` | theorem | ``EqualityDecidable``, ``HasSolutions`` | [42](<doc:AtlasUnfolded#ExactlyOneSurvives>) | Identification |
| ``Decidable`` | marker | ``Pair`` | [38](<doc:AtlasUnfolded#Decidable>) | Core |
| ``LibrarySaturates`` | bridge | ``CachePermanent``, ``HasSaturation`` | [38](<doc:AtlasUnfolded#LibrarySaturates>) | Intelligence |
| ``PassIsIdentification`` | theorem | ``ExactlyOneSurvives``, ``PassImpliesMembership`` | [37](<doc:AtlasUnfolded#PassIsIdentification>) | Identification |
| ``Null`` | seed | ``Pair`` | [32](<doc:AtlasUnfolded#Null>) | Primitive |
| ``IdentityCollapse`` | theorem | ``HasSolutions``, ``Null`` | [28](<doc:AtlasUnfolded#IdentityCollapse>) | Core |
| ``Resistant`` | theorem | ``Decidable``, ``HasDistance`` | [28](<doc:AtlasUnfolded#Resistant>) | Matter |
| ``AxesCoOriented`` | theorem | ``CachePermanent``, ``ResultDeterministic`` | [27](<doc:AtlasUnfolded#AxesCoOriented>) | Identification |
| ``Matter`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification``, ``Resistant`` | [26](<doc:AtlasUnfolded#Matter>) | Matter |
| ``OrderIsOnlyFreedom`` | bridge | ``AxesCoOriented``, ``IdentityCollapse`` | [26](<doc:AtlasUnfolded#OrderIsOnlyFreedom>) | Identification |
| ``AnchorGraph`` | bridge | ``DistanceOnStructures``, ``HasLibrary`` | [22](<doc:AtlasUnfolded#AnchorGraph>) | Map |
| ``Ignites`` | bridge | ``LibrarySaturates``, ``Matter`` | [22](<doc:AtlasUnfolded#Ignites>) | Matter |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``BallSaturation`` | bridge | ``DistanceOnStructures``, ``LibrarySaturates`` | [15](<doc:AtlasUnfolded#BallSaturation>) | Gradient |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``ComparedReadings`` | marker | ``Pair`` | [13](<doc:AtlasUnfolded#ComparedReadings>) | Verdict |
| ``GateIsZeroOfLoss`` | theorem | ``DistanceOnStructures``, ``PassImpliesMembership`` | [12](<doc:AtlasUnfolded#GateIsZeroOfLoss>) | Gradient |
| ``StrategyLivesInSigma`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | [12](<doc:AtlasUnfolded#StrategyLivesInSigma>) | Strategy |
| ``AlignmentCoefficient`` | bridge | ``GateIsZeroOfLoss``, ``HasAlpha`` | [11](<doc:AtlasUnfolded#AlignmentCoefficient>) | Search |
| ``NoInverse`` | bridge | ``KnowledgeAccumulates`` | [11](<doc:AtlasUnfolded#NoInverse>) | Matter |
| ``VerdictIsInvariant`` | bridge | ``ComparedReadings``, ``HasVerdict`` | [11](<doc:AtlasUnfolded#VerdictIsInvariant>) | Verdict |
| ``Monotone`` | marker | ``Pair`` | [10](<doc:AtlasUnfolded#Monotone>) | Core |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``HolesCarryAddresses`` | bridge | ``AnchorGraph``, ``Decidable`` | [9](<doc:AtlasUnfolded#HolesCarryAddresses>) | Map |
| ``BasisIsFinite`` | bridge | ``HasBasis``, ``LibrarySaturates`` | [7](<doc:AtlasUnfolded#BasisIsFinite>) | Intelligence |
| ``CandidatesOnlyLeave`` | bridge | ``CachePermanent``, ``HasSolutions`` | [7](<doc:AtlasUnfolded#CandidatesOnlyLeave>) | Identification |
| ``LiquidPhase`` | bridge | ``KnowledgeAccumulates``, ``Monotone`` | [7](<doc:AtlasUnfolded#LiquidPhase>) | Liquid |
| ``Measurable`` | marker | ``Pair`` | [7](<doc:AtlasUnfolded#Measurable>) | Core |
| ``MembershipDecidable`` | theorem | ``EqualityDecidable``, ``HasSolutions`` | [7](<doc:AtlasUnfolded#MembershipDecidable>) | Intelligence |
| ``ResultsIrreversible`` | theorem | ``CachePermanent``, ``EqualityDecidable`` | [7](<doc:AtlasUnfolded#ResultsIrreversible>) | Intelligence |
| ``CertifiedRuleGenerates`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification`` | [6](<doc:AtlasUnfolded#CertifiedRuleGenerates>) | Play |
| ``LawLivesInSigma`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [6](<doc:AtlasUnfolded#LawLivesInSigma>) | Dynamics |
| ``PredicateReading`` | bridge | ``HasVerdict``, ``Pair`` | [6](<doc:AtlasUnfolded#PredicateReading>) | Verdict |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``SystemCrystallizes`` | bridge | ``CandidatesOnlyLeave``, ``MembershipDecidable``, ``ResultsIrreversible`` | [6](<doc:AtlasUnfolded#SystemCrystallizes>) | Intelligence |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``CrystallizationFront`` | bridge | ``DistanceOnStructures``, ``LiquidPhase``, ``NoInverse`` | [5](<doc:AtlasUnfolded#CrystallizationFront>) | Liquid |
| ``DiscriminatorAndGenerator`` | bridge | ``OrderIsOnlyFreedom``, ``PassImpliesMembership`` | [5](<doc:AtlasUnfolded#DiscriminatorAndGenerator>) | Generation |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
| ``PresentedLaw`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [5](<doc:AtlasUnfolded#PresentedLaw>) | Presentation |
| ``ReadingFactors`` | bridge | ``VerdictIsInvariant`` | [5](<doc:AtlasUnfolded#ReadingFactors>) | Verdict |
| ``RevealsNotCreates`` | kernel | ``Measurable``, ``OperationsClosed`` | [5](<doc:AtlasUnfolded#RevealsNotCreates>) | Identification |
| ``ScopeBoundedByEncoding`` | kernel | ``ResultDeterministic`` | [5](<doc:AtlasUnfolded#ScopeBoundedByEncoding>) | Identification |
| ``SearchFlow`` | bridge | ``AlignmentCoefficient``, ``LiquidPhase`` | [5](<doc:AtlasUnfolded#SearchFlow>) | Liquid |
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
| ``ObservationTrace`` | marker | ``Pair`` | [2](<doc:AtlasUnfolded#ObservationTrace>) | Verdict |
| ``ObservedTransition`` | theorem | ``HasEncoding``, ``Pair`` | [2](<doc:AtlasUnfolded#ObservedTransition>) | Transition |
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
| ``CostReadsGauge`` | bridge | ``HasDistance``, ``HasGauge``, ``PredicateReading`` | [1](<doc:AtlasUnfolded#CostReadsGauge>) | Gauge |
| ``EmissionIsAutoregressive`` | bridge | ``HasEncoding``, ``HasPath``, ``ScopeBoundedByEncoding`` | [1](<doc:AtlasUnfolded#EmissionIsAutoregressive>) | Path |
| ``EvidenceRefinesQuestion`` | kernel | ``Pair`` | [1](<doc:AtlasUnfolded#EvidenceRefinesQuestion>) | Verdict |
| ``GatedConstruction`` | bridge | ``EmissionAccumulates``, ``SystemCrystallizes`` | [1](<doc:AtlasUnfolded#GatedConstruction>) | Path |
| ``IntegerValued`` | marker | ``Pair`` | [1](<doc:AtlasUnfolded#IntegerValued>) | Core |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``Permanent`` | marker | ``Pair`` | [1](<doc:AtlasUnfolded#Permanent>) | Core |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``RepairsPermanent`` | bridge | ``AnchorGraph``, ``NoInverse`` | [1](<doc:AtlasUnfolded#RepairsPermanent>) | Map |
| ``StandardIsType`` | bridge | ``PresentedLaw`` | [1](<doc:AtlasUnfolded#StandardIsType>) | Ruler |
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
| ``Close`` | kernel | ``Structure`` | 0 | Primitive |
| ``ColourIsQuotient`` | bridge | ``EncodingForgets`` | 0 | Colour |
| ``CommunicationBounded`` | theorem | ``ComparisonsAreBounded``, ``HasCache`` | 0 | Space |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``CompletionIsSolutionSet`` | bridge | ``HasPath``, ``Reading`` | 0 | Path |
| ``ConservedReadingStep`` | theorem | ``CommutingTransition`` | 0 | Halt |
| ``ConstructionIsReading`` | bridge | ``EmissionAccumulates``, ``Reading`` | 0 | Path |
| ``Converges`` | bridge | ``NoInverse``, ``SystemCrystallizes`` | 0 | Matter |
| ``CoverageMatchesDeclaration`` | kernel | ``Pair`` | 0 | Verdict |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DiagnosticsAccumulate`` | theorem | ``CachePermanent``, ``ResultDeterministic`` | 0 | Identification |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``Digit`` | kernel | ``Open`` | 0 | Numeral |
| ``DiscoveryIsRevelation`` | bridge | ``ExactlyOneSurvives``, ``LibrarySaturates`` | 0 | Intelligence |
| ``DistanceIsCost`` | bridge | ``DistanceOnStructures``, ``HasCost`` | 0 | Gradient |
| ``EdgesCarryTheJudgement`` | bridge | ``BehaviorIsStructure``, ``PresentedLaw`` | 0 | Presentation |
| ``EmptyObservationTrace`` | kernel | ``ObservationTrace`` | 0 | Verdict |
| ``EncodingInvents`` | theorem | ``ComparedReadings``, ``HasEncoding`` | 0 | Voice |
| ``EncodingSelectionSaturates`` | bridge | ``HasEncoding``, ``LibrarySaturates`` | 0 | Intelligence |
| ``ErasureIsRecession`` | bridge | ``EmissionAccumulates``, ``NoInverse`` | 0 | Path |
| ``ExtendedObservationTrace`` | kernel | ``ObservationTrace`` | 0 | Verdict |
| ``FailureCurriculum`` | bridge | ``HolesCarryAddresses``, ``RepairsPermanent`` | 0 | Map |
| ``FaithfulEncoding`` | bridge | ``ReadingFactors`` | 0 | Voice |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``FormIsInvariant`` | bridge | ``PresentedLaw`` | 0 | Presentation |
| ``FreeGeneration`` | bridge | ``DiscriminatorAndGenerator``, ``EmissionAccumulates`` | 0 | Path |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``CostIsPathLength`` | 0 | Gauge |
| ``GaugeFixing`` | bridge | ``CostReadsGauge``, ``SystemCrystallizes`` | 0 | Gauge |
| ``GradientInComparison`` | theorem | ``Decidable``, ``DistanceOnStructures`` | 0 | Gradient |
| ``GreedyDescentTerminates`` | bridge | ``AnchorGraph``, ``Monotone`` | 0 | Map |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``InterferenceIsIntelligence`` | bridge | ``IntelligenceRises``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``InvalidStepFolds`` | theorem | ``HasPath``, ``Null`` | 0 | Path |
| ``IsIsYIdentity`` | bridge | ``OrderIsOnlyFreedom``, ``PassIsIdentification`` | 0 | Interference |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``LibraryCrystallizes`` | bridge | ``LibrarySaturates``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``MeasureIsCount`` | bridge | ``StandardIsType`` | 0 | Ruler |
| ``MetricProperty`` | marker | ``Pair`` | 0 | Core |
| ``NoSelfReference`` | kernel | ``OperationsClosed`` | 0 | Identification |
| ``NullIsOrigin`` | theorem | ``DistanceOnStructures``, ``Null`` | 0 | Gradient |
| ``OrderByDistance`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | 0 | Gradient |
| ``OrgansAreOneCompare`` | bridge | ``Decidable``, ``DiscriminatorAndGenerator`` | 0 | Generation |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``PerspectiveIsEncoding`` | theorem | ``HasEncoding``, ``Measurable``, ``ScopeBoundedByEncoding`` | 0 | Space |
| ``PipelineCrystallizes`` | bridge | ``PassIsIdentification``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``PreconditionsGuaranteePass`` | theorem | ``ExactlyOneSurvives`` | 0 | Identification |
| ``PressIsIdentification`` | bridge | ``PassIsIdentification``, ``PresentedLaw`` | 0 | Presentation |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |
| ``QualitiesAreFinite`` | theorem | ``HasEncoding``, ``IntegerValued`` | 0 | Space |
| ``RecordedAnswerReading`` | bridge | ``PredicateReading`` | 0 | Verdict |
| ``RefinementPreservesAnswer`` | kernel | ``EvidenceRefinesQuestion`` | 0 | Verdict |
| ``ResistanceHasMagnitude`` | theorem | ``DistanceOnStructures``, ``Resistant`` | 0 | Gradient |
| ``RetainedReadingRecord`` | marker | ``Permanent`` | 0 | Verdict |
| ``RootedRecordReadings`` | kernel | ``Pair`` | 0 | Record |
| ``SaturationDynamics`` | bridge | ``ComparisonsAreBounded``, ``LibrarySaturates`` | 0 | Intelligence |
| ``SaturationIncorruptible`` | theorem | ``CachePermanent`` | 0 | Identification |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``SeparatorIdentifies`` | bridge | ``EncodingForgets`` | 0 | Seeing |
| ``SharedBoundaryContinuation`` | kernel | ``Pair`` | 0 | Continuation |
| ``SharedDeclaredTick`` | kernel | ``Pair`` | 0 | Ruler |
| ``SharedDecoder`` | kernel | ``Pair`` | 0 | Verdict |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |
| ``ThreeAxesOfCompare`` | bridge | ``Decidable``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``Unique`` | marker | ``Monotone``, ``Null`` | 0 | Core |
| ``Universality`` | bridge | ``ExactlyOneSurvives``, ``HasEncoding`` | 0 | Identification |
| ``VerdictCoversBranches`` | bridge | ``HasCandidates``, ``VerdictIsInvariant`` | 0 | Verdict |
| ``VerdictReorders`` | kernel | ``Pair`` | 0 | Verdict |
| ``VerdictRetainsLeft`` | kernel | ``Pair`` | 0 | Verdict |
| ``VerdictRetainsRight`` | kernel | ``Pair`` | 0 | Verdict |

### Open

``Open`` carries 174 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``Pair`` | seed | ``Open`` | [172](<doc:AtlasUnfolded#Pair>) | Primitive |
| ``StructuresFinite`` | kernel | ``HasSigma``, ``Pair`` | [115](<doc:AtlasUnfolded#StructuresFinite>) | Identification |
| ``OperationsClosed`` | kernel | ``Pair`` | [97](<doc:AtlasUnfolded#OperationsClosed>) | Identification |
| ``CachePermanent`` | theorem | ``HasCache``, ``OperationsClosed``, ``StructuresFinite`` | [82](<doc:AtlasUnfolded#CachePermanent>) | Identification |
| ``ResultDeterministic`` | kernel | ``OperationsClosed`` | [67](<doc:AtlasUnfolded#ResultDeterministic>) | Identification |
| ``DistanceOnStructures`` | theorem | ``HasDistance``, ``StructuresFinite`` | [59](<doc:AtlasUnfolded#DistanceOnStructures>) | Gradient |
| ``StepsTerminate`` | kernel | ``StructuresFinite`` | [54](<doc:AtlasUnfolded#StepsTerminate>) | Identification |
| ``PipelineTotal`` | kernel | ``StepsTerminate`` | [52](<doc:AtlasUnfolded#PipelineTotal>) | Identification |
| ``EqualityDecidable`` | kernel | ``StructuresFinite`` | [51](<doc:AtlasUnfolded#EqualityDecidable>) | Identification |
| ``PassImpliesMembership`` | kernel | ``PipelineTotal``, ``ResultDeterministic`` | [51](<doc:AtlasUnfolded#PassImpliesMembership>) | Identification |
| ``KnowledgeAccumulates`` | bridge | ``CachePermanent``, ``HasLibrary`` | [45](<doc:AtlasUnfolded#KnowledgeAccumulates>) | Intelligence |
| ``ExactlyOneSurvives`` | theorem | ``EqualityDecidable``, ``HasSolutions`` | [42](<doc:AtlasUnfolded#ExactlyOneSurvives>) | Identification |
| ``Decidable`` | marker | ``Pair`` | [38](<doc:AtlasUnfolded#Decidable>) | Core |
| ``LibrarySaturates`` | bridge | ``CachePermanent``, ``HasSaturation`` | [38](<doc:AtlasUnfolded#LibrarySaturates>) | Intelligence |
| ``PassIsIdentification`` | theorem | ``ExactlyOneSurvives``, ``PassImpliesMembership`` | [37](<doc:AtlasUnfolded#PassIsIdentification>) | Identification |
| ``Null`` | seed | ``Pair`` | [32](<doc:AtlasUnfolded#Null>) | Primitive |
| ``IdentityCollapse`` | theorem | ``HasSolutions``, ``Null`` | [28](<doc:AtlasUnfolded#IdentityCollapse>) | Core |
| ``Resistant`` | theorem | ``Decidable``, ``HasDistance`` | [28](<doc:AtlasUnfolded#Resistant>) | Matter |
| ``AxesCoOriented`` | theorem | ``CachePermanent``, ``ResultDeterministic`` | [27](<doc:AtlasUnfolded#AxesCoOriented>) | Identification |
| ``Matter`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification``, ``Resistant`` | [26](<doc:AtlasUnfolded#Matter>) | Matter |
| ``OrderIsOnlyFreedom`` | bridge | ``AxesCoOriented``, ``IdentityCollapse`` | [26](<doc:AtlasUnfolded#OrderIsOnlyFreedom>) | Identification |
| ``AnchorGraph`` | bridge | ``DistanceOnStructures``, ``HasLibrary`` | [22](<doc:AtlasUnfolded#AnchorGraph>) | Map |
| ``Ignites`` | bridge | ``LibrarySaturates``, ``Matter`` | [22](<doc:AtlasUnfolded#Ignites>) | Matter |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``BallSaturation`` | bridge | ``DistanceOnStructures``, ``LibrarySaturates`` | [15](<doc:AtlasUnfolded#BallSaturation>) | Gradient |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``ComparedReadings`` | marker | ``Pair`` | [13](<doc:AtlasUnfolded#ComparedReadings>) | Verdict |
| ``GateIsZeroOfLoss`` | theorem | ``DistanceOnStructures``, ``PassImpliesMembership`` | [12](<doc:AtlasUnfolded#GateIsZeroOfLoss>) | Gradient |
| ``StrategyLivesInSigma`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | [12](<doc:AtlasUnfolded#StrategyLivesInSigma>) | Strategy |
| ``AlignmentCoefficient`` | bridge | ``GateIsZeroOfLoss``, ``HasAlpha`` | [11](<doc:AtlasUnfolded#AlignmentCoefficient>) | Search |
| ``NoInverse`` | bridge | ``KnowledgeAccumulates`` | [11](<doc:AtlasUnfolded#NoInverse>) | Matter |
| ``VerdictIsInvariant`` | bridge | ``ComparedReadings``, ``HasVerdict`` | [11](<doc:AtlasUnfolded#VerdictIsInvariant>) | Verdict |
| ``Monotone`` | marker | ``Pair`` | [10](<doc:AtlasUnfolded#Monotone>) | Core |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``HolesCarryAddresses`` | bridge | ``AnchorGraph``, ``Decidable`` | [9](<doc:AtlasUnfolded#HolesCarryAddresses>) | Map |
| ``BasisIsFinite`` | bridge | ``HasBasis``, ``LibrarySaturates`` | [7](<doc:AtlasUnfolded#BasisIsFinite>) | Intelligence |
| ``CandidatesOnlyLeave`` | bridge | ``CachePermanent``, ``HasSolutions`` | [7](<doc:AtlasUnfolded#CandidatesOnlyLeave>) | Identification |
| ``LiquidPhase`` | bridge | ``KnowledgeAccumulates``, ``Monotone`` | [7](<doc:AtlasUnfolded#LiquidPhase>) | Liquid |
| ``Measurable`` | marker | ``Pair`` | [7](<doc:AtlasUnfolded#Measurable>) | Core |
| ``MembershipDecidable`` | theorem | ``EqualityDecidable``, ``HasSolutions`` | [7](<doc:AtlasUnfolded#MembershipDecidable>) | Intelligence |
| ``ResultsIrreversible`` | theorem | ``CachePermanent``, ``EqualityDecidable`` | [7](<doc:AtlasUnfolded#ResultsIrreversible>) | Intelligence |
| ``CertifiedRuleGenerates`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification`` | [6](<doc:AtlasUnfolded#CertifiedRuleGenerates>) | Play |
| ``LawLivesInSigma`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [6](<doc:AtlasUnfolded#LawLivesInSigma>) | Dynamics |
| ``PredicateReading`` | bridge | ``HasVerdict``, ``Pair`` | [6](<doc:AtlasUnfolded#PredicateReading>) | Verdict |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``SystemCrystallizes`` | bridge | ``CandidatesOnlyLeave``, ``MembershipDecidable``, ``ResultsIrreversible`` | [6](<doc:AtlasUnfolded#SystemCrystallizes>) | Intelligence |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``CrystallizationFront`` | bridge | ``DistanceOnStructures``, ``LiquidPhase``, ``NoInverse`` | [5](<doc:AtlasUnfolded#CrystallizationFront>) | Liquid |
| ``DiscriminatorAndGenerator`` | bridge | ``OrderIsOnlyFreedom``, ``PassImpliesMembership`` | [5](<doc:AtlasUnfolded#DiscriminatorAndGenerator>) | Generation |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
| ``PresentedLaw`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [5](<doc:AtlasUnfolded#PresentedLaw>) | Presentation |
| ``ReadingFactors`` | bridge | ``VerdictIsInvariant`` | [5](<doc:AtlasUnfolded#ReadingFactors>) | Verdict |
| ``RevealsNotCreates`` | kernel | ``Measurable``, ``OperationsClosed`` | [5](<doc:AtlasUnfolded#RevealsNotCreates>) | Identification |
| ``ScopeBoundedByEncoding`` | kernel | ``ResultDeterministic`` | [5](<doc:AtlasUnfolded#ScopeBoundedByEncoding>) | Identification |
| ``SearchFlow`` | bridge | ``AlignmentCoefficient``, ``LiquidPhase`` | [5](<doc:AtlasUnfolded#SearchFlow>) | Liquid |
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
| ``ObservationTrace`` | marker | ``Pair`` | [2](<doc:AtlasUnfolded#ObservationTrace>) | Verdict |
| ``ObservedTransition`` | theorem | ``HasEncoding``, ``Pair`` | [2](<doc:AtlasUnfolded#ObservedTransition>) | Transition |
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
| ``CostReadsGauge`` | bridge | ``HasDistance``, ``HasGauge``, ``PredicateReading`` | [1](<doc:AtlasUnfolded#CostReadsGauge>) | Gauge |
| ``EmissionIsAutoregressive`` | bridge | ``HasEncoding``, ``HasPath``, ``ScopeBoundedByEncoding`` | [1](<doc:AtlasUnfolded#EmissionIsAutoregressive>) | Path |
| ``EvidenceRefinesQuestion`` | kernel | ``Pair`` | [1](<doc:AtlasUnfolded#EvidenceRefinesQuestion>) | Verdict |
| ``GatedConstruction`` | bridge | ``EmissionAccumulates``, ``SystemCrystallizes`` | [1](<doc:AtlasUnfolded#GatedConstruction>) | Path |
| ``IntegerValued`` | marker | ``Pair`` | [1](<doc:AtlasUnfolded#IntegerValued>) | Core |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``Permanent`` | marker | ``Pair`` | [1](<doc:AtlasUnfolded#Permanent>) | Core |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``RepairsPermanent`` | bridge | ``AnchorGraph``, ``NoInverse`` | [1](<doc:AtlasUnfolded#RepairsPermanent>) | Map |
| ``StandardIsType`` | bridge | ``PresentedLaw`` | [1](<doc:AtlasUnfolded#StandardIsType>) | Ruler |
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
| ``ColourIsQuotient`` | bridge | ``EncodingForgets`` | 0 | Colour |
| ``CommunicationBounded`` | theorem | ``ComparisonsAreBounded``, ``HasCache`` | 0 | Space |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``CompletionIsSolutionSet`` | bridge | ``HasPath``, ``Reading`` | 0 | Path |
| ``ConservedReadingStep`` | theorem | ``CommutingTransition`` | 0 | Halt |
| ``ConstructionIsReading`` | bridge | ``EmissionAccumulates``, ``Reading`` | 0 | Path |
| ``Converges`` | bridge | ``NoInverse``, ``SystemCrystallizes`` | 0 | Matter |
| ``CoverageMatchesDeclaration`` | kernel | ``Pair`` | 0 | Verdict |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DiagnosticsAccumulate`` | theorem | ``CachePermanent``, ``ResultDeterministic`` | 0 | Identification |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``Digit`` | kernel | ``Open`` | 0 | Numeral |
| ``DiscoveryIsRevelation`` | bridge | ``ExactlyOneSurvives``, ``LibrarySaturates`` | 0 | Intelligence |
| ``DistanceIsCost`` | bridge | ``DistanceOnStructures``, ``HasCost`` | 0 | Gradient |
| ``EdgesCarryTheJudgement`` | bridge | ``BehaviorIsStructure``, ``PresentedLaw`` | 0 | Presentation |
| ``EmptyObservationTrace`` | kernel | ``ObservationTrace`` | 0 | Verdict |
| ``EncodingInvents`` | theorem | ``ComparedReadings``, ``HasEncoding`` | 0 | Voice |
| ``EncodingSelectionSaturates`` | bridge | ``HasEncoding``, ``LibrarySaturates`` | 0 | Intelligence |
| ``ErasureIsRecession`` | bridge | ``EmissionAccumulates``, ``NoInverse`` | 0 | Path |
| ``ExtendedObservationTrace`` | kernel | ``ObservationTrace`` | 0 | Verdict |
| ``FailureCurriculum`` | bridge | ``HolesCarryAddresses``, ``RepairsPermanent`` | 0 | Map |
| ``FaithfulEncoding`` | bridge | ``ReadingFactors`` | 0 | Voice |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``FormIsInvariant`` | bridge | ``PresentedLaw`` | 0 | Presentation |
| ``FreeGeneration`` | bridge | ``DiscriminatorAndGenerator``, ``EmissionAccumulates`` | 0 | Path |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``CostIsPathLength`` | 0 | Gauge |
| ``GaugeFixing`` | bridge | ``CostReadsGauge``, ``SystemCrystallizes`` | 0 | Gauge |
| ``GradientInComparison`` | theorem | ``Decidable``, ``DistanceOnStructures`` | 0 | Gradient |
| ``GreedyDescentTerminates`` | bridge | ``AnchorGraph``, ``Monotone`` | 0 | Map |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``InterferenceIsIntelligence`` | bridge | ``IntelligenceRises``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``InvalidStepFolds`` | theorem | ``HasPath``, ``Null`` | 0 | Path |
| ``IsIsYIdentity`` | bridge | ``OrderIsOnlyFreedom``, ``PassIsIdentification`` | 0 | Interference |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``LibraryCrystallizes`` | bridge | ``LibrarySaturates``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``MeasureIsCount`` | bridge | ``StandardIsType`` | 0 | Ruler |
| ``MetricProperty`` | marker | ``Pair`` | 0 | Core |
| ``NoSelfReference`` | kernel | ``OperationsClosed`` | 0 | Identification |
| ``NullIsOrigin`` | theorem | ``DistanceOnStructures``, ``Null`` | 0 | Gradient |
| ``OrderByDistance`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | 0 | Gradient |
| ``OrgansAreOneCompare`` | bridge | ``Decidable``, ``DiscriminatorAndGenerator`` | 0 | Generation |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``PerspectiveIsEncoding`` | theorem | ``HasEncoding``, ``Measurable``, ``ScopeBoundedByEncoding`` | 0 | Space |
| ``PipelineCrystallizes`` | bridge | ``PassIsIdentification``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``PreconditionsGuaranteePass`` | theorem | ``ExactlyOneSurvives`` | 0 | Identification |
| ``PressIsIdentification`` | bridge | ``PassIsIdentification``, ``PresentedLaw`` | 0 | Presentation |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |
| ``QualitiesAreFinite`` | theorem | ``HasEncoding``, ``IntegerValued`` | 0 | Space |
| ``RecordedAnswerReading`` | bridge | ``PredicateReading`` | 0 | Verdict |
| ``RefinementPreservesAnswer`` | kernel | ``EvidenceRefinesQuestion`` | 0 | Verdict |
| ``ResistanceHasMagnitude`` | theorem | ``DistanceOnStructures``, ``Resistant`` | 0 | Gradient |
| ``RetainedReadingRecord`` | marker | ``Permanent`` | 0 | Verdict |
| ``RootedRecordReadings`` | kernel | ``Pair`` | 0 | Record |
| ``SaturationDynamics`` | bridge | ``ComparisonsAreBounded``, ``LibrarySaturates`` | 0 | Intelligence |
| ``SaturationIncorruptible`` | theorem | ``CachePermanent`` | 0 | Identification |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``SeparatorIdentifies`` | bridge | ``EncodingForgets`` | 0 | Seeing |
| ``SharedBoundaryContinuation`` | kernel | ``Pair`` | 0 | Continuation |
| ``SharedDeclaredTick`` | kernel | ``Pair`` | 0 | Ruler |
| ``SharedDecoder`` | kernel | ``Pair`` | 0 | Verdict |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |
| ``ThreeAxesOfCompare`` | bridge | ``Decidable``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``Unique`` | marker | ``Monotone``, ``Null`` | 0 | Core |
| ``Universality`` | bridge | ``ExactlyOneSurvives``, ``HasEncoding`` | 0 | Identification |
| ``VerdictCoversBranches`` | bridge | ``HasCandidates``, ``VerdictIsInvariant`` | 0 | Verdict |
| ``VerdictReorders`` | kernel | ``Pair`` | 0 | Verdict |
| ``VerdictRetainsLeft`` | kernel | ``Pair`` | 0 | Verdict |
| ``VerdictRetainsRight`` | kernel | ``Pair`` | 0 | Verdict |

### Pair

``Pair`` carries 172 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``StructuresFinite`` | kernel | ``HasSigma``, ``Pair`` | [115](<doc:AtlasUnfolded#StructuresFinite>) | Identification |
| ``OperationsClosed`` | kernel | ``Pair`` | [97](<doc:AtlasUnfolded#OperationsClosed>) | Identification |
| ``CachePermanent`` | theorem | ``HasCache``, ``OperationsClosed``, ``StructuresFinite`` | [82](<doc:AtlasUnfolded#CachePermanent>) | Identification |
| ``ResultDeterministic`` | kernel | ``OperationsClosed`` | [67](<doc:AtlasUnfolded#ResultDeterministic>) | Identification |
| ``DistanceOnStructures`` | theorem | ``HasDistance``, ``StructuresFinite`` | [59](<doc:AtlasUnfolded#DistanceOnStructures>) | Gradient |
| ``StepsTerminate`` | kernel | ``StructuresFinite`` | [54](<doc:AtlasUnfolded#StepsTerminate>) | Identification |
| ``PipelineTotal`` | kernel | ``StepsTerminate`` | [52](<doc:AtlasUnfolded#PipelineTotal>) | Identification |
| ``EqualityDecidable`` | kernel | ``StructuresFinite`` | [51](<doc:AtlasUnfolded#EqualityDecidable>) | Identification |
| ``PassImpliesMembership`` | kernel | ``PipelineTotal``, ``ResultDeterministic`` | [51](<doc:AtlasUnfolded#PassImpliesMembership>) | Identification |
| ``KnowledgeAccumulates`` | bridge | ``CachePermanent``, ``HasLibrary`` | [45](<doc:AtlasUnfolded#KnowledgeAccumulates>) | Intelligence |
| ``ExactlyOneSurvives`` | theorem | ``EqualityDecidable``, ``HasSolutions`` | [42](<doc:AtlasUnfolded#ExactlyOneSurvives>) | Identification |
| ``Decidable`` | marker | ``Pair`` | [38](<doc:AtlasUnfolded#Decidable>) | Core |
| ``LibrarySaturates`` | bridge | ``CachePermanent``, ``HasSaturation`` | [38](<doc:AtlasUnfolded#LibrarySaturates>) | Intelligence |
| ``PassIsIdentification`` | theorem | ``ExactlyOneSurvives``, ``PassImpliesMembership`` | [37](<doc:AtlasUnfolded#PassIsIdentification>) | Identification |
| ``Null`` | seed | ``Pair`` | [32](<doc:AtlasUnfolded#Null>) | Primitive |
| ``IdentityCollapse`` | theorem | ``HasSolutions``, ``Null`` | [28](<doc:AtlasUnfolded#IdentityCollapse>) | Core |
| ``Resistant`` | theorem | ``Decidable``, ``HasDistance`` | [28](<doc:AtlasUnfolded#Resistant>) | Matter |
| ``AxesCoOriented`` | theorem | ``CachePermanent``, ``ResultDeterministic`` | [27](<doc:AtlasUnfolded#AxesCoOriented>) | Identification |
| ``Matter`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification``, ``Resistant`` | [26](<doc:AtlasUnfolded#Matter>) | Matter |
| ``OrderIsOnlyFreedom`` | bridge | ``AxesCoOriented``, ``IdentityCollapse`` | [26](<doc:AtlasUnfolded#OrderIsOnlyFreedom>) | Identification |
| ``AnchorGraph`` | bridge | ``DistanceOnStructures``, ``HasLibrary`` | [22](<doc:AtlasUnfolded#AnchorGraph>) | Map |
| ``Ignites`` | bridge | ``LibrarySaturates``, ``Matter`` | [22](<doc:AtlasUnfolded#Ignites>) | Matter |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``BallSaturation`` | bridge | ``DistanceOnStructures``, ``LibrarySaturates`` | [15](<doc:AtlasUnfolded#BallSaturation>) | Gradient |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``ComparedReadings`` | marker | ``Pair`` | [13](<doc:AtlasUnfolded#ComparedReadings>) | Verdict |
| ``GateIsZeroOfLoss`` | theorem | ``DistanceOnStructures``, ``PassImpliesMembership`` | [12](<doc:AtlasUnfolded#GateIsZeroOfLoss>) | Gradient |
| ``StrategyLivesInSigma`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | [12](<doc:AtlasUnfolded#StrategyLivesInSigma>) | Strategy |
| ``AlignmentCoefficient`` | bridge | ``GateIsZeroOfLoss``, ``HasAlpha`` | [11](<doc:AtlasUnfolded#AlignmentCoefficient>) | Search |
| ``NoInverse`` | bridge | ``KnowledgeAccumulates`` | [11](<doc:AtlasUnfolded#NoInverse>) | Matter |
| ``VerdictIsInvariant`` | bridge | ``ComparedReadings``, ``HasVerdict`` | [11](<doc:AtlasUnfolded#VerdictIsInvariant>) | Verdict |
| ``Monotone`` | marker | ``Pair`` | [10](<doc:AtlasUnfolded#Monotone>) | Core |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``HolesCarryAddresses`` | bridge | ``AnchorGraph``, ``Decidable`` | [9](<doc:AtlasUnfolded#HolesCarryAddresses>) | Map |
| ``BasisIsFinite`` | bridge | ``HasBasis``, ``LibrarySaturates`` | [7](<doc:AtlasUnfolded#BasisIsFinite>) | Intelligence |
| ``CandidatesOnlyLeave`` | bridge | ``CachePermanent``, ``HasSolutions`` | [7](<doc:AtlasUnfolded#CandidatesOnlyLeave>) | Identification |
| ``LiquidPhase`` | bridge | ``KnowledgeAccumulates``, ``Monotone`` | [7](<doc:AtlasUnfolded#LiquidPhase>) | Liquid |
| ``Measurable`` | marker | ``Pair`` | [7](<doc:AtlasUnfolded#Measurable>) | Core |
| ``MembershipDecidable`` | theorem | ``EqualityDecidable``, ``HasSolutions`` | [7](<doc:AtlasUnfolded#MembershipDecidable>) | Intelligence |
| ``ResultsIrreversible`` | theorem | ``CachePermanent``, ``EqualityDecidable`` | [7](<doc:AtlasUnfolded#ResultsIrreversible>) | Intelligence |
| ``CertifiedRuleGenerates`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification`` | [6](<doc:AtlasUnfolded#CertifiedRuleGenerates>) | Play |
| ``LawLivesInSigma`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [6](<doc:AtlasUnfolded#LawLivesInSigma>) | Dynamics |
| ``PredicateReading`` | bridge | ``HasVerdict``, ``Pair`` | [6](<doc:AtlasUnfolded#PredicateReading>) | Verdict |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``SystemCrystallizes`` | bridge | ``CandidatesOnlyLeave``, ``MembershipDecidable``, ``ResultsIrreversible`` | [6](<doc:AtlasUnfolded#SystemCrystallizes>) | Intelligence |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``CrystallizationFront`` | bridge | ``DistanceOnStructures``, ``LiquidPhase``, ``NoInverse`` | [5](<doc:AtlasUnfolded#CrystallizationFront>) | Liquid |
| ``DiscriminatorAndGenerator`` | bridge | ``OrderIsOnlyFreedom``, ``PassImpliesMembership`` | [5](<doc:AtlasUnfolded#DiscriminatorAndGenerator>) | Generation |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
| ``PresentedLaw`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [5](<doc:AtlasUnfolded#PresentedLaw>) | Presentation |
| ``ReadingFactors`` | bridge | ``VerdictIsInvariant`` | [5](<doc:AtlasUnfolded#ReadingFactors>) | Verdict |
| ``RevealsNotCreates`` | kernel | ``Measurable``, ``OperationsClosed`` | [5](<doc:AtlasUnfolded#RevealsNotCreates>) | Identification |
| ``ScopeBoundedByEncoding`` | kernel | ``ResultDeterministic`` | [5](<doc:AtlasUnfolded#ScopeBoundedByEncoding>) | Identification |
| ``SearchFlow`` | bridge | ``AlignmentCoefficient``, ``LiquidPhase`` | [5](<doc:AtlasUnfolded#SearchFlow>) | Liquid |
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
| ``ObservationTrace`` | marker | ``Pair`` | [2](<doc:AtlasUnfolded#ObservationTrace>) | Verdict |
| ``ObservedTransition`` | theorem | ``HasEncoding``, ``Pair`` | [2](<doc:AtlasUnfolded#ObservedTransition>) | Transition |
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
| ``CostReadsGauge`` | bridge | ``HasDistance``, ``HasGauge``, ``PredicateReading`` | [1](<doc:AtlasUnfolded#CostReadsGauge>) | Gauge |
| ``EmissionIsAutoregressive`` | bridge | ``HasEncoding``, ``HasPath``, ``ScopeBoundedByEncoding`` | [1](<doc:AtlasUnfolded#EmissionIsAutoregressive>) | Path |
| ``EvidenceRefinesQuestion`` | kernel | ``Pair`` | [1](<doc:AtlasUnfolded#EvidenceRefinesQuestion>) | Verdict |
| ``GatedConstruction`` | bridge | ``EmissionAccumulates``, ``SystemCrystallizes`` | [1](<doc:AtlasUnfolded#GatedConstruction>) | Path |
| ``IntegerValued`` | marker | ``Pair`` | [1](<doc:AtlasUnfolded#IntegerValued>) | Core |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``Permanent`` | marker | ``Pair`` | [1](<doc:AtlasUnfolded#Permanent>) | Core |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``RepairsPermanent`` | bridge | ``AnchorGraph``, ``NoInverse`` | [1](<doc:AtlasUnfolded#RepairsPermanent>) | Map |
| ``StandardIsType`` | bridge | ``PresentedLaw`` | [1](<doc:AtlasUnfolded#StandardIsType>) | Ruler |
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
| ``ColourIsQuotient`` | bridge | ``EncodingForgets`` | 0 | Colour |
| ``CommunicationBounded`` | theorem | ``ComparisonsAreBounded``, ``HasCache`` | 0 | Space |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``CompletionIsSolutionSet`` | bridge | ``HasPath``, ``Reading`` | 0 | Path |
| ``ConservedReadingStep`` | theorem | ``CommutingTransition`` | 0 | Halt |
| ``ConstructionIsReading`` | bridge | ``EmissionAccumulates``, ``Reading`` | 0 | Path |
| ``Converges`` | bridge | ``NoInverse``, ``SystemCrystallizes`` | 0 | Matter |
| ``CoverageMatchesDeclaration`` | kernel | ``Pair`` | 0 | Verdict |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DiagnosticsAccumulate`` | theorem | ``CachePermanent``, ``ResultDeterministic`` | 0 | Identification |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``DiscoveryIsRevelation`` | bridge | ``ExactlyOneSurvives``, ``LibrarySaturates`` | 0 | Intelligence |
| ``DistanceIsCost`` | bridge | ``DistanceOnStructures``, ``HasCost`` | 0 | Gradient |
| ``EdgesCarryTheJudgement`` | bridge | ``BehaviorIsStructure``, ``PresentedLaw`` | 0 | Presentation |
| ``EmptyObservationTrace`` | kernel | ``ObservationTrace`` | 0 | Verdict |
| ``EncodingInvents`` | theorem | ``ComparedReadings``, ``HasEncoding`` | 0 | Voice |
| ``EncodingSelectionSaturates`` | bridge | ``HasEncoding``, ``LibrarySaturates`` | 0 | Intelligence |
| ``ErasureIsRecession`` | bridge | ``EmissionAccumulates``, ``NoInverse`` | 0 | Path |
| ``ExtendedObservationTrace`` | kernel | ``ObservationTrace`` | 0 | Verdict |
| ``FailureCurriculum`` | bridge | ``HolesCarryAddresses``, ``RepairsPermanent`` | 0 | Map |
| ``FaithfulEncoding`` | bridge | ``ReadingFactors`` | 0 | Voice |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``FormIsInvariant`` | bridge | ``PresentedLaw`` | 0 | Presentation |
| ``FreeGeneration`` | bridge | ``DiscriminatorAndGenerator``, ``EmissionAccumulates`` | 0 | Path |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``CostIsPathLength`` | 0 | Gauge |
| ``GaugeFixing`` | bridge | ``CostReadsGauge``, ``SystemCrystallizes`` | 0 | Gauge |
| ``GradientInComparison`` | theorem | ``Decidable``, ``DistanceOnStructures`` | 0 | Gradient |
| ``GreedyDescentTerminates`` | bridge | ``AnchorGraph``, ``Monotone`` | 0 | Map |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``InterferenceIsIntelligence`` | bridge | ``IntelligenceRises``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``InvalidStepFolds`` | theorem | ``HasPath``, ``Null`` | 0 | Path |
| ``IsIsYIdentity`` | bridge | ``OrderIsOnlyFreedom``, ``PassIsIdentification`` | 0 | Interference |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``LibraryCrystallizes`` | bridge | ``LibrarySaturates``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``MeasureIsCount`` | bridge | ``StandardIsType`` | 0 | Ruler |
| ``MetricProperty`` | marker | ``Pair`` | 0 | Core |
| ``NoSelfReference`` | kernel | ``OperationsClosed`` | 0 | Identification |
| ``NullIsOrigin`` | theorem | ``DistanceOnStructures``, ``Null`` | 0 | Gradient |
| ``OrderByDistance`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | 0 | Gradient |
| ``OrgansAreOneCompare`` | bridge | ``Decidable``, ``DiscriminatorAndGenerator`` | 0 | Generation |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``PerspectiveIsEncoding`` | theorem | ``HasEncoding``, ``Measurable``, ``ScopeBoundedByEncoding`` | 0 | Space |
| ``PipelineCrystallizes`` | bridge | ``PassIsIdentification``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``PreconditionsGuaranteePass`` | theorem | ``ExactlyOneSurvives`` | 0 | Identification |
| ``PressIsIdentification`` | bridge | ``PassIsIdentification``, ``PresentedLaw`` | 0 | Presentation |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |
| ``QualitiesAreFinite`` | theorem | ``HasEncoding``, ``IntegerValued`` | 0 | Space |
| ``RecordedAnswerReading`` | bridge | ``PredicateReading`` | 0 | Verdict |
| ``RefinementPreservesAnswer`` | kernel | ``EvidenceRefinesQuestion`` | 0 | Verdict |
| ``ResistanceHasMagnitude`` | theorem | ``DistanceOnStructures``, ``Resistant`` | 0 | Gradient |
| ``RetainedReadingRecord`` | marker | ``Permanent`` | 0 | Verdict |
| ``RootedRecordReadings`` | kernel | ``Pair`` | 0 | Record |
| ``SaturationDynamics`` | bridge | ``ComparisonsAreBounded``, ``LibrarySaturates`` | 0 | Intelligence |
| ``SaturationIncorruptible`` | theorem | ``CachePermanent`` | 0 | Identification |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``SeparatorIdentifies`` | bridge | ``EncodingForgets`` | 0 | Seeing |
| ``SharedBoundaryContinuation`` | kernel | ``Pair`` | 0 | Continuation |
| ``SharedDeclaredTick`` | kernel | ``Pair`` | 0 | Ruler |
| ``SharedDecoder`` | kernel | ``Pair`` | 0 | Verdict |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |
| ``ThreeAxesOfCompare`` | bridge | ``Decidable``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``Unique`` | marker | ``Monotone``, ``Null`` | 0 | Core |
| ``Universality`` | bridge | ``ExactlyOneSurvives``, ``HasEncoding`` | 0 | Identification |
| ``VerdictCoversBranches`` | bridge | ``HasCandidates``, ``VerdictIsInvariant`` | 0 | Verdict |
| ``VerdictReorders`` | kernel | ``Pair`` | 0 | Verdict |
| ``VerdictRetainsLeft`` | kernel | ``Pair`` | 0 | Verdict |
| ``VerdictRetainsRight`` | kernel | ``Pair`` | 0 | Verdict |

### HasSigma

``HasSigma`` carries 169 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``StructuresFinite`` | kernel | ``HasSigma``, ``Pair`` | [115](<doc:AtlasUnfolded#StructuresFinite>) | Identification |
| ``HasCache`` | axis | ``HasSigma`` | [86](<doc:AtlasUnfolded#HasCache>) | Core |
| ``CachePermanent`` | theorem | ``HasCache``, ``OperationsClosed``, ``StructuresFinite`` | [82](<doc:AtlasUnfolded#CachePermanent>) | Identification |
| ``HasDistance`` | axis | ``HasSigma`` | [76](<doc:AtlasUnfolded#HasDistance>) | Core |
| ``HasSolutions`` | axis | ``HasSigma`` | [67](<doc:AtlasUnfolded#HasSolutions>) | Core |
| ``HasLibrary`` | axis | ``HasSigma`` | [66](<doc:AtlasUnfolded#HasLibrary>) | Core |
| ``DistanceOnStructures`` | theorem | ``HasDistance``, ``StructuresFinite`` | [59](<doc:AtlasUnfolded#DistanceOnStructures>) | Gradient |
| ``StepsTerminate`` | kernel | ``StructuresFinite`` | [54](<doc:AtlasUnfolded#StepsTerminate>) | Identification |
| ``PipelineTotal`` | kernel | ``StepsTerminate`` | [52](<doc:AtlasUnfolded#PipelineTotal>) | Identification |
| ``EqualityDecidable`` | kernel | ``StructuresFinite`` | [51](<doc:AtlasUnfolded#EqualityDecidable>) | Identification |
| ``PassImpliesMembership`` | kernel | ``PipelineTotal``, ``ResultDeterministic`` | [51](<doc:AtlasUnfolded#PassImpliesMembership>) | Identification |
| ``KnowledgeAccumulates`` | bridge | ``CachePermanent``, ``HasLibrary`` | [45](<doc:AtlasUnfolded#KnowledgeAccumulates>) | Intelligence |
| ``ExactlyOneSurvives`` | theorem | ``EqualityDecidable``, ``HasSolutions`` | [42](<doc:AtlasUnfolded#ExactlyOneSurvives>) | Identification |
| ``HasSaturation`` | axis | ``HasLibrary`` | [39](<doc:AtlasUnfolded#HasSaturation>) | Core |
| ``LibrarySaturates`` | bridge | ``CachePermanent``, ``HasSaturation`` | [38](<doc:AtlasUnfolded#LibrarySaturates>) | Intelligence |
| ``HasEncoding`` | axis | ``HasSigma`` | [37](<doc:AtlasUnfolded#HasEncoding>) | Core |
| ``PassIsIdentification`` | theorem | ``ExactlyOneSurvives``, ``PassImpliesMembership`` | [37](<doc:AtlasUnfolded#PassIsIdentification>) | Identification |
| ``IdentityCollapse`` | theorem | ``HasSolutions``, ``Null`` | [28](<doc:AtlasUnfolded#IdentityCollapse>) | Core |
| ``Resistant`` | theorem | ``Decidable``, ``HasDistance`` | [28](<doc:AtlasUnfolded#Resistant>) | Matter |
| ``AxesCoOriented`` | theorem | ``CachePermanent``, ``ResultDeterministic`` | [27](<doc:AtlasUnfolded#AxesCoOriented>) | Identification |
| ``Matter`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification``, ``Resistant`` | [26](<doc:AtlasUnfolded#Matter>) | Matter |
| ``OrderIsOnlyFreedom`` | bridge | ``AxesCoOriented``, ``IdentityCollapse`` | [26](<doc:AtlasUnfolded#OrderIsOnlyFreedom>) | Identification |
| ``HasTime`` | axis | ``HasSigma`` | [24](<doc:AtlasUnfolded#HasTime>) | Matter |
| ``AnchorGraph`` | bridge | ``DistanceOnStructures``, ``HasLibrary`` | [22](<doc:AtlasUnfolded#AnchorGraph>) | Map |
| ``Ignites`` | bridge | ``LibrarySaturates``, ``Matter`` | [22](<doc:AtlasUnfolded#Ignites>) | Matter |
| ``HasCost`` | axis | ``HasSigma`` | [20](<doc:AtlasUnfolded#HasCost>) | Matter |
| ``HasVerdict`` | axis | ``HasEncoding`` | [19](<doc:AtlasUnfolded#HasVerdict>) | Verdict |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``BallSaturation`` | bridge | ``DistanceOnStructures``, ``LibrarySaturates`` | [15](<doc:AtlasUnfolded#BallSaturation>) | Gradient |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``HasLaw`` | axis | ``HasSigma`` | [13](<doc:AtlasUnfolded#HasLaw>) | Dynamics |
| ``GateIsZeroOfLoss`` | theorem | ``DistanceOnStructures``, ``PassImpliesMembership`` | [12](<doc:AtlasUnfolded#GateIsZeroOfLoss>) | Gradient |
| ``HasAlpha`` | axis | ``HasDistance`` | [12](<doc:AtlasUnfolded#HasAlpha>) | Core |
| ``HasPath`` | axis | ``HasSigma`` | [12](<doc:AtlasUnfolded#HasPath>) | Path |
| ``StrategyLivesInSigma`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | [12](<doc:AtlasUnfolded#StrategyLivesInSigma>) | Strategy |
| ``AlignmentCoefficient`` | bridge | ``GateIsZeroOfLoss``, ``HasAlpha`` | [11](<doc:AtlasUnfolded#AlignmentCoefficient>) | Search |
| ``NoInverse`` | bridge | ``KnowledgeAccumulates`` | [11](<doc:AtlasUnfolded#NoInverse>) | Matter |
| ``VerdictIsInvariant`` | bridge | ``ComparedReadings``, ``HasVerdict`` | [11](<doc:AtlasUnfolded#VerdictIsInvariant>) | Verdict |
| ``HasBasis`` | axis | ``HasLibrary`` | [10](<doc:AtlasUnfolded#HasBasis>) | Core |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``HolesCarryAddresses`` | bridge | ``AnchorGraph``, ``Decidable`` | [9](<doc:AtlasUnfolded#HolesCarryAddresses>) | Map |
| ``BasisIsFinite`` | bridge | ``HasBasis``, ``LibrarySaturates`` | [7](<doc:AtlasUnfolded#BasisIsFinite>) | Intelligence |
| ``CandidatesOnlyLeave`` | bridge | ``CachePermanent``, ``HasSolutions`` | [7](<doc:AtlasUnfolded#CandidatesOnlyLeave>) | Identification |
| ``LiquidPhase`` | bridge | ``KnowledgeAccumulates``, ``Monotone`` | [7](<doc:AtlasUnfolded#LiquidPhase>) | Liquid |
| ``MembershipDecidable`` | theorem | ``EqualityDecidable``, ``HasSolutions`` | [7](<doc:AtlasUnfolded#MembershipDecidable>) | Intelligence |
| ``ResultsIrreversible`` | theorem | ``CachePermanent``, ``EqualityDecidable`` | [7](<doc:AtlasUnfolded#ResultsIrreversible>) | Intelligence |
| ``CertifiedRuleGenerates`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification`` | [6](<doc:AtlasUnfolded#CertifiedRuleGenerates>) | Play |
| ``LawLivesInSigma`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [6](<doc:AtlasUnfolded#LawLivesInSigma>) | Dynamics |
| ``PredicateReading`` | bridge | ``HasVerdict``, ``Pair`` | [6](<doc:AtlasUnfolded#PredicateReading>) | Verdict |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``SystemCrystallizes`` | bridge | ``CandidatesOnlyLeave``, ``MembershipDecidable``, ``ResultsIrreversible`` | [6](<doc:AtlasUnfolded#SystemCrystallizes>) | Intelligence |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``CrystallizationFront`` | bridge | ``DistanceOnStructures``, ``LiquidPhase``, ``NoInverse`` | [5](<doc:AtlasUnfolded#CrystallizationFront>) | Liquid |
| ``DiscriminatorAndGenerator`` | bridge | ``OrderIsOnlyFreedom``, ``PassImpliesMembership`` | [5](<doc:AtlasUnfolded#DiscriminatorAndGenerator>) | Generation |
| ``EmissionAccumulates`` | theorem | ``HasPath`` | [5](<doc:AtlasUnfolded#EmissionAccumulates>) | Path |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
| ``PresentedLaw`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [5](<doc:AtlasUnfolded#PresentedLaw>) | Presentation |
| ``ReadingFactors`` | bridge | ``VerdictIsInvariant`` | [5](<doc:AtlasUnfolded#ReadingFactors>) | Verdict |
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
| ``ObservedTransition`` | theorem | ``HasEncoding``, ``Pair`` | [2](<doc:AtlasUnfolded#ObservedTransition>) | Transition |
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
| ``GatedConstruction`` | bridge | ``EmissionAccumulates``, ``SystemCrystallizes`` | [1](<doc:AtlasUnfolded#GatedConstruction>) | Path |
| ``HasStrategy`` | axis | ``HasSigma`` | [1](<doc:AtlasUnfolded#HasStrategy>) | Level |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``ReachIsPath`` | bridge | ``HasBasis``, ``HasPath`` | [1](<doc:AtlasUnfolded#ReachIsPath>) | Path |
| ``RepairsPermanent`` | bridge | ``AnchorGraph``, ``NoInverse`` | [1](<doc:AtlasUnfolded#RepairsPermanent>) | Map |
| ``StandardIsType`` | bridge | ``PresentedLaw`` | [1](<doc:AtlasUnfolded#StandardIsType>) | Ruler |
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
| ``ColourIsQuotient`` | bridge | ``EncodingForgets`` | 0 | Colour |
| ``CommunicationBounded`` | theorem | ``ComparisonsAreBounded``, ``HasCache`` | 0 | Space |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``CompletionIsSolutionSet`` | bridge | ``HasPath``, ``Reading`` | 0 | Path |
| ``ConservedReadingStep`` | theorem | ``CommutingTransition`` | 0 | Halt |
| ``ConstructionIsReading`` | bridge | ``EmissionAccumulates``, ``Reading`` | 0 | Path |
| ``Converges`` | bridge | ``NoInverse``, ``SystemCrystallizes`` | 0 | Matter |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DiagnosticsAccumulate`` | theorem | ``CachePermanent``, ``ResultDeterministic`` | 0 | Identification |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``DiscoveryIsRevelation`` | bridge | ``ExactlyOneSurvives``, ``LibrarySaturates`` | 0 | Intelligence |
| ``DistanceIsCost`` | bridge | ``DistanceOnStructures``, ``HasCost`` | 0 | Gradient |
| ``EdgesCarryTheJudgement`` | bridge | ``BehaviorIsStructure``, ``PresentedLaw`` | 0 | Presentation |
| ``EncodingInvents`` | theorem | ``ComparedReadings``, ``HasEncoding`` | 0 | Voice |
| ``EncodingSelectionSaturates`` | bridge | ``HasEncoding``, ``LibrarySaturates`` | 0 | Intelligence |
| ``ErasureIsRecession`` | bridge | ``EmissionAccumulates``, ``NoInverse`` | 0 | Path |
| ``FailureCurriculum`` | bridge | ``HolesCarryAddresses``, ``RepairsPermanent`` | 0 | Map |
| ``FaithfulEncoding`` | bridge | ``ReadingFactors`` | 0 | Voice |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``FormIsInvariant`` | bridge | ``PresentedLaw`` | 0 | Presentation |
| ``FreeGeneration`` | bridge | ``DiscriminatorAndGenerator``, ``EmissionAccumulates`` | 0 | Path |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``CostIsPathLength`` | 0 | Gauge |
| ``GaugeFixing`` | bridge | ``CostReadsGauge``, ``SystemCrystallizes`` | 0 | Gauge |
| ``GradientInComparison`` | theorem | ``Decidable``, ``DistanceOnStructures`` | 0 | Gradient |
| ``GreedyDescentTerminates`` | bridge | ``AnchorGraph``, ``Monotone`` | 0 | Map |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``InterferenceIsIntelligence`` | bridge | ``IntelligenceRises``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``InvalidStepFolds`` | theorem | ``HasPath``, ``Null`` | 0 | Path |
| ``IsIsYIdentity`` | bridge | ``OrderIsOnlyFreedom``, ``PassIsIdentification`` | 0 | Interference |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``LibraryCrystallizes`` | bridge | ``LibrarySaturates``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``MeasureIsCount`` | bridge | ``StandardIsType`` | 0 | Ruler |
| ``NullIsOrigin`` | theorem | ``DistanceOnStructures``, ``Null`` | 0 | Gradient |
| ``OrderByDistance`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | 0 | Gradient |
| ``OrgansAreOneCompare`` | bridge | ``Decidable``, ``DiscriminatorAndGenerator`` | 0 | Generation |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``PerspectiveIsEncoding`` | theorem | ``HasEncoding``, ``Measurable``, ``ScopeBoundedByEncoding`` | 0 | Space |
| ``PipelineCrystallizes`` | bridge | ``PassIsIdentification``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``PreconditionsGuaranteePass`` | theorem | ``ExactlyOneSurvives`` | 0 | Identification |
| ``PressIsIdentification`` | bridge | ``PassIsIdentification``, ``PresentedLaw`` | 0 | Presentation |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |
| ``QualitiesAreFinite`` | theorem | ``HasEncoding``, ``IntegerValued`` | 0 | Space |
| ``RecordedAnswerReading`` | bridge | ``PredicateReading`` | 0 | Verdict |
| ``ResistanceHasMagnitude`` | theorem | ``DistanceOnStructures``, ``Resistant`` | 0 | Gradient |
| ``SaturationDynamics`` | bridge | ``ComparisonsAreBounded``, ``LibrarySaturates`` | 0 | Intelligence |
| ``SaturationIncorruptible`` | theorem | ``CachePermanent`` | 0 | Identification |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``SeparatorIdentifies`` | bridge | ``EncodingForgets`` | 0 | Seeing |
| ``SpaceFromDifference`` | bridge | ``DistanceIsMetric``, ``HasGrammar`` | 0 | Space |
| ``StrategyBecomesTarget`` | axis | ``HasStrategy`` | 0 | Level |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |
| ``ThreeAxesOfCompare`` | bridge | ``Decidable``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``Universality`` | bridge | ``ExactlyOneSurvives``, ``HasEncoding`` | 0 | Identification |
| ``VerdictCoversBranches`` | bridge | ``HasCandidates``, ``VerdictIsInvariant`` | 0 | Verdict |

### StructuresFinite

``StructuresFinite`` carries 115 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``CachePermanent`` | theorem | ``HasCache``, ``OperationsClosed``, ``StructuresFinite`` | [82](<doc:AtlasUnfolded#CachePermanent>) | Identification |
| ``DistanceOnStructures`` | theorem | ``HasDistance``, ``StructuresFinite`` | [59](<doc:AtlasUnfolded#DistanceOnStructures>) | Gradient |
| ``StepsTerminate`` | kernel | ``StructuresFinite`` | [54](<doc:AtlasUnfolded#StepsTerminate>) | Identification |
| ``PipelineTotal`` | kernel | ``StepsTerminate`` | [52](<doc:AtlasUnfolded#PipelineTotal>) | Identification |
| ``EqualityDecidable`` | kernel | ``StructuresFinite`` | [51](<doc:AtlasUnfolded#EqualityDecidable>) | Identification |
| ``PassImpliesMembership`` | kernel | ``PipelineTotal``, ``ResultDeterministic`` | [51](<doc:AtlasUnfolded#PassImpliesMembership>) | Identification |
| ``KnowledgeAccumulates`` | bridge | ``CachePermanent``, ``HasLibrary`` | [45](<doc:AtlasUnfolded#KnowledgeAccumulates>) | Intelligence |
| ``ExactlyOneSurvives`` | theorem | ``EqualityDecidable``, ``HasSolutions`` | [42](<doc:AtlasUnfolded#ExactlyOneSurvives>) | Identification |
| ``LibrarySaturates`` | bridge | ``CachePermanent``, ``HasSaturation`` | [38](<doc:AtlasUnfolded#LibrarySaturates>) | Intelligence |
| ``PassIsIdentification`` | theorem | ``ExactlyOneSurvives``, ``PassImpliesMembership`` | [37](<doc:AtlasUnfolded#PassIsIdentification>) | Identification |
| ``AxesCoOriented`` | theorem | ``CachePermanent``, ``ResultDeterministic`` | [27](<doc:AtlasUnfolded#AxesCoOriented>) | Identification |
| ``Matter`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification``, ``Resistant`` | [26](<doc:AtlasUnfolded#Matter>) | Matter |
| ``OrderIsOnlyFreedom`` | bridge | ``AxesCoOriented``, ``IdentityCollapse`` | [26](<doc:AtlasUnfolded#OrderIsOnlyFreedom>) | Identification |
| ``AnchorGraph`` | bridge | ``DistanceOnStructures``, ``HasLibrary`` | [22](<doc:AtlasUnfolded#AnchorGraph>) | Map |
| ``Ignites`` | bridge | ``LibrarySaturates``, ``Matter`` | [22](<doc:AtlasUnfolded#Ignites>) | Matter |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``BallSaturation`` | bridge | ``DistanceOnStructures``, ``LibrarySaturates`` | [15](<doc:AtlasUnfolded#BallSaturation>) | Gradient |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``GateIsZeroOfLoss`` | theorem | ``DistanceOnStructures``, ``PassImpliesMembership`` | [12](<doc:AtlasUnfolded#GateIsZeroOfLoss>) | Gradient |
| ``StrategyLivesInSigma`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | [12](<doc:AtlasUnfolded#StrategyLivesInSigma>) | Strategy |
| ``AlignmentCoefficient`` | bridge | ``GateIsZeroOfLoss``, ``HasAlpha`` | [11](<doc:AtlasUnfolded#AlignmentCoefficient>) | Search |
| ``NoInverse`` | bridge | ``KnowledgeAccumulates`` | [11](<doc:AtlasUnfolded#NoInverse>) | Matter |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``HolesCarryAddresses`` | bridge | ``AnchorGraph``, ``Decidable`` | [9](<doc:AtlasUnfolded#HolesCarryAddresses>) | Map |
| ``BasisIsFinite`` | bridge | ``HasBasis``, ``LibrarySaturates`` | [7](<doc:AtlasUnfolded#BasisIsFinite>) | Intelligence |
| ``CandidatesOnlyLeave`` | bridge | ``CachePermanent``, ``HasSolutions`` | [7](<doc:AtlasUnfolded#CandidatesOnlyLeave>) | Identification |
| ``LiquidPhase`` | bridge | ``KnowledgeAccumulates``, ``Monotone`` | [7](<doc:AtlasUnfolded#LiquidPhase>) | Liquid |
| ``MembershipDecidable`` | theorem | ``EqualityDecidable``, ``HasSolutions`` | [7](<doc:AtlasUnfolded#MembershipDecidable>) | Intelligence |
| ``ResultsIrreversible`` | theorem | ``CachePermanent``, ``EqualityDecidable`` | [7](<doc:AtlasUnfolded#ResultsIrreversible>) | Intelligence |
| ``CertifiedRuleGenerates`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification`` | [6](<doc:AtlasUnfolded#CertifiedRuleGenerates>) | Play |
| ``LawLivesInSigma`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [6](<doc:AtlasUnfolded#LawLivesInSigma>) | Dynamics |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``SystemCrystallizes`` | bridge | ``CandidatesOnlyLeave``, ``MembershipDecidable``, ``ResultsIrreversible`` | [6](<doc:AtlasUnfolded#SystemCrystallizes>) | Intelligence |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``CrystallizationFront`` | bridge | ``DistanceOnStructures``, ``LiquidPhase``, ``NoInverse`` | [5](<doc:AtlasUnfolded#CrystallizationFront>) | Liquid |
| ``DiscriminatorAndGenerator`` | bridge | ``OrderIsOnlyFreedom``, ``PassImpliesMembership`` | [5](<doc:AtlasUnfolded#DiscriminatorAndGenerator>) | Generation |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
| ``PresentedLaw`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [5](<doc:AtlasUnfolded#PresentedLaw>) | Presentation |
| ``SearchFlow`` | bridge | ``AlignmentCoefficient``, ``LiquidPhase`` | [5](<doc:AtlasUnfolded#SearchFlow>) | Liquid |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``StefanCoupling`` | bridge | ``CrystallizationFront``, ``SearchFlow`` | [4](<doc:AtlasUnfolded#StefanCoupling>) | Liquid |
| ``StrategyGate`` | bridge | ``PassImpliesMembership``, ``StrategyLivesInSigma`` | [4](<doc:AtlasUnfolded#StrategyGate>) | Strategy |
| ``ComparisonsAreBounded`` | kernel | ``StructuresFinite`` | [3](<doc:AtlasUnfolded#ComparisonsAreBounded>) | Identification |
| ``GateIsMembrane`` | bridge | ``StefanCoupling`` | [3](<doc:AtlasUnfolded#GateIsMembrane>) | Liquid |
| ``IntelligenceRises`` | bridge | ``HasEfficiency``, ``LibrarySaturates`` | [3](<doc:AtlasUnfolded#IntelligenceRises>) | Intelligence |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``StrategyIsUnique`` | bridge | ``ExactlyOneSurvives``, ``StrategyGate`` | [3](<doc:AtlasUnfolded#StrategyIsUnique>) | Strategy |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``Reading`` | bridge | ``HasTime``, ``OrderIsOnlyFreedom``, ``RevealsNotCreates`` | [2](<doc:AtlasUnfolded#Reading>) | Reading |
| ``RulesCompose`` | bridge | ``KnowledgeAccumulates`` | [2](<doc:AtlasUnfolded#RulesCompose>) | Basis |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``AmbiguityIsExperiment`` | bridge | ``HolesCarryAddresses``, ``LawIsTarget`` | [1](<doc:AtlasUnfolded#AmbiguityIsExperiment>) | Dynamics |
| ``AtomBasis`` | bridge | ``BasisIsFinite``, ``HasCompositionalNorm``, ``RulesCompose`` | [1](<doc:AtlasUnfolded#AtomBasis>) | Basis |
| ``BehaviorIsStructure`` | bridge | ``DistanceOnStructures``, ``HasTime`` | [1](<doc:AtlasUnfolded#BehaviorIsStructure>) | Dynamics |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``GatedConstruction`` | bridge | ``EmissionAccumulates``, ``SystemCrystallizes`` | [1](<doc:AtlasUnfolded#GatedConstruction>) | Path |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``RepairsPermanent`` | bridge | ``AnchorGraph``, ``NoInverse`` | [1](<doc:AtlasUnfolded#RepairsPermanent>) | Map |
| ``StandardIsType`` | bridge | ``PresentedLaw`` | [1](<doc:AtlasUnfolded#StandardIsType>) | Ruler |
| ``AgentPathCertified`` | theorem | ``IdentityCollapse``, ``PassIsIdentification`` | 0 | Intelligence |
| ``AlignmentEnablesIntelligence`` | bridge | ``AlignmentCoefficient``, ``IntelligenceRises`` | 0 | Search |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``AtomnessIsTrajectory`` | bridge | ``AtomBasis``, ``NoInverse`` | 0 | Basis |
| ``CacheOnlyGrows`` | theorem | ``CachePermanent``, ``StepsTerminate`` | 0 | Identification |
| ``CommunicationBounded`` | theorem | ``ComparisonsAreBounded``, ``HasCache`` | 0 | Space |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``CompletionIsSolutionSet`` | bridge | ``HasPath``, ``Reading`` | 0 | Path |
| ``ConstructionIsReading`` | bridge | ``EmissionAccumulates``, ``Reading`` | 0 | Path |
| ``Converges`` | bridge | ``NoInverse``, ``SystemCrystallizes`` | 0 | Matter |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DiagnosticsAccumulate`` | theorem | ``CachePermanent``, ``ResultDeterministic`` | 0 | Identification |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``DiscoveryIsRevelation`` | bridge | ``ExactlyOneSurvives``, ``LibrarySaturates`` | 0 | Intelligence |
| ``DistanceIsCost`` | bridge | ``DistanceOnStructures``, ``HasCost`` | 0 | Gradient |
| ``EdgesCarryTheJudgement`` | bridge | ``BehaviorIsStructure``, ``PresentedLaw`` | 0 | Presentation |
| ``EncodingSelectionSaturates`` | bridge | ``HasEncoding``, ``LibrarySaturates`` | 0 | Intelligence |
| ``ErasureIsRecession`` | bridge | ``EmissionAccumulates``, ``NoInverse`` | 0 | Path |
| ``FailureCurriculum`` | bridge | ``HolesCarryAddresses``, ``RepairsPermanent`` | 0 | Map |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``FormIsInvariant`` | bridge | ``PresentedLaw`` | 0 | Presentation |
| ``FreeGeneration`` | bridge | ``DiscriminatorAndGenerator``, ``EmissionAccumulates`` | 0 | Path |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``GaugeFixing`` | bridge | ``CostReadsGauge``, ``SystemCrystallizes`` | 0 | Gauge |
| ``GradientInComparison`` | theorem | ``Decidable``, ``DistanceOnStructures`` | 0 | Gradient |
| ``GreedyDescentTerminates`` | bridge | ``AnchorGraph``, ``Monotone`` | 0 | Map |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``InterferenceIsIntelligence`` | bridge | ``IntelligenceRises``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``IsIsYIdentity`` | bridge | ``OrderIsOnlyFreedom``, ``PassIsIdentification`` | 0 | Interference |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``LibraryCrystallizes`` | bridge | ``LibrarySaturates``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``MeasureIsCount`` | bridge | ``StandardIsType`` | 0 | Ruler |
| ``NullIsOrigin`` | theorem | ``DistanceOnStructures``, ``Null`` | 0 | Gradient |
| ``OrderByDistance`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | 0 | Gradient |
| ``OrgansAreOneCompare`` | bridge | ``Decidable``, ``DiscriminatorAndGenerator`` | 0 | Generation |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``PipelineCrystallizes`` | bridge | ``PassIsIdentification``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``PreconditionsGuaranteePass`` | theorem | ``ExactlyOneSurvives`` | 0 | Identification |
| ``PressIsIdentification`` | bridge | ``PassIsIdentification``, ``PresentedLaw`` | 0 | Presentation |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |
| ``ResistanceHasMagnitude`` | theorem | ``DistanceOnStructures``, ``Resistant`` | 0 | Gradient |
| ``SaturationDynamics`` | bridge | ``ComparisonsAreBounded``, ``LibrarySaturates`` | 0 | Intelligence |
| ``SaturationIncorruptible`` | theorem | ``CachePermanent`` | 0 | Identification |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |
| ``ThreeAxesOfCompare`` | bridge | ``Decidable``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``Universality`` | bridge | ``ExactlyOneSurvives``, ``HasEncoding`` | 0 | Identification |

### OperationsClosed

``OperationsClosed`` carries 97 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``CachePermanent`` | theorem | ``HasCache``, ``OperationsClosed``, ``StructuresFinite`` | [82](<doc:AtlasUnfolded#CachePermanent>) | Identification |
| ``ResultDeterministic`` | kernel | ``OperationsClosed`` | [67](<doc:AtlasUnfolded#ResultDeterministic>) | Identification |
| ``PassImpliesMembership`` | kernel | ``PipelineTotal``, ``ResultDeterministic`` | [51](<doc:AtlasUnfolded#PassImpliesMembership>) | Identification |
| ``KnowledgeAccumulates`` | bridge | ``CachePermanent``, ``HasLibrary`` | [45](<doc:AtlasUnfolded#KnowledgeAccumulates>) | Intelligence |
| ``LibrarySaturates`` | bridge | ``CachePermanent``, ``HasSaturation`` | [38](<doc:AtlasUnfolded#LibrarySaturates>) | Intelligence |
| ``PassIsIdentification`` | theorem | ``ExactlyOneSurvives``, ``PassImpliesMembership`` | [37](<doc:AtlasUnfolded#PassIsIdentification>) | Identification |
| ``AxesCoOriented`` | theorem | ``CachePermanent``, ``ResultDeterministic`` | [27](<doc:AtlasUnfolded#AxesCoOriented>) | Identification |
| ``Matter`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification``, ``Resistant`` | [26](<doc:AtlasUnfolded#Matter>) | Matter |
| ``OrderIsOnlyFreedom`` | bridge | ``AxesCoOriented``, ``IdentityCollapse`` | [26](<doc:AtlasUnfolded#OrderIsOnlyFreedom>) | Identification |
| ``Ignites`` | bridge | ``LibrarySaturates``, ``Matter`` | [22](<doc:AtlasUnfolded#Ignites>) | Matter |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``BallSaturation`` | bridge | ``DistanceOnStructures``, ``LibrarySaturates`` | [15](<doc:AtlasUnfolded#BallSaturation>) | Gradient |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``GateIsZeroOfLoss`` | theorem | ``DistanceOnStructures``, ``PassImpliesMembership`` | [12](<doc:AtlasUnfolded#GateIsZeroOfLoss>) | Gradient |
| ``StrategyLivesInSigma`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | [12](<doc:AtlasUnfolded#StrategyLivesInSigma>) | Strategy |
| ``AlignmentCoefficient`` | bridge | ``GateIsZeroOfLoss``, ``HasAlpha`` | [11](<doc:AtlasUnfolded#AlignmentCoefficient>) | Search |
| ``NoInverse`` | bridge | ``KnowledgeAccumulates`` | [11](<doc:AtlasUnfolded#NoInverse>) | Matter |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``BasisIsFinite`` | bridge | ``HasBasis``, ``LibrarySaturates`` | [7](<doc:AtlasUnfolded#BasisIsFinite>) | Intelligence |
| ``CandidatesOnlyLeave`` | bridge | ``CachePermanent``, ``HasSolutions`` | [7](<doc:AtlasUnfolded#CandidatesOnlyLeave>) | Identification |
| ``LiquidPhase`` | bridge | ``KnowledgeAccumulates``, ``Monotone`` | [7](<doc:AtlasUnfolded#LiquidPhase>) | Liquid |
| ``ResultsIrreversible`` | theorem | ``CachePermanent``, ``EqualityDecidable`` | [7](<doc:AtlasUnfolded#ResultsIrreversible>) | Intelligence |
| ``CertifiedRuleGenerates`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification`` | [6](<doc:AtlasUnfolded#CertifiedRuleGenerates>) | Play |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``SystemCrystallizes`` | bridge | ``CandidatesOnlyLeave``, ``MembershipDecidable``, ``ResultsIrreversible`` | [6](<doc:AtlasUnfolded#SystemCrystallizes>) | Intelligence |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``CrystallizationFront`` | bridge | ``DistanceOnStructures``, ``LiquidPhase``, ``NoInverse`` | [5](<doc:AtlasUnfolded#CrystallizationFront>) | Liquid |
| ``DiscriminatorAndGenerator`` | bridge | ``OrderIsOnlyFreedom``, ``PassImpliesMembership`` | [5](<doc:AtlasUnfolded#DiscriminatorAndGenerator>) | Generation |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
| ``RevealsNotCreates`` | kernel | ``Measurable``, ``OperationsClosed`` | [5](<doc:AtlasUnfolded#RevealsNotCreates>) | Identification |
| ``ScopeBoundedByEncoding`` | kernel | ``ResultDeterministic`` | [5](<doc:AtlasUnfolded#ScopeBoundedByEncoding>) | Identification |
| ``SearchFlow`` | bridge | ``AlignmentCoefficient``, ``LiquidPhase`` | [5](<doc:AtlasUnfolded#SearchFlow>) | Liquid |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``StefanCoupling`` | bridge | ``CrystallizationFront``, ``SearchFlow`` | [4](<doc:AtlasUnfolded#StefanCoupling>) | Liquid |
| ``StrategyGate`` | bridge | ``PassImpliesMembership``, ``StrategyLivesInSigma`` | [4](<doc:AtlasUnfolded#StrategyGate>) | Strategy |
| ``GateIsMembrane`` | bridge | ``StefanCoupling`` | [3](<doc:AtlasUnfolded#GateIsMembrane>) | Liquid |
| ``IntelligenceRises`` | bridge | ``HasEfficiency``, ``LibrarySaturates`` | [3](<doc:AtlasUnfolded#IntelligenceRises>) | Intelligence |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``StrategyIsUnique`` | bridge | ``ExactlyOneSurvives``, ``StrategyGate`` | [3](<doc:AtlasUnfolded#StrategyIsUnique>) | Strategy |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``Reading`` | bridge | ``HasTime``, ``OrderIsOnlyFreedom``, ``RevealsNotCreates`` | [2](<doc:AtlasUnfolded#Reading>) | Reading |
| ``RulesCompose`` | bridge | ``KnowledgeAccumulates`` | [2](<doc:AtlasUnfolded#RulesCompose>) | Basis |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``AmbiguityIsExperiment`` | bridge | ``HolesCarryAddresses``, ``LawIsTarget`` | [1](<doc:AtlasUnfolded#AmbiguityIsExperiment>) | Dynamics |
| ``AtomBasis`` | bridge | ``BasisIsFinite``, ``HasCompositionalNorm``, ``RulesCompose`` | [1](<doc:AtlasUnfolded#AtomBasis>) | Basis |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``EmissionIsAutoregressive`` | bridge | ``HasEncoding``, ``HasPath``, ``ScopeBoundedByEncoding`` | [1](<doc:AtlasUnfolded#EmissionIsAutoregressive>) | Path |
| ``GatedConstruction`` | bridge | ``EmissionAccumulates``, ``SystemCrystallizes`` | [1](<doc:AtlasUnfolded#GatedConstruction>) | Path |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``RepairsPermanent`` | bridge | ``AnchorGraph``, ``NoInverse`` | [1](<doc:AtlasUnfolded#RepairsPermanent>) | Map |
| ``AgentPathCertified`` | theorem | ``IdentityCollapse``, ``PassIsIdentification`` | 0 | Intelligence |
| ``AlignmentEnablesIntelligence`` | bridge | ``AlignmentCoefficient``, ``IntelligenceRises`` | 0 | Search |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``AtomnessIsTrajectory`` | bridge | ``AtomBasis``, ``NoInverse`` | 0 | Basis |
| ``CacheOnlyGrows`` | theorem | ``CachePermanent``, ``StepsTerminate`` | 0 | Identification |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``CompletionIsSolutionSet`` | bridge | ``HasPath``, ``Reading`` | 0 | Path |
| ``ConstructionIsReading`` | bridge | ``EmissionAccumulates``, ``Reading`` | 0 | Path |
| ``Converges`` | bridge | ``NoInverse``, ``SystemCrystallizes`` | 0 | Matter |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DiagnosticsAccumulate`` | theorem | ``CachePermanent``, ``ResultDeterministic`` | 0 | Identification |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``DiscoveryIsRevelation`` | bridge | ``ExactlyOneSurvives``, ``LibrarySaturates`` | 0 | Intelligence |
| ``EncodingSelectionSaturates`` | bridge | ``HasEncoding``, ``LibrarySaturates`` | 0 | Intelligence |
| ``ErasureIsRecession`` | bridge | ``EmissionAccumulates``, ``NoInverse`` | 0 | Path |
| ``FailureCurriculum`` | bridge | ``HolesCarryAddresses``, ``RepairsPermanent`` | 0 | Map |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``FreeGeneration`` | bridge | ``DiscriminatorAndGenerator``, ``EmissionAccumulates`` | 0 | Path |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``GaugeFixing`` | bridge | ``CostReadsGauge``, ``SystemCrystallizes`` | 0 | Gauge |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``InterferenceIsIntelligence`` | bridge | ``IntelligenceRises``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``IsIsYIdentity`` | bridge | ``OrderIsOnlyFreedom``, ``PassIsIdentification`` | 0 | Interference |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``LibraryCrystallizes`` | bridge | ``LibrarySaturates``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``NoSelfReference`` | kernel | ``OperationsClosed`` | 0 | Identification |
| ``OrderByDistance`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | 0 | Gradient |
| ``OrgansAreOneCompare`` | bridge | ``Decidable``, ``DiscriminatorAndGenerator`` | 0 | Generation |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``PerspectiveIsEncoding`` | theorem | ``HasEncoding``, ``Measurable``, ``ScopeBoundedByEncoding`` | 0 | Space |
| ``PipelineCrystallizes`` | bridge | ``PassIsIdentification``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``PressIsIdentification`` | bridge | ``PassIsIdentification``, ``PresentedLaw`` | 0 | Presentation |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |
| ``SaturationDynamics`` | bridge | ``ComparisonsAreBounded``, ``LibrarySaturates`` | 0 | Intelligence |
| ``SaturationIncorruptible`` | theorem | ``CachePermanent`` | 0 | Identification |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |
| ``ThreeAxesOfCompare`` | bridge | ``Decidable``, ``OrderIsOnlyFreedom`` | 0 | Interference |

### HasCache

``HasCache`` carries 86 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``CachePermanent`` | theorem | ``HasCache``, ``OperationsClosed``, ``StructuresFinite`` | [82](<doc:AtlasUnfolded#CachePermanent>) | Identification |
| ``KnowledgeAccumulates`` | bridge | ``CachePermanent``, ``HasLibrary`` | [45](<doc:AtlasUnfolded#KnowledgeAccumulates>) | Intelligence |
| ``LibrarySaturates`` | bridge | ``CachePermanent``, ``HasSaturation`` | [38](<doc:AtlasUnfolded#LibrarySaturates>) | Intelligence |
| ``AxesCoOriented`` | theorem | ``CachePermanent``, ``ResultDeterministic`` | [27](<doc:AtlasUnfolded#AxesCoOriented>) | Identification |
| ``Matter`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification``, ``Resistant`` | [26](<doc:AtlasUnfolded#Matter>) | Matter |
| ``OrderIsOnlyFreedom`` | bridge | ``AxesCoOriented``, ``IdentityCollapse`` | [26](<doc:AtlasUnfolded#OrderIsOnlyFreedom>) | Identification |
| ``Ignites`` | bridge | ``LibrarySaturates``, ``Matter`` | [22](<doc:AtlasUnfolded#Ignites>) | Matter |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``BallSaturation`` | bridge | ``DistanceOnStructures``, ``LibrarySaturates`` | [15](<doc:AtlasUnfolded#BallSaturation>) | Gradient |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``StrategyLivesInSigma`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | [12](<doc:AtlasUnfolded#StrategyLivesInSigma>) | Strategy |
| ``NoInverse`` | bridge | ``KnowledgeAccumulates`` | [11](<doc:AtlasUnfolded#NoInverse>) | Matter |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``BasisIsFinite`` | bridge | ``HasBasis``, ``LibrarySaturates`` | [7](<doc:AtlasUnfolded#BasisIsFinite>) | Intelligence |
| ``CandidatesOnlyLeave`` | bridge | ``CachePermanent``, ``HasSolutions`` | [7](<doc:AtlasUnfolded#CandidatesOnlyLeave>) | Identification |
| ``LiquidPhase`` | bridge | ``KnowledgeAccumulates``, ``Monotone`` | [7](<doc:AtlasUnfolded#LiquidPhase>) | Liquid |
| ``ResultsIrreversible`` | theorem | ``CachePermanent``, ``EqualityDecidable`` | [7](<doc:AtlasUnfolded#ResultsIrreversible>) | Intelligence |
| ``CertifiedRuleGenerates`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification`` | [6](<doc:AtlasUnfolded#CertifiedRuleGenerates>) | Play |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``SystemCrystallizes`` | bridge | ``CandidatesOnlyLeave``, ``MembershipDecidable``, ``ResultsIrreversible`` | [6](<doc:AtlasUnfolded#SystemCrystallizes>) | Intelligence |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``CrystallizationFront`` | bridge | ``DistanceOnStructures``, ``LiquidPhase``, ``NoInverse`` | [5](<doc:AtlasUnfolded#CrystallizationFront>) | Liquid |
| ``DiscriminatorAndGenerator`` | bridge | ``OrderIsOnlyFreedom``, ``PassImpliesMembership`` | [5](<doc:AtlasUnfolded#DiscriminatorAndGenerator>) | Generation |
| ``SearchFlow`` | bridge | ``AlignmentCoefficient``, ``LiquidPhase`` | [5](<doc:AtlasUnfolded#SearchFlow>) | Liquid |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``StefanCoupling`` | bridge | ``CrystallizationFront``, ``SearchFlow`` | [4](<doc:AtlasUnfolded#StefanCoupling>) | Liquid |
| ``StrategyGate`` | bridge | ``PassImpliesMembership``, ``StrategyLivesInSigma`` | [4](<doc:AtlasUnfolded#StrategyGate>) | Strategy |
| ``GateIsMembrane`` | bridge | ``StefanCoupling`` | [3](<doc:AtlasUnfolded#GateIsMembrane>) | Liquid |
| ``IntelligenceRises`` | bridge | ``HasEfficiency``, ``LibrarySaturates`` | [3](<doc:AtlasUnfolded#IntelligenceRises>) | Intelligence |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``StrategyIsUnique`` | bridge | ``ExactlyOneSurvives``, ``StrategyGate`` | [3](<doc:AtlasUnfolded#StrategyIsUnique>) | Strategy |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``Reading`` | bridge | ``HasTime``, ``OrderIsOnlyFreedom``, ``RevealsNotCreates`` | [2](<doc:AtlasUnfolded#Reading>) | Reading |
| ``RulesCompose`` | bridge | ``KnowledgeAccumulates`` | [2](<doc:AtlasUnfolded#RulesCompose>) | Basis |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``AtomBasis`` | bridge | ``BasisIsFinite``, ``HasCompositionalNorm``, ``RulesCompose`` | [1](<doc:AtlasUnfolded#AtomBasis>) | Basis |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``DistanceIsMetric`` | bridge | ``HasCache``, ``HasDistance`` | [1](<doc:AtlasUnfolded#DistanceIsMetric>) | Space |
| ``GatedConstruction`` | bridge | ``EmissionAccumulates``, ``SystemCrystallizes`` | [1](<doc:AtlasUnfolded#GatedConstruction>) | Path |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``RepairsPermanent`` | bridge | ``AnchorGraph``, ``NoInverse`` | [1](<doc:AtlasUnfolded#RepairsPermanent>) | Map |
| ``AlignmentEnablesIntelligence`` | bridge | ``AlignmentCoefficient``, ``IntelligenceRises`` | 0 | Search |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``AtomnessIsTrajectory`` | bridge | ``AtomBasis``, ``NoInverse`` | 0 | Basis |
| ``CacheOnlyGrows`` | theorem | ``CachePermanent``, ``StepsTerminate`` | 0 | Identification |
| ``CommunicationBounded`` | theorem | ``ComparisonsAreBounded``, ``HasCache`` | 0 | Space |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``CompletionIsSolutionSet`` | bridge | ``HasPath``, ``Reading`` | 0 | Path |
| ``ConstructionIsReading`` | bridge | ``EmissionAccumulates``, ``Reading`` | 0 | Path |
| ``Converges`` | bridge | ``NoInverse``, ``SystemCrystallizes`` | 0 | Matter |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DiagnosticsAccumulate`` | theorem | ``CachePermanent``, ``ResultDeterministic`` | 0 | Identification |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``DiscoveryIsRevelation`` | bridge | ``ExactlyOneSurvives``, ``LibrarySaturates`` | 0 | Intelligence |
| ``EncodingSelectionSaturates`` | bridge | ``HasEncoding``, ``LibrarySaturates`` | 0 | Intelligence |
| ``ErasureIsRecession`` | bridge | ``EmissionAccumulates``, ``NoInverse`` | 0 | Path |
| ``FailureCurriculum`` | bridge | ``HolesCarryAddresses``, ``RepairsPermanent`` | 0 | Map |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``FreeGeneration`` | bridge | ``DiscriminatorAndGenerator``, ``EmissionAccumulates`` | 0 | Path |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``GaugeFixing`` | bridge | ``CostReadsGauge``, ``SystemCrystallizes`` | 0 | Gauge |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``InterferenceIsIntelligence`` | bridge | ``IntelligenceRises``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``IsIsYIdentity`` | bridge | ``OrderIsOnlyFreedom``, ``PassIsIdentification`` | 0 | Interference |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``LibraryCrystallizes`` | bridge | ``LibrarySaturates``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``OrderByDistance`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | 0 | Gradient |
| ``OrgansAreOneCompare`` | bridge | ``Decidable``, ``DiscriminatorAndGenerator`` | 0 | Generation |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``PipelineCrystallizes`` | bridge | ``PassIsIdentification``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |
| ``SaturationDynamics`` | bridge | ``ComparisonsAreBounded``, ``LibrarySaturates`` | 0 | Intelligence |
| ``SaturationIncorruptible`` | theorem | ``CachePermanent`` | 0 | Identification |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``SpaceFromDifference`` | bridge | ``DistanceIsMetric``, ``HasGrammar`` | 0 | Space |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |
| ``ThreeAxesOfCompare`` | bridge | ``Decidable``, ``OrderIsOnlyFreedom`` | 0 | Interference |

### CachePermanent

``CachePermanent`` carries 82 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``KnowledgeAccumulates`` | bridge | ``CachePermanent``, ``HasLibrary`` | [45](<doc:AtlasUnfolded#KnowledgeAccumulates>) | Intelligence |
| ``LibrarySaturates`` | bridge | ``CachePermanent``, ``HasSaturation`` | [38](<doc:AtlasUnfolded#LibrarySaturates>) | Intelligence |
| ``AxesCoOriented`` | theorem | ``CachePermanent``, ``ResultDeterministic`` | [27](<doc:AtlasUnfolded#AxesCoOriented>) | Identification |
| ``Matter`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification``, ``Resistant`` | [26](<doc:AtlasUnfolded#Matter>) | Matter |
| ``OrderIsOnlyFreedom`` | bridge | ``AxesCoOriented``, ``IdentityCollapse`` | [26](<doc:AtlasUnfolded#OrderIsOnlyFreedom>) | Identification |
| ``Ignites`` | bridge | ``LibrarySaturates``, ``Matter`` | [22](<doc:AtlasUnfolded#Ignites>) | Matter |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``BallSaturation`` | bridge | ``DistanceOnStructures``, ``LibrarySaturates`` | [15](<doc:AtlasUnfolded#BallSaturation>) | Gradient |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``StrategyLivesInSigma`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | [12](<doc:AtlasUnfolded#StrategyLivesInSigma>) | Strategy |
| ``NoInverse`` | bridge | ``KnowledgeAccumulates`` | [11](<doc:AtlasUnfolded#NoInverse>) | Matter |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``BasisIsFinite`` | bridge | ``HasBasis``, ``LibrarySaturates`` | [7](<doc:AtlasUnfolded#BasisIsFinite>) | Intelligence |
| ``CandidatesOnlyLeave`` | bridge | ``CachePermanent``, ``HasSolutions`` | [7](<doc:AtlasUnfolded#CandidatesOnlyLeave>) | Identification |
| ``LiquidPhase`` | bridge | ``KnowledgeAccumulates``, ``Monotone`` | [7](<doc:AtlasUnfolded#LiquidPhase>) | Liquid |
| ``ResultsIrreversible`` | theorem | ``CachePermanent``, ``EqualityDecidable`` | [7](<doc:AtlasUnfolded#ResultsIrreversible>) | Intelligence |
| ``CertifiedRuleGenerates`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification`` | [6](<doc:AtlasUnfolded#CertifiedRuleGenerates>) | Play |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``SystemCrystallizes`` | bridge | ``CandidatesOnlyLeave``, ``MembershipDecidable``, ``ResultsIrreversible`` | [6](<doc:AtlasUnfolded#SystemCrystallizes>) | Intelligence |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``CrystallizationFront`` | bridge | ``DistanceOnStructures``, ``LiquidPhase``, ``NoInverse`` | [5](<doc:AtlasUnfolded#CrystallizationFront>) | Liquid |
| ``DiscriminatorAndGenerator`` | bridge | ``OrderIsOnlyFreedom``, ``PassImpliesMembership`` | [5](<doc:AtlasUnfolded#DiscriminatorAndGenerator>) | Generation |
| ``SearchFlow`` | bridge | ``AlignmentCoefficient``, ``LiquidPhase`` | [5](<doc:AtlasUnfolded#SearchFlow>) | Liquid |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``StefanCoupling`` | bridge | ``CrystallizationFront``, ``SearchFlow`` | [4](<doc:AtlasUnfolded#StefanCoupling>) | Liquid |
| ``StrategyGate`` | bridge | ``PassImpliesMembership``, ``StrategyLivesInSigma`` | [4](<doc:AtlasUnfolded#StrategyGate>) | Strategy |
| ``GateIsMembrane`` | bridge | ``StefanCoupling`` | [3](<doc:AtlasUnfolded#GateIsMembrane>) | Liquid |
| ``IntelligenceRises`` | bridge | ``HasEfficiency``, ``LibrarySaturates`` | [3](<doc:AtlasUnfolded#IntelligenceRises>) | Intelligence |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``StrategyIsUnique`` | bridge | ``ExactlyOneSurvives``, ``StrategyGate`` | [3](<doc:AtlasUnfolded#StrategyIsUnique>) | Strategy |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``Reading`` | bridge | ``HasTime``, ``OrderIsOnlyFreedom``, ``RevealsNotCreates`` | [2](<doc:AtlasUnfolded#Reading>) | Reading |
| ``RulesCompose`` | bridge | ``KnowledgeAccumulates`` | [2](<doc:AtlasUnfolded#RulesCompose>) | Basis |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``AtomBasis`` | bridge | ``BasisIsFinite``, ``HasCompositionalNorm``, ``RulesCompose`` | [1](<doc:AtlasUnfolded#AtomBasis>) | Basis |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``GatedConstruction`` | bridge | ``EmissionAccumulates``, ``SystemCrystallizes`` | [1](<doc:AtlasUnfolded#GatedConstruction>) | Path |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``RepairsPermanent`` | bridge | ``AnchorGraph``, ``NoInverse`` | [1](<doc:AtlasUnfolded#RepairsPermanent>) | Map |
| ``AlignmentEnablesIntelligence`` | bridge | ``AlignmentCoefficient``, ``IntelligenceRises`` | 0 | Search |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``AtomnessIsTrajectory`` | bridge | ``AtomBasis``, ``NoInverse`` | 0 | Basis |
| ``CacheOnlyGrows`` | theorem | ``CachePermanent``, ``StepsTerminate`` | 0 | Identification |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``CompletionIsSolutionSet`` | bridge | ``HasPath``, ``Reading`` | 0 | Path |
| ``ConstructionIsReading`` | bridge | ``EmissionAccumulates``, ``Reading`` | 0 | Path |
| ``Converges`` | bridge | ``NoInverse``, ``SystemCrystallizes`` | 0 | Matter |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DiagnosticsAccumulate`` | theorem | ``CachePermanent``, ``ResultDeterministic`` | 0 | Identification |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``DiscoveryIsRevelation`` | bridge | ``ExactlyOneSurvives``, ``LibrarySaturates`` | 0 | Intelligence |
| ``EncodingSelectionSaturates`` | bridge | ``HasEncoding``, ``LibrarySaturates`` | 0 | Intelligence |
| ``ErasureIsRecession`` | bridge | ``EmissionAccumulates``, ``NoInverse`` | 0 | Path |
| ``FailureCurriculum`` | bridge | ``HolesCarryAddresses``, ``RepairsPermanent`` | 0 | Map |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``FreeGeneration`` | bridge | ``DiscriminatorAndGenerator``, ``EmissionAccumulates`` | 0 | Path |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``GaugeFixing`` | bridge | ``CostReadsGauge``, ``SystemCrystallizes`` | 0 | Gauge |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``InterferenceIsIntelligence`` | bridge | ``IntelligenceRises``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``IsIsYIdentity`` | bridge | ``OrderIsOnlyFreedom``, ``PassIsIdentification`` | 0 | Interference |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``LibraryCrystallizes`` | bridge | ``LibrarySaturates``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``OrderByDistance`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | 0 | Gradient |
| ``OrgansAreOneCompare`` | bridge | ``Decidable``, ``DiscriminatorAndGenerator`` | 0 | Generation |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``PipelineCrystallizes`` | bridge | ``PassIsIdentification``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |
| ``SaturationDynamics`` | bridge | ``ComparisonsAreBounded``, ``LibrarySaturates`` | 0 | Intelligence |
| ``SaturationIncorruptible`` | theorem | ``CachePermanent`` | 0 | Identification |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |
| ``ThreeAxesOfCompare`` | bridge | ``Decidable``, ``OrderIsOnlyFreedom`` | 0 | Interference |

### HasDistance

``HasDistance`` carries 76 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``DistanceOnStructures`` | theorem | ``HasDistance``, ``StructuresFinite`` | [59](<doc:AtlasUnfolded#DistanceOnStructures>) | Gradient |
| ``Resistant`` | theorem | ``Decidable``, ``HasDistance`` | [28](<doc:AtlasUnfolded#Resistant>) | Matter |
| ``Matter`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification``, ``Resistant`` | [26](<doc:AtlasUnfolded#Matter>) | Matter |
| ``AnchorGraph`` | bridge | ``DistanceOnStructures``, ``HasLibrary`` | [22](<doc:AtlasUnfolded#AnchorGraph>) | Map |
| ``Ignites`` | bridge | ``LibrarySaturates``, ``Matter`` | [22](<doc:AtlasUnfolded#Ignites>) | Matter |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``BallSaturation`` | bridge | ``DistanceOnStructures``, ``LibrarySaturates`` | [15](<doc:AtlasUnfolded#BallSaturation>) | Gradient |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``GateIsZeroOfLoss`` | theorem | ``DistanceOnStructures``, ``PassImpliesMembership`` | [12](<doc:AtlasUnfolded#GateIsZeroOfLoss>) | Gradient |
| ``HasAlpha`` | axis | ``HasDistance`` | [12](<doc:AtlasUnfolded#HasAlpha>) | Core |
| ``StrategyLivesInSigma`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | [12](<doc:AtlasUnfolded#StrategyLivesInSigma>) | Strategy |
| ``AlignmentCoefficient`` | bridge | ``GateIsZeroOfLoss``, ``HasAlpha`` | [11](<doc:AtlasUnfolded#AlignmentCoefficient>) | Search |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``HolesCarryAddresses`` | bridge | ``AnchorGraph``, ``Decidable`` | [9](<doc:AtlasUnfolded#HolesCarryAddresses>) | Map |
| ``LawLivesInSigma`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [6](<doc:AtlasUnfolded#LawLivesInSigma>) | Dynamics |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``CrystallizationFront`` | bridge | ``DistanceOnStructures``, ``LiquidPhase``, ``NoInverse`` | [5](<doc:AtlasUnfolded#CrystallizationFront>) | Liquid |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
| ``PresentedLaw`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [5](<doc:AtlasUnfolded#PresentedLaw>) | Presentation |
| ``SearchFlow`` | bridge | ``AlignmentCoefficient``, ``LiquidPhase`` | [5](<doc:AtlasUnfolded#SearchFlow>) | Liquid |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``StefanCoupling`` | bridge | ``CrystallizationFront``, ``SearchFlow`` | [4](<doc:AtlasUnfolded#StefanCoupling>) | Liquid |
| ``StrategyGate`` | bridge | ``PassImpliesMembership``, ``StrategyLivesInSigma`` | [4](<doc:AtlasUnfolded#StrategyGate>) | Strategy |
| ``GateIsMembrane`` | bridge | ``StefanCoupling`` | [3](<doc:AtlasUnfolded#GateIsMembrane>) | Liquid |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``StrategyIsUnique`` | bridge | ``ExactlyOneSurvives``, ``StrategyGate`` | [3](<doc:AtlasUnfolded#StrategyIsUnique>) | Strategy |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``HasCompositionalNorm`` | axis | ``HasDistance`` | [2](<doc:AtlasUnfolded#HasCompositionalNorm>) | Basis |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``AmbiguityIsExperiment`` | bridge | ``HolesCarryAddresses``, ``LawIsTarget`` | [1](<doc:AtlasUnfolded#AmbiguityIsExperiment>) | Dynamics |
| ``AtomBasis`` | bridge | ``BasisIsFinite``, ``HasCompositionalNorm``, ``RulesCompose`` | [1](<doc:AtlasUnfolded#AtomBasis>) | Basis |
| ``BehaviorIsStructure`` | bridge | ``DistanceOnStructures``, ``HasTime`` | [1](<doc:AtlasUnfolded#BehaviorIsStructure>) | Dynamics |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``CostIsPathLength`` | bridge | ``HasDistance``, ``HasPath`` | [1](<doc:AtlasUnfolded#CostIsPathLength>) | Path |
| ``CostReadsGauge`` | bridge | ``HasDistance``, ``HasGauge``, ``PredicateReading`` | [1](<doc:AtlasUnfolded#CostReadsGauge>) | Gauge |
| ``DistanceIsMetric`` | bridge | ``HasCache``, ``HasDistance`` | [1](<doc:AtlasUnfolded#DistanceIsMetric>) | Space |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``RepairsPermanent`` | bridge | ``AnchorGraph``, ``NoInverse`` | [1](<doc:AtlasUnfolded#RepairsPermanent>) | Map |
| ``StandardIsType`` | bridge | ``PresentedLaw`` | [1](<doc:AtlasUnfolded#StandardIsType>) | Ruler |
| ``AlignmentEnablesIntelligence`` | bridge | ``AlignmentCoefficient``, ``IntelligenceRises`` | 0 | Search |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``AtomnessIsTrajectory`` | bridge | ``AtomBasis``, ``NoInverse`` | 0 | Basis |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``DistanceIsCost`` | bridge | ``DistanceOnStructures``, ``HasCost`` | 0 | Gradient |
| ``EdgesCarryTheJudgement`` | bridge | ``BehaviorIsStructure``, ``PresentedLaw`` | 0 | Presentation |
| ``FailureCurriculum`` | bridge | ``HolesCarryAddresses``, ``RepairsPermanent`` | 0 | Map |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``FormIsInvariant`` | bridge | ``PresentedLaw`` | 0 | Presentation |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``CostIsPathLength`` | 0 | Gauge |
| ``GaugeFixing`` | bridge | ``CostReadsGauge``, ``SystemCrystallizes`` | 0 | Gauge |
| ``GradientInComparison`` | theorem | ``Decidable``, ``DistanceOnStructures`` | 0 | Gradient |
| ``GreedyDescentTerminates`` | bridge | ``AnchorGraph``, ``Monotone`` | 0 | Map |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``MeasureIsCount`` | bridge | ``StandardIsType`` | 0 | Ruler |
| ``NullIsOrigin`` | theorem | ``DistanceOnStructures``, ``Null`` | 0 | Gradient |
| ``OrderByDistance`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | 0 | Gradient |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``PressIsIdentification`` | bridge | ``PassIsIdentification``, ``PresentedLaw`` | 0 | Presentation |
| ``ResistanceHasMagnitude`` | theorem | ``DistanceOnStructures``, ``Resistant`` | 0 | Gradient |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``SpaceFromDifference`` | bridge | ``DistanceIsMetric``, ``HasGrammar`` | 0 | Space |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |

### HasSolutions

``HasSolutions`` carries 67 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``ExactlyOneSurvives`` | theorem | ``EqualityDecidable``, ``HasSolutions`` | [42](<doc:AtlasUnfolded#ExactlyOneSurvives>) | Identification |
| ``PassIsIdentification`` | theorem | ``ExactlyOneSurvives``, ``PassImpliesMembership`` | [37](<doc:AtlasUnfolded#PassIsIdentification>) | Identification |
| ``IdentityCollapse`` | theorem | ``HasSolutions``, ``Null`` | [28](<doc:AtlasUnfolded#IdentityCollapse>) | Core |
| ``Matter`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification``, ``Resistant`` | [26](<doc:AtlasUnfolded#Matter>) | Matter |
| ``OrderIsOnlyFreedom`` | bridge | ``AxesCoOriented``, ``IdentityCollapse`` | [26](<doc:AtlasUnfolded#OrderIsOnlyFreedom>) | Identification |
| ``Ignites`` | bridge | ``LibrarySaturates``, ``Matter`` | [22](<doc:AtlasUnfolded#Ignites>) | Matter |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``StrategyLivesInSigma`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | [12](<doc:AtlasUnfolded#StrategyLivesInSigma>) | Strategy |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``CandidatesOnlyLeave`` | bridge | ``CachePermanent``, ``HasSolutions`` | [7](<doc:AtlasUnfolded#CandidatesOnlyLeave>) | Identification |
| ``MembershipDecidable`` | theorem | ``EqualityDecidable``, ``HasSolutions`` | [7](<doc:AtlasUnfolded#MembershipDecidable>) | Intelligence |
| ``CertifiedRuleGenerates`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification`` | [6](<doc:AtlasUnfolded#CertifiedRuleGenerates>) | Play |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``SystemCrystallizes`` | bridge | ``CandidatesOnlyLeave``, ``MembershipDecidable``, ``ResultsIrreversible`` | [6](<doc:AtlasUnfolded#SystemCrystallizes>) | Intelligence |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``DiscriminatorAndGenerator`` | bridge | ``OrderIsOnlyFreedom``, ``PassImpliesMembership`` | [5](<doc:AtlasUnfolded#DiscriminatorAndGenerator>) | Generation |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``StrategyGate`` | bridge | ``PassImpliesMembership``, ``StrategyLivesInSigma`` | [4](<doc:AtlasUnfolded#StrategyGate>) | Strategy |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``StrategyIsUnique`` | bridge | ``ExactlyOneSurvives``, ``StrategyGate`` | [3](<doc:AtlasUnfolded#StrategyIsUnique>) | Strategy |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``Reading`` | bridge | ``HasTime``, ``OrderIsOnlyFreedom``, ``RevealsNotCreates`` | [2](<doc:AtlasUnfolded#Reading>) | Reading |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``AmbiguityIsExperiment`` | bridge | ``HolesCarryAddresses``, ``LawIsTarget`` | [1](<doc:AtlasUnfolded#AmbiguityIsExperiment>) | Dynamics |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``GatedConstruction`` | bridge | ``EmissionAccumulates``, ``SystemCrystallizes`` | [1](<doc:AtlasUnfolded#GatedConstruction>) | Path |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AgentPathCertified`` | theorem | ``IdentityCollapse``, ``PassIsIdentification`` | 0 | Intelligence |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``CompletionIsSolutionSet`` | bridge | ``HasPath``, ``Reading`` | 0 | Path |
| ``ConstructionIsReading`` | bridge | ``EmissionAccumulates``, ``Reading`` | 0 | Path |
| ``Converges`` | bridge | ``NoInverse``, ``SystemCrystallizes`` | 0 | Matter |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``DiscoveryIsRevelation`` | bridge | ``ExactlyOneSurvives``, ``LibrarySaturates`` | 0 | Intelligence |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``FreeGeneration`` | bridge | ``DiscriminatorAndGenerator``, ``EmissionAccumulates`` | 0 | Path |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``GaugeFixing`` | bridge | ``CostReadsGauge``, ``SystemCrystallizes`` | 0 | Gauge |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``InterferenceIsIntelligence`` | bridge | ``IntelligenceRises``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``IsIsYIdentity`` | bridge | ``OrderIsOnlyFreedom``, ``PassIsIdentification`` | 0 | Interference |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``LibraryCrystallizes`` | bridge | ``LibrarySaturates``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``OrderByDistance`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | 0 | Gradient |
| ``OrgansAreOneCompare`` | bridge | ``Decidable``, ``DiscriminatorAndGenerator`` | 0 | Generation |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``PipelineCrystallizes`` | bridge | ``PassIsIdentification``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``PreconditionsGuaranteePass`` | theorem | ``ExactlyOneSurvives`` | 0 | Identification |
| ``PressIsIdentification`` | bridge | ``PassIsIdentification``, ``PresentedLaw`` | 0 | Presentation |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |
| ``ThreeAxesOfCompare`` | bridge | ``Decidable``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``Universality`` | bridge | ``ExactlyOneSurvives``, ``HasEncoding`` | 0 | Identification |

### ResultDeterministic

``ResultDeterministic`` carries 67 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``PassImpliesMembership`` | kernel | ``PipelineTotal``, ``ResultDeterministic`` | [51](<doc:AtlasUnfolded#PassImpliesMembership>) | Identification |
| ``PassIsIdentification`` | theorem | ``ExactlyOneSurvives``, ``PassImpliesMembership`` | [37](<doc:AtlasUnfolded#PassIsIdentification>) | Identification |
| ``AxesCoOriented`` | theorem | ``CachePermanent``, ``ResultDeterministic`` | [27](<doc:AtlasUnfolded#AxesCoOriented>) | Identification |
| ``Matter`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification``, ``Resistant`` | [26](<doc:AtlasUnfolded#Matter>) | Matter |
| ``OrderIsOnlyFreedom`` | bridge | ``AxesCoOriented``, ``IdentityCollapse`` | [26](<doc:AtlasUnfolded#OrderIsOnlyFreedom>) | Identification |
| ``Ignites`` | bridge | ``LibrarySaturates``, ``Matter`` | [22](<doc:AtlasUnfolded#Ignites>) | Matter |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``GateIsZeroOfLoss`` | theorem | ``DistanceOnStructures``, ``PassImpliesMembership`` | [12](<doc:AtlasUnfolded#GateIsZeroOfLoss>) | Gradient |
| ``StrategyLivesInSigma`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | [12](<doc:AtlasUnfolded#StrategyLivesInSigma>) | Strategy |
| ``AlignmentCoefficient`` | bridge | ``GateIsZeroOfLoss``, ``HasAlpha`` | [11](<doc:AtlasUnfolded#AlignmentCoefficient>) | Search |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``CertifiedRuleGenerates`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification`` | [6](<doc:AtlasUnfolded#CertifiedRuleGenerates>) | Play |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``DiscriminatorAndGenerator`` | bridge | ``OrderIsOnlyFreedom``, ``PassImpliesMembership`` | [5](<doc:AtlasUnfolded#DiscriminatorAndGenerator>) | Generation |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
| ``ScopeBoundedByEncoding`` | kernel | ``ResultDeterministic`` | [5](<doc:AtlasUnfolded#ScopeBoundedByEncoding>) | Identification |
| ``SearchFlow`` | bridge | ``AlignmentCoefficient``, ``LiquidPhase`` | [5](<doc:AtlasUnfolded#SearchFlow>) | Liquid |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``StefanCoupling`` | bridge | ``CrystallizationFront``, ``SearchFlow`` | [4](<doc:AtlasUnfolded#StefanCoupling>) | Liquid |
| ``StrategyGate`` | bridge | ``PassImpliesMembership``, ``StrategyLivesInSigma`` | [4](<doc:AtlasUnfolded#StrategyGate>) | Strategy |
| ``GateIsMembrane`` | bridge | ``StefanCoupling`` | [3](<doc:AtlasUnfolded#GateIsMembrane>) | Liquid |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``StrategyIsUnique`` | bridge | ``ExactlyOneSurvives``, ``StrategyGate`` | [3](<doc:AtlasUnfolded#StrategyIsUnique>) | Strategy |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``Reading`` | bridge | ``HasTime``, ``OrderIsOnlyFreedom``, ``RevealsNotCreates`` | [2](<doc:AtlasUnfolded#Reading>) | Reading |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``AmbiguityIsExperiment`` | bridge | ``HolesCarryAddresses``, ``LawIsTarget`` | [1](<doc:AtlasUnfolded#AmbiguityIsExperiment>) | Dynamics |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``EmissionIsAutoregressive`` | bridge | ``HasEncoding``, ``HasPath``, ``ScopeBoundedByEncoding`` | [1](<doc:AtlasUnfolded#EmissionIsAutoregressive>) | Path |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AgentPathCertified`` | theorem | ``IdentityCollapse``, ``PassIsIdentification`` | 0 | Intelligence |
| ``AlignmentEnablesIntelligence`` | bridge | ``AlignmentCoefficient``, ``IntelligenceRises`` | 0 | Search |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``CompletionIsSolutionSet`` | bridge | ``HasPath``, ``Reading`` | 0 | Path |
| ``ConstructionIsReading`` | bridge | ``EmissionAccumulates``, ``Reading`` | 0 | Path |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DiagnosticsAccumulate`` | theorem | ``CachePermanent``, ``ResultDeterministic`` | 0 | Identification |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``FreeGeneration`` | bridge | ``DiscriminatorAndGenerator``, ``EmissionAccumulates`` | 0 | Path |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``InterferenceIsIntelligence`` | bridge | ``IntelligenceRises``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``IsIsYIdentity`` | bridge | ``OrderIsOnlyFreedom``, ``PassIsIdentification`` | 0 | Interference |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``OrderByDistance`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | 0 | Gradient |
| ``OrgansAreOneCompare`` | bridge | ``Decidable``, ``DiscriminatorAndGenerator`` | 0 | Generation |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``PerspectiveIsEncoding`` | theorem | ``HasEncoding``, ``Measurable``, ``ScopeBoundedByEncoding`` | 0 | Space |
| ``PipelineCrystallizes`` | bridge | ``PassIsIdentification``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``PressIsIdentification`` | bridge | ``PassIsIdentification``, ``PresentedLaw`` | 0 | Presentation |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |
| ``ThreeAxesOfCompare`` | bridge | ``Decidable``, ``OrderIsOnlyFreedom`` | 0 | Interference |

### HasLibrary

``HasLibrary`` carries 66 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``KnowledgeAccumulates`` | bridge | ``CachePermanent``, ``HasLibrary`` | [45](<doc:AtlasUnfolded#KnowledgeAccumulates>) | Intelligence |
| ``HasSaturation`` | axis | ``HasLibrary`` | [39](<doc:AtlasUnfolded#HasSaturation>) | Core |
| ``LibrarySaturates`` | bridge | ``CachePermanent``, ``HasSaturation`` | [38](<doc:AtlasUnfolded#LibrarySaturates>) | Intelligence |
| ``Matter`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification``, ``Resistant`` | [26](<doc:AtlasUnfolded#Matter>) | Matter |
| ``AnchorGraph`` | bridge | ``DistanceOnStructures``, ``HasLibrary`` | [22](<doc:AtlasUnfolded#AnchorGraph>) | Map |
| ``Ignites`` | bridge | ``LibrarySaturates``, ``Matter`` | [22](<doc:AtlasUnfolded#Ignites>) | Matter |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``BallSaturation`` | bridge | ``DistanceOnStructures``, ``LibrarySaturates`` | [15](<doc:AtlasUnfolded#BallSaturation>) | Gradient |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``NoInverse`` | bridge | ``KnowledgeAccumulates`` | [11](<doc:AtlasUnfolded#NoInverse>) | Matter |
| ``HasBasis`` | axis | ``HasLibrary`` | [10](<doc:AtlasUnfolded#HasBasis>) | Core |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``HolesCarryAddresses`` | bridge | ``AnchorGraph``, ``Decidable`` | [9](<doc:AtlasUnfolded#HolesCarryAddresses>) | Map |
| ``BasisIsFinite`` | bridge | ``HasBasis``, ``LibrarySaturates`` | [7](<doc:AtlasUnfolded#BasisIsFinite>) | Intelligence |
| ``LiquidPhase`` | bridge | ``KnowledgeAccumulates``, ``Monotone`` | [7](<doc:AtlasUnfolded#LiquidPhase>) | Liquid |
| ``CertifiedRuleGenerates`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification`` | [6](<doc:AtlasUnfolded#CertifiedRuleGenerates>) | Play |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``CrystallizationFront`` | bridge | ``DistanceOnStructures``, ``LiquidPhase``, ``NoInverse`` | [5](<doc:AtlasUnfolded#CrystallizationFront>) | Liquid |
| ``SearchFlow`` | bridge | ``AlignmentCoefficient``, ``LiquidPhase`` | [5](<doc:AtlasUnfolded#SearchFlow>) | Liquid |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``StefanCoupling`` | bridge | ``CrystallizationFront``, ``SearchFlow`` | [4](<doc:AtlasUnfolded#StefanCoupling>) | Liquid |
| ``GateIsMembrane`` | bridge | ``StefanCoupling`` | [3](<doc:AtlasUnfolded#GateIsMembrane>) | Liquid |
| ``IntelligenceRises`` | bridge | ``HasEfficiency``, ``LibrarySaturates`` | [3](<doc:AtlasUnfolded#IntelligenceRises>) | Intelligence |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``RulesCompose`` | bridge | ``KnowledgeAccumulates`` | [2](<doc:AtlasUnfolded#RulesCompose>) | Basis |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``AmbiguityIsExperiment`` | bridge | ``HolesCarryAddresses``, ``LawIsTarget`` | [1](<doc:AtlasUnfolded#AmbiguityIsExperiment>) | Dynamics |
| ``AtomBasis`` | bridge | ``BasisIsFinite``, ``HasCompositionalNorm``, ``RulesCompose`` | [1](<doc:AtlasUnfolded#AtomBasis>) | Basis |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``ReachIsPath`` | bridge | ``HasBasis``, ``HasPath`` | [1](<doc:AtlasUnfolded#ReachIsPath>) | Path |
| ``RepairsPermanent`` | bridge | ``AnchorGraph``, ``NoInverse`` | [1](<doc:AtlasUnfolded#RepairsPermanent>) | Map |
| ``AlignmentEnablesIntelligence`` | bridge | ``AlignmentCoefficient``, ``IntelligenceRises`` | 0 | Search |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``AtomnessIsTrajectory`` | bridge | ``AtomBasis``, ``NoInverse`` | 0 | Basis |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``Converges`` | bridge | ``NoInverse``, ``SystemCrystallizes`` | 0 | Matter |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``DiscoveryIsRevelation`` | bridge | ``ExactlyOneSurvives``, ``LibrarySaturates`` | 0 | Intelligence |
| ``EncodingSelectionSaturates`` | bridge | ``HasEncoding``, ``LibrarySaturates`` | 0 | Intelligence |
| ``ErasureIsRecession`` | bridge | ``EmissionAccumulates``, ``NoInverse`` | 0 | Path |
| ``FailureCurriculum`` | bridge | ``HolesCarryAddresses``, ``RepairsPermanent`` | 0 | Map |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``GreedyDescentTerminates`` | bridge | ``AnchorGraph``, ``Monotone`` | 0 | Map |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``InterferenceIsIntelligence`` | bridge | ``IntelligenceRises``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``LibraryCrystallizes`` | bridge | ``LibrarySaturates``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |
| ``SaturationDynamics`` | bridge | ``ComparisonsAreBounded``, ``LibrarySaturates`` | 0 | Intelligence |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |

### DistanceOnStructures

``DistanceOnStructures`` carries 59 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``AnchorGraph`` | bridge | ``DistanceOnStructures``, ``HasLibrary`` | [22](<doc:AtlasUnfolded#AnchorGraph>) | Map |
| ``BallSaturation`` | bridge | ``DistanceOnStructures``, ``LibrarySaturates`` | [15](<doc:AtlasUnfolded#BallSaturation>) | Gradient |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``GateIsZeroOfLoss`` | theorem | ``DistanceOnStructures``, ``PassImpliesMembership`` | [12](<doc:AtlasUnfolded#GateIsZeroOfLoss>) | Gradient |
| ``StrategyLivesInSigma`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | [12](<doc:AtlasUnfolded#StrategyLivesInSigma>) | Strategy |
| ``AlignmentCoefficient`` | bridge | ``GateIsZeroOfLoss``, ``HasAlpha`` | [11](<doc:AtlasUnfolded#AlignmentCoefficient>) | Search |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``HolesCarryAddresses`` | bridge | ``AnchorGraph``, ``Decidable`` | [9](<doc:AtlasUnfolded#HolesCarryAddresses>) | Map |
| ``LawLivesInSigma`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [6](<doc:AtlasUnfolded#LawLivesInSigma>) | Dynamics |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``CrystallizationFront`` | bridge | ``DistanceOnStructures``, ``LiquidPhase``, ``NoInverse`` | [5](<doc:AtlasUnfolded#CrystallizationFront>) | Liquid |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
| ``PresentedLaw`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [5](<doc:AtlasUnfolded#PresentedLaw>) | Presentation |
| ``SearchFlow`` | bridge | ``AlignmentCoefficient``, ``LiquidPhase`` | [5](<doc:AtlasUnfolded#SearchFlow>) | Liquid |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``StefanCoupling`` | bridge | ``CrystallizationFront``, ``SearchFlow`` | [4](<doc:AtlasUnfolded#StefanCoupling>) | Liquid |
| ``StrategyGate`` | bridge | ``PassImpliesMembership``, ``StrategyLivesInSigma`` | [4](<doc:AtlasUnfolded#StrategyGate>) | Strategy |
| ``GateIsMembrane`` | bridge | ``StefanCoupling`` | [3](<doc:AtlasUnfolded#GateIsMembrane>) | Liquid |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``StrategyIsUnique`` | bridge | ``ExactlyOneSurvives``, ``StrategyGate`` | [3](<doc:AtlasUnfolded#StrategyIsUnique>) | Strategy |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``AmbiguityIsExperiment`` | bridge | ``HolesCarryAddresses``, ``LawIsTarget`` | [1](<doc:AtlasUnfolded#AmbiguityIsExperiment>) | Dynamics |
| ``BehaviorIsStructure`` | bridge | ``DistanceOnStructures``, ``HasTime`` | [1](<doc:AtlasUnfolded#BehaviorIsStructure>) | Dynamics |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``RepairsPermanent`` | bridge | ``AnchorGraph``, ``NoInverse`` | [1](<doc:AtlasUnfolded#RepairsPermanent>) | Map |
| ``StandardIsType`` | bridge | ``PresentedLaw`` | [1](<doc:AtlasUnfolded#StandardIsType>) | Ruler |
| ``AlignmentEnablesIntelligence`` | bridge | ``AlignmentCoefficient``, ``IntelligenceRises`` | 0 | Search |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``DistanceIsCost`` | bridge | ``DistanceOnStructures``, ``HasCost`` | 0 | Gradient |
| ``EdgesCarryTheJudgement`` | bridge | ``BehaviorIsStructure``, ``PresentedLaw`` | 0 | Presentation |
| ``FailureCurriculum`` | bridge | ``HolesCarryAddresses``, ``RepairsPermanent`` | 0 | Map |
| ``FormIsInvariant`` | bridge | ``PresentedLaw`` | 0 | Presentation |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``GradientInComparison`` | theorem | ``Decidable``, ``DistanceOnStructures`` | 0 | Gradient |
| ``GreedyDescentTerminates`` | bridge | ``AnchorGraph``, ``Monotone`` | 0 | Map |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``MeasureIsCount`` | bridge | ``StandardIsType`` | 0 | Ruler |
| ``NullIsOrigin`` | theorem | ``DistanceOnStructures``, ``Null`` | 0 | Gradient |
| ``OrderByDistance`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | 0 | Gradient |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``PressIsIdentification`` | bridge | ``PassIsIdentification``, ``PresentedLaw`` | 0 | Presentation |
| ``ResistanceHasMagnitude`` | theorem | ``DistanceOnStructures``, ``Resistant`` | 0 | Gradient |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |

### StepsTerminate

``StepsTerminate`` carries 54 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``PipelineTotal`` | kernel | ``StepsTerminate`` | [52](<doc:AtlasUnfolded#PipelineTotal>) | Identification |
| ``PassImpliesMembership`` | kernel | ``PipelineTotal``, ``ResultDeterministic`` | [51](<doc:AtlasUnfolded#PassImpliesMembership>) | Identification |
| ``PassIsIdentification`` | theorem | ``ExactlyOneSurvives``, ``PassImpliesMembership`` | [37](<doc:AtlasUnfolded#PassIsIdentification>) | Identification |
| ``Matter`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification``, ``Resistant`` | [26](<doc:AtlasUnfolded#Matter>) | Matter |
| ``Ignites`` | bridge | ``LibrarySaturates``, ``Matter`` | [22](<doc:AtlasUnfolded#Ignites>) | Matter |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``GateIsZeroOfLoss`` | theorem | ``DistanceOnStructures``, ``PassImpliesMembership`` | [12](<doc:AtlasUnfolded#GateIsZeroOfLoss>) | Gradient |
| ``AlignmentCoefficient`` | bridge | ``GateIsZeroOfLoss``, ``HasAlpha`` | [11](<doc:AtlasUnfolded#AlignmentCoefficient>) | Search |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``CertifiedRuleGenerates`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification`` | [6](<doc:AtlasUnfolded#CertifiedRuleGenerates>) | Play |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``DiscriminatorAndGenerator`` | bridge | ``OrderIsOnlyFreedom``, ``PassImpliesMembership`` | [5](<doc:AtlasUnfolded#DiscriminatorAndGenerator>) | Generation |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
| ``SearchFlow`` | bridge | ``AlignmentCoefficient``, ``LiquidPhase`` | [5](<doc:AtlasUnfolded#SearchFlow>) | Liquid |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``StefanCoupling`` | bridge | ``CrystallizationFront``, ``SearchFlow`` | [4](<doc:AtlasUnfolded#StefanCoupling>) | Liquid |
| ``StrategyGate`` | bridge | ``PassImpliesMembership``, ``StrategyLivesInSigma`` | [4](<doc:AtlasUnfolded#StrategyGate>) | Strategy |
| ``GateIsMembrane`` | bridge | ``StefanCoupling`` | [3](<doc:AtlasUnfolded#GateIsMembrane>) | Liquid |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``StrategyIsUnique`` | bridge | ``ExactlyOneSurvives``, ``StrategyGate`` | [3](<doc:AtlasUnfolded#StrategyIsUnique>) | Strategy |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``AmbiguityIsExperiment`` | bridge | ``HolesCarryAddresses``, ``LawIsTarget`` | [1](<doc:AtlasUnfolded#AmbiguityIsExperiment>) | Dynamics |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AgentPathCertified`` | theorem | ``IdentityCollapse``, ``PassIsIdentification`` | 0 | Intelligence |
| ``AlignmentEnablesIntelligence`` | bridge | ``AlignmentCoefficient``, ``IntelligenceRises`` | 0 | Search |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``CacheOnlyGrows`` | theorem | ``CachePermanent``, ``StepsTerminate`` | 0 | Identification |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``FreeGeneration`` | bridge | ``DiscriminatorAndGenerator``, ``EmissionAccumulates`` | 0 | Path |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``IsIsYIdentity`` | bridge | ``OrderIsOnlyFreedom``, ``PassIsIdentification`` | 0 | Interference |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``OrgansAreOneCompare`` | bridge | ``Decidable``, ``DiscriminatorAndGenerator`` | 0 | Generation |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``PipelineCrystallizes`` | bridge | ``PassIsIdentification``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``PressIsIdentification`` | bridge | ``PassIsIdentification``, ``PresentedLaw`` | 0 | Presentation |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |

### PipelineTotal

``PipelineTotal`` carries 52 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``PassImpliesMembership`` | kernel | ``PipelineTotal``, ``ResultDeterministic`` | [51](<doc:AtlasUnfolded#PassImpliesMembership>) | Identification |
| ``PassIsIdentification`` | theorem | ``ExactlyOneSurvives``, ``PassImpliesMembership`` | [37](<doc:AtlasUnfolded#PassIsIdentification>) | Identification |
| ``Matter`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification``, ``Resistant`` | [26](<doc:AtlasUnfolded#Matter>) | Matter |
| ``Ignites`` | bridge | ``LibrarySaturates``, ``Matter`` | [22](<doc:AtlasUnfolded#Ignites>) | Matter |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``GateIsZeroOfLoss`` | theorem | ``DistanceOnStructures``, ``PassImpliesMembership`` | [12](<doc:AtlasUnfolded#GateIsZeroOfLoss>) | Gradient |
| ``AlignmentCoefficient`` | bridge | ``GateIsZeroOfLoss``, ``HasAlpha`` | [11](<doc:AtlasUnfolded#AlignmentCoefficient>) | Search |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``CertifiedRuleGenerates`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification`` | [6](<doc:AtlasUnfolded#CertifiedRuleGenerates>) | Play |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``DiscriminatorAndGenerator`` | bridge | ``OrderIsOnlyFreedom``, ``PassImpliesMembership`` | [5](<doc:AtlasUnfolded#DiscriminatorAndGenerator>) | Generation |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
| ``SearchFlow`` | bridge | ``AlignmentCoefficient``, ``LiquidPhase`` | [5](<doc:AtlasUnfolded#SearchFlow>) | Liquid |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``StefanCoupling`` | bridge | ``CrystallizationFront``, ``SearchFlow`` | [4](<doc:AtlasUnfolded#StefanCoupling>) | Liquid |
| ``StrategyGate`` | bridge | ``PassImpliesMembership``, ``StrategyLivesInSigma`` | [4](<doc:AtlasUnfolded#StrategyGate>) | Strategy |
| ``GateIsMembrane`` | bridge | ``StefanCoupling`` | [3](<doc:AtlasUnfolded#GateIsMembrane>) | Liquid |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``StrategyIsUnique`` | bridge | ``ExactlyOneSurvives``, ``StrategyGate`` | [3](<doc:AtlasUnfolded#StrategyIsUnique>) | Strategy |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``AmbiguityIsExperiment`` | bridge | ``HolesCarryAddresses``, ``LawIsTarget`` | [1](<doc:AtlasUnfolded#AmbiguityIsExperiment>) | Dynamics |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AgentPathCertified`` | theorem | ``IdentityCollapse``, ``PassIsIdentification`` | 0 | Intelligence |
| ``AlignmentEnablesIntelligence`` | bridge | ``AlignmentCoefficient``, ``IntelligenceRises`` | 0 | Search |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``FreeGeneration`` | bridge | ``DiscriminatorAndGenerator``, ``EmissionAccumulates`` | 0 | Path |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``IsIsYIdentity`` | bridge | ``OrderIsOnlyFreedom``, ``PassIsIdentification`` | 0 | Interference |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``OrgansAreOneCompare`` | bridge | ``Decidable``, ``DiscriminatorAndGenerator`` | 0 | Generation |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``PipelineCrystallizes`` | bridge | ``PassIsIdentification``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``PressIsIdentification`` | bridge | ``PassIsIdentification``, ``PresentedLaw`` | 0 | Presentation |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |

### EqualityDecidable

``EqualityDecidable`` carries 51 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``ExactlyOneSurvives`` | theorem | ``EqualityDecidable``, ``HasSolutions`` | [42](<doc:AtlasUnfolded#ExactlyOneSurvives>) | Identification |
| ``PassIsIdentification`` | theorem | ``ExactlyOneSurvives``, ``PassImpliesMembership`` | [37](<doc:AtlasUnfolded#PassIsIdentification>) | Identification |
| ``Matter`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification``, ``Resistant`` | [26](<doc:AtlasUnfolded#Matter>) | Matter |
| ``Ignites`` | bridge | ``LibrarySaturates``, ``Matter`` | [22](<doc:AtlasUnfolded#Ignites>) | Matter |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``MembershipDecidable`` | theorem | ``EqualityDecidable``, ``HasSolutions`` | [7](<doc:AtlasUnfolded#MembershipDecidable>) | Intelligence |
| ``ResultsIrreversible`` | theorem | ``CachePermanent``, ``EqualityDecidable`` | [7](<doc:AtlasUnfolded#ResultsIrreversible>) | Intelligence |
| ``CertifiedRuleGenerates`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification`` | [6](<doc:AtlasUnfolded#CertifiedRuleGenerates>) | Play |
| ``SystemCrystallizes`` | bridge | ``CandidatesOnlyLeave``, ``MembershipDecidable``, ``ResultsIrreversible`` | [6](<doc:AtlasUnfolded#SystemCrystallizes>) | Intelligence |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``StrategyIsUnique`` | bridge | ``ExactlyOneSurvives``, ``StrategyGate`` | [3](<doc:AtlasUnfolded#StrategyIsUnique>) | Strategy |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``AmbiguityIsExperiment`` | bridge | ``HolesCarryAddresses``, ``LawIsTarget`` | [1](<doc:AtlasUnfolded#AmbiguityIsExperiment>) | Dynamics |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``GatedConstruction`` | bridge | ``EmissionAccumulates``, ``SystemCrystallizes`` | [1](<doc:AtlasUnfolded#GatedConstruction>) | Path |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AgentPathCertified`` | theorem | ``IdentityCollapse``, ``PassIsIdentification`` | 0 | Intelligence |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``Converges`` | bridge | ``NoInverse``, ``SystemCrystallizes`` | 0 | Matter |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``DiscoveryIsRevelation`` | bridge | ``ExactlyOneSurvives``, ``LibrarySaturates`` | 0 | Intelligence |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``GaugeFixing`` | bridge | ``CostReadsGauge``, ``SystemCrystallizes`` | 0 | Gauge |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``IsIsYIdentity`` | bridge | ``OrderIsOnlyFreedom``, ``PassIsIdentification`` | 0 | Interference |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``LibraryCrystallizes`` | bridge | ``LibrarySaturates``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``PipelineCrystallizes`` | bridge | ``PassIsIdentification``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``PreconditionsGuaranteePass`` | theorem | ``ExactlyOneSurvives`` | 0 | Identification |
| ``PressIsIdentification`` | bridge | ``PassIsIdentification``, ``PresentedLaw`` | 0 | Presentation |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |
| ``Universality`` | bridge | ``ExactlyOneSurvives``, ``HasEncoding`` | 0 | Identification |

### PassImpliesMembership

``PassImpliesMembership`` carries 51 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``PassIsIdentification`` | theorem | ``ExactlyOneSurvives``, ``PassImpliesMembership`` | [37](<doc:AtlasUnfolded#PassIsIdentification>) | Identification |
| ``Matter`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification``, ``Resistant`` | [26](<doc:AtlasUnfolded#Matter>) | Matter |
| ``Ignites`` | bridge | ``LibrarySaturates``, ``Matter`` | [22](<doc:AtlasUnfolded#Ignites>) | Matter |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``GateIsZeroOfLoss`` | theorem | ``DistanceOnStructures``, ``PassImpliesMembership`` | [12](<doc:AtlasUnfolded#GateIsZeroOfLoss>) | Gradient |
| ``AlignmentCoefficient`` | bridge | ``GateIsZeroOfLoss``, ``HasAlpha`` | [11](<doc:AtlasUnfolded#AlignmentCoefficient>) | Search |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``CertifiedRuleGenerates`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification`` | [6](<doc:AtlasUnfolded#CertifiedRuleGenerates>) | Play |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``DiscriminatorAndGenerator`` | bridge | ``OrderIsOnlyFreedom``, ``PassImpliesMembership`` | [5](<doc:AtlasUnfolded#DiscriminatorAndGenerator>) | Generation |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
| ``SearchFlow`` | bridge | ``AlignmentCoefficient``, ``LiquidPhase`` | [5](<doc:AtlasUnfolded#SearchFlow>) | Liquid |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``StefanCoupling`` | bridge | ``CrystallizationFront``, ``SearchFlow`` | [4](<doc:AtlasUnfolded#StefanCoupling>) | Liquid |
| ``StrategyGate`` | bridge | ``PassImpliesMembership``, ``StrategyLivesInSigma`` | [4](<doc:AtlasUnfolded#StrategyGate>) | Strategy |
| ``GateIsMembrane`` | bridge | ``StefanCoupling`` | [3](<doc:AtlasUnfolded#GateIsMembrane>) | Liquid |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``StrategyIsUnique`` | bridge | ``ExactlyOneSurvives``, ``StrategyGate`` | [3](<doc:AtlasUnfolded#StrategyIsUnique>) | Strategy |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``AmbiguityIsExperiment`` | bridge | ``HolesCarryAddresses``, ``LawIsTarget`` | [1](<doc:AtlasUnfolded#AmbiguityIsExperiment>) | Dynamics |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AgentPathCertified`` | theorem | ``IdentityCollapse``, ``PassIsIdentification`` | 0 | Intelligence |
| ``AlignmentEnablesIntelligence`` | bridge | ``AlignmentCoefficient``, ``IntelligenceRises`` | 0 | Search |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``FreeGeneration`` | bridge | ``DiscriminatorAndGenerator``, ``EmissionAccumulates`` | 0 | Path |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``IsIsYIdentity`` | bridge | ``OrderIsOnlyFreedom``, ``PassIsIdentification`` | 0 | Interference |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``OrgansAreOneCompare`` | bridge | ``Decidable``, ``DiscriminatorAndGenerator`` | 0 | Generation |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``PipelineCrystallizes`` | bridge | ``PassIsIdentification``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``PressIsIdentification`` | bridge | ``PassIsIdentification``, ``PresentedLaw`` | 0 | Presentation |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |

### KnowledgeAccumulates

``KnowledgeAccumulates`` carries 45 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``Matter`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification``, ``Resistant`` | [26](<doc:AtlasUnfolded#Matter>) | Matter |
| ``Ignites`` | bridge | ``LibrarySaturates``, ``Matter`` | [22](<doc:AtlasUnfolded#Ignites>) | Matter |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``NoInverse`` | bridge | ``KnowledgeAccumulates`` | [11](<doc:AtlasUnfolded#NoInverse>) | Matter |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``LiquidPhase`` | bridge | ``KnowledgeAccumulates``, ``Monotone`` | [7](<doc:AtlasUnfolded#LiquidPhase>) | Liquid |
| ``CertifiedRuleGenerates`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification`` | [6](<doc:AtlasUnfolded#CertifiedRuleGenerates>) | Play |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``CrystallizationFront`` | bridge | ``DistanceOnStructures``, ``LiquidPhase``, ``NoInverse`` | [5](<doc:AtlasUnfolded#CrystallizationFront>) | Liquid |
| ``SearchFlow`` | bridge | ``AlignmentCoefficient``, ``LiquidPhase`` | [5](<doc:AtlasUnfolded#SearchFlow>) | Liquid |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``StefanCoupling`` | bridge | ``CrystallizationFront``, ``SearchFlow`` | [4](<doc:AtlasUnfolded#StefanCoupling>) | Liquid |
| ``GateIsMembrane`` | bridge | ``StefanCoupling`` | [3](<doc:AtlasUnfolded#GateIsMembrane>) | Liquid |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``RulesCompose`` | bridge | ``KnowledgeAccumulates`` | [2](<doc:AtlasUnfolded#RulesCompose>) | Basis |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``AtomBasis`` | bridge | ``BasisIsFinite``, ``HasCompositionalNorm``, ``RulesCompose`` | [1](<doc:AtlasUnfolded#AtomBasis>) | Basis |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``RepairsPermanent`` | bridge | ``AnchorGraph``, ``NoInverse`` | [1](<doc:AtlasUnfolded#RepairsPermanent>) | Map |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``AtomnessIsTrajectory`` | bridge | ``AtomBasis``, ``NoInverse`` | 0 | Basis |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``Converges`` | bridge | ``NoInverse``, ``SystemCrystallizes`` | 0 | Matter |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``ErasureIsRecession`` | bridge | ``EmissionAccumulates``, ``NoInverse`` | 0 | Path |
| ``FailureCurriculum`` | bridge | ``HolesCarryAddresses``, ``RepairsPermanent`` | 0 | Map |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |

### ExactlyOneSurvives

``ExactlyOneSurvives`` carries 42 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``PassIsIdentification`` | theorem | ``ExactlyOneSurvives``, ``PassImpliesMembership`` | [37](<doc:AtlasUnfolded#PassIsIdentification>) | Identification |
| ``Matter`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification``, ``Resistant`` | [26](<doc:AtlasUnfolded#Matter>) | Matter |
| ``Ignites`` | bridge | ``LibrarySaturates``, ``Matter`` | [22](<doc:AtlasUnfolded#Ignites>) | Matter |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``CertifiedRuleGenerates`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification`` | [6](<doc:AtlasUnfolded#CertifiedRuleGenerates>) | Play |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``StrategyIsUnique`` | bridge | ``ExactlyOneSurvives``, ``StrategyGate`` | [3](<doc:AtlasUnfolded#StrategyIsUnique>) | Strategy |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``AmbiguityIsExperiment`` | bridge | ``HolesCarryAddresses``, ``LawIsTarget`` | [1](<doc:AtlasUnfolded#AmbiguityIsExperiment>) | Dynamics |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AgentPathCertified`` | theorem | ``IdentityCollapse``, ``PassIsIdentification`` | 0 | Intelligence |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``DiscoveryIsRevelation`` | bridge | ``ExactlyOneSurvives``, ``LibrarySaturates`` | 0 | Intelligence |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``IsIsYIdentity`` | bridge | ``OrderIsOnlyFreedom``, ``PassIsIdentification`` | 0 | Interference |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``PipelineCrystallizes`` | bridge | ``PassIsIdentification``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``PreconditionsGuaranteePass`` | theorem | ``ExactlyOneSurvives`` | 0 | Identification |
| ``PressIsIdentification`` | bridge | ``PassIsIdentification``, ``PresentedLaw`` | 0 | Presentation |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |
| ``Universality`` | bridge | ``ExactlyOneSurvives``, ``HasEncoding`` | 0 | Identification |

### HasSaturation

``HasSaturation`` carries 39 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``LibrarySaturates`` | bridge | ``CachePermanent``, ``HasSaturation`` | [38](<doc:AtlasUnfolded#LibrarySaturates>) | Intelligence |
| ``Ignites`` | bridge | ``LibrarySaturates``, ``Matter`` | [22](<doc:AtlasUnfolded#Ignites>) | Matter |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``BallSaturation`` | bridge | ``DistanceOnStructures``, ``LibrarySaturates`` | [15](<doc:AtlasUnfolded#BallSaturation>) | Gradient |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``BasisIsFinite`` | bridge | ``HasBasis``, ``LibrarySaturates`` | [7](<doc:AtlasUnfolded#BasisIsFinite>) | Intelligence |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``IntelligenceRises`` | bridge | ``HasEfficiency``, ``LibrarySaturates`` | [3](<doc:AtlasUnfolded#IntelligenceRises>) | Intelligence |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``AtomBasis`` | bridge | ``BasisIsFinite``, ``HasCompositionalNorm``, ``RulesCompose`` | [1](<doc:AtlasUnfolded#AtomBasis>) | Basis |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AlignmentEnablesIntelligence`` | bridge | ``AlignmentCoefficient``, ``IntelligenceRises`` | 0 | Search |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``AtomnessIsTrajectory`` | bridge | ``AtomBasis``, ``NoInverse`` | 0 | Basis |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``DiscoveryIsRevelation`` | bridge | ``ExactlyOneSurvives``, ``LibrarySaturates`` | 0 | Intelligence |
| ``EncodingSelectionSaturates`` | bridge | ``HasEncoding``, ``LibrarySaturates`` | 0 | Intelligence |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``InterferenceIsIntelligence`` | bridge | ``IntelligenceRises``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``LibraryCrystallizes`` | bridge | ``LibrarySaturates``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``SaturationDynamics`` | bridge | ``ComparisonsAreBounded``, ``LibrarySaturates`` | 0 | Intelligence |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |

### Decidable

``Decidable`` carries 38 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``Resistant`` | theorem | ``Decidable``, ``HasDistance`` | [28](<doc:AtlasUnfolded#Resistant>) | Matter |
| ``Matter`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification``, ``Resistant`` | [26](<doc:AtlasUnfolded#Matter>) | Matter |
| ``Ignites`` | bridge | ``LibrarySaturates``, ``Matter`` | [22](<doc:AtlasUnfolded#Ignites>) | Matter |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``HolesCarryAddresses`` | bridge | ``AnchorGraph``, ``Decidable`` | [9](<doc:AtlasUnfolded#HolesCarryAddresses>) | Map |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``AmbiguityIsExperiment`` | bridge | ``HolesCarryAddresses``, ``LawIsTarget`` | [1](<doc:AtlasUnfolded#AmbiguityIsExperiment>) | Dynamics |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``FailureCurriculum`` | bridge | ``HolesCarryAddresses``, ``RepairsPermanent`` | 0 | Map |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``GradientInComparison`` | theorem | ``Decidable``, ``DistanceOnStructures`` | 0 | Gradient |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``OrgansAreOneCompare`` | bridge | ``Decidable``, ``DiscriminatorAndGenerator`` | 0 | Generation |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``ResistanceHasMagnitude`` | theorem | ``DistanceOnStructures``, ``Resistant`` | 0 | Gradient |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |
| ``ThreeAxesOfCompare`` | bridge | ``Decidable``, ``OrderIsOnlyFreedom`` | 0 | Interference |

### LibrarySaturates

``LibrarySaturates`` carries 38 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``Ignites`` | bridge | ``LibrarySaturates``, ``Matter`` | [22](<doc:AtlasUnfolded#Ignites>) | Matter |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``BallSaturation`` | bridge | ``DistanceOnStructures``, ``LibrarySaturates`` | [15](<doc:AtlasUnfolded#BallSaturation>) | Gradient |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``BasisIsFinite`` | bridge | ``HasBasis``, ``LibrarySaturates`` | [7](<doc:AtlasUnfolded#BasisIsFinite>) | Intelligence |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``IntelligenceRises`` | bridge | ``HasEfficiency``, ``LibrarySaturates`` | [3](<doc:AtlasUnfolded#IntelligenceRises>) | Intelligence |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``AtomBasis`` | bridge | ``BasisIsFinite``, ``HasCompositionalNorm``, ``RulesCompose`` | [1](<doc:AtlasUnfolded#AtomBasis>) | Basis |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AlignmentEnablesIntelligence`` | bridge | ``AlignmentCoefficient``, ``IntelligenceRises`` | 0 | Search |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``AtomnessIsTrajectory`` | bridge | ``AtomBasis``, ``NoInverse`` | 0 | Basis |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``DiscoveryIsRevelation`` | bridge | ``ExactlyOneSurvives``, ``LibrarySaturates`` | 0 | Intelligence |
| ``EncodingSelectionSaturates`` | bridge | ``HasEncoding``, ``LibrarySaturates`` | 0 | Intelligence |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``InterferenceIsIntelligence`` | bridge | ``IntelligenceRises``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``LibraryCrystallizes`` | bridge | ``LibrarySaturates``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``SaturationDynamics`` | bridge | ``ComparisonsAreBounded``, ``LibrarySaturates`` | 0 | Intelligence |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |

### HasEncoding

``HasEncoding`` carries 37 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``HasVerdict`` | axis | ``HasEncoding`` | [19](<doc:AtlasUnfolded#HasVerdict>) | Verdict |
| ``VerdictIsInvariant`` | bridge | ``ComparedReadings``, ``HasVerdict`` | [11](<doc:AtlasUnfolded#VerdictIsInvariant>) | Verdict |
| ``PredicateReading`` | bridge | ``HasVerdict``, ``Pair`` | [6](<doc:AtlasUnfolded#PredicateReading>) | Verdict |
| ``ReadingFactors`` | bridge | ``VerdictIsInvariant`` | [5](<doc:AtlasUnfolded#ReadingFactors>) | Verdict |
| ``CandidateReading`` | bridge | ``HasCandidates``, ``PredicateReading`` | [2](<doc:AtlasUnfolded#CandidateReading>) | Verdict |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``EncodingForgets`` | bridge | ``VerdictIsInvariant`` | [2](<doc:AtlasUnfolded#EncodingForgets>) | Seeing |
| ``HasGrammar`` | axis | ``HasEncoding`` | [2](<doc:AtlasUnfolded#HasGrammar>) | Space |
| ``ObservedTransition`` | theorem | ``HasEncoding``, ``Pair`` | [2](<doc:AtlasUnfolded#ObservedTransition>) | Transition |
| ``CommutingTransition`` | theorem | ``ObservedTransition`` | [1](<doc:AtlasUnfolded#CommutingTransition>) | Transition |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``ContentIsGaugeInvariant`` | bridge | ``HasGauge``, ``ReadingFactors`` | [1](<doc:AtlasUnfolded#ContentIsGaugeInvariant>) | Gauge |
| ``CostReadsGauge`` | bridge | ``HasDistance``, ``HasGauge``, ``PredicateReading`` | [1](<doc:AtlasUnfolded#CostReadsGauge>) | Gauge |
| ``EmissionIsAutoregressive`` | bridge | ``HasEncoding``, ``HasPath``, ``ScopeBoundedByEncoding`` | [1](<doc:AtlasUnfolded#EmissionIsAutoregressive>) | Path |
| ``AcquiresAnswer`` | bridge | ``ReadingFactors`` | 0 | Verdict |
| ``AdequateResidueContinuation`` | bridge | ``VerdictIsInvariant`` | 0 | Acquisition |
| ``CandidateGroupReading`` | bridge | ``CandidateReading`` | 0 | Verdict |
| ``CandidateLeafReading`` | bridge | ``CandidateReading`` | 0 | Verdict |
| ``CheckedSpellingAdmission`` | bridge | ``ReadingFactors`` | 0 | Permission |
| ``ColourIsQuotient`` | bridge | ``EncodingForgets`` | 0 | Colour |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``ConservedReadingStep`` | theorem | ``CommutingTransition`` | 0 | Halt |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``EncodingInvents`` | theorem | ``ComparedReadings``, ``HasEncoding`` | 0 | Voice |
| ``EncodingSelectionSaturates`` | bridge | ``HasEncoding``, ``LibrarySaturates`` | 0 | Intelligence |
| ``FaithfulEncoding`` | bridge | ``ReadingFactors`` | 0 | Voice |
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``CostIsPathLength`` | 0 | Gauge |
| ``GaugeFixing`` | bridge | ``CostReadsGauge``, ``SystemCrystallizes`` | 0 | Gauge |
| ``PerspectiveIsEncoding`` | theorem | ``HasEncoding``, ``Measurable``, ``ScopeBoundedByEncoding`` | 0 | Space |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |
| ``QualitiesAreFinite`` | theorem | ``HasEncoding``, ``IntegerValued`` | 0 | Space |
| ``RecordedAnswerReading`` | bridge | ``PredicateReading`` | 0 | Verdict |
| ``SeparatorIdentifies`` | bridge | ``EncodingForgets`` | 0 | Seeing |
| ``SpaceFromDifference`` | bridge | ``DistanceIsMetric``, ``HasGrammar`` | 0 | Space |
| ``Universality`` | bridge | ``ExactlyOneSurvives``, ``HasEncoding`` | 0 | Identification |
| ``VerdictCoversBranches`` | bridge | ``HasCandidates``, ``VerdictIsInvariant`` | 0 | Verdict |

### PassIsIdentification

``PassIsIdentification`` carries 37 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``Matter`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification``, ``Resistant`` | [26](<doc:AtlasUnfolded#Matter>) | Matter |
| ``Ignites`` | bridge | ``LibrarySaturates``, ``Matter`` | [22](<doc:AtlasUnfolded#Ignites>) | Matter |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``CertifiedRuleGenerates`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification`` | [6](<doc:AtlasUnfolded#CertifiedRuleGenerates>) | Play |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``AmbiguityIsExperiment`` | bridge | ``HolesCarryAddresses``, ``LawIsTarget`` | [1](<doc:AtlasUnfolded#AmbiguityIsExperiment>) | Dynamics |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AgentPathCertified`` | theorem | ``IdentityCollapse``, ``PassIsIdentification`` | 0 | Intelligence |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``IsIsYIdentity`` | bridge | ``OrderIsOnlyFreedom``, ``PassIsIdentification`` | 0 | Interference |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``PipelineCrystallizes`` | bridge | ``PassIsIdentification``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``PressIsIdentification`` | bridge | ``PassIsIdentification``, ``PresentedLaw`` | 0 | Presentation |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |

### Null

``Null`` carries 32 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``IdentityCollapse`` | theorem | ``HasSolutions``, ``Null`` | [28](<doc:AtlasUnfolded#IdentityCollapse>) | Core |
| ``OrderIsOnlyFreedom`` | bridge | ``AxesCoOriented``, ``IdentityCollapse`` | [26](<doc:AtlasUnfolded#OrderIsOnlyFreedom>) | Identification |
| ``StrategyLivesInSigma`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | [12](<doc:AtlasUnfolded#StrategyLivesInSigma>) | Strategy |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``DiscriminatorAndGenerator`` | bridge | ``OrderIsOnlyFreedom``, ``PassImpliesMembership`` | [5](<doc:AtlasUnfolded#DiscriminatorAndGenerator>) | Generation |
| ``StrategyGate`` | bridge | ``PassImpliesMembership``, ``StrategyLivesInSigma`` | [4](<doc:AtlasUnfolded#StrategyGate>) | Strategy |
| ``StrategyIsUnique`` | bridge | ``ExactlyOneSurvives``, ``StrategyGate`` | [3](<doc:AtlasUnfolded#StrategyIsUnique>) | Strategy |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``Reading`` | bridge | ``HasTime``, ``OrderIsOnlyFreedom``, ``RevealsNotCreates`` | [2](<doc:AtlasUnfolded#Reading>) | Reading |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``AgentPathCertified`` | theorem | ``IdentityCollapse``, ``PassIsIdentification`` | 0 | Intelligence |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``CompletionIsSolutionSet`` | bridge | ``HasPath``, ``Reading`` | 0 | Path |
| ``ConstructionIsReading`` | bridge | ``EmissionAccumulates``, ``Reading`` | 0 | Path |
| ``FreeGeneration`` | bridge | ``DiscriminatorAndGenerator``, ``EmissionAccumulates`` | 0 | Path |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``InterferenceIsIntelligence`` | bridge | ``IntelligenceRises``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``InvalidStepFolds`` | theorem | ``HasPath``, ``Null`` | 0 | Path |
| ``IsIsYIdentity`` | bridge | ``OrderIsOnlyFreedom``, ``PassIsIdentification`` | 0 | Interference |
| ``NullIsOrigin`` | theorem | ``DistanceOnStructures``, ``Null`` | 0 | Gradient |
| ``OrderByDistance`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | 0 | Gradient |
| ``OrgansAreOneCompare`` | bridge | ``Decidable``, ``DiscriminatorAndGenerator`` | 0 | Generation |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |
| ``ThreeAxesOfCompare`` | bridge | ``Decidable``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``Unique`` | marker | ``Monotone``, ``Null`` | 0 | Core |

### IdentityCollapse

``IdentityCollapse`` carries 28 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``OrderIsOnlyFreedom`` | bridge | ``AxesCoOriented``, ``IdentityCollapse`` | [26](<doc:AtlasUnfolded#OrderIsOnlyFreedom>) | Identification |
| ``StrategyLivesInSigma`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | [12](<doc:AtlasUnfolded#StrategyLivesInSigma>) | Strategy |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``DiscriminatorAndGenerator`` | bridge | ``OrderIsOnlyFreedom``, ``PassImpliesMembership`` | [5](<doc:AtlasUnfolded#DiscriminatorAndGenerator>) | Generation |
| ``StrategyGate`` | bridge | ``PassImpliesMembership``, ``StrategyLivesInSigma`` | [4](<doc:AtlasUnfolded#StrategyGate>) | Strategy |
| ``StrategyIsUnique`` | bridge | ``ExactlyOneSurvives``, ``StrategyGate`` | [3](<doc:AtlasUnfolded#StrategyIsUnique>) | Strategy |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``Reading`` | bridge | ``HasTime``, ``OrderIsOnlyFreedom``, ``RevealsNotCreates`` | [2](<doc:AtlasUnfolded#Reading>) | Reading |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``AgentPathCertified`` | theorem | ``IdentityCollapse``, ``PassIsIdentification`` | 0 | Intelligence |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``CompletionIsSolutionSet`` | bridge | ``HasPath``, ``Reading`` | 0 | Path |
| ``ConstructionIsReading`` | bridge | ``EmissionAccumulates``, ``Reading`` | 0 | Path |
| ``FreeGeneration`` | bridge | ``DiscriminatorAndGenerator``, ``EmissionAccumulates`` | 0 | Path |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``InterferenceIsIntelligence`` | bridge | ``IntelligenceRises``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``IsIsYIdentity`` | bridge | ``OrderIsOnlyFreedom``, ``PassIsIdentification`` | 0 | Interference |
| ``OrderByDistance`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | 0 | Gradient |
| ``OrgansAreOneCompare`` | bridge | ``Decidable``, ``DiscriminatorAndGenerator`` | 0 | Generation |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |
| ``ThreeAxesOfCompare`` | bridge | ``Decidable``, ``OrderIsOnlyFreedom`` | 0 | Interference |

### Resistant

``Resistant`` carries 28 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``Matter`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification``, ``Resistant`` | [26](<doc:AtlasUnfolded#Matter>) | Matter |
| ``Ignites`` | bridge | ``LibrarySaturates``, ``Matter`` | [22](<doc:AtlasUnfolded#Ignites>) | Matter |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``ResistanceHasMagnitude`` | theorem | ``DistanceOnStructures``, ``Resistant`` | 0 | Gradient |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |

### AxesCoOriented

``AxesCoOriented`` carries 27 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``OrderIsOnlyFreedom`` | bridge | ``AxesCoOriented``, ``IdentityCollapse`` | [26](<doc:AtlasUnfolded#OrderIsOnlyFreedom>) | Identification |
| ``StrategyLivesInSigma`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | [12](<doc:AtlasUnfolded#StrategyLivesInSigma>) | Strategy |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``DiscriminatorAndGenerator`` | bridge | ``OrderIsOnlyFreedom``, ``PassImpliesMembership`` | [5](<doc:AtlasUnfolded#DiscriminatorAndGenerator>) | Generation |
| ``StrategyGate`` | bridge | ``PassImpliesMembership``, ``StrategyLivesInSigma`` | [4](<doc:AtlasUnfolded#StrategyGate>) | Strategy |
| ``StrategyIsUnique`` | bridge | ``ExactlyOneSurvives``, ``StrategyGate`` | [3](<doc:AtlasUnfolded#StrategyIsUnique>) | Strategy |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``Reading`` | bridge | ``HasTime``, ``OrderIsOnlyFreedom``, ``RevealsNotCreates`` | [2](<doc:AtlasUnfolded#Reading>) | Reading |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``CompletionIsSolutionSet`` | bridge | ``HasPath``, ``Reading`` | 0 | Path |
| ``ConstructionIsReading`` | bridge | ``EmissionAccumulates``, ``Reading`` | 0 | Path |
| ``FreeGeneration`` | bridge | ``DiscriminatorAndGenerator``, ``EmissionAccumulates`` | 0 | Path |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``InterferenceIsIntelligence`` | bridge | ``IntelligenceRises``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``IsIsYIdentity`` | bridge | ``OrderIsOnlyFreedom``, ``PassIsIdentification`` | 0 | Interference |
| ``OrderByDistance`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | 0 | Gradient |
| ``OrgansAreOneCompare`` | bridge | ``Decidable``, ``DiscriminatorAndGenerator`` | 0 | Generation |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |
| ``ThreeAxesOfCompare`` | bridge | ``Decidable``, ``OrderIsOnlyFreedom`` | 0 | Interference |

### Matter

``Matter`` carries 26 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``Ignites`` | bridge | ``LibrarySaturates``, ``Matter`` | [22](<doc:AtlasUnfolded#Ignites>) | Matter |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |

### OrderIsOnlyFreedom

``OrderIsOnlyFreedom`` carries 26 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``StrategyLivesInSigma`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | [12](<doc:AtlasUnfolded#StrategyLivesInSigma>) | Strategy |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``DiscriminatorAndGenerator`` | bridge | ``OrderIsOnlyFreedom``, ``PassImpliesMembership`` | [5](<doc:AtlasUnfolded#DiscriminatorAndGenerator>) | Generation |
| ``StrategyGate`` | bridge | ``PassImpliesMembership``, ``StrategyLivesInSigma`` | [4](<doc:AtlasUnfolded#StrategyGate>) | Strategy |
| ``StrategyIsUnique`` | bridge | ``ExactlyOneSurvives``, ``StrategyGate`` | [3](<doc:AtlasUnfolded#StrategyIsUnique>) | Strategy |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``Reading`` | bridge | ``HasTime``, ``OrderIsOnlyFreedom``, ``RevealsNotCreates`` | [2](<doc:AtlasUnfolded#Reading>) | Reading |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``CompletionIsSolutionSet`` | bridge | ``HasPath``, ``Reading`` | 0 | Path |
| ``ConstructionIsReading`` | bridge | ``EmissionAccumulates``, ``Reading`` | 0 | Path |
| ``FreeGeneration`` | bridge | ``DiscriminatorAndGenerator``, ``EmissionAccumulates`` | 0 | Path |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``InterferenceIsIntelligence`` | bridge | ``IntelligenceRises``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``IsIsYIdentity`` | bridge | ``OrderIsOnlyFreedom``, ``PassIsIdentification`` | 0 | Interference |
| ``OrderByDistance`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | 0 | Gradient |
| ``OrgansAreOneCompare`` | bridge | ``Decidable``, ``DiscriminatorAndGenerator`` | 0 | Generation |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |
| ``ThreeAxesOfCompare`` | bridge | ``Decidable``, ``OrderIsOnlyFreedom`` | 0 | Interference |

### HasTime

``HasTime`` carries 24 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``Reading`` | bridge | ``HasTime``, ``OrderIsOnlyFreedom``, ``RevealsNotCreates`` | [2](<doc:AtlasUnfolded#Reading>) | Reading |
| ``BehaviorIsStructure`` | bridge | ``DistanceOnStructures``, ``HasTime`` | [1](<doc:AtlasUnfolded#BehaviorIsStructure>) | Dynamics |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``CompletionIsSolutionSet`` | bridge | ``HasPath``, ``Reading`` | 0 | Path |
| ``ConstructionIsReading`` | bridge | ``EmissionAccumulates``, ``Reading`` | 0 | Path |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``EdgesCarryTheJudgement`` | bridge | ``BehaviorIsStructure``, ``PresentedLaw`` | 0 | Presentation |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |

### AnchorGraph

``AnchorGraph`` carries 22 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``HolesCarryAddresses`` | bridge | ``AnchorGraph``, ``Decidable`` | [9](<doc:AtlasUnfolded#HolesCarryAddresses>) | Map |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``AmbiguityIsExperiment`` | bridge | ``HolesCarryAddresses``, ``LawIsTarget`` | [1](<doc:AtlasUnfolded#AmbiguityIsExperiment>) | Dynamics |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``RepairsPermanent`` | bridge | ``AnchorGraph``, ``NoInverse`` | [1](<doc:AtlasUnfolded#RepairsPermanent>) | Map |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``FailureCurriculum`` | bridge | ``HolesCarryAddresses``, ``RepairsPermanent`` | 0 | Map |
| ``GreedyDescentTerminates`` | bridge | ``AnchorGraph``, ``Monotone`` | 0 | Map |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |

### Ignites

``Ignites`` carries 22 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |

### HasCost

``HasCost`` carries 20 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``DistanceIsCost`` | bridge | ``DistanceOnStructures``, ``HasCost`` | 0 | Gradient |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |

### HasVerdict

``HasVerdict`` carries 19 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``VerdictIsInvariant`` | bridge | ``ComparedReadings``, ``HasVerdict`` | [11](<doc:AtlasUnfolded#VerdictIsInvariant>) | Verdict |
| ``PredicateReading`` | bridge | ``HasVerdict``, ``Pair`` | [6](<doc:AtlasUnfolded#PredicateReading>) | Verdict |
| ``ReadingFactors`` | bridge | ``VerdictIsInvariant`` | [5](<doc:AtlasUnfolded#ReadingFactors>) | Verdict |
| ``CandidateReading`` | bridge | ``HasCandidates``, ``PredicateReading`` | [2](<doc:AtlasUnfolded#CandidateReading>) | Verdict |
| ``EncodingForgets`` | bridge | ``VerdictIsInvariant`` | [2](<doc:AtlasUnfolded#EncodingForgets>) | Seeing |
| ``ContentIsGaugeInvariant`` | bridge | ``HasGauge``, ``ReadingFactors`` | [1](<doc:AtlasUnfolded#ContentIsGaugeInvariant>) | Gauge |
| ``CostReadsGauge`` | bridge | ``HasDistance``, ``HasGauge``, ``PredicateReading`` | [1](<doc:AtlasUnfolded#CostReadsGauge>) | Gauge |
| ``AcquiresAnswer`` | bridge | ``ReadingFactors`` | 0 | Verdict |
| ``AdequateResidueContinuation`` | bridge | ``VerdictIsInvariant`` | 0 | Acquisition |
| ``CandidateGroupReading`` | bridge | ``CandidateReading`` | 0 | Verdict |
| ``CandidateLeafReading`` | bridge | ``CandidateReading`` | 0 | Verdict |
| ``CheckedSpellingAdmission`` | bridge | ``ReadingFactors`` | 0 | Permission |
| ``ColourIsQuotient`` | bridge | ``EncodingForgets`` | 0 | Colour |
| ``FaithfulEncoding`` | bridge | ``ReadingFactors`` | 0 | Voice |
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``CostIsPathLength`` | 0 | Gauge |
| ``GaugeFixing`` | bridge | ``CostReadsGauge``, ``SystemCrystallizes`` | 0 | Gauge |
| ``RecordedAnswerReading`` | bridge | ``PredicateReading`` | 0 | Verdict |
| ``SeparatorIdentifies`` | bridge | ``EncodingForgets`` | 0 | Seeing |
| ``VerdictCoversBranches`` | bridge | ``HasCandidates``, ``VerdictIsInvariant`` | 0 | Verdict |

### Tower

``Tower`` carries 18 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |

### BallSaturation

``BallSaturation`` carries 15 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |

### CompressionCriterion

``CompressionCriterion`` carries 14 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |

### ComparedReadings

``ComparedReadings`` carries 13 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``VerdictIsInvariant`` | bridge | ``ComparedReadings``, ``HasVerdict`` | [11](<doc:AtlasUnfolded#VerdictIsInvariant>) | Verdict |
| ``ReadingFactors`` | bridge | ``VerdictIsInvariant`` | [5](<doc:AtlasUnfolded#ReadingFactors>) | Verdict |
| ``EncodingForgets`` | bridge | ``VerdictIsInvariant`` | [2](<doc:AtlasUnfolded#EncodingForgets>) | Seeing |
| ``ContentIsGaugeInvariant`` | bridge | ``HasGauge``, ``ReadingFactors`` | [1](<doc:AtlasUnfolded#ContentIsGaugeInvariant>) | Gauge |
| ``AcquiresAnswer`` | bridge | ``ReadingFactors`` | 0 | Verdict |
| ``AdequateResidueContinuation`` | bridge | ``VerdictIsInvariant`` | 0 | Acquisition |
| ``CheckedSpellingAdmission`` | bridge | ``ReadingFactors`` | 0 | Permission |
| ``ColourIsQuotient`` | bridge | ``EncodingForgets`` | 0 | Colour |
| ``EncodingInvents`` | theorem | ``ComparedReadings``, ``HasEncoding`` | 0 | Voice |
| ``FaithfulEncoding`` | bridge | ``ReadingFactors`` | 0 | Voice |
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``CostIsPathLength`` | 0 | Gauge |
| ``SeparatorIdentifies`` | bridge | ``EncodingForgets`` | 0 | Seeing |
| ``VerdictCoversBranches`` | bridge | ``HasCandidates``, ``VerdictIsInvariant`` | 0 | Verdict |

### HasLaw

``HasLaw`` carries 13 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``LawLivesInSigma`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [6](<doc:AtlasUnfolded#LawLivesInSigma>) | Dynamics |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
| ``PresentedLaw`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [5](<doc:AtlasUnfolded#PresentedLaw>) | Presentation |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``AmbiguityIsExperiment`` | bridge | ``HolesCarryAddresses``, ``LawIsTarget`` | [1](<doc:AtlasUnfolded#AmbiguityIsExperiment>) | Dynamics |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``StandardIsType`` | bridge | ``PresentedLaw`` | [1](<doc:AtlasUnfolded#StandardIsType>) | Ruler |
| ``EdgesCarryTheJudgement`` | bridge | ``BehaviorIsStructure``, ``PresentedLaw`` | 0 | Presentation |
| ``FormIsInvariant`` | bridge | ``PresentedLaw`` | 0 | Presentation |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``MeasureIsCount`` | bridge | ``StandardIsType`` | 0 | Ruler |
| ``PressIsIdentification`` | bridge | ``PassIsIdentification``, ``PresentedLaw`` | 0 | Presentation |

### GateIsZeroOfLoss

``GateIsZeroOfLoss`` carries 12 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``AlignmentCoefficient`` | bridge | ``GateIsZeroOfLoss``, ``HasAlpha`` | [11](<doc:AtlasUnfolded#AlignmentCoefficient>) | Search |
| ``SearchFlow`` | bridge | ``AlignmentCoefficient``, ``LiquidPhase`` | [5](<doc:AtlasUnfolded#SearchFlow>) | Liquid |
| ``StefanCoupling`` | bridge | ``CrystallizationFront``, ``SearchFlow`` | [4](<doc:AtlasUnfolded#StefanCoupling>) | Liquid |
| ``GateIsMembrane`` | bridge | ``StefanCoupling`` | [3](<doc:AtlasUnfolded#GateIsMembrane>) | Liquid |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``AlignmentEnablesIntelligence`` | bridge | ``AlignmentCoefficient``, ``IntelligenceRises`` | 0 | Search |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |

### HasAlpha

``HasAlpha`` carries 12 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``AlignmentCoefficient`` | bridge | ``GateIsZeroOfLoss``, ``HasAlpha`` | [11](<doc:AtlasUnfolded#AlignmentCoefficient>) | Search |
| ``SearchFlow`` | bridge | ``AlignmentCoefficient``, ``LiquidPhase`` | [5](<doc:AtlasUnfolded#SearchFlow>) | Liquid |
| ``StefanCoupling`` | bridge | ``CrystallizationFront``, ``SearchFlow`` | [4](<doc:AtlasUnfolded#StefanCoupling>) | Liquid |
| ``GateIsMembrane`` | bridge | ``StefanCoupling`` | [3](<doc:AtlasUnfolded#GateIsMembrane>) | Liquid |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``AlignmentEnablesIntelligence`` | bridge | ``AlignmentCoefficient``, ``IntelligenceRises`` | 0 | Search |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |

### HasPath

``HasPath`` carries 12 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``EmissionAccumulates`` | theorem | ``HasPath`` | [5](<doc:AtlasUnfolded#EmissionAccumulates>) | Path |
| ``CostIsPathLength`` | bridge | ``HasDistance``, ``HasPath`` | [1](<doc:AtlasUnfolded#CostIsPathLength>) | Path |
| ``EmissionIsAutoregressive`` | bridge | ``HasEncoding``, ``HasPath``, ``ScopeBoundedByEncoding`` | [1](<doc:AtlasUnfolded#EmissionIsAutoregressive>) | Path |
| ``GatedConstruction`` | bridge | ``EmissionAccumulates``, ``SystemCrystallizes`` | [1](<doc:AtlasUnfolded#GatedConstruction>) | Path |
| ``ReachIsPath`` | bridge | ``HasBasis``, ``HasPath`` | [1](<doc:AtlasUnfolded#ReachIsPath>) | Path |
| ``CompletionIsSolutionSet`` | bridge | ``HasPath``, ``Reading`` | 0 | Path |
| ``ConstructionIsReading`` | bridge | ``EmissionAccumulates``, ``Reading`` | 0 | Path |
| ``ErasureIsRecession`` | bridge | ``EmissionAccumulates``, ``NoInverse`` | 0 | Path |
| ``FreeGeneration`` | bridge | ``DiscriminatorAndGenerator``, ``EmissionAccumulates`` | 0 | Path |
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``CostIsPathLength`` | 0 | Gauge |
| ``InvalidStepFolds`` | theorem | ``HasPath``, ``Null`` | 0 | Path |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |

### StrategyLivesInSigma

``StrategyLivesInSigma`` carries 12 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``StrategyGate`` | bridge | ``PassImpliesMembership``, ``StrategyLivesInSigma`` | [4](<doc:AtlasUnfolded#StrategyGate>) | Strategy |
| ``StrategyIsUnique`` | bridge | ``ExactlyOneSurvives``, ``StrategyGate`` | [3](<doc:AtlasUnfolded#StrategyIsUnique>) | Strategy |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |

### AlignmentCoefficient

``AlignmentCoefficient`` carries 11 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``SearchFlow`` | bridge | ``AlignmentCoefficient``, ``LiquidPhase`` | [5](<doc:AtlasUnfolded#SearchFlow>) | Liquid |
| ``StefanCoupling`` | bridge | ``CrystallizationFront``, ``SearchFlow`` | [4](<doc:AtlasUnfolded#StefanCoupling>) | Liquid |
| ``GateIsMembrane`` | bridge | ``StefanCoupling`` | [3](<doc:AtlasUnfolded#GateIsMembrane>) | Liquid |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``AlignmentEnablesIntelligence`` | bridge | ``AlignmentCoefficient``, ``IntelligenceRises`` | 0 | Search |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |

### NoInverse

``NoInverse`` carries 11 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``CrystallizationFront`` | bridge | ``DistanceOnStructures``, ``LiquidPhase``, ``NoInverse`` | [5](<doc:AtlasUnfolded#CrystallizationFront>) | Liquid |
| ``StefanCoupling`` | bridge | ``CrystallizationFront``, ``SearchFlow`` | [4](<doc:AtlasUnfolded#StefanCoupling>) | Liquid |
| ``GateIsMembrane`` | bridge | ``StefanCoupling`` | [3](<doc:AtlasUnfolded#GateIsMembrane>) | Liquid |
| ``RepairsPermanent`` | bridge | ``AnchorGraph``, ``NoInverse`` | [1](<doc:AtlasUnfolded#RepairsPermanent>) | Map |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``AtomnessIsTrajectory`` | bridge | ``AtomBasis``, ``NoInverse`` | 0 | Basis |
| ``Converges`` | bridge | ``NoInverse``, ``SystemCrystallizes`` | 0 | Matter |
| ``ErasureIsRecession`` | bridge | ``EmissionAccumulates``, ``NoInverse`` | 0 | Path |
| ``FailureCurriculum`` | bridge | ``HolesCarryAddresses``, ``RepairsPermanent`` | 0 | Map |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |

### VerdictIsInvariant

``VerdictIsInvariant`` carries 11 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``ReadingFactors`` | bridge | ``VerdictIsInvariant`` | [5](<doc:AtlasUnfolded#ReadingFactors>) | Verdict |
| ``EncodingForgets`` | bridge | ``VerdictIsInvariant`` | [2](<doc:AtlasUnfolded#EncodingForgets>) | Seeing |
| ``ContentIsGaugeInvariant`` | bridge | ``HasGauge``, ``ReadingFactors`` | [1](<doc:AtlasUnfolded#ContentIsGaugeInvariant>) | Gauge |
| ``AcquiresAnswer`` | bridge | ``ReadingFactors`` | 0 | Verdict |
| ``AdequateResidueContinuation`` | bridge | ``VerdictIsInvariant`` | 0 | Acquisition |
| ``CheckedSpellingAdmission`` | bridge | ``ReadingFactors`` | 0 | Permission |
| ``ColourIsQuotient`` | bridge | ``EncodingForgets`` | 0 | Colour |
| ``FaithfulEncoding`` | bridge | ``ReadingFactors`` | 0 | Voice |
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``CostIsPathLength`` | 0 | Gauge |
| ``SeparatorIdentifies`` | bridge | ``EncodingForgets`` | 0 | Seeing |
| ``VerdictCoversBranches`` | bridge | ``HasCandidates``, ``VerdictIsInvariant`` | 0 | Verdict |

### HasBasis

``HasBasis`` carries 10 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``BasisIsFinite`` | bridge | ``HasBasis``, ``LibrarySaturates`` | [7](<doc:AtlasUnfolded#BasisIsFinite>) | Intelligence |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``AtomBasis`` | bridge | ``BasisIsFinite``, ``HasCompositionalNorm``, ``RulesCompose`` | [1](<doc:AtlasUnfolded#AtomBasis>) | Basis |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``ReachIsPath`` | bridge | ``HasBasis``, ``HasPath`` | [1](<doc:AtlasUnfolded#ReachIsPath>) | Path |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``AtomnessIsTrajectory`` | bridge | ``AtomBasis``, ``NoInverse`` | 0 | Basis |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |

### Monotone

``Monotone`` carries 10 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``LiquidPhase`` | bridge | ``KnowledgeAccumulates``, ``Monotone`` | [7](<doc:AtlasUnfolded#LiquidPhase>) | Liquid |
| ``CrystallizationFront`` | bridge | ``DistanceOnStructures``, ``LiquidPhase``, ``NoInverse`` | [5](<doc:AtlasUnfolded#CrystallizationFront>) | Liquid |
| ``SearchFlow`` | bridge | ``AlignmentCoefficient``, ``LiquidPhase`` | [5](<doc:AtlasUnfolded#SearchFlow>) | Liquid |
| ``StefanCoupling`` | bridge | ``CrystallizationFront``, ``SearchFlow`` | [4](<doc:AtlasUnfolded#StefanCoupling>) | Liquid |
| ``GateIsMembrane`` | bridge | ``StefanCoupling`` | [3](<doc:AtlasUnfolded#GateIsMembrane>) | Liquid |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``GreedyDescentTerminates`` | bridge | ``AnchorGraph``, ``Monotone`` | 0 | Map |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``Unique`` | marker | ``Monotone``, ``Null`` | 0 | Core |

### OneBoundaryThreeFaces

``OneBoundaryThreeFaces`` carries 10 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |

### HolesCarryAddresses

``HolesCarryAddresses`` carries 9 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``AmbiguityIsExperiment`` | bridge | ``HolesCarryAddresses``, ``LawIsTarget`` | [1](<doc:AtlasUnfolded#AmbiguityIsExperiment>) | Dynamics |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``FailureCurriculum`` | bridge | ``HolesCarryAddresses``, ``RepairsPermanent`` | 0 | Map |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |

### BasisIsFinite

``BasisIsFinite`` carries 7 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``AtomBasis`` | bridge | ``BasisIsFinite``, ``HasCompositionalNorm``, ``RulesCompose`` | [1](<doc:AtlasUnfolded#AtomBasis>) | Basis |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``AtomnessIsTrajectory`` | bridge | ``AtomBasis``, ``NoInverse`` | 0 | Basis |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |

### CandidatesOnlyLeave

``CandidatesOnlyLeave`` carries 7 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``SystemCrystallizes`` | bridge | ``CandidatesOnlyLeave``, ``MembershipDecidable``, ``ResultsIrreversible`` | [6](<doc:AtlasUnfolded#SystemCrystallizes>) | Intelligence |
| ``GatedConstruction`` | bridge | ``EmissionAccumulates``, ``SystemCrystallizes`` | [1](<doc:AtlasUnfolded#GatedConstruction>) | Path |
| ``Converges`` | bridge | ``NoInverse``, ``SystemCrystallizes`` | 0 | Matter |
| ``GaugeFixing`` | bridge | ``CostReadsGauge``, ``SystemCrystallizes`` | 0 | Gauge |
| ``LibraryCrystallizes`` | bridge | ``LibrarySaturates``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``PipelineCrystallizes`` | bridge | ``PassIsIdentification``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |

### LiquidPhase

``LiquidPhase`` carries 7 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``CrystallizationFront`` | bridge | ``DistanceOnStructures``, ``LiquidPhase``, ``NoInverse`` | [5](<doc:AtlasUnfolded#CrystallizationFront>) | Liquid |
| ``SearchFlow`` | bridge | ``AlignmentCoefficient``, ``LiquidPhase`` | [5](<doc:AtlasUnfolded#SearchFlow>) | Liquid |
| ``StefanCoupling`` | bridge | ``CrystallizationFront``, ``SearchFlow`` | [4](<doc:AtlasUnfolded#StefanCoupling>) | Liquid |
| ``GateIsMembrane`` | bridge | ``StefanCoupling`` | [3](<doc:AtlasUnfolded#GateIsMembrane>) | Liquid |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |

### Measurable

``Measurable`` carries 7 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``RevealsNotCreates`` | kernel | ``Measurable``, ``OperationsClosed`` | [5](<doc:AtlasUnfolded#RevealsNotCreates>) | Identification |
| ``Reading`` | bridge | ``HasTime``, ``OrderIsOnlyFreedom``, ``RevealsNotCreates`` | [2](<doc:AtlasUnfolded#Reading>) | Reading |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``CompletionIsSolutionSet`` | bridge | ``HasPath``, ``Reading`` | 0 | Path |
| ``ConstructionIsReading`` | bridge | ``EmissionAccumulates``, ``Reading`` | 0 | Path |
| ``PerspectiveIsEncoding`` | theorem | ``HasEncoding``, ``Measurable``, ``ScopeBoundedByEncoding`` | 0 | Space |

### MembershipDecidable

``MembershipDecidable`` carries 7 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``SystemCrystallizes`` | bridge | ``CandidatesOnlyLeave``, ``MembershipDecidable``, ``ResultsIrreversible`` | [6](<doc:AtlasUnfolded#SystemCrystallizes>) | Intelligence |
| ``GatedConstruction`` | bridge | ``EmissionAccumulates``, ``SystemCrystallizes`` | [1](<doc:AtlasUnfolded#GatedConstruction>) | Path |
| ``Converges`` | bridge | ``NoInverse``, ``SystemCrystallizes`` | 0 | Matter |
| ``GaugeFixing`` | bridge | ``CostReadsGauge``, ``SystemCrystallizes`` | 0 | Gauge |
| ``LibraryCrystallizes`` | bridge | ``LibrarySaturates``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``PipelineCrystallizes`` | bridge | ``PassIsIdentification``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |

### ResultsIrreversible

``ResultsIrreversible`` carries 7 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``SystemCrystallizes`` | bridge | ``CandidatesOnlyLeave``, ``MembershipDecidable``, ``ResultsIrreversible`` | [6](<doc:AtlasUnfolded#SystemCrystallizes>) | Intelligence |
| ``GatedConstruction`` | bridge | ``EmissionAccumulates``, ``SystemCrystallizes`` | [1](<doc:AtlasUnfolded#GatedConstruction>) | Path |
| ``Converges`` | bridge | ``NoInverse``, ``SystemCrystallizes`` | 0 | Matter |
| ``GaugeFixing`` | bridge | ``CostReadsGauge``, ``SystemCrystallizes`` | 0 | Gauge |
| ``LibraryCrystallizes`` | bridge | ``LibrarySaturates``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``PipelineCrystallizes`` | bridge | ``PassIsIdentification``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |

### CertifiedRuleGenerates

``CertifiedRuleGenerates`` carries 6 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |

### LawLivesInSigma

``LawLivesInSigma`` carries 6 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``AmbiguityIsExperiment`` | bridge | ``HolesCarryAddresses``, ``LawIsTarget`` | [1](<doc:AtlasUnfolded#AmbiguityIsExperiment>) | Dynamics |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |

### PredicateReading

``PredicateReading`` carries 6 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``CandidateReading`` | bridge | ``HasCandidates``, ``PredicateReading`` | [2](<doc:AtlasUnfolded#CandidateReading>) | Verdict |
| ``CostReadsGauge`` | bridge | ``HasDistance``, ``HasGauge``, ``PredicateReading`` | [1](<doc:AtlasUnfolded#CostReadsGauge>) | Gauge |
| ``CandidateGroupReading`` | bridge | ``CandidateReading`` | 0 | Verdict |
| ``CandidateLeafReading`` | bridge | ``CandidateReading`` | 0 | Verdict |
| ``GaugeFixing`` | bridge | ``CostReadsGauge``, ``SystemCrystallizes`` | 0 | Gauge |
| ``RecordedAnswerReading`` | bridge | ``PredicateReading`` | 0 | Verdict |

### SkillsAreBalls

``SkillsAreBalls`` carries 6 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |

### SystemCrystallizes

``SystemCrystallizes`` carries 6 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``GatedConstruction`` | bridge | ``EmissionAccumulates``, ``SystemCrystallizes`` | [1](<doc:AtlasUnfolded#GatedConstruction>) | Path |
| ``Converges`` | bridge | ``NoInverse``, ``SystemCrystallizes`` | 0 | Matter |
| ``GaugeFixing`` | bridge | ``CostReadsGauge``, ``SystemCrystallizes`` | 0 | Gauge |
| ``LibraryCrystallizes`` | bridge | ``LibrarySaturates``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``PipelineCrystallizes`` | bridge | ``PassIsIdentification``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |

### AmbiguityNamesInput

``AmbiguityNamesInput`` carries 5 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |

### CrystallizationFront

``CrystallizationFront`` carries 5 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``StefanCoupling`` | bridge | ``CrystallizationFront``, ``SearchFlow`` | [4](<doc:AtlasUnfolded#StefanCoupling>) | Liquid |
| ``GateIsMembrane`` | bridge | ``StefanCoupling`` | [3](<doc:AtlasUnfolded#GateIsMembrane>) | Liquid |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |

### DiscriminatorAndGenerator

``DiscriminatorAndGenerator`` carries 5 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``FreeGeneration`` | bridge | ``DiscriminatorAndGenerator``, ``EmissionAccumulates`` | 0 | Path |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``OrgansAreOneCompare`` | bridge | ``Decidable``, ``DiscriminatorAndGenerator`` | 0 | Generation |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |

### EmissionAccumulates

``EmissionAccumulates`` carries 5 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``GatedConstruction`` | bridge | ``EmissionAccumulates``, ``SystemCrystallizes`` | [1](<doc:AtlasUnfolded#GatedConstruction>) | Path |
| ``ConstructionIsReading`` | bridge | ``EmissionAccumulates``, ``Reading`` | 0 | Path |
| ``ErasureIsRecession`` | bridge | ``EmissionAccumulates``, ``NoInverse`` | 0 | Path |
| ``FreeGeneration`` | bridge | ``DiscriminatorAndGenerator``, ``EmissionAccumulates`` | 0 | Path |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |

### LawIsTarget

``LawIsTarget`` carries 5 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``AmbiguityIsExperiment`` | bridge | ``HolesCarryAddresses``, ``LawIsTarget`` | [1](<doc:AtlasUnfolded#AmbiguityIsExperiment>) | Dynamics |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |

### PresentedLaw

``PresentedLaw`` carries 5 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``StandardIsType`` | bridge | ``PresentedLaw`` | [1](<doc:AtlasUnfolded#StandardIsType>) | Ruler |
| ``EdgesCarryTheJudgement`` | bridge | ``BehaviorIsStructure``, ``PresentedLaw`` | 0 | Presentation |
| ``FormIsInvariant`` | bridge | ``PresentedLaw`` | 0 | Presentation |
| ``MeasureIsCount`` | bridge | ``StandardIsType`` | 0 | Ruler |
| ``PressIsIdentification`` | bridge | ``PassIsIdentification``, ``PresentedLaw`` | 0 | Presentation |

### ReadingFactors

``ReadingFactors`` carries 5 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``ContentIsGaugeInvariant`` | bridge | ``HasGauge``, ``ReadingFactors`` | [1](<doc:AtlasUnfolded#ContentIsGaugeInvariant>) | Gauge |
| ``AcquiresAnswer`` | bridge | ``ReadingFactors`` | 0 | Verdict |
| ``CheckedSpellingAdmission`` | bridge | ``ReadingFactors`` | 0 | Permission |
| ``FaithfulEncoding`` | bridge | ``ReadingFactors`` | 0 | Voice |
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``CostIsPathLength`` | 0 | Gauge |

### RevealsNotCreates

``RevealsNotCreates`` carries 5 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``Reading`` | bridge | ``HasTime``, ``OrderIsOnlyFreedom``, ``RevealsNotCreates`` | [2](<doc:AtlasUnfolded#Reading>) | Reading |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``CompletionIsSolutionSet`` | bridge | ``HasPath``, ``Reading`` | 0 | Path |
| ``ConstructionIsReading`` | bridge | ``EmissionAccumulates``, ``Reading`` | 0 | Path |

### ScopeBoundedByEncoding

``ScopeBoundedByEncoding`` carries 5 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``EmissionIsAutoregressive`` | bridge | ``HasEncoding``, ``HasPath``, ``ScopeBoundedByEncoding`` | [1](<doc:AtlasUnfolded#EmissionIsAutoregressive>) | Path |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``PerspectiveIsEncoding`` | theorem | ``HasEncoding``, ``Measurable``, ``ScopeBoundedByEncoding`` | 0 | Space |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |

### SearchFlow

``SearchFlow`` carries 5 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``StefanCoupling`` | bridge | ``CrystallizationFront``, ``SearchFlow`` | [4](<doc:AtlasUnfolded#StefanCoupling>) | Liquid |
| ``GateIsMembrane`` | bridge | ``StefanCoupling`` | [3](<doc:AtlasUnfolded#GateIsMembrane>) | Liquid |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |

### HasCandidates

``HasCandidates`` carries 4 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``CandidateReading`` | bridge | ``HasCandidates``, ``PredicateReading`` | [2](<doc:AtlasUnfolded#CandidateReading>) | Verdict |
| ``CandidateGroupReading`` | bridge | ``CandidateReading`` | 0 | Verdict |
| ``CandidateLeafReading`` | bridge | ``CandidateReading`` | 0 | Verdict |
| ``VerdictCoversBranches`` | bridge | ``HasCandidates``, ``VerdictIsInvariant`` | 0 | Verdict |

### HasEfficiency

``HasEfficiency`` carries 4 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``IntelligenceRises`` | bridge | ``HasEfficiency``, ``LibrarySaturates`` | [3](<doc:AtlasUnfolded#IntelligenceRises>) | Intelligence |
| ``AlignmentEnablesIntelligence`` | bridge | ``AlignmentCoefficient``, ``IntelligenceRises`` | 0 | Search |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``InterferenceIsIntelligence`` | bridge | ``IntelligenceRises``, ``OrderIsOnlyFreedom`` | 0 | Interference |

### HasGauge

``HasGauge`` carries 4 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``ContentIsGaugeInvariant`` | bridge | ``HasGauge``, ``ReadingFactors`` | [1](<doc:AtlasUnfolded#ContentIsGaugeInvariant>) | Gauge |
| ``CostReadsGauge`` | bridge | ``HasDistance``, ``HasGauge``, ``PredicateReading`` | [1](<doc:AtlasUnfolded#CostReadsGauge>) | Gauge |
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``CostIsPathLength`` | 0 | Gauge |
| ``GaugeFixing`` | bridge | ``CostReadsGauge``, ``SystemCrystallizes`` | 0 | Gauge |

### NavigationInevitable

``NavigationInevitable`` carries 4 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |

### SelfPlaySaturates

``SelfPlaySaturates`` carries 4 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |

### StefanCoupling

``StefanCoupling`` carries 4 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``GateIsMembrane`` | bridge | ``StefanCoupling`` | [3](<doc:AtlasUnfolded#GateIsMembrane>) | Liquid |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |

### StrategyGate

``StrategyGate`` carries 4 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``StrategyIsUnique`` | bridge | ``ExactlyOneSurvives``, ``StrategyGate`` | [3](<doc:AtlasUnfolded#StrategyIsUnique>) | Strategy |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |

### ComparisonsAreBounded

``ComparisonsAreBounded`` carries 3 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``CommunicationBounded`` | theorem | ``ComparisonsAreBounded``, ``HasCache`` | 0 | Space |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``SaturationDynamics`` | bridge | ``ComparisonsAreBounded``, ``LibrarySaturates`` | 0 | Intelligence |

### GateIsMembrane

``GateIsMembrane`` carries 3 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |

### IntelligenceRises

``IntelligenceRises`` carries 3 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``AlignmentEnablesIntelligence`` | bridge | ``AlignmentCoefficient``, ``IntelligenceRises`` | 0 | Search |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``InterferenceIsIntelligence`` | bridge | ``IntelligenceRises``, ``OrderIsOnlyFreedom`` | 0 | Interference |

### SearchableIffClusteredAndAligned

``SearchableIffClusteredAndAligned`` carries 3 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |

### StrategyIsUnique

``StrategyIsUnique`` carries 3 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |

### CandidateReading

``CandidateReading`` carries 2 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``CandidateGroupReading`` | bridge | ``CandidateReading`` | 0 | Verdict |
| ``CandidateLeafReading`` | bridge | ``CandidateReading`` | 0 | Verdict |

### EncoderConditions

``EncoderConditions`` carries 2 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |

### EncodingForgets

``EncodingForgets`` carries 2 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``ColourIsQuotient`` | bridge | ``EncodingForgets`` | 0 | Colour |
| ``SeparatorIdentifies`` | bridge | ``EncodingForgets`` | 0 | Seeing |

### FourthFace

``FourthFace`` carries 2 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |

### HasCompositionalNorm

``HasCompositionalNorm`` carries 2 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``AtomBasis`` | bridge | ``BasisIsFinite``, ``HasCompositionalNorm``, ``RulesCompose`` | [1](<doc:AtlasUnfolded#AtomBasis>) | Basis |
| ``AtomnessIsTrajectory`` | bridge | ``AtomBasis``, ``NoInverse`` | 0 | Basis |

### HasGrammar

``HasGrammar`` carries 2 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``SpaceFromDifference`` | bridge | ``DistanceIsMetric``, ``HasGrammar`` | 0 | Space |

### ObservationTrace

``ObservationTrace`` carries 2 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``EmptyObservationTrace`` | kernel | ``ObservationTrace`` | 0 | Verdict |
| ``ExtendedObservationTrace`` | kernel | ``ObservationTrace`` | 0 | Verdict |

### ObservedTransition

``ObservedTransition`` carries 2 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``CommutingTransition`` | theorem | ``ObservedTransition`` | [1](<doc:AtlasUnfolded#CommutingTransition>) | Transition |
| ``ConservedReadingStep`` | theorem | ``CommutingTransition`` | 0 | Halt |

### PlanningIsNavigation

``PlanningIsNavigation`` carries 2 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |

### Reading

``Reading`` carries 2 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``CompletionIsSolutionSet`` | bridge | ``HasPath``, ``Reading`` | 0 | Path |
| ``ConstructionIsReading`` | bridge | ``EmissionAccumulates``, ``Reading`` | 0 | Path |

### RulesCompose

``RulesCompose`` carries 2 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``AtomBasis`` | bridge | ``BasisIsFinite``, ``HasCompositionalNorm``, ``RulesCompose`` | [1](<doc:AtlasUnfolded#AtomBasis>) | Basis |
| ``AtomnessIsTrajectory`` | bridge | ``AtomBasis``, ``NoInverse`` | 0 | Basis |

### StrategyCrystallizes

``StrategyCrystallizes`` carries 2 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |

### TowerSelfPlay

``TowerSelfPlay`` carries 2 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |

### AmbiguityIsExperiment

``AmbiguityIsExperiment`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |

### AtomBasis

``AtomBasis`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``AtomnessIsTrajectory`` | bridge | ``AtomBasis``, ``NoInverse`` | 0 | Basis |

### BehaviorIsStructure

``BehaviorIsStructure`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``EdgesCarryTheJudgement`` | bridge | ``BehaviorIsStructure``, ``PresentedLaw`` | 0 | Presentation |

### CommutingTransition

``CommutingTransition`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``ConservedReadingStep`` | theorem | ``CommutingTransition`` | 0 | Halt |

### ConditionalSolving

``ConditionalSolving`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |

### ContentIsGaugeInvariant

``ContentIsGaugeInvariant`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``CostIsPathLength`` | 0 | Gauge |

### CostIsPathLength

``CostIsPathLength`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``CostIsPathLength`` | 0 | Gauge |

### CostReadsGauge

``CostReadsGauge`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``GaugeFixing`` | bridge | ``CostReadsGauge``, ``SystemCrystallizes`` | 0 | Gauge |

### DistanceIsMetric

``DistanceIsMetric`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``SpaceFromDifference`` | bridge | ``DistanceIsMetric``, ``HasGrammar`` | 0 | Space |

### EmissionIsAutoregressive

``EmissionIsAutoregressive`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |

### EvidenceRefinesQuestion

``EvidenceRefinesQuestion`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``RefinementPreservesAnswer`` | kernel | ``EvidenceRefinesQuestion`` | 0 | Verdict |

### GatedConstruction

``GatedConstruction`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |

### HasStrategy

``HasStrategy`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``StrategyBecomesTarget`` | axis | ``HasStrategy`` | 0 | Level |

### IntegerValued

``IntegerValued`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``QualitiesAreFinite`` | theorem | ``HasEncoding``, ``IntegerValued`` | 0 | Space |

### MeasuredGeometry

``MeasuredGeometry`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |

### MotorSkillsAreStrategies

``MotorSkillsAreStrategies`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |

### Permanent

``Permanent`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``RetainedReadingRecord`` | marker | ``Permanent`` | 0 | Verdict |

### PhaseBecomesAmplitude

``PhaseBecomesAmplitude`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |

### PlayIsProof

``PlayIsProof`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |

### ReachIsPath

``ReachIsPath`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |

### RepairsPermanent

``RepairsPermanent`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``FailureCurriculum`` | bridge | ``HolesCarryAddresses``, ``RepairsPermanent`` | 0 | Map |

### StandardIsType

``StandardIsType`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Premises | Carries | Home |
| --- | --- | --- | --- | --- |
| ``MeasureIsCount`` | bridge | ``StandardIsType`` | 0 | Ruler |
