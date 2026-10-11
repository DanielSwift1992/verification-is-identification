import VerificationIsIdentification
import Examples

// Generic recovery, not a table of numerical distances.
enum DistanceRegroupingRecoversEveryField<P: Pair>: Null
where P.Left: Pair, P.Right: Pair,
      P.Left.Left: Structure, P.Left.Right: Structure,
      P.Right.Left: Structure, P.Right.Right: Structure {
    typealias Left = DistanceLegsRestored<P>.Left
    typealias Right = DistanceLegsRestored<P>.Right
}

enum DirectPartIsInsideTheActualLegs<P: MetricProperty>: Null
where P.Left.Left: Structure, P.Left.Right: Structure,
      P.Right.Left: Structure, P.Right.Right: Structure {
    typealias Left = CancelDistanceDetour<P>.Right
    typealias Right = Paired<P.Left.Left, P.Right.Right>
}

enum ResidualCopiesComeFromTheSharedPart<P: MetricProperty>: Null
where P.Left.Left: Structure, P.Left.Right: Structure,
      P.Right.Left: Structure, P.Right.Right: Structure {
    typealias Left = DistanceDetourHasTwoCopies<P>.Left
    typealias Right = DistanceDetourHasTwoCopies<P>.Right
}

// The one-node route NULL -> PAIR(NULL,NULL) -> NULL has no direct
// difference and two charged occurrences of its root-address difference.
typealias RootExcursion = Path<Never, Lit1, Never>
typealias CancelledRootExcursion = CancelDistanceDetour<RootExcursion>

enum RootExcursionRetainsBothOccurrences: Null {
    typealias Left = CancelledRootExcursion.Left.Right
    typealias Right = Paired<Lit1, Lit1>
}

enum RootExcursionDirectPartIsEmpty: Null {
    typealias Left = CancelledRootExcursion.Right
    typealias Right = Paired<Never, Never>
}

enum TreePartitionBuildsItsSources<L: TreePartitionShape, R: TreePartitionShape>: Null {
    typealias Left = TreePartition111<L, R>.Left
    typealias Right = AddressTriple<
        Paired<L.Left.Left, R.Left.Left>,
        Paired<L.Left.Right.Left, R.Left.Right.Left>,
        Paired<L.Left.Right.Right, R.Left.Right.Right>
    >
}

enum TreePartitionKeepsTheLeftAddress<L: TreePartitionShape, R: TreePartitionShape>: Null {
    typealias Left = TreePartition111<L, R>.Right.Left.Right.Left
    typealias Right = L.Right.Left
}

enum TreePartitionKeepsTheRightAddress<L: TreePartitionShape, R: TreePartitionShape>: Null {
    typealias Left = TreePartition111<L, R>.Right.Left.Right.Right
    typealias Right = R.Right.Left
}

enum PartitionSuppliesTheDirectDifference<P: TreePartitionShape>: Null {
    typealias Left = PartitionedTreeDistance<P>.Right
    typealias Right = Paired<P.Right.Left, P.Right.Right.Right>
}

typealias EmptyPartition = EmptyTreePartition
typealias OnlyFirstRoot = TreePartition100<EmptyPartition, EmptyPartition>
typealias OnlyMiddleRoot = TreePartition010<EmptyPartition, EmptyPartition>
typealias OnlyLastRoot = TreePartition001<EmptyPartition, EmptyPartition>
typealias FirstMiddleRoots = TreePartition110<EmptyPartition, EmptyPartition>
typealias FirstLastRoots = TreePartition101<EmptyPartition, EmptyPartition>
typealias MiddleLastRoots = TreePartition011<EmptyPartition, EmptyPartition>
typealias AllThreeRoots = TreePartition111<EmptyPartition, EmptyPartition>
typealias OneTreeNode = Paired<Never, Never>

