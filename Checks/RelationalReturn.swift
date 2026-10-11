import VerificationIsIdentification
import Examples

// Relabel both ends of an arbitrary operation and transform its question.
// Actual swap/projection compositions derive the same answer. H's source is
// a constructed pair so the inverse readdressing recovers that exact source.
enum RelabelledOperationKeepsReadAnswer<
    A: Structure, B: Structure, H: PredicateReading
>: Null
where H.Left == Paired<A, B>, H.Answer: Pair,
      H.Answer.Left: Structure, H.Answer.Right: Structure,
      H.Sigma == BeamSpace, H.Encoding == SaturationEncoding {
    typealias NewSource = SwapBoundaryReading<H.Left>
    typealias Restore = SwapBoundaryReading<NewSource.Answer>
    typealias Run = SequentialReading<Restore, H>
    typealias ReframeOutput = SwapBoundaryReading<Run.Answer>
    typealias NewOperation = SequentialReading<Run, ReframeOutput>
    typealias OldQuestion = FirstEvidenceImage<
        H.Answer, BeamSpace, SaturationEncoding, FirstProjection>
    typealias NewQuestion = SecondEvidenceImage<
        NewOperation.Answer, BeamSpace, SaturationEncoding, SecondProjection>
    typealias OldReading = SequentialReading<H, OldQuestion>
    typealias NewReading = SequentialReading<NewOperation, NewQuestion>
    typealias Left = OldReading.Answer
    typealias Right = NewReading.Answer
}

typealias ReframedUnequalReturn = RelabelledOperationKeepsReadAnswer<
    Never, Lit1, SwapBoundaryReading<Paired<Never, Lit1>>>
typealias UnchangedFrameQuestion = FirstEvidenceImage<
    ReframedUnequalReturn.NewOperation.Answer,
    BeamSpace, SaturationEncoding, FirstProjection>
typealias WrongFrameReading = SequentialReading<
    ReframedUnequalReturn.NewOperation, UnchangedFrameQuestion>
typealias FrameQuestionDifference = SuccessorZeroBoundaryPairClass<
    Paired<ReframedUnequalReturn.OldReading.Answer, WrongFrameReading.Answer>, Never>

#if RETURN_RELABEL_WITH_UNCHANGED_QUESTION
enum RejectedUnchangedFrameQuestion: Null {
    typealias Left = ReframedUnequalReturn.OldReading.Answer
    typealias Right = WrongFrameReading.Answer
}
#endif

// Universal consequence and a realization for every component type.
enum ReturnAgreementDerived<C: Null>: Null
where C.Left: Pair, C.Right: Pair,
      C.Right.Left == C.Left.Right, C.Right.Right == C.Left.Left {
    typealias Left = SwapReturnForcesAgreement<C>.Left
    typealias Right = SwapReturnForcesAgreement<C>.Right
}

enum EveryDiagonalReturns<A: Structure>: Null {
    typealias Left = DiagonalSwapReturn<A>.Left
    typealias Right = DiagonalSwapReturn<A>.Right
}

enum CommonReturnFactKeepsValue<A: Structure>: Null {
    typealias Left = SwapReturnBoundary<DiagonalSwapReturn<A>>.Answer.Answer
    typealias Right = A
}

// Equal relational answers do not identify the represented sources.
typealias ReturnAtZero = DiagonalSwapReturn<Never>
typealias ReturnAtOne = DiagonalSwapReturn<Lit1>
typealias DifferentReturnedValues = ZeroSuccessorBoundaryPairClass<
    Paired<ReturnAtZero.Left.Left, ReturnAtOne.Left.Left>, Never
>

typealias UnequalIdentityReturn = IdentityPairReturn<Never, Lit1>
typealias IdentityStillSeparates = ZeroSuccessorBoundaryPairClass<
    UnequalIdentityReturn.Left, Never
>
typealias UnequalDoubleReturn = DoubleSwapReturn<Never, Lit1>
typealias DoubleStillSeparates = ZeroSuccessorBoundaryPairClass<
    UnequalDoubleReturn.Right, Never
>
typealias DoubleIntermediateSeparates = SuccessorZeroBoundaryPairClass<
    UnequalDoubleReturn.First.Answer, Never
>

