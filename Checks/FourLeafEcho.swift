import VerificationIsIdentification
import Examples

enum FourLeafEchoAcquiresDifferentStages<K: Structure>: Null {
    typealias Left = FourLeafEchoAnswers<K>.Answer
    typealias Right = Paired<FourLeafStageLabels<Never, Lit1, Never, Never, Never>,
        FourLeafStageLabels<Never, Never, Lit1, Never, Never>>
}

// Full equality of the input fact types exhibits the decoder's entire input:
// stage answers and one common question, without the source or its phase.
enum FourLeafEchoMemoryContainsOnlyStageFacts<K: Structure>: Null {
    typealias Left = FourLeafEchoAnswers<K>.Left
    typealias Right = Paired<AnswerFact<BeamSpace, SaturationEncoding, FirstProjection,
        FourLeafStageLabels<Never, Lit1, Never, Never, Never>>,
        AnswerFact<BeamSpace, SaturationEncoding, FirstProjection,
        FourLeafStageLabels<Never, Never, Lit1, Never, Never>>>
}

// The restored target and the retained records are separate actual fields.
// No empty memory or renewed command tape is inferred from the target return.
enum FourLeafEchoRetainsItsAcquisition<K: Structure>: Null {
    typealias E = FourLeafEcho<K>
    typealias Left = Paired<E.Answer.Left.Left.Left,
        Paired<E.Answer.Left.Right, Paired<E.Answer.Left.Left.Right, E.Answer.Right>>>
    typealias Right = Paired<E.Left.Left,
        Paired<E.L.F0, Paired<E.L.F1, Paired<Never, E.Past4>>>>
}

// Independently construct the next-stage question at the actual final target.
// Its answer follows from the first retained fact. No new fact is acquired.
enum FourLeafEchoFirstFactPredictsAgain<K: Structure>: Null {
    typealias E = FourLeafEcho<K>
    typealias P0 = FirstEvidenceImage<E.Answer, BeamSpace, SaturationEncoding, FirstProjection>
    typealias P1 = FollowedPair<P0,
        FirstEvidenceImage<P0.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    typealias Target = FollowedPair<P1,
        FirstEvidenceImage<P1.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    typealias Future = FollowedPair<Target, FollowedPair<E.L.C.S0, E.L.Q0>>
    typealias Memory = FourLeafEchoFacts<E.Answer>
    typealias Evidence = FollowedPair<Memory,
        FirstEvidenceImage<Memory.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    typealias Decoder = ReadRecordedAnswer<Evidence.Answer>
    typealias Left = Future.Answer
    typealias Right = Decoder.Answer
}

#if LOCAL_PHASE_ECHO_REUSES_OLD_SOURCE
enum RejectedFourLeafEchoWrongObservationSource: Pair {
    typealias E = FourLeafEcho<Never>
    typealias WrongRead = ExperimentReadingBeside<E.L.Zero, E.L.F0>
    typealias Wrong = FollowedPair<E.R1, WrongRead>
    typealias Left = Wrong.Left
    typealias Right = Wrong.Right
}
#endif

#if LOCAL_PHASE_ECHO_RETURN_ERASES_RECORDS
enum RejectedFourLeafEchoWholeReturn: Null {
    typealias E = FourLeafEcho<Never>
    typealias Left = E.Left
    typealias Right = E.Answer
}
#endif

#if LOCAL_PHASE_ECHO_SECOND_FACT_PREDICTS_NOW
enum RejectedFourLeafEchoSecondFactReuse: Null {
    typealias P = FourLeafEchoFirstFactPredictsAgain<Never>
    typealias Old = ReadRecordedAnswer<P.Memory.Answer.Right>
    typealias Left = P.Future.Answer
    typealias Right = Old.Answer
}
#endif