// A round edits a compatible frontier in the actual input. Two disjoint
// child changes need one round, while creating their parent needs another.
typealias IdleTreeLeaf = IdentityReading<Never, Never, Never>
typealias GrowOneTreeRoot = GrowTreeRoot<Never, Never>
typealias ShrinkOneTreeRoot = ShrinkTreeRoot<Never, Never>
typealias GrowBothTreeChildren = PairedTreeRound<GrowOneTreeRoot, GrowOneTreeRoot>
typealias GrowTreeInTwoRounds = SequentialReading<GrowOneTreeRoot, GrowBothTreeChildren>
typealias ThreeTreeNodes = Paired<OneTreeNode, OneTreeNode>

enum TwoRoundsBuildThreeActualNodes: Null {
    typealias Left = Paired<GrowTreeInTwoRounds.Left, GrowTreeInTwoRounds.Answer>
    typealias Right = Paired<Never, ThreeTreeNodes>
}

typealias IndependentGrowthAndShrinkage = IndependentReadingOrders<GrowOneTreeRoot, ShrinkOneTreeRoot>
typealias CompatibleGrowthAndShrinkage = PairedTreeRound<GrowOneTreeRoot, ShrinkOneTreeRoot>

// MiC3: independent partial repairs can jointly satisfy a two-part target
// even when neither branch alone satisfies the complete target.
typealias TwoIndependentRootConstructions = IndependentReadingOrders<GrowOneTreeRoot, GrowOneTreeRoot>
typealias FirstRootOnly = PairedApplication<GrowOneTreeRoot, IdleTreeLeaf>
typealias SecondRootOnly = PairedApplication<IdleTreeLeaf, GrowOneTreeRoot>

enum MergedRootsSatisfyBothRequirements: Null {
    typealias Left = TwoIndependentRootConstructions.Together.Answer
    typealias Right = Paired<OneTreeNode, OneTreeNode>
}

enum EachSeparateBranchHasAnAbsentRequiredRoot: Null {
    typealias Left = Paired<FirstRootOnly.Answer.Right, SecondRootOnly.Answer.Left>
    typealias Right = Paired<Never, Never>
}

#if DISTANCE_MERGE_SUCCESS_FORCES_BRANCH_SUCCESS
enum RejectedMergeImpliesBranchSuccess: Null {
    typealias Left = Paired<FirstRootOnly.Answer, SecondRootOnly.Answer>
    typealias Right = Paired<
        TwoIndependentRootConstructions.Together.Answer,
        TwoIndependentRootConstructions.Together.Answer
    >
}
#endif

enum BothSequentialOrdersMatchOneCompatibleRound: Null {
    typealias Left = Paired<
        IndependentGrowthAndShrinkage.FirstThenSecond.Answer,
        IndependentGrowthAndShrinkage.SecondThenFirst.Answer
    >
    typealias Right = Paired<CompatibleGrowthAndShrinkage.Answer, CompatibleGrowthAndShrinkage.Answer>
}

// Record the full lifted applications and their actual source addresses.
typealias BeforeIndependentEdits = CompatibleGrowthAndShrinkage.Left
typealias IndependentEditRecords = RecordedIndependentOrders<GrowOneTreeRoot, ShrinkOneTreeRoot>
typealias GrowthThenShrinkageRecord = IndependentEditRecords.FirstRecord
typealias ShrinkageThenGrowthRecord = IndependentEditRecords.SecondRecord

// The local rule is identical on both sides. Its addressed occurrence is not.
typealias SameRuleAtTwoSides = RecordedIndependentOrders<GrowOneTreeRoot, GrowOneTreeRoot>

enum SameLocalRulesHaveOneFinalRegion: Null {
    typealias Left = Paired<
        SameRuleAtTwoSides.FirstThenSecond.Answer,
        SameRuleAtTwoSides.SecondThenFirst.Answer>
    typealias Right = Paired<ThreeTreeNodes, ThreeTreeNodes>
}

enum FirstRecordedApplicationsRetainTheirDifferentPlaces: Null {
    typealias Left = Paired<
        SameRuleAtTwoSides.FirstRecord.Right.Left.Right.Answer,
        SameRuleAtTwoSides.SecondRecord.Right.Left.Right.Answer>
    typealias Right = Paired<FirstRootOnly.Answer, SecondRootOnly.Answer>
}