// This open swap is a positive unequal return-seam comparison. Rejection
// below is supported by those addressed zero/successor witnesses.
typealias OpenReturnPair = Paired<Never, Lit1>
typealias OpenReturnSwap = SwapBoundaryReading<OpenReturnPair>
typealias OpenSeamDifference = ZeroSuccessorBoundaryPairClass<
    Paired<OpenReturnSwap.Left.Left, OpenReturnSwap.Answer.Left>, Never
>

#if RETURN_UNEQUAL_ZERO_ONE
enum RejectedReturnZeroOne: Null {
    typealias Left = OpenReturnSwap.Left
    typealias Right = OpenReturnSwap.Answer
}
#endif

#if RETURN_UNEQUAL_ONE_ZERO
enum RejectedReturnOneZero: Null {
    typealias Left = Paired<Lit1, Never>
    typealias Right = SwapBoundaryReading<Left>.Answer
}
#endif

#if RETURN_FORCES_VALUE
enum RejectedReturnValue: Null {
    typealias Left = ReturnAtZero.Left.Left
    typealias Right = ReturnAtOne.Left.Left
}
#endif

#if RETURN_IDENTITY_FORCES_AGREEMENT
typealias RejectedIdentityCrossing = SwapReturnForcesAgreement<UnequalIdentityReturn>
#endif

#if RETURN_DOUBLE_FORCES_AGREEMENT
enum RejectedDoubleAgreement: Null {
    typealias Left = UnequalDoubleReturn.Right.Left
    typealias Right = UnequalDoubleReturn.Right.Right
}
#endif

#if RETURN_INTERMEDIATE_IS_ENDPOINT
enum RejectedIntermediateReturn: Null {
    typealias Left = UnequalDoubleReturn.First.Answer
    typealias Right = UnequalDoubleReturn.Left
}
#endif

// IiS21 derives e_j = +/- e_i from saturated overlap relations. The two
// orientations below use the existing pair exchange. Accessors are actual
// fields of one assignment, not independent phase values supplied per edge.
typealias CycleFirst<W: Pair> = FirstEvidenceImage<
    W, BeamSpace, SaturationEncoding, FirstProjection>
typealias CycleSecond<W: Pair> = SequentialReading<
    SecondEvidenceImage<W, BeamSpace, SaturationEncoding, SecondProjection>,
    FirstEvidenceImage<W.Right, BeamSpace, SaturationEncoding, FirstProjection>
> where W.Right: Pair
typealias CycleThird<W: Pair> = SequentialReading<
    SecondEvidenceImage<W, BeamSpace, SaturationEncoding, SecondProjection>,
    SecondEvidenceImage<W.Right, BeamSpace, SaturationEncoding, SecondProjection>
> where W.Right: Pair

// The contact retains its actual transport and both actual accessors.
enum ContactRetainsApplication<A: PredicateReading, B: PredicateReading,
                              T: PredicateReading>: Null
where A.Left: Structure, A.Left == B.Left, A.Sigma == B.Sigma, A.Encoding == B.Encoding,
      T.Sigma == A.Sigma, T.Encoding == A.Encoding,
      T.Left == A.Answer, T.Answer == B.Answer {
    typealias C = ResidentTransportContact<A, B, T>
    typealias Left = Paired<C.Left, C.Answer>
    typealias Right = Paired<A.Left, Paired<Paired<A, B>, T>>
}

// All three local equations refer to one W. Their consequence is the
// collapse of its first frame's two sides, not a supplied A == B premise.
enum CommonOddCycleForcesCollapse<W: Pair>: Null
where W.Left: Pair, W.Right: Pair, W.Right.Left: Pair, W.Right.Right: Pair,
      W.Right.Left.Left == W.Left.Left, W.Right.Left.Right == W.Left.Right,
      W.Right.Right.Left == W.Right.Left.Left, W.Right.Right.Right == W.Right.Left.Right,
      W.Right.Right.Right == W.Left.Left, W.Right.Right.Left == W.Left.Right {
    typealias Left = ThreePhaseContactsForceCollapse<W>.Left
    typealias Right = ThreePhaseContactsForceCollapse<W>.Right
}

