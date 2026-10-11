import VerificationIsIdentification

enum RecoveringTheActualInputDerivesTheReceiverSeam<R: PredicateReading, F: ReadingFactors>: Null
where F.Left == IdentityReading<R.Left, R.Sigma, R.Encoding> {
    typealias Use = ReapplyReceiverAfterRecovery<R, F>
    typealias Left = Use.Right.Answer
    typealias Right = R.Answer
}

enum RecoveringTheActualInputDerivesTheComposedAnswer<R: PredicateReading, F: ReadingFactors>: Null
where F.Left == IdentityReading<R.Left, R.Sigma, R.Encoding> {
    typealias Use = ReapplyReceiverAfterRecovery<R, F>
    typealias Left = Use.Actual.Answer
    typealias Right = R.Answer
}

enum EachReceiverDerivesItsCorrespondingResult<A: Structure, B: Structure>: Null {
    typealias Uses = RecoveredPairUses<A, B>
    typealias Left = Paired<Uses.Left.Actual.Answer, Uses.Right.Actual.Answer>
    typealias Right = Paired<A, B>
}

enum TheOriginalBoundReceiverRemainsInTheApplication<A: Structure, B: Structure>: Null {
    typealias Uses = RecoveredPairUses<A, B>
    typealias Left = Paired<Uses.Left.Right, Uses.Right.Right>
    typealias Right = Paired<
        DecodeRefinedEvidence<Uses.Recovery.Right, Uses.First>,
        DecodeRefinedEvidence<Uses.Recovery.Right, Uses.Second>>
}

enum RecordedAnswerAvailableWithoutReapplyingReceiver<R: PredicateReading>: Null {
    typealias F = ReceiverAnswerIsAvailable<R>
    typealias Left = F.Right.Answer
    typealias Right = R.Answer
}

enum DifferentBoundInputsCanGiveTheSameAnswer<A: Structure, B: Structure, C: Structure>: Null {
    typealias X = FirstEvidenceImage<Paired<A, B>, BeamSpace, SaturationEncoding, FirstProjection>
    typealias Y = FirstEvidenceImage<Paired<A, C>, BeamSpace, SaturationEncoding, FirstProjection>
    typealias Left = X.Answer
    typealias Right = Y.Answer
}

#if RECEIVER_ANSWER_AS_INPUT
enum RejectedAnswerFactorAsInputRecovery<A: Structure, B: Structure>: Pair {
    typealias R = RecoveredPairUses<A, B>.First
    typealias Left = R
    typealias Right = ReapplyReceiverAfterRecovery<R, ReceiverAnswerIsAvailable<R>>
}
#endif

#if RECEIVER_ANSWER_AS_APPLICATION
enum RejectedAnswerAvailabilityAsReapplication<A: Structure, B: Structure>: Pair {
    typealias R = RecoveredPairUses<A, B>.First
    typealias Left = R
    typealias Right = SequentialReading<ReceiverRecordedAnswer<R>, R>
}
#endif

#if RECEIVER_UNJOINED_INPUT
enum RejectedEqualAnswersJoinDifferentInputs<A: Structure, B: Structure, C: Structure>: Pair {
    typealias Recovery = SwappedPairRecoversInput<A, C>
    typealias R = RecoveredPairUses<A, B>.First
    typealias Left = R
    typealias Right = ReapplyReceiverAfterRecovery<R, Recovery>
}
#endif

#if RECEIVER_RETARGETED
enum RejectedChangedReceiverKeepsTheFormerAnswer<A: Structure, B: Structure>: Null {
    typealias Uses = RecoveredPairUses<A, B>
    typealias Left = Uses.Left.Actual.Answer
    typealias Right = Uses.Right.Actual.Answer
}
#endif