enum BothRecordedOrdersRecoverTheSameSource: Null {
    typealias Left = Paired<
        SameRuleAtTwoSides.FirstRecord.Right.Left.Left,
        SameRuleAtTwoSides.SecondRecord.Right.Left.Left>
    typealias Right = Paired<FirstRootOnly.Left, SecondRootOnly.Left>
}

#if DISTANCE_SAME_LOCAL_RULE_ERASES_ORDER
enum RejectedSameLocalRuleOrder: Null {
    typealias Left = SameRuleAtTwoSides.FirstRecord.Right
    typealias Right = SameRuleAtTwoSides.SecondRecord.Right
}
#endif

#if DISTANCE_ROUND_CREATES_PARENT_AND_CHILD
typealias RejectedAbsentRoundParent = SequentialReading<IdleTreeLeaf, GrowBothTreeChildren>
#endif

#if DISTANCE_ROUND_SHRINKS_NONLEAF
typealias RejectedShrinkNonleaf = SequentialReading<GrowTreeInTwoRounds, ShrinkOneTreeRoot>
#endif

#if DISTANCE_ROUND_CHANGES_CONTEXT
typealias RejectedRoundContext = PairedTreeRound<GrowOneTreeRoot, GrowTreeRoot<Lit1, Never>>
#endif

#if DISTANCE_INDEPENDENCE_ERASES_HISTORY
enum RejectedIndependentHistoryCollapse: Null {
    typealias Left = GrowthThenShrinkageRecord.Right
    typealias Right = ShrinkageThenGrowthRecord.Right
}
#endif

#if DISTANCE_TWO_ROUNDS_ARE_ONE_ROUND
typealias RejectedRoundCountCollapse = PairedTreeRound<GrowTreeInTwoRounds, IdleTreeLeaf>
#endif

// One retaining append shifts the old tree below L. Its structural edit
// distance need not be one: here X contains R, and Z contains L and LR.
typealias BeforeAppend = Paired<Never, OneTreeNode>
typealias RetainingAppend = RetainedWhole<BeforeAppend, Never>
typealias AppendPartition = TreePartition101<
    TreePartition001<EmptyPartition, OnlyLastRoot>, OnlyFirstRoot
>
enum AppendPartitionUsesActualTransition: Null {
    typealias Left = AppendPartition.Left
    typealias Right = AddressTriple<RetainingAppend.Left, Never, RetainingAppend.Right>
}
enum AppendHasThreeOccupiedDifferenceAddresses: Null {
    typealias X = AppendPartition.Right.Left
    typealias Z = AppendPartition.Right.Right.Right
    typealias Left = AddressTriple<X.Right.Right.Left, Z.Right.Left.Left, Z.Right.Left.Right.Right.Left>
    typealias Right = AddressTriple<Lit1, Lit1, Lit1>
}

// The same append context preserves pairwise distinctions: both direct
// masks move below L. E supplies equal actual first/last event trees.
enum CommonAppendPreservesDirectMasks<P: TreePartitionShape, E: ZeroTreeDifference>: Null {
    typealias Extended = TreePartition111<P, E>
    typealias Left = Paired<Extended.Right.Left.Right.Left, Extended.Right.Right.Right.Right.Left>
    typealias Right = PartitionedTreeDistance<P>.Right
}

enum CommonAppendUsesEqualActualEvents<P: TreePartitionShape, E: ZeroTreeDifference>: Null {
    typealias Extended = TreePartition111<P, E>
    typealias Left = Extended.Left.Left.Right
    typealias Right = Extended.Left.Right.Right.Right
}

#if DISTANCE_APPEND_PRESERVES_OLD_ADDRESS
enum RejectedAppendAddressPreservation: Null {
    typealias Left = RetainingAppend.Right.Right
    typealias Right = RetainingAppend.Left.Right
}
#endif

