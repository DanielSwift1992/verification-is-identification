import VerificationIsIdentification
import Examples

#if !LOCAL_PHASE_MARKED_SEPARATE && !LOCAL_PHASE_MARKED_FORGOTTEN && !LOCAL_PHASE_MARKED_GATED && !LOCAL_PHASE_TERNARY_ZERO && !LOCAL_PHASE_TERNARY_LEFT && !LOCAL_PHASE_TERNARY_RIGHT
enum EveryMarkedClauseHasBothActualSuccessors<A: Structure, B: Structure, C: Structure>: Null {
    typealias M = MarkedFrameMoves<A, B, C>
    typealias Left = AddressTriple<Paired<M.First0.SourceStep.Answer, M.Last0.SourceStep.Answer>,
        Paired<M.First1.SourceStep.Answer, M.Last1.SourceStep.Answer>,
        Paired<M.First2.SourceStep.Answer, M.Last2.SourceStep.Answer>>
    typealias Right = AddressTriple<Paired<M.First0.Right.Left, M.Last0.Right.Left>,
        Paired<M.First1.Right.Left, M.Last1.Right.Left>,
        Paired<M.First2.Right.Left, M.Last2.Right.Left>>
}

enum EveryMarkedSuccessorPreservesItsQuestionAnswer<A: Structure, B: Structure, C: Structure>: Null {
    typealias M = MarkedFrameMoves<A, B, C>
    typealias Left = AddressTriple<Paired<M.First0.Right.Answer, M.Last0.Right.Answer>,
        Paired<M.First1.Right.Answer, M.Last1.Right.Answer>,
        Paired<M.First2.Right.Answer, M.Last2.Right.Answer>>
    typealias Right = AddressTriple<Paired<A, A>, Paired<B, B>, Paired<C, C>>
}

enum ActualMarkedMoveUsesTheRetainedAcquisition<A: Structure, B: Structure, C: Structure, P: Structure>: Null {
    typealias R = RecordedMarkedFrameMove<A, B, C, P>
    typealias Left = Paired<R.Endpoint.Left, R.CurrentFromOldFact.Left.Answer>
    typealias Right = Paired<R.Endpoint.Right, R.CurrentFromOldFact.Right.Answer>
}

enum TheSameUnmarkedFrameDoesNotEstablishRequestTransport<A: Structure, B: Structure, C: Structure, P: Structure>: Null {
    typealias R = RecordedMarkedFrameMove<A, B, C, P>
    typealias Left = Paired<R.SameUnmarkedFrame.Left, R.ActualSeparatedEndpoint.Left>
    typealias Right = Paired<R.SameUnmarkedFrame.Right, R.ActualSeparatedEndpoint.Right>
}

enum GatedMovementHasThreeActualSourceClauses<A: Structure, B: Structure, C: Structure>: Null {
    typealias R = GatedUnmarkedFrameMove<A, B, C>
    typealias Left = R.ThreeActualClauses.Left
    typealias Right = R.ThreeActualClauses.Right
}

enum GatedMovementPreservesTheSelectedValue<A: Structure, B: Structure, C: Structure>: Null {
    typealias R = GatedUnmarkedFrameMove<A, B, C>
    typealias Left = R.EveryClauseKeepsItsSelectedValue.Left
    typealias Right = R.EveryClauseKeepsItsSelectedValue.Right
}

enum GatedMovementRecoversItsCompleteSource<A: Structure, B: Structure, C: Structure>: Null {
    typealias R = GatedUnmarkedFrameMove<A, B, C>
    typealias Left = R.EveryClauseReturnsItsWholeSource.Left
    typealias Right = R.EveryClauseReturnsItsWholeSource.Right
}

enum TwoReversibleBinaryChangesForceTheForbiddenProfile: Null {
    typealias R = BinaryChangeWithoutTernaryLift
    typealias Left = Paired<R.CommonSourceAndReversibleBinaryStep.Left, R.ForcedJointProfile.Left>
    typealias Right = Paired<R.CommonSourceAndReversibleBinaryStep.Right, R.ForcedJointProfile.Right>
}
#endif

#if LOCAL_PHASE_MARKED_SEPARATE
enum RejectedMovingOnlyValuesPreservesTheMarkedAnswer: CommutingTransition {
    typealias Left = MarkedFrameAtLast<Never, Lit1, Lit2>
    typealias Right = MarkedFrameAtLast<Never, Lit2, Lit1>
    typealias SourceStep = MoveFrameValuesWithoutRequest<Never, Lit1, Lit2>
    typealias ImageStep = KeepMarkedFrameAnswer<Lit2, SourceStep.Predicate>
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Operation = SourceStep.Predicate
}
#endif

#if LOCAL_PHASE_TERNARY_ZERO
enum RejectedJointProfileIsTheNeutralTernaryValue: Null {
    typealias R = BinaryChangeWithoutTernaryLift
    typealias Left = R.Actual.Answer
    typealias Right = R.Code0
}
#endif

#if LOCAL_PHASE_TERNARY_LEFT
enum RejectedJointProfileIsTheLeftTernaryValue: Null {
    typealias R = BinaryChangeWithoutTernaryLift
    typealias Left = R.Actual.Answer
    typealias Right = R.CodeL
}
#endif

#if LOCAL_PHASE_TERNARY_RIGHT
enum RejectedJointProfileIsTheRightTernaryValue: Null {
    typealias R = BinaryChangeWithoutTernaryLift
    typealias Left = R.Actual.Answer
    typealias Right = R.CodeR
}
#endif

#if LOCAL_PHASE_MARKED_GATED
enum RejectedGatedMovementIsOneFixedWholeRowExchange: Null {
    typealias Left = GatedUnmarkedFrameMove<Never, Lit1, Lit2>.At1.Answer
    typealias Right = MarkedFrameMoves<Never, Lit1, Lit2>.Last1.SourceStep.Answer
}
#endif

#if LOCAL_PHASE_MARKED_FORGOTTEN
enum RejectedTheUnmarkedFrameDeterminesTheMarkedQuestion: Null {
    typealias Left = MarkedFrameAtMiddle<Never, Lit2, Lit1>.Answer
    typealias Right = MarkedFrameAtLast<Never, Lit2, Lit1>.Answer
}
#endif
