# Atlas, unfolded

The lists behind every count of the <doc:Atlas>. A claim's **cone** is the full set of claims that rest on it, directly or through others, and every Carries number on the map links to its cone here.

Each section repeats the same table over its cone, heaviest first. Numbers inside a cone open further cones, each strictly smaller than the one above, so the descent ends at bare zeros. Cone inside cone stays acyclic for the same reason the theory does: the compiler refuses a circular hierarchy.

## The cones

### HasSigma

``HasSigma`` carries 151 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``StructuresFinite`` | kernel | ``HasSigma``, ``Pair`` | [117](<doc:AtlasUnfolded#StructuresFinite>) | Identification |
| ``HasCache`` | axis | ``HasSigma`` | [86](<doc:AtlasUnfolded#HasCache>) | Core |
| ``CachePermanent`` | theorem | ``HasCache``, ``OperationsClosed``, ``StructuresFinite`` | [82](<doc:AtlasUnfolded#CachePermanent>) | Identification |
| ``HasDistance`` | axis | ``HasSigma`` | [79](<doc:AtlasUnfolded#HasDistance>) | Core |
| ``HasSolutions`` | axis | ``HasSigma`` | [67](<doc:AtlasUnfolded#HasSolutions>) | Core |
| ``HasLibrary`` | axis | ``HasSigma`` | [66](<doc:AtlasUnfolded#HasLibrary>) | Core |
| ``DistanceOnStructures`` | theorem | ``HasDistance``, ``StructuresFinite`` | [61](<doc:AtlasUnfolded#DistanceOnStructures>) | Gradient |
| ``StepsTerminate`` | kernel | ``StructuresFinite`` | [54](<doc:AtlasUnfolded#StepsTerminate>) | Identification |
| ``PipelineTotal`` | kernel | ``StepsTerminate`` | [52](<doc:AtlasUnfolded#PipelineTotal>) | Identification |
| ``EqualityDecidable`` | kernel | ``StructuresFinite`` | [51](<doc:AtlasUnfolded#EqualityDecidable>) | Identification |
| ``PassImpliesMembership`` | kernel | ``PipelineTotal``, ``ResultDeterministic`` | [51](<doc:AtlasUnfolded#PassImpliesMembership>) | Identification |
| ``KnowledgeAccumulates`` | bridge | ``CachePermanent``, ``HasLibrary`` | [45](<doc:AtlasUnfolded#KnowledgeAccumulates>) | Intelligence |
| ``ExactlyOneSurvives`` | theorem | ``EqualityDecidable``, ``HasSolutions`` | [42](<doc:AtlasUnfolded#ExactlyOneSurvives>) | Identification |
| ``HasSaturation`` | axis | ``HasLibrary`` | [39](<doc:AtlasUnfolded#HasSaturation>) | Core |
| ``LibrarySaturates`` | bridge | ``CachePermanent``, ``HasSaturation`` | [38](<doc:AtlasUnfolded#LibrarySaturates>) | Intelligence |
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
| ``Tower`` | bridge | ``HasCost``, ``HasTime``, ``Ignites`` | [18](<doc:AtlasUnfolded#Tower>) | Matter |
| ``HasEncoding`` | axis | ``HasSigma`` | [17](<doc:AtlasUnfolded#HasEncoding>) | Core |
| ``BallSaturation`` | bridge | ``DistanceOnStructures``, ``LibrarySaturates`` | [15](<doc:AtlasUnfolded#BallSaturation>) | Gradient |
| ``HasLaw`` | axis | ``HasSigma`` | [15](<doc:AtlasUnfolded#HasLaw>) | Dynamics |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``HasPath`` | axis | ``HasSigma`` | [13](<doc:AtlasUnfolded#HasPath>) | Path |
| ``GateIsZeroOfLoss`` | theorem | ``DistanceOnStructures``, ``PassImpliesMembership`` | [12](<doc:AtlasUnfolded#GateIsZeroOfLoss>) | Gradient |
| ``HasAlpha`` | axis | ``HasDistance`` | [12](<doc:AtlasUnfolded#HasAlpha>) | Core |
| ``StrategyLivesInSigma`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | [12](<doc:AtlasUnfolded#StrategyLivesInSigma>) | Strategy |
| ``AlignmentCoefficient`` | bridge | ``GateIsZeroOfLoss``, ``HasAlpha`` | [11](<doc:AtlasUnfolded#AlignmentCoefficient>) | Search |
| ``NoInverse`` | bridge | ``KnowledgeAccumulates`` | [11](<doc:AtlasUnfolded#NoInverse>) | Matter |
| ``HasBasis`` | axis | ``HasLibrary`` | [10](<doc:AtlasUnfolded#HasBasis>) | Core |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``HolesCarryAddresses`` | bridge | ``AnchorGraph``, ``Decidable`` | [9](<doc:AtlasUnfolded#HolesCarryAddresses>) | Map |
| ``BasisIsFinite`` | bridge | ``HasBasis``, ``LibrarySaturates`` | [7](<doc:AtlasUnfolded#BasisIsFinite>) | Intelligence |
| ``CandidatesOnlyLeave`` | bridge | ``CachePermanent``, ``HasSolutions`` | [7](<doc:AtlasUnfolded#CandidatesOnlyLeave>) | Identification |
| ``LiquidPhase`` | bridge | ``KnowledgeAccumulates``, ``Monotone`` | [7](<doc:AtlasUnfolded#LiquidPhase>) | Liquid |
| ``MembershipDecidable`` | theorem | ``EqualityDecidable``, ``HasSolutions`` | [7](<doc:AtlasUnfolded#MembershipDecidable>) | Intelligence |
| ``PresentedLaw`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [7](<doc:AtlasUnfolded#PresentedLaw>) | Presentation |
| ``ResultsIrreversible`` | theorem | ``CachePermanent``, ``EqualityDecidable`` | [7](<doc:AtlasUnfolded#ResultsIrreversible>) | Intelligence |
| ``CertifiedRuleGenerates`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification`` | [6](<doc:AtlasUnfolded#CertifiedRuleGenerates>) | Play |
| ``LawLivesInSigma`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [6](<doc:AtlasUnfolded#LawLivesInSigma>) | Dynamics |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``SystemCrystallizes`` | bridge | ``CandidatesOnlyLeave``, ``MembershipDecidable``, ``ResultsIrreversible`` | [6](<doc:AtlasUnfolded#SystemCrystallizes>) | Intelligence |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``CrystallizationFront`` | bridge | ``DistanceOnStructures``, ``LiquidPhase``, ``NoInverse`` | [5](<doc:AtlasUnfolded#CrystallizationFront>) | Liquid |
| ``DiscriminatorAndGenerator`` | bridge | ``OrderIsOnlyFreedom``, ``PassImpliesMembership`` | [5](<doc:AtlasUnfolded#DiscriminatorAndGenerator>) | Generation |
| ``EmissionAccumulates`` | theorem | ``HasPath`` | [5](<doc:AtlasUnfolded#EmissionAccumulates>) | Path |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
| ``SearchFlow`` | bridge | ``AlignmentCoefficient``, ``LiquidPhase`` | [5](<doc:AtlasUnfolded#SearchFlow>) | Liquid |
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
| ``CostIsPathLength`` | bridge | ``HasDistance``, ``HasPath`` | [2](<doc:AtlasUnfolded#CostIsPathLength>) | Path |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``HasCompositionalNorm`` | axis | ``HasDistance`` | [2](<doc:AtlasUnfolded#HasCompositionalNorm>) | Basis |
| ``HasGrammar`` | axis | ``HasEncoding`` | [2](<doc:AtlasUnfolded#HasGrammar>) | Space |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``Reading`` | bridge | ``HasTime``, ``OrderIsOnlyFreedom``, ``RevealsNotCreates`` | [2](<doc:AtlasUnfolded#Reading>) | Reading |
| ``RulesCompose`` | bridge | ``KnowledgeAccumulates`` | [2](<doc:AtlasUnfolded#RulesCompose>) | Basis |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``AmbiguityIsExperiment`` | bridge | ``HolesCarryAddresses``, ``LawIsTarget`` | [1](<doc:AtlasUnfolded#AmbiguityIsExperiment>) | Dynamics |
| ``AtomBasis`` | bridge | ``BasisIsFinite``, ``HasCompositionalNorm``, ``RulesCompose`` | [1](<doc:AtlasUnfolded#AtomBasis>) | Basis |
| ``BehaviorIsStructure`` | bridge | ``DistanceOnStructures``, ``HasTime`` | [1](<doc:AtlasUnfolded#BehaviorIsStructure>) | Dynamics |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``ContentIsGaugeInvariant`` | bridge | ``HasEncoding``, ``HasGauge``, ``RevealsNotCreates`` | [1](<doc:AtlasUnfolded#ContentIsGaugeInvariant>) | Gauge |
| ``CostReadsGauge`` | bridge | ``HasDistance``, ``HasGauge`` | [1](<doc:AtlasUnfolded#CostReadsGauge>) | Gauge |
| ``DistanceIsMetric`` | bridge | ``HasCache``, ``HasDistance`` | [1](<doc:AtlasUnfolded#DistanceIsMetric>) | Space |
| ``EmissionIsAutoregressive`` | bridge | ``HasEncoding``, ``HasPath``, ``ScopeBoundedByEncoding`` | [1](<doc:AtlasUnfolded#EmissionIsAutoregressive>) | Path |
| ``EncodingForgets`` | axis | ``HasEncoding`` | [1](<doc:AtlasUnfolded#EncodingForgets>) | Seeing |
| ``GatedConstruction`` | bridge | ``EmissionAccumulates``, ``SystemCrystallizes`` | [1](<doc:AtlasUnfolded#GatedConstruction>) | Path |
| ``InterferenceIsSubstitution`` | bridge | ``PresentedLaw`` | [1](<doc:AtlasUnfolded#InterferenceIsSubstitution>) | Wave |
| ``LinearArbiter`` | bridge | ``CostIsPathLength`` | [1](<doc:AtlasUnfolded#LinearArbiter>) | Gauge |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``ReachIsPath`` | bridge | ``HasBasis``, ``HasPath`` | [1](<doc:AtlasUnfolded#ReachIsPath>) | Path |
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
| ``DarknessIsNormalForm`` | bridge | ``InterferenceIsSubstitution`` | 0 | Wave |
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
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``LinearArbiter`` | 0 | Gauge |
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
| ``ResistanceHasMagnitude`` | theorem | ``DistanceOnStructures``, ``Resistant`` | 0 | Gradient |
| ``SaturationDynamics`` | bridge | ``ComparisonsAreBounded``, ``LibrarySaturates`` | 0 | Intelligence |
| ``SaturationIncorruptible`` | theorem | ``CachePermanent`` | 0 | Identification |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``SeparatorIdentifies`` | axis | ``EncodingForgets`` | 0 | Seeing |
| ``SpaceFromDifference`` | bridge | ``DistanceIsMetric``, ``HasGrammar`` | 0 | Space |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |
| ``ThreeAxesOfCompare`` | bridge | ``Decidable``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``Universality`` | bridge | ``ExactlyOneSurvives``, ``HasEncoding`` | 0 | Identification |

### Structure

``Structure`` carries 143 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``Open`` | kernel | ``Structure`` | [141](<doc:AtlasUnfolded#Open>) | Primitive |
| ``Pair`` | seed | ``Open`` | [139](<doc:AtlasUnfolded#Pair>) | Primitive |
| ``StructuresFinite`` | kernel | ``HasSigma``, ``Pair`` | [117](<doc:AtlasUnfolded#StructuresFinite>) | Identification |
| ``OperationsClosed`` | kernel | ``Pair`` | [99](<doc:AtlasUnfolded#OperationsClosed>) | Identification |
| ``CachePermanent`` | theorem | ``HasCache``, ``OperationsClosed``, ``StructuresFinite`` | [82](<doc:AtlasUnfolded#CachePermanent>) | Identification |
| ``ResultDeterministic`` | kernel | ``OperationsClosed`` | [67](<doc:AtlasUnfolded#ResultDeterministic>) | Identification |
| ``DistanceOnStructures`` | theorem | ``HasDistance``, ``StructuresFinite`` | [61](<doc:AtlasUnfolded#DistanceOnStructures>) | Gradient |
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
| ``GateIsZeroOfLoss`` | theorem | ``DistanceOnStructures``, ``PassImpliesMembership`` | [12](<doc:AtlasUnfolded#GateIsZeroOfLoss>) | Gradient |
| ``StrategyLivesInSigma`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | [12](<doc:AtlasUnfolded#StrategyLivesInSigma>) | Strategy |
| ``AlignmentCoefficient`` | bridge | ``GateIsZeroOfLoss``, ``HasAlpha`` | [11](<doc:AtlasUnfolded#AlignmentCoefficient>) | Search |
| ``NoInverse`` | bridge | ``KnowledgeAccumulates`` | [11](<doc:AtlasUnfolded#NoInverse>) | Matter |
| ``Monotone`` | marker | ``Pair`` | [10](<doc:AtlasUnfolded#Monotone>) | Core |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``HolesCarryAddresses`` | bridge | ``AnchorGraph``, ``Decidable`` | [9](<doc:AtlasUnfolded#HolesCarryAddresses>) | Map |
| ``Measurable`` | marker | ``Pair`` | [9](<doc:AtlasUnfolded#Measurable>) | Core |
| ``BasisIsFinite`` | bridge | ``HasBasis``, ``LibrarySaturates`` | [7](<doc:AtlasUnfolded#BasisIsFinite>) | Intelligence |
| ``CandidatesOnlyLeave`` | bridge | ``CachePermanent``, ``HasSolutions`` | [7](<doc:AtlasUnfolded#CandidatesOnlyLeave>) | Identification |
| ``LiquidPhase`` | bridge | ``KnowledgeAccumulates``, ``Monotone`` | [7](<doc:AtlasUnfolded#LiquidPhase>) | Liquid |
| ``MembershipDecidable`` | theorem | ``EqualityDecidable``, ``HasSolutions`` | [7](<doc:AtlasUnfolded#MembershipDecidable>) | Intelligence |
| ``PresentedLaw`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [7](<doc:AtlasUnfolded#PresentedLaw>) | Presentation |
| ``ResultsIrreversible`` | theorem | ``CachePermanent``, ``EqualityDecidable`` | [7](<doc:AtlasUnfolded#ResultsIrreversible>) | Intelligence |
| ``RevealsNotCreates`` | kernel | ``Measurable``, ``OperationsClosed`` | [7](<doc:AtlasUnfolded#RevealsNotCreates>) | Identification |
| ``CertifiedRuleGenerates`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification`` | [6](<doc:AtlasUnfolded#CertifiedRuleGenerates>) | Play |
| ``LawLivesInSigma`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [6](<doc:AtlasUnfolded#LawLivesInSigma>) | Dynamics |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``SystemCrystallizes`` | bridge | ``CandidatesOnlyLeave``, ``MembershipDecidable``, ``ResultsIrreversible`` | [6](<doc:AtlasUnfolded#SystemCrystallizes>) | Intelligence |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``CrystallizationFront`` | bridge | ``DistanceOnStructures``, ``LiquidPhase``, ``NoInverse`` | [5](<doc:AtlasUnfolded#CrystallizationFront>) | Liquid |
| ``DiscriminatorAndGenerator`` | bridge | ``OrderIsOnlyFreedom``, ``PassImpliesMembership`` | [5](<doc:AtlasUnfolded#DiscriminatorAndGenerator>) | Generation |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
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
| ``ContentIsGaugeInvariant`` | bridge | ``HasEncoding``, ``HasGauge``, ``RevealsNotCreates`` | [1](<doc:AtlasUnfolded#ContentIsGaugeInvariant>) | Gauge |
| ``EmissionIsAutoregressive`` | bridge | ``HasEncoding``, ``HasPath``, ``ScopeBoundedByEncoding`` | [1](<doc:AtlasUnfolded#EmissionIsAutoregressive>) | Path |
| ``GatedConstruction`` | bridge | ``EmissionAccumulates``, ``SystemCrystallizes`` | [1](<doc:AtlasUnfolded#GatedConstruction>) | Path |
| ``IntegerValued`` | marker | ``Pair`` | [1](<doc:AtlasUnfolded#IntegerValued>) | Core |
| ``InterferenceIsSubstitution`` | bridge | ``PresentedLaw`` | [1](<doc:AtlasUnfolded#InterferenceIsSubstitution>) | Wave |
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
| ``Close`` | kernel | ``Structure`` | 0 | Primitive |
| ``CommunicationBounded`` | theorem | ``ComparisonsAreBounded``, ``HasCache`` | 0 | Space |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``CompletionIsSolutionSet`` | bridge | ``HasPath``, ``Reading`` | 0 | Path |
| ``ConstructionIsReading`` | bridge | ``EmissionAccumulates``, ``Reading`` | 0 | Path |
| ``Converges`` | bridge | ``NoInverse``, ``SystemCrystallizes`` | 0 | Matter |
| ``DarknessIsNormalForm`` | bridge | ``InterferenceIsSubstitution`` | 0 | Wave |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DiagnosticsAccumulate`` | theorem | ``CachePermanent``, ``ResultDeterministic`` | 0 | Identification |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``Digit`` | kernel | ``Open`` | 0 | Numeral |
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
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``LinearArbiter`` | 0 | Gauge |
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
| ``Permanent`` | marker | ``Pair`` | 0 | Core |
| ``PerspectiveIsEncoding`` | theorem | ``HasEncoding``, ``Measurable``, ``ScopeBoundedByEncoding`` | 0 | Space |
| ``PipelineCrystallizes`` | bridge | ``PassIsIdentification``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``PreconditionsGuaranteePass`` | theorem | ``ExactlyOneSurvives`` | 0 | Identification |
| ``PressIsIdentification`` | bridge | ``PassIsIdentification``, ``PresentedLaw`` | 0 | Presentation |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |
| ``QualitiesAreFinite`` | theorem | ``HasEncoding``, ``IntegerValued`` | 0 | Space |
| ``ResistanceHasMagnitude`` | theorem | ``DistanceOnStructures``, ``Resistant`` | 0 | Gradient |
| ``SaturationDynamics`` | bridge | ``ComparisonsAreBounded``, ``LibrarySaturates`` | 0 | Intelligence |
| ``SaturationIncorruptible`` | theorem | ``CachePermanent`` | 0 | Identification |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |
| ``ThreeAxesOfCompare`` | bridge | ``Decidable``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``Unique`` | marker | ``Monotone``, ``Null`` | 0 | Core |
| ``Universality`` | bridge | ``ExactlyOneSurvives``, ``HasEncoding`` | 0 | Identification |

### Open

``Open`` carries 141 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``Pair`` | seed | ``Open`` | [139](<doc:AtlasUnfolded#Pair>) | Primitive |
| ``StructuresFinite`` | kernel | ``HasSigma``, ``Pair`` | [117](<doc:AtlasUnfolded#StructuresFinite>) | Identification |
| ``OperationsClosed`` | kernel | ``Pair`` | [99](<doc:AtlasUnfolded#OperationsClosed>) | Identification |
| ``CachePermanent`` | theorem | ``HasCache``, ``OperationsClosed``, ``StructuresFinite`` | [82](<doc:AtlasUnfolded#CachePermanent>) | Identification |
| ``ResultDeterministic`` | kernel | ``OperationsClosed`` | [67](<doc:AtlasUnfolded#ResultDeterministic>) | Identification |
| ``DistanceOnStructures`` | theorem | ``HasDistance``, ``StructuresFinite`` | [61](<doc:AtlasUnfolded#DistanceOnStructures>) | Gradient |
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
| ``GateIsZeroOfLoss`` | theorem | ``DistanceOnStructures``, ``PassImpliesMembership`` | [12](<doc:AtlasUnfolded#GateIsZeroOfLoss>) | Gradient |
| ``StrategyLivesInSigma`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | [12](<doc:AtlasUnfolded#StrategyLivesInSigma>) | Strategy |
| ``AlignmentCoefficient`` | bridge | ``GateIsZeroOfLoss``, ``HasAlpha`` | [11](<doc:AtlasUnfolded#AlignmentCoefficient>) | Search |
| ``NoInverse`` | bridge | ``KnowledgeAccumulates`` | [11](<doc:AtlasUnfolded#NoInverse>) | Matter |
| ``Monotone`` | marker | ``Pair`` | [10](<doc:AtlasUnfolded#Monotone>) | Core |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``HolesCarryAddresses`` | bridge | ``AnchorGraph``, ``Decidable`` | [9](<doc:AtlasUnfolded#HolesCarryAddresses>) | Map |
| ``Measurable`` | marker | ``Pair`` | [9](<doc:AtlasUnfolded#Measurable>) | Core |
| ``BasisIsFinite`` | bridge | ``HasBasis``, ``LibrarySaturates`` | [7](<doc:AtlasUnfolded#BasisIsFinite>) | Intelligence |
| ``CandidatesOnlyLeave`` | bridge | ``CachePermanent``, ``HasSolutions`` | [7](<doc:AtlasUnfolded#CandidatesOnlyLeave>) | Identification |
| ``LiquidPhase`` | bridge | ``KnowledgeAccumulates``, ``Monotone`` | [7](<doc:AtlasUnfolded#LiquidPhase>) | Liquid |
| ``MembershipDecidable`` | theorem | ``EqualityDecidable``, ``HasSolutions`` | [7](<doc:AtlasUnfolded#MembershipDecidable>) | Intelligence |
| ``PresentedLaw`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [7](<doc:AtlasUnfolded#PresentedLaw>) | Presentation |
| ``ResultsIrreversible`` | theorem | ``CachePermanent``, ``EqualityDecidable`` | [7](<doc:AtlasUnfolded#ResultsIrreversible>) | Intelligence |
| ``RevealsNotCreates`` | kernel | ``Measurable``, ``OperationsClosed`` | [7](<doc:AtlasUnfolded#RevealsNotCreates>) | Identification |
| ``CertifiedRuleGenerates`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification`` | [6](<doc:AtlasUnfolded#CertifiedRuleGenerates>) | Play |
| ``LawLivesInSigma`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [6](<doc:AtlasUnfolded#LawLivesInSigma>) | Dynamics |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``SystemCrystallizes`` | bridge | ``CandidatesOnlyLeave``, ``MembershipDecidable``, ``ResultsIrreversible`` | [6](<doc:AtlasUnfolded#SystemCrystallizes>) | Intelligence |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``CrystallizationFront`` | bridge | ``DistanceOnStructures``, ``LiquidPhase``, ``NoInverse`` | [5](<doc:AtlasUnfolded#CrystallizationFront>) | Liquid |
| ``DiscriminatorAndGenerator`` | bridge | ``OrderIsOnlyFreedom``, ``PassImpliesMembership`` | [5](<doc:AtlasUnfolded#DiscriminatorAndGenerator>) | Generation |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
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
| ``ContentIsGaugeInvariant`` | bridge | ``HasEncoding``, ``HasGauge``, ``RevealsNotCreates`` | [1](<doc:AtlasUnfolded#ContentIsGaugeInvariant>) | Gauge |
| ``EmissionIsAutoregressive`` | bridge | ``HasEncoding``, ``HasPath``, ``ScopeBoundedByEncoding`` | [1](<doc:AtlasUnfolded#EmissionIsAutoregressive>) | Path |
| ``GatedConstruction`` | bridge | ``EmissionAccumulates``, ``SystemCrystallizes`` | [1](<doc:AtlasUnfolded#GatedConstruction>) | Path |
| ``IntegerValued`` | marker | ``Pair`` | [1](<doc:AtlasUnfolded#IntegerValued>) | Core |
| ``InterferenceIsSubstitution`` | bridge | ``PresentedLaw`` | [1](<doc:AtlasUnfolded#InterferenceIsSubstitution>) | Wave |
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
| ``DarknessIsNormalForm`` | bridge | ``InterferenceIsSubstitution`` | 0 | Wave |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DiagnosticsAccumulate`` | theorem | ``CachePermanent``, ``ResultDeterministic`` | 0 | Identification |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``Digit`` | kernel | ``Open`` | 0 | Numeral |
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
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``LinearArbiter`` | 0 | Gauge |
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
| ``Permanent`` | marker | ``Pair`` | 0 | Core |
| ``PerspectiveIsEncoding`` | theorem | ``HasEncoding``, ``Measurable``, ``ScopeBoundedByEncoding`` | 0 | Space |
| ``PipelineCrystallizes`` | bridge | ``PassIsIdentification``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``PreconditionsGuaranteePass`` | theorem | ``ExactlyOneSurvives`` | 0 | Identification |
| ``PressIsIdentification`` | bridge | ``PassIsIdentification``, ``PresentedLaw`` | 0 | Presentation |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |
| ``QualitiesAreFinite`` | theorem | ``HasEncoding``, ``IntegerValued`` | 0 | Space |
| ``ResistanceHasMagnitude`` | theorem | ``DistanceOnStructures``, ``Resistant`` | 0 | Gradient |
| ``SaturationDynamics`` | bridge | ``ComparisonsAreBounded``, ``LibrarySaturates`` | 0 | Intelligence |
| ``SaturationIncorruptible`` | theorem | ``CachePermanent`` | 0 | Identification |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |
| ``ThreeAxesOfCompare`` | bridge | ``Decidable``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``Unique`` | marker | ``Monotone``, ``Null`` | 0 | Core |
| ``Universality`` | bridge | ``ExactlyOneSurvives``, ``HasEncoding`` | 0 | Identification |

### Pair

``Pair`` carries 139 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``StructuresFinite`` | kernel | ``HasSigma``, ``Pair`` | [117](<doc:AtlasUnfolded#StructuresFinite>) | Identification |
| ``OperationsClosed`` | kernel | ``Pair`` | [99](<doc:AtlasUnfolded#OperationsClosed>) | Identification |
| ``CachePermanent`` | theorem | ``HasCache``, ``OperationsClosed``, ``StructuresFinite`` | [82](<doc:AtlasUnfolded#CachePermanent>) | Identification |
| ``ResultDeterministic`` | kernel | ``OperationsClosed`` | [67](<doc:AtlasUnfolded#ResultDeterministic>) | Identification |
| ``DistanceOnStructures`` | theorem | ``HasDistance``, ``StructuresFinite`` | [61](<doc:AtlasUnfolded#DistanceOnStructures>) | Gradient |
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
| ``GateIsZeroOfLoss`` | theorem | ``DistanceOnStructures``, ``PassImpliesMembership`` | [12](<doc:AtlasUnfolded#GateIsZeroOfLoss>) | Gradient |
| ``StrategyLivesInSigma`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | [12](<doc:AtlasUnfolded#StrategyLivesInSigma>) | Strategy |
| ``AlignmentCoefficient`` | bridge | ``GateIsZeroOfLoss``, ``HasAlpha`` | [11](<doc:AtlasUnfolded#AlignmentCoefficient>) | Search |
| ``NoInverse`` | bridge | ``KnowledgeAccumulates`` | [11](<doc:AtlasUnfolded#NoInverse>) | Matter |
| ``Monotone`` | marker | ``Pair`` | [10](<doc:AtlasUnfolded#Monotone>) | Core |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``HolesCarryAddresses`` | bridge | ``AnchorGraph``, ``Decidable`` | [9](<doc:AtlasUnfolded#HolesCarryAddresses>) | Map |
| ``Measurable`` | marker | ``Pair`` | [9](<doc:AtlasUnfolded#Measurable>) | Core |
| ``BasisIsFinite`` | bridge | ``HasBasis``, ``LibrarySaturates`` | [7](<doc:AtlasUnfolded#BasisIsFinite>) | Intelligence |
| ``CandidatesOnlyLeave`` | bridge | ``CachePermanent``, ``HasSolutions`` | [7](<doc:AtlasUnfolded#CandidatesOnlyLeave>) | Identification |
| ``LiquidPhase`` | bridge | ``KnowledgeAccumulates``, ``Monotone`` | [7](<doc:AtlasUnfolded#LiquidPhase>) | Liquid |
| ``MembershipDecidable`` | theorem | ``EqualityDecidable``, ``HasSolutions`` | [7](<doc:AtlasUnfolded#MembershipDecidable>) | Intelligence |
| ``PresentedLaw`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [7](<doc:AtlasUnfolded#PresentedLaw>) | Presentation |
| ``ResultsIrreversible`` | theorem | ``CachePermanent``, ``EqualityDecidable`` | [7](<doc:AtlasUnfolded#ResultsIrreversible>) | Intelligence |
| ``RevealsNotCreates`` | kernel | ``Measurable``, ``OperationsClosed`` | [7](<doc:AtlasUnfolded#RevealsNotCreates>) | Identification |
| ``CertifiedRuleGenerates`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification`` | [6](<doc:AtlasUnfolded#CertifiedRuleGenerates>) | Play |
| ``LawLivesInSigma`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [6](<doc:AtlasUnfolded#LawLivesInSigma>) | Dynamics |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``SystemCrystallizes`` | bridge | ``CandidatesOnlyLeave``, ``MembershipDecidable``, ``ResultsIrreversible`` | [6](<doc:AtlasUnfolded#SystemCrystallizes>) | Intelligence |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``CrystallizationFront`` | bridge | ``DistanceOnStructures``, ``LiquidPhase``, ``NoInverse`` | [5](<doc:AtlasUnfolded#CrystallizationFront>) | Liquid |
| ``DiscriminatorAndGenerator`` | bridge | ``OrderIsOnlyFreedom``, ``PassImpliesMembership`` | [5](<doc:AtlasUnfolded#DiscriminatorAndGenerator>) | Generation |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
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
| ``ContentIsGaugeInvariant`` | bridge | ``HasEncoding``, ``HasGauge``, ``RevealsNotCreates`` | [1](<doc:AtlasUnfolded#ContentIsGaugeInvariant>) | Gauge |
| ``EmissionIsAutoregressive`` | bridge | ``HasEncoding``, ``HasPath``, ``ScopeBoundedByEncoding`` | [1](<doc:AtlasUnfolded#EmissionIsAutoregressive>) | Path |
| ``GatedConstruction`` | bridge | ``EmissionAccumulates``, ``SystemCrystallizes`` | [1](<doc:AtlasUnfolded#GatedConstruction>) | Path |
| ``IntegerValued`` | marker | ``Pair`` | [1](<doc:AtlasUnfolded#IntegerValued>) | Core |
| ``InterferenceIsSubstitution`` | bridge | ``PresentedLaw`` | [1](<doc:AtlasUnfolded#InterferenceIsSubstitution>) | Wave |
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
| ``DarknessIsNormalForm`` | bridge | ``InterferenceIsSubstitution`` | 0 | Wave |
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
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``LinearArbiter`` | 0 | Gauge |
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
| ``Permanent`` | marker | ``Pair`` | 0 | Core |
| ``PerspectiveIsEncoding`` | theorem | ``HasEncoding``, ``Measurable``, ``ScopeBoundedByEncoding`` | 0 | Space |
| ``PipelineCrystallizes`` | bridge | ``PassIsIdentification``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``PreconditionsGuaranteePass`` | theorem | ``ExactlyOneSurvives`` | 0 | Identification |
| ``PressIsIdentification`` | bridge | ``PassIsIdentification``, ``PresentedLaw`` | 0 | Presentation |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |
| ``QualitiesAreFinite`` | theorem | ``HasEncoding``, ``IntegerValued`` | 0 | Space |
| ``ResistanceHasMagnitude`` | theorem | ``DistanceOnStructures``, ``Resistant`` | 0 | Gradient |
| ``SaturationDynamics`` | bridge | ``ComparisonsAreBounded``, ``LibrarySaturates`` | 0 | Intelligence |
| ``SaturationIncorruptible`` | theorem | ``CachePermanent`` | 0 | Identification |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |
| ``ThreeAxesOfCompare`` | bridge | ``Decidable``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``Unique`` | marker | ``Monotone``, ``Null`` | 0 | Core |
| ``Universality`` | bridge | ``ExactlyOneSurvives``, ``HasEncoding`` | 0 | Identification |

### StructuresFinite

``StructuresFinite`` carries 117 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``CachePermanent`` | theorem | ``HasCache``, ``OperationsClosed``, ``StructuresFinite`` | [82](<doc:AtlasUnfolded#CachePermanent>) | Identification |
| ``DistanceOnStructures`` | theorem | ``HasDistance``, ``StructuresFinite`` | [61](<doc:AtlasUnfolded#DistanceOnStructures>) | Gradient |
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
| ``PresentedLaw`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [7](<doc:AtlasUnfolded#PresentedLaw>) | Presentation |
| ``ResultsIrreversible`` | theorem | ``CachePermanent``, ``EqualityDecidable`` | [7](<doc:AtlasUnfolded#ResultsIrreversible>) | Intelligence |
| ``CertifiedRuleGenerates`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification`` | [6](<doc:AtlasUnfolded#CertifiedRuleGenerates>) | Play |
| ``LawLivesInSigma`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [6](<doc:AtlasUnfolded#LawLivesInSigma>) | Dynamics |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``SystemCrystallizes`` | bridge | ``CandidatesOnlyLeave``, ``MembershipDecidable``, ``ResultsIrreversible`` | [6](<doc:AtlasUnfolded#SystemCrystallizes>) | Intelligence |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``CrystallizationFront`` | bridge | ``DistanceOnStructures``, ``LiquidPhase``, ``NoInverse`` | [5](<doc:AtlasUnfolded#CrystallizationFront>) | Liquid |
| ``DiscriminatorAndGenerator`` | bridge | ``OrderIsOnlyFreedom``, ``PassImpliesMembership`` | [5](<doc:AtlasUnfolded#DiscriminatorAndGenerator>) | Generation |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
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
| ``InterferenceIsSubstitution`` | bridge | ``PresentedLaw`` | [1](<doc:AtlasUnfolded#InterferenceIsSubstitution>) | Wave |
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
| ``DarknessIsNormalForm`` | bridge | ``InterferenceIsSubstitution`` | 0 | Wave |
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

``OperationsClosed`` carries 99 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
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
| ``RevealsNotCreates`` | kernel | ``Measurable``, ``OperationsClosed`` | [7](<doc:AtlasUnfolded#RevealsNotCreates>) | Identification |
| ``CertifiedRuleGenerates`` | bridge | ``KnowledgeAccumulates``, ``PassIsIdentification`` | [6](<doc:AtlasUnfolded#CertifiedRuleGenerates>) | Play |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``SystemCrystallizes`` | bridge | ``CandidatesOnlyLeave``, ``MembershipDecidable``, ``ResultsIrreversible`` | [6](<doc:AtlasUnfolded#SystemCrystallizes>) | Intelligence |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``CrystallizationFront`` | bridge | ``DistanceOnStructures``, ``LiquidPhase``, ``NoInverse`` | [5](<doc:AtlasUnfolded#CrystallizationFront>) | Liquid |
| ``DiscriminatorAndGenerator`` | bridge | ``OrderIsOnlyFreedom``, ``PassImpliesMembership`` | [5](<doc:AtlasUnfolded#DiscriminatorAndGenerator>) | Generation |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
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
| ``ContentIsGaugeInvariant`` | bridge | ``HasEncoding``, ``HasGauge``, ``RevealsNotCreates`` | [1](<doc:AtlasUnfolded#ContentIsGaugeInvariant>) | Gauge |
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
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``LinearArbiter`` | 0 | Gauge |
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

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

``HasDistance`` carries 79 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``DistanceOnStructures`` | theorem | ``HasDistance``, ``StructuresFinite`` | [61](<doc:AtlasUnfolded#DistanceOnStructures>) | Gradient |
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
| ``PresentedLaw`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [7](<doc:AtlasUnfolded#PresentedLaw>) | Presentation |
| ``LawLivesInSigma`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [6](<doc:AtlasUnfolded#LawLivesInSigma>) | Dynamics |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``CrystallizationFront`` | bridge | ``DistanceOnStructures``, ``LiquidPhase``, ``NoInverse`` | [5](<doc:AtlasUnfolded#CrystallizationFront>) | Liquid |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
| ``SearchFlow`` | bridge | ``AlignmentCoefficient``, ``LiquidPhase`` | [5](<doc:AtlasUnfolded#SearchFlow>) | Liquid |
| ``NavigationInevitable`` | bridge | ``OneBoundaryThreeFaces`` | [4](<doc:AtlasUnfolded#NavigationInevitable>) | Map |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``StefanCoupling`` | bridge | ``CrystallizationFront``, ``SearchFlow`` | [4](<doc:AtlasUnfolded#StefanCoupling>) | Liquid |
| ``StrategyGate`` | bridge | ``PassImpliesMembership``, ``StrategyLivesInSigma`` | [4](<doc:AtlasUnfolded#StrategyGate>) | Strategy |
| ``GateIsMembrane`` | bridge | ``StefanCoupling`` | [3](<doc:AtlasUnfolded#GateIsMembrane>) | Liquid |
| ``SearchableIffClusteredAndAligned`` | bridge | ``AlignmentCoefficient``, ``OneBoundaryThreeFaces`` | [3](<doc:AtlasUnfolded#SearchableIffClusteredAndAligned>) | Search |
| ``StrategyIsUnique`` | bridge | ``ExactlyOneSurvives``, ``StrategyGate`` | [3](<doc:AtlasUnfolded#StrategyIsUnique>) | Strategy |
| ``CostIsPathLength`` | bridge | ``HasDistance``, ``HasPath`` | [2](<doc:AtlasUnfolded#CostIsPathLength>) | Path |
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
| ``CostReadsGauge`` | bridge | ``HasDistance``, ``HasGauge`` | [1](<doc:AtlasUnfolded#CostReadsGauge>) | Gauge |
| ``DistanceIsMetric`` | bridge | ``HasCache``, ``HasDistance`` | [1](<doc:AtlasUnfolded#DistanceIsMetric>) | Space |
| ``InterferenceIsSubstitution`` | bridge | ``PresentedLaw`` | [1](<doc:AtlasUnfolded#InterferenceIsSubstitution>) | Wave |
| ``LinearArbiter`` | bridge | ``CostIsPathLength`` | [1](<doc:AtlasUnfolded#LinearArbiter>) | Gauge |
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
| ``DarknessIsNormalForm`` | bridge | ``InterferenceIsSubstitution`` | 0 | Wave |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``DistanceIsCost`` | bridge | ``DistanceOnStructures``, ``HasCost`` | 0 | Gradient |
| ``EdgesCarryTheJudgement`` | bridge | ``BehaviorIsStructure``, ``PresentedLaw`` | 0 | Presentation |
| ``FailureCurriculum`` | bridge | ``HolesCarryAddresses``, ``RepairsPermanent`` | 0 | Map |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``FormIsInvariant`` | bridge | ``PresentedLaw`` | 0 | Presentation |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``LinearArbiter`` | 0 | Gauge |
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

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

``DistanceOnStructures`` carries 61 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``AnchorGraph`` | bridge | ``DistanceOnStructures``, ``HasLibrary`` | [22](<doc:AtlasUnfolded#AnchorGraph>) | Map |
| ``BallSaturation`` | bridge | ``DistanceOnStructures``, ``LibrarySaturates`` | [15](<doc:AtlasUnfolded#BallSaturation>) | Gradient |
| ``CompressionCriterion`` | bridge | ``DistanceOnStructures``, ``Tower`` | [14](<doc:AtlasUnfolded#CompressionCriterion>) | Gradient |
| ``GateIsZeroOfLoss`` | theorem | ``DistanceOnStructures``, ``PassImpliesMembership`` | [12](<doc:AtlasUnfolded#GateIsZeroOfLoss>) | Gradient |
| ``StrategyLivesInSigma`` | bridge | ``DistanceOnStructures``, ``OrderIsOnlyFreedom`` | [12](<doc:AtlasUnfolded#StrategyLivesInSigma>) | Strategy |
| ``AlignmentCoefficient`` | bridge | ``GateIsZeroOfLoss``, ``HasAlpha`` | [11](<doc:AtlasUnfolded#AlignmentCoefficient>) | Search |
| ``OneBoundaryThreeFaces`` | bridge | ``AnchorGraph``, ``BallSaturation``, ``CompressionCriterion`` | [10](<doc:AtlasUnfolded#OneBoundaryThreeFaces>) | Map |
| ``HolesCarryAddresses`` | bridge | ``AnchorGraph``, ``Decidable`` | [9](<doc:AtlasUnfolded#HolesCarryAddresses>) | Map |
| ``PresentedLaw`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [7](<doc:AtlasUnfolded#PresentedLaw>) | Presentation |
| ``LawLivesInSigma`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [6](<doc:AtlasUnfolded#LawLivesInSigma>) | Dynamics |
| ``SkillsAreBalls`` | bridge | ``BallSaturation``, ``StrategyLivesInSigma`` | [6](<doc:AtlasUnfolded#SkillsAreBalls>) | Strategy |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``CrystallizationFront`` | bridge | ``DistanceOnStructures``, ``LiquidPhase``, ``NoInverse`` | [5](<doc:AtlasUnfolded#CrystallizationFront>) | Liquid |
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
| ``BehaviorIsStructure`` | bridge | ``DistanceOnStructures``, ``HasTime`` | [1](<doc:AtlasUnfolded#BehaviorIsStructure>) | Dynamics |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``InterferenceIsSubstitution`` | bridge | ``PresentedLaw`` | [1](<doc:AtlasUnfolded#InterferenceIsSubstitution>) | Wave |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``RepairsPermanent`` | bridge | ``AnchorGraph``, ``NoInverse`` | [1](<doc:AtlasUnfolded#RepairsPermanent>) | Map |
| ``StandardIsType`` | bridge | ``PresentedLaw`` | [1](<doc:AtlasUnfolded#StandardIsType>) | Ruler |
| ``AlignmentEnablesIntelligence`` | bridge | ``AlignmentCoefficient``, ``IntelligenceRises`` | 0 | Search |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``DarknessIsNormalForm`` | bridge | ``InterferenceIsSubstitution`` | 0 | Wave |
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

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

### PassIsIdentification

``PassIsIdentification`` carries 37 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

### Tower

``Tower`` carries 18 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
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

### HasEncoding

``HasEncoding`` carries 17 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``EncoderConditions`` | bridge | ``BallSaturation``, ``CompressionCriterion``, ``HasEncoding`` | [2](<doc:AtlasUnfolded#EncoderConditions>) | Spec |
| ``HasGrammar`` | axis | ``HasEncoding`` | [2](<doc:AtlasUnfolded#HasGrammar>) | Space |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``ContentIsGaugeInvariant`` | bridge | ``HasEncoding``, ``HasGauge``, ``RevealsNotCreates`` | [1](<doc:AtlasUnfolded#ContentIsGaugeInvariant>) | Gauge |
| ``EmissionIsAutoregressive`` | bridge | ``HasEncoding``, ``HasPath``, ``ScopeBoundedByEncoding`` | [1](<doc:AtlasUnfolded#EmissionIsAutoregressive>) | Path |
| ``EncodingForgets`` | axis | ``HasEncoding`` | [1](<doc:AtlasUnfolded#EncodingForgets>) | Seeing |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``EncodingSelectionSaturates`` | bridge | ``HasEncoding``, ``LibrarySaturates`` | 0 | Intelligence |
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``LinearArbiter`` | 0 | Gauge |
| ``PerspectiveIsEncoding`` | theorem | ``HasEncoding``, ``Measurable``, ``ScopeBoundedByEncoding`` | 0 | Space |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |
| ``QualitiesAreFinite`` | theorem | ``HasEncoding``, ``IntegerValued`` | 0 | Space |
| ``SeparatorIdentifies`` | axis | ``EncodingForgets`` | 0 | Seeing |
| ``SpaceFromDifference`` | bridge | ``DistanceIsMetric``, ``HasGrammar`` | 0 | Space |
| ``Universality`` | bridge | ``ExactlyOneSurvives``, ``HasEncoding`` | 0 | Identification |

### BallSaturation

``BallSaturation`` carries 15 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
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

### HasLaw

``HasLaw`` carries 15 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``PresentedLaw`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [7](<doc:AtlasUnfolded#PresentedLaw>) | Presentation |
| ``LawLivesInSigma`` | bridge | ``DistanceOnStructures``, ``HasLaw`` | [6](<doc:AtlasUnfolded#LawLivesInSigma>) | Dynamics |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``AmbiguityIsExperiment`` | bridge | ``HolesCarryAddresses``, ``LawIsTarget`` | [1](<doc:AtlasUnfolded#AmbiguityIsExperiment>) | Dynamics |
| ``InterferenceIsSubstitution`` | bridge | ``PresentedLaw`` | [1](<doc:AtlasUnfolded#InterferenceIsSubstitution>) | Wave |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``StandardIsType`` | bridge | ``PresentedLaw`` | [1](<doc:AtlasUnfolded#StandardIsType>) | Ruler |
| ``DarknessIsNormalForm`` | bridge | ``InterferenceIsSubstitution`` | 0 | Wave |
| ``EdgesCarryTheJudgement`` | bridge | ``BehaviorIsStructure``, ``PresentedLaw`` | 0 | Presentation |
| ``FormIsInvariant`` | bridge | ``PresentedLaw`` | 0 | Presentation |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |
| ``MeasureIsCount`` | bridge | ``StandardIsType`` | 0 | Ruler |
| ``PressIsIdentification`` | bridge | ``PassIsIdentification``, ``PresentedLaw`` | 0 | Presentation |

### CompressionCriterion

``CompressionCriterion`` carries 14 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
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

### HasPath

``HasPath`` carries 13 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``EmissionAccumulates`` | theorem | ``HasPath`` | [5](<doc:AtlasUnfolded#EmissionAccumulates>) | Path |
| ``CostIsPathLength`` | bridge | ``HasDistance``, ``HasPath`` | [2](<doc:AtlasUnfolded#CostIsPathLength>) | Path |
| ``EmissionIsAutoregressive`` | bridge | ``HasEncoding``, ``HasPath``, ``ScopeBoundedByEncoding`` | [1](<doc:AtlasUnfolded#EmissionIsAutoregressive>) | Path |
| ``GatedConstruction`` | bridge | ``EmissionAccumulates``, ``SystemCrystallizes`` | [1](<doc:AtlasUnfolded#GatedConstruction>) | Path |
| ``LinearArbiter`` | bridge | ``CostIsPathLength`` | [1](<doc:AtlasUnfolded#LinearArbiter>) | Gauge |
| ``ReachIsPath`` | bridge | ``HasBasis``, ``HasPath`` | [1](<doc:AtlasUnfolded#ReachIsPath>) | Path |
| ``CompletionIsSolutionSet`` | bridge | ``HasPath``, ``Reading`` | 0 | Path |
| ``ConstructionIsReading`` | bridge | ``EmissionAccumulates``, ``Reading`` | 0 | Path |
| ``ErasureIsRecession`` | bridge | ``EmissionAccumulates``, ``NoInverse`` | 0 | Path |
| ``FreeGeneration`` | bridge | ``DiscriminatorAndGenerator``, ``EmissionAccumulates`` | 0 | Path |
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``LinearArbiter`` | 0 | Gauge |
| ``InvalidStepFolds`` | theorem | ``HasPath``, ``Null`` | 0 | Path |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |

### GateIsZeroOfLoss

``GateIsZeroOfLoss`` carries 12 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

### StrategyLivesInSigma

``StrategyLivesInSigma`` carries 12 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

### HasBasis

``HasBasis`` carries 10 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

### Measurable

``Measurable`` carries 9 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``RevealsNotCreates`` | kernel | ``Measurable``, ``OperationsClosed`` | [7](<doc:AtlasUnfolded#RevealsNotCreates>) | Identification |
| ``Reading`` | bridge | ``HasTime``, ``OrderIsOnlyFreedom``, ``RevealsNotCreates`` | [2](<doc:AtlasUnfolded#Reading>) | Reading |
| ``ContentIsGaugeInvariant`` | bridge | ``HasEncoding``, ``HasGauge``, ``RevealsNotCreates`` | [1](<doc:AtlasUnfolded#ContentIsGaugeInvariant>) | Gauge |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``CompletionIsSolutionSet`` | bridge | ``HasPath``, ``Reading`` | 0 | Path |
| ``ConstructionIsReading`` | bridge | ``EmissionAccumulates``, ``Reading`` | 0 | Path |
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``LinearArbiter`` | 0 | Gauge |
| ``PerspectiveIsEncoding`` | theorem | ``HasEncoding``, ``Measurable``, ``ScopeBoundedByEncoding`` | 0 | Space |

### BasisIsFinite

``BasisIsFinite`` carries 7 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
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

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``CrystallizationFront`` | bridge | ``DistanceOnStructures``, ``LiquidPhase``, ``NoInverse`` | [5](<doc:AtlasUnfolded#CrystallizationFront>) | Liquid |
| ``SearchFlow`` | bridge | ``AlignmentCoefficient``, ``LiquidPhase`` | [5](<doc:AtlasUnfolded#SearchFlow>) | Liquid |
| ``StefanCoupling`` | bridge | ``CrystallizationFront``, ``SearchFlow`` | [4](<doc:AtlasUnfolded#StefanCoupling>) | Liquid |
| ``GateIsMembrane`` | bridge | ``StefanCoupling`` | [3](<doc:AtlasUnfolded#GateIsMembrane>) | Liquid |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |

### MembershipDecidable

``MembershipDecidable`` carries 7 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``SystemCrystallizes`` | bridge | ``CandidatesOnlyLeave``, ``MembershipDecidable``, ``ResultsIrreversible`` | [6](<doc:AtlasUnfolded#SystemCrystallizes>) | Intelligence |
| ``GatedConstruction`` | bridge | ``EmissionAccumulates``, ``SystemCrystallizes`` | [1](<doc:AtlasUnfolded#GatedConstruction>) | Path |
| ``Converges`` | bridge | ``NoInverse``, ``SystemCrystallizes`` | 0 | Matter |
| ``GaugeFixing`` | bridge | ``CostReadsGauge``, ``SystemCrystallizes`` | 0 | Gauge |
| ``LibraryCrystallizes`` | bridge | ``LibrarySaturates``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``PipelineCrystallizes`` | bridge | ``PassIsIdentification``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |

### PresentedLaw

``PresentedLaw`` carries 7 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``InterferenceIsSubstitution`` | bridge | ``PresentedLaw`` | [1](<doc:AtlasUnfolded#InterferenceIsSubstitution>) | Wave |
| ``StandardIsType`` | bridge | ``PresentedLaw`` | [1](<doc:AtlasUnfolded#StandardIsType>) | Ruler |
| ``DarknessIsNormalForm`` | bridge | ``InterferenceIsSubstitution`` | 0 | Wave |
| ``EdgesCarryTheJudgement`` | bridge | ``BehaviorIsStructure``, ``PresentedLaw`` | 0 | Presentation |
| ``FormIsInvariant`` | bridge | ``PresentedLaw`` | 0 | Presentation |
| ``MeasureIsCount`` | bridge | ``StandardIsType`` | 0 | Ruler |
| ``PressIsIdentification`` | bridge | ``PassIsIdentification``, ``PresentedLaw`` | 0 | Presentation |

### ResultsIrreversible

``ResultsIrreversible`` carries 7 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``SystemCrystallizes`` | bridge | ``CandidatesOnlyLeave``, ``MembershipDecidable``, ``ResultsIrreversible`` | [6](<doc:AtlasUnfolded#SystemCrystallizes>) | Intelligence |
| ``GatedConstruction`` | bridge | ``EmissionAccumulates``, ``SystemCrystallizes`` | [1](<doc:AtlasUnfolded#GatedConstruction>) | Path |
| ``Converges`` | bridge | ``NoInverse``, ``SystemCrystallizes`` | 0 | Matter |
| ``GaugeFixing`` | bridge | ``CostReadsGauge``, ``SystemCrystallizes`` | 0 | Gauge |
| ``LibraryCrystallizes`` | bridge | ``LibrarySaturates``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``PipelineCrystallizes`` | bridge | ``PassIsIdentification``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |

### RevealsNotCreates

``RevealsNotCreates`` carries 7 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``Reading`` | bridge | ``HasTime``, ``OrderIsOnlyFreedom``, ``RevealsNotCreates`` | [2](<doc:AtlasUnfolded#Reading>) | Reading |
| ``ContentIsGaugeInvariant`` | bridge | ``HasEncoding``, ``HasGauge``, ``RevealsNotCreates`` | [1](<doc:AtlasUnfolded#ContentIsGaugeInvariant>) | Gauge |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``CompletionIsSolutionSet`` | bridge | ``HasPath``, ``Reading`` | 0 | Path |
| ``ConstructionIsReading`` | bridge | ``EmissionAccumulates``, ``Reading`` | 0 | Path |
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``LinearArbiter`` | 0 | Gauge |

### CertifiedRuleGenerates

``CertifiedRuleGenerates`` carries 6 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``AmbiguityNamesInput`` | bridge | ``CertifiedRuleGenerates``, ``HolesCarryAddresses`` | [5](<doc:AtlasUnfolded#AmbiguityNamesInput>) | Play |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |

### LawLivesInSigma

``LawLivesInSigma`` carries 6 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``AmbiguityIsExperiment`` | bridge | ``HolesCarryAddresses``, ``LawIsTarget`` | [1](<doc:AtlasUnfolded#AmbiguityIsExperiment>) | Dynamics |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |

### SkillsAreBalls

``SkillsAreBalls`` carries 6 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``FourthFace`` | bridge | ``OneBoundaryThreeFaces``, ``SkillsAreBalls`` | [2](<doc:AtlasUnfolded#FourthFace>) | Strategy |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |

### SystemCrystallizes

``SystemCrystallizes`` carries 6 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``GatedConstruction`` | bridge | ``EmissionAccumulates``, ``SystemCrystallizes`` | [1](<doc:AtlasUnfolded#GatedConstruction>) | Path |
| ``Converges`` | bridge | ``NoInverse``, ``SystemCrystallizes`` | 0 | Matter |
| ``GaugeFixing`` | bridge | ``CostReadsGauge``, ``SystemCrystallizes`` | 0 | Gauge |
| ``LibraryCrystallizes`` | bridge | ``LibrarySaturates``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``PipelineCrystallizes`` | bridge | ``PassIsIdentification``, ``SystemCrystallizes`` | 0 | Intelligence |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |

### AmbiguityNamesInput

``AmbiguityNamesInput`` carries 5 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``SelfPlaySaturates`` | bridge | ``AmbiguityNamesInput``, ``BasisIsFinite`` | [4](<doc:AtlasUnfolded#SelfPlaySaturates>) | Play |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |

### CrystallizationFront

``CrystallizationFront`` carries 5 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``StefanCoupling`` | bridge | ``CrystallizationFront``, ``SearchFlow`` | [4](<doc:AtlasUnfolded#StefanCoupling>) | Liquid |
| ``GateIsMembrane`` | bridge | ``StefanCoupling`` | [3](<doc:AtlasUnfolded#GateIsMembrane>) | Liquid |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |

### DiscriminatorAndGenerator

``DiscriminatorAndGenerator`` carries 5 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``FreeGeneration`` | bridge | ``DiscriminatorAndGenerator``, ``EmissionAccumulates`` | 0 | Path |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``OrgansAreOneCompare`` | bridge | ``Decidable``, ``DiscriminatorAndGenerator`` | 0 | Generation |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |

### EmissionAccumulates

``EmissionAccumulates`` carries 5 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``GatedConstruction`` | bridge | ``EmissionAccumulates``, ``SystemCrystallizes`` | [1](<doc:AtlasUnfolded#GatedConstruction>) | Path |
| ``ConstructionIsReading`` | bridge | ``EmissionAccumulates``, ``Reading`` | 0 | Path |
| ``ErasureIsRecession`` | bridge | ``EmissionAccumulates``, ``NoInverse`` | 0 | Path |
| ``FreeGeneration`` | bridge | ``DiscriminatorAndGenerator``, ``EmissionAccumulates`` | 0 | Path |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |

### LawIsTarget

``LawIsTarget`` carries 5 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``AmbiguityIsExperiment`` | bridge | ``HolesCarryAddresses``, ``LawIsTarget`` | [1](<doc:AtlasUnfolded#AmbiguityIsExperiment>) | Dynamics |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``LawfulDrift`` | bridge | ``LawIsTarget``, ``Tower`` | 0 | Dynamics |

### ScopeBoundedByEncoding

``ScopeBoundedByEncoding`` carries 5 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``EmissionIsAutoregressive`` | bridge | ``HasEncoding``, ``HasPath``, ``ScopeBoundedByEncoding`` | [1](<doc:AtlasUnfolded#EmissionIsAutoregressive>) | Path |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |
| ``PerspectiveIsEncoding`` | theorem | ``HasEncoding``, ``Measurable``, ``ScopeBoundedByEncoding`` | 0 | Space |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |

### SearchFlow

``SearchFlow`` carries 5 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``StefanCoupling`` | bridge | ``CrystallizationFront``, ``SearchFlow`` | [4](<doc:AtlasUnfolded#StefanCoupling>) | Liquid |
| ``GateIsMembrane`` | bridge | ``StefanCoupling`` | [3](<doc:AtlasUnfolded#GateIsMembrane>) | Liquid |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |

### HasEfficiency

``HasEfficiency`` carries 4 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``IntelligenceRises`` | bridge | ``HasEfficiency``, ``LibrarySaturates`` | [3](<doc:AtlasUnfolded#IntelligenceRises>) | Intelligence |
| ``AlignmentEnablesIntelligence`` | bridge | ``AlignmentCoefficient``, ``IntelligenceRises`` | 0 | Search |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``InterferenceIsIntelligence`` | bridge | ``IntelligenceRises``, ``OrderIsOnlyFreedom`` | 0 | Interference |

### HasGauge

``HasGauge`` carries 4 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``ContentIsGaugeInvariant`` | bridge | ``HasEncoding``, ``HasGauge``, ``RevealsNotCreates`` | [1](<doc:AtlasUnfolded#ContentIsGaugeInvariant>) | Gauge |
| ``CostReadsGauge`` | bridge | ``HasDistance``, ``HasGauge`` | [1](<doc:AtlasUnfolded#CostReadsGauge>) | Gauge |
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``LinearArbiter`` | 0 | Gauge |
| ``GaugeFixing`` | bridge | ``CostReadsGauge``, ``SystemCrystallizes`` | 0 | Gauge |

### NavigationInevitable

``NavigationInevitable`` carries 4 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``PlanningIsNavigation`` | bridge | ``LawIsTarget``, ``NavigationInevitable`` | [2](<doc:AtlasUnfolded#PlanningIsNavigation>) | Dynamics |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |

### SelfPlaySaturates

``SelfPlaySaturates`` carries 4 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``TowerSelfPlay`` | bridge | ``Ignites``, ``SelfPlaySaturates`` | [2](<doc:AtlasUnfolded#TowerSelfPlay>) | Play |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``SecondEncodingIsNovelty`` | bridge | ``ScopeBoundedByEncoding``, ``SelfPlaySaturates`` | 0 | Play |

### StefanCoupling

``StefanCoupling`` carries 4 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``GateIsMembrane`` | bridge | ``StefanCoupling`` | [3](<doc:AtlasUnfolded#GateIsMembrane>) | Liquid |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |

### StrategyGate

``StrategyGate`` carries 4 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``StrategyIsUnique`` | bridge | ``ExactlyOneSurvives``, ``StrategyGate`` | [3](<doc:AtlasUnfolded#StrategyIsUnique>) | Strategy |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |

### ComparisonsAreBounded

``ComparisonsAreBounded`` carries 3 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``CommunicationBounded`` | theorem | ``ComparisonsAreBounded``, ``HasCache`` | 0 | Space |
| ``FiniteDiscovery`` | bridge | ``ComparisonsAreBounded``, ``Tower`` | 0 | Matter |
| ``SaturationDynamics`` | bridge | ``ComparisonsAreBounded``, ``LibrarySaturates`` | 0 | Intelligence |

### GateIsMembrane

``GateIsMembrane`` carries 3 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |
| ``GateWrapper`` | bridge | ``DiscriminatorAndGenerator``, ``GateIsMembrane`` | 0 | Projection |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |

### IntelligenceRises

``IntelligenceRises`` carries 3 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``AlignmentEnablesIntelligence`` | bridge | ``AlignmentCoefficient``, ``IntelligenceRises`` | 0 | Search |
| ``InevitabilityIsDiscriminator`` | bridge | ``AlignmentCoefficient``, ``DiscriminatorAndGenerator``, ``IntelligenceRises`` | 0 | Generation |
| ``InterferenceIsIntelligence`` | bridge | ``IntelligenceRises``, ``OrderIsOnlyFreedom`` | 0 | Interference |

### SearchableIffClusteredAndAligned

``SearchableIffClusteredAndAligned`` carries 3 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``OrthogonalOrgans`` | bridge | ``DiscriminatorAndGenerator``, ``SearchableIffClusteredAndAligned`` | 0 | Generation |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |

### StrategyIsUnique

``StrategyIsUnique`` carries 3 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``StrategyCrystallizes`` | bridge | ``Matter``, ``StrategyIsUnique`` | [2](<doc:AtlasUnfolded#StrategyCrystallizes>) | Strategy |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |

### CostIsPathLength

``CostIsPathLength`` carries 2 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``LinearArbiter`` | bridge | ``CostIsPathLength`` | [1](<doc:AtlasUnfolded#LinearArbiter>) | Gauge |
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``LinearArbiter`` | 0 | Gauge |

### EncoderConditions

``EncoderConditions`` carries 2 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``ConditionalSolving`` | bridge | ``EncoderConditions`` | [1](<doc:AtlasUnfolded#ConditionalSolving>) | Spec |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |

### FourthFace

``FourthFace`` carries 2 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``MeasuredGeometry`` | bridge | ``FourthFace``, ``SearchableIffClusteredAndAligned`` | [1](<doc:AtlasUnfolded#MeasuredGeometry>) | Spec |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |

### HasCompositionalNorm

``HasCompositionalNorm`` carries 2 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``AtomBasis`` | bridge | ``BasisIsFinite``, ``HasCompositionalNorm``, ``RulesCompose`` | [1](<doc:AtlasUnfolded#AtomBasis>) | Basis |
| ``AtomnessIsTrajectory`` | bridge | ``AtomBasis``, ``NoInverse`` | 0 | Basis |

### HasGrammar

``HasGrammar`` carries 2 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``DepthIsBounded`` | bridge | ``HasGrammar``, ``Tower`` | 0 | Space |
| ``SpaceFromDifference`` | bridge | ``DistanceIsMetric``, ``HasGrammar`` | 0 | Space |

### PlanningIsNavigation

``PlanningIsNavigation`` carries 2 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``MotorSkillsAreStrategies`` | bridge | ``PlanningIsNavigation``, ``SkillsAreBalls`` | [1](<doc:AtlasUnfolded#MotorSkillsAreStrategies>) | Dynamics |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |

### Reading

``Reading`` carries 2 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``CompletionIsSolutionSet`` | bridge | ``HasPath``, ``Reading`` | 0 | Path |
| ``ConstructionIsReading`` | bridge | ``EmissionAccumulates``, ``Reading`` | 0 | Path |

### RulesCompose

``RulesCompose`` carries 2 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``AtomBasis`` | bridge | ``BasisIsFinite``, ``HasCompositionalNorm``, ``RulesCompose`` | [1](<doc:AtlasUnfolded#AtomBasis>) | Basis |
| ``AtomnessIsTrajectory`` | bridge | ``AtomBasis``, ``NoInverse`` | 0 | Basis |

### StrategyCrystallizes

``StrategyCrystallizes`` carries 2 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``PhaseBecomesAmplitude`` | bridge | ``StrategyCrystallizes`` | [1](<doc:AtlasUnfolded#PhaseBecomesAmplitude>) | Strategy |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |

### TowerSelfPlay

``TowerSelfPlay`` carries 2 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``PlayIsProof`` | bridge | ``RevealsNotCreates``, ``TowerSelfPlay`` | [1](<doc:AtlasUnfolded#PlayIsProof>) | Play |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |

### AmbiguityIsExperiment

``AmbiguityIsExperiment`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |

### AtomBasis

``AtomBasis`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``AtomnessIsTrajectory`` | bridge | ``AtomBasis``, ``NoInverse`` | 0 | Basis |

### BehaviorIsStructure

``BehaviorIsStructure`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``EdgesCarryTheJudgement`` | bridge | ``BehaviorIsStructure``, ``PresentedLaw`` | 0 | Presentation |

### ConditionalSolving

``ConditionalSolving`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``DifficultyIsEncoder`` | bridge | ``ConditionalSolving``, ``ScopeBoundedByEncoding`` | 0 | Spec |

### ContentIsGaugeInvariant

``ContentIsGaugeInvariant`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``LinearArbiter`` | 0 | Gauge |

### CostReadsGauge

``CostReadsGauge`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``GaugeFixing`` | bridge | ``CostReadsGauge``, ``SystemCrystallizes`` | 0 | Gauge |

### DistanceIsMetric

``DistanceIsMetric`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``SpaceFromDifference`` | bridge | ``DistanceIsMetric``, ``HasGrammar`` | 0 | Space |

### EmissionIsAutoregressive

``EmissionIsAutoregressive`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |

### EncodingForgets

``EncodingForgets`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``SeparatorIdentifies`` | axis | ``EncodingForgets`` | 0 | Seeing |

### GatedConstruction

``GatedConstruction`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |

### IntegerValued

``IntegerValued`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``QualitiesAreFinite`` | theorem | ``HasEncoding``, ``IntegerValued`` | 0 | Space |

### InterferenceIsSubstitution

``InterferenceIsSubstitution`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``DarknessIsNormalForm`` | bridge | ``InterferenceIsSubstitution`` | 0 | Wave |

### LinearArbiter

``LinearArbiter`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``GaugeCollapse`` | bridge | ``ContentIsGaugeInvariant``, ``LinearArbiter`` | 0 | Gauge |

### MeasuredGeometry

``MeasuredGeometry`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``SaturationMap`` | bridge | ``GateIsMembrane``, ``MeasuredGeometry`` | 0 | Projection |

### MotorSkillsAreStrategies

``MotorSkillsAreStrategies`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``InteractiveDecomposition`` | bridge | ``AmbiguityIsExperiment``, ``MotorSkillsAreStrategies`` | 0 | Dynamics |

### PhaseBecomesAmplitude

``PhaseBecomesAmplitude`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``CompleteEntry`` | bridge | ``HasEncoding``, ``PhaseBecomesAmplitude`` | 0 | Strategy |

### PlayIsProof

``PlayIsProof`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``AllCoordinatesPresent`` | bridge | ``GateIsMembrane``, ``PlayIsProof`` | 0 | Projection |

### ReachIsPath

``ReachIsPath`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``ProgramIsPath`` | bridge | ``EmissionIsAutoregressive``, ``GatedConstruction``, ``ReachIsPath`` | 0 | Path |

### RepairsPermanent

``RepairsPermanent`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``FailureCurriculum`` | bridge | ``HolesCarryAddresses``, ``RepairsPermanent`` | 0 | Map |

### StandardIsType

``StandardIsType`` carries 1 claims, listed heaviest first. Every number below opens a further cone, strictly smaller than this one.

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``MeasureIsCount`` | bridge | ``StandardIsType`` | 0 | Ruler |
