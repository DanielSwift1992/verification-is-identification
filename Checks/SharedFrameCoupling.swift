import VerificationIsIdentification
import Examples

#if !LOCAL_PHASE_FRAME_PAIR && !LOCAL_PHASE_FRAME_WHOLE && !LOCAL_PHASE_FRAME_NO_PROBE
enum OneFixedPortAcquisitionCouplesEveryFrame<A: Structure, B: Structure, C: Structure>: Null {
    typealias R = ThreePortSharedCoupling<A, B, C>
    typealias Left = R.SixActualCouplings.Left
    typealias Right = R.SixActualCouplings.Right
}

enum FixedPortSelectorsHaveNoOtherFrameInput<A: Structure, B: Structure, C: Structure>: Null {
    typealias R = ThreePortSharedCoupling<A, B, C>
    typealias Left = R.OnlyTheAcquiredFixedPointIsUsed.Left
    typealias Right = R.OnlyTheAcquiredFixedPointIsUsed.Right
}

enum EachAcquiredReplyStillAllowsTwoFrames<A: Structure, B: Structure, C: Structure>: Null {
    typealias R = ThreePortSharedCoupling<A, B, C>
    typealias Left = R.EachReplyLeavesTwoFrames.Left
    typealias Right = R.EachReplyLeavesTwoFrames.Right
}

enum FixedPortFactRemainsApplicableAtTheActualResult<A: Structure, B: Structure, C: Structure>: Null {
    typealias R = ThreePortSharedCoupling<A, B, C>
    typealias Left = AddressTriple<R.R012.Endpoint.Left, R.R021.RetainedFrameAndFact.Left,
        R.R120.CurrentFixedPointFactors.Left.Answer>
    typealias Right = AddressTriple<R.R012.Endpoint.Right, R.R021.RetainedFrameAndFact.Right,
        R.R120.CurrentFixedPointFactors.Right.Answer>
}
#endif

#if LOCAL_PHASE_FRAME_PAIR
enum RejectedFixedPortSelectsAnotherPair: Null {
    typealias R = ThreePortSharedCoupling<Never, Lit1, Lit2>
    typealias Left = R.R012.Payload
    typealias Right = R.F.F021.Answer
}
#endif

#if LOCAL_PHASE_FRAME_WHOLE
enum RejectedOneFixedPortIdentifiesTheWholeFrame: Null {
    typealias R = ThreePortSharedCoupling<Never, Lit1, Lit2>
    typealias Left = R.Frames.F012.Answer
    typealias Right = R.Frames.F102.Answer
}
#endif

#if LOCAL_PHASE_FRAME_NO_PROBE
enum RejectedOneUncalibratedSwapWorksInEveryFrame: Null {
    typealias R = ThreePortSharedCoupling<Never, Lit1, Lit2>
    typealias Left = R.R012.Payload
    typealias Right = R.R021.Payload
}
#endif
