import VerificationIsIdentification
import Examples

// Four arbitrary phase labels prove each full involution, including its fixed
// positions. No distinctness or particular scalar interpretation is needed.
enum FourLeafPhaseInvolutions<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias P0 = FollowedPair<FourLeafPhase0<A, B, C, D>, FourLeafPhase0<B, A, C, D>>
    typealias P1 = FollowedPair<FourLeafPhase1<A, B, C, D>, FourLeafPhase1<A, C, B, D>>
    typealias P2 = FollowedPair<FourLeafPhase2<A, B, C, D>, FourLeafPhase2<A, B, D, C>>
    typealias P3 = FollowedPair<FourLeafPhase3<A, B, C, D>, FourLeafPhase3<D, B, C, A>>
    typealias Left = Paired<P0.Right, Paired<P1.Right, Paired<P2.Right, P3.Right>>>
    typealias Right = Paired<P0.Left, Paired<P1.Left, Paired<P2.Left, P3.Left>>>
}

enum FourLeafStageInvolutions<O: Structure, A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias S0 = FollowedPair<FourLeafStage0<O, A, B, C, D>, FourLeafStage0<A, O, B, C, D>>
    typealias S1 = FollowedPair<FourLeafStage1<O, A, B, C, D>, FourLeafStage1<B, A, O, C, D>>
    typealias S2 = FollowedPair<FourLeafStage2<O, A, B, C, D>, FourLeafStage2<C, A, B, O, D>>
    typealias S3 = FollowedPair<FourLeafStage3<O, A, B, C, D>, FourLeafStage3<D, A, B, C, O>>
    typealias Left = Paired<S0.Right, Paired<S1.Right, Paired<S2.Right, S3.Right>>>
    typealias Right = Paired<S0.Left, Paired<S1.Left, Paired<S2.Left, S3.Left>>>
}

enum FourLeafStageWordsReturn<O: Structure, A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias Z = FourLeafShortStageWord<O, A, B, C, D>
    typealias W = FourLeafStageWord<O, A, B, C, D>
    typealias Left = Paired<Z.Right, W.Right>
    typealias Right = Paired<Z.Left, W.Left>
}

enum FourLeafReturnIsNotErasure<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias First = FourLeafPhaseWord<A, B, C, D>
    typealias Second = FourLeafPhaseWord<D, B, A, C>
    typealias Third = FourLeafPhaseWord<C, B, D, A>
    typealias Path = FollowedPair<FollowedPair<First, Second>, Third>
    typealias Left = Path.Left
    typealias Right = Path.Right
}

// B=(0,2): the entire stage action returns after three blocks, while the
// entire phase action returns after two. Distinct initial center/phase tokens
// therefore give joint period six blocks without an external clock value.
enum FourLeafBlockPeriods<O: Structure, A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias Stage = FourLeafShortStageWord<O, A, B, C, D>
    typealias Phase = FourLeafShortPhaseWord<A, B, C, D>
    typealias Left = Paired<Paired<Stage.S1.Right, Paired<Stage.S3.Right, Stage.S5.Right>>,
        Paired<Phase.S1.Right, Phase.S3.Right>>
    typealias Right = Paired<Paired<FourLeafStageLabels<C, O, B, A, D>,
        Paired<FourLeafStageLabels<A, C, B, O, D>, FourLeafStageLabels<O, A, B, C, D>>>,
        Paired<BoundaryWorking<B, A, D, C>, BoundaryWorking<A, B, C, D>>>
}

// Follow original token 0 to final address 2, not the token found at final
// address 0. The latter is token 3: point and inverse image differ.
enum FourLeafPositivePhaseBoundary: Null {
    typealias W = FourLeafPhaseWord<Never, Lit1, Lit2, Examples.Succ<Lit2>>
    typealias Left = Paired<W.Right.Right.Left, W.Right.Left.Left>
    typealias Right = Paired<Never, Examples.Succ<Lit2>>
}

// A coarser label question can remain unchanged while the phase permutation
// differs. The counterexample does not justify refusing that weaker reading.
enum FourLeafConstantLabelsSurvive<V: Structure>: Null {
    typealias W = FourLeafPhaseWord<V, V, V, V>
    typealias Left = W.Left
    typealias Right = W.Right
}

enum FourLeafOneLabelSurvivesW<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias W = FourLeafPhaseWord<A, B, C, D>
    typealias Left = W.Right.Left.Right
    typealias Right = B
}

#if LOCAL_PHASE_FOUR_STAGE_IDENTITY_IS_COMPLETE
enum RejectedFourLeafCompleteIdentity: Null {
    typealias W = FourLeafPhaseWord<Never, Lit1, Lit2, Examples.Succ<Lit2>>
    typealias Left = W.Left
    typealias Right = W.Right
}
#endif

#if LOCAL_PHASE_FOUR_OMITS_INTERMEDIATE_CHANGE
enum RejectedFourLeafWrongSeam: Pair {
    typealias Path = FollowedPair<FourLeafPhase0<Never, Lit1, Lit2, Examples.Succ<Lit2>>,
        FourLeafPhase2<Never, Lit1, Lit2, Examples.Succ<Lit2>>>
    typealias Left = Path.Left
    typealias Right = Path.Right
}
#endif