typealias RootPartition<P: TreePartitionShape> = AddressTriple<P.Right.Left.Left, P.Right.Right.Left.Left, P.Right.Right.Right.Left>
where P.Right.Left: Pair, P.Right.Right.Left: Pair, P.Right.Right.Right: Pair,
      P.Right.Left.Left: Structure, P.Right.Right.Left.Left: Structure, P.Right.Right.Right.Left: Structure

// Three complementary pairs exhaust the nonconstant binary root cases.
enum RootOutliersUseTheActualRootBits: Null {
    typealias Left = AddressTriple<
        Paired<RootPartition<OnlyFirstRoot>, RootPartition<MiddleLastRoots>>,
        Paired<RootPartition<OnlyMiddleRoot>, RootPartition<FirstLastRoots>>,
        Paired<RootPartition<OnlyLastRoot>, RootPartition<FirstMiddleRoots>>
    >
    typealias X = AddressTriple<Lit1, Never, Never>
    typealias Y = AddressTriple<Never, Lit1, Never>
    typealias Z = AddressTriple<Never, Never, Lit1>
    typealias Right = AddressTriple<Paired<X, X>, Paired<Y, Y>, Paired<Z, Z>>
}

enum RootAgreementHasNoOutlier: Null {
    typealias Left = AddressTriple<AllThreeRoots.Right.Left.Left, AllThreeRoots.Right.Right.Left.Left, AllThreeRoots.Right.Right.Right.Left>
    typealias Right = EmptyPartition.Right
}

// The first extra node is on L, the middle extra node on R. The last
// tree has only the common root. This exercises actual unequal depths.
typealias SplitTreePartition = TreePartition111<OnlyFirstRoot, OnlyMiddleRoot>

enum SplitPartitionNamesTheActualTrees: Null {
    typealias Left = SplitTreePartition.Left
    typealias Right = AddressTriple<Paired<OneTreeNode, Never>, Paired<Never, OneTreeNode>, OneTreeNode>
}

enum SplitPartitionLocatesTheDirectDifference: Null {
    typealias Left = PartitionedTreeDistance<SplitTreePartition>.Right.Left
    typealias Right = AddressTriple<Never, AddressTriple<Lit1, Never, Never>, AddressTriple<Never, Never, Never>>
}

enum SplitPartitionLocatesTheDetour: Null {
    typealias Left = PartitionedTreeDistance<SplitTreePartition>.Left.Right
    typealias Mask = AddressTriple<Never, AddressTriple<Never, Never, Never>, AddressTriple<Lit1, Never, Never>>
    typealias Right = Paired<Mask, Mask>
}

// Positive boundary: an open shape protocol is not the finite constructor
// grammar. This counterfeit source/mask pair compiles as a shape. It must
// never be cited as a generated partition or a theorem about all conformers.
enum ArbitraryPartitionShape: TreePartitionShape {
    typealias Left = EmptyPartition.Left
    typealias Right = AddressTriple<AddressTriple<Lit1, Never, Never>, Never, Never>
}

enum ShapeAloneCanNameAnUnsupportedDifference: Null {
    typealias Left = PartitionedTreeDistance<ArbitraryPartitionShape>.Right.Left.Left
    typealias Right = Lit1
}

// Consumers receive both the mask constraint and the endpoint equation
// from the constructor conformances. No endpoint equality is supplied here.
enum EndpointsFromZeroDistance<P: ZeroTreeDifference>: Null {
    typealias Left = P.Left.Left
    typealias Right = P.Left.Right.Right
}

enum RootOfEmptyMask<M: EmptyAddressMask>: Null {
    typealias Left = M.Left
    typealias Right = Never
}

typealias PaddedMaskIsEmpty = RootOfEmptyMask<AllThreeRoots.Right.Left>
typealias ZeroWithNonemptyMiddle = EndpointsFromZeroDistance<OnlyMiddleRoot>
typealias NestedZeroPartition = TreePartition111<FirstLastRoots, OnlyMiddleRoot>
typealias NestedZeroSourcesAgree = EndpointsFromZeroDistance<NestedZeroPartition>

enum NestedZeroKeepsTheActualEndpoint: Null {
    typealias Left = NestedZeroSourcesAgree.Left
    typealias Right = Paired<OneTreeNode, Never>
}

