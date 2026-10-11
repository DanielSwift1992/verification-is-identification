import VerificationIsIdentification
import Examples

// The selector can have the same available input at two different stages.
// The selected actual application remains bound to each current source root.
enum FourLeafPolicyInputForgetsStage<K: Structure>: Null {
    typealias Context = Paired<FourLeafAddressProgram, K>
    typealias First = FourLeafControlInput<FourLeafCenter, FourLeafMarked0, Context>
    typealias Second = FourLeafControlInput<
        FourLeafStageLabels<Never, Lit1, Never, Never, Never>, FourLeafMarked0, Context>
    typealias Left = First.Answer
    typealias Right = Second.Answer
}

// These independently constructed carriers have the same displayed stage
// sequence. Their whole-action return laws were proved to differ.
enum FourLeafControlAndFaithfulVisibleAgreement: Null {
    typealias C = FourLeafControlOrbit<Never>
    typealias F = FaithfulFourLeafCycle
    typealias Left = FourLeafStageLabels<
        BoundaryWorking<C.S0.Left.Left, C.S1.Left.Left, C.S2.Left.Left, C.S3.Left.Left>,
        BoundaryWorking<C.S4.Left.Left, C.S5.Left.Left, C.S6.Left.Left, C.S7.Left.Left>,
        BoundaryWorking<C.S8.Left.Left, C.S9.Left.Left, C.S10.Left.Left, C.S11.Left.Left>,
        BoundaryWorking<C.S12.Left.Left, C.S13.Left.Left, C.S14.Left.Left, C.S15.Left.Left>,
        BoundaryWorking<C.S16.Left.Left, C.S17.Left.Left, C.S18.Left.Left, C.S19.Left.Left>>
    typealias Right = FourLeafStageLabels<
        BoundaryWorking<F.S0.Left.Left, F.S1.Left.Left, F.S2.Left.Left, F.S3.Left.Left>,
        BoundaryWorking<F.S4.Left.Left, F.S5.Left.Left, F.S6.Left.Left, F.S7.Left.Left>,
        BoundaryWorking<F.S8.Left.Left, F.S9.Left.Left, F.S10.Left.Left, F.S11.Left.Left>,
        BoundaryWorking<F.S12.Left.Left, F.S13.Left.Left, F.S14.Left.Left, F.S15.Left.Left>,
        BoundaryWorking<F.S16.Left.Left, F.S17.Left.Left, F.S18.Left.Left, F.S19.Left.Left>>
}

// The target cycle retains arbitrary context. Its five-round return is
// independent of whether the context is a ledger, another source, or empty.
enum FourLeafControlKeepsContext<K: Structure>: Null {
    typealias C = FourLeafControlOrbit<K>
    typealias Left = Paired<C.S0.Left.Right.Right, C.S19.Answer.Right.Right>
    typealias Right = Paired<Paired<FourLeafAddressProgram, K>, Paired<FourLeafAddressProgram, K>>
}

#if LOCAL_PHASE_CONTROL_FOUR_STEPS_ARE_RETURN
enum RejectedFourLeafShortControlReturn: Null {
    typealias C = FourLeafControlOrbit<Never>
    typealias Left = C.S0.Left
    typealias Right = C.S3.Answer
}
#endif

#if LOCAL_PHASE_CONTROL_REUSES_WRONG_STAGE_ROOT
enum RejectedFourLeafSamePolicyWrongRoot: Pair {
    typealias C = FourLeafControlOrbit<Never>
    typealias Wrong = FollowedPair<C.S3, C.S0>
    typealias Left = Wrong.Left
    typealias Right = Wrong.Right
}
#endif
