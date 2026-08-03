# Which premises the build needs

Every claim in the theory rests on premises. This page asks which of them
the compiler needs. Each premise was cut from its declaration, the module
was rebuilt, and the file was put back.

Of 2396 premises the module needs 5. It builds without the other 2184,
and 207 name a premise the compiler inherits, so they have no line to cut.

A row reads as a sentence: this claim names this premise, declared at that
line, and the module without the premise either still builds or fails.
When it fails, the last column lists what stops compiling. A row that
still builds asks a reader instead, and the papers carry its case.

The five the module needs:

- ``HasCompositionalNorm`` needs ``HasDistance``, at Sources/VerificationIsIdentification/Basis.swift:27
- ``KnowledgeAccumulates`` needs ``HasLibrary``, at Sources/VerificationIsIdentification/Intelligence.swift:15
- ``Open`` needs ``Structure``, at Sources/VerificationIsIdentification/Primitive.swift:70
- ``Close`` needs ``Structure``, at Sources/VerificationIsIdentification/Primitive.swift:88
- ``Pair`` needs ``Open``, at Sources/VerificationIsIdentification/Primitive.swift:102

The map behind this table is <doc:Atlas>, and the cone behind every count
there is <doc:AtlasUnfolded>.

The premise list is the compiler's own symbol graph, the file tree-sort
reads, so the lattice has one reader. The run took 4158s over the
lattice at revision 95014c7. Rerun it
yourself: `swift build --product Tools && .build/debug/Tools ablate
<symbols.json>`. The build writes the graph file under
`.build/*/extracted-symbols/`.