// Recursive associated types need not terminate, even when every reachable
// finite address is empty. EmptyAddressMask makes no finiteness claim.
enum RecursiveEmptyMask: EmptyAddressMask {
    typealias Left = Never
    typealias Right = Paired<RecursiveEmptyMask, RecursiveEmptyMask>
}
typealias RecursiveZeroRoot = RootOfEmptyMask<RecursiveEmptyMask>

// Positive nonzero evidence names the actual source, the selected direct
// mask and the projection path ending at its occupied address.
typealias SplitFirstMask = SplitTreePartition.Right.Left
typealias SplitLeftOccupancy = ReadMaskLeft<
    SplitFirstMask, ReadMaskRoot<SplitFirstMask.Right.Left, Never, Never>
>
typealias SelectSplitFirstMask = FirstEvidenceImage<
    PartitionedTreeDistance<SplitTreePartition>.Right, Never, Never, FirstProjection
>
typealias SplitDifferenceReading = SequentialReading<SelectSplitFirstMask, SplitLeftOccupancy>
typealias LocatedSplitDifference = TreeDifferenceAt<SplitTreePartition, SplitDifferenceReading>

typealias LastRootDifferenceReading = SequentialReading<
    SecondEvidenceImage<PartitionedTreeDistance<OnlyLastRoot>.Right, Never, Never, SecondProjection>,
    ReadMaskRoot<OnlyLastRoot.Right.Right.Right, Never, Never>
>
typealias LocatedLastRootDifference = TreeDifferenceAt<OnlyLastRoot, LastRootDifferenceReading>

enum LocatedDifferenceRetainsItsSources: Null {
    typealias Left = LocatedSplitDifference.Left
    typealias Right = SplitTreePartition.Left
}

enum LocatedDifferenceReadsAnOccupiedAddress: Null {
    typealias Left = LocatedSplitDifference.Right.Answer
    typealias Right = Lit1
}

enum MaskRootIsComputed<M: Pair, S, E>: Null {
    typealias Left = ReadMaskRoot<M, S, E>.Answer
    typealias Right = M.Left
}

enum LeftMaskPathKeepsItsSource<M: Pair, T: PredicateReading>: Null
where M.Right: Pair, T.Left == M.Right.Left {
    typealias Left = ReadMaskLeft<M, T>.Left
    typealias Right = M
}

// Strict progress needs an occupied X, not just a positive direct distance.
typealias RemoveLastNode = StrictTreeProgress<
    OnlyFirstRoot, ReadMaskRoot<OnlyFirstRoot.Right.Left, Never, Never>
>
typealias AddTargetNode = StrictTreeProgress<
    MiddleLastRoots, ReadMaskRoot<MiddleLastRoots.Right.Left, Never, Never>
>

// A strict improvement in one output extends to a pair of outputs if the
// other output introduces no detour. The reading is transported to the
// actual child mask, not copied with a newly declared answer.
typealias FirstImprovesSecondWaits = PairedTreeProgress<
    OnlyFirstRoot, OnlyLastRoot, ReadMaskRoot<OnlyFirstRoot.Right.Left, Never, Never>
>
typealias BothOutputsImprove = PairedTreeProgress<
    OnlyFirstRoot, MiddleLastRoots, ReadMaskRoot<OnlyFirstRoot.Right.Left, Never, Never>
>

enum ProgressUsesActualOutputBatch: Null {
    typealias Left = FirstImprovesSecondWaits.Sources
    typealias Right = AddressTriple<Paired<OneTreeNode, Never>, OneTreeNode, Paired<Never, OneTreeNode>>
}

// Two candidate projection rules applied to the same actual input.
// Replacing first-projection by second-projection reaches this target.
// The opposite input below shows why the application seam is essential.
typealias ProjectionInput = Paired<OneTreeNode, Never>
typealias OldProjectionRule = FirstEvidenceImage<ProjectionInput, Never, Never, FirstProjection>
typealias NewProjectionRule = SecondEvidenceImage<ProjectionInput, Never, Never, SecondProjection>
typealias ActualProjectionProgress = TreeReadingProgress<
    OldProjectionRule, NewProjectionRule, OnlyFirstRoot,
    ReadMaskRoot<OnlyFirstRoot.Right.Left, Never, Never>
