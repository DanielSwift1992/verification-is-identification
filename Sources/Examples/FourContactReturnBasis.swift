import VerificationIsIdentification

/// Finite operation expressions for the six equations of VC101. An expression
/// states which contacts a calibration must compose; it is not itself a claim
/// that the resulting action is identity or that an interpreter is available.
public typealias AlternatingContactReturn<A, B> = OperationSequence<
    OperationSequence<A, B>, OperationSequence<OperationSequence<A, B>, OperationSequence<A, B>>>
public typealias ConjugateContactReturn<A, B, C> = OperationSequence<
    OperationSequence<OperationSequence<A, B>, OperationSequence<A, C>>,
    OperationSequence<OperationSequence<A, B>, OperationSequence<A, C>>>

public enum FourContactReturnBasis<A, B, C, D>: Close {
    public typealias Pair01 = AlternatingContactReturn<A, B>
    public typealias Pair12 = AlternatingContactReturn<B, C>
    public typealias Pair13 = AlternatingContactReturn<B, D>
    public typealias Triple120 = ConjugateContactReturn<B, C, A>
    public typealias Triple230 = ConjugateContactReturn<C, D, A>
    public typealias Triple231 = ConjugateContactReturn<C, D, B>
    public typealias Pairs = CandidateFork<CandidateLeaf<Pair01>,
        CandidateFork<CandidateLeaf<Pair12>, CandidateLeaf<Pair13>>>
    public typealias Triples = CandidateFork<CandidateLeaf<Triple120>,
        CandidateFork<CandidateLeaf<Triple230>, CandidateLeaf<Triple231>>>
    public typealias Words = CandidateFork<Pairs, Triples>
}

/// The length-eight template (1,2,1,0)^2 on arbitrary stage labels. Relabeling
/// the three chosen leaves gives the other triple stage returns of VC101.
public enum FourLeafTripleStageWord<O: Structure, A: Structure, B: Structure,
                                    C: Structure, D: Structure>: Null {
    public typealias S0 = FourLeafStage1<O, A, B, C, D>
    public typealias S1 = FourLeafStage2<B, A, O, C, D>
    public typealias S2 = FourLeafStage1<C, A, O, B, D>
    public typealias S3 = FourLeafStage0<O, A, C, B, D>
    public typealias S4 = FourLeafStage1<A, O, C, B, D>
    public typealias S5 = FourLeafStage2<C, O, A, B, D>
    public typealias S6 = FourLeafStage1<B, O, A, C, D>
    public typealias S7 = FourLeafStage0<A, O, B, C, D>
    public typealias Path = FollowedPair<
        FollowedPair<FollowedPair<S0, S1>, FollowedPair<S2, S3>>,
        FollowedPair<FollowedPair<S4, S5>, FollowedPair<S6, S7>>>
    public typealias Left = Path.Left
    public typealias Right = Path.Right
}

/// The same named word in VC99's canonical phase lift is not identity.
/// Intermediate sources and the final tuple are derived from actual contacts.
public enum FourLeafTriplePhaseWord<A: Structure, B: Structure,
                                    C: Structure, D: Structure>: Pair {
    public typealias S0 = FourLeafPhase1<A, B, C, D>
    public typealias S1 = FourLeafPhase2<A, C, B, D>
    public typealias S2 = FourLeafPhase1<A, C, D, B>
    public typealias S3 = FourLeafPhase0<A, D, C, B>
    public typealias S4 = FourLeafPhase1<D, A, C, B>
    public typealias S5 = FourLeafPhase2<D, C, A, B>
    public typealias S6 = FourLeafPhase1<D, C, B, A>
    public typealias S7 = FourLeafPhase0<D, B, C, A>
    public typealias Path = FollowedPair<
        FollowedPair<FollowedPair<S0, S1>, FollowedPair<S2, S3>>,
        FollowedPair<FollowedPair<S4, S5>, FollowedPair<S6, S7>>>
    public typealias Left = Path.Left
    public typealias Right = Path.Right
}

public enum FourLeafTriplePhaseOutcome<A: Structure, B: Structure,
                                       C: Structure, D: Structure>: Null {
    public typealias Left = FourLeafTriplePhaseWord<A, B, C, D>.Right
    public typealias Right = BoundaryWorking<B, D, C, A>
}