| claim | premise | declared at | the module without it | what stops compiling |
|---|---|---|---|---|
| ``RulesCompose`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Basis.swift:21 | still builds |  |
| ``RulesCompose`` | ``HasCache`` | Sources/VerificationIsIdentification/Basis.swift:21 | still builds |  |
| ``RulesCompose`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Basis.swift:21 | still builds |  |
| ``RulesCompose`` | ``HasSigma`` | Sources/VerificationIsIdentification/Basis.swift:21 | still builds |  |
| ``RulesCompose`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Basis.swift:21 | still builds |  |
| ``RulesCompose`` | ``Open`` | Sources/VerificationIsIdentification/Basis.swift:21 | still builds |  |
| ``RulesCompose`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Basis.swift:21 | still builds |  |
| ``RulesCompose`` | ``Pair`` | Sources/VerificationIsIdentification/Basis.swift:21 | still builds |  |
| ``RulesCompose`` | ``Structure`` | Sources/VerificationIsIdentification/Basis.swift:21 | still builds |  |
| ``RulesCompose`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Basis.swift:21 | still builds |  |
| ``HasCompositionalNorm`` | ``HasDistance`` | Sources/VerificationIsIdentification/Basis.swift:27 | fails | Distance |
| ``HasCompositionalNorm`` | ``HasSigma`` | Sources/VerificationIsIdentification/Basis.swift:27 | still builds |  |
| ``AtomBasis`` | ``BasisIsFinite`` | Sources/VerificationIsIdentification/Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``HasBasis`` | Sources/VerificationIsIdentification/Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``HasCache`` | Sources/VerificationIsIdentification/Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``HasCompositionalNorm`` | Sources/VerificationIsIdentification/Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``HasDistance`` | Sources/VerificationIsIdentification/Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``HasSigma`` | Sources/VerificationIsIdentification/Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``Open`` | Sources/VerificationIsIdentification/Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``Pair`` | Sources/VerificationIsIdentification/Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``RulesCompose`` | Sources/VerificationIsIdentification/Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``Structure`` | Sources/VerificationIsIdentification/Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Basis.swift:44 | inherited, no line to cut |  |
| ``AtomnessIsTrajectory`` | ``AtomBasis`` | Sources/VerificationIsIdentification/Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``BasisIsFinite`` | Sources/VerificationIsIdentification/Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``HasBasis`` | Sources/VerificationIsIdentification/Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``HasCache`` | Sources/VerificationIsIdentification/Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``HasCompositionalNorm`` | Sources/VerificationIsIdentification/Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``HasDistance`` | Sources/VerificationIsIdentification/Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``HasSigma`` | Sources/VerificationIsIdentification/Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``NoInverse`` | Sources/VerificationIsIdentification/Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``Open`` | Sources/VerificationIsIdentification/Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``Pair`` | Sources/VerificationIsIdentification/Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``RulesCompose`` | Sources/VerificationIsIdentification/Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``Structure`` | Sources/VerificationIsIdentification/Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Basis.swift:53 | still builds |  |
| ``ColourIsQuotient`` | ``EncodingForgets`` | Sources/VerificationIsIdentification/Colour.swift:16 | still builds |  |
| ``ColourIsQuotient`` | ``HasEncoding`` | Sources/VerificationIsIdentification/Colour.swift:16 | still builds |  |
| ``ColourIsQuotient`` | ``HasSigma`` | Sources/VerificationIsIdentification/Colour.swift:16 | still builds |  |
| ``GamutIsCone`` | ``ColourIsQuotient`` | Sources/VerificationIsIdentification/Colour.swift:27 | still builds |  |
| ``GamutIsCone`` | ``EncodingForgets`` | Sources/VerificationIsIdentification/Colour.swift:27 | still builds |  |
| ``GamutIsCone`` | ``HasEncoding`` | Sources/VerificationIsIdentification/Colour.swift:27 | still builds |  |
| ``GamutIsCone`` | ``HasSigma`` | Sources/VerificationIsIdentification/Colour.swift:27 | still builds |  |
| ``Unique`` | ``Monotone`` | Sources/VerificationIsIdentification/Core.swift:25 | still builds |  |
| ``Unique`` | ``Null`` | Sources/VerificationIsIdentification/Core.swift:25 | still builds |  |
| ``Unique`` | ``Open`` | Sources/VerificationIsIdentification/Core.swift:25 | still builds |  |
| ``Unique`` | ``Pair`` | Sources/VerificationIsIdentification/Core.swift:25 | still builds |  |
| ``Unique`` | ``Structure`` | Sources/VerificationIsIdentification/Core.swift:25 | still builds |  |
| ``Permanent`` | ``Open`` | Sources/VerificationIsIdentification/Core.swift:32 | inherited, no line to cut |  |
| ``Permanent`` | ``Pair`` | Sources/VerificationIsIdentification/Core.swift:32 | inherited, no line to cut |  |
| ``Permanent`` | ``Structure`` | Sources/VerificationIsIdentification/Core.swift:32 | inherited, no line to cut |  |
| ``Monotone`` | ``Open`` | Sources/VerificationIsIdentification/Core.swift:40 | inherited, no line to cut |  |
| ``Monotone`` | ``Pair`` | Sources/VerificationIsIdentification/Core.swift:40 | inherited, no line to cut |  |
| ``Monotone`` | ``Structure`` | Sources/VerificationIsIdentification/Core.swift:40 | inherited, no line to cut |  |
| ``Decidable`` | ``Open`` | Sources/VerificationIsIdentification/Core.swift:47 | inherited, no line to cut |  |
| ``Decidable`` | ``Pair`` | Sources/VerificationIsIdentification/Core.swift:47 | inherited, no line to cut |  |
| ``Decidable`` | ``Structure`` | Sources/VerificationIsIdentification/Core.swift:47 | inherited, no line to cut |  |
| ``MetricProperty`` | ``Open`` | Sources/VerificationIsIdentification/Core.swift:55 | inherited, no line to cut |  |
| ``MetricProperty`` | ``Pair`` | Sources/VerificationIsIdentification/Core.swift:55 | inherited, no line to cut |  |
| ``MetricProperty`` | ``Structure`` | Sources/VerificationIsIdentification/Core.swift:55 | inherited, no line to cut |  |
| ``IntegerValued`` | ``Open`` | Sources/VerificationIsIdentification/Core.swift:64 | inherited, no line to cut |  |
| ``IntegerValued`` | ``Pair`` | Sources/VerificationIsIdentification/Core.swift:64 | inherited, no line to cut |  |
| ``IntegerValued`` | ``Structure`` | Sources/VerificationIsIdentification/Core.swift:64 | inherited, no line to cut |  |
| ``Measurable`` | ``Open`` | Sources/VerificationIsIdentification/Core.swift:71 | inherited, no line to cut |  |
| ``Measurable`` | ``Pair`` | Sources/VerificationIsIdentification/Core.swift:71 | inherited, no line to cut |  |
| ``Measurable`` | ``Structure`` | Sources/VerificationIsIdentification/Core.swift:71 | inherited, no line to cut |  |
| ``HasSolutions`` | ``HasSigma`` | Sources/VerificationIsIdentification/Core.swift:111 | still builds |  |
| ``HasLibrary`` | ``HasSigma`` | Sources/VerificationIsIdentification/Core.swift:119 | still builds |  |
| ``HasCache`` | ``HasSigma`` | Sources/VerificationIsIdentification/Core.swift:127 | still builds |  |
| ``HasDistance`` | ``HasSigma`` | Sources/VerificationIsIdentification/Core.swift:136 | still builds |  |
| ``HasEncoding`` | ``HasSigma`` | Sources/VerificationIsIdentification/Core.swift:144 | still builds |  |
| ``HasAlpha`` | ``HasDistance`` | Sources/VerificationIsIdentification/Core.swift:153 | still builds |  |
| ``HasAlpha`` | ``HasSigma`` | Sources/VerificationIsIdentification/Core.swift:153 | still builds |  |
| ``HasBasis`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Core.swift:162 | still builds |  |
| ``HasBasis`` | ``HasSigma`` | Sources/VerificationIsIdentification/Core.swift:162 | still builds |  |
| ``HasSaturation`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Core.swift:171 | still builds |  |
| ``HasSaturation`` | ``HasSigma`` | Sources/VerificationIsIdentification/Core.swift:171 | still builds |  |
| ``IdentityCollapse`` | ``HasSigma`` | Sources/VerificationIsIdentification/Core.swift:196 | inherited, no line to cut |  |
| ``IdentityCollapse`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Core.swift:196 | inherited, no line to cut |  |
| ``IdentityCollapse`` | ``Null`` | Sources/VerificationIsIdentification/Core.swift:196 | inherited, no line to cut |  |
| ``IdentityCollapse`` | ``Open`` | Sources/VerificationIsIdentification/Core.swift:196 | inherited, no line to cut |  |
| ``IdentityCollapse`` | ``Pair`` | Sources/VerificationIsIdentification/Core.swift:196 | inherited, no line to cut |  |
| ``IdentityCollapse`` | ``Structure`` | Sources/VerificationIsIdentification/Core.swift:196 | inherited, no line to cut |  |
| ``HasLaw`` | ``HasSigma`` | Sources/VerificationIsIdentification/Dynamics.swift:21 | still builds |  |
| ``LawLivesInSigma`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Dynamics.swift:31 | still builds |  |
| ``LawLivesInSigma`` | ``HasDistance`` | Sources/VerificationIsIdentification/Dynamics.swift:31 | still builds |  |
| ``LawLivesInSigma`` | ``HasLaw`` | Sources/VerificationIsIdentification/Dynamics.swift:31 | still builds |  |
| ``LawLivesInSigma`` | ``HasSigma`` | Sources/VerificationIsIdentification/Dynamics.swift:31 | still builds |  |
| ``LawLivesInSigma`` | ``Open`` | Sources/VerificationIsIdentification/Dynamics.swift:31 | still builds |  |
| ``LawLivesInSigma`` | ``Pair`` | Sources/VerificationIsIdentification/Dynamics.swift:31 | still builds |  |
| ``LawLivesInSigma`` | ``Structure`` | Sources/VerificationIsIdentification/Dynamics.swift:31 | still builds |  |
| ``LawLivesInSigma`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Dynamics.swift:31 | still builds |  |
| ``LawIsTarget`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``HasDistance`` | Sources/VerificationIsIdentification/Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``HasLaw`` | Sources/VerificationIsIdentification/Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``HasSigma`` | Sources/VerificationIsIdentification/Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``LawLivesInSigma`` | Sources/VerificationIsIdentification/Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``Open`` | Sources/VerificationIsIdentification/Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``Pair`` | Sources/VerificationIsIdentification/Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``Structure`` | Sources/VerificationIsIdentification/Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Dynamics.swift:41 | still builds |  |
| ``AmbiguityIsExperiment`` | ``AnchorGraph`` | Sources/VerificationIsIdentification/Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``Decidable`` | Sources/VerificationIsIdentification/Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``HasDistance`` | Sources/VerificationIsIdentification/Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``HasLaw`` | Sources/VerificationIsIdentification/Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``HasSigma`` | Sources/VerificationIsIdentification/Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``HolesCarryAddresses`` | Sources/VerificationIsIdentification/Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``LawIsTarget`` | Sources/VerificationIsIdentification/Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``LawLivesInSigma`` | Sources/VerificationIsIdentification/Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``Open`` | Sources/VerificationIsIdentification/Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``Pair`` | Sources/VerificationIsIdentification/Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``Structure`` | Sources/VerificationIsIdentification/Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Dynamics.swift:47 | still builds |  |
| ``BehaviorIsStructure`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Dynamics.swift:53 | still builds |  |
| ``BehaviorIsStructure`` | ``HasDistance`` | Sources/VerificationIsIdentification/Dynamics.swift:53 | still builds |  |
| ``BehaviorIsStructure`` | ``HasSigma`` | Sources/VerificationIsIdentification/Dynamics.swift:53 | still builds |  |
| ``BehaviorIsStructure`` | ``HasTime`` | Sources/VerificationIsIdentification/Dynamics.swift:53 | still builds |  |
| ``BehaviorIsStructure`` | ``Open`` | Sources/VerificationIsIdentification/Dynamics.swift:53 | still builds |  |
| ``BehaviorIsStructure`` | ``Pair`` | Sources/VerificationIsIdentification/Dynamics.swift:53 | still builds |  |
| ``BehaviorIsStructure`` | ``Structure`` | Sources/VerificationIsIdentification/Dynamics.swift:53 | still builds |  |
| ``BehaviorIsStructure`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Dynamics.swift:53 | still builds |  |
| ``PlanningIsNavigation`` | ``AnchorGraph`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``BallSaturation`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``CompressionCriterion`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``Decidable`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``HasCache`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``HasCost`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``HasDistance`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``HasLaw`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``HasSigma`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``HasTime`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``Ignites`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``LawIsTarget`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``LawLivesInSigma`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``Matter`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``NavigationInevitable`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``OneBoundaryThreeFaces`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``Open`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``Pair`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``Resistant`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``Structure`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``Tower`` | Sources/VerificationIsIdentification/Dynamics.swift:65 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``AnchorGraph`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``AxesCoOriented`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``BallSaturation`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``CompressionCriterion`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``Decidable`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``HasCache`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``HasCost`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``HasDistance`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``HasLaw`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``HasSigma`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``HasTime`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``Ignites`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``LawIsTarget`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``LawLivesInSigma`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``Matter`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``NavigationInevitable`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``Null`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``OneBoundaryThreeFaces`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``Open`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``OrderIsOnlyFreedom`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``Pair`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``PlanningIsNavigation`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``Resistant`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``SkillsAreBalls`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``StrategyLivesInSigma`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``Structure`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``Tower`` | Sources/VerificationIsIdentification/Dynamics.swift:72 | still builds |  |
| ``InteractiveDecomposition`` | ``AmbiguityIsExperiment`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``AnchorGraph`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``AxesCoOriented`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``BallSaturation`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``CompressionCriterion`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``Decidable`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``HasCache`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``HasCost`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``HasDistance`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``HasLaw`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``HasSigma`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``HasTime`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``HolesCarryAddresses`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``Ignites`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``LawIsTarget`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``LawLivesInSigma`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``Matter`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``MotorSkillsAreStrategies`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``NavigationInevitable`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``Null`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``OneBoundaryThreeFaces`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``Open`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``OrderIsOnlyFreedom`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``Pair`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``PlanningIsNavigation`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``Resistant`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``SkillsAreBalls`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``StrategyLivesInSigma`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``Structure`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``Tower`` | Sources/VerificationIsIdentification/Dynamics.swift:79 | still builds |  |
| ``LawfulDrift`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``Decidable`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``HasCache`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``HasCost`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``HasDistance`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``HasLaw`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``HasSigma`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``HasTime`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``Ignites`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``LawIsTarget`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``LawLivesInSigma`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``Matter`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``Open`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``Pair`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``Resistant`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``Structure`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``Tower`` | Sources/VerificationIsIdentification/Dynamics.swift:86 | still builds |  |
| ``HasGauge`` | ``HasSigma`` | Sources/VerificationIsIdentification/Gauge.swift:30 | still builds |  |
| ``ContentIsGaugeInvariant`` | ``HasEncoding`` | Sources/VerificationIsIdentification/Gauge.swift:40 | still builds |  |
| ``ContentIsGaugeInvariant`` | ``HasGauge`` | Sources/VerificationIsIdentification/Gauge.swift:40 | still builds |  |
| ``ContentIsGaugeInvariant`` | ``HasSigma`` | Sources/VerificationIsIdentification/Gauge.swift:40 | still builds |  |
| ``ContentIsGaugeInvariant`` | ``Measurable`` | Sources/VerificationIsIdentification/Gauge.swift:40 | still builds |  |
| ``ContentIsGaugeInvariant`` | ``Open`` | Sources/VerificationIsIdentification/Gauge.swift:40 | still builds |  |
| ``ContentIsGaugeInvariant`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Gauge.swift:40 | still builds |  |
| ``ContentIsGaugeInvariant`` | ``Pair`` | Sources/VerificationIsIdentification/Gauge.swift:40 | still builds |  |
| ``ContentIsGaugeInvariant`` | ``RevealsNotCreates`` | Sources/VerificationIsIdentification/Gauge.swift:40 | still builds |  |
| ``ContentIsGaugeInvariant`` | ``Structure`` | Sources/VerificationIsIdentification/Gauge.swift:40 | still builds |  |
| ``CostReadsGauge`` | ``HasDistance`` | Sources/VerificationIsIdentification/Gauge.swift:48 | still builds |  |
| ``CostReadsGauge`` | ``HasGauge`` | Sources/VerificationIsIdentification/Gauge.swift:48 | still builds |  |
| ``CostReadsGauge`` | ``HasSigma`` | Sources/VerificationIsIdentification/Gauge.swift:48 | still builds |  |
| ``GaugeFixing`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``CandidatesOnlyLeave`` | Sources/VerificationIsIdentification/Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``CostReadsGauge`` | Sources/VerificationIsIdentification/Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``HasCache`` | Sources/VerificationIsIdentification/Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``HasDistance`` | Sources/VerificationIsIdentification/Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``HasGauge`` | Sources/VerificationIsIdentification/Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``HasSigma`` | Sources/VerificationIsIdentification/Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``MembershipDecidable`` | Sources/VerificationIsIdentification/Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``Open`` | Sources/VerificationIsIdentification/Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``Pair`` | Sources/VerificationIsIdentification/Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``ResultsIrreversible`` | Sources/VerificationIsIdentification/Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``Structure`` | Sources/VerificationIsIdentification/Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``SystemCrystallizes`` | Sources/VerificationIsIdentification/Gauge.swift:59 | still builds |  |
| ``LinearArbiter`` | ``CostIsPathLength`` | Sources/VerificationIsIdentification/Gauge.swift:67 | still builds |  |
| ``LinearArbiter`` | ``HasDistance`` | Sources/VerificationIsIdentification/Gauge.swift:67 | still builds |  |
| ``LinearArbiter`` | ``HasPath`` | Sources/VerificationIsIdentification/Gauge.swift:67 | still builds |  |
| ``LinearArbiter`` | ``HasSigma`` | Sources/VerificationIsIdentification/Gauge.swift:67 | still builds |  |
| ``GaugeCollapse`` | ``ContentIsGaugeInvariant`` | Sources/VerificationIsIdentification/Gauge.swift:76 | still builds |  |
| ``GaugeCollapse`` | ``CostIsPathLength`` | Sources/VerificationIsIdentification/Gauge.swift:76 | still builds |  |
| ``GaugeCollapse`` | ``HasDistance`` | Sources/VerificationIsIdentification/Gauge.swift:76 | still builds |  |
| ``GaugeCollapse`` | ``HasEncoding`` | Sources/VerificationIsIdentification/Gauge.swift:76 | still builds |  |
| ``GaugeCollapse`` | ``HasGauge`` | Sources/VerificationIsIdentification/Gauge.swift:76 | still builds |  |
| ``GaugeCollapse`` | ``HasPath`` | Sources/VerificationIsIdentification/Gauge.swift:76 | still builds |  |
| ``GaugeCollapse`` | ``HasSigma`` | Sources/VerificationIsIdentification/Gauge.swift:76 | still builds |  |
| ``GaugeCollapse`` | ``LinearArbiter`` | Sources/VerificationIsIdentification/Gauge.swift:76 | still builds |  |
| ``GaugeCollapse`` | ``Measurable`` | Sources/VerificationIsIdentification/Gauge.swift:76 | still builds |  |
| ``GaugeCollapse`` | ``Open`` | Sources/VerificationIsIdentification/Gauge.swift:76 | still builds |  |
| ``GaugeCollapse`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Gauge.swift:76 | still builds |  |
| ``GaugeCollapse`` | ``Pair`` | Sources/VerificationIsIdentification/Gauge.swift:76 | still builds |  |
| ``GaugeCollapse`` | ``RevealsNotCreates`` | Sources/VerificationIsIdentification/Gauge.swift:76 | still builds |  |
| ``GaugeCollapse`` | ``Structure`` | Sources/VerificationIsIdentification/Gauge.swift:76 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``AxesCoOriented`` | Sources/VerificationIsIdentification/Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``HasCache`` | Sources/VerificationIsIdentification/Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``HasSigma`` | Sources/VerificationIsIdentification/Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``Null`` | Sources/VerificationIsIdentification/Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``Open`` | Sources/VerificationIsIdentification/Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``OrderIsOnlyFreedom`` | Sources/VerificationIsIdentification/Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``Pair`` | Sources/VerificationIsIdentification/Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``Structure`` | Sources/VerificationIsIdentification/Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Generation.swift:28 | still builds |  |
| ``OrthogonalOrgans`` | ``AlignmentCoefficient`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``AnchorGraph`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``AxesCoOriented`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``BallSaturation`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``CompressionCriterion`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``Decidable`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``DiscriminatorAndGenerator`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``GateIsZeroOfLoss`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``HasAlpha`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``HasCache`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``HasCost`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``HasDistance`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``HasSigma`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``HasTime`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``Ignites`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``Matter`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``Null`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``OneBoundaryThreeFaces`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``Open`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``OrderIsOnlyFreedom`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``Pair`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``Resistant`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``SearchableIffClusteredAndAligned`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``Structure`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``Tower`` | Sources/VerificationIsIdentification/Generation.swift:36 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``AlignmentCoefficient`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``AxesCoOriented`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``DiscriminatorAndGenerator`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``GateIsZeroOfLoss`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``HasAlpha`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``HasCache`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``HasDistance`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``HasEfficiency`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``HasSigma`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``IntelligenceRises`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``Null`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``Open`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``OrderIsOnlyFreedom`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``Pair`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``Structure`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Generation.swift:50 | still builds |  |
| ``OrgansAreOneCompare`` | ``AxesCoOriented`` | Sources/VerificationIsIdentification/Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``Decidable`` | Sources/VerificationIsIdentification/Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``DiscriminatorAndGenerator`` | Sources/VerificationIsIdentification/Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``HasCache`` | Sources/VerificationIsIdentification/Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``HasSigma`` | Sources/VerificationIsIdentification/Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``Null`` | Sources/VerificationIsIdentification/Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``Open`` | Sources/VerificationIsIdentification/Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``OrderIsOnlyFreedom`` | Sources/VerificationIsIdentification/Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``Pair`` | Sources/VerificationIsIdentification/Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``Structure`` | Sources/VerificationIsIdentification/Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Generation.swift:57 | still builds |  |
| ``DistanceOnStructures`` | ``HasDistance`` | Sources/VerificationIsIdentification/Gradient.swift:26 | inherited, no line to cut |  |
| ``DistanceOnStructures`` | ``HasSigma`` | Sources/VerificationIsIdentification/Gradient.swift:26 | inherited, no line to cut |  |
| ``DistanceOnStructures`` | ``Open`` | Sources/VerificationIsIdentification/Gradient.swift:26 | inherited, no line to cut |  |
| ``DistanceOnStructures`` | ``Pair`` | Sources/VerificationIsIdentification/Gradient.swift:26 | inherited, no line to cut |  |
| ``DistanceOnStructures`` | ``Structure`` | Sources/VerificationIsIdentification/Gradient.swift:26 | inherited, no line to cut |  |
| ``DistanceOnStructures`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Gradient.swift:26 | inherited, no line to cut |  |
| ``DistanceIsCost`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Gradient.swift:33 | inherited, no line to cut |  |
| ``DistanceIsCost`` | ``HasCost`` | Sources/VerificationIsIdentification/Gradient.swift:33 | inherited, no line to cut |  |
| ``DistanceIsCost`` | ``HasDistance`` | Sources/VerificationIsIdentification/Gradient.swift:33 | inherited, no line to cut |  |
| ``DistanceIsCost`` | ``HasSigma`` | Sources/VerificationIsIdentification/Gradient.swift:33 | inherited, no line to cut |  |
| ``DistanceIsCost`` | ``Open`` | Sources/VerificationIsIdentification/Gradient.swift:33 | inherited, no line to cut |  |
| ``DistanceIsCost`` | ``Pair`` | Sources/VerificationIsIdentification/Gradient.swift:33 | inherited, no line to cut |  |
| ``DistanceIsCost`` | ``Structure`` | Sources/VerificationIsIdentification/Gradient.swift:33 | inherited, no line to cut |  |
| ``DistanceIsCost`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Gradient.swift:33 | inherited, no line to cut |  |
| ``NullIsOrigin`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Gradient.swift:40 | still builds |  |
| ``NullIsOrigin`` | ``HasDistance`` | Sources/VerificationIsIdentification/Gradient.swift:40 | still builds |  |
| ``NullIsOrigin`` | ``HasSigma`` | Sources/VerificationIsIdentification/Gradient.swift:40 | still builds |  |
| ``NullIsOrigin`` | ``Null`` | Sources/VerificationIsIdentification/Gradient.swift:40 | still builds |  |
| ``NullIsOrigin`` | ``Open`` | Sources/VerificationIsIdentification/Gradient.swift:40 | still builds |  |
| ``NullIsOrigin`` | ``Pair`` | Sources/VerificationIsIdentification/Gradient.swift:40 | still builds |  |
| ``NullIsOrigin`` | ``Structure`` | Sources/VerificationIsIdentification/Gradient.swift:40 | still builds |  |
| ``NullIsOrigin`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Gradient.swift:40 | still builds |  |
| ``GradientInComparison`` | ``Decidable`` | Sources/VerificationIsIdentification/Gradient.swift:47 | still builds |  |
| ``GradientInComparison`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Gradient.swift:47 | still builds |  |
| ``GradientInComparison`` | ``HasDistance`` | Sources/VerificationIsIdentification/Gradient.swift:47 | still builds |  |
| ``GradientInComparison`` | ``HasSigma`` | Sources/VerificationIsIdentification/Gradient.swift:47 | still builds |  |
| ``GradientInComparison`` | ``Open`` | Sources/VerificationIsIdentification/Gradient.swift:47 | still builds |  |
| ``GradientInComparison`` | ``Pair`` | Sources/VerificationIsIdentification/Gradient.swift:47 | still builds |  |
| ``GradientInComparison`` | ``Structure`` | Sources/VerificationIsIdentification/Gradient.swift:47 | still builds |  |
| ``GradientInComparison`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Gradient.swift:47 | still builds |  |
| ``OrderByDistance`` | ``AxesCoOriented`` | Sources/VerificationIsIdentification/Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``HasCache`` | Sources/VerificationIsIdentification/Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``HasDistance`` | Sources/VerificationIsIdentification/Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``HasSigma`` | Sources/VerificationIsIdentification/Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``Null`` | Sources/VerificationIsIdentification/Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``Open`` | Sources/VerificationIsIdentification/Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``OrderIsOnlyFreedom`` | Sources/VerificationIsIdentification/Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``Pair`` | Sources/VerificationIsIdentification/Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``Structure`` | Sources/VerificationIsIdentification/Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Gradient.swift:53 | still builds |  |
| ``GateIsZeroOfLoss`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Gradient.swift:59 | still builds |  |
| ``GateIsZeroOfLoss`` | ``HasDistance`` | Sources/VerificationIsIdentification/Gradient.swift:59 | still builds |  |
| ``GateIsZeroOfLoss`` | ``HasSigma`` | Sources/VerificationIsIdentification/Gradient.swift:59 | still builds |  |
| ``GateIsZeroOfLoss`` | ``Open`` | Sources/VerificationIsIdentification/Gradient.swift:59 | still builds |  |
| ``GateIsZeroOfLoss`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Gradient.swift:59 | still builds |  |
| ``GateIsZeroOfLoss`` | ``Pair`` | Sources/VerificationIsIdentification/Gradient.swift:59 | still builds |  |
| ``GateIsZeroOfLoss`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Gradient.swift:59 | still builds |  |
| ``GateIsZeroOfLoss`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Gradient.swift:59 | still builds |  |
| ``GateIsZeroOfLoss`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Gradient.swift:59 | still builds |  |
| ``GateIsZeroOfLoss`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Gradient.swift:59 | still builds |  |
| ``GateIsZeroOfLoss`` | ``Structure`` | Sources/VerificationIsIdentification/Gradient.swift:59 | still builds |  |
| ``GateIsZeroOfLoss`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Gradient.swift:59 | still builds |  |
| ``BallSaturation`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Gradient.swift:66 | still builds |  |
| ``BallSaturation`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Gradient.swift:66 | still builds |  |
| ``BallSaturation`` | ``HasCache`` | Sources/VerificationIsIdentification/Gradient.swift:66 | still builds |  |
| ``BallSaturation`` | ``HasDistance`` | Sources/VerificationIsIdentification/Gradient.swift:66 | still builds |  |
| ``BallSaturation`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Gradient.swift:66 | still builds |  |
| ``BallSaturation`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Gradient.swift:66 | still builds |  |
| ``BallSaturation`` | ``HasSigma`` | Sources/VerificationIsIdentification/Gradient.swift:66 | still builds |  |
| ``BallSaturation`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Gradient.swift:66 | still builds |  |
| ``BallSaturation`` | ``Open`` | Sources/VerificationIsIdentification/Gradient.swift:66 | still builds |  |
| ``BallSaturation`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Gradient.swift:66 | still builds |  |
| ``BallSaturation`` | ``Pair`` | Sources/VerificationIsIdentification/Gradient.swift:66 | still builds |  |
| ``BallSaturation`` | ``Structure`` | Sources/VerificationIsIdentification/Gradient.swift:66 | still builds |  |
| ``BallSaturation`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Gradient.swift:66 | still builds |  |
| ``CompressionCriterion`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``Decidable`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``HasCache`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``HasCost`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``HasDistance`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``HasSigma`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``HasTime`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``Ignites`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``Matter`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``Open`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``Pair`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``Resistant`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``Structure`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``Tower`` | Sources/VerificationIsIdentification/Gradient.swift:73 | still builds |  |
| ``ResistanceHasMagnitude`` | ``Decidable`` | Sources/VerificationIsIdentification/Gradient.swift:80 | still builds |  |
| ``ResistanceHasMagnitude`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Gradient.swift:80 | still builds |  |
| ``ResistanceHasMagnitude`` | ``HasDistance`` | Sources/VerificationIsIdentification/Gradient.swift:80 | still builds |  |
| ``ResistanceHasMagnitude`` | ``HasSigma`` | Sources/VerificationIsIdentification/Gradient.swift:80 | still builds |  |
| ``ResistanceHasMagnitude`` | ``Open`` | Sources/VerificationIsIdentification/Gradient.swift:80 | still builds |  |
| ``ResistanceHasMagnitude`` | ``Pair`` | Sources/VerificationIsIdentification/Gradient.swift:80 | still builds |  |
| ``ResistanceHasMagnitude`` | ``Resistant`` | Sources/VerificationIsIdentification/Gradient.swift:80 | still builds |  |
| ``ResistanceHasMagnitude`` | ``Structure`` | Sources/VerificationIsIdentification/Gradient.swift:80 | still builds |  |
| ``ResistanceHasMagnitude`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Gradient.swift:80 | still builds |  |
| ``StructuresFinite`` | ``HasSigma`` | Sources/VerificationIsIdentification/Identification.swift:27 | still builds |  |
| ``StructuresFinite`` | ``Open`` | Sources/VerificationIsIdentification/Identification.swift:27 | still builds |  |
| ``StructuresFinite`` | ``Pair`` | Sources/VerificationIsIdentification/Identification.swift:27 | still builds |  |
| ``StructuresFinite`` | ``Structure`` | Sources/VerificationIsIdentification/Identification.swift:27 | still builds |  |
| ``OperationsClosed`` | ``Open`` | Sources/VerificationIsIdentification/Identification.swift:33 | inherited, no line to cut |  |
| ``OperationsClosed`` | ``Pair`` | Sources/VerificationIsIdentification/Identification.swift:33 | inherited, no line to cut |  |
| ``OperationsClosed`` | ``Structure`` | Sources/VerificationIsIdentification/Identification.swift:33 | inherited, no line to cut |  |
| ``EqualityDecidable`` | ``HasSigma`` | Sources/VerificationIsIdentification/Identification.swift:45 | still builds |  |
| ``EqualityDecidable`` | ``Open`` | Sources/VerificationIsIdentification/Identification.swift:45 | still builds |  |
| ``EqualityDecidable`` | ``Pair`` | Sources/VerificationIsIdentification/Identification.swift:45 | still builds |  |
| ``EqualityDecidable`` | ``Structure`` | Sources/VerificationIsIdentification/Identification.swift:45 | still builds |  |
| ``EqualityDecidable`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Identification.swift:45 | still builds |  |
| ``CachePermanent`` | ``HasCache`` | Sources/VerificationIsIdentification/Identification.swift:56 | inherited, no line to cut |  |
| ``CachePermanent`` | ``HasSigma`` | Sources/VerificationIsIdentification/Identification.swift:56 | inherited, no line to cut |  |
| ``CachePermanent`` | ``Open`` | Sources/VerificationIsIdentification/Identification.swift:56 | inherited, no line to cut |  |
| ``CachePermanent`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Identification.swift:56 | inherited, no line to cut |  |
| ``CachePermanent`` | ``Pair`` | Sources/VerificationIsIdentification/Identification.swift:56 | inherited, no line to cut |  |
| ``CachePermanent`` | ``Structure`` | Sources/VerificationIsIdentification/Identification.swift:56 | inherited, no line to cut |  |
| ``CachePermanent`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Identification.swift:56 | inherited, no line to cut |  |
| ``StepsTerminate`` | ``HasSigma`` | Sources/VerificationIsIdentification/Identification.swift:66 | still builds |  |
| ``StepsTerminate`` | ``Open`` | Sources/VerificationIsIdentification/Identification.swift:66 | still builds |  |
| ``StepsTerminate`` | ``Pair`` | Sources/VerificationIsIdentification/Identification.swift:66 | still builds |  |
| ``StepsTerminate`` | ``Structure`` | Sources/VerificationIsIdentification/Identification.swift:66 | still builds |  |
| ``StepsTerminate`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Identification.swift:66 | still builds |  |
| ``PipelineTotal`` | ``HasSigma`` | Sources/VerificationIsIdentification/Identification.swift:73 | still builds |  |
| ``PipelineTotal`` | ``Open`` | Sources/VerificationIsIdentification/Identification.swift:73 | still builds |  |
| ``PipelineTotal`` | ``Pair`` | Sources/VerificationIsIdentification/Identification.swift:73 | still builds |  |
| ``PipelineTotal`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Identification.swift:73 | still builds |  |
| ``PipelineTotal`` | ``Structure`` | Sources/VerificationIsIdentification/Identification.swift:73 | still builds |  |
| ``PipelineTotal`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Identification.swift:73 | still builds |  |
| ``ResultDeterministic`` | ``Open`` | Sources/VerificationIsIdentification/Identification.swift:81 | still builds |  |
| ``ResultDeterministic`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Identification.swift:81 | still builds |  |
| ``ResultDeterministic`` | ``Pair`` | Sources/VerificationIsIdentification/Identification.swift:81 | still builds |  |
| ``ResultDeterministic`` | ``Structure`` | Sources/VerificationIsIdentification/Identification.swift:81 | still builds |  |
| ``CacheOnlyGrows`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Identification.swift:91 | still builds |  |
| ``CacheOnlyGrows`` | ``HasCache`` | Sources/VerificationIsIdentification/Identification.swift:91 | still builds |  |
| ``CacheOnlyGrows`` | ``HasSigma`` | Sources/VerificationIsIdentification/Identification.swift:91 | still builds |  |
| ``CacheOnlyGrows`` | ``Open`` | Sources/VerificationIsIdentification/Identification.swift:91 | still builds |  |
| ``CacheOnlyGrows`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Identification.swift:91 | still builds |  |
| ``CacheOnlyGrows`` | ``Pair`` | Sources/VerificationIsIdentification/Identification.swift:91 | still builds |  |
| ``CacheOnlyGrows`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Identification.swift:91 | still builds |  |
| ``CacheOnlyGrows`` | ``Structure`` | Sources/VerificationIsIdentification/Identification.swift:91 | still builds |  |
| ``CacheOnlyGrows`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Identification.swift:91 | still builds |  |
| ``DiagnosticsAccumulate`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Identification.swift:96 | still builds |  |
| ``DiagnosticsAccumulate`` | ``HasCache`` | Sources/VerificationIsIdentification/Identification.swift:96 | still builds |  |
| ``DiagnosticsAccumulate`` | ``HasSigma`` | Sources/VerificationIsIdentification/Identification.swift:96 | still builds |  |
| ``DiagnosticsAccumulate`` | ``Open`` | Sources/VerificationIsIdentification/Identification.swift:96 | still builds |  |
| ``DiagnosticsAccumulate`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Identification.swift:96 | still builds |  |
| ``DiagnosticsAccumulate`` | ``Pair`` | Sources/VerificationIsIdentification/Identification.swift:96 | still builds |  |
| ``DiagnosticsAccumulate`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Identification.swift:96 | still builds |  |
| ``DiagnosticsAccumulate`` | ``Structure`` | Sources/VerificationIsIdentification/Identification.swift:96 | still builds |  |
| ``DiagnosticsAccumulate`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Identification.swift:96 | still builds |  |
| ``CandidatesOnlyLeave`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Identification.swift:103 | inherited, no line to cut |  |
| ``CandidatesOnlyLeave`` | ``HasCache`` | Sources/VerificationIsIdentification/Identification.swift:103 | inherited, no line to cut |  |
| ``CandidatesOnlyLeave`` | ``HasSigma`` | Sources/VerificationIsIdentification/Identification.swift:103 | inherited, no line to cut |  |
| ``CandidatesOnlyLeave`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Identification.swift:103 | inherited, no line to cut |  |
| ``CandidatesOnlyLeave`` | ``Open`` | Sources/VerificationIsIdentification/Identification.swift:103 | inherited, no line to cut |  |
| ``CandidatesOnlyLeave`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Identification.swift:103 | inherited, no line to cut |  |
| ``CandidatesOnlyLeave`` | ``Pair`` | Sources/VerificationIsIdentification/Identification.swift:103 | inherited, no line to cut |  |
| ``CandidatesOnlyLeave`` | ``Structure`` | Sources/VerificationIsIdentification/Identification.swift:103 | inherited, no line to cut |  |
| ``CandidatesOnlyLeave`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Identification.swift:103 | inherited, no line to cut |  |
| ``NoSelfReference`` | ``Open`` | Sources/VerificationIsIdentification/Identification.swift:117 | still builds |  |
| ``NoSelfReference`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Identification.swift:117 | still builds |  |
| ``NoSelfReference`` | ``Pair`` | Sources/VerificationIsIdentification/Identification.swift:117 | still builds |  |
| ``NoSelfReference`` | ``Structure`` | Sources/VerificationIsIdentification/Identification.swift:117 | still builds |  |
| ``ScopeBoundedByEncoding`` | ``Open`` | Sources/VerificationIsIdentification/Identification.swift:124 | still builds |  |
| ``ScopeBoundedByEncoding`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Identification.swift:124 | still builds |  |
| ``ScopeBoundedByEncoding`` | ``Pair`` | Sources/VerificationIsIdentification/Identification.swift:124 | still builds |  |
| ``ScopeBoundedByEncoding`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Identification.swift:124 | still builds |  |
| ``ScopeBoundedByEncoding`` | ``Structure`` | Sources/VerificationIsIdentification/Identification.swift:124 | still builds |  |
| ``ExactlyOneSurvives`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Identification.swift:136 | inherited, no line to cut |  |
| ``ExactlyOneSurvives`` | ``HasSigma`` | Sources/VerificationIsIdentification/Identification.swift:136 | inherited, no line to cut |  |
| ``ExactlyOneSurvives`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Identification.swift:136 | inherited, no line to cut |  |
| ``ExactlyOneSurvives`` | ``Open`` | Sources/VerificationIsIdentification/Identification.swift:136 | inherited, no line to cut |  |
| ``ExactlyOneSurvives`` | ``Pair`` | Sources/VerificationIsIdentification/Identification.swift:136 | inherited, no line to cut |  |
| ``ExactlyOneSurvives`` | ``Structure`` | Sources/VerificationIsIdentification/Identification.swift:136 | inherited, no line to cut |  |
| ``ExactlyOneSurvives`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Identification.swift:136 | inherited, no line to cut |  |
| ``PassImpliesMembership`` | ``HasSigma`` | Sources/VerificationIsIdentification/Identification.swift:146 | still builds |  |
| ``PassImpliesMembership`` | ``Open`` | Sources/VerificationIsIdentification/Identification.swift:146 | still builds |  |
| ``PassImpliesMembership`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Identification.swift:146 | still builds |  |
| ``PassImpliesMembership`` | ``Pair`` | Sources/VerificationIsIdentification/Identification.swift:146 | still builds |  |
| ``PassImpliesMembership`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Identification.swift:146 | still builds |  |
| ``PassImpliesMembership`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Identification.swift:146 | still builds |  |
| ``PassImpliesMembership`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Identification.swift:146 | still builds |  |
| ``PassImpliesMembership`` | ``Structure`` | Sources/VerificationIsIdentification/Identification.swift:146 | still builds |  |
| ``PassImpliesMembership`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Identification.swift:146 | still builds |  |
| ``PassIsIdentification`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Identification.swift:156 | inherited, no line to cut |  |
| ``PassIsIdentification`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Identification.swift:156 | inherited, no line to cut |  |
| ``PassIsIdentification`` | ``HasSigma`` | Sources/VerificationIsIdentification/Identification.swift:156 | inherited, no line to cut |  |
| ``PassIsIdentification`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Identification.swift:156 | inherited, no line to cut |  |
| ``PassIsIdentification`` | ``Open`` | Sources/VerificationIsIdentification/Identification.swift:156 | inherited, no line to cut |  |
| ``PassIsIdentification`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Identification.swift:156 | inherited, no line to cut |  |
| ``PassIsIdentification`` | ``Pair`` | Sources/VerificationIsIdentification/Identification.swift:156 | inherited, no line to cut |  |
| ``PassIsIdentification`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Identification.swift:156 | inherited, no line to cut |  |
| ``PassIsIdentification`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Identification.swift:156 | inherited, no line to cut |  |
| ``PassIsIdentification`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Identification.swift:156 | inherited, no line to cut |  |
| ``PassIsIdentification`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Identification.swift:156 | inherited, no line to cut |  |
| ``PassIsIdentification`` | ``Structure`` | Sources/VerificationIsIdentification/Identification.swift:156 | inherited, no line to cut |  |
| ``PassIsIdentification`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Identification.swift:156 | inherited, no line to cut |  |
| ``ComparisonsAreBounded`` | ``HasSigma`` | Sources/VerificationIsIdentification/Identification.swift:163 | still builds |  |
| ``ComparisonsAreBounded`` | ``Open`` | Sources/VerificationIsIdentification/Identification.swift:163 | still builds |  |
| ``ComparisonsAreBounded`` | ``Pair`` | Sources/VerificationIsIdentification/Identification.swift:163 | still builds |  |
| ``ComparisonsAreBounded`` | ``Structure`` | Sources/VerificationIsIdentification/Identification.swift:163 | still builds |  |
| ``ComparisonsAreBounded`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Identification.swift:163 | still builds |  |
| ``PreconditionsGuaranteePass`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Identification.swift:171 | still builds |  |
| ``PreconditionsGuaranteePass`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Identification.swift:171 | still builds |  |
| ``PreconditionsGuaranteePass`` | ``HasSigma`` | Sources/VerificationIsIdentification/Identification.swift:171 | still builds |  |
| ``PreconditionsGuaranteePass`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Identification.swift:171 | still builds |  |
| ``PreconditionsGuaranteePass`` | ``Open`` | Sources/VerificationIsIdentification/Identification.swift:171 | still builds |  |
| ``PreconditionsGuaranteePass`` | ``Pair`` | Sources/VerificationIsIdentification/Identification.swift:171 | still builds |  |
| ``PreconditionsGuaranteePass`` | ``Structure`` | Sources/VerificationIsIdentification/Identification.swift:171 | still builds |  |
| ``PreconditionsGuaranteePass`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Identification.swift:171 | still builds |  |
| ``AxesCoOriented`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Identification.swift:183 | still builds |  |
| ``AxesCoOriented`` | ``HasCache`` | Sources/VerificationIsIdentification/Identification.swift:183 | still builds |  |
| ``AxesCoOriented`` | ``HasSigma`` | Sources/VerificationIsIdentification/Identification.swift:183 | still builds |  |
| ``AxesCoOriented`` | ``Open`` | Sources/VerificationIsIdentification/Identification.swift:183 | still builds |  |
| ``AxesCoOriented`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Identification.swift:183 | still builds |  |
| ``AxesCoOriented`` | ``Pair`` | Sources/VerificationIsIdentification/Identification.swift:183 | still builds |  |
| ``AxesCoOriented`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Identification.swift:183 | still builds |  |
| ``AxesCoOriented`` | ``Structure`` | Sources/VerificationIsIdentification/Identification.swift:183 | still builds |  |
| ``AxesCoOriented`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Identification.swift:183 | still builds |  |
| ``SaturationIncorruptible`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Identification.swift:188 | still builds |  |
| ``SaturationIncorruptible`` | ``HasCache`` | Sources/VerificationIsIdentification/Identification.swift:188 | still builds |  |
| ``SaturationIncorruptible`` | ``HasSigma`` | Sources/VerificationIsIdentification/Identification.swift:188 | still builds |  |
| ``SaturationIncorruptible`` | ``Open`` | Sources/VerificationIsIdentification/Identification.swift:188 | still builds |  |
| ``SaturationIncorruptible`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Identification.swift:188 | still builds |  |
| ``SaturationIncorruptible`` | ``Pair`` | Sources/VerificationIsIdentification/Identification.swift:188 | still builds |  |
| ``SaturationIncorruptible`` | ``Structure`` | Sources/VerificationIsIdentification/Identification.swift:188 | still builds |  |
| ``SaturationIncorruptible`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Identification.swift:188 | still builds |  |
| ``Universality`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Identification.swift:197 | still builds |  |
| ``Universality`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Identification.swift:197 | still builds |  |
| ``Universality`` | ``HasEncoding`` | Sources/VerificationIsIdentification/Identification.swift:197 | still builds |  |
| ``Universality`` | ``HasSigma`` | Sources/VerificationIsIdentification/Identification.swift:197 | still builds |  |
| ``Universality`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Identification.swift:197 | still builds |  |
| ``Universality`` | ``Open`` | Sources/VerificationIsIdentification/Identification.swift:197 | still builds |  |
| ``Universality`` | ``Pair`` | Sources/VerificationIsIdentification/Identification.swift:197 | still builds |  |
| ``Universality`` | ``Structure`` | Sources/VerificationIsIdentification/Identification.swift:197 | still builds |  |
| ``Universality`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Identification.swift:197 | still builds |  |
| ``RevealsNotCreates`` | ``Measurable`` | Sources/VerificationIsIdentification/Identification.swift:204 | still builds |  |
| ``RevealsNotCreates`` | ``Open`` | Sources/VerificationIsIdentification/Identification.swift:204 | still builds |  |
| ``RevealsNotCreates`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Identification.swift:204 | still builds |  |
| ``RevealsNotCreates`` | ``Pair`` | Sources/VerificationIsIdentification/Identification.swift:204 | still builds |  |
| ``RevealsNotCreates`` | ``Structure`` | Sources/VerificationIsIdentification/Identification.swift:204 | still builds |  |
| ``OrderIsOnlyFreedom`` | ``AxesCoOriented`` | Sources/VerificationIsIdentification/Identification.swift:215 | still builds |  |
| ``OrderIsOnlyFreedom`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Identification.swift:215 | still builds |  |
| ``OrderIsOnlyFreedom`` | ``HasCache`` | Sources/VerificationIsIdentification/Identification.swift:215 | still builds |  |
| ``OrderIsOnlyFreedom`` | ``HasSigma`` | Sources/VerificationIsIdentification/Identification.swift:215 | still builds |  |
| ``OrderIsOnlyFreedom`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Identification.swift:215 | still builds |  |
| ``OrderIsOnlyFreedom`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Identification.swift:215 | still builds |  |
| ``OrderIsOnlyFreedom`` | ``Null`` | Sources/VerificationIsIdentification/Identification.swift:215 | still builds |  |
| ``OrderIsOnlyFreedom`` | ``Open`` | Sources/VerificationIsIdentification/Identification.swift:215 | still builds |  |
| ``OrderIsOnlyFreedom`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Identification.swift:215 | still builds |  |
| ``OrderIsOnlyFreedom`` | ``Pair`` | Sources/VerificationIsIdentification/Identification.swift:215 | still builds |  |
| ``OrderIsOnlyFreedom`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Identification.swift:215 | still builds |  |
| ``OrderIsOnlyFreedom`` | ``Structure`` | Sources/VerificationIsIdentification/Identification.swift:215 | still builds |  |
| ``OrderIsOnlyFreedom`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Identification.swift:215 | still builds |  |
| ``AgentPathCertified`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``HasSigma`` | Sources/VerificationIsIdentification/Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``Null`` | Sources/VerificationIsIdentification/Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``Open`` | Sources/VerificationIsIdentification/Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``Pair`` | Sources/VerificationIsIdentification/Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``Structure`` | Sources/VerificationIsIdentification/Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Intelligence.swift:11 | still builds |  |
| ``KnowledgeAccumulates`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Intelligence.swift:15 | still builds |  |
| ``KnowledgeAccumulates`` | ``HasCache`` | Sources/VerificationIsIdentification/Intelligence.swift:15 | still builds |  |
| ``KnowledgeAccumulates`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Intelligence.swift:15 | fails | Library |
| ``KnowledgeAccumulates`` | ``HasSigma`` | Sources/VerificationIsIdentification/Intelligence.swift:15 | still builds |  |
| ``KnowledgeAccumulates`` | ``Open`` | Sources/VerificationIsIdentification/Intelligence.swift:15 | still builds |  |
| ``KnowledgeAccumulates`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Intelligence.swift:15 | still builds |  |
| ``KnowledgeAccumulates`` | ``Pair`` | Sources/VerificationIsIdentification/Intelligence.swift:15 | still builds |  |
| ``KnowledgeAccumulates`` | ``Structure`` | Sources/VerificationIsIdentification/Intelligence.swift:15 | still builds |  |
| ``KnowledgeAccumulates`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Intelligence.swift:15 | still builds |  |
| ``LibrarySaturates`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Intelligence.swift:23 | inherited, no line to cut |  |
| ``LibrarySaturates`` | ``HasCache`` | Sources/VerificationIsIdentification/Intelligence.swift:23 | inherited, no line to cut |  |
| ``LibrarySaturates`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Intelligence.swift:23 | inherited, no line to cut |  |
| ``LibrarySaturates`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Intelligence.swift:23 | inherited, no line to cut |  |
| ``LibrarySaturates`` | ``HasSigma`` | Sources/VerificationIsIdentification/Intelligence.swift:23 | inherited, no line to cut |  |
| ``LibrarySaturates`` | ``Open`` | Sources/VerificationIsIdentification/Intelligence.swift:23 | inherited, no line to cut |  |
| ``LibrarySaturates`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Intelligence.swift:23 | inherited, no line to cut |  |
| ``LibrarySaturates`` | ``Pair`` | Sources/VerificationIsIdentification/Intelligence.swift:23 | inherited, no line to cut |  |
| ``LibrarySaturates`` | ``Structure`` | Sources/VerificationIsIdentification/Intelligence.swift:23 | inherited, no line to cut |  |
| ``LibrarySaturates`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Intelligence.swift:23 | inherited, no line to cut |  |
| ``BasisIsFinite`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Intelligence.swift:31 | inherited, no line to cut |  |
| ``BasisIsFinite`` | ``HasBasis`` | Sources/VerificationIsIdentification/Intelligence.swift:31 | inherited, no line to cut |  |
| ``BasisIsFinite`` | ``HasCache`` | Sources/VerificationIsIdentification/Intelligence.swift:31 | inherited, no line to cut |  |
| ``BasisIsFinite`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Intelligence.swift:31 | inherited, no line to cut |  |
| ``BasisIsFinite`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Intelligence.swift:31 | inherited, no line to cut |  |
| ``BasisIsFinite`` | ``HasSigma`` | Sources/VerificationIsIdentification/Intelligence.swift:31 | inherited, no line to cut |  |
| ``BasisIsFinite`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Intelligence.swift:31 | inherited, no line to cut |  |
| ``BasisIsFinite`` | ``Open`` | Sources/VerificationIsIdentification/Intelligence.swift:31 | inherited, no line to cut |  |
| ``BasisIsFinite`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Intelligence.swift:31 | inherited, no line to cut |  |
| ``BasisIsFinite`` | ``Pair`` | Sources/VerificationIsIdentification/Intelligence.swift:31 | inherited, no line to cut |  |
| ``BasisIsFinite`` | ``Structure`` | Sources/VerificationIsIdentification/Intelligence.swift:31 | inherited, no line to cut |  |
| ``BasisIsFinite`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Intelligence.swift:31 | inherited, no line to cut |  |
| ``EncodingSelectionSaturates`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Intelligence.swift:38 | inherited, no line to cut |  |
| ``EncodingSelectionSaturates`` | ``HasCache`` | Sources/VerificationIsIdentification/Intelligence.swift:38 | inherited, no line to cut |  |
| ``EncodingSelectionSaturates`` | ``HasEncoding`` | Sources/VerificationIsIdentification/Intelligence.swift:38 | inherited, no line to cut |  |
| ``EncodingSelectionSaturates`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Intelligence.swift:38 | inherited, no line to cut |  |
| ``EncodingSelectionSaturates`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Intelligence.swift:38 | inherited, no line to cut |  |
| ``EncodingSelectionSaturates`` | ``HasSigma`` | Sources/VerificationIsIdentification/Intelligence.swift:38 | inherited, no line to cut |  |
| ``EncodingSelectionSaturates`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Intelligence.swift:38 | inherited, no line to cut |  |
| ``EncodingSelectionSaturates`` | ``Open`` | Sources/VerificationIsIdentification/Intelligence.swift:38 | inherited, no line to cut |  |
| ``EncodingSelectionSaturates`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Intelligence.swift:38 | inherited, no line to cut |  |
| ``EncodingSelectionSaturates`` | ``Pair`` | Sources/VerificationIsIdentification/Intelligence.swift:38 | inherited, no line to cut |  |
| ``EncodingSelectionSaturates`` | ``Structure`` | Sources/VerificationIsIdentification/Intelligence.swift:38 | inherited, no line to cut |  |
| ``EncodingSelectionSaturates`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Intelligence.swift:38 | inherited, no line to cut |  |
| ``ResultsIrreversible`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Intelligence.swift:49 | still builds |  |
| ``ResultsIrreversible`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Intelligence.swift:49 | still builds |  |
| ``ResultsIrreversible`` | ``HasCache`` | Sources/VerificationIsIdentification/Intelligence.swift:49 | still builds |  |
| ``ResultsIrreversible`` | ``HasSigma`` | Sources/VerificationIsIdentification/Intelligence.swift:49 | still builds |  |
| ``ResultsIrreversible`` | ``Open`` | Sources/VerificationIsIdentification/Intelligence.swift:49 | still builds |  |
| ``ResultsIrreversible`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Intelligence.swift:49 | still builds |  |
| ``ResultsIrreversible`` | ``Pair`` | Sources/VerificationIsIdentification/Intelligence.swift:49 | still builds |  |
| ``ResultsIrreversible`` | ``Structure`` | Sources/VerificationIsIdentification/Intelligence.swift:49 | still builds |  |
| ``ResultsIrreversible`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Intelligence.swift:49 | still builds |  |
| ``MembershipDecidable`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Intelligence.swift:53 | inherited, no line to cut |  |
| ``MembershipDecidable`` | ``HasSigma`` | Sources/VerificationIsIdentification/Intelligence.swift:53 | inherited, no line to cut |  |
| ``MembershipDecidable`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Intelligence.swift:53 | inherited, no line to cut |  |
| ``MembershipDecidable`` | ``Open`` | Sources/VerificationIsIdentification/Intelligence.swift:53 | inherited, no line to cut |  |
| ``MembershipDecidable`` | ``Pair`` | Sources/VerificationIsIdentification/Intelligence.swift:53 | inherited, no line to cut |  |
| ``MembershipDecidable`` | ``Structure`` | Sources/VerificationIsIdentification/Intelligence.swift:53 | inherited, no line to cut |  |
| ``MembershipDecidable`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Intelligence.swift:53 | inherited, no line to cut |  |
| ``SystemCrystallizes`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Intelligence.swift:68 | inherited, no line to cut |  |
| ``SystemCrystallizes`` | ``CandidatesOnlyLeave`` | Sources/VerificationIsIdentification/Intelligence.swift:68 | inherited, no line to cut |  |
| ``SystemCrystallizes`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Intelligence.swift:68 | inherited, no line to cut |  |
| ``SystemCrystallizes`` | ``HasCache`` | Sources/VerificationIsIdentification/Intelligence.swift:68 | inherited, no line to cut |  |
| ``SystemCrystallizes`` | ``HasSigma`` | Sources/VerificationIsIdentification/Intelligence.swift:68 | inherited, no line to cut |  |
| ``SystemCrystallizes`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Intelligence.swift:68 | inherited, no line to cut |  |
| ``SystemCrystallizes`` | ``MembershipDecidable`` | Sources/VerificationIsIdentification/Intelligence.swift:68 | inherited, no line to cut |  |
| ``SystemCrystallizes`` | ``Open`` | Sources/VerificationIsIdentification/Intelligence.swift:68 | inherited, no line to cut |  |
| ``SystemCrystallizes`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Intelligence.swift:68 | inherited, no line to cut |  |
| ``SystemCrystallizes`` | ``Pair`` | Sources/VerificationIsIdentification/Intelligence.swift:68 | inherited, no line to cut |  |
| ``SystemCrystallizes`` | ``ResultsIrreversible`` | Sources/VerificationIsIdentification/Intelligence.swift:68 | inherited, no line to cut |  |
| ``SystemCrystallizes`` | ``Structure`` | Sources/VerificationIsIdentification/Intelligence.swift:68 | inherited, no line to cut |  |
| ``SystemCrystallizes`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Intelligence.swift:68 | inherited, no line to cut |  |
| ``PipelineCrystallizes`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``CandidatesOnlyLeave`` | Sources/VerificationIsIdentification/Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``HasCache`` | Sources/VerificationIsIdentification/Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``HasSigma`` | Sources/VerificationIsIdentification/Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``MembershipDecidable`` | Sources/VerificationIsIdentification/Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``Open`` | Sources/VerificationIsIdentification/Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``Pair`` | Sources/VerificationIsIdentification/Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``ResultsIrreversible`` | Sources/VerificationIsIdentification/Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``Structure`` | Sources/VerificationIsIdentification/Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``SystemCrystallizes`` | Sources/VerificationIsIdentification/Intelligence.swift:74 | still builds |  |
| ``LibraryCrystallizes`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``CandidatesOnlyLeave`` | Sources/VerificationIsIdentification/Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``HasCache`` | Sources/VerificationIsIdentification/Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``HasSigma`` | Sources/VerificationIsIdentification/Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``MembershipDecidable`` | Sources/VerificationIsIdentification/Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``Open`` | Sources/VerificationIsIdentification/Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``Pair`` | Sources/VerificationIsIdentification/Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``ResultsIrreversible`` | Sources/VerificationIsIdentification/Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``Structure`` | Sources/VerificationIsIdentification/Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``SystemCrystallizes`` | Sources/VerificationIsIdentification/Intelligence.swift:78 | still builds |  |
| ``SaturationDynamics`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Intelligence.swift:83 | still builds |  |
| ``SaturationDynamics`` | ``ComparisonsAreBounded`` | Sources/VerificationIsIdentification/Intelligence.swift:83 | still builds |  |
| ``SaturationDynamics`` | ``HasCache`` | Sources/VerificationIsIdentification/Intelligence.swift:83 | still builds |  |
| ``SaturationDynamics`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Intelligence.swift:83 | still builds |  |
| ``SaturationDynamics`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Intelligence.swift:83 | still builds |  |
| ``SaturationDynamics`` | ``HasSigma`` | Sources/VerificationIsIdentification/Intelligence.swift:83 | still builds |  |
| ``SaturationDynamics`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Intelligence.swift:83 | still builds |  |
| ``SaturationDynamics`` | ``Open`` | Sources/VerificationIsIdentification/Intelligence.swift:83 | still builds |  |
| ``SaturationDynamics`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Intelligence.swift:83 | still builds |  |
| ``SaturationDynamics`` | ``Pair`` | Sources/VerificationIsIdentification/Intelligence.swift:83 | still builds |  |
| ``SaturationDynamics`` | ``Structure`` | Sources/VerificationIsIdentification/Intelligence.swift:83 | still builds |  |
| ``SaturationDynamics`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Intelligence.swift:83 | still builds |  |
| ``DiscoveryIsRevelation`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Intelligence.swift:88 | still builds |  |
| ``DiscoveryIsRevelation`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Intelligence.swift:88 | still builds |  |
| ``DiscoveryIsRevelation`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Intelligence.swift:88 | still builds |  |
| ``DiscoveryIsRevelation`` | ``HasCache`` | Sources/VerificationIsIdentification/Intelligence.swift:88 | still builds |  |
| ``DiscoveryIsRevelation`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Intelligence.swift:88 | still builds |  |
| ``DiscoveryIsRevelation`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Intelligence.swift:88 | still builds |  |
| ``DiscoveryIsRevelation`` | ``HasSigma`` | Sources/VerificationIsIdentification/Intelligence.swift:88 | still builds |  |
| ``DiscoveryIsRevelation`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Intelligence.swift:88 | still builds |  |
| ``DiscoveryIsRevelation`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Intelligence.swift:88 | still builds |  |
| ``DiscoveryIsRevelation`` | ``Open`` | Sources/VerificationIsIdentification/Intelligence.swift:88 | still builds |  |
| ``DiscoveryIsRevelation`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Intelligence.swift:88 | still builds |  |
| ``DiscoveryIsRevelation`` | ``Pair`` | Sources/VerificationIsIdentification/Intelligence.swift:88 | still builds |  |
| ``DiscoveryIsRevelation`` | ``Structure`` | Sources/VerificationIsIdentification/Intelligence.swift:88 | still builds |  |
| ``DiscoveryIsRevelation`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Intelligence.swift:88 | still builds |  |
| ``HasEfficiency`` | ``HasSigma`` | Sources/VerificationIsIdentification/Intelligence.swift:96 | still builds |  |
| ``IntelligenceRises`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Intelligence.swift:104 | still builds |  |
| ``IntelligenceRises`` | ``HasCache`` | Sources/VerificationIsIdentification/Intelligence.swift:104 | still builds |  |
| ``IntelligenceRises`` | ``HasEfficiency`` | Sources/VerificationIsIdentification/Intelligence.swift:104 | still builds |  |
| ``IntelligenceRises`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Intelligence.swift:104 | still builds |  |
| ``IntelligenceRises`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Intelligence.swift:104 | still builds |  |
| ``IntelligenceRises`` | ``HasSigma`` | Sources/VerificationIsIdentification/Intelligence.swift:104 | still builds |  |
| ``IntelligenceRises`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Intelligence.swift:104 | still builds |  |
| ``IntelligenceRises`` | ``Open`` | Sources/VerificationIsIdentification/Intelligence.swift:104 | still builds |  |
| ``IntelligenceRises`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Intelligence.swift:104 | still builds |  |
| ``IntelligenceRises`` | ``Pair`` | Sources/VerificationIsIdentification/Intelligence.swift:104 | still builds |  |
| ``IntelligenceRises`` | ``Structure`` | Sources/VerificationIsIdentification/Intelligence.swift:104 | still builds |  |
| ``IntelligenceRises`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Intelligence.swift:104 | still builds |  |
| ``ThreeAxesOfCompare`` | ``AxesCoOriented`` | Sources/VerificationIsIdentification/Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``Decidable`` | Sources/VerificationIsIdentification/Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``HasCache`` | Sources/VerificationIsIdentification/Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``HasSigma`` | Sources/VerificationIsIdentification/Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``Null`` | Sources/VerificationIsIdentification/Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``Open`` | Sources/VerificationIsIdentification/Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``OrderIsOnlyFreedom`` | Sources/VerificationIsIdentification/Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``Pair`` | Sources/VerificationIsIdentification/Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``Structure`` | Sources/VerificationIsIdentification/Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Interference.swift:23 | still builds |  |
| ``InterferenceIsIntelligence`` | ``AxesCoOriented`` | Sources/VerificationIsIdentification/Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``HasCache`` | Sources/VerificationIsIdentification/Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``HasEfficiency`` | Sources/VerificationIsIdentification/Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``HasSigma`` | Sources/VerificationIsIdentification/Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``IntelligenceRises`` | Sources/VerificationIsIdentification/Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``Null`` | Sources/VerificationIsIdentification/Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``Open`` | Sources/VerificationIsIdentification/Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``OrderIsOnlyFreedom`` | Sources/VerificationIsIdentification/Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``Pair`` | Sources/VerificationIsIdentification/Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``Structure`` | Sources/VerificationIsIdentification/Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Interference.swift:30 | still builds |  |
| ``IsIsYIdentity`` | ``AxesCoOriented`` | Sources/VerificationIsIdentification/Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``HasCache`` | Sources/VerificationIsIdentification/Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``HasSigma`` | Sources/VerificationIsIdentification/Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``Null`` | Sources/VerificationIsIdentification/Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``Open`` | Sources/VerificationIsIdentification/Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``OrderIsOnlyFreedom`` | Sources/VerificationIsIdentification/Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``Pair`` | Sources/VerificationIsIdentification/Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``Structure`` | Sources/VerificationIsIdentification/Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Interference.swift:37 | still builds |  |
| ``LiquidPhase`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Liquid.swift:31 | still builds |  |
| ``LiquidPhase`` | ``HasCache`` | Sources/VerificationIsIdentification/Liquid.swift:31 | still builds |  |
| ``LiquidPhase`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Liquid.swift:31 | still builds |  |
| ``LiquidPhase`` | ``HasSigma`` | Sources/VerificationIsIdentification/Liquid.swift:31 | still builds |  |
| ``LiquidPhase`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Liquid.swift:31 | still builds |  |
| ``LiquidPhase`` | ``Monotone`` | Sources/VerificationIsIdentification/Liquid.swift:31 | still builds |  |
| ``LiquidPhase`` | ``Open`` | Sources/VerificationIsIdentification/Liquid.swift:31 | still builds |  |
| ``LiquidPhase`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Liquid.swift:31 | still builds |  |
| ``LiquidPhase`` | ``Pair`` | Sources/VerificationIsIdentification/Liquid.swift:31 | still builds |  |
| ``LiquidPhase`` | ``Structure`` | Sources/VerificationIsIdentification/Liquid.swift:31 | still builds |  |
| ``LiquidPhase`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Liquid.swift:31 | still builds |  |
| ``CrystallizationFront`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``HasCache`` | Sources/VerificationIsIdentification/Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``HasDistance`` | Sources/VerificationIsIdentification/Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``HasSigma`` | Sources/VerificationIsIdentification/Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``LiquidPhase`` | Sources/VerificationIsIdentification/Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``Monotone`` | Sources/VerificationIsIdentification/Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``NoInverse`` | Sources/VerificationIsIdentification/Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``Open`` | Sources/VerificationIsIdentification/Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``Pair`` | Sources/VerificationIsIdentification/Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``Structure`` | Sources/VerificationIsIdentification/Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Liquid.swift:38 | still builds |  |
| ``SearchFlow`` | ``AlignmentCoefficient`` | Sources/VerificationIsIdentification/Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``GateIsZeroOfLoss`` | Sources/VerificationIsIdentification/Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``HasAlpha`` | Sources/VerificationIsIdentification/Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``HasCache`` | Sources/VerificationIsIdentification/Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``HasDistance`` | Sources/VerificationIsIdentification/Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``HasSigma`` | Sources/VerificationIsIdentification/Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``LiquidPhase`` | Sources/VerificationIsIdentification/Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``Monotone`` | Sources/VerificationIsIdentification/Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``Open`` | Sources/VerificationIsIdentification/Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``Pair`` | Sources/VerificationIsIdentification/Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``Structure`` | Sources/VerificationIsIdentification/Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Liquid.swift:46 | still builds |  |
| ``StefanCoupling`` | ``AlignmentCoefficient`` | Sources/VerificationIsIdentification/Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``CrystallizationFront`` | Sources/VerificationIsIdentification/Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``GateIsZeroOfLoss`` | Sources/VerificationIsIdentification/Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``HasAlpha`` | Sources/VerificationIsIdentification/Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``HasCache`` | Sources/VerificationIsIdentification/Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``HasDistance`` | Sources/VerificationIsIdentification/Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``HasSigma`` | Sources/VerificationIsIdentification/Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``LiquidPhase`` | Sources/VerificationIsIdentification/Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``Monotone`` | Sources/VerificationIsIdentification/Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``NoInverse`` | Sources/VerificationIsIdentification/Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``Open`` | Sources/VerificationIsIdentification/Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``Pair`` | Sources/VerificationIsIdentification/Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``SearchFlow`` | Sources/VerificationIsIdentification/Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``Structure`` | Sources/VerificationIsIdentification/Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Liquid.swift:53 | still builds |  |
| ``GateIsMembrane`` | ``AlignmentCoefficient`` | Sources/VerificationIsIdentification/Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``CrystallizationFront`` | Sources/VerificationIsIdentification/Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``GateIsZeroOfLoss`` | Sources/VerificationIsIdentification/Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``HasAlpha`` | Sources/VerificationIsIdentification/Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``HasCache`` | Sources/VerificationIsIdentification/Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``HasDistance`` | Sources/VerificationIsIdentification/Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``HasSigma`` | Sources/VerificationIsIdentification/Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``LiquidPhase`` | Sources/VerificationIsIdentification/Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``Monotone`` | Sources/VerificationIsIdentification/Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``NoInverse`` | Sources/VerificationIsIdentification/Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``Open`` | Sources/VerificationIsIdentification/Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``Pair`` | Sources/VerificationIsIdentification/Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``SearchFlow`` | Sources/VerificationIsIdentification/Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``StefanCoupling`` | Sources/VerificationIsIdentification/Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``Structure`` | Sources/VerificationIsIdentification/Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Liquid.swift:66 | still builds |  |
| ``AnchorGraph`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Map.swift:23 | still builds |  |
| ``AnchorGraph`` | ``HasDistance`` | Sources/VerificationIsIdentification/Map.swift:23 | still builds |  |
| ``AnchorGraph`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Map.swift:23 | still builds |  |
| ``AnchorGraph`` | ``HasSigma`` | Sources/VerificationIsIdentification/Map.swift:23 | still builds |  |
| ``AnchorGraph`` | ``Open`` | Sources/VerificationIsIdentification/Map.swift:23 | still builds |  |
| ``AnchorGraph`` | ``Pair`` | Sources/VerificationIsIdentification/Map.swift:23 | still builds |  |
| ``AnchorGraph`` | ``Structure`` | Sources/VerificationIsIdentification/Map.swift:23 | still builds |  |
| ``AnchorGraph`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Map.swift:23 | still builds |  |
| ``GreedyDescentTerminates`` | ``AnchorGraph`` | Sources/VerificationIsIdentification/Map.swift:33 | still builds |  |
| ``GreedyDescentTerminates`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Map.swift:33 | still builds |  |
| ``GreedyDescentTerminates`` | ``HasDistance`` | Sources/VerificationIsIdentification/Map.swift:33 | still builds |  |
| ``GreedyDescentTerminates`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Map.swift:33 | still builds |  |
| ``GreedyDescentTerminates`` | ``HasSigma`` | Sources/VerificationIsIdentification/Map.swift:33 | still builds |  |
| ``GreedyDescentTerminates`` | ``Monotone`` | Sources/VerificationIsIdentification/Map.swift:33 | still builds |  |
| ``GreedyDescentTerminates`` | ``Open`` | Sources/VerificationIsIdentification/Map.swift:33 | still builds |  |
| ``GreedyDescentTerminates`` | ``Pair`` | Sources/VerificationIsIdentification/Map.swift:33 | still builds |  |
| ``GreedyDescentTerminates`` | ``Structure`` | Sources/VerificationIsIdentification/Map.swift:33 | still builds |  |
| ``GreedyDescentTerminates`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Map.swift:33 | still builds |  |
| ``HolesCarryAddresses`` | ``AnchorGraph`` | Sources/VerificationIsIdentification/Map.swift:39 | still builds |  |
| ``HolesCarryAddresses`` | ``Decidable`` | Sources/VerificationIsIdentification/Map.swift:39 | still builds |  |
| ``HolesCarryAddresses`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Map.swift:39 | still builds |  |
| ``HolesCarryAddresses`` | ``HasDistance`` | Sources/VerificationIsIdentification/Map.swift:39 | still builds |  |
| ``HolesCarryAddresses`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Map.swift:39 | still builds |  |
| ``HolesCarryAddresses`` | ``HasSigma`` | Sources/VerificationIsIdentification/Map.swift:39 | still builds |  |
| ``HolesCarryAddresses`` | ``Open`` | Sources/VerificationIsIdentification/Map.swift:39 | still builds |  |
| ``HolesCarryAddresses`` | ``Pair`` | Sources/VerificationIsIdentification/Map.swift:39 | still builds |  |
| ``HolesCarryAddresses`` | ``Structure`` | Sources/VerificationIsIdentification/Map.swift:39 | still builds |  |
| ``HolesCarryAddresses`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Map.swift:39 | still builds |  |
| ``RepairsPermanent`` | ``AnchorGraph`` | Sources/VerificationIsIdentification/Map.swift:45 | still builds |  |
| ``RepairsPermanent`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Map.swift:45 | still builds |  |
| ``RepairsPermanent`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Map.swift:45 | still builds |  |
| ``RepairsPermanent`` | ``HasCache`` | Sources/VerificationIsIdentification/Map.swift:45 | still builds |  |
| ``RepairsPermanent`` | ``HasDistance`` | Sources/VerificationIsIdentification/Map.swift:45 | still builds |  |
| ``RepairsPermanent`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Map.swift:45 | still builds |  |
| ``RepairsPermanent`` | ``HasSigma`` | Sources/VerificationIsIdentification/Map.swift:45 | still builds |  |
| ``RepairsPermanent`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Map.swift:45 | still builds |  |
| ``RepairsPermanent`` | ``NoInverse`` | Sources/VerificationIsIdentification/Map.swift:45 | still builds |  |
| ``RepairsPermanent`` | ``Open`` | Sources/VerificationIsIdentification/Map.swift:45 | still builds |  |
| ``RepairsPermanent`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Map.swift:45 | still builds |  |
| ``RepairsPermanent`` | ``Pair`` | Sources/VerificationIsIdentification/Map.swift:45 | still builds |  |
| ``RepairsPermanent`` | ``Structure`` | Sources/VerificationIsIdentification/Map.swift:45 | still builds |  |
| ``RepairsPermanent`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Map.swift:45 | still builds |  |
| ``FailureCurriculum`` | ``AnchorGraph`` | Sources/VerificationIsIdentification/Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``Decidable`` | Sources/VerificationIsIdentification/Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``HasCache`` | Sources/VerificationIsIdentification/Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``HasDistance`` | Sources/VerificationIsIdentification/Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``HasSigma`` | Sources/VerificationIsIdentification/Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``HolesCarryAddresses`` | Sources/VerificationIsIdentification/Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``NoInverse`` | Sources/VerificationIsIdentification/Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``Open`` | Sources/VerificationIsIdentification/Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``Pair`` | Sources/VerificationIsIdentification/Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``RepairsPermanent`` | Sources/VerificationIsIdentification/Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``Structure`` | Sources/VerificationIsIdentification/Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Map.swift:52 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``AnchorGraph`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``BallSaturation`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``CompressionCriterion`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``Decidable`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``HasCache`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``HasCost`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``HasDistance`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``HasSigma`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``HasTime`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``Ignites`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``Matter`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``Open`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``Pair`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``Resistant`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``Structure`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``Tower`` | Sources/VerificationIsIdentification/Map.swift:64 | still builds |  |
| ``NavigationInevitable`` | ``AnchorGraph`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``BallSaturation`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``CompressionCriterion`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``Decidable`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``HasCache`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``HasCost`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``HasDistance`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``HasSigma`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``HasTime`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``Ignites`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``Matter`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``OneBoundaryThreeFaces`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``Open`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``Pair`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``Resistant`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``Structure`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``Tower`` | Sources/VerificationIsIdentification/Map.swift:72 | still builds |  |
| ``HasTime`` | ``HasSigma`` | Sources/VerificationIsIdentification/Matter.swift:20 | still builds |  |
| ``HasCost`` | ``HasSigma`` | Sources/VerificationIsIdentification/Matter.swift:26 | still builds |  |
| ``Resistant`` | ``Decidable`` | Sources/VerificationIsIdentification/Matter.swift:36 | still builds |  |
| ``Resistant`` | ``HasDistance`` | Sources/VerificationIsIdentification/Matter.swift:36 | still builds |  |
| ``Resistant`` | ``HasSigma`` | Sources/VerificationIsIdentification/Matter.swift:36 | still builds |  |
| ``Resistant`` | ``Open`` | Sources/VerificationIsIdentification/Matter.swift:36 | still builds |  |
| ``Resistant`` | ``Pair`` | Sources/VerificationIsIdentification/Matter.swift:36 | still builds |  |
| ``Resistant`` | ``Structure`` | Sources/VerificationIsIdentification/Matter.swift:36 | still builds |  |
| ``Matter`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Matter.swift:50 | still builds |  |
| ``Matter`` | ``Decidable`` | Sources/VerificationIsIdentification/Matter.swift:50 | still builds |  |
| ``Matter`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Matter.swift:50 | still builds |  |
| ``Matter`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Matter.swift:50 | still builds |  |
| ``Matter`` | ``HasCache`` | Sources/VerificationIsIdentification/Matter.swift:50 | still builds |  |
| ``Matter`` | ``HasDistance`` | Sources/VerificationIsIdentification/Matter.swift:50 | still builds |  |
| ``Matter`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Matter.swift:50 | still builds |  |
| ``Matter`` | ``HasSigma`` | Sources/VerificationIsIdentification/Matter.swift:50 | still builds |  |
| ``Matter`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Matter.swift:50 | still builds |  |
| ``Matter`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Matter.swift:50 | still builds |  |
| ``Matter`` | ``Open`` | Sources/VerificationIsIdentification/Matter.swift:50 | still builds |  |
| ``Matter`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Matter.swift:50 | still builds |  |
| ``Matter`` | ``Pair`` | Sources/VerificationIsIdentification/Matter.swift:50 | still builds |  |
| ``Matter`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Matter.swift:50 | still builds |  |
| ``Matter`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Matter.swift:50 | still builds |  |
| ``Matter`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Matter.swift:50 | still builds |  |
| ``Matter`` | ``Resistant`` | Sources/VerificationIsIdentification/Matter.swift:50 | still builds |  |
| ``Matter`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Matter.swift:50 | still builds |  |
| ``Matter`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Matter.swift:50 | still builds |  |
| ``Matter`` | ``Structure`` | Sources/VerificationIsIdentification/Matter.swift:50 | still builds |  |
| ``Matter`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Matter.swift:50 | still builds |  |
| ``NoInverse`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Matter.swift:57 | inherited, no line to cut |  |
| ``NoInverse`` | ``HasCache`` | Sources/VerificationIsIdentification/Matter.swift:57 | inherited, no line to cut |  |
| ``NoInverse`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Matter.swift:57 | inherited, no line to cut |  |
| ``NoInverse`` | ``HasSigma`` | Sources/VerificationIsIdentification/Matter.swift:57 | inherited, no line to cut |  |
| ``NoInverse`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Matter.swift:57 | inherited, no line to cut |  |
| ``NoInverse`` | ``Open`` | Sources/VerificationIsIdentification/Matter.swift:57 | inherited, no line to cut |  |
| ``NoInverse`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Matter.swift:57 | inherited, no line to cut |  |
| ``NoInverse`` | ``Pair`` | Sources/VerificationIsIdentification/Matter.swift:57 | inherited, no line to cut |  |
| ``NoInverse`` | ``Structure`` | Sources/VerificationIsIdentification/Matter.swift:57 | inherited, no line to cut |  |
| ``NoInverse`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Matter.swift:57 | inherited, no line to cut |  |
| ``Converges`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Matter.swift:66 | still builds |  |
| ``Converges`` | ``CandidatesOnlyLeave`` | Sources/VerificationIsIdentification/Matter.swift:66 | still builds |  |
| ``Converges`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Matter.swift:66 | still builds |  |
| ``Converges`` | ``HasCache`` | Sources/VerificationIsIdentification/Matter.swift:66 | still builds |  |
| ``Converges`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Matter.swift:66 | still builds |  |
| ``Converges`` | ``HasSigma`` | Sources/VerificationIsIdentification/Matter.swift:66 | still builds |  |
| ``Converges`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Matter.swift:66 | still builds |  |
| ``Converges`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Matter.swift:66 | still builds |  |
| ``Converges`` | ``MembershipDecidable`` | Sources/VerificationIsIdentification/Matter.swift:66 | still builds |  |
| ``Converges`` | ``NoInverse`` | Sources/VerificationIsIdentification/Matter.swift:66 | still builds |  |
| ``Converges`` | ``Open`` | Sources/VerificationIsIdentification/Matter.swift:66 | still builds |  |
| ``Converges`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Matter.swift:66 | still builds |  |
| ``Converges`` | ``Pair`` | Sources/VerificationIsIdentification/Matter.swift:66 | still builds |  |
| ``Converges`` | ``ResultsIrreversible`` | Sources/VerificationIsIdentification/Matter.swift:66 | still builds |  |
| ``Converges`` | ``Structure`` | Sources/VerificationIsIdentification/Matter.swift:66 | still builds |  |
| ``Converges`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Matter.swift:66 | still builds |  |
| ``Converges`` | ``SystemCrystallizes`` | Sources/VerificationIsIdentification/Matter.swift:66 | still builds |  |
| ``Ignites`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Matter.swift:73 | still builds |  |
| ``Ignites`` | ``Decidable`` | Sources/VerificationIsIdentification/Matter.swift:73 | still builds |  |
| ``Ignites`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Matter.swift:73 | still builds |  |
| ``Ignites`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Matter.swift:73 | still builds |  |
| ``Ignites`` | ``HasCache`` | Sources/VerificationIsIdentification/Matter.swift:73 | still builds |  |
| ``Ignites`` | ``HasDistance`` | Sources/VerificationIsIdentification/Matter.swift:73 | still builds |  |
| ``Ignites`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Matter.swift:73 | still builds |  |
| ``Ignites`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Matter.swift:73 | still builds |  |
| ``Ignites`` | ``HasSigma`` | Sources/VerificationIsIdentification/Matter.swift:73 | still builds |  |
| ``Ignites`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Matter.swift:73 | still builds |  |
| ``Ignites`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Matter.swift:73 | still builds |  |
| ``Ignites`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Matter.swift:73 | still builds |  |
| ``Ignites`` | ``Matter`` | Sources/VerificationIsIdentification/Matter.swift:73 | still builds |  |
| ``Ignites`` | ``Open`` | Sources/VerificationIsIdentification/Matter.swift:73 | still builds |  |
| ``Ignites`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Matter.swift:73 | still builds |  |
| ``Ignites`` | ``Pair`` | Sources/VerificationIsIdentification/Matter.swift:73 | still builds |  |
| ``Ignites`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Matter.swift:73 | still builds |  |
| ``Ignites`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Matter.swift:73 | still builds |  |
| ``Ignites`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Matter.swift:73 | still builds |  |
| ``Ignites`` | ``Resistant`` | Sources/VerificationIsIdentification/Matter.swift:73 | still builds |  |
| ``Ignites`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Matter.swift:73 | still builds |  |
| ``Ignites`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Matter.swift:73 | still builds |  |
| ``Ignites`` | ``Structure`` | Sources/VerificationIsIdentification/Matter.swift:73 | still builds |  |
| ``Ignites`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Matter.swift:73 | still builds |  |
| ``Tower`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Matter.swift:81 | still builds |  |
| ``Tower`` | ``Decidable`` | Sources/VerificationIsIdentification/Matter.swift:81 | still builds |  |
| ``Tower`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Matter.swift:81 | still builds |  |
| ``Tower`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Matter.swift:81 | still builds |  |
| ``Tower`` | ``HasCache`` | Sources/VerificationIsIdentification/Matter.swift:81 | still builds |  |
| ``Tower`` | ``HasCost`` | Sources/VerificationIsIdentification/Matter.swift:81 | still builds |  |
| ``Tower`` | ``HasDistance`` | Sources/VerificationIsIdentification/Matter.swift:81 | still builds |  |
| ``Tower`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Matter.swift:81 | still builds |  |
| ``Tower`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Matter.swift:81 | still builds |  |
| ``Tower`` | ``HasSigma`` | Sources/VerificationIsIdentification/Matter.swift:81 | still builds |  |
| ``Tower`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Matter.swift:81 | still builds |  |
| ``Tower`` | ``HasTime`` | Sources/VerificationIsIdentification/Matter.swift:81 | still builds |  |
| ``Tower`` | ``Ignites`` | Sources/VerificationIsIdentification/Matter.swift:81 | still builds |  |
| ``Tower`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Matter.swift:81 | still builds |  |
| ``Tower`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Matter.swift:81 | still builds |  |
| ``Tower`` | ``Matter`` | Sources/VerificationIsIdentification/Matter.swift:81 | still builds |  |
| ``Tower`` | ``Open`` | Sources/VerificationIsIdentification/Matter.swift:81 | still builds |  |
| ``Tower`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Matter.swift:81 | still builds |  |
| ``Tower`` | ``Pair`` | Sources/VerificationIsIdentification/Matter.swift:81 | still builds |  |
| ``Tower`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Matter.swift:81 | still builds |  |
| ``Tower`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Matter.swift:81 | still builds |  |
| ``Tower`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Matter.swift:81 | still builds |  |
| ``Tower`` | ``Resistant`` | Sources/VerificationIsIdentification/Matter.swift:81 | still builds |  |
| ``Tower`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Matter.swift:81 | still builds |  |
| ``Tower`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Matter.swift:81 | still builds |  |
| ``Tower`` | ``Structure`` | Sources/VerificationIsIdentification/Matter.swift:81 | still builds |  |
| ``Tower`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Matter.swift:81 | still builds |  |
| ``FiniteDiscovery`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``ComparisonsAreBounded`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``Decidable`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``HasCache`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``HasCost`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``HasDistance`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``HasSigma`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``HasTime`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``Ignites`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``Matter`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``Open`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``Pair`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``Resistant`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``Structure`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``Tower`` | Sources/VerificationIsIdentification/Matter.swift:90 | still builds |  |
| ``Digit`` | ``Open`` | Sources/VerificationIsIdentification/Numeral.swift:20 | still builds |  |
| ``Digit`` | ``Structure`` | Sources/VerificationIsIdentification/Numeral.swift:20 | still builds |  |
| ``HasPath`` | ``HasSigma`` | Sources/VerificationIsIdentification/Path.swift:32 | still builds |  |
| ``EmissionAccumulates`` | ``HasPath`` | Sources/VerificationIsIdentification/Path.swift:42 | inherited, no line to cut |  |
| ``EmissionAccumulates`` | ``HasSigma`` | Sources/VerificationIsIdentification/Path.swift:42 | inherited, no line to cut |  |
| ``CostIsPathLength`` | ``HasDistance`` | Sources/VerificationIsIdentification/Path.swift:52 | inherited, no line to cut |  |
| ``CostIsPathLength`` | ``HasPath`` | Sources/VerificationIsIdentification/Path.swift:52 | inherited, no line to cut |  |
| ``CostIsPathLength`` | ``HasSigma`` | Sources/VerificationIsIdentification/Path.swift:52 | inherited, no line to cut |  |
| ``ReachIsPath`` | ``HasBasis`` | Sources/VerificationIsIdentification/Path.swift:67 | inherited, no line to cut |  |
| ``ReachIsPath`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Path.swift:67 | inherited, no line to cut |  |
| ``ReachIsPath`` | ``HasPath`` | Sources/VerificationIsIdentification/Path.swift:67 | inherited, no line to cut |  |
| ``ReachIsPath`` | ``HasSigma`` | Sources/VerificationIsIdentification/Path.swift:67 | inherited, no line to cut |  |
| ``EmissionIsAutoregressive`` | ``HasEncoding`` | Sources/VerificationIsIdentification/Path.swift:78 | inherited, no line to cut |  |
| ``EmissionIsAutoregressive`` | ``HasPath`` | Sources/VerificationIsIdentification/Path.swift:78 | inherited, no line to cut |  |
| ``EmissionIsAutoregressive`` | ``HasSigma`` | Sources/VerificationIsIdentification/Path.swift:78 | inherited, no line to cut |  |
| ``EmissionIsAutoregressive`` | ``Open`` | Sources/VerificationIsIdentification/Path.swift:78 | inherited, no line to cut |  |
| ``EmissionIsAutoregressive`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Path.swift:78 | inherited, no line to cut |  |
| ``EmissionIsAutoregressive`` | ``Pair`` | Sources/VerificationIsIdentification/Path.swift:78 | inherited, no line to cut |  |
| ``EmissionIsAutoregressive`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Path.swift:78 | inherited, no line to cut |  |
| ``EmissionIsAutoregressive`` | ``ScopeBoundedByEncoding`` | Sources/VerificationIsIdentification/Path.swift:78 | inherited, no line to cut |  |
| ``EmissionIsAutoregressive`` | ``Structure`` | Sources/VerificationIsIdentification/Path.swift:78 | inherited, no line to cut |  |
| ``ConstructionIsReading`` | ``AxesCoOriented`` | Sources/VerificationIsIdentification/Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``EmissionAccumulates`` | Sources/VerificationIsIdentification/Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``HasCache`` | Sources/VerificationIsIdentification/Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``HasPath`` | Sources/VerificationIsIdentification/Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``HasSigma`` | Sources/VerificationIsIdentification/Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``HasTime`` | Sources/VerificationIsIdentification/Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``Measurable`` | Sources/VerificationIsIdentification/Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``Null`` | Sources/VerificationIsIdentification/Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``Open`` | Sources/VerificationIsIdentification/Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``OrderIsOnlyFreedom`` | Sources/VerificationIsIdentification/Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``Pair`` | Sources/VerificationIsIdentification/Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``Reading`` | Sources/VerificationIsIdentification/Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``RevealsNotCreates`` | Sources/VerificationIsIdentification/Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``Structure`` | Sources/VerificationIsIdentification/Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Path.swift:90 | still builds |  |
| ``InvalidStepFolds`` | ``HasPath`` | Sources/VerificationIsIdentification/Path.swift:101 | inherited, no line to cut |  |
| ``InvalidStepFolds`` | ``HasSigma`` | Sources/VerificationIsIdentification/Path.swift:101 | inherited, no line to cut |  |
| ``InvalidStepFolds`` | ``Null`` | Sources/VerificationIsIdentification/Path.swift:101 | inherited, no line to cut |  |
| ``InvalidStepFolds`` | ``Open`` | Sources/VerificationIsIdentification/Path.swift:101 | inherited, no line to cut |  |
| ``InvalidStepFolds`` | ``Pair`` | Sources/VerificationIsIdentification/Path.swift:101 | inherited, no line to cut |  |
| ``InvalidStepFolds`` | ``Structure`` | Sources/VerificationIsIdentification/Path.swift:101 | inherited, no line to cut |  |
| ``GatedConstruction`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``CandidatesOnlyLeave`` | Sources/VerificationIsIdentification/Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``EmissionAccumulates`` | Sources/VerificationIsIdentification/Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``HasCache`` | Sources/VerificationIsIdentification/Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``HasPath`` | Sources/VerificationIsIdentification/Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``HasSigma`` | Sources/VerificationIsIdentification/Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``MembershipDecidable`` | Sources/VerificationIsIdentification/Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``Open`` | Sources/VerificationIsIdentification/Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``Pair`` | Sources/VerificationIsIdentification/Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``ResultsIrreversible`` | Sources/VerificationIsIdentification/Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``Structure`` | Sources/VerificationIsIdentification/Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``SystemCrystallizes`` | Sources/VerificationIsIdentification/Path.swift:111 | still builds |  |
| ``FreeGeneration`` | ``AxesCoOriented`` | Sources/VerificationIsIdentification/Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``DiscriminatorAndGenerator`` | Sources/VerificationIsIdentification/Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``EmissionAccumulates`` | Sources/VerificationIsIdentification/Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``HasCache`` | Sources/VerificationIsIdentification/Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``HasPath`` | Sources/VerificationIsIdentification/Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``HasSigma`` | Sources/VerificationIsIdentification/Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``Null`` | Sources/VerificationIsIdentification/Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``Open`` | Sources/VerificationIsIdentification/Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``OrderIsOnlyFreedom`` | Sources/VerificationIsIdentification/Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``Pair`` | Sources/VerificationIsIdentification/Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``Structure`` | Sources/VerificationIsIdentification/Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Path.swift:126 | still builds |  |
| ``ProgramIsPath`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``CandidatesOnlyLeave`` | Sources/VerificationIsIdentification/Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``EmissionAccumulates`` | Sources/VerificationIsIdentification/Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``EmissionIsAutoregressive`` | Sources/VerificationIsIdentification/Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``GatedConstruction`` | Sources/VerificationIsIdentification/Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``HasBasis`` | Sources/VerificationIsIdentification/Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``HasCache`` | Sources/VerificationIsIdentification/Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``HasEncoding`` | Sources/VerificationIsIdentification/Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``HasPath`` | Sources/VerificationIsIdentification/Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``HasSigma`` | Sources/VerificationIsIdentification/Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``MembershipDecidable`` | Sources/VerificationIsIdentification/Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``Open`` | Sources/VerificationIsIdentification/Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``Pair`` | Sources/VerificationIsIdentification/Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``ReachIsPath`` | Sources/VerificationIsIdentification/Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``ResultsIrreversible`` | Sources/VerificationIsIdentification/Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``ScopeBoundedByEncoding`` | Sources/VerificationIsIdentification/Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``Structure`` | Sources/VerificationIsIdentification/Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``SystemCrystallizes`` | Sources/VerificationIsIdentification/Path.swift:136 | still builds |  |
| ``CompletionIsSolutionSet`` | ``AxesCoOriented`` | Sources/VerificationIsIdentification/Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``HasCache`` | Sources/VerificationIsIdentification/Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``HasPath`` | Sources/VerificationIsIdentification/Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``HasSigma`` | Sources/VerificationIsIdentification/Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``HasTime`` | Sources/VerificationIsIdentification/Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``Measurable`` | Sources/VerificationIsIdentification/Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``Null`` | Sources/VerificationIsIdentification/Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``Open`` | Sources/VerificationIsIdentification/Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``OrderIsOnlyFreedom`` | Sources/VerificationIsIdentification/Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``Pair`` | Sources/VerificationIsIdentification/Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``Reading`` | Sources/VerificationIsIdentification/Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``RevealsNotCreates`` | Sources/VerificationIsIdentification/Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``Structure`` | Sources/VerificationIsIdentification/Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Path.swift:148 | inherited, no line to cut |  |
| ``ErasureIsRecession`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Path.swift:160 | still builds |  |
| ``ErasureIsRecession`` | ``EmissionAccumulates`` | Sources/VerificationIsIdentification/Path.swift:160 | still builds |  |
| ``ErasureIsRecession`` | ``HasCache`` | Sources/VerificationIsIdentification/Path.swift:160 | still builds |  |
| ``ErasureIsRecession`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Path.swift:160 | still builds |  |
| ``ErasureIsRecession`` | ``HasPath`` | Sources/VerificationIsIdentification/Path.swift:160 | still builds |  |
| ``ErasureIsRecession`` | ``HasSigma`` | Sources/VerificationIsIdentification/Path.swift:160 | still builds |  |
| ``ErasureIsRecession`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Path.swift:160 | still builds |  |
| ``ErasureIsRecession`` | ``NoInverse`` | Sources/VerificationIsIdentification/Path.swift:160 | still builds |  |
| ``ErasureIsRecession`` | ``Open`` | Sources/VerificationIsIdentification/Path.swift:160 | still builds |  |
| ``ErasureIsRecession`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Path.swift:160 | still builds |  |
| ``ErasureIsRecession`` | ``Pair`` | Sources/VerificationIsIdentification/Path.swift:160 | still builds |  |
| ``ErasureIsRecession`` | ``Structure`` | Sources/VerificationIsIdentification/Path.swift:160 | still builds |  |
| ``ErasureIsRecession`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Path.swift:160 | still builds |  |
| ``CertifiedRuleGenerates`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``HasCache`` | Sources/VerificationIsIdentification/Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``HasSigma`` | Sources/VerificationIsIdentification/Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``Open`` | Sources/VerificationIsIdentification/Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``Pair`` | Sources/VerificationIsIdentification/Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``Structure`` | Sources/VerificationIsIdentification/Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Play.swift:23 | still builds |  |
| ``AmbiguityNamesInput`` | ``AnchorGraph`` | Sources/VerificationIsIdentification/Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``CertifiedRuleGenerates`` | Sources/VerificationIsIdentification/Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``Decidable`` | Sources/VerificationIsIdentification/Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``HasCache`` | Sources/VerificationIsIdentification/Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``HasDistance`` | Sources/VerificationIsIdentification/Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``HasSigma`` | Sources/VerificationIsIdentification/Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``HolesCarryAddresses`` | Sources/VerificationIsIdentification/Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``Open`` | Sources/VerificationIsIdentification/Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``Pair`` | Sources/VerificationIsIdentification/Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``Structure`` | Sources/VerificationIsIdentification/Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Play.swift:30 | still builds |  |
| ``SelfPlaySaturates`` | ``AmbiguityNamesInput`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``AnchorGraph`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``BasisIsFinite`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``CertifiedRuleGenerates`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``Decidable`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``HasBasis`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``HasCache`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``HasDistance`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``HasSigma`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``HolesCarryAddresses`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``Open`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``Pair`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``Structure`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Play.swift:42 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``AmbiguityNamesInput`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``AnchorGraph`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``BasisIsFinite`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``CertifiedRuleGenerates`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``Decidable`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``HasBasis`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``HasCache`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``HasDistance`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``HasSigma`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``HolesCarryAddresses`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``Open`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``Pair`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``ScopeBoundedByEncoding`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``SelfPlaySaturates`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``Structure`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Play.swift:49 | still builds |  |
| ``TowerSelfPlay`` | ``AmbiguityNamesInput`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``AnchorGraph`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``BasisIsFinite`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``CertifiedRuleGenerates`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``Decidable`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``HasBasis`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``HasCache`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``HasDistance`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``HasSigma`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``HolesCarryAddresses`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``Ignites`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``Matter`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``Open`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``Pair`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``Resistant`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``SelfPlaySaturates`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``Structure`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Play.swift:55 | still builds |  |
| ``PlayIsProof`` | ``AmbiguityNamesInput`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``AnchorGraph`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``BasisIsFinite`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``CertifiedRuleGenerates`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``Decidable`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``HasBasis`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``HasCache`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``HasDistance`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``HasSigma`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``HolesCarryAddresses`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``Ignites`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``Matter`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``Measurable`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``Open`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``Pair`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``Resistant`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``RevealsNotCreates`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``SelfPlaySaturates`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``Structure`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``TowerSelfPlay`` | Sources/VerificationIsIdentification/Play.swift:70 | still builds |  |
| ``PresentedLaw`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Presentation.swift:18 | still builds |  |
| ``PresentedLaw`` | ``HasDistance`` | Sources/VerificationIsIdentification/Presentation.swift:18 | still builds |  |
| ``PresentedLaw`` | ``HasLaw`` | Sources/VerificationIsIdentification/Presentation.swift:18 | still builds |  |
| ``PresentedLaw`` | ``HasSigma`` | Sources/VerificationIsIdentification/Presentation.swift:18 | still builds |  |
| ``PresentedLaw`` | ``Open`` | Sources/VerificationIsIdentification/Presentation.swift:18 | still builds |  |
| ``PresentedLaw`` | ``Pair`` | Sources/VerificationIsIdentification/Presentation.swift:18 | still builds |  |
| ``PresentedLaw`` | ``Structure`` | Sources/VerificationIsIdentification/Presentation.swift:18 | still builds |  |
| ``PresentedLaw`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Presentation.swift:18 | still builds |  |
| ``PressIsIdentification`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``HasDistance`` | Sources/VerificationIsIdentification/Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``HasLaw`` | Sources/VerificationIsIdentification/Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``HasSigma`` | Sources/VerificationIsIdentification/Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``Open`` | Sources/VerificationIsIdentification/Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``Pair`` | Sources/VerificationIsIdentification/Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``PresentedLaw`` | Sources/VerificationIsIdentification/Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``Structure`` | Sources/VerificationIsIdentification/Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Presentation.swift:25 | still builds |  |
| ``EdgesCarryTheJudgement`` | ``BehaviorIsStructure`` | Sources/VerificationIsIdentification/Presentation.swift:32 | still builds |  |
| ``EdgesCarryTheJudgement`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Presentation.swift:32 | still builds |  |
| ``EdgesCarryTheJudgement`` | ``HasDistance`` | Sources/VerificationIsIdentification/Presentation.swift:32 | still builds |  |
| ``EdgesCarryTheJudgement`` | ``HasLaw`` | Sources/VerificationIsIdentification/Presentation.swift:32 | still builds |  |
| ``EdgesCarryTheJudgement`` | ``HasSigma`` | Sources/VerificationIsIdentification/Presentation.swift:32 | still builds |  |
| ``EdgesCarryTheJudgement`` | ``HasTime`` | Sources/VerificationIsIdentification/Presentation.swift:32 | still builds |  |
| ``EdgesCarryTheJudgement`` | ``Open`` | Sources/VerificationIsIdentification/Presentation.swift:32 | still builds |  |
| ``EdgesCarryTheJudgement`` | ``Pair`` | Sources/VerificationIsIdentification/Presentation.swift:32 | still builds |  |
| ``EdgesCarryTheJudgement`` | ``PresentedLaw`` | Sources/VerificationIsIdentification/Presentation.swift:32 | still builds |  |
| ``EdgesCarryTheJudgement`` | ``Structure`` | Sources/VerificationIsIdentification/Presentation.swift:32 | still builds |  |
| ``EdgesCarryTheJudgement`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Presentation.swift:32 | still builds |  |
| ``FormIsInvariant`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Presentation.swift:38 | still builds |  |
| ``FormIsInvariant`` | ``HasDistance`` | Sources/VerificationIsIdentification/Presentation.swift:38 | still builds |  |
| ``FormIsInvariant`` | ``HasLaw`` | Sources/VerificationIsIdentification/Presentation.swift:38 | still builds |  |
| ``FormIsInvariant`` | ``HasSigma`` | Sources/VerificationIsIdentification/Presentation.swift:38 | still builds |  |
| ``FormIsInvariant`` | ``Open`` | Sources/VerificationIsIdentification/Presentation.swift:38 | still builds |  |
| ``FormIsInvariant`` | ``Pair`` | Sources/VerificationIsIdentification/Presentation.swift:38 | still builds |  |
| ``FormIsInvariant`` | ``PresentedLaw`` | Sources/VerificationIsIdentification/Presentation.swift:38 | still builds |  |
| ``FormIsInvariant`` | ``Structure`` | Sources/VerificationIsIdentification/Presentation.swift:38 | still builds |  |
| ``FormIsInvariant`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Presentation.swift:38 | still builds |  |
| ``Open`` | ``Structure`` | Sources/VerificationIsIdentification/Primitive.swift:70 | fails | Paired<A, B>, Plus<Unit, Unit>, Structure, U2, body |
| ``Close`` | ``Structure`` | Sources/VerificationIsIdentification/Primitive.swift:88 | fails | Structure, U1, Unit |
| ``Pair`` | ``Open`` | Sources/VerificationIsIdentification/Primitive.swift:102 | fails | Paired<A, B>, Structure, body |
| ``Pair`` | ``Structure`` | Sources/VerificationIsIdentification/Primitive.swift:102 | still builds |  |
| ``Null`` | ``Open`` | Sources/VerificationIsIdentification/Primitive.swift:114 | inherited, no line to cut |  |
| ``Null`` | ``Pair`` | Sources/VerificationIsIdentification/Primitive.swift:114 | inherited, no line to cut |  |
| ``Null`` | ``Structure`` | Sources/VerificationIsIdentification/Primitive.swift:114 | inherited, no line to cut |  |
| ``AllCoordinatesPresent`` | ``AlignmentCoefficient`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``AmbiguityNamesInput`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``AnchorGraph`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``BasisIsFinite`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``CertifiedRuleGenerates`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``CrystallizationFront`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``Decidable`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``GateIsMembrane`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``GateIsZeroOfLoss`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``HasAlpha`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``HasBasis`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``HasCache`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``HasDistance`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``HasSigma`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``HolesCarryAddresses`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``Ignites`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``LiquidPhase`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``Matter`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``Measurable`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``Monotone`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``NoInverse`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``Open`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``Pair`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``PlayIsProof`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``Resistant`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``RevealsNotCreates`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``SearchFlow`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``SelfPlaySaturates`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``StefanCoupling`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``Structure`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``TowerSelfPlay`` | Sources/VerificationIsIdentification/Projection.swift:29 | still builds |  |
| ``GateWrapper`` | ``AlignmentCoefficient`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``AxesCoOriented`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``CrystallizationFront`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``DiscriminatorAndGenerator`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``GateIsMembrane`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``GateIsZeroOfLoss`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``HasAlpha`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``HasCache`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``HasDistance`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``HasSigma`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``LiquidPhase`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``Monotone`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``NoInverse`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``Null`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``Open`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``OrderIsOnlyFreedom`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``Pair`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``SearchFlow`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``StefanCoupling`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``Structure`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Projection.swift:38 | still builds |  |
| ``SaturationMap`` | ``AlignmentCoefficient`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``AnchorGraph`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``AxesCoOriented`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``BallSaturation`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``CompressionCriterion`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``CrystallizationFront`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``Decidable`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``FourthFace`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``GateIsMembrane`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``GateIsZeroOfLoss`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``HasAlpha`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``HasCache`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``HasCost`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``HasDistance`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``HasSigma`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``HasTime`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``Ignites`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``LiquidPhase`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``Matter`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``MeasuredGeometry`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``Monotone`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``NoInverse`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``Null`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``OneBoundaryThreeFaces`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``Open`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``OrderIsOnlyFreedom`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``Pair`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``Resistant`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``SearchFlow`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``SearchableIffClusteredAndAligned`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``SkillsAreBalls`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``StefanCoupling`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``StrategyLivesInSigma`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``Structure`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``Tower`` | Sources/VerificationIsIdentification/Projection.swift:46 | still builds |  |
| ``Reading`` | ``AxesCoOriented`` | Sources/VerificationIsIdentification/Reading.swift:23 | still builds |  |
| ``Reading`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Reading.swift:23 | still builds |  |
| ``Reading`` | ``HasCache`` | Sources/VerificationIsIdentification/Reading.swift:23 | still builds |  |
| ``Reading`` | ``HasSigma`` | Sources/VerificationIsIdentification/Reading.swift:23 | still builds |  |
| ``Reading`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Reading.swift:23 | still builds |  |
| ``Reading`` | ``HasTime`` | Sources/VerificationIsIdentification/Reading.swift:23 | still builds |  |
| ``Reading`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Reading.swift:23 | still builds |  |
| ``Reading`` | ``Measurable`` | Sources/VerificationIsIdentification/Reading.swift:23 | still builds |  |
| ``Reading`` | ``Null`` | Sources/VerificationIsIdentification/Reading.swift:23 | still builds |  |
| ``Reading`` | ``Open`` | Sources/VerificationIsIdentification/Reading.swift:23 | still builds |  |
| ``Reading`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Reading.swift:23 | still builds |  |
| ``Reading`` | ``OrderIsOnlyFreedom`` | Sources/VerificationIsIdentification/Reading.swift:23 | still builds |  |
| ``Reading`` | ``Pair`` | Sources/VerificationIsIdentification/Reading.swift:23 | still builds |  |
| ``Reading`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Reading.swift:23 | still builds |  |
| ``Reading`` | ``RevealsNotCreates`` | Sources/VerificationIsIdentification/Reading.swift:23 | still builds |  |
| ``Reading`` | ``Structure`` | Sources/VerificationIsIdentification/Reading.swift:23 | still builds |  |
| ``Reading`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Reading.swift:23 | still builds |  |
| ``StandardIsType`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Ruler.swift:18 | still builds |  |
| ``StandardIsType`` | ``HasDistance`` | Sources/VerificationIsIdentification/Ruler.swift:18 | still builds |  |
| ``StandardIsType`` | ``HasLaw`` | Sources/VerificationIsIdentification/Ruler.swift:18 | still builds |  |
| ``StandardIsType`` | ``HasSigma`` | Sources/VerificationIsIdentification/Ruler.swift:18 | still builds |  |
| ``StandardIsType`` | ``Open`` | Sources/VerificationIsIdentification/Ruler.swift:18 | still builds |  |
| ``StandardIsType`` | ``Pair`` | Sources/VerificationIsIdentification/Ruler.swift:18 | still builds |  |
| ``StandardIsType`` | ``PresentedLaw`` | Sources/VerificationIsIdentification/Ruler.swift:18 | still builds |  |
| ``StandardIsType`` | ``Structure`` | Sources/VerificationIsIdentification/Ruler.swift:18 | still builds |  |
| ``StandardIsType`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Ruler.swift:18 | still builds |  |
| ``MeasureIsCount`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Ruler.swift:28 | still builds |  |
| ``MeasureIsCount`` | ``HasDistance`` | Sources/VerificationIsIdentification/Ruler.swift:28 | still builds |  |
| ``MeasureIsCount`` | ``HasLaw`` | Sources/VerificationIsIdentification/Ruler.swift:28 | still builds |  |
| ``MeasureIsCount`` | ``HasSigma`` | Sources/VerificationIsIdentification/Ruler.swift:28 | still builds |  |
| ``MeasureIsCount`` | ``Open`` | Sources/VerificationIsIdentification/Ruler.swift:28 | still builds |  |
| ``MeasureIsCount`` | ``Pair`` | Sources/VerificationIsIdentification/Ruler.swift:28 | still builds |  |
| ``MeasureIsCount`` | ``PresentedLaw`` | Sources/VerificationIsIdentification/Ruler.swift:28 | still builds |  |
| ``MeasureIsCount`` | ``StandardIsType`` | Sources/VerificationIsIdentification/Ruler.swift:28 | still builds |  |
| ``MeasureIsCount`` | ``Structure`` | Sources/VerificationIsIdentification/Ruler.swift:28 | still builds |  |
| ``MeasureIsCount`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Ruler.swift:28 | still builds |  |
| ``AlignmentCoefficient`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Search.swift:29 | still builds |  |
| ``AlignmentCoefficient`` | ``GateIsZeroOfLoss`` | Sources/VerificationIsIdentification/Search.swift:29 | still builds |  |
| ``AlignmentCoefficient`` | ``HasAlpha`` | Sources/VerificationIsIdentification/Search.swift:29 | still builds |  |
| ``AlignmentCoefficient`` | ``HasDistance`` | Sources/VerificationIsIdentification/Search.swift:29 | still builds |  |
| ``AlignmentCoefficient`` | ``HasSigma`` | Sources/VerificationIsIdentification/Search.swift:29 | still builds |  |
| ``AlignmentCoefficient`` | ``Open`` | Sources/VerificationIsIdentification/Search.swift:29 | still builds |  |
| ``AlignmentCoefficient`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Search.swift:29 | still builds |  |
| ``AlignmentCoefficient`` | ``Pair`` | Sources/VerificationIsIdentification/Search.swift:29 | still builds |  |
| ``AlignmentCoefficient`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Search.swift:29 | still builds |  |
| ``AlignmentCoefficient`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Search.swift:29 | still builds |  |
| ``AlignmentCoefficient`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Search.swift:29 | still builds |  |
| ``AlignmentCoefficient`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Search.swift:29 | still builds |  |
| ``AlignmentCoefficient`` | ``Structure`` | Sources/VerificationIsIdentification/Search.swift:29 | still builds |  |
| ``AlignmentCoefficient`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Search.swift:29 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``AlignmentCoefficient`` | Sources/VerificationIsIdentification/Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``GateIsZeroOfLoss`` | Sources/VerificationIsIdentification/Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``HasAlpha`` | Sources/VerificationIsIdentification/Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``HasCache`` | Sources/VerificationIsIdentification/Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``HasDistance`` | Sources/VerificationIsIdentification/Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``HasEfficiency`` | Sources/VerificationIsIdentification/Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``HasSigma`` | Sources/VerificationIsIdentification/Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``IntelligenceRises`` | Sources/VerificationIsIdentification/Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``Open`` | Sources/VerificationIsIdentification/Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``Pair`` | Sources/VerificationIsIdentification/Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``Structure`` | Sources/VerificationIsIdentification/Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Search.swift:38 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``AlignmentCoefficient`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``AnchorGraph`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``BallSaturation`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``CompressionCriterion`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``Decidable`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``GateIsZeroOfLoss`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``HasAlpha`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``HasCache`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``HasCost`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``HasDistance`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``HasSigma`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``HasTime`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``Ignites`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``Matter`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``OneBoundaryThreeFaces`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``Open`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``Pair`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``Resistant`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``Structure`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``Tower`` | Sources/VerificationIsIdentification/Search.swift:50 | still builds |  |
| ``EncodingForgets`` | ``HasEncoding`` | Sources/VerificationIsIdentification/Seeing.swift:17 | still builds |  |
| ``EncodingForgets`` | ``HasSigma`` | Sources/VerificationIsIdentification/Seeing.swift:17 | still builds |  |
| ``SeparatorIdentifies`` | ``EncodingForgets`` | Sources/VerificationIsIdentification/Seeing.swift:29 | still builds |  |
| ``SeparatorIdentifies`` | ``HasEncoding`` | Sources/VerificationIsIdentification/Seeing.swift:29 | still builds |  |
| ``SeparatorIdentifies`` | ``HasSigma`` | Sources/VerificationIsIdentification/Seeing.swift:29 | still builds |  |
| ``HasGrammar`` | ``HasEncoding`` | Sources/VerificationIsIdentification/Space.swift:20 | still builds |  |
| ``HasGrammar`` | ``HasSigma`` | Sources/VerificationIsIdentification/Space.swift:20 | still builds |  |
| ``PerspectiveIsEncoding`` | ``HasEncoding`` | Sources/VerificationIsIdentification/Space.swift:30 | still builds |  |
| ``PerspectiveIsEncoding`` | ``HasSigma`` | Sources/VerificationIsIdentification/Space.swift:30 | still builds |  |
| ``PerspectiveIsEncoding`` | ``Measurable`` | Sources/VerificationIsIdentification/Space.swift:30 | still builds |  |
| ``PerspectiveIsEncoding`` | ``Open`` | Sources/VerificationIsIdentification/Space.swift:30 | still builds |  |
| ``PerspectiveIsEncoding`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Space.swift:30 | still builds |  |
| ``PerspectiveIsEncoding`` | ``Pair`` | Sources/VerificationIsIdentification/Space.swift:30 | still builds |  |
| ``PerspectiveIsEncoding`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Space.swift:30 | still builds |  |
| ``PerspectiveIsEncoding`` | ``ScopeBoundedByEncoding`` | Sources/VerificationIsIdentification/Space.swift:30 | still builds |  |
| ``PerspectiveIsEncoding`` | ``Structure`` | Sources/VerificationIsIdentification/Space.swift:30 | still builds |  |
| ``DistanceIsMetric`` | ``HasCache`` | Sources/VerificationIsIdentification/Space.swift:43 | inherited, no line to cut |  |
| ``DistanceIsMetric`` | ``HasDistance`` | Sources/VerificationIsIdentification/Space.swift:43 | inherited, no line to cut |  |
| ``DistanceIsMetric`` | ``HasSigma`` | Sources/VerificationIsIdentification/Space.swift:43 | inherited, no line to cut |  |
| ``SpaceFromDifference`` | ``DistanceIsMetric`` | Sources/VerificationIsIdentification/Space.swift:49 | still builds |  |
| ``SpaceFromDifference`` | ``HasCache`` | Sources/VerificationIsIdentification/Space.swift:49 | still builds |  |
| ``SpaceFromDifference`` | ``HasDistance`` | Sources/VerificationIsIdentification/Space.swift:49 | still builds |  |
| ``SpaceFromDifference`` | ``HasEncoding`` | Sources/VerificationIsIdentification/Space.swift:49 | still builds |  |
| ``SpaceFromDifference`` | ``HasGrammar`` | Sources/VerificationIsIdentification/Space.swift:49 | still builds |  |
| ``SpaceFromDifference`` | ``HasSigma`` | Sources/VerificationIsIdentification/Space.swift:49 | still builds |  |
| ``QualitiesAreFinite`` | ``HasEncoding`` | Sources/VerificationIsIdentification/Space.swift:56 | still builds |  |
| ``QualitiesAreFinite`` | ``HasSigma`` | Sources/VerificationIsIdentification/Space.swift:56 | still builds |  |
| ``QualitiesAreFinite`` | ``IntegerValued`` | Sources/VerificationIsIdentification/Space.swift:56 | still builds |  |
| ``QualitiesAreFinite`` | ``Open`` | Sources/VerificationIsIdentification/Space.swift:56 | still builds |  |
| ``QualitiesAreFinite`` | ``Pair`` | Sources/VerificationIsIdentification/Space.swift:56 | still builds |  |
| ``QualitiesAreFinite`` | ``Structure`` | Sources/VerificationIsIdentification/Space.swift:56 | still builds |  |
| ``CommunicationBounded`` | ``ComparisonsAreBounded`` | Sources/VerificationIsIdentification/Space.swift:61 | still builds |  |
| ``CommunicationBounded`` | ``HasCache`` | Sources/VerificationIsIdentification/Space.swift:61 | still builds |  |
| ``CommunicationBounded`` | ``HasSigma`` | Sources/VerificationIsIdentification/Space.swift:61 | still builds |  |
| ``CommunicationBounded`` | ``Open`` | Sources/VerificationIsIdentification/Space.swift:61 | still builds |  |
| ``CommunicationBounded`` | ``Pair`` | Sources/VerificationIsIdentification/Space.swift:61 | still builds |  |
| ``CommunicationBounded`` | ``Structure`` | Sources/VerificationIsIdentification/Space.swift:61 | still builds |  |
| ``CommunicationBounded`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Space.swift:61 | still builds |  |
| ``DepthIsBounded`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``Decidable`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``HasCache`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``HasCost`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``HasDistance`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``HasEncoding`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``HasGrammar`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``HasSigma`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``HasTime`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``Ignites`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``Matter`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``Open`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``Pair`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``Resistant`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``Structure`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``Tower`` | Sources/VerificationIsIdentification/Space.swift:65 | still builds |  |
| ``EncoderConditions`` | ``BallSaturation`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``CompressionCriterion`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``Decidable`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``HasCache`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``HasCost`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``HasDistance`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``HasEncoding`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``HasSigma`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``HasTime`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``Ignites`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``Matter`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``Open`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``Pair`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``Resistant`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``Structure`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``Tower`` | Sources/VerificationIsIdentification/Spec.swift:33 | still builds |  |
| ``ConditionalSolving`` | ``BallSaturation`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``CompressionCriterion`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``Decidable`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``EncoderConditions`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``HasCache`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``HasCost`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``HasDistance`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``HasEncoding`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``HasSigma`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``HasTime`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``Ignites`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``Matter`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``Open`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``Pair`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``Resistant`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``Structure`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``Tower`` | Sources/VerificationIsIdentification/Spec.swift:45 | still builds |  |
| ``DifficultyIsEncoder`` | ``BallSaturation`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``CompressionCriterion`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``ConditionalSolving`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``Decidable`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``EncoderConditions`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``HasCache`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``HasCost`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``HasDistance`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``HasEncoding`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``HasSigma`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``HasTime`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``Ignites`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``Matter`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``Open`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``Pair`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``Resistant`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``ScopeBoundedByEncoding`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``Structure`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``Tower`` | Sources/VerificationIsIdentification/Spec.swift:53 | still builds |  |
| ``MeasuredGeometry`` | ``AlignmentCoefficient`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``AnchorGraph`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``AxesCoOriented`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``BallSaturation`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``CompressionCriterion`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``Decidable`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``FourthFace`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``GateIsZeroOfLoss`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``HasAlpha`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``HasCache`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``HasCost`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``HasDistance`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``HasSigma`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``HasTime`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``Ignites`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``Matter`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``Null`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``OneBoundaryThreeFaces`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``Open`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``OrderIsOnlyFreedom`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``Pair`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``Resistant`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``SearchableIffClusteredAndAligned`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``SkillsAreBalls`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``StrategyLivesInSigma`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``Structure`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``Tower`` | Sources/VerificationIsIdentification/Spec.swift:68 | still builds |  |
| ``StrategyLivesInSigma`` | ``AxesCoOriented`` | Sources/VerificationIsIdentification/Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``HasCache`` | Sources/VerificationIsIdentification/Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``HasDistance`` | Sources/VerificationIsIdentification/Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``HasSigma`` | Sources/VerificationIsIdentification/Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``Null`` | Sources/VerificationIsIdentification/Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``Open`` | Sources/VerificationIsIdentification/Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``OrderIsOnlyFreedom`` | Sources/VerificationIsIdentification/Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``Pair`` | Sources/VerificationIsIdentification/Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``Structure`` | Sources/VerificationIsIdentification/Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Strategy.swift:23 | still builds |  |
| ``StrategyGate`` | ``AxesCoOriented`` | Sources/VerificationIsIdentification/Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``HasCache`` | Sources/VerificationIsIdentification/Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``HasDistance`` | Sources/VerificationIsIdentification/Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``HasSigma`` | Sources/VerificationIsIdentification/Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``Null`` | Sources/VerificationIsIdentification/Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``Open`` | Sources/VerificationIsIdentification/Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``OrderIsOnlyFreedom`` | Sources/VerificationIsIdentification/Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``Pair`` | Sources/VerificationIsIdentification/Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``StrategyLivesInSigma`` | Sources/VerificationIsIdentification/Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``Structure`` | Sources/VerificationIsIdentification/Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Strategy.swift:30 | still builds |  |
| ``StrategyIsUnique`` | ``AxesCoOriented`` | Sources/VerificationIsIdentification/Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``HasCache`` | Sources/VerificationIsIdentification/Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``HasDistance`` | Sources/VerificationIsIdentification/Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``HasSigma`` | Sources/VerificationIsIdentification/Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``Null`` | Sources/VerificationIsIdentification/Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``Open`` | Sources/VerificationIsIdentification/Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``OrderIsOnlyFreedom`` | Sources/VerificationIsIdentification/Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``Pair`` | Sources/VerificationIsIdentification/Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``StrategyGate`` | Sources/VerificationIsIdentification/Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``StrategyLivesInSigma`` | Sources/VerificationIsIdentification/Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``Structure`` | Sources/VerificationIsIdentification/Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Strategy.swift:36 | still builds |  |
| ``StrategyCrystallizes`` | ``AxesCoOriented`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``Decidable`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``HasCache`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``HasDistance`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``HasSigma`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``Matter`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``Null`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``Open`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``OrderIsOnlyFreedom`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``Pair`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``Resistant`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``StrategyGate`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``StrategyIsUnique`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``StrategyLivesInSigma`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``Structure`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Strategy.swift:46 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``AxesCoOriented`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``Decidable`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``HasCache`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``HasDistance`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``HasSigma`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``Matter`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``Null`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``Open`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``OrderIsOnlyFreedom`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``Pair`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``Resistant`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``StrategyCrystallizes`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``StrategyGate`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``StrategyIsUnique`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``StrategyLivesInSigma`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``Structure`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Strategy.swift:56 | still builds |  |
| ``CompleteEntry`` | ``AxesCoOriented`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``Decidable`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``HasCache`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``HasDistance`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``HasEncoding`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``HasSigma`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``Matter`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``Null`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``Open`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``OrderIsOnlyFreedom`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``Pair`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``PhaseBecomesAmplitude`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``Resistant`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``StrategyCrystallizes`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``StrategyGate`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``StrategyIsUnique`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``StrategyLivesInSigma`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``Structure`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Strategy.swift:63 | still builds |  |
| ``SkillsAreBalls`` | ``AxesCoOriented`` | Sources/VerificationIsIdentification/Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``BallSaturation`` | Sources/VerificationIsIdentification/Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``HasCache`` | Sources/VerificationIsIdentification/Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``HasDistance`` | Sources/VerificationIsIdentification/Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``HasSigma`` | Sources/VerificationIsIdentification/Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``Null`` | Sources/VerificationIsIdentification/Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``Open`` | Sources/VerificationIsIdentification/Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``OrderIsOnlyFreedom`` | Sources/VerificationIsIdentification/Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``Pair`` | Sources/VerificationIsIdentification/Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``StrategyLivesInSigma`` | Sources/VerificationIsIdentification/Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``Structure`` | Sources/VerificationIsIdentification/Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Strategy.swift:70 | still builds |  |
| ``StrategyNavigation`` | ``AnchorGraph`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``AxesCoOriented`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``BallSaturation`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``CompressionCriterion`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``Decidable`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``HasCache`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``HasCost`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``HasDistance`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``HasSigma`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``HasTime`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``Ignites`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``Matter`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``NavigationInevitable`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``Null`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``OneBoundaryThreeFaces`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``Open`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``OrderIsOnlyFreedom`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``Pair`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``Resistant`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``SkillsAreBalls`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``StrategyLivesInSigma`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``Structure`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``Tower`` | Sources/VerificationIsIdentification/Strategy.swift:77 | still builds |  |
| ``FourthFace`` | ``AnchorGraph`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``AxesCoOriented`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``BallSaturation`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``CachePermanent`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``CompressionCriterion`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``Decidable`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``EqualityDecidable`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``ExactlyOneSurvives`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``HasCache`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``HasCost`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``HasDistance`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``HasLibrary`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``HasSaturation`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``HasSigma`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``HasSolutions`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``HasTime`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``IdentityCollapse`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``Ignites`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``KnowledgeAccumulates`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``LibrarySaturates`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``Matter`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``Null`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``OneBoundaryThreeFaces`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``Open`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``OperationsClosed`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``OrderIsOnlyFreedom`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``Pair`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``PassImpliesMembership`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``PassIsIdentification`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``PipelineTotal`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``Resistant`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``ResultDeterministic`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``SkillsAreBalls`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``StepsTerminate`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``StrategyLivesInSigma`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``Structure`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``Tower`` | Sources/VerificationIsIdentification/Strategy.swift:88 | still builds |  |
| ``EncodingInvents`` | ``HasEncoding`` | Sources/VerificationIsIdentification/Voice.swift:20 | still builds |  |
| ``EncodingInvents`` | ``HasSigma`` | Sources/VerificationIsIdentification/Voice.swift:20 | still builds |  |
| ``FaithfulEncoding`` | ``HasEncoding`` | Sources/VerificationIsIdentification/Voice.swift:31 | still builds |  |
| ``FaithfulEncoding`` | ``HasSigma`` | Sources/VerificationIsIdentification/Voice.swift:31 | still builds |  |
| ``InterferenceIsSubstitution`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Wave.swift:19 | still builds |  |
| ``InterferenceIsSubstitution`` | ``HasDistance`` | Sources/VerificationIsIdentification/Wave.swift:19 | still builds |  |
| ``InterferenceIsSubstitution`` | ``HasLaw`` | Sources/VerificationIsIdentification/Wave.swift:19 | still builds |  |
| ``InterferenceIsSubstitution`` | ``HasSigma`` | Sources/VerificationIsIdentification/Wave.swift:19 | still builds |  |
| ``InterferenceIsSubstitution`` | ``Open`` | Sources/VerificationIsIdentification/Wave.swift:19 | still builds |  |
| ``InterferenceIsSubstitution`` | ``Pair`` | Sources/VerificationIsIdentification/Wave.swift:19 | still builds |  |
| ``InterferenceIsSubstitution`` | ``PresentedLaw`` | Sources/VerificationIsIdentification/Wave.swift:19 | still builds |  |
| ``InterferenceIsSubstitution`` | ``Structure`` | Sources/VerificationIsIdentification/Wave.swift:19 | still builds |  |
| ``InterferenceIsSubstitution`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Wave.swift:19 | still builds |  |
| ``DarknessIsNormalForm`` | ``DistanceOnStructures`` | Sources/VerificationIsIdentification/Wave.swift:29 | still builds |  |
| ``DarknessIsNormalForm`` | ``HasDistance`` | Sources/VerificationIsIdentification/Wave.swift:29 | still builds |  |
| ``DarknessIsNormalForm`` | ``HasLaw`` | Sources/VerificationIsIdentification/Wave.swift:29 | still builds |  |
| ``DarknessIsNormalForm`` | ``HasSigma`` | Sources/VerificationIsIdentification/Wave.swift:29 | still builds |  |
| ``DarknessIsNormalForm`` | ``InterferenceIsSubstitution`` | Sources/VerificationIsIdentification/Wave.swift:29 | still builds |  |
| ``DarknessIsNormalForm`` | ``Open`` | Sources/VerificationIsIdentification/Wave.swift:29 | still builds |  |
| ``DarknessIsNormalForm`` | ``Pair`` | Sources/VerificationIsIdentification/Wave.swift:29 | still builds |  |
| ``DarknessIsNormalForm`` | ``PresentedLaw`` | Sources/VerificationIsIdentification/Wave.swift:29 | still builds |  |
| ``DarknessIsNormalForm`` | ``Structure`` | Sources/VerificationIsIdentification/Wave.swift:29 | still builds |  |
| ``DarknessIsNormalForm`` | ``StructuresFinite`` | Sources/VerificationIsIdentification/Wave.swift:29 | still builds |  |

Every file was put back after its cut, and the module builds: true.
