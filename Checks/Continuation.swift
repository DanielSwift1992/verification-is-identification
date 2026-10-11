import VerificationIsIdentification
import Examples

// The future question is read from the present image, with its operation
// path retained in the question itself.
enum FutureAnswerFollows<P: CommutingTransition, F: ReadingFactors>: Null
where F.Observation == P.Right {
    typealias Left = QuestionAlongTransition<P, F>.Right.Answer
    typealias Right = F.Left.Answer
}

enum FutureAnswerUsesPresentImage<P: CommutingTransition, F: ReadingFactors>: Null
where F.Observation == P.Right {
    typealias Left = QuestionAlongTransition<P, F>.Right.Left
    typealias Right = P.Left.Answer
}

enum FutureQuestionIncludesPath<P: CommutingTransition, F: ReadingFactors>: Null
where F.Observation == P.Right {
    typealias Left = QuestionAlongTransition<P, F>.Predicate
    typealias Right = OperationSequence<P.Operation, F.Predicate>
}

// Two permitted operations expose the third coordinate to the alpha question.
typealias HiddenThenVisible<B: BeamShape> = JoinedTransition<
    SpectrumSecondTransition<B>,
    SpectrumFirstTransition<SwapBetaHidden<B>>
>
typealias MixedFutureQuestion<B: BeamShape> = QuestionAlongTransition<
    HiddenThenVisible<B>,
    SpectrumAlphaFactors<SwapVisible<SwapBetaHidden<B>>>
>
typealias AcquiredMixedFuture<B: BeamShape & Structure> = AnswerFromAcquiredObservation<MixedFutureQuestion<B>>

enum AcquiredImageAnswersMixedFuture<B: BeamShape & Structure>: Null {
    typealias Left = AcquiredMixedFuture<B>.Right.Answer
    typealias Right = B.PaschenLevel
}

enum AcquiredFutureUsesOnlyItsFact<B: BeamShape & Structure>: Null {
    typealias Left = AcquiredMixedFuture<B>.Right.Left
    typealias Right = FactOf<FullSpectrumReading<B>>
}

enum AcquiredFutureKeepsItsQuestion<B: BeamShape & Structure>: Null {
    typealias Left = AcquiredMixedFuture<B>.Predicate
    typealias Right = OperationSequence<
        HiddenThenVisible<B>.Operation,
        AlphaQuestion
    >
}

typealias RecordedFuture = AcquiredMixedFuture<RedBeamWithIR>

#if CONTINUATION_RETARGETS_PRESENT_QUESTION
enum RejectedFutureAsPresentQuestion: Null {
    typealias Left = RecordedFuture.Predicate
    typealias Right = AlphaQuestion
}
#endif

#if CONTINUATION_OTHER_FINAL_SOURCE
typealias RejectedFutureEndpoint = QuestionAlongTransition<
    HiddenThenVisible<RedBeamWithIR>,
    SpectrumAlphaFactors<SwapVisible<SwapBetaHidden<RedBeam>>>
>
#endif

#if CONTINUATION_WITHOUT_ACQUIRED_IMAGE
// An acquired alpha answer does not supply the full initial image required
// by this factorization. The metameric pair supplies the separating example.
typealias RejectedInsufficientFutureFact = AnswerOnRefinement<
    MixedFutureQuestion<RedBeamWithIR>,
    AcquireAnswer<SpectrumAlphaSource<RedBeamWithIR>>
>
#endif