>
typealias OppositeProjectionInput = Paired<Never, OneTreeNode>
typealias OppositeOldRule = FirstEvidenceImage<OppositeProjectionInput, Never, Never, FirstProjection>
typealias OppositeNewRule = SecondEvidenceImage<OppositeProjectionInput, Never, Never, SecondProjection>

#if DISTANCE_PROGRESS_IGNORES_APPLICATION
typealias RejectedProgressForOtherApplication = TreeReadingProgress<
    OppositeOldRule, OppositeNewRule, OnlyFirstRoot,
    ReadMaskRoot<OnlyFirstRoot.Right.Left, Never, Never>
>
#endif

#if DISTANCE_PROGRESS_CHANGES_INPUT
typealias RejectedProgressAcrossInputs = TreeReadingProgress<
    OldProjectionRule, OppositeOldRule, OnlyFirstRoot,
    ReadMaskRoot<OnlyFirstRoot.Right.Left, Never, Never>
>
#endif

#if DISTANCE_PROGRESS_CHANGES_CONTEXT
typealias OtherContextNewRule = SecondEvidenceImage<ProjectionInput, Lit1, Never, SecondProjection>
typealias RejectedProgressAcrossContexts = TreeReadingProgress<
    OldProjectionRule, OtherContextNewRule, OnlyFirstRoot,
    ReadMaskRoot<OnlyFirstRoot.Right.Left, Never, Never>
>
#endif

// A smaller scalar loss need not be address-monotone: remove two left
// nodes and introduce one right node, with the common root as target.
typealias LowerLossWithDetour = TreePartition111<
    TreePartition100<OnlyFirstRoot, EmptyPartition>, OnlyMiddleRoot
>

#if DISTANCE_PROGRESS_WITHOUT_REMOVAL
typealias RejectedStationaryProgress = StrictTreeProgress<
    OnlyLastRoot, ReadMaskRoot<OnlyLastRoot.Right.Left, Never, Never>
>
#endif

#if DISTANCE_PROGRESS_FROM_REMAINING_MASK
typealias RejectedRemainingAsRemoved = StrictTreeProgress<
    OnlyLastRoot, ReadMaskRoot<OnlyLastRoot.Right.Right.Right, Never, Never>
>
#endif

#if DISTANCE_PROGRESS_WITH_DETOUR
typealias RejectedDetourProgress = StrictTreeProgress<SplitTreePartition, SplitLeftOccupancy>
#endif

#if DISTANCE_PROGRESS_HIDES_SECOND_OUTPUT
typealias RejectedBatchDetour = PairedTreeProgress<
    OnlyFirstRoot, OnlyMiddleRoot, ReadMaskRoot<OnlyFirstRoot.Right.Left, Never, Never>
>
#endif

#if DISTANCE_SCALAR_DESCENT_IS_GEODESIC
typealias LowerLossRemovedMask = LowerLossWithDetour.Right.Left
typealias RejectedScalarAsGeodesic = StrictTreeProgress<
    LowerLossWithDetour,
    ReadMaskLeft<LowerLossRemovedMask, ReadMaskRoot<LowerLossRemovedMask.Right.Left, Never, Never>>
>
#endif

#if DISTANCE_NONZERO_AT_EMPTY_ADDRESS
typealias EmptyRightOccupancy = ReadMaskRight<
    SplitFirstMask, ReadMaskRoot<SplitFirstMask.Right.Right, Never, Never>
>
typealias RejectedEmptyAddressDifference = TreeDifferenceAt<
    SplitTreePartition, SequentialReading<SelectSplitFirstMask, EmptyRightOccupancy>
>
#endif

#if DISTANCE_NONZERO_WRONG_CHILD_SEAM
typealias RejectedNonzeroChildSeam = ReadMaskRight<
    SplitFirstMask, ReadMaskRoot<SplitFirstMask.Right.Left, Never, Never>
