import VerificationIsIdentification
import Examples

#if !SELF_RECORD_NORMAL_AFTER_PROBE && !SELF_RECORD_STALE_SOURCE
enum FaithfulSelfRecordHidesTheActingDependency<A: Structure, B: Structure,
    H: Structure>: Null {
    typealias P = FaithfulSelfRecordStep<A, B, H>
    typealias Left = P.Left
    typealias Right = P.Right
}
enum AnotherFaithfulStepStillHidesTheDependency<A: Structure, B: Structure,
    H: Structure>: Null {
    typealias P = FaithfulSelfRecordStep<A, B, H>
    typealias Left = AdvanceFromWorking<P.Direct.Answer>.Answer
    typealias Right = AdvanceFromRecord<P.Feedback.Answer>.Answer
}
enum WorkingDrivenStepRecoversAllInputFields<A: Structure, B: Structure,
    C: Structure, D: Structure, H: Structure>: Null {
    typealias S = SelfRecordState<Paired<A, B>, Paired<C, D>, H>
    typealias P = AdvanceFromWorking<S>
    typealias Back = SequentialReading<P, RestoreWorkingDriven<P.Answer>>
    typealias Left = Back.Answer
    typealias Right = S
}
enum RecordDrivenStepRecoversAllInputFields<A: Structure, B: Structure,
    C: Structure, D: Structure, H: Structure>: Null {
    typealias S = SelfRecordState<Paired<A, B>, Paired<C, D>, H>
    typealias P = AdvanceFromRecord<S>
    typealias Back = SequentialReading<P, RestoreRecordDriven<P.Answer>>
    typealias Left = Back.Answer
    typealias Right = S
}
enum PerturbingOnlyTheRecordHasAnActualReverse<A: Structure, B: Structure,
    C: Structure, D: Structure, H: Structure>: Null {
    typealias S = SelfRecordState<Paired<A, B>, Paired<C, D>, H>
    typealias P = PerturbSelfRecord<S>
    typealias Twice = SequentialReading<P, PerturbSelfRecord<P.Answer>>
    typealias Left = Twice.Answer
    typealias Right = S
}
enum InternalProbeSeparatesTheTwoReferenceRelations<A: Structure, B: Structure,
    H: Structure>: Null {
    typealias P = SelfRecordProbe<A, B, H>
    typealias Left = Paired<P.DirectSwapsReference.Left, P.FeedbackReturnsReference.Left>
    typealias Right = Paired<Paired<B, A>, Paired<A, B>>
}
enum AnUndistinguishedProbeDoesNotSeparateTheLaws<A: Structure,
    H: Structure>: Null {
    typealias P = SelfRecordProbe<A, A, H>
    typealias Left = P.Direct.Answer
    typealias Right = P.Feedback.Answer
}
#endif

#if SELF_RECORD_NORMAL_AFTER_PROBE
enum RejectedNormalTrackingAgreementAfterTheInternalProbe: Null {
    typealias P = SelfRecordProbe<Never, Examples.Succ<Never>, Never>
    typealias Left = P.Direct.Answer.Left.Left
    typealias Right = P.Feedback.Answer.Left.Left
}
#endif

#if SELF_RECORD_STALE_SOURCE
enum RejectedUnperturbedAdvanceFromThePerturbedRecord: Null {
    typealias P = SelfRecordProbe<Never, Examples.Succ<Never>, Never>
    typealias Invalid = SequentialReading<P.Probe, AdvanceFromRecord<P.Source>>
    typealias Left = Invalid.Answer
    typealias Right = P.Feedback.Answer
}
#endif
