import VerificationIsIdentification
import Examples

enum OddFixedPointFrame<A: Structure, B: Structure, C: Structure,
    D: Structure>: Close {
    typealias Odd = FourLeafPhase2<A, B, C, D>
    typealias W = FourLeafPhaseWord<A, B, C, D>
    typealias OddThenW = FollowedPair<Odd, FourLeafPhaseWord<A, B, D, C>>
    typealias WThenOdd = FollowedPair<W, FourLeafPhase2<D, B, A, C>>
    typealias IdentityRecord = RecordReading<PhaseLawProbe1<Odd.Left>>
    typealias OddRecord = RecordReading<PhaseLawProbe1<Odd.Right>>
}

#if !LOCAL_PHASE_ONE_REPLY_IDENTIFIES_FRAME && !LOCAL_PHASE_ONE_REPLY_WITHOUT_EVEN_SCOPE
enum OneReplyAcquiredDecisions: Null {
    typealias F = EvenFrameApplicability
    typealias Left = Paired<F.Verdicts.Left, F.SamePositiveEvidence.Left>
    typealias Right = Paired<F.Verdicts.Right, F.SamePositiveEvidence.Right>
}

enum OneReplyIndependentActionProof<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias Cmp = EvenFrameCommutation<A, B, C, D>
    typealias Left = Paired<Cmp.PureCommutes.Left, Cmp.OtherWitnesses.Left>
    typealias Right = Paired<Cmp.PureCommutes.Right, Cmp.OtherWitnesses.Right>
}

enum OneReplyRetainsLaboratory<R: Structure>: Null {
    typealias F = EvenFrameApplicability
    typealias I = StepBeside<F.I, R>
    typealias W = StepBeside<F.W, R>
    typealias Left = Paired<I.Right.Right, W.Right.Right>
    typealias Right = Paired<R, R>
}

// An odd frame and identity give the same one-point fact. This is outside
// the even-family commutation theorem, not a failure of the point reading.
enum OneReplyOddAmbiguity<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias O = OddFixedPointFrame<A, B, C, D>
    typealias Left = O.IdentityRecord.Right.Right
    typealias Right = O.OddRecord.Right.Right
}

enum OneReplyOddActionDifference<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias O = OddFixedPointFrame<A, B, C, D>
    typealias Left = Paired<O.OddThenW.Right, O.WThenOdd.Right>
    typealias Right = Paired<BoundaryWorking<C, B, A, D>, BoundaryWorking<D, B, C, A>>
}
#endif

#if LOCAL_PHASE_ONE_REPLY_IDENTIFIES_FRAME
enum RejectedOneReplyIdentifiesFrame: Null {
    typealias F = EvenFrameApplicability
    typealias Left = F.I.Left.Left.Right.Right.Right.Left
    typealias Right = F.W.Left.Left.Right.Right.Right.Left
}
#endif

#if LOCAL_PHASE_ONE_REPLY_WITHOUT_EVEN_SCOPE
enum RejectedOneReplyWithoutEvenScope<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias O = OddFixedPointFrame<A, B, C, D>
    typealias Left = O.OddThenW.Right
    typealias Right = O.WThenOdd.Right
}
#endif