>
#endif

#if DISTANCE_NONZERO_WRONG_SOURCE_TRIPLE
typealias RejectedNonzeroSourceTriple = TreeDifferenceAt<OnlyFirstRoot, SplitDifferenceReading>
#endif

#if DISTANCE_DETOUR_IS_DIRECT_NONZERO
typealias RejectedDetourAsDirectDifference = TreeDifferenceAt<
    OnlyMiddleRoot, ReadMaskRoot<OnlyMiddleRoot.Right.Right.Left, Never, Never>
>
#endif

#if DISTANCE_OCCUPIED_MASK_IS_EMPTY
typealias RejectedOccupiedMask = RootOfEmptyMask<OnlyFirstRoot.Right.Left>
#endif

#if DISTANCE_EMPTY_ROOT_HIDES_OCCUPIED_MASK_CHILD
typealias RejectedOccupiedMaskChild = RootOfEmptyMask<SplitTreePartition.Right.Left>
#endif

#if DISTANCE_EMPTY_MASK_IS_NEVER
enum RejectedPaddedMaskCollapse: Null {
    typealias Left = AllThreeRoots.Right.Left
    typealias Right = Never
}
#endif

#if DISTANCE_EQUAL_ROOTS_HIDE_DIFFERENT_CHILDREN
typealias RejectedZeroFromEqualRoots = EndpointsFromZeroDistance<SplitTreePartition>
#endif

#if DISTANCE_ZERO_ENDPOINTS_ERASE_DETOUR
typealias RejectedZeroDetour = RootOfEmptyMask<OnlyMiddleRoot.Right.Right.Left>
#endif

#if DISTANCE_FORGED_ZERO_MASK
enum RejectedZeroWithOccupiedMask: ZeroTreeDifference {
    typealias Left = ArbitraryPartitionShape.Left
    typealias Right = ArbitraryPartitionShape.Right
}
#endif

#if DISTANCE_FORGED_ZERO_SOURCES
enum RejectedZeroWithUnequalSources: ZeroTreeDifference {
    typealias Left = OnlyFirstRoot.Left
    typealias Right = EmptyPartition.Right
}
#endif

#if DISTANCE_HIDDEN_FIRST_CHILD
typealias RejectedHiddenFirstChild = TreePartition001<OnlyFirstRoot, EmptyPartition>
#endif

#if DISTANCE_HIDDEN_MIDDLE_CHILD
typealias RejectedHiddenMiddleChild = TreePartition101<EmptyPartition, OnlyMiddleRoot>
#endif

#if DISTANCE_HIDDEN_LAST_CHILD
typealias RejectedHiddenLastChild = TreePartition110<OnlyLastRoot, EmptyPartition>
#endif

#if DISTANCE_SWAPS_TREE_ADDRESSES
enum RejectedTreeAddressSwap: Null {
    typealias Left = SplitTreePartition.Left.Left
    typealias Right = Paired<Never, OneTreeNode>
}
#endif

#if DISTANCE_MOVES_DETOUR
enum RejectedDetourAddressMove: Null {
    typealias Left = PartitionedTreeDistance<SplitTreePartition>.Left.Right.Left
    typealias Right = AddressTriple<Never, AddressTriple<Lit1, Never, Never>, AddressTriple<Never, Never, Never>>
}
#endif

#if DISTANCE_ERASES_DETOUR
enum RejectedDistanceErasure: Null {
    typealias Left = CancelledRootExcursion.Left.Right.Left
    typealias Right = Never
}
#endif

#if DISTANCE_CHANGES_DIRECT_PART
enum RejectedDistanceRetargeting: Null {
    typealias Left = CancelDistanceDetour<Path<Lit1, Never, Never>>.Right
    typealias Right = Paired<Never, Never>
}
#endif

#if DISTANCE_UNSHARED_PART
enum RejectedDistanceSeam: MetricProperty {
    typealias Left = Paired<Never, Lit1>
    typealias Right = Paired<Never, Never>
}
#endif
