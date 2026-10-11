import VerificationIsIdentification
import Examples

enum QuarterClockPremiseBoundary {
    typealias Phase = QuarterClockSixReturns<Never, Lit1, Lit2, Paired<Never, Never>>
    typealias Contact = QuarterClockDoubleContact<Lit1, Never, Never, Never, Never,
        Never, Lit1, Lit2, Paired<Never, Never>>
}

enum QuarterClockSixPhaseEquationsHold: Null {
    typealias P = QuarterClockPremiseBoundary.Phase
    typealias Left = P.Left
    typealias Right = P.Right
}

enum QuarterClockSquaredContactReturnsStage: Null {
    typealias C = QuarterClockPremiseBoundary.Contact
    typealias Left = C.Actual.Left.Left
    typealias Right = C.Actual.Answer.Left
}

enum QuarterClockSquaredContactMovesFirstPhase: Null {
    typealias C = QuarterClockPremiseBoundary.Contact
    typealias Left = Paired<C.Actual.Left.Right.Left.Left, C.Actual.Answer.Right.Left.Left>
    typealias Right = Paired<Never, Lit2>
}

#if LOCAL_PHASE_SIX_RETURNS_FORCE_INVOLUTION
enum RejectedQuarterClockInvolution: Null {
    typealias C = QuarterClockPremiseBoundary.Contact
    typealias Left = C.Actual.Left
    typealias Right = C.Actual.Answer
}
#endif
