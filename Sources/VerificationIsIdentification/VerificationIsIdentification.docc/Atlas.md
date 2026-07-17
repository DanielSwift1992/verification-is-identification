# Atlas

One row per claim of the theory: what it stands on, and how much stands on it. The table is printed from the compiler's own dependency record, never drawn or edited by hand.

Each claim is one Swift protocol, and one claim standing on another is that protocol refining it. The compiler therefore already holds the full dependency graph of the theory, and this page prints it as a table. **Stands on** lists the claim's direct premises. **Carries** counts every claim that rests on it, directly or through others: remove this row and that many claims stop compiling. The heaviest rows are the assumptions the theory leans on. **Kind** is computed from the row's shape, not assigned: a *seed* is one of the two primitives everything is built from, an *axis* opens a coordinate the theory can vary along, a *bridge* joins axes into a theorem, a *marker* names a property used as a constraint, a *kernel* is core machinery between the seed and the axes.

The table is testable. Delete any claim's declaration from the source and build: the compiler lists every claim that falls, and the length of that list is this table's Carries number. The table and the compiler read the same source, so the two counts cannot drift apart.

A cycle between claims cannot exist here: a circular protocol hierarchy does not compile. Acyclicity is built into the language.

## The load, heaviest first

| Claim | Kind | Stands on | Carries | Home |
| --- | --- | --- | --- | --- |
| ``HasSigma`` | axis | — | [151](<doc:AtlasUnfolded#HasSigma>) | Core |
| ``Structure`` | marker | — | [143](<doc:AtlasUnfolded#Structure>) | Primitive |
| ``Open`` | kernel | ``Structure`` | [141](<doc:AtlasUnfolded#Open>) | Primitive |
| ``Pair`` | seed | ``Open`` | [139](<doc:AtlasUnfolded#Pair>) | Primitive |
| ``StructuresFinite`` | kernel | ``HasSigma``, ``Pair`` | [117](<doc:AtlasUnfolded#StructuresFinite>) | Identification |
| ``OperationsClosed`` | kernel | ``Pair`` | [99](<doc:AtlasUnfolded#OperationsClosed>) | Identification |
| ``HasCache`` | axis | ``HasSigma`` | [86](<doc:AtlasUnfolded#HasCache>) | Core |
| ``CachePermanent`` | theorem | ``HasCache``, ``OperationsClosed``, ``StructuresFinite`` | [82](<doc:AtlasUnfolded#CachePermanent>) | Identification |
| ``HasDistance`` | axis | ``HasSigma`` | [79](<doc:AtlasUnfolded#HasDistance>) | Core |
| ``HasSolutions`` | axis | ``HasSigma`` | [67](<doc:AtlasUnfolded#HasSolutions>) | Core |
| ``ResultDeterministic`` | kernel | ``OperationsClosed`` | [67](<doc:AtlasUnfolded#ResultDeterministic>) | Identification |
| ``HasLibrary`` | axis | ``HasSigma`` | [66](<doc:AtlasUnfolded#HasLibrary>) | Core |
| ``DistanceOnStructures`` | theorem | ``HasDistance``, ``StructuresFinite`` | [61](<doc:AtlasUnfolded#DistanceOnStructures>) | Gradient |
| ``StepsTerminate`` | kernel | ``StructuresFinite`` | [54](<doc:AtlasUnfolded#StepsTerminate>) | Identification |
| ``PipelineTotal`` | kernel | ``StepsTerminate`` | [52](<doc:AtlasUnfolded#PipelineTotal>) | Identification |
| ``EqualityDecidable`` | kernel | ``StructuresFinite`` | [51](<doc:AtlasUnfolded#EqualityDecidable>) | Identification |
| ``PassImpliesMembership`` | kernel | ``PipelineTotal``, ``ResultDeterministic`` | [51](<doc:AtlasUnfolded#PassImpliesMembership>) | Identification |
| ``KnowledgeAccumulates`` | bridge | ``CachePermanent``, ``HasLibrary`` | [45](<doc:AtlasUnfolded#KnowledgeAccumulates>) | Intelligence |
| ``ExactlyOneSurvives`` | theorem | ``EqualityDecidable``, ``HasSolutions`` | [42](<doc:AtlasUnfolded#ExactlyOneSurvives>) | Identification |
| ``HasSaturation`` | axis | ``HasLibrary`` | [39](<doc:AtlasUnfolded#HasSaturation>) | Core |
| ``Decidable`` | marker | ``Pair`` | [38](<doc:AtlasUnfolded#Decidable>) | Core |
| ``LibrarySaturates`` | bridge | ``CachePermanent``, ``HasSaturation`` | [38](<doc:AtlasUnfolded#LibrarySaturates>) | Intelligence |
| ``PassIsIdentification`` | theorem | ``ExactlyOneSurvives``, ``PassImpliesMembership`` | [37](<doc:AtlasUnfolded#PassIsIdentification>) | Identification |
| ``Null`` | seed | ``Pair`` | [32](<doc:AtlasUnfolded#Null>) | Primitive |
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
| ``EmissionAccumulates`` | theorem | ``HasPath`` | [5](<doc:AtlasUnfolded#EmissionAccumulates>) | Path |
| ``LawIsTarget`` | bridge | ``LawLivesInSigma``, ``PassIsIdentification`` | [5](<doc:AtlasUnfolded#LawIsTarget>) | Dynamics |
| ``ScopeBoundedByEncoding`` | kernel | ``ResultDeterministic`` | [5](<doc:AtlasUnfolded#ScopeBoundedByEncoding>) | Identification |
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
| ``IntegerValued`` | marker | ``Pair`` | [1](<doc:AtlasUnfolded#IntegerValued>) | Core |
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
| ``SeparatorIdentifies`` | axis | ``EncodingForgets`` | 0 | Seeing |
| ``SpaceFromDifference`` | bridge | ``DistanceIsMetric``, ``HasGrammar`` | 0 | Space |
| ``StrategyNavigation`` | bridge | ``NavigationInevitable``, ``SkillsAreBalls`` | 0 | Strategy |
| ``ThreeAxesOfCompare`` | bridge | ``Decidable``, ``OrderIsOnlyFreedom`` | 0 | Interference |
| ``Unique`` | marker | ``Monotone``, ``Null`` | 0 | Core |
| ``Universality`` | bridge | ``ExactlyOneSurvives``, ``HasEncoding`` | 0 | Identification |
