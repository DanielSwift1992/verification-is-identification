# Which premises the build needs

Each claim declares premises, and this page records which of them
the compiler needs: each premise was removed from its declaration,
the module was rebuilt, and the file was put back.

Of 2396 premises the module needs 5. It builds without the other 2184,
and 207 come from a premise the compiler inherits: an inherited premise
is not written on a line of its own, so there is nothing to remove.

Row format: the claim, the premise, the line where the premise is
declared, whether the module builds without it, and, when the build
fails, the symbols the compiler reports. A premise the build does not
need is not therefore redundant: its justification is in the papers.

The premises the module needs:

- ``HasCompositionalNorm`` needs ``HasDistance``, at Basis.swift:27
- ``KnowledgeAccumulates`` needs ``HasLibrary``, at Intelligence.swift:15
- ``Open`` needs ``Structure``, at Primitive.swift:70
- ``Close`` needs ``Structure``, at Primitive.swift:88
- ``Pair`` needs ``Open``, at Primitive.swift:102

<doc:Atlas> ranks these claims by how many others depend on them, and
<doc:AtlasUnfolded> expands every such count into its list.

The premise list comes from the symbol graph the compiler emits, and
tree-sort reads the same file, so the lattice has one reader.
The run took 4158s over the
lattice at revision 95014c7. Rerun it
yourself: `swift build --product Tools && .build/debug/Tools ablate
<symbols.json>`. The build writes the graph file under
`.build/*/extracted-symbols/`.

