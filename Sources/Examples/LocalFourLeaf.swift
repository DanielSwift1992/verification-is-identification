import VerificationIsIdentification

/// Symbolic labels of center and four leaves. Exchanging slots presents the
/// complete stage permutation; it does not count five physical observations.
public typealias FourLeafStageLabels<O: Structure, A: Structure, B: Structure,
                                     C: Structure, D: Structure> = Paired<O, BoundaryWorking<A, B, C, D>>

public enum FourLeafStage0<O: Structure, A: Structure, B: Structure, C: Structure, D: Structure>: Pair {
    public typealias Left = FourLeafStageLabels<O, A, B, C, D>
    public typealias Right = FourLeafStageLabels<A, O, B, C, D>
}
public enum FourLeafStage1<O: Structure, A: Structure, B: Structure, C: Structure, D: Structure>: Pair {
    public typealias Left = FourLeafStageLabels<O, A, B, C, D>
    public typealias Right = FourLeafStageLabels<B, A, O, C, D>
}
public enum FourLeafStage2<O: Structure, A: Structure, B: Structure, C: Structure, D: Structure>: Pair {
    public typealias Left = FourLeafStageLabels<O, A, B, C, D>
    public typealias Right = FourLeafStageLabels<C, A, B, O, D>
}
public enum FourLeafStage3<O: Structure, A: Structure, B: Structure, C: Structure, D: Structure>: Pair {
    public typealias Left = FourLeafStageLabels<O, A, B, C, D>
    public typealias Right = FourLeafStageLabels<D, A, B, C, O>
}

/// Corresponding phase contacts exchange 0/1, 1/2, 2/3, 3/0. These actual
/// finite constructors supply the permutations, not arbitrary Pair conformances.
public enum FourLeafPhase0<A: Structure, B: Structure, C: Structure, D: Structure>: Pair {
    public typealias Left = BoundaryWorking<A, B, C, D>
    public typealias Right = BoundaryWorking<B, A, C, D>
}
public enum FourLeafPhase1<A: Structure, B: Structure, C: Structure, D: Structure>: Pair {
    public typealias Left = BoundaryWorking<A, B, C, D>
    public typealias Right = BoundaryWorking<A, C, B, D>
}
public enum FourLeafPhase2<A: Structure, B: Structure, C: Structure, D: Structure>: Pair {
    public typealias Left = BoundaryWorking<A, B, C, D>
    public typealias Right = BoundaryWorking<A, B, D, C>
}
public enum FourLeafPhase3<A: Structure, B: Structure, C: Structure, D: Structure>: Pair {
    public typealias Left = BoundaryWorking<A, B, C, D>
    public typealias Right = BoundaryWorking<D, B, C, A>
}

/// Z = 0,2,0,2,0,2. Every intermediate source joins the actual previous
/// output. The final stage equality is derived, not an input constraint.
public enum FourLeafShortStageWord<O: Structure, A: Structure, B: Structure,
                                   C: Structure, D: Structure>: Null {
    public typealias S0 = FourLeafStage0<O, A, B, C, D>
    public typealias S1 = FourLeafStage2<A, O, B, C, D>
    public typealias S2 = FourLeafStage0<C, O, B, A, D>
    public typealias S3 = FourLeafStage2<O, C, B, A, D>
    public typealias S4 = FourLeafStage0<A, C, B, O, D>
    public typealias S5 = FourLeafStage2<C, A, B, O, D>
    public typealias Path = FollowedPair<
        FollowedPair<FollowedPair<S0, S1>, FollowedPair<S2, S3>>, FollowedPair<S4, S5>>
    public typealias Left = Path.Left
    public typealias Right = Path.Right
}