// A diagonal frame admits the collapse. Its scalar interpretation is zero,
// so it cannot supply the unit residual vector required in the paper.
enum DiagonalOddCycle<X: Structure>: Null {
    typealias F = Paired<X, X>
    typealias W = Paired<F, Paired<F, F>>
    typealias Left = CommonOddCycleForcesCollapse<W>.Left
    typealias Right = CommonOddCycleForcesCollapse<W>.Right
}

typealias PhaseRoot = Paired<Lit1, Never>
typealias PhaseReversed = SwapBoundaryReading<PhaseRoot>.Answer
typealias PhaseRootContrast = SuccessorZeroBoundaryPairClass<PhaseRoot, Never>

// Remove CA, AB, or BC respectively. Each remaining tree has a common
// assignment. These are positive constructions for the local contacts.
typealias PhaseTreeA = Paired<PhaseRoot, Paired<PhaseRoot, PhaseRoot>>
typealias PhaseTreeB = Paired<PhaseRoot, Paired<PhaseReversed, PhaseReversed>>
typealias PhaseTreeC = Paired<PhaseRoot, Paired<PhaseRoot, PhaseReversed>>

typealias PhaseA_AB = ResidentTransportContact<CycleFirst<PhaseTreeA>,
    CycleSecond<PhaseTreeA>, IdentityReading<PhaseRoot, BeamSpace, SaturationEncoding>>
typealias PhaseA_BC = ResidentTransportContact<CycleSecond<PhaseTreeA>,
    CycleThird<PhaseTreeA>, IdentityReading<PhaseRoot, BeamSpace, SaturationEncoding>>
typealias PhaseAContacts = JointEvidence<PhaseA_AB, PhaseA_BC>

typealias PhaseB_BC = ResidentTransportContact<CycleSecond<PhaseTreeB>,
    CycleThird<PhaseTreeB>, IdentityReading<PhaseReversed, BeamSpace, SaturationEncoding>>
typealias PhaseB_CA = ResidentTransportContact<CycleThird<PhaseTreeB>,
    CycleFirst<PhaseTreeB>, SwapBoundaryReading<PhaseReversed>>
typealias PhaseBContacts = JointEvidence<PhaseB_BC, PhaseB_CA>

typealias PhaseC_AB = ResidentTransportContact<CycleFirst<PhaseTreeC>,
    CycleSecond<PhaseTreeC>, IdentityReading<PhaseRoot, BeamSpace, SaturationEncoding>>
typealias PhaseC_CA = ResidentTransportContact<CycleThird<PhaseTreeC>,
    CycleFirst<PhaseTreeC>, SwapBoundaryReading<PhaseReversed>>
typealias PhaseCContacts = JointEvidence<PhaseC_AB, PhaseC_CA>

// Reversing AB as well makes the full cycle consistent. This construction
// works for every supplied root frame, through the actual double exchange.
enum EvenCycleHasOneAssignment<A: Structure, B: Structure>: Null {
    typealias F = Paired<A, B>
    typealias G = SwapBoundaryReading<F>.Answer
    typealias W = Paired<F, Paired<G, G>>
    typealias AB = ResidentTransportContact<CycleFirst<W>, CycleSecond<W>,
        SwapBoundaryReading<F>>
    typealias BC = ResidentTransportContact<CycleSecond<W>, CycleThird<W>,
        IdentityReading<G, BeamSpace, SaturationEncoding>>
    typealias CA = ResidentTransportContact<CycleThird<W>, CycleFirst<W>,
        SwapBoundaryReading<G>>
    typealias Whole = JointEvidence<JointEvidence<AB, BC>, CA>
    typealias Left = Whole.Left
    typealias Right = W
}

#if RETURN_PHASE_CYCLE_CLOSING_EDGE
typealias RejectedPhaseClosingEdge = ResidentTransportContact<
    CycleThird<PhaseTreeA>, CycleFirst<PhaseTreeA>, SwapBoundaryReading<PhaseRoot>>
#endif

#if RETURN_PHASE_CYCLE_SEPARATE_SOURCES
typealias RejectedPhaseSeparateSources = JointEvidence<PhaseA_AB, PhaseB_BC>
#endif

#if RETURN_PHASE_CONTACT_FOREIGN_START
typealias RejectedPhaseForeignStart = ResidentTransportContact<
    CycleThird<PhaseTreeB>, CycleFirst<PhaseTreeB>,
    IdentityReading<PhaseRoot, BeamSpace, SaturationEncoding>>
#endif