| claim | premise | declared at | the module without it | what stops compiling |
|---|---|---|---|---|
| ``RulesCompose`` | ``CachePermanent`` | Basis.swift:21 | still builds |  |
| ``RulesCompose`` | ``HasCache`` | Basis.swift:21 | still builds |  |
| ``RulesCompose`` | ``HasLibrary`` | Basis.swift:21 | still builds |  |
| ``RulesCompose`` | ``HasSigma`` | Basis.swift:21 | still builds |  |
| ``RulesCompose`` | ``KnowledgeAccumulates`` | Basis.swift:21 | still builds |  |
| ``RulesCompose`` | ``Open`` | Basis.swift:21 | still builds |  |
| ``RulesCompose`` | ``OperationsClosed`` | Basis.swift:21 | still builds |  |
| ``RulesCompose`` | ``Pair`` | Basis.swift:21 | still builds |  |
| ``RulesCompose`` | ``Structure`` | Basis.swift:21 | still builds |  |
| ``RulesCompose`` | ``StructuresFinite`` | Basis.swift:21 | still builds |  |
| ``HasCompositionalNorm`` | ``HasDistance`` | Basis.swift:27 | fails | Distance |
| ``HasCompositionalNorm`` | ``HasSigma`` | Basis.swift:27 | still builds |  |
| ``AtomBasis`` | ``BasisIsFinite`` | Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``CachePermanent`` | Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``HasBasis`` | Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``HasCache`` | Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``HasCompositionalNorm`` | Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``HasDistance`` | Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``HasLibrary`` | Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``HasSaturation`` | Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``HasSigma`` | Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``KnowledgeAccumulates`` | Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``LibrarySaturates`` | Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``Open`` | Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``OperationsClosed`` | Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``Pair`` | Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``RulesCompose`` | Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``Structure`` | Basis.swift:44 | inherited, no line to cut |  |
| ``AtomBasis`` | ``StructuresFinite`` | Basis.swift:44 | inherited, no line to cut |  |
| ``AtomnessIsTrajectory`` | ``AtomBasis`` | Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``BasisIsFinite`` | Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``CachePermanent`` | Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``HasBasis`` | Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``HasCache`` | Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``HasCompositionalNorm`` | Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``HasDistance`` | Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``HasLibrary`` | Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``HasSaturation`` | Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``HasSigma`` | Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``KnowledgeAccumulates`` | Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``LibrarySaturates`` | Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``NoInverse`` | Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``Open`` | Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``OperationsClosed`` | Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``Pair`` | Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``RulesCompose`` | Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``Structure`` | Basis.swift:53 | still builds |  |
| ``AtomnessIsTrajectory`` | ``StructuresFinite`` | Basis.swift:53 | still builds |  |
| ``ColourIsQuotient`` | ``EncodingForgets`` | Colour.swift:16 | still builds |  |
| ``ColourIsQuotient`` | ``HasEncoding`` | Colour.swift:16 | still builds |  |
| ``ColourIsQuotient`` | ``HasSigma`` | Colour.swift:16 | still builds |  |
| ``GamutIsCone`` | ``ColourIsQuotient`` | Colour.swift:27 | still builds |  |
| ``GamutIsCone`` | ``EncodingForgets`` | Colour.swift:27 | still builds |  |
| ``GamutIsCone`` | ``HasEncoding`` | Colour.swift:27 | still builds |  |
| ``GamutIsCone`` | ``HasSigma`` | Colour.swift:27 | still builds |  |
| ``Unique`` | ``Monotone`` | Core.swift:25 | still builds |  |
| ``Unique`` | ``Null`` | Core.swift:25 | still builds |  |
| ``Unique`` | ``Open`` | Core.swift:25 | still builds |  |
| ``Unique`` | ``Pair`` | Core.swift:25 | still builds |  |
| ``Unique`` | ``Structure`` | Core.swift:25 | still builds |  |
| ``Permanent`` | ``Open`` | Core.swift:32 | inherited, no line to cut |  |
| ``Permanent`` | ``Pair`` | Core.swift:32 | inherited, no line to cut |  |
| ``Permanent`` | ``Structure`` | Core.swift:32 | inherited, no line to cut |  |
| ``Monotone`` | ``Open`` | Core.swift:40 | inherited, no line to cut |  |
| ``Monotone`` | ``Pair`` | Core.swift:40 | inherited, no line to cut |  |
| ``Monotone`` | ``Structure`` | Core.swift:40 | inherited, no line to cut |  |
| ``Decidable`` | ``Open`` | Core.swift:47 | inherited, no line to cut |  |
| ``Decidable`` | ``Pair`` | Core.swift:47 | inherited, no line to cut |  |
| ``Decidable`` | ``Structure`` | Core.swift:47 | inherited, no line to cut |  |
| ``MetricProperty`` | ``Open`` | Core.swift:55 | inherited, no line to cut |  |
| ``MetricProperty`` | ``Pair`` | Core.swift:55 | inherited, no line to cut |  |
| ``MetricProperty`` | ``Structure`` | Core.swift:55 | inherited, no line to cut |  |
| ``IntegerValued`` | ``Open`` | Core.swift:64 | inherited, no line to cut |  |
| ``IntegerValued`` | ``Pair`` | Core.swift:64 | inherited, no line to cut |  |
| ``IntegerValued`` | ``Structure`` | Core.swift:64 | inherited, no line to cut |  |
| ``Measurable`` | ``Open`` | Core.swift:71 | inherited, no line to cut |  |
| ``Measurable`` | ``Pair`` | Core.swift:71 | inherited, no line to cut |  |
| ``Measurable`` | ``Structure`` | Core.swift:71 | inherited, no line to cut |  |
| ``HasSolutions`` | ``HasSigma`` | Core.swift:111 | still builds |  |
| ``HasLibrary`` | ``HasSigma`` | Core.swift:119 | still builds |  |
| ``HasCache`` | ``HasSigma`` | Core.swift:127 | still builds |  |
| ``HasDistance`` | ``HasSigma`` | Core.swift:136 | still builds |  |
| ``HasEncoding`` | ``HasSigma`` | Core.swift:144 | still builds |  |
| ``HasAlpha`` | ``HasDistance`` | Core.swift:153 | still builds |  |
| ``HasAlpha`` | ``HasSigma`` | Core.swift:153 | still builds |  |
| ``HasBasis`` | ``HasLibrary`` | Core.swift:162 | still builds |  |
| ``HasBasis`` | ``HasSigma`` | Core.swift:162 | still builds |  |
| ``HasSaturation`` | ``HasLibrary`` | Core.swift:171 | still builds |  |
| ``HasSaturation`` | ``HasSigma`` | Core.swift:171 | still builds |  |
| ``IdentityCollapse`` | ``HasSigma`` | Core.swift:196 | inherited, no line to cut |  |
| ``IdentityCollapse`` | ``HasSolutions`` | Core.swift:196 | inherited, no line to cut |  |
| ``IdentityCollapse`` | ``Null`` | Core.swift:196 | inherited, no line to cut |  |
| ``IdentityCollapse`` | ``Open`` | Core.swift:196 | inherited, no line to cut |  |
| ``IdentityCollapse`` | ``Pair`` | Core.swift:196 | inherited, no line to cut |  |
| ``IdentityCollapse`` | ``Structure`` | Core.swift:196 | inherited, no line to cut |  |
| ``HasLaw`` | ``HasSigma`` | Dynamics.swift:21 | still builds |  |
| ``LawLivesInSigma`` | ``DistanceOnStructures`` | Dynamics.swift:31 | still builds |  |
| ``LawLivesInSigma`` | ``HasDistance`` | Dynamics.swift:31 | still builds |  |
| ``LawLivesInSigma`` | ``HasLaw`` | Dynamics.swift:31 | still builds |  |
| ``LawLivesInSigma`` | ``HasSigma`` | Dynamics.swift:31 | still builds |  |
| ``LawLivesInSigma`` | ``Open`` | Dynamics.swift:31 | still builds |  |
| ``LawLivesInSigma`` | ``Pair`` | Dynamics.swift:31 | still builds |  |
| ``LawLivesInSigma`` | ``Structure`` | Dynamics.swift:31 | still builds |  |
| ``LawLivesInSigma`` | ``StructuresFinite`` | Dynamics.swift:31 | still builds |  |
| ``LawIsTarget`` | ``DistanceOnStructures`` | Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``EqualityDecidable`` | Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``ExactlyOneSurvives`` | Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``HasDistance`` | Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``HasLaw`` | Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``HasSigma`` | Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``HasSolutions`` | Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``LawLivesInSigma`` | Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``Open`` | Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``OperationsClosed`` | Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``Pair`` | Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``PassImpliesMembership`` | Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``PassIsIdentification`` | Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``PipelineTotal`` | Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``ResultDeterministic`` | Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``StepsTerminate`` | Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``Structure`` | Dynamics.swift:41 | still builds |  |
| ``LawIsTarget`` | ``StructuresFinite`` | Dynamics.swift:41 | still builds |  |
| ``AmbiguityIsExperiment`` | ``AnchorGraph`` | Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``Decidable`` | Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``DistanceOnStructures`` | Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``EqualityDecidable`` | Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``ExactlyOneSurvives`` | Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``HasDistance`` | Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``HasLaw`` | Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``HasLibrary`` | Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``HasSigma`` | Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``HasSolutions`` | Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``HolesCarryAddresses`` | Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``LawIsTarget`` | Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``LawLivesInSigma`` | Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``Open`` | Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``OperationsClosed`` | Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``Pair`` | Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``PassImpliesMembership`` | Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``PassIsIdentification`` | Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``PipelineTotal`` | Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``ResultDeterministic`` | Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``StepsTerminate`` | Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``Structure`` | Dynamics.swift:47 | still builds |  |
| ``AmbiguityIsExperiment`` | ``StructuresFinite`` | Dynamics.swift:47 | still builds |  |
| ``BehaviorIsStructure`` | ``DistanceOnStructures`` | Dynamics.swift:53 | still builds |  |
| ``BehaviorIsStructure`` | ``HasDistance`` | Dynamics.swift:53 | still builds |  |
| ``BehaviorIsStructure`` | ``HasSigma`` | Dynamics.swift:53 | still builds |  |
| ``BehaviorIsStructure`` | ``HasTime`` | Dynamics.swift:53 | still builds |  |
| ``BehaviorIsStructure`` | ``Open`` | Dynamics.swift:53 | still builds |  |
| ``BehaviorIsStructure`` | ``Pair`` | Dynamics.swift:53 | still builds |  |
| ``BehaviorIsStructure`` | ``Structure`` | Dynamics.swift:53 | still builds |  |
| ``BehaviorIsStructure`` | ``StructuresFinite`` | Dynamics.swift:53 | still builds |  |
| ``PlanningIsNavigation`` | ``AnchorGraph`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``BallSaturation`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``CachePermanent`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``CompressionCriterion`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``Decidable`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``DistanceOnStructures`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``EqualityDecidable`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``ExactlyOneSurvives`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``HasCache`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``HasCost`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``HasDistance`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``HasLaw`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``HasLibrary`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``HasSaturation`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``HasSigma`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``HasSolutions`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``HasTime`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``Ignites`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``KnowledgeAccumulates`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``LawIsTarget`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``LawLivesInSigma`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``LibrarySaturates`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``Matter`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``NavigationInevitable`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``OneBoundaryThreeFaces`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``Open`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``OperationsClosed`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``Pair`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``PassImpliesMembership`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``PassIsIdentification`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``PipelineTotal`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``Resistant`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``ResultDeterministic`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``StepsTerminate`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``Structure`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``StructuresFinite`` | Dynamics.swift:65 | still builds |  |
| ``PlanningIsNavigation`` | ``Tower`` | Dynamics.swift:65 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``AnchorGraph`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``AxesCoOriented`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``BallSaturation`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``CachePermanent`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``CompressionCriterion`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``Decidable`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``DistanceOnStructures`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``EqualityDecidable`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``ExactlyOneSurvives`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``HasCache`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``HasCost`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``HasDistance`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``HasLaw`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``HasLibrary`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``HasSaturation`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``HasSigma`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``HasSolutions`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``HasTime`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``IdentityCollapse`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``Ignites`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``KnowledgeAccumulates`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``LawIsTarget`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``LawLivesInSigma`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``LibrarySaturates`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``Matter`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``NavigationInevitable`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``Null`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``OneBoundaryThreeFaces`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``Open`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``OperationsClosed`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``OrderIsOnlyFreedom`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``Pair`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``PassImpliesMembership`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``PassIsIdentification`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``PipelineTotal`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``PlanningIsNavigation`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``Resistant`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``ResultDeterministic`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``SkillsAreBalls`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``StepsTerminate`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``StrategyLivesInSigma`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``Structure`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``StructuresFinite`` | Dynamics.swift:72 | still builds |  |
| ``MotorSkillsAreStrategies`` | ``Tower`` | Dynamics.swift:72 | still builds |  |
| ``InteractiveDecomposition`` | ``AmbiguityIsExperiment`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``AnchorGraph`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``AxesCoOriented`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``BallSaturation`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``CachePermanent`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``CompressionCriterion`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``Decidable`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``DistanceOnStructures`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``EqualityDecidable`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``ExactlyOneSurvives`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``HasCache`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``HasCost`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``HasDistance`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``HasLaw`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``HasLibrary`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``HasSaturation`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``HasSigma`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``HasSolutions`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``HasTime`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``HolesCarryAddresses`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``IdentityCollapse`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``Ignites`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``KnowledgeAccumulates`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``LawIsTarget`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``LawLivesInSigma`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``LibrarySaturates`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``Matter`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``MotorSkillsAreStrategies`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``NavigationInevitable`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``Null`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``OneBoundaryThreeFaces`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``Open`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``OperationsClosed`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``OrderIsOnlyFreedom`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``Pair`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``PassImpliesMembership`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``PassIsIdentification`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``PipelineTotal`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``PlanningIsNavigation`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``Resistant`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``ResultDeterministic`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``SkillsAreBalls`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``StepsTerminate`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``StrategyLivesInSigma`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``Structure`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``StructuresFinite`` | Dynamics.swift:79 | still builds |  |
| ``InteractiveDecomposition`` | ``Tower`` | Dynamics.swift:79 | still builds |  |
| ``LawfulDrift`` | ``CachePermanent`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``Decidable`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``DistanceOnStructures`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``EqualityDecidable`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``ExactlyOneSurvives`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``HasCache`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``HasCost`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``HasDistance`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``HasLaw`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``HasLibrary`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``HasSaturation`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``HasSigma`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``HasSolutions`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``HasTime`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``Ignites`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``KnowledgeAccumulates`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``LawIsTarget`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``LawLivesInSigma`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``LibrarySaturates`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``Matter`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``Open`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``OperationsClosed`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``Pair`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``PassImpliesMembership`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``PassIsIdentification`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``PipelineTotal`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``Resistant`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``ResultDeterministic`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``StepsTerminate`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``Structure`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``StructuresFinite`` | Dynamics.swift:86 | still builds |  |
| ``LawfulDrift`` | ``Tower`` | Dynamics.swift:86 | still builds |  |
| ``HasGauge`` | ``HasSigma`` | Gauge.swift:30 | still builds |  |
| ``ContentIsGaugeInvariant`` | ``HasEncoding`` | Gauge.swift:40 | still builds |  |
| ``ContentIsGaugeInvariant`` | ``HasGauge`` | Gauge.swift:40 | still builds |  |
| ``ContentIsGaugeInvariant`` | ``HasSigma`` | Gauge.swift:40 | still builds |  |
| ``ContentIsGaugeInvariant`` | ``Measurable`` | Gauge.swift:40 | still builds |  |
| ``ContentIsGaugeInvariant`` | ``Open`` | Gauge.swift:40 | still builds |  |
| ``ContentIsGaugeInvariant`` | ``OperationsClosed`` | Gauge.swift:40 | still builds |  |
| ``ContentIsGaugeInvariant`` | ``Pair`` | Gauge.swift:40 | still builds |  |
| ``ContentIsGaugeInvariant`` | ``RevealsNotCreates`` | Gauge.swift:40 | still builds |  |
| ``ContentIsGaugeInvariant`` | ``Structure`` | Gauge.swift:40 | still builds |  |
| ``CostReadsGauge`` | ``HasDistance`` | Gauge.swift:48 | still builds |  |
| ``CostReadsGauge`` | ``HasGauge`` | Gauge.swift:48 | still builds |  |
| ``CostReadsGauge`` | ``HasSigma`` | Gauge.swift:48 | still builds |  |
| ``GaugeFixing`` | ``CachePermanent`` | Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``CandidatesOnlyLeave`` | Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``CostReadsGauge`` | Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``EqualityDecidable`` | Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``HasCache`` | Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``HasDistance`` | Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``HasGauge`` | Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``HasSigma`` | Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``HasSolutions`` | Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``MembershipDecidable`` | Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``Open`` | Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``OperationsClosed`` | Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``Pair`` | Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``ResultsIrreversible`` | Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``Structure`` | Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``StructuresFinite`` | Gauge.swift:59 | still builds |  |
| ``GaugeFixing`` | ``SystemCrystallizes`` | Gauge.swift:59 | still builds |  |
| ``LinearArbiter`` | ``CostIsPathLength`` | Gauge.swift:67 | still builds |  |
| ``LinearArbiter`` | ``HasDistance`` | Gauge.swift:67 | still builds |  |
| ``LinearArbiter`` | ``HasPath`` | Gauge.swift:67 | still builds |  |
| ``LinearArbiter`` | ``HasSigma`` | Gauge.swift:67 | still builds |  |
| ``GaugeCollapse`` | ``ContentIsGaugeInvariant`` | Gauge.swift:76 | still builds |  |
| ``GaugeCollapse`` | ``CostIsPathLength`` | Gauge.swift:76 | still builds |  |
| ``GaugeCollapse`` | ``HasDistance`` | Gauge.swift:76 | still builds |  |
| ``GaugeCollapse`` | ``HasEncoding`` | Gauge.swift:76 | still builds |  |
| ``GaugeCollapse`` | ``HasGauge`` | Gauge.swift:76 | still builds |  |
| ``GaugeCollapse`` | ``HasPath`` | Gauge.swift:76 | still builds |  |
| ``GaugeCollapse`` | ``HasSigma`` | Gauge.swift:76 | still builds |  |
| ``GaugeCollapse`` | ``LinearArbiter`` | Gauge.swift:76 | still builds |  |
| ``GaugeCollapse`` | ``Measurable`` | Gauge.swift:76 | still builds |  |
| ``GaugeCollapse`` | ``Open`` | Gauge.swift:76 | still builds |  |
| ``GaugeCollapse`` | ``OperationsClosed`` | Gauge.swift:76 | still builds |  |
| ``GaugeCollapse`` | ``Pair`` | Gauge.swift:76 | still builds |  |
| ``GaugeCollapse`` | ``RevealsNotCreates`` | Gauge.swift:76 | still builds |  |
| ``GaugeCollapse`` | ``Structure`` | Gauge.swift:76 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``AxesCoOriented`` | Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``CachePermanent`` | Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``HasCache`` | Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``HasSigma`` | Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``HasSolutions`` | Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``IdentityCollapse`` | Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``Null`` | Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``Open`` | Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``OperationsClosed`` | Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``OrderIsOnlyFreedom`` | Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``Pair`` | Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``PassImpliesMembership`` | Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``PipelineTotal`` | Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``ResultDeterministic`` | Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``StepsTerminate`` | Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``Structure`` | Generation.swift:28 | still builds |  |
| ``DiscriminatorAndGenerator`` | ``StructuresFinite`` | Generation.swift:28 | still builds |  |
| ``OrthogonalOrgans`` | ``AlignmentCoefficient`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``AnchorGraph`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``AxesCoOriented`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``BallSaturation`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``CachePermanent`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``CompressionCriterion`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``Decidable`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``DiscriminatorAndGenerator`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``DistanceOnStructures`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``EqualityDecidable`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``ExactlyOneSurvives`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``GateIsZeroOfLoss`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``HasAlpha`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``HasCache`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``HasCost`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``HasDistance`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``HasLibrary`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``HasSaturation`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``HasSigma`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``HasSolutions`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``HasTime`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``IdentityCollapse`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``Ignites`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``KnowledgeAccumulates`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``LibrarySaturates`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``Matter`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``Null`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``OneBoundaryThreeFaces`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``Open`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``OperationsClosed`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``OrderIsOnlyFreedom`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``Pair`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``PassImpliesMembership`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``PassIsIdentification`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``PipelineTotal`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``Resistant`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``ResultDeterministic`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``SearchableIffClusteredAndAligned`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``StepsTerminate`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``Structure`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``StructuresFinite`` | Generation.swift:36 | still builds |  |
| ``OrthogonalOrgans`` | ``Tower`` | Generation.swift:36 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``AlignmentCoefficient`` | Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``AxesCoOriented`` | Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``CachePermanent`` | Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``DiscriminatorAndGenerator`` | Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``DistanceOnStructures`` | Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``GateIsZeroOfLoss`` | Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``HasAlpha`` | Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``HasCache`` | Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``HasDistance`` | Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``HasEfficiency`` | Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``HasLibrary`` | Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``HasSaturation`` | Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``HasSigma`` | Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``HasSolutions`` | Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``IdentityCollapse`` | Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``IntelligenceRises`` | Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``LibrarySaturates`` | Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``Null`` | Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``Open`` | Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``OperationsClosed`` | Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``OrderIsOnlyFreedom`` | Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``Pair`` | Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``PassImpliesMembership`` | Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``PipelineTotal`` | Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``ResultDeterministic`` | Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``StepsTerminate`` | Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``Structure`` | Generation.swift:50 | still builds |  |
| ``InevitabilityIsDiscriminator`` | ``StructuresFinite`` | Generation.swift:50 | still builds |  |
| ``OrgansAreOneCompare`` | ``AxesCoOriented`` | Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``CachePermanent`` | Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``Decidable`` | Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``DiscriminatorAndGenerator`` | Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``HasCache`` | Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``HasSigma`` | Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``HasSolutions`` | Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``IdentityCollapse`` | Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``Null`` | Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``Open`` | Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``OperationsClosed`` | Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``OrderIsOnlyFreedom`` | Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``Pair`` | Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``PassImpliesMembership`` | Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``PipelineTotal`` | Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``ResultDeterministic`` | Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``StepsTerminate`` | Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``Structure`` | Generation.swift:57 | still builds |  |
| ``OrgansAreOneCompare`` | ``StructuresFinite`` | Generation.swift:57 | still builds |  |
| ``DistanceOnStructures`` | ``HasDistance`` | Gradient.swift:26 | inherited, no line to cut |  |
| ``DistanceOnStructures`` | ``HasSigma`` | Gradient.swift:26 | inherited, no line to cut |  |
| ``DistanceOnStructures`` | ``Open`` | Gradient.swift:26 | inherited, no line to cut |  |
| ``DistanceOnStructures`` | ``Pair`` | Gradient.swift:26 | inherited, no line to cut |  |
| ``DistanceOnStructures`` | ``Structure`` | Gradient.swift:26 | inherited, no line to cut |  |
| ``DistanceOnStructures`` | ``StructuresFinite`` | Gradient.swift:26 | inherited, no line to cut |  |
| ``DistanceIsCost`` | ``DistanceOnStructures`` | Gradient.swift:33 | inherited, no line to cut |  |
| ``DistanceIsCost`` | ``HasCost`` | Gradient.swift:33 | inherited, no line to cut |  |
| ``DistanceIsCost`` | ``HasDistance`` | Gradient.swift:33 | inherited, no line to cut |  |
| ``DistanceIsCost`` | ``HasSigma`` | Gradient.swift:33 | inherited, no line to cut |  |
| ``DistanceIsCost`` | ``Open`` | Gradient.swift:33 | inherited, no line to cut |  |
| ``DistanceIsCost`` | ``Pair`` | Gradient.swift:33 | inherited, no line to cut |  |
| ``DistanceIsCost`` | ``Structure`` | Gradient.swift:33 | inherited, no line to cut |  |
| ``DistanceIsCost`` | ``StructuresFinite`` | Gradient.swift:33 | inherited, no line to cut |  |
| ``NullIsOrigin`` | ``DistanceOnStructures`` | Gradient.swift:40 | still builds |  |
| ``NullIsOrigin`` | ``HasDistance`` | Gradient.swift:40 | still builds |  |
| ``NullIsOrigin`` | ``HasSigma`` | Gradient.swift:40 | still builds |  |
| ``NullIsOrigin`` | ``Null`` | Gradient.swift:40 | still builds |  |
| ``NullIsOrigin`` | ``Open`` | Gradient.swift:40 | still builds |  |
| ``NullIsOrigin`` | ``Pair`` | Gradient.swift:40 | still builds |  |
| ``NullIsOrigin`` | ``Structure`` | Gradient.swift:40 | still builds |  |
| ``NullIsOrigin`` | ``StructuresFinite`` | Gradient.swift:40 | still builds |  |
| ``GradientInComparison`` | ``Decidable`` | Gradient.swift:47 | still builds |  |
| ``GradientInComparison`` | ``DistanceOnStructures`` | Gradient.swift:47 | still builds |  |
| ``GradientInComparison`` | ``HasDistance`` | Gradient.swift:47 | still builds |  |
| ``GradientInComparison`` | ``HasSigma`` | Gradient.swift:47 | still builds |  |
| ``GradientInComparison`` | ``Open`` | Gradient.swift:47 | still builds |  |
| ``GradientInComparison`` | ``Pair`` | Gradient.swift:47 | still builds |  |
| ``GradientInComparison`` | ``Structure`` | Gradient.swift:47 | still builds |  |
| ``GradientInComparison`` | ``StructuresFinite`` | Gradient.swift:47 | still builds |  |
| ``OrderByDistance`` | ``AxesCoOriented`` | Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``CachePermanent`` | Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``DistanceOnStructures`` | Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``HasCache`` | Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``HasDistance`` | Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``HasSigma`` | Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``HasSolutions`` | Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``IdentityCollapse`` | Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``Null`` | Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``Open`` | Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``OperationsClosed`` | Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``OrderIsOnlyFreedom`` | Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``Pair`` | Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``ResultDeterministic`` | Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``Structure`` | Gradient.swift:53 | still builds |  |
| ``OrderByDistance`` | ``StructuresFinite`` | Gradient.swift:53 | still builds |  |
| ``GateIsZeroOfLoss`` | ``DistanceOnStructures`` | Gradient.swift:59 | still builds |  |
| ``GateIsZeroOfLoss`` | ``HasDistance`` | Gradient.swift:59 | still builds |  |
| ``GateIsZeroOfLoss`` | ``HasSigma`` | Gradient.swift:59 | still builds |  |
| ``GateIsZeroOfLoss`` | ``Open`` | Gradient.swift:59 | still builds |  |
| ``GateIsZeroOfLoss`` | ``OperationsClosed`` | Gradient.swift:59 | still builds |  |
| ``GateIsZeroOfLoss`` | ``Pair`` | Gradient.swift:59 | still builds |  |
| ``GateIsZeroOfLoss`` | ``PassImpliesMembership`` | Gradient.swift:59 | still builds |  |
| ``GateIsZeroOfLoss`` | ``PipelineTotal`` | Gradient.swift:59 | still builds |  |
| ``GateIsZeroOfLoss`` | ``ResultDeterministic`` | Gradient.swift:59 | still builds |  |
| ``GateIsZeroOfLoss`` | ``StepsTerminate`` | Gradient.swift:59 | still builds |  |
| ``GateIsZeroOfLoss`` | ``Structure`` | Gradient.swift:59 | still builds |  |
| ``GateIsZeroOfLoss`` | ``StructuresFinite`` | Gradient.swift:59 | still builds |  |
| ``BallSaturation`` | ``CachePermanent`` | Gradient.swift:66 | still builds |  |
| ``BallSaturation`` | ``DistanceOnStructures`` | Gradient.swift:66 | still builds |  |
| ``BallSaturation`` | ``HasCache`` | Gradient.swift:66 | still builds |  |
| ``BallSaturation`` | ``HasDistance`` | Gradient.swift:66 | still builds |  |
| ``BallSaturation`` | ``HasLibrary`` | Gradient.swift:66 | still builds |  |
| ``BallSaturation`` | ``HasSaturation`` | Gradient.swift:66 | still builds |  |
| ``BallSaturation`` | ``HasSigma`` | Gradient.swift:66 | still builds |  |
| ``BallSaturation`` | ``LibrarySaturates`` | Gradient.swift:66 | still builds |  |
| ``BallSaturation`` | ``Open`` | Gradient.swift:66 | still builds |  |
| ``BallSaturation`` | ``OperationsClosed`` | Gradient.swift:66 | still builds |  |
| ``BallSaturation`` | ``Pair`` | Gradient.swift:66 | still builds |  |
| ``BallSaturation`` | ``Structure`` | Gradient.swift:66 | still builds |  |
| ``BallSaturation`` | ``StructuresFinite`` | Gradient.swift:66 | still builds |  |
| ``CompressionCriterion`` | ``CachePermanent`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``Decidable`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``DistanceOnStructures`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``EqualityDecidable`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``ExactlyOneSurvives`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``HasCache`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``HasCost`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``HasDistance`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``HasLibrary`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``HasSaturation`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``HasSigma`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``HasSolutions`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``HasTime`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``Ignites`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``KnowledgeAccumulates`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``LibrarySaturates`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``Matter`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``Open`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``OperationsClosed`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``Pair`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``PassImpliesMembership`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``PassIsIdentification`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``PipelineTotal`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``Resistant`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``ResultDeterministic`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``StepsTerminate`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``Structure`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``StructuresFinite`` | Gradient.swift:73 | still builds |  |
| ``CompressionCriterion`` | ``Tower`` | Gradient.swift:73 | still builds |  |
| ``ResistanceHasMagnitude`` | ``Decidable`` | Gradient.swift:80 | still builds |  |
| ``ResistanceHasMagnitude`` | ``DistanceOnStructures`` | Gradient.swift:80 | still builds |  |
| ``ResistanceHasMagnitude`` | ``HasDistance`` | Gradient.swift:80 | still builds |  |
| ``ResistanceHasMagnitude`` | ``HasSigma`` | Gradient.swift:80 | still builds |  |
| ``ResistanceHasMagnitude`` | ``Open`` | Gradient.swift:80 | still builds |  |
| ``ResistanceHasMagnitude`` | ``Pair`` | Gradient.swift:80 | still builds |  |
| ``ResistanceHasMagnitude`` | ``Resistant`` | Gradient.swift:80 | still builds |  |
| ``ResistanceHasMagnitude`` | ``Structure`` | Gradient.swift:80 | still builds |  |
| ``ResistanceHasMagnitude`` | ``StructuresFinite`` | Gradient.swift:80 | still builds |  |
| ``StructuresFinite`` | ``HasSigma`` | Identification.swift:27 | still builds |  |
| ``StructuresFinite`` | ``Open`` | Identification.swift:27 | still builds |  |
| ``StructuresFinite`` | ``Pair`` | Identification.swift:27 | still builds |  |
| ``StructuresFinite`` | ``Structure`` | Identification.swift:27 | still builds |  |
| ``OperationsClosed`` | ``Open`` | Identification.swift:33 | inherited, no line to cut |  |
| ``OperationsClosed`` | ``Pair`` | Identification.swift:33 | inherited, no line to cut |  |
| ``OperationsClosed`` | ``Structure`` | Identification.swift:33 | inherited, no line to cut |  |
| ``EqualityDecidable`` | ``HasSigma`` | Identification.swift:45 | still builds |  |
| ``EqualityDecidable`` | ``Open`` | Identification.swift:45 | still builds |  |
| ``EqualityDecidable`` | ``Pair`` | Identification.swift:45 | still builds |  |
| ``EqualityDecidable`` | ``Structure`` | Identification.swift:45 | still builds |  |
| ``EqualityDecidable`` | ``StructuresFinite`` | Identification.swift:45 | still builds |  |
| ``CachePermanent`` | ``HasCache`` | Identification.swift:56 | inherited, no line to cut |  |
| ``CachePermanent`` | ``HasSigma`` | Identification.swift:56 | inherited, no line to cut |  |
| ``CachePermanent`` | ``Open`` | Identification.swift:56 | inherited, no line to cut |  |
| ``CachePermanent`` | ``OperationsClosed`` | Identification.swift:56 | inherited, no line to cut |  |
| ``CachePermanent`` | ``Pair`` | Identification.swift:56 | inherited, no line to cut |  |
| ``CachePermanent`` | ``Structure`` | Identification.swift:56 | inherited, no line to cut |  |
| ``CachePermanent`` | ``StructuresFinite`` | Identification.swift:56 | inherited, no line to cut |  |
| ``StepsTerminate`` | ``HasSigma`` | Identification.swift:66 | still builds |  |
| ``StepsTerminate`` | ``Open`` | Identification.swift:66 | still builds |  |
| ``StepsTerminate`` | ``Pair`` | Identification.swift:66 | still builds |  |
| ``StepsTerminate`` | ``Structure`` | Identification.swift:66 | still builds |  |
| ``StepsTerminate`` | ``StructuresFinite`` | Identification.swift:66 | still builds |  |
| ``PipelineTotal`` | ``HasSigma`` | Identification.swift:73 | still builds |  |
| ``PipelineTotal`` | ``Open`` | Identification.swift:73 | still builds |  |
| ``PipelineTotal`` | ``Pair`` | Identification.swift:73 | still builds |  |
| ``PipelineTotal`` | ``StepsTerminate`` | Identification.swift:73 | still builds |  |
| ``PipelineTotal`` | ``Structure`` | Identification.swift:73 | still builds |  |
| ``PipelineTotal`` | ``StructuresFinite`` | Identification.swift:73 | still builds |  |
| ``ResultDeterministic`` | ``Open`` | Identification.swift:81 | still builds |  |
| ``ResultDeterministic`` | ``OperationsClosed`` | Identification.swift:81 | still builds |  |
| ``ResultDeterministic`` | ``Pair`` | Identification.swift:81 | still builds |  |
| ``ResultDeterministic`` | ``Structure`` | Identification.swift:81 | still builds |  |
| ``CacheOnlyGrows`` | ``CachePermanent`` | Identification.swift:91 | still builds |  |
| ``CacheOnlyGrows`` | ``HasCache`` | Identification.swift:91 | still builds |  |
| ``CacheOnlyGrows`` | ``HasSigma`` | Identification.swift:91 | still builds |  |
| ``CacheOnlyGrows`` | ``Open`` | Identification.swift:91 | still builds |  |
| ``CacheOnlyGrows`` | ``OperationsClosed`` | Identification.swift:91 | still builds |  |
| ``CacheOnlyGrows`` | ``Pair`` | Identification.swift:91 | still builds |  |
| ``CacheOnlyGrows`` | ``StepsTerminate`` | Identification.swift:91 | still builds |  |
| ``CacheOnlyGrows`` | ``Structure`` | Identification.swift:91 | still builds |  |
| ``CacheOnlyGrows`` | ``StructuresFinite`` | Identification.swift:91 | still builds |  |
| ``DiagnosticsAccumulate`` | ``CachePermanent`` | Identification.swift:96 | still builds |  |
| ``DiagnosticsAccumulate`` | ``HasCache`` | Identification.swift:96 | still builds |  |
| ``DiagnosticsAccumulate`` | ``HasSigma`` | Identification.swift:96 | still builds |  |
| ``DiagnosticsAccumulate`` | ``Open`` | Identification.swift:96 | still builds |  |
| ``DiagnosticsAccumulate`` | ``OperationsClosed`` | Identification.swift:96 | still builds |  |
| ``DiagnosticsAccumulate`` | ``Pair`` | Identification.swift:96 | still builds |  |
| ``DiagnosticsAccumulate`` | ``ResultDeterministic`` | Identification.swift:96 | still builds |  |
| ``DiagnosticsAccumulate`` | ``Structure`` | Identification.swift:96 | still builds |  |
| ``DiagnosticsAccumulate`` | ``StructuresFinite`` | Identification.swift:96 | still builds |  |
| ``CandidatesOnlyLeave`` | ``CachePermanent`` | Identification.swift:103 | inherited, no line to cut |  |
| ``CandidatesOnlyLeave`` | ``HasCache`` | Identification.swift:103 | inherited, no line to cut |  |
| ``CandidatesOnlyLeave`` | ``HasSigma`` | Identification.swift:103 | inherited, no line to cut |  |
| ``CandidatesOnlyLeave`` | ``HasSolutions`` | Identification.swift:103 | inherited, no line to cut |  |
| ``CandidatesOnlyLeave`` | ``Open`` | Identification.swift:103 | inherited, no line to cut |  |
| ``CandidatesOnlyLeave`` | ``OperationsClosed`` | Identification.swift:103 | inherited, no line to cut |  |
| ``CandidatesOnlyLeave`` | ``Pair`` | Identification.swift:103 | inherited, no line to cut |  |
| ``CandidatesOnlyLeave`` | ``Structure`` | Identification.swift:103 | inherited, no line to cut |  |
| ``CandidatesOnlyLeave`` | ``StructuresFinite`` | Identification.swift:103 | inherited, no line to cut |  |
| ``NoSelfReference`` | ``Open`` | Identification.swift:117 | still builds |  |
| ``NoSelfReference`` | ``OperationsClosed`` | Identification.swift:117 | still builds |  |
| ``NoSelfReference`` | ``Pair`` | Identification.swift:117 | still builds |  |
| ``NoSelfReference`` | ``Structure`` | Identification.swift:117 | still builds |  |
| ``ScopeBoundedByEncoding`` | ``Open`` | Identification.swift:124 | still builds |  |
| ``ScopeBoundedByEncoding`` | ``OperationsClosed`` | Identification.swift:124 | still builds |  |
| ``ScopeBoundedByEncoding`` | ``Pair`` | Identification.swift:124 | still builds |  |
| ``ScopeBoundedByEncoding`` | ``ResultDeterministic`` | Identification.swift:124 | still builds |  |
| ``ScopeBoundedByEncoding`` | ``Structure`` | Identification.swift:124 | still builds |  |
| ``ExactlyOneSurvives`` | ``EqualityDecidable`` | Identification.swift:136 | inherited, no line to cut |  |
| ``ExactlyOneSurvives`` | ``HasSigma`` | Identification.swift:136 | inherited, no line to cut |  |
| ``ExactlyOneSurvives`` | ``HasSolutions`` | Identification.swift:136 | inherited, no line to cut |  |
| ``ExactlyOneSurvives`` | ``Open`` | Identification.swift:136 | inherited, no line to cut |  |
| ``ExactlyOneSurvives`` | ``Pair`` | Identification.swift:136 | inherited, no line to cut |  |
| ``ExactlyOneSurvives`` | ``Structure`` | Identification.swift:136 | inherited, no line to cut |  |
| ``ExactlyOneSurvives`` | ``StructuresFinite`` | Identification.swift:136 | inherited, no line to cut |  |
| ``PassImpliesMembership`` | ``HasSigma`` | Identification.swift:146 | still builds |  |
| ``PassImpliesMembership`` | ``Open`` | Identification.swift:146 | still builds |  |
| ``PassImpliesMembership`` | ``OperationsClosed`` | Identification.swift:146 | still builds |  |
| ``PassImpliesMembership`` | ``Pair`` | Identification.swift:146 | still builds |  |
| ``PassImpliesMembership`` | ``PipelineTotal`` | Identification.swift:146 | still builds |  |
| ``PassImpliesMembership`` | ``ResultDeterministic`` | Identification.swift:146 | still builds |  |
| ``PassImpliesMembership`` | ``StepsTerminate`` | Identification.swift:146 | still builds |  |
| ``PassImpliesMembership`` | ``Structure`` | Identification.swift:146 | still builds |  |
| ``PassImpliesMembership`` | ``StructuresFinite`` | Identification.swift:146 | still builds |  |
| ``PassIsIdentification`` | ``EqualityDecidable`` | Identification.swift:156 | inherited, no line to cut |  |
| ``PassIsIdentification`` | ``ExactlyOneSurvives`` | Identification.swift:156 | inherited, no line to cut |  |
| ``PassIsIdentification`` | ``HasSigma`` | Identification.swift:156 | inherited, no line to cut |  |
| ``PassIsIdentification`` | ``HasSolutions`` | Identification.swift:156 | inherited, no line to cut |  |
| ``PassIsIdentification`` | ``Open`` | Identification.swift:156 | inherited, no line to cut |  |
| ``PassIsIdentification`` | ``OperationsClosed`` | Identification.swift:156 | inherited, no line to cut |  |
| ``PassIsIdentification`` | ``Pair`` | Identification.swift:156 | inherited, no line to cut |  |
| ``PassIsIdentification`` | ``PassImpliesMembership`` | Identification.swift:156 | inherited, no line to cut |  |
| ``PassIsIdentification`` | ``PipelineTotal`` | Identification.swift:156 | inherited, no line to cut |  |
| ``PassIsIdentification`` | ``ResultDeterministic`` | Identification.swift:156 | inherited, no line to cut |  |
| ``PassIsIdentification`` | ``StepsTerminate`` | Identification.swift:156 | inherited, no line to cut |  |
| ``PassIsIdentification`` | ``Structure`` | Identification.swift:156 | inherited, no line to cut |  |
| ``PassIsIdentification`` | ``StructuresFinite`` | Identification.swift:156 | inherited, no line to cut |  |
| ``ComparisonsAreBounded`` | ``HasSigma`` | Identification.swift:163 | still builds |  |
| ``ComparisonsAreBounded`` | ``Open`` | Identification.swift:163 | still builds |  |
| ``ComparisonsAreBounded`` | ``Pair`` | Identification.swift:163 | still builds |  |
| ``ComparisonsAreBounded`` | ``Structure`` | Identification.swift:163 | still builds |  |
| ``ComparisonsAreBounded`` | ``StructuresFinite`` | Identification.swift:163 | still builds |  |
| ``PreconditionsGuaranteePass`` | ``EqualityDecidable`` | Identification.swift:171 | still builds |  |
| ``PreconditionsGuaranteePass`` | ``ExactlyOneSurvives`` | Identification.swift:171 | still builds |  |
| ``PreconditionsGuaranteePass`` | ``HasSigma`` | Identification.swift:171 | still builds |  |
| ``PreconditionsGuaranteePass`` | ``HasSolutions`` | Identification.swift:171 | still builds |  |
| ``PreconditionsGuaranteePass`` | ``Open`` | Identification.swift:171 | still builds |  |
| ``PreconditionsGuaranteePass`` | ``Pair`` | Identification.swift:171 | still builds |  |
| ``PreconditionsGuaranteePass`` | ``Structure`` | Identification.swift:171 | still builds |  |
| ``PreconditionsGuaranteePass`` | ``StructuresFinite`` | Identification.swift:171 | still builds |  |
| ``AxesCoOriented`` | ``CachePermanent`` | Identification.swift:183 | still builds |  |
| ``AxesCoOriented`` | ``HasCache`` | Identification.swift:183 | still builds |  |
| ``AxesCoOriented`` | ``HasSigma`` | Identification.swift:183 | still builds |  |
| ``AxesCoOriented`` | ``Open`` | Identification.swift:183 | still builds |  |
| ``AxesCoOriented`` | ``OperationsClosed`` | Identification.swift:183 | still builds |  |
| ``AxesCoOriented`` | ``Pair`` | Identification.swift:183 | still builds |  |
| ``AxesCoOriented`` | ``ResultDeterministic`` | Identification.swift:183 | still builds |  |
| ``AxesCoOriented`` | ``Structure`` | Identification.swift:183 | still builds |  |
| ``AxesCoOriented`` | ``StructuresFinite`` | Identification.swift:183 | still builds |  |
| ``SaturationIncorruptible`` | ``CachePermanent`` | Identification.swift:188 | still builds |  |
| ``SaturationIncorruptible`` | ``HasCache`` | Identification.swift:188 | still builds |  |
| ``SaturationIncorruptible`` | ``HasSigma`` | Identification.swift:188 | still builds |  |
| ``SaturationIncorruptible`` | ``Open`` | Identification.swift:188 | still builds |  |
| ``SaturationIncorruptible`` | ``OperationsClosed`` | Identification.swift:188 | still builds |  |
| ``SaturationIncorruptible`` | ``Pair`` | Identification.swift:188 | still builds |  |
| ``SaturationIncorruptible`` | ``Structure`` | Identification.swift:188 | still builds |  |
| ``SaturationIncorruptible`` | ``StructuresFinite`` | Identification.swift:188 | still builds |  |
| ``Universality`` | ``EqualityDecidable`` | Identification.swift:197 | still builds |  |
| ``Universality`` | ``ExactlyOneSurvives`` | Identification.swift:197 | still builds |  |
| ``Universality`` | ``HasEncoding`` | Identification.swift:197 | still builds |  |
| ``Universality`` | ``HasSigma`` | Identification.swift:197 | still builds |  |
| ``Universality`` | ``HasSolutions`` | Identification.swift:197 | still builds |  |
| ``Universality`` | ``Open`` | Identification.swift:197 | still builds |  |
| ``Universality`` | ``Pair`` | Identification.swift:197 | still builds |  |
| ``Universality`` | ``Structure`` | Identification.swift:197 | still builds |  |
| ``Universality`` | ``StructuresFinite`` | Identification.swift:197 | still builds |  |
| ``RevealsNotCreates`` | ``Measurable`` | Identification.swift:204 | still builds |  |
| ``RevealsNotCreates`` | ``Open`` | Identification.swift:204 | still builds |  |
| ``RevealsNotCreates`` | ``OperationsClosed`` | Identification.swift:204 | still builds |  |
| ``RevealsNotCreates`` | ``Pair`` | Identification.swift:204 | still builds |  |
| ``RevealsNotCreates`` | ``Structure`` | Identification.swift:204 | still builds |  |
| ``OrderIsOnlyFreedom`` | ``AxesCoOriented`` | Identification.swift:215 | still builds |  |
| ``OrderIsOnlyFreedom`` | ``CachePermanent`` | Identification.swift:215 | still builds |  |
| ``OrderIsOnlyFreedom`` | ``HasCache`` | Identification.swift:215 | still builds |  |
| ``OrderIsOnlyFreedom`` | ``HasSigma`` | Identification.swift:215 | still builds |  |
| ``OrderIsOnlyFreedom`` | ``HasSolutions`` | Identification.swift:215 | still builds |  |
| ``OrderIsOnlyFreedom`` | ``IdentityCollapse`` | Identification.swift:215 | still builds |  |
| ``OrderIsOnlyFreedom`` | ``Null`` | Identification.swift:215 | still builds |  |
| ``OrderIsOnlyFreedom`` | ``Open`` | Identification.swift:215 | still builds |  |
| ``OrderIsOnlyFreedom`` | ``OperationsClosed`` | Identification.swift:215 | still builds |  |
| ``OrderIsOnlyFreedom`` | ``Pair`` | Identification.swift:215 | still builds |  |
| ``OrderIsOnlyFreedom`` | ``ResultDeterministic`` | Identification.swift:215 | still builds |  |
| ``OrderIsOnlyFreedom`` | ``Structure`` | Identification.swift:215 | still builds |  |
| ``OrderIsOnlyFreedom`` | ``StructuresFinite`` | Identification.swift:215 | still builds |  |
| ``AgentPathCertified`` | ``EqualityDecidable`` | Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``ExactlyOneSurvives`` | Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``HasSigma`` | Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``HasSolutions`` | Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``IdentityCollapse`` | Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``Null`` | Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``Open`` | Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``OperationsClosed`` | Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``Pair`` | Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``PassImpliesMembership`` | Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``PassIsIdentification`` | Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``PipelineTotal`` | Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``ResultDeterministic`` | Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``StepsTerminate`` | Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``Structure`` | Intelligence.swift:11 | still builds |  |
| ``AgentPathCertified`` | ``StructuresFinite`` | Intelligence.swift:11 | still builds |  |
| ``KnowledgeAccumulates`` | ``CachePermanent`` | Intelligence.swift:15 | still builds |  |
| ``KnowledgeAccumulates`` | ``HasCache`` | Intelligence.swift:15 | still builds |  |
| ``KnowledgeAccumulates`` | ``HasLibrary`` | Intelligence.swift:15 | fails | Library |
| ``KnowledgeAccumulates`` | ``HasSigma`` | Intelligence.swift:15 | still builds |  |
| ``KnowledgeAccumulates`` | ``Open`` | Intelligence.swift:15 | still builds |  |
| ``KnowledgeAccumulates`` | ``OperationsClosed`` | Intelligence.swift:15 | still builds |  |
| ``KnowledgeAccumulates`` | ``Pair`` | Intelligence.swift:15 | still builds |  |
| ``KnowledgeAccumulates`` | ``Structure`` | Intelligence.swift:15 | still builds |  |
| ``KnowledgeAccumulates`` | ``StructuresFinite`` | Intelligence.swift:15 | still builds |  |
| ``LibrarySaturates`` | ``CachePermanent`` | Intelligence.swift:23 | inherited, no line to cut |  |
| ``LibrarySaturates`` | ``HasCache`` | Intelligence.swift:23 | inherited, no line to cut |  |
| ``LibrarySaturates`` | ``HasLibrary`` | Intelligence.swift:23 | inherited, no line to cut |  |
| ``LibrarySaturates`` | ``HasSaturation`` | Intelligence.swift:23 | inherited, no line to cut |  |
| ``LibrarySaturates`` | ``HasSigma`` | Intelligence.swift:23 | inherited, no line to cut |  |
| ``LibrarySaturates`` | ``Open`` | Intelligence.swift:23 | inherited, no line to cut |  |
| ``LibrarySaturates`` | ``OperationsClosed`` | Intelligence.swift:23 | inherited, no line to cut |  |
| ``LibrarySaturates`` | ``Pair`` | Intelligence.swift:23 | inherited, no line to cut |  |
| ``LibrarySaturates`` | ``Structure`` | Intelligence.swift:23 | inherited, no line to cut |  |
| ``LibrarySaturates`` | ``StructuresFinite`` | Intelligence.swift:23 | inherited, no line to cut |  |
| ``BasisIsFinite`` | ``CachePermanent`` | Intelligence.swift:31 | inherited, no line to cut |  |
| ``BasisIsFinite`` | ``HasBasis`` | Intelligence.swift:31 | inherited, no line to cut |  |
| ``BasisIsFinite`` | ``HasCache`` | Intelligence.swift:31 | inherited, no line to cut |  |
| ``BasisIsFinite`` | ``HasLibrary`` | Intelligence.swift:31 | inherited, no line to cut |  |
| ``BasisIsFinite`` | ``HasSaturation`` | Intelligence.swift:31 | inherited, no line to cut |  |
| ``BasisIsFinite`` | ``HasSigma`` | Intelligence.swift:31 | inherited, no line to cut |  |
| ``BasisIsFinite`` | ``LibrarySaturates`` | Intelligence.swift:31 | inherited, no line to cut |  |
| ``BasisIsFinite`` | ``Open`` | Intelligence.swift:31 | inherited, no line to cut |  |
| ``BasisIsFinite`` | ``OperationsClosed`` | Intelligence.swift:31 | inherited, no line to cut |  |
| ``BasisIsFinite`` | ``Pair`` | Intelligence.swift:31 | inherited, no line to cut |  |
| ``BasisIsFinite`` | ``Structure`` | Intelligence.swift:31 | inherited, no line to cut |  |
| ``BasisIsFinite`` | ``StructuresFinite`` | Intelligence.swift:31 | inherited, no line to cut |  |
| ``EncodingSelectionSaturates`` | ``CachePermanent`` | Intelligence.swift:38 | inherited, no line to cut |  |
| ``EncodingSelectionSaturates`` | ``HasCache`` | Intelligence.swift:38 | inherited, no line to cut |  |
| ``EncodingSelectionSaturates`` | ``HasEncoding`` | Intelligence.swift:38 | inherited, no line to cut |  |
| ``EncodingSelectionSaturates`` | ``HasLibrary`` | Intelligence.swift:38 | inherited, no line to cut |  |
| ``EncodingSelectionSaturates`` | ``HasSaturation`` | Intelligence.swift:38 | inherited, no line to cut |  |
| ``EncodingSelectionSaturates`` | ``HasSigma`` | Intelligence.swift:38 | inherited, no line to cut |  |
| ``EncodingSelectionSaturates`` | ``LibrarySaturates`` | Intelligence.swift:38 | inherited, no line to cut |  |
| ``EncodingSelectionSaturates`` | ``Open`` | Intelligence.swift:38 | inherited, no line to cut |  |
| ``EncodingSelectionSaturates`` | ``OperationsClosed`` | Intelligence.swift:38 | inherited, no line to cut |  |
| ``EncodingSelectionSaturates`` | ``Pair`` | Intelligence.swift:38 | inherited, no line to cut |  |
| ``EncodingSelectionSaturates`` | ``Structure`` | Intelligence.swift:38 | inherited, no line to cut |  |
| ``EncodingSelectionSaturates`` | ``StructuresFinite`` | Intelligence.swift:38 | inherited, no line to cut |  |
| ``ResultsIrreversible`` | ``CachePermanent`` | Intelligence.swift:49 | still builds |  |
| ``ResultsIrreversible`` | ``EqualityDecidable`` | Intelligence.swift:49 | still builds |  |
| ``ResultsIrreversible`` | ``HasCache`` | Intelligence.swift:49 | still builds |  |
| ``ResultsIrreversible`` | ``HasSigma`` | Intelligence.swift:49 | still builds |  |
| ``ResultsIrreversible`` | ``Open`` | Intelligence.swift:49 | still builds |  |
| ``ResultsIrreversible`` | ``OperationsClosed`` | Intelligence.swift:49 | still builds |  |
| ``ResultsIrreversible`` | ``Pair`` | Intelligence.swift:49 | still builds |  |
| ``ResultsIrreversible`` | ``Structure`` | Intelligence.swift:49 | still builds |  |
| ``ResultsIrreversible`` | ``StructuresFinite`` | Intelligence.swift:49 | still builds |  |
| ``MembershipDecidable`` | ``EqualityDecidable`` | Intelligence.swift:53 | inherited, no line to cut |  |
| ``MembershipDecidable`` | ``HasSigma`` | Intelligence.swift:53 | inherited, no line to cut |  |
| ``MembershipDecidable`` | ``HasSolutions`` | Intelligence.swift:53 | inherited, no line to cut |  |
| ``MembershipDecidable`` | ``Open`` | Intelligence.swift:53 | inherited, no line to cut |  |
| ``MembershipDecidable`` | ``Pair`` | Intelligence.swift:53 | inherited, no line to cut |  |
| ``MembershipDecidable`` | ``Structure`` | Intelligence.swift:53 | inherited, no line to cut |  |
| ``MembershipDecidable`` | ``StructuresFinite`` | Intelligence.swift:53 | inherited, no line to cut |  |
| ``SystemCrystallizes`` | ``CachePermanent`` | Intelligence.swift:68 | inherited, no line to cut |  |
| ``SystemCrystallizes`` | ``CandidatesOnlyLeave`` | Intelligence.swift:68 | inherited, no line to cut |  |
| ``SystemCrystallizes`` | ``EqualityDecidable`` | Intelligence.swift:68 | inherited, no line to cut |  |
| ``SystemCrystallizes`` | ``HasCache`` | Intelligence.swift:68 | inherited, no line to cut |  |
| ``SystemCrystallizes`` | ``HasSigma`` | Intelligence.swift:68 | inherited, no line to cut |  |
| ``SystemCrystallizes`` | ``HasSolutions`` | Intelligence.swift:68 | inherited, no line to cut |  |
| ``SystemCrystallizes`` | ``MembershipDecidable`` | Intelligence.swift:68 | inherited, no line to cut |  |
| ``SystemCrystallizes`` | ``Open`` | Intelligence.swift:68 | inherited, no line to cut |  |
| ``SystemCrystallizes`` | ``OperationsClosed`` | Intelligence.swift:68 | inherited, no line to cut |  |
| ``SystemCrystallizes`` | ``Pair`` | Intelligence.swift:68 | inherited, no line to cut |  |
| ``SystemCrystallizes`` | ``ResultsIrreversible`` | Intelligence.swift:68 | inherited, no line to cut |  |
| ``SystemCrystallizes`` | ``Structure`` | Intelligence.swift:68 | inherited, no line to cut |  |
| ``SystemCrystallizes`` | ``StructuresFinite`` | Intelligence.swift:68 | inherited, no line to cut |  |
| ``PipelineCrystallizes`` | ``CachePermanent`` | Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``CandidatesOnlyLeave`` | Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``EqualityDecidable`` | Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``ExactlyOneSurvives`` | Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``HasCache`` | Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``HasSigma`` | Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``HasSolutions`` | Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``MembershipDecidable`` | Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``Open`` | Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``OperationsClosed`` | Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``Pair`` | Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``PassImpliesMembership`` | Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``PassIsIdentification`` | Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``PipelineTotal`` | Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``ResultDeterministic`` | Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``ResultsIrreversible`` | Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``StepsTerminate`` | Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``Structure`` | Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``StructuresFinite`` | Intelligence.swift:74 | still builds |  |
| ``PipelineCrystallizes`` | ``SystemCrystallizes`` | Intelligence.swift:74 | still builds |  |
| ``LibraryCrystallizes`` | ``CachePermanent`` | Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``CandidatesOnlyLeave`` | Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``EqualityDecidable`` | Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``HasCache`` | Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``HasLibrary`` | Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``HasSaturation`` | Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``HasSigma`` | Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``HasSolutions`` | Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``LibrarySaturates`` | Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``MembershipDecidable`` | Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``Open`` | Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``OperationsClosed`` | Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``Pair`` | Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``ResultsIrreversible`` | Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``Structure`` | Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``StructuresFinite`` | Intelligence.swift:78 | still builds |  |
| ``LibraryCrystallizes`` | ``SystemCrystallizes`` | Intelligence.swift:78 | still builds |  |
| ``SaturationDynamics`` | ``CachePermanent`` | Intelligence.swift:83 | still builds |  |
| ``SaturationDynamics`` | ``ComparisonsAreBounded`` | Intelligence.swift:83 | still builds |  |
| ``SaturationDynamics`` | ``HasCache`` | Intelligence.swift:83 | still builds |  |
| ``SaturationDynamics`` | ``HasLibrary`` | Intelligence.swift:83 | still builds |  |
| ``SaturationDynamics`` | ``HasSaturation`` | Intelligence.swift:83 | still builds |  |
| ``SaturationDynamics`` | ``HasSigma`` | Intelligence.swift:83 | still builds |  |
| ``SaturationDynamics`` | ``LibrarySaturates`` | Intelligence.swift:83 | still builds |  |
| ``SaturationDynamics`` | ``Open`` | Intelligence.swift:83 | still builds |  |
| ``SaturationDynamics`` | ``OperationsClosed`` | Intelligence.swift:83 | still builds |  |
| ``SaturationDynamics`` | ``Pair`` | Intelligence.swift:83 | still builds |  |
| ``SaturationDynamics`` | ``Structure`` | Intelligence.swift:83 | still builds |  |
| ``SaturationDynamics`` | ``StructuresFinite`` | Intelligence.swift:83 | still builds |  |
| ``DiscoveryIsRevelation`` | ``CachePermanent`` | Intelligence.swift:88 | still builds |  |
| ``DiscoveryIsRevelation`` | ``EqualityDecidable`` | Intelligence.swift:88 | still builds |  |
| ``DiscoveryIsRevelation`` | ``ExactlyOneSurvives`` | Intelligence.swift:88 | still builds |  |
| ``DiscoveryIsRevelation`` | ``HasCache`` | Intelligence.swift:88 | still builds |  |
| ``DiscoveryIsRevelation`` | ``HasLibrary`` | Intelligence.swift:88 | still builds |  |
| ``DiscoveryIsRevelation`` | ``HasSaturation`` | Intelligence.swift:88 | still builds |  |
| ``DiscoveryIsRevelation`` | ``HasSigma`` | Intelligence.swift:88 | still builds |  |
| ``DiscoveryIsRevelation`` | ``HasSolutions`` | Intelligence.swift:88 | still builds |  |
| ``DiscoveryIsRevelation`` | ``LibrarySaturates`` | Intelligence.swift:88 | still builds |  |
| ``DiscoveryIsRevelation`` | ``Open`` | Intelligence.swift:88 | still builds |  |
| ``DiscoveryIsRevelation`` | ``OperationsClosed`` | Intelligence.swift:88 | still builds |  |
| ``DiscoveryIsRevelation`` | ``Pair`` | Intelligence.swift:88 | still builds |  |
| ``DiscoveryIsRevelation`` | ``Structure`` | Intelligence.swift:88 | still builds |  |
| ``DiscoveryIsRevelation`` | ``StructuresFinite`` | Intelligence.swift:88 | still builds |  |
| ``HasEfficiency`` | ``HasSigma`` | Intelligence.swift:96 | still builds |  |
| ``IntelligenceRises`` | ``CachePermanent`` | Intelligence.swift:104 | still builds |  |
| ``IntelligenceRises`` | ``HasCache`` | Intelligence.swift:104 | still builds |  |
| ``IntelligenceRises`` | ``HasEfficiency`` | Intelligence.swift:104 | still builds |  |
| ``IntelligenceRises`` | ``HasLibrary`` | Intelligence.swift:104 | still builds |  |
| ``IntelligenceRises`` | ``HasSaturation`` | Intelligence.swift:104 | still builds |  |
| ``IntelligenceRises`` | ``HasSigma`` | Intelligence.swift:104 | still builds |  |
| ``IntelligenceRises`` | ``LibrarySaturates`` | Intelligence.swift:104 | still builds |  |
| ``IntelligenceRises`` | ``Open`` | Intelligence.swift:104 | still builds |  |
| ``IntelligenceRises`` | ``OperationsClosed`` | Intelligence.swift:104 | still builds |  |
| ``IntelligenceRises`` | ``Pair`` | Intelligence.swift:104 | still builds |  |
| ``IntelligenceRises`` | ``Structure`` | Intelligence.swift:104 | still builds |  |
| ``IntelligenceRises`` | ``StructuresFinite`` | Intelligence.swift:104 | still builds |  |
| ``ThreeAxesOfCompare`` | ``AxesCoOriented`` | Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``CachePermanent`` | Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``Decidable`` | Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``HasCache`` | Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``HasSigma`` | Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``HasSolutions`` | Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``IdentityCollapse`` | Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``Null`` | Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``Open`` | Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``OperationsClosed`` | Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``OrderIsOnlyFreedom`` | Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``Pair`` | Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``ResultDeterministic`` | Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``Structure`` | Interference.swift:23 | still builds |  |
| ``ThreeAxesOfCompare`` | ``StructuresFinite`` | Interference.swift:23 | still builds |  |
| ``InterferenceIsIntelligence`` | ``AxesCoOriented`` | Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``CachePermanent`` | Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``HasCache`` | Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``HasEfficiency`` | Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``HasLibrary`` | Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``HasSaturation`` | Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``HasSigma`` | Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``HasSolutions`` | Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``IdentityCollapse`` | Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``IntelligenceRises`` | Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``LibrarySaturates`` | Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``Null`` | Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``Open`` | Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``OperationsClosed`` | Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``OrderIsOnlyFreedom`` | Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``Pair`` | Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``ResultDeterministic`` | Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``Structure`` | Interference.swift:30 | still builds |  |
| ``InterferenceIsIntelligence`` | ``StructuresFinite`` | Interference.swift:30 | still builds |  |
| ``IsIsYIdentity`` | ``AxesCoOriented`` | Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``CachePermanent`` | Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``EqualityDecidable`` | Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``ExactlyOneSurvives`` | Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``HasCache`` | Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``HasSigma`` | Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``HasSolutions`` | Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``IdentityCollapse`` | Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``Null`` | Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``Open`` | Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``OperationsClosed`` | Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``OrderIsOnlyFreedom`` | Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``Pair`` | Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``PassImpliesMembership`` | Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``PassIsIdentification`` | Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``PipelineTotal`` | Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``ResultDeterministic`` | Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``StepsTerminate`` | Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``Structure`` | Interference.swift:37 | still builds |  |
| ``IsIsYIdentity`` | ``StructuresFinite`` | Interference.swift:37 | still builds |  |
| ``LiquidPhase`` | ``CachePermanent`` | Liquid.swift:31 | still builds |  |
| ``LiquidPhase`` | ``HasCache`` | Liquid.swift:31 | still builds |  |
| ``LiquidPhase`` | ``HasLibrary`` | Liquid.swift:31 | still builds |  |
| ``LiquidPhase`` | ``HasSigma`` | Liquid.swift:31 | still builds |  |
| ``LiquidPhase`` | ``KnowledgeAccumulates`` | Liquid.swift:31 | still builds |  |
| ``LiquidPhase`` | ``Monotone`` | Liquid.swift:31 | still builds |  |
| ``LiquidPhase`` | ``Open`` | Liquid.swift:31 | still builds |  |
| ``LiquidPhase`` | ``OperationsClosed`` | Liquid.swift:31 | still builds |  |
| ``LiquidPhase`` | ``Pair`` | Liquid.swift:31 | still builds |  |
| ``LiquidPhase`` | ``Structure`` | Liquid.swift:31 | still builds |  |
| ``LiquidPhase`` | ``StructuresFinite`` | Liquid.swift:31 | still builds |  |
| ``CrystallizationFront`` | ``CachePermanent`` | Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``DistanceOnStructures`` | Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``HasCache`` | Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``HasDistance`` | Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``HasLibrary`` | Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``HasSigma`` | Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``KnowledgeAccumulates`` | Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``LiquidPhase`` | Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``Monotone`` | Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``NoInverse`` | Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``Open`` | Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``OperationsClosed`` | Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``Pair`` | Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``Structure`` | Liquid.swift:38 | still builds |  |
| ``CrystallizationFront`` | ``StructuresFinite`` | Liquid.swift:38 | still builds |  |
| ``SearchFlow`` | ``AlignmentCoefficient`` | Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``CachePermanent`` | Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``DistanceOnStructures`` | Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``GateIsZeroOfLoss`` | Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``HasAlpha`` | Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``HasCache`` | Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``HasDistance`` | Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``HasLibrary`` | Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``HasSigma`` | Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``KnowledgeAccumulates`` | Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``LiquidPhase`` | Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``Monotone`` | Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``Open`` | Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``OperationsClosed`` | Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``Pair`` | Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``PassImpliesMembership`` | Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``PipelineTotal`` | Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``ResultDeterministic`` | Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``StepsTerminate`` | Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``Structure`` | Liquid.swift:46 | still builds |  |
| ``SearchFlow`` | ``StructuresFinite`` | Liquid.swift:46 | still builds |  |
| ``StefanCoupling`` | ``AlignmentCoefficient`` | Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``CachePermanent`` | Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``CrystallizationFront`` | Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``DistanceOnStructures`` | Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``GateIsZeroOfLoss`` | Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``HasAlpha`` | Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``HasCache`` | Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``HasDistance`` | Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``HasLibrary`` | Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``HasSigma`` | Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``KnowledgeAccumulates`` | Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``LiquidPhase`` | Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``Monotone`` | Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``NoInverse`` | Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``Open`` | Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``OperationsClosed`` | Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``Pair`` | Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``PassImpliesMembership`` | Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``PipelineTotal`` | Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``ResultDeterministic`` | Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``SearchFlow`` | Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``StepsTerminate`` | Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``Structure`` | Liquid.swift:53 | still builds |  |
| ``StefanCoupling`` | ``StructuresFinite`` | Liquid.swift:53 | still builds |  |
| ``GateIsMembrane`` | ``AlignmentCoefficient`` | Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``CachePermanent`` | Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``CrystallizationFront`` | Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``DistanceOnStructures`` | Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``GateIsZeroOfLoss`` | Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``HasAlpha`` | Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``HasCache`` | Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``HasDistance`` | Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``HasLibrary`` | Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``HasSigma`` | Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``KnowledgeAccumulates`` | Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``LiquidPhase`` | Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``Monotone`` | Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``NoInverse`` | Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``Open`` | Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``OperationsClosed`` | Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``Pair`` | Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``PassImpliesMembership`` | Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``PipelineTotal`` | Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``ResultDeterministic`` | Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``SearchFlow`` | Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``StefanCoupling`` | Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``StepsTerminate`` | Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``Structure`` | Liquid.swift:66 | still builds |  |
| ``GateIsMembrane`` | ``StructuresFinite`` | Liquid.swift:66 | still builds |  |
| ``AnchorGraph`` | ``DistanceOnStructures`` | Map.swift:23 | still builds |  |
| ``AnchorGraph`` | ``HasDistance`` | Map.swift:23 | still builds |  |
| ``AnchorGraph`` | ``HasLibrary`` | Map.swift:23 | still builds |  |
| ``AnchorGraph`` | ``HasSigma`` | Map.swift:23 | still builds |  |
| ``AnchorGraph`` | ``Open`` | Map.swift:23 | still builds |  |
| ``AnchorGraph`` | ``Pair`` | Map.swift:23 | still builds |  |
| ``AnchorGraph`` | ``Structure`` | Map.swift:23 | still builds |  |
| ``AnchorGraph`` | ``StructuresFinite`` | Map.swift:23 | still builds |  |
| ``GreedyDescentTerminates`` | ``AnchorGraph`` | Map.swift:33 | still builds |  |
| ``GreedyDescentTerminates`` | ``DistanceOnStructures`` | Map.swift:33 | still builds |  |
| ``GreedyDescentTerminates`` | ``HasDistance`` | Map.swift:33 | still builds |  |
| ``GreedyDescentTerminates`` | ``HasLibrary`` | Map.swift:33 | still builds |  |
| ``GreedyDescentTerminates`` | ``HasSigma`` | Map.swift:33 | still builds |  |
| ``GreedyDescentTerminates`` | ``Monotone`` | Map.swift:33 | still builds |  |
| ``GreedyDescentTerminates`` | ``Open`` | Map.swift:33 | still builds |  |
| ``GreedyDescentTerminates`` | ``Pair`` | Map.swift:33 | still builds |  |
| ``GreedyDescentTerminates`` | ``Structure`` | Map.swift:33 | still builds |  |
| ``GreedyDescentTerminates`` | ``StructuresFinite`` | Map.swift:33 | still builds |  |
| ``HolesCarryAddresses`` | ``AnchorGraph`` | Map.swift:39 | still builds |  |
| ``HolesCarryAddresses`` | ``Decidable`` | Map.swift:39 | still builds |  |
| ``HolesCarryAddresses`` | ``DistanceOnStructures`` | Map.swift:39 | still builds |  |
| ``HolesCarryAddresses`` | ``HasDistance`` | Map.swift:39 | still builds |  |
| ``HolesCarryAddresses`` | ``HasLibrary`` | Map.swift:39 | still builds |  |
| ``HolesCarryAddresses`` | ``HasSigma`` | Map.swift:39 | still builds |  |
| ``HolesCarryAddresses`` | ``Open`` | Map.swift:39 | still builds |  |
| ``HolesCarryAddresses`` | ``Pair`` | Map.swift:39 | still builds |  |
| ``HolesCarryAddresses`` | ``Structure`` | Map.swift:39 | still builds |  |
| ``HolesCarryAddresses`` | ``StructuresFinite`` | Map.swift:39 | still builds |  |
| ``RepairsPermanent`` | ``AnchorGraph`` | Map.swift:45 | still builds |  |
| ``RepairsPermanent`` | ``CachePermanent`` | Map.swift:45 | still builds |  |
| ``RepairsPermanent`` | ``DistanceOnStructures`` | Map.swift:45 | still builds |  |
| ``RepairsPermanent`` | ``HasCache`` | Map.swift:45 | still builds |  |
| ``RepairsPermanent`` | ``HasDistance`` | Map.swift:45 | still builds |  |
| ``RepairsPermanent`` | ``HasLibrary`` | Map.swift:45 | still builds |  |
| ``RepairsPermanent`` | ``HasSigma`` | Map.swift:45 | still builds |  |
| ``RepairsPermanent`` | ``KnowledgeAccumulates`` | Map.swift:45 | still builds |  |
| ``RepairsPermanent`` | ``NoInverse`` | Map.swift:45 | still builds |  |
| ``RepairsPermanent`` | ``Open`` | Map.swift:45 | still builds |  |
| ``RepairsPermanent`` | ``OperationsClosed`` | Map.swift:45 | still builds |  |
| ``RepairsPermanent`` | ``Pair`` | Map.swift:45 | still builds |  |
| ``RepairsPermanent`` | ``Structure`` | Map.swift:45 | still builds |  |
| ``RepairsPermanent`` | ``StructuresFinite`` | Map.swift:45 | still builds |  |
| ``FailureCurriculum`` | ``AnchorGraph`` | Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``CachePermanent`` | Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``Decidable`` | Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``DistanceOnStructures`` | Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``HasCache`` | Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``HasDistance`` | Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``HasLibrary`` | Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``HasSigma`` | Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``HolesCarryAddresses`` | Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``KnowledgeAccumulates`` | Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``NoInverse`` | Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``Open`` | Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``OperationsClosed`` | Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``Pair`` | Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``RepairsPermanent`` | Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``Structure`` | Map.swift:52 | still builds |  |
| ``FailureCurriculum`` | ``StructuresFinite`` | Map.swift:52 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``AnchorGraph`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``BallSaturation`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``CachePermanent`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``CompressionCriterion`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``Decidable`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``DistanceOnStructures`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``EqualityDecidable`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``ExactlyOneSurvives`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``HasCache`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``HasCost`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``HasDistance`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``HasLibrary`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``HasSaturation`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``HasSigma`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``HasSolutions`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``HasTime`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``Ignites`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``KnowledgeAccumulates`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``LibrarySaturates`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``Matter`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``Open`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``OperationsClosed`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``Pair`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``PassImpliesMembership`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``PassIsIdentification`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``PipelineTotal`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``Resistant`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``ResultDeterministic`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``StepsTerminate`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``Structure`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``StructuresFinite`` | Map.swift:64 | still builds |  |
| ``OneBoundaryThreeFaces`` | ``Tower`` | Map.swift:64 | still builds |  |
| ``NavigationInevitable`` | ``AnchorGraph`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``BallSaturation`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``CachePermanent`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``CompressionCriterion`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``Decidable`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``DistanceOnStructures`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``EqualityDecidable`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``ExactlyOneSurvives`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``HasCache`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``HasCost`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``HasDistance`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``HasLibrary`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``HasSaturation`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``HasSigma`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``HasSolutions`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``HasTime`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``Ignites`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``KnowledgeAccumulates`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``LibrarySaturates`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``Matter`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``OneBoundaryThreeFaces`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``Open`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``OperationsClosed`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``Pair`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``PassImpliesMembership`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``PassIsIdentification`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``PipelineTotal`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``Resistant`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``ResultDeterministic`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``StepsTerminate`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``Structure`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``StructuresFinite`` | Map.swift:72 | still builds |  |
| ``NavigationInevitable`` | ``Tower`` | Map.swift:72 | still builds |  |
| ``HasTime`` | ``HasSigma`` | Matter.swift:20 | still builds |  |
| ``HasCost`` | ``HasSigma`` | Matter.swift:26 | still builds |  |
| ``Resistant`` | ``Decidable`` | Matter.swift:36 | still builds |  |
| ``Resistant`` | ``HasDistance`` | Matter.swift:36 | still builds |  |
| ``Resistant`` | ``HasSigma`` | Matter.swift:36 | still builds |  |
| ``Resistant`` | ``Open`` | Matter.swift:36 | still builds |  |
| ``Resistant`` | ``Pair`` | Matter.swift:36 | still builds |  |
| ``Resistant`` | ``Structure`` | Matter.swift:36 | still builds |  |
| ``Matter`` | ``CachePermanent`` | Matter.swift:50 | still builds |  |
| ``Matter`` | ``Decidable`` | Matter.swift:50 | still builds |  |
| ``Matter`` | ``EqualityDecidable`` | Matter.swift:50 | still builds |  |
| ``Matter`` | ``ExactlyOneSurvives`` | Matter.swift:50 | still builds |  |
| ``Matter`` | ``HasCache`` | Matter.swift:50 | still builds |  |
| ``Matter`` | ``HasDistance`` | Matter.swift:50 | still builds |  |
| ``Matter`` | ``HasLibrary`` | Matter.swift:50 | still builds |  |
| ``Matter`` | ``HasSigma`` | Matter.swift:50 | still builds |  |
| ``Matter`` | ``HasSolutions`` | Matter.swift:50 | still builds |  |
| ``Matter`` | ``KnowledgeAccumulates`` | Matter.swift:50 | still builds |  |
| ``Matter`` | ``Open`` | Matter.swift:50 | still builds |  |
| ``Matter`` | ``OperationsClosed`` | Matter.swift:50 | still builds |  |
| ``Matter`` | ``Pair`` | Matter.swift:50 | still builds |  |
| ``Matter`` | ``PassImpliesMembership`` | Matter.swift:50 | still builds |  |
| ``Matter`` | ``PassIsIdentification`` | Matter.swift:50 | still builds |  |
| ``Matter`` | ``PipelineTotal`` | Matter.swift:50 | still builds |  |
| ``Matter`` | ``Resistant`` | Matter.swift:50 | still builds |  |
| ``Matter`` | ``ResultDeterministic`` | Matter.swift:50 | still builds |  |
| ``Matter`` | ``StepsTerminate`` | Matter.swift:50 | still builds |  |
| ``Matter`` | ``Structure`` | Matter.swift:50 | still builds |  |
| ``Matter`` | ``StructuresFinite`` | Matter.swift:50 | still builds |  |
| ``NoInverse`` | ``CachePermanent`` | Matter.swift:57 | inherited, no line to cut |  |
| ``NoInverse`` | ``HasCache`` | Matter.swift:57 | inherited, no line to cut |  |
| ``NoInverse`` | ``HasLibrary`` | Matter.swift:57 | inherited, no line to cut |  |
| ``NoInverse`` | ``HasSigma`` | Matter.swift:57 | inherited, no line to cut |  |
| ``NoInverse`` | ``KnowledgeAccumulates`` | Matter.swift:57 | inherited, no line to cut |  |
| ``NoInverse`` | ``Open`` | Matter.swift:57 | inherited, no line to cut |  |
| ``NoInverse`` | ``OperationsClosed`` | Matter.swift:57 | inherited, no line to cut |  |
| ``NoInverse`` | ``Pair`` | Matter.swift:57 | inherited, no line to cut |  |
| ``NoInverse`` | ``Structure`` | Matter.swift:57 | inherited, no line to cut |  |
| ``NoInverse`` | ``StructuresFinite`` | Matter.swift:57 | inherited, no line to cut |  |
| ``Converges`` | ``CachePermanent`` | Matter.swift:66 | still builds |  |
| ``Converges`` | ``CandidatesOnlyLeave`` | Matter.swift:66 | still builds |  |
| ``Converges`` | ``EqualityDecidable`` | Matter.swift:66 | still builds |  |
| ``Converges`` | ``HasCache`` | Matter.swift:66 | still builds |  |
| ``Converges`` | ``HasLibrary`` | Matter.swift:66 | still builds |  |
| ``Converges`` | ``HasSigma`` | Matter.swift:66 | still builds |  |
| ``Converges`` | ``HasSolutions`` | Matter.swift:66 | still builds |  |
| ``Converges`` | ``KnowledgeAccumulates`` | Matter.swift:66 | still builds |  |
| ``Converges`` | ``MembershipDecidable`` | Matter.swift:66 | still builds |  |
| ``Converges`` | ``NoInverse`` | Matter.swift:66 | still builds |  |
| ``Converges`` | ``Open`` | Matter.swift:66 | still builds |  |
| ``Converges`` | ``OperationsClosed`` | Matter.swift:66 | still builds |  |
| ``Converges`` | ``Pair`` | Matter.swift:66 | still builds |  |
| ``Converges`` | ``ResultsIrreversible`` | Matter.swift:66 | still builds |  |
| ``Converges`` | ``Structure`` | Matter.swift:66 | still builds |  |
| ``Converges`` | ``StructuresFinite`` | Matter.swift:66 | still builds |  |
| ``Converges`` | ``SystemCrystallizes`` | Matter.swift:66 | still builds |  |
| ``Ignites`` | ``CachePermanent`` | Matter.swift:73 | still builds |  |
| ``Ignites`` | ``Decidable`` | Matter.swift:73 | still builds |  |
| ``Ignites`` | ``EqualityDecidable`` | Matter.swift:73 | still builds |  |
| ``Ignites`` | ``ExactlyOneSurvives`` | Matter.swift:73 | still builds |  |
| ``Ignites`` | ``HasCache`` | Matter.swift:73 | still builds |  |
| ``Ignites`` | ``HasDistance`` | Matter.swift:73 | still builds |  |
| ``Ignites`` | ``HasLibrary`` | Matter.swift:73 | still builds |  |
| ``Ignites`` | ``HasSaturation`` | Matter.swift:73 | still builds |  |
| ``Ignites`` | ``HasSigma`` | Matter.swift:73 | still builds |  |
| ``Ignites`` | ``HasSolutions`` | Matter.swift:73 | still builds |  |
| ``Ignites`` | ``KnowledgeAccumulates`` | Matter.swift:73 | still builds |  |
| ``Ignites`` | ``LibrarySaturates`` | Matter.swift:73 | still builds |  |
| ``Ignites`` | ``Matter`` | Matter.swift:73 | still builds |  |
| ``Ignites`` | ``Open`` | Matter.swift:73 | still builds |  |
| ``Ignites`` | ``OperationsClosed`` | Matter.swift:73 | still builds |  |
| ``Ignites`` | ``Pair`` | Matter.swift:73 | still builds |  |
| ``Ignites`` | ``PassImpliesMembership`` | Matter.swift:73 | still builds |  |
| ``Ignites`` | ``PassIsIdentification`` | Matter.swift:73 | still builds |  |
| ``Ignites`` | ``PipelineTotal`` | Matter.swift:73 | still builds |  |
| ``Ignites`` | ``Resistant`` | Matter.swift:73 | still builds |  |
| ``Ignites`` | ``ResultDeterministic`` | Matter.swift:73 | still builds |  |
| ``Ignites`` | ``StepsTerminate`` | Matter.swift:73 | still builds |  |
| ``Ignites`` | ``Structure`` | Matter.swift:73 | still builds |  |
| ``Ignites`` | ``StructuresFinite`` | Matter.swift:73 | still builds |  |
| ``Tower`` | ``CachePermanent`` | Matter.swift:81 | still builds |  |
| ``Tower`` | ``Decidable`` | Matter.swift:81 | still builds |  |
| ``Tower`` | ``EqualityDecidable`` | Matter.swift:81 | still builds |  |
| ``Tower`` | ``ExactlyOneSurvives`` | Matter.swift:81 | still builds |  |
| ``Tower`` | ``HasCache`` | Matter.swift:81 | still builds |  |
| ``Tower`` | ``HasCost`` | Matter.swift:81 | still builds |  |
| ``Tower`` | ``HasDistance`` | Matter.swift:81 | still builds |  |
| ``Tower`` | ``HasLibrary`` | Matter.swift:81 | still builds |  |
| ``Tower`` | ``HasSaturation`` | Matter.swift:81 | still builds |  |
| ``Tower`` | ``HasSigma`` | Matter.swift:81 | still builds |  |
| ``Tower`` | ``HasSolutions`` | Matter.swift:81 | still builds |  |
| ``Tower`` | ``HasTime`` | Matter.swift:81 | still builds |  |
| ``Tower`` | ``Ignites`` | Matter.swift:81 | still builds |  |
| ``Tower`` | ``KnowledgeAccumulates`` | Matter.swift:81 | still builds |  |
| ``Tower`` | ``LibrarySaturates`` | Matter.swift:81 | still builds |  |
| ``Tower`` | ``Matter`` | Matter.swift:81 | still builds |  |
| ``Tower`` | ``Open`` | Matter.swift:81 | still builds |  |
| ``Tower`` | ``OperationsClosed`` | Matter.swift:81 | still builds |  |
| ``Tower`` | ``Pair`` | Matter.swift:81 | still builds |  |
| ``Tower`` | ``PassImpliesMembership`` | Matter.swift:81 | still builds |  |
| ``Tower`` | ``PassIsIdentification`` | Matter.swift:81 | still builds |  |
| ``Tower`` | ``PipelineTotal`` | Matter.swift:81 | still builds |  |
| ``Tower`` | ``Resistant`` | Matter.swift:81 | still builds |  |
| ``Tower`` | ``ResultDeterministic`` | Matter.swift:81 | still builds |  |
| ``Tower`` | ``StepsTerminate`` | Matter.swift:81 | still builds |  |
| ``Tower`` | ``Structure`` | Matter.swift:81 | still builds |  |
| ``Tower`` | ``StructuresFinite`` | Matter.swift:81 | still builds |  |
| ``FiniteDiscovery`` | ``CachePermanent`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``ComparisonsAreBounded`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``Decidable`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``EqualityDecidable`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``ExactlyOneSurvives`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``HasCache`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``HasCost`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``HasDistance`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``HasLibrary`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``HasSaturation`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``HasSigma`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``HasSolutions`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``HasTime`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``Ignites`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``KnowledgeAccumulates`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``LibrarySaturates`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``Matter`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``Open`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``OperationsClosed`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``Pair`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``PassImpliesMembership`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``PassIsIdentification`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``PipelineTotal`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``Resistant`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``ResultDeterministic`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``StepsTerminate`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``Structure`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``StructuresFinite`` | Matter.swift:90 | still builds |  |
| ``FiniteDiscovery`` | ``Tower`` | Matter.swift:90 | still builds |  |
| ``Digit`` | ``Open`` | Numeral.swift:20 | still builds |  |
| ``Digit`` | ``Structure`` | Numeral.swift:20 | still builds |  |
| ``HasPath`` | ``HasSigma`` | Path.swift:32 | still builds |  |
| ``EmissionAccumulates`` | ``HasPath`` | Path.swift:42 | inherited, no line to cut |  |
| ``EmissionAccumulates`` | ``HasSigma`` | Path.swift:42 | inherited, no line to cut |  |
| ``CostIsPathLength`` | ``HasDistance`` | Path.swift:52 | inherited, no line to cut |  |
| ``CostIsPathLength`` | ``HasPath`` | Path.swift:52 | inherited, no line to cut |  |
| ``CostIsPathLength`` | ``HasSigma`` | Path.swift:52 | inherited, no line to cut |  |
| ``ReachIsPath`` | ``HasBasis`` | Path.swift:67 | inherited, no line to cut |  |
| ``ReachIsPath`` | ``HasLibrary`` | Path.swift:67 | inherited, no line to cut |  |
| ``ReachIsPath`` | ``HasPath`` | Path.swift:67 | inherited, no line to cut |  |
| ``ReachIsPath`` | ``HasSigma`` | Path.swift:67 | inherited, no line to cut |  |
| ``EmissionIsAutoregressive`` | ``HasEncoding`` | Path.swift:78 | inherited, no line to cut |  |
| ``EmissionIsAutoregressive`` | ``HasPath`` | Path.swift:78 | inherited, no line to cut |  |
| ``EmissionIsAutoregressive`` | ``HasSigma`` | Path.swift:78 | inherited, no line to cut |  |
| ``EmissionIsAutoregressive`` | ``Open`` | Path.swift:78 | inherited, no line to cut |  |
| ``EmissionIsAutoregressive`` | ``OperationsClosed`` | Path.swift:78 | inherited, no line to cut |  |
| ``EmissionIsAutoregressive`` | ``Pair`` | Path.swift:78 | inherited, no line to cut |  |
| ``EmissionIsAutoregressive`` | ``ResultDeterministic`` | Path.swift:78 | inherited, no line to cut |  |
| ``EmissionIsAutoregressive`` | ``ScopeBoundedByEncoding`` | Path.swift:78 | inherited, no line to cut |  |
| ``EmissionIsAutoregressive`` | ``Structure`` | Path.swift:78 | inherited, no line to cut |  |
| ``ConstructionIsReading`` | ``AxesCoOriented`` | Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``CachePermanent`` | Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``EmissionAccumulates`` | Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``HasCache`` | Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``HasPath`` | Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``HasSigma`` | Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``HasSolutions`` | Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``HasTime`` | Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``IdentityCollapse`` | Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``Measurable`` | Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``Null`` | Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``Open`` | Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``OperationsClosed`` | Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``OrderIsOnlyFreedom`` | Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``Pair`` | Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``Reading`` | Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``ResultDeterministic`` | Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``RevealsNotCreates`` | Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``Structure`` | Path.swift:90 | still builds |  |
| ``ConstructionIsReading`` | ``StructuresFinite`` | Path.swift:90 | still builds |  |
| ``InvalidStepFolds`` | ``HasPath`` | Path.swift:101 | inherited, no line to cut |  |
| ``InvalidStepFolds`` | ``HasSigma`` | Path.swift:101 | inherited, no line to cut |  |
| ``InvalidStepFolds`` | ``Null`` | Path.swift:101 | inherited, no line to cut |  |
| ``InvalidStepFolds`` | ``Open`` | Path.swift:101 | inherited, no line to cut |  |
| ``InvalidStepFolds`` | ``Pair`` | Path.swift:101 | inherited, no line to cut |  |
| ``InvalidStepFolds`` | ``Structure`` | Path.swift:101 | inherited, no line to cut |  |
| ``GatedConstruction`` | ``CachePermanent`` | Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``CandidatesOnlyLeave`` | Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``EmissionAccumulates`` | Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``EqualityDecidable`` | Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``HasCache`` | Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``HasPath`` | Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``HasSigma`` | Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``HasSolutions`` | Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``MembershipDecidable`` | Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``Open`` | Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``OperationsClosed`` | Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``Pair`` | Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``ResultsIrreversible`` | Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``Structure`` | Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``StructuresFinite`` | Path.swift:111 | still builds |  |
| ``GatedConstruction`` | ``SystemCrystallizes`` | Path.swift:111 | still builds |  |
| ``FreeGeneration`` | ``AxesCoOriented`` | Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``CachePermanent`` | Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``DiscriminatorAndGenerator`` | Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``EmissionAccumulates`` | Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``HasCache`` | Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``HasPath`` | Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``HasSigma`` | Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``HasSolutions`` | Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``IdentityCollapse`` | Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``Null`` | Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``Open`` | Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``OperationsClosed`` | Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``OrderIsOnlyFreedom`` | Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``Pair`` | Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``PassImpliesMembership`` | Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``PipelineTotal`` | Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``ResultDeterministic`` | Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``StepsTerminate`` | Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``Structure`` | Path.swift:126 | still builds |  |
| ``FreeGeneration`` | ``StructuresFinite`` | Path.swift:126 | still builds |  |
| ``ProgramIsPath`` | ``CachePermanent`` | Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``CandidatesOnlyLeave`` | Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``EmissionAccumulates`` | Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``EmissionIsAutoregressive`` | Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``EqualityDecidable`` | Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``GatedConstruction`` | Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``HasBasis`` | Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``HasCache`` | Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``HasEncoding`` | Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``HasLibrary`` | Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``HasPath`` | Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``HasSigma`` | Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``HasSolutions`` | Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``MembershipDecidable`` | Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``Open`` | Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``OperationsClosed`` | Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``Pair`` | Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``ReachIsPath`` | Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``ResultDeterministic`` | Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``ResultsIrreversible`` | Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``ScopeBoundedByEncoding`` | Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``Structure`` | Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``StructuresFinite`` | Path.swift:136 | still builds |  |
| ``ProgramIsPath`` | ``SystemCrystallizes`` | Path.swift:136 | still builds |  |
| ``CompletionIsSolutionSet`` | ``AxesCoOriented`` | Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``CachePermanent`` | Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``HasCache`` | Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``HasPath`` | Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``HasSigma`` | Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``HasSolutions`` | Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``HasTime`` | Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``IdentityCollapse`` | Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``Measurable`` | Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``Null`` | Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``Open`` | Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``OperationsClosed`` | Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``OrderIsOnlyFreedom`` | Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``Pair`` | Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``Reading`` | Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``ResultDeterministic`` | Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``RevealsNotCreates`` | Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``Structure`` | Path.swift:148 | inherited, no line to cut |  |
| ``CompletionIsSolutionSet`` | ``StructuresFinite`` | Path.swift:148 | inherited, no line to cut |  |
| ``ErasureIsRecession`` | ``CachePermanent`` | Path.swift:160 | still builds |  |
| ``ErasureIsRecession`` | ``EmissionAccumulates`` | Path.swift:160 | still builds |  |
| ``ErasureIsRecession`` | ``HasCache`` | Path.swift:160 | still builds |  |
| ``ErasureIsRecession`` | ``HasLibrary`` | Path.swift:160 | still builds |  |
| ``ErasureIsRecession`` | ``HasPath`` | Path.swift:160 | still builds |  |
| ``ErasureIsRecession`` | ``HasSigma`` | Path.swift:160 | still builds |  |
| ``ErasureIsRecession`` | ``KnowledgeAccumulates`` | Path.swift:160 | still builds |  |
| ``ErasureIsRecession`` | ``NoInverse`` | Path.swift:160 | still builds |  |
| ``ErasureIsRecession`` | ``Open`` | Path.swift:160 | still builds |  |
| ``ErasureIsRecession`` | ``OperationsClosed`` | Path.swift:160 | still builds |  |
| ``ErasureIsRecession`` | ``Pair`` | Path.swift:160 | still builds |  |
| ``ErasureIsRecession`` | ``Structure`` | Path.swift:160 | still builds |  |
| ``ErasureIsRecession`` | ``StructuresFinite`` | Path.swift:160 | still builds |  |
| ``CertifiedRuleGenerates`` | ``CachePermanent`` | Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``EqualityDecidable`` | Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``ExactlyOneSurvives`` | Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``HasCache`` | Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``HasLibrary`` | Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``HasSigma`` | Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``HasSolutions`` | Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``KnowledgeAccumulates`` | Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``Open`` | Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``OperationsClosed`` | Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``Pair`` | Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``PassImpliesMembership`` | Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``PassIsIdentification`` | Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``PipelineTotal`` | Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``ResultDeterministic`` | Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``StepsTerminate`` | Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``Structure`` | Play.swift:23 | still builds |  |
| ``CertifiedRuleGenerates`` | ``StructuresFinite`` | Play.swift:23 | still builds |  |
| ``AmbiguityNamesInput`` | ``AnchorGraph`` | Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``CachePermanent`` | Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``CertifiedRuleGenerates`` | Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``Decidable`` | Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``DistanceOnStructures`` | Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``EqualityDecidable`` | Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``ExactlyOneSurvives`` | Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``HasCache`` | Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``HasDistance`` | Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``HasLibrary`` | Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``HasSigma`` | Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``HasSolutions`` | Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``HolesCarryAddresses`` | Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``KnowledgeAccumulates`` | Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``Open`` | Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``OperationsClosed`` | Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``Pair`` | Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``PassImpliesMembership`` | Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``PassIsIdentification`` | Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``PipelineTotal`` | Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``ResultDeterministic`` | Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``StepsTerminate`` | Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``Structure`` | Play.swift:30 | still builds |  |
| ``AmbiguityNamesInput`` | ``StructuresFinite`` | Play.swift:30 | still builds |  |
| ``SelfPlaySaturates`` | ``AmbiguityNamesInput`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``AnchorGraph`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``BasisIsFinite`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``CachePermanent`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``CertifiedRuleGenerates`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``Decidable`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``DistanceOnStructures`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``EqualityDecidable`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``ExactlyOneSurvives`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``HasBasis`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``HasCache`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``HasDistance`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``HasLibrary`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``HasSaturation`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``HasSigma`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``HasSolutions`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``HolesCarryAddresses`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``KnowledgeAccumulates`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``LibrarySaturates`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``Open`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``OperationsClosed`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``Pair`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``PassImpliesMembership`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``PassIsIdentification`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``PipelineTotal`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``ResultDeterministic`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``StepsTerminate`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``Structure`` | Play.swift:42 | still builds |  |
| ``SelfPlaySaturates`` | ``StructuresFinite`` | Play.swift:42 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``AmbiguityNamesInput`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``AnchorGraph`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``BasisIsFinite`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``CachePermanent`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``CertifiedRuleGenerates`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``Decidable`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``DistanceOnStructures`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``EqualityDecidable`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``ExactlyOneSurvives`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``HasBasis`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``HasCache`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``HasDistance`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``HasLibrary`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``HasSaturation`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``HasSigma`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``HasSolutions`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``HolesCarryAddresses`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``KnowledgeAccumulates`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``LibrarySaturates`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``Open`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``OperationsClosed`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``Pair`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``PassImpliesMembership`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``PassIsIdentification`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``PipelineTotal`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``ResultDeterministic`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``ScopeBoundedByEncoding`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``SelfPlaySaturates`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``StepsTerminate`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``Structure`` | Play.swift:49 | still builds |  |
| ``SecondEncodingIsNovelty`` | ``StructuresFinite`` | Play.swift:49 | still builds |  |
| ``TowerSelfPlay`` | ``AmbiguityNamesInput`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``AnchorGraph`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``BasisIsFinite`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``CachePermanent`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``CertifiedRuleGenerates`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``Decidable`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``DistanceOnStructures`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``EqualityDecidable`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``ExactlyOneSurvives`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``HasBasis`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``HasCache`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``HasDistance`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``HasLibrary`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``HasSaturation`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``HasSigma`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``HasSolutions`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``HolesCarryAddresses`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``Ignites`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``KnowledgeAccumulates`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``LibrarySaturates`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``Matter`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``Open`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``OperationsClosed`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``Pair`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``PassImpliesMembership`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``PassIsIdentification`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``PipelineTotal`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``Resistant`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``ResultDeterministic`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``SelfPlaySaturates`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``StepsTerminate`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``Structure`` | Play.swift:55 | still builds |  |
| ``TowerSelfPlay`` | ``StructuresFinite`` | Play.swift:55 | still builds |  |
| ``PlayIsProof`` | ``AmbiguityNamesInput`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``AnchorGraph`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``BasisIsFinite`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``CachePermanent`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``CertifiedRuleGenerates`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``Decidable`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``DistanceOnStructures`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``EqualityDecidable`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``ExactlyOneSurvives`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``HasBasis`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``HasCache`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``HasDistance`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``HasLibrary`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``HasSaturation`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``HasSigma`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``HasSolutions`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``HolesCarryAddresses`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``Ignites`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``KnowledgeAccumulates`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``LibrarySaturates`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``Matter`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``Measurable`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``Open`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``OperationsClosed`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``Pair`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``PassImpliesMembership`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``PassIsIdentification`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``PipelineTotal`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``Resistant`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``ResultDeterministic`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``RevealsNotCreates`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``SelfPlaySaturates`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``StepsTerminate`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``Structure`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``StructuresFinite`` | Play.swift:70 | still builds |  |
| ``PlayIsProof`` | ``TowerSelfPlay`` | Play.swift:70 | still builds |  |
| ``PresentedLaw`` | ``DistanceOnStructures`` | Presentation.swift:18 | still builds |  |
| ``PresentedLaw`` | ``HasDistance`` | Presentation.swift:18 | still builds |  |
| ``PresentedLaw`` | ``HasLaw`` | Presentation.swift:18 | still builds |  |
| ``PresentedLaw`` | ``HasSigma`` | Presentation.swift:18 | still builds |  |
| ``PresentedLaw`` | ``Open`` | Presentation.swift:18 | still builds |  |
| ``PresentedLaw`` | ``Pair`` | Presentation.swift:18 | still builds |  |
| ``PresentedLaw`` | ``Structure`` | Presentation.swift:18 | still builds |  |
| ``PresentedLaw`` | ``StructuresFinite`` | Presentation.swift:18 | still builds |  |
| ``PressIsIdentification`` | ``DistanceOnStructures`` | Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``EqualityDecidable`` | Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``ExactlyOneSurvives`` | Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``HasDistance`` | Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``HasLaw`` | Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``HasSigma`` | Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``HasSolutions`` | Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``Open`` | Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``OperationsClosed`` | Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``Pair`` | Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``PassImpliesMembership`` | Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``PassIsIdentification`` | Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``PipelineTotal`` | Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``PresentedLaw`` | Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``ResultDeterministic`` | Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``StepsTerminate`` | Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``Structure`` | Presentation.swift:25 | still builds |  |
| ``PressIsIdentification`` | ``StructuresFinite`` | Presentation.swift:25 | still builds |  |
| ``EdgesCarryTheJudgement`` | ``BehaviorIsStructure`` | Presentation.swift:32 | still builds |  |
| ``EdgesCarryTheJudgement`` | ``DistanceOnStructures`` | Presentation.swift:32 | still builds |  |
| ``EdgesCarryTheJudgement`` | ``HasDistance`` | Presentation.swift:32 | still builds |  |
| ``EdgesCarryTheJudgement`` | ``HasLaw`` | Presentation.swift:32 | still builds |  |
| ``EdgesCarryTheJudgement`` | ``HasSigma`` | Presentation.swift:32 | still builds |  |
| ``EdgesCarryTheJudgement`` | ``HasTime`` | Presentation.swift:32 | still builds |  |
| ``EdgesCarryTheJudgement`` | ``Open`` | Presentation.swift:32 | still builds |  |
| ``EdgesCarryTheJudgement`` | ``Pair`` | Presentation.swift:32 | still builds |  |
| ``EdgesCarryTheJudgement`` | ``PresentedLaw`` | Presentation.swift:32 | still builds |  |
| ``EdgesCarryTheJudgement`` | ``Structure`` | Presentation.swift:32 | still builds |  |
| ``EdgesCarryTheJudgement`` | ``StructuresFinite`` | Presentation.swift:32 | still builds |  |
| ``FormIsInvariant`` | ``DistanceOnStructures`` | Presentation.swift:38 | still builds |  |
| ``FormIsInvariant`` | ``HasDistance`` | Presentation.swift:38 | still builds |  |
| ``FormIsInvariant`` | ``HasLaw`` | Presentation.swift:38 | still builds |  |
| ``FormIsInvariant`` | ``HasSigma`` | Presentation.swift:38 | still builds |  |
| ``FormIsInvariant`` | ``Open`` | Presentation.swift:38 | still builds |  |
| ``FormIsInvariant`` | ``Pair`` | Presentation.swift:38 | still builds |  |
| ``FormIsInvariant`` | ``PresentedLaw`` | Presentation.swift:38 | still builds |  |
| ``FormIsInvariant`` | ``Structure`` | Presentation.swift:38 | still builds |  |
| ``FormIsInvariant`` | ``StructuresFinite`` | Presentation.swift:38 | still builds |  |
| ``Open`` | ``Structure`` | Primitive.swift:70 | fails | Paired<A, B>, Plus<Unit, Unit>, Structure, U2, body |
| ``Close`` | ``Structure`` | Primitive.swift:88 | fails | Structure, U1, Unit |
| ``Pair`` | ``Open`` | Primitive.swift:102 | fails | Paired<A, B>, Structure, body |
| ``Pair`` | ``Structure`` | Primitive.swift:102 | still builds |  |
| ``Null`` | ``Open`` | Primitive.swift:114 | inherited, no line to cut |  |
| ``Null`` | ``Pair`` | Primitive.swift:114 | inherited, no line to cut |  |
| ``Null`` | ``Structure`` | Primitive.swift:114 | inherited, no line to cut |  |
| ``AllCoordinatesPresent`` | ``AlignmentCoefficient`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``AmbiguityNamesInput`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``AnchorGraph`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``BasisIsFinite`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``CachePermanent`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``CertifiedRuleGenerates`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``CrystallizationFront`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``Decidable`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``DistanceOnStructures`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``EqualityDecidable`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``ExactlyOneSurvives`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``GateIsMembrane`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``GateIsZeroOfLoss`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``HasAlpha`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``HasBasis`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``HasCache`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``HasDistance`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``HasLibrary`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``HasSaturation`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``HasSigma`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``HasSolutions`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``HolesCarryAddresses`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``Ignites`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``KnowledgeAccumulates`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``LibrarySaturates`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``LiquidPhase`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``Matter`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``Measurable`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``Monotone`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``NoInverse`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``Open`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``OperationsClosed`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``Pair`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``PassImpliesMembership`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``PassIsIdentification`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``PipelineTotal`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``PlayIsProof`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``Resistant`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``ResultDeterministic`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``RevealsNotCreates`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``SearchFlow`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``SelfPlaySaturates`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``StefanCoupling`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``StepsTerminate`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``Structure`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``StructuresFinite`` | Projection.swift:29 | still builds |  |
| ``AllCoordinatesPresent`` | ``TowerSelfPlay`` | Projection.swift:29 | still builds |  |
| ``GateWrapper`` | ``AlignmentCoefficient`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``AxesCoOriented`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``CachePermanent`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``CrystallizationFront`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``DiscriminatorAndGenerator`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``DistanceOnStructures`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``GateIsMembrane`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``GateIsZeroOfLoss`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``HasAlpha`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``HasCache`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``HasDistance`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``HasLibrary`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``HasSigma`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``HasSolutions`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``IdentityCollapse`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``KnowledgeAccumulates`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``LiquidPhase`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``Monotone`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``NoInverse`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``Null`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``Open`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``OperationsClosed`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``OrderIsOnlyFreedom`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``Pair`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``PassImpliesMembership`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``PipelineTotal`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``ResultDeterministic`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``SearchFlow`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``StefanCoupling`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``StepsTerminate`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``Structure`` | Projection.swift:38 | still builds |  |
| ``GateWrapper`` | ``StructuresFinite`` | Projection.swift:38 | still builds |  |
| ``SaturationMap`` | ``AlignmentCoefficient`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``AnchorGraph`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``AxesCoOriented`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``BallSaturation`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``CachePermanent`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``CompressionCriterion`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``CrystallizationFront`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``Decidable`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``DistanceOnStructures`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``EqualityDecidable`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``ExactlyOneSurvives`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``FourthFace`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``GateIsMembrane`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``GateIsZeroOfLoss`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``HasAlpha`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``HasCache`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``HasCost`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``HasDistance`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``HasLibrary`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``HasSaturation`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``HasSigma`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``HasSolutions`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``HasTime`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``IdentityCollapse`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``Ignites`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``KnowledgeAccumulates`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``LibrarySaturates`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``LiquidPhase`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``Matter`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``MeasuredGeometry`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``Monotone`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``NoInverse`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``Null`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``OneBoundaryThreeFaces`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``Open`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``OperationsClosed`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``OrderIsOnlyFreedom`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``Pair`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``PassImpliesMembership`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``PassIsIdentification`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``PipelineTotal`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``Resistant`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``ResultDeterministic`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``SearchFlow`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``SearchableIffClusteredAndAligned`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``SkillsAreBalls`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``StefanCoupling`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``StepsTerminate`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``StrategyLivesInSigma`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``Structure`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``StructuresFinite`` | Projection.swift:46 | still builds |  |
| ``SaturationMap`` | ``Tower`` | Projection.swift:46 | still builds |  |
| ``Reading`` | ``AxesCoOriented`` | Reading.swift:23 | still builds |  |
| ``Reading`` | ``CachePermanent`` | Reading.swift:23 | still builds |  |
| ``Reading`` | ``HasCache`` | Reading.swift:23 | still builds |  |
| ``Reading`` | ``HasSigma`` | Reading.swift:23 | still builds |  |
| ``Reading`` | ``HasSolutions`` | Reading.swift:23 | still builds |  |
| ``Reading`` | ``HasTime`` | Reading.swift:23 | still builds |  |
| ``Reading`` | ``IdentityCollapse`` | Reading.swift:23 | still builds |  |
| ``Reading`` | ``Measurable`` | Reading.swift:23 | still builds |  |
| ``Reading`` | ``Null`` | Reading.swift:23 | still builds |  |
| ``Reading`` | ``Open`` | Reading.swift:23 | still builds |  |
| ``Reading`` | ``OperationsClosed`` | Reading.swift:23 | still builds |  |
| ``Reading`` | ``OrderIsOnlyFreedom`` | Reading.swift:23 | still builds |  |
| ``Reading`` | ``Pair`` | Reading.swift:23 | still builds |  |
| ``Reading`` | ``ResultDeterministic`` | Reading.swift:23 | still builds |  |
| ``Reading`` | ``RevealsNotCreates`` | Reading.swift:23 | still builds |  |
| ``Reading`` | ``Structure`` | Reading.swift:23 | still builds |  |
| ``Reading`` | ``StructuresFinite`` | Reading.swift:23 | still builds |  |
| ``StandardIsType`` | ``DistanceOnStructures`` | Ruler.swift:18 | still builds |  |
| ``StandardIsType`` | ``HasDistance`` | Ruler.swift:18 | still builds |  |
| ``StandardIsType`` | ``HasLaw`` | Ruler.swift:18 | still builds |  |
| ``StandardIsType`` | ``HasSigma`` | Ruler.swift:18 | still builds |  |
| ``StandardIsType`` | ``Open`` | Ruler.swift:18 | still builds |  |
| ``StandardIsType`` | ``Pair`` | Ruler.swift:18 | still builds |  |
| ``StandardIsType`` | ``PresentedLaw`` | Ruler.swift:18 | still builds |  |
| ``StandardIsType`` | ``Structure`` | Ruler.swift:18 | still builds |  |
| ``StandardIsType`` | ``StructuresFinite`` | Ruler.swift:18 | still builds |  |
| ``MeasureIsCount`` | ``DistanceOnStructures`` | Ruler.swift:28 | still builds |  |
| ``MeasureIsCount`` | ``HasDistance`` | Ruler.swift:28 | still builds |  |
| ``MeasureIsCount`` | ``HasLaw`` | Ruler.swift:28 | still builds |  |
| ``MeasureIsCount`` | ``HasSigma`` | Ruler.swift:28 | still builds |  |
| ``MeasureIsCount`` | ``Open`` | Ruler.swift:28 | still builds |  |
| ``MeasureIsCount`` | ``Pair`` | Ruler.swift:28 | still builds |  |
| ``MeasureIsCount`` | ``PresentedLaw`` | Ruler.swift:28 | still builds |  |
| ``MeasureIsCount`` | ``StandardIsType`` | Ruler.swift:28 | still builds |  |
| ``MeasureIsCount`` | ``Structure`` | Ruler.swift:28 | still builds |  |
| ``MeasureIsCount`` | ``StructuresFinite`` | Ruler.swift:28 | still builds |  |
| ``AlignmentCoefficient`` | ``DistanceOnStructures`` | Search.swift:29 | still builds |  |
| ``AlignmentCoefficient`` | ``GateIsZeroOfLoss`` | Search.swift:29 | still builds |  |
| ``AlignmentCoefficient`` | ``HasAlpha`` | Search.swift:29 | still builds |  |
| ``AlignmentCoefficient`` | ``HasDistance`` | Search.swift:29 | still builds |  |
| ``AlignmentCoefficient`` | ``HasSigma`` | Search.swift:29 | still builds |  |
| ``AlignmentCoefficient`` | ``Open`` | Search.swift:29 | still builds |  |
| ``AlignmentCoefficient`` | ``OperationsClosed`` | Search.swift:29 | still builds |  |
| ``AlignmentCoefficient`` | ``Pair`` | Search.swift:29 | still builds |  |
| ``AlignmentCoefficient`` | ``PassImpliesMembership`` | Search.swift:29 | still builds |  |
| ``AlignmentCoefficient`` | ``PipelineTotal`` | Search.swift:29 | still builds |  |
| ``AlignmentCoefficient`` | ``ResultDeterministic`` | Search.swift:29 | still builds |  |
| ``AlignmentCoefficient`` | ``StepsTerminate`` | Search.swift:29 | still builds |  |
| ``AlignmentCoefficient`` | ``Structure`` | Search.swift:29 | still builds |  |
| ``AlignmentCoefficient`` | ``StructuresFinite`` | Search.swift:29 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``AlignmentCoefficient`` | Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``CachePermanent`` | Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``DistanceOnStructures`` | Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``GateIsZeroOfLoss`` | Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``HasAlpha`` | Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``HasCache`` | Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``HasDistance`` | Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``HasEfficiency`` | Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``HasLibrary`` | Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``HasSaturation`` | Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``HasSigma`` | Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``IntelligenceRises`` | Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``LibrarySaturates`` | Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``Open`` | Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``OperationsClosed`` | Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``Pair`` | Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``PassImpliesMembership`` | Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``PipelineTotal`` | Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``ResultDeterministic`` | Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``StepsTerminate`` | Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``Structure`` | Search.swift:38 | still builds |  |
| ``AlignmentEnablesIntelligence`` | ``StructuresFinite`` | Search.swift:38 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``AlignmentCoefficient`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``AnchorGraph`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``BallSaturation`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``CachePermanent`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``CompressionCriterion`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``Decidable`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``DistanceOnStructures`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``EqualityDecidable`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``ExactlyOneSurvives`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``GateIsZeroOfLoss`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``HasAlpha`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``HasCache`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``HasCost`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``HasDistance`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``HasLibrary`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``HasSaturation`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``HasSigma`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``HasSolutions`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``HasTime`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``Ignites`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``KnowledgeAccumulates`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``LibrarySaturates`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``Matter`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``OneBoundaryThreeFaces`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``Open`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``OperationsClosed`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``Pair`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``PassImpliesMembership`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``PassIsIdentification`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``PipelineTotal`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``Resistant`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``ResultDeterministic`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``StepsTerminate`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``Structure`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``StructuresFinite`` | Search.swift:50 | still builds |  |
| ``SearchableIffClusteredAndAligned`` | ``Tower`` | Search.swift:50 | still builds |  |
| ``EncodingForgets`` | ``HasEncoding`` | Seeing.swift:17 | still builds |  |
| ``EncodingForgets`` | ``HasSigma`` | Seeing.swift:17 | still builds |  |
| ``SeparatorIdentifies`` | ``EncodingForgets`` | Seeing.swift:29 | still builds |  |
| ``SeparatorIdentifies`` | ``HasEncoding`` | Seeing.swift:29 | still builds |  |
| ``SeparatorIdentifies`` | ``HasSigma`` | Seeing.swift:29 | still builds |  |
| ``HasGrammar`` | ``HasEncoding`` | Space.swift:20 | still builds |  |
| ``HasGrammar`` | ``HasSigma`` | Space.swift:20 | still builds |  |
| ``PerspectiveIsEncoding`` | ``HasEncoding`` | Space.swift:30 | still builds |  |
| ``PerspectiveIsEncoding`` | ``HasSigma`` | Space.swift:30 | still builds |  |
| ``PerspectiveIsEncoding`` | ``Measurable`` | Space.swift:30 | still builds |  |
| ``PerspectiveIsEncoding`` | ``Open`` | Space.swift:30 | still builds |  |
| ``PerspectiveIsEncoding`` | ``OperationsClosed`` | Space.swift:30 | still builds |  |
| ``PerspectiveIsEncoding`` | ``Pair`` | Space.swift:30 | still builds |  |
| ``PerspectiveIsEncoding`` | ``ResultDeterministic`` | Space.swift:30 | still builds |  |
| ``PerspectiveIsEncoding`` | ``ScopeBoundedByEncoding`` | Space.swift:30 | still builds |  |
| ``PerspectiveIsEncoding`` | ``Structure`` | Space.swift:30 | still builds |  |
| ``DistanceIsMetric`` | ``HasCache`` | Space.swift:43 | inherited, no line to cut |  |
| ``DistanceIsMetric`` | ``HasDistance`` | Space.swift:43 | inherited, no line to cut |  |
| ``DistanceIsMetric`` | ``HasSigma`` | Space.swift:43 | inherited, no line to cut |  |
| ``SpaceFromDifference`` | ``DistanceIsMetric`` | Space.swift:49 | still builds |  |
| ``SpaceFromDifference`` | ``HasCache`` | Space.swift:49 | still builds |  |
| ``SpaceFromDifference`` | ``HasDistance`` | Space.swift:49 | still builds |  |
| ``SpaceFromDifference`` | ``HasEncoding`` | Space.swift:49 | still builds |  |
| ``SpaceFromDifference`` | ``HasGrammar`` | Space.swift:49 | still builds |  |
| ``SpaceFromDifference`` | ``HasSigma`` | Space.swift:49 | still builds |  |
| ``QualitiesAreFinite`` | ``HasEncoding`` | Space.swift:56 | still builds |  |
| ``QualitiesAreFinite`` | ``HasSigma`` | Space.swift:56 | still builds |  |
| ``QualitiesAreFinite`` | ``IntegerValued`` | Space.swift:56 | still builds |  |
| ``QualitiesAreFinite`` | ``Open`` | Space.swift:56 | still builds |  |
| ``QualitiesAreFinite`` | ``Pair`` | Space.swift:56 | still builds |  |
| ``QualitiesAreFinite`` | ``Structure`` | Space.swift:56 | still builds |  |
| ``CommunicationBounded`` | ``ComparisonsAreBounded`` | Space.swift:61 | still builds |  |
| ``CommunicationBounded`` | ``HasCache`` | Space.swift:61 | still builds |  |
| ``CommunicationBounded`` | ``HasSigma`` | Space.swift:61 | still builds |  |
| ``CommunicationBounded`` | ``Open`` | Space.swift:61 | still builds |  |
| ``CommunicationBounded`` | ``Pair`` | Space.swift:61 | still builds |  |
| ``CommunicationBounded`` | ``Structure`` | Space.swift:61 | still builds |  |
| ``CommunicationBounded`` | ``StructuresFinite`` | Space.swift:61 | still builds |  |
| ``DepthIsBounded`` | ``CachePermanent`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``Decidable`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``EqualityDecidable`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``ExactlyOneSurvives`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``HasCache`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``HasCost`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``HasDistance`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``HasEncoding`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``HasGrammar`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``HasLibrary`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``HasSaturation`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``HasSigma`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``HasSolutions`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``HasTime`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``Ignites`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``KnowledgeAccumulates`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``LibrarySaturates`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``Matter`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``Open`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``OperationsClosed`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``Pair`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``PassImpliesMembership`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``PassIsIdentification`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``PipelineTotal`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``Resistant`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``ResultDeterministic`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``StepsTerminate`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``Structure`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``StructuresFinite`` | Space.swift:65 | still builds |  |
| ``DepthIsBounded`` | ``Tower`` | Space.swift:65 | still builds |  |
| ``EncoderConditions`` | ``BallSaturation`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``CachePermanent`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``CompressionCriterion`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``Decidable`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``DistanceOnStructures`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``EqualityDecidable`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``ExactlyOneSurvives`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``HasCache`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``HasCost`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``HasDistance`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``HasEncoding`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``HasLibrary`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``HasSaturation`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``HasSigma`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``HasSolutions`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``HasTime`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``Ignites`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``KnowledgeAccumulates`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``LibrarySaturates`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``Matter`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``Open`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``OperationsClosed`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``Pair`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``PassImpliesMembership`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``PassIsIdentification`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``PipelineTotal`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``Resistant`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``ResultDeterministic`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``StepsTerminate`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``Structure`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``StructuresFinite`` | Spec.swift:33 | still builds |  |
| ``EncoderConditions`` | ``Tower`` | Spec.swift:33 | still builds |  |
| ``ConditionalSolving`` | ``BallSaturation`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``CachePermanent`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``CompressionCriterion`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``Decidable`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``DistanceOnStructures`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``EncoderConditions`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``EqualityDecidable`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``ExactlyOneSurvives`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``HasCache`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``HasCost`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``HasDistance`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``HasEncoding`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``HasLibrary`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``HasSaturation`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``HasSigma`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``HasSolutions`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``HasTime`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``Ignites`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``KnowledgeAccumulates`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``LibrarySaturates`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``Matter`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``Open`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``OperationsClosed`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``Pair`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``PassImpliesMembership`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``PassIsIdentification`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``PipelineTotal`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``Resistant`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``ResultDeterministic`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``StepsTerminate`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``Structure`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``StructuresFinite`` | Spec.swift:45 | still builds |  |
| ``ConditionalSolving`` | ``Tower`` | Spec.swift:45 | still builds |  |
| ``DifficultyIsEncoder`` | ``BallSaturation`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``CachePermanent`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``CompressionCriterion`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``ConditionalSolving`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``Decidable`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``DistanceOnStructures`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``EncoderConditions`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``EqualityDecidable`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``ExactlyOneSurvives`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``HasCache`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``HasCost`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``HasDistance`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``HasEncoding`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``HasLibrary`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``HasSaturation`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``HasSigma`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``HasSolutions`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``HasTime`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``Ignites`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``KnowledgeAccumulates`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``LibrarySaturates`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``Matter`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``Open`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``OperationsClosed`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``Pair`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``PassImpliesMembership`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``PassIsIdentification`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``PipelineTotal`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``Resistant`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``ResultDeterministic`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``ScopeBoundedByEncoding`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``StepsTerminate`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``Structure`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``StructuresFinite`` | Spec.swift:53 | still builds |  |
| ``DifficultyIsEncoder`` | ``Tower`` | Spec.swift:53 | still builds |  |
| ``MeasuredGeometry`` | ``AlignmentCoefficient`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``AnchorGraph`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``AxesCoOriented`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``BallSaturation`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``CachePermanent`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``CompressionCriterion`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``Decidable`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``DistanceOnStructures`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``EqualityDecidable`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``ExactlyOneSurvives`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``FourthFace`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``GateIsZeroOfLoss`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``HasAlpha`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``HasCache`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``HasCost`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``HasDistance`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``HasLibrary`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``HasSaturation`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``HasSigma`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``HasSolutions`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``HasTime`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``IdentityCollapse`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``Ignites`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``KnowledgeAccumulates`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``LibrarySaturates`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``Matter`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``Null`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``OneBoundaryThreeFaces`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``Open`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``OperationsClosed`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``OrderIsOnlyFreedom`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``Pair`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``PassImpliesMembership`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``PassIsIdentification`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``PipelineTotal`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``Resistant`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``ResultDeterministic`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``SearchableIffClusteredAndAligned`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``SkillsAreBalls`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``StepsTerminate`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``StrategyLivesInSigma`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``Structure`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``StructuresFinite`` | Spec.swift:68 | still builds |  |
| ``MeasuredGeometry`` | ``Tower`` | Spec.swift:68 | still builds |  |
| ``StrategyLivesInSigma`` | ``AxesCoOriented`` | Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``CachePermanent`` | Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``DistanceOnStructures`` | Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``HasCache`` | Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``HasDistance`` | Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``HasSigma`` | Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``HasSolutions`` | Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``IdentityCollapse`` | Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``Null`` | Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``Open`` | Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``OperationsClosed`` | Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``OrderIsOnlyFreedom`` | Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``Pair`` | Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``ResultDeterministic`` | Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``Structure`` | Strategy.swift:23 | still builds |  |
| ``StrategyLivesInSigma`` | ``StructuresFinite`` | Strategy.swift:23 | still builds |  |
| ``StrategyGate`` | ``AxesCoOriented`` | Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``CachePermanent`` | Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``DistanceOnStructures`` | Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``HasCache`` | Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``HasDistance`` | Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``HasSigma`` | Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``HasSolutions`` | Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``IdentityCollapse`` | Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``Null`` | Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``Open`` | Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``OperationsClosed`` | Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``OrderIsOnlyFreedom`` | Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``Pair`` | Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``PassImpliesMembership`` | Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``PipelineTotal`` | Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``ResultDeterministic`` | Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``StepsTerminate`` | Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``StrategyLivesInSigma`` | Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``Structure`` | Strategy.swift:30 | still builds |  |
| ``StrategyGate`` | ``StructuresFinite`` | Strategy.swift:30 | still builds |  |
| ``StrategyIsUnique`` | ``AxesCoOriented`` | Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``CachePermanent`` | Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``DistanceOnStructures`` | Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``EqualityDecidable`` | Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``ExactlyOneSurvives`` | Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``HasCache`` | Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``HasDistance`` | Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``HasSigma`` | Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``HasSolutions`` | Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``IdentityCollapse`` | Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``Null`` | Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``Open`` | Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``OperationsClosed`` | Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``OrderIsOnlyFreedom`` | Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``Pair`` | Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``PassImpliesMembership`` | Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``PipelineTotal`` | Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``ResultDeterministic`` | Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``StepsTerminate`` | Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``StrategyGate`` | Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``StrategyLivesInSigma`` | Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``Structure`` | Strategy.swift:36 | still builds |  |
| ``StrategyIsUnique`` | ``StructuresFinite`` | Strategy.swift:36 | still builds |  |
| ``StrategyCrystallizes`` | ``AxesCoOriented`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``CachePermanent`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``Decidable`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``DistanceOnStructures`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``EqualityDecidable`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``ExactlyOneSurvives`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``HasCache`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``HasDistance`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``HasLibrary`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``HasSigma`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``HasSolutions`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``IdentityCollapse`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``KnowledgeAccumulates`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``Matter`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``Null`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``Open`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``OperationsClosed`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``OrderIsOnlyFreedom`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``Pair`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``PassImpliesMembership`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``PassIsIdentification`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``PipelineTotal`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``Resistant`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``ResultDeterministic`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``StepsTerminate`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``StrategyGate`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``StrategyIsUnique`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``StrategyLivesInSigma`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``Structure`` | Strategy.swift:46 | still builds |  |
| ``StrategyCrystallizes`` | ``StructuresFinite`` | Strategy.swift:46 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``AxesCoOriented`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``CachePermanent`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``Decidable`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``DistanceOnStructures`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``EqualityDecidable`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``ExactlyOneSurvives`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``HasCache`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``HasDistance`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``HasLibrary`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``HasSigma`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``HasSolutions`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``IdentityCollapse`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``KnowledgeAccumulates`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``Matter`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``Null`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``Open`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``OperationsClosed`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``OrderIsOnlyFreedom`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``Pair`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``PassImpliesMembership`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``PassIsIdentification`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``PipelineTotal`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``Resistant`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``ResultDeterministic`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``StepsTerminate`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``StrategyCrystallizes`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``StrategyGate`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``StrategyIsUnique`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``StrategyLivesInSigma`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``Structure`` | Strategy.swift:56 | still builds |  |
| ``PhaseBecomesAmplitude`` | ``StructuresFinite`` | Strategy.swift:56 | still builds |  |
| ``CompleteEntry`` | ``AxesCoOriented`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``CachePermanent`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``Decidable`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``DistanceOnStructures`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``EqualityDecidable`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``ExactlyOneSurvives`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``HasCache`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``HasDistance`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``HasEncoding`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``HasLibrary`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``HasSigma`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``HasSolutions`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``IdentityCollapse`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``KnowledgeAccumulates`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``Matter`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``Null`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``Open`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``OperationsClosed`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``OrderIsOnlyFreedom`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``Pair`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``PassImpliesMembership`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``PassIsIdentification`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``PhaseBecomesAmplitude`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``PipelineTotal`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``Resistant`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``ResultDeterministic`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``StepsTerminate`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``StrategyCrystallizes`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``StrategyGate`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``StrategyIsUnique`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``StrategyLivesInSigma`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``Structure`` | Strategy.swift:63 | still builds |  |
| ``CompleteEntry`` | ``StructuresFinite`` | Strategy.swift:63 | still builds |  |
| ``SkillsAreBalls`` | ``AxesCoOriented`` | Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``BallSaturation`` | Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``CachePermanent`` | Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``DistanceOnStructures`` | Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``HasCache`` | Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``HasDistance`` | Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``HasLibrary`` | Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``HasSaturation`` | Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``HasSigma`` | Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``HasSolutions`` | Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``IdentityCollapse`` | Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``LibrarySaturates`` | Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``Null`` | Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``Open`` | Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``OperationsClosed`` | Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``OrderIsOnlyFreedom`` | Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``Pair`` | Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``ResultDeterministic`` | Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``StrategyLivesInSigma`` | Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``Structure`` | Strategy.swift:70 | still builds |  |
| ``SkillsAreBalls`` | ``StructuresFinite`` | Strategy.swift:70 | still builds |  |
| ``StrategyNavigation`` | ``AnchorGraph`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``AxesCoOriented`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``BallSaturation`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``CachePermanent`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``CompressionCriterion`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``Decidable`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``DistanceOnStructures`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``EqualityDecidable`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``ExactlyOneSurvives`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``HasCache`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``HasCost`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``HasDistance`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``HasLibrary`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``HasSaturation`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``HasSigma`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``HasSolutions`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``HasTime`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``IdentityCollapse`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``Ignites`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``KnowledgeAccumulates`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``LibrarySaturates`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``Matter`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``NavigationInevitable`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``Null`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``OneBoundaryThreeFaces`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``Open`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``OperationsClosed`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``OrderIsOnlyFreedom`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``Pair`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``PassImpliesMembership`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``PassIsIdentification`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``PipelineTotal`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``Resistant`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``ResultDeterministic`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``SkillsAreBalls`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``StepsTerminate`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``StrategyLivesInSigma`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``Structure`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``StructuresFinite`` | Strategy.swift:77 | still builds |  |
| ``StrategyNavigation`` | ``Tower`` | Strategy.swift:77 | still builds |  |
| ``FourthFace`` | ``AnchorGraph`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``AxesCoOriented`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``BallSaturation`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``CachePermanent`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``CompressionCriterion`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``Decidable`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``DistanceOnStructures`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``EqualityDecidable`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``ExactlyOneSurvives`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``HasCache`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``HasCost`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``HasDistance`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``HasLibrary`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``HasSaturation`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``HasSigma`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``HasSolutions`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``HasTime`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``IdentityCollapse`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``Ignites`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``KnowledgeAccumulates`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``LibrarySaturates`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``Matter`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``Null`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``OneBoundaryThreeFaces`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``Open`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``OperationsClosed`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``OrderIsOnlyFreedom`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``Pair`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``PassImpliesMembership`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``PassIsIdentification`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``PipelineTotal`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``Resistant`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``ResultDeterministic`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``SkillsAreBalls`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``StepsTerminate`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``StrategyLivesInSigma`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``Structure`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``StructuresFinite`` | Strategy.swift:88 | still builds |  |
| ``FourthFace`` | ``Tower`` | Strategy.swift:88 | still builds |  |
| ``EncodingInvents`` | ``HasEncoding`` | Voice.swift:20 | still builds |  |
| ``EncodingInvents`` | ``HasSigma`` | Voice.swift:20 | still builds |  |
| ``FaithfulEncoding`` | ``HasEncoding`` | Voice.swift:31 | still builds |  |
| ``FaithfulEncoding`` | ``HasSigma`` | Voice.swift:31 | still builds |  |
| ``InterferenceIsSubstitution`` | ``DistanceOnStructures`` | Wave.swift:19 | still builds |  |
| ``InterferenceIsSubstitution`` | ``HasDistance`` | Wave.swift:19 | still builds |  |
| ``InterferenceIsSubstitution`` | ``HasLaw`` | Wave.swift:19 | still builds |  |
| ``InterferenceIsSubstitution`` | ``HasSigma`` | Wave.swift:19 | still builds |  |
| ``InterferenceIsSubstitution`` | ``Open`` | Wave.swift:19 | still builds |  |
| ``InterferenceIsSubstitution`` | ``Pair`` | Wave.swift:19 | still builds |  |
| ``InterferenceIsSubstitution`` | ``PresentedLaw`` | Wave.swift:19 | still builds |  |
| ``InterferenceIsSubstitution`` | ``Structure`` | Wave.swift:19 | still builds |  |
| ``InterferenceIsSubstitution`` | ``StructuresFinite`` | Wave.swift:19 | still builds |  |
| ``DarknessIsNormalForm`` | ``DistanceOnStructures`` | Wave.swift:29 | still builds |  |
| ``DarknessIsNormalForm`` | ``HasDistance`` | Wave.swift:29 | still builds |  |
| ``DarknessIsNormalForm`` | ``HasLaw`` | Wave.swift:29 | still builds |  |
| ``DarknessIsNormalForm`` | ``HasSigma`` | Wave.swift:29 | still builds |  |
| ``DarknessIsNormalForm`` | ``InterferenceIsSubstitution`` | Wave.swift:29 | still builds |  |
| ``DarknessIsNormalForm`` | ``Open`` | Wave.swift:29 | still builds |  |
| ``DarknessIsNormalForm`` | ``Pair`` | Wave.swift:29 | still builds |  |
| ``DarknessIsNormalForm`` | ``PresentedLaw`` | Wave.swift:29 | still builds |  |
| ``DarknessIsNormalForm`` | ``Structure`` | Wave.swift:29 | still builds |  |
| ``DarknessIsNormalForm`` | ``StructuresFinite`` | Wave.swift:29 | still builds |  |

Every file was put back after its cut, and the module builds.
