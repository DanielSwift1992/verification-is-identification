import VerificationIsIdentification
import Examples

// Exactly the same twenty visible stages as VC97's four-phase star.
enum FaithfulCycleHasSameVisibleWord: Null {
    typealias C = FaithfulFourLeafCycle
    typealias Left = Paired<Paired<Paired<Paired<Paired<C.S0.Left.Left, C.S1.Left.Left>, C.S2.Left.Left>, Paired<C.S3.Left.Left, C.S4.Left.Left>>, Paired<Paired<Paired<C.S5.Left.Left, C.S6.Left.Left>, C.S7.Left.Left>, Paired<C.S8.Left.Left, C.S9.Left.Left>>>, Paired<Paired<Paired<Paired<C.S10.Left.Left, C.S11.Left.Left>, C.S12.Left.Left>, Paired<C.S13.Left.Left, C.S14.Left.Left>>, Paired<Paired<Paired<C.S15.Left.Left, C.S16.Left.Left>, C.S17.Left.Left>, Paired<C.S18.Left.Left, C.S19.Left.Left>>>>
    typealias Right = Paired<Paired<Paired<Paired<Paired<FourLeafCenter, FourLeafStageLabels<Never, Lit1, Never, Never, Never>>, FourLeafStageLabels<Never, Lit1, Never, Never, Never>>, Paired<FourLeafStageLabels<Never, Lit1, Never, Never, Never>, FourLeafStageLabels<Never, Lit1, Never, Never, Never>>>, Paired<Paired<Paired<FourLeafCenter, FourLeafStageLabels<Never, Never, Lit1, Never, Never>>, FourLeafStageLabels<Never, Never, Lit1, Never, Never>>, Paired<FourLeafStageLabels<Never, Never, Lit1, Never, Never>, FourLeafStageLabels<Never, Never, Lit1, Never, Never>>>>, Paired<Paired<Paired<Paired<FourLeafCenter, FourLeafStageLabels<Never, Never, Never, Lit1, Never>>, FourLeafStageLabels<Never, Never, Never, Lit1, Never>>, Paired<FourLeafStageLabels<Never, Never, Never, Lit1, Never>, FourLeafStageLabels<Never, Never, Never, Lit1, Never>>>, Paired<Paired<Paired<FourLeafCenter, FourLeafStageLabels<Never, Never, Never, Never, Lit1>>, FourLeafStageLabels<Never, Never, Never, Never, Lit1>>, Paired<FourLeafStageLabels<Never, Never, Never, Never, Lit1>, FourLeafStageLabels<Never, Never, Never, Never, Lit1>>>>>
}

// A source pair in the unused part has one constant U-only stage history.
// The common continuation A0 then U separates it through visible stages.
enum FaithfulMoreContextsExposeDifference: Null {
    typealias F = FaithfulFourLeafPhases
    typealias First = FollowedPair<F.C.L00, FaithfulFourLeafCycle.S15>
    typealias Second = FollowedPair<F.Q.L00, FaithfulFourLeafRemainder.CenterQ.Forward>
    typealias Left = Paired<First.Right.Left, Second.Right.Left>
    typealias Right = Paired<FourLeafStageLabels<Never, Never, Never, Never, Lit1>, FourLeafStageLabels<Never, Never, Lit1, Never, Never>>
}

enum FaithfulSameCurrentStage: Null {
    typealias Left = FaithfulFourLeafPhases.C.L00.Left.Left
    typealias Right = FaithfulFourLeafPhases.Q.L00.Left.Left
}

#if LOCAL_PHASE_FAITHFUL_UNUSED_IS_EQUIVALENT
enum RejectedFaithfulSameContinuation: Null {
    typealias Left = FaithfulMoreContextsExposeDifference.First.Right.Left
    typealias Right = FaithfulMoreContextsExposeDifference.Second.Right.Left
}
#endif

#if LOCAL_PHASE_FAITHFUL_OMITS_REMAINDER
// Reusing the cycle's outgoing row at an unused center would change its
// actual phase preparation even though both read center.
enum RejectedFaithfulUnusedCenter: Pair {
    typealias Arrive = FaithfulFourLeafRemainder.CenterQ.Backward
    typealias Wrong = FollowedPair<Arrive, FaithfulFourLeafCycle.S0>
    typealias Left = Wrong.Left
    typealias Right = Wrong.Right
}
#endif