public enum FourLeafShortPhaseWord<A: Structure, B: Structure,
                                   C: Structure, D: Structure>: Pair {
    public typealias S0 = FourLeafPhase0<A, B, C, D>
    public typealias S1 = FourLeafPhase2<B, A, C, D>
    public typealias S2 = FourLeafPhase0<B, A, D, C>
    public typealias S3 = FourLeafPhase2<A, B, D, C>
    public typealias S4 = FourLeafPhase0<A, B, C, D>
    public typealias S5 = FourLeafPhase2<B, A, C, D>
    public typealias Path = FollowedPair<
        FollowedPair<FollowedPair<S0, S1>, FollowedPair<S2, S3>>, FollowedPair<S4, S5>>
    public typealias Left = Path.Left
    public typealias Right = Path.Right
}

/// W = 0,2,0,1,3,1,0,2,0,1,3,1. Arbitrary labels establish the entire
/// permutation rather than one preparation. No equality between labels is used.
public enum FourLeafStageWord<O: Structure, A: Structure, B: Structure,
                              C: Structure, D: Structure>: Null {
    public typealias S0 = FourLeafStage0<O, A, B, C, D>
    public typealias S1 = FourLeafStage2<A, O, B, C, D>
    public typealias S2 = FourLeafStage0<C, O, B, A, D>
    public typealias S3 = FourLeafStage1<O, C, B, A, D>
    public typealias S4 = FourLeafStage3<B, C, O, A, D>
    public typealias S5 = FourLeafStage1<D, C, O, A, B>
    public typealias S6 = FourLeafStage0<O, C, D, A, B>
    public typealias S7 = FourLeafStage2<C, O, D, A, B>
    public typealias S8 = FourLeafStage0<A, O, D, C, B>
    public typealias S9 = FourLeafStage1<O, A, D, C, B>
    public typealias S10 = FourLeafStage3<D, A, O, C, B>
    public typealias S11 = FourLeafStage1<B, A, O, C, D>
    public typealias First = FollowedPair<FollowedPair<S0, S1>, S2>
    public typealias Second = FollowedPair<FollowedPair<S3, S4>, S5>
    public typealias Third = FollowedPair<FollowedPair<S6, S7>, S8>
    public typealias Fourth = FollowedPair<FollowedPair<S9, S10>, S11>
    public typealias Path = FollowedPair<FollowedPair<First, Second>, FollowedPair<Third, Fourth>>
    public typealias Left = Path.Left
    public typealias Right = Path.Right
}

public enum FourLeafPhaseWord<A: Structure, B: Structure,
                              C: Structure, D: Structure>: Pair {
    public typealias S0 = FourLeafPhase0<A, B, C, D>
    public typealias S1 = FourLeafPhase2<B, A, C, D>
    public typealias S2 = FourLeafPhase0<B, A, D, C>
    public typealias S3 = FourLeafPhase1<A, B, D, C>
    public typealias S4 = FourLeafPhase3<A, D, B, C>
    public typealias S5 = FourLeafPhase1<C, D, B, A>
    public typealias S6 = FourLeafPhase0<C, B, D, A>
    public typealias S7 = FourLeafPhase2<B, C, D, A>
    public typealias S8 = FourLeafPhase0<B, C, A, D>
    public typealias S9 = FourLeafPhase1<C, B, A, D>
    public typealias S10 = FourLeafPhase3<C, A, B, D>
    public typealias S11 = FourLeafPhase1<D, A, B, C>
    public typealias First = FollowedPair<FollowedPair<S0, S1>, S2>
    public typealias Second = FollowedPair<FollowedPair<S3, S4>, S5>
    public typealias Third = FollowedPair<FollowedPair<S6, S7>, S8>
    public typealias Fourth = FollowedPair<FollowedPair<S9, S10>, S11>
    public typealias Path = FollowedPair<FollowedPair<First, Second>, FollowedPair<Third, Fourth>>
    public typealias Left = Path.Left
    public typealias Right = Path.Right
}

public enum FourLeafPhaseOutcomes<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    public typealias Left = Paired<FourLeafShortPhaseWord<A, B, C, D>.Right,
        FourLeafPhaseWord<A, B, C, D>.Right>
    public typealias Right = Paired<BoundaryWorking<B, A, D, C>, BoundaryWorking<D, B, A, C>>
}
