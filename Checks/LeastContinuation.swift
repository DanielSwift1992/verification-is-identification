import VerificationIsIdentification
#if !LEAST_CURRENT_DECLARATIONS
import Examples
#endif

// Arbitrary A, B and rest. The memory order is deliberately (next, now).
// The constructed decoder must recover the independently requested (now,next).
enum ReversedMemorySuppliesTheLeastFrame<A: Structure, B: Structure,
    Rest: Structure>: Null {
    typealias S = TargetFrame<A, B, Rest>
    typealias Q0 = ReadFrameTarget<S>
    typealias Q1 = NextFrameTarget<S>
    typealias Now = JointEvidenceRetainsSecond<Q1, Q0>
    typealias Next = JointEvidenceRetainsFirst<Q1, Q0>
    typealias Least = FramePairFromSufficientObservation<S, Now, Next>
    typealias Left = Least.Decoder.Answer
    typealias Right = Paired<A, B>
}

enum LeastFrameDecoderUsesTheActualMemory<A: Structure, B: Structure,
    Rest: Structure>: Null {
    typealias S = TargetFrame<A, B, Rest>
    typealias Q0 = ReadFrameTarget<S>
    typealias Q1 = NextFrameTarget<S>
    typealias Now = JointEvidenceRetainsSecond<Q1, Q0>
    typealias Next = JointEvidenceRetainsFirst<Q1, Q0>
    typealias Least = FramePairFromSufficientObservation<S, Now, Next>
    typealias Left = Least.Decoder.Left
    typealias Right = Paired<B, A>
}

// Continue from the constructed pair using the already established frame
// action. No retained Rest field is supplied to this continuation.
enum LeastFrameFeedsTheExistingContinuation<A: Structure, B: Structure,
    Rest: Structure>: Null {
    typealias S = TargetFrame<A, B, Rest>
    typealias Q0 = ReadFrameTarget<S>
    typealias Q1 = NextFrameTarget<S>
    typealias Now = JointEvidenceRetainsSecond<Q1, Q0>
    typealias Next = JointEvidenceRetainsFirst<Q1, Q0>
    typealias Least = FramePairFromSufficientObservation<S, Now, Next>
    typealias Continued = ExchangeRetainedTargets<Least.Decoder.Answer>
    typealias Left = Continued.Answer
    typealias Right = TargetFrameTransport<S>.SourcePath.Answer
}

// The residual contains the future target and arbitrary extra content.
// Relative minimization keeps only the already retained target and the
// requested future target. It does not declare the residual itself minimal.
enum ExtraResidualContentIsNotNeeded<A: Structure, B: Structure,
    Rest: Structure>: Null {
    typealias S = TargetFrame<A, B, Rest>
    typealias P = ReadFrameTarget<S>
    typealias D = IdentityReading<S, TargetFrameSpace, TargetFrameEncoding>
    typealias Q = NextFrameTarget<S>
    typealias SourceFactor = QuestionThroughStoredSource<P, Q>
    typealias Least = LeastJointEvidence<P, D, SourceFactor>
    typealias Left = Least.Right.Answer
    typealias Right = Paired<A, B>
}

// This supplied factor is built from the residual's actual source and Q.
// Its assumptions identify endpoints, not the desired pair of answers.
enum QuestionThroughStoredSource<P: PredicateReading,
    Q: PredicateReading>: ReadingFactors
where Q.Left == P.Left,
      P.Sigma == Q.Sigma, P.Encoding == Q.Encoding,
      P.Answer: Structure, P.Left: Structure {
    typealias D = IdentityReading<P.Left, P.Sigma, P.Encoding>
    typealias Left = Q
    typealias Observation = JointEvidence<P, D>
    typealias Select = SecondEvidenceImage<Observation.Answer,
        Q.Sigma, Q.Encoding, Q.Predicate>
    typealias Right = DecodeRefinedEvidence<Select, Q>
    typealias Sigma = Q.Sigma
    typealias Encoding = Q.Encoding
    typealias Predicate = Q.Predicate
    typealias Answer = Q.Answer
}

enum ContinuationA: Close {}
enum ContinuationB: Close {}
enum ContinuationRest: Close {}
typealias ContinuationSource = TargetFrame<ContinuationA, ContinuationB, ContinuationRest>
typealias ContinuationNow = ReadFrameTarget<ContinuationSource>
typealias ContinuationNext = NextFrameTarget<ContinuationSource>
typealias ActualNow = JointEvidenceRetainsFirst<ContinuationNow, ContinuationNext>
typealias ActualNext = JointEvidenceRetainsSecond<ContinuationNow, ContinuationNext>

// U11's two possible preserved actions. These are actual field constructors,
// not a table of values or a claim that a physical repeat interface exists.
typealias ExchangeContinuationTail<S: Pair> = Paired<S.Left,
    SwapBoundaryReading<S.Right>.Answer>
where S.Left: Structure, S.Right: Pair,
      S.Right.Left: Structure, S.Right.Right: Structure

typealias ThreeContinuationRotations<S: Pair> = RotateThree<RotateThree<RotateThree<S>>>
where S.Left: Structure, S.Right: Pair,
      S.Right.Left: Structure, S.Right.Right: Structure

typealias ThreeContinuationTailExchanges<S: Pair> = ExchangeContinuationTail<
    ExchangeContinuationTail<ExchangeContinuationTail<S>>>
where S.Left: Structure, S.Right: Pair,
      S.Right.Left: Structure, S.Right.Right: Structure

enum FixedRotationReturnsTheOriginalQuestion<A: Structure, B: Structure,
    C: Structure>: Null {
    typealias S = TargetFrame<A, B, C>
    typealias Left = ThreeContinuationRotations<S>.Left
    typealias Right = S.Left
}

enum FixedTailExchangeReturnsTheSameOriginalQuestion<A: Structure,
    B: Structure, C: Structure>: Null {
    typealias S = TargetFrame<A, B, C>
    typealias Left = ThreeContinuationTailExchanges<S>.Left
    typealias Right = S.Left
}

// Canonical reassembly compares the fields, not nominal wrapper identities.
enum SixRotationsAlsoReturnTheWhole<A: Structure, B: Structure,
    C: Structure>: Null {
    typealias S = TargetFrame<A, B, C>
    typealias End = ThreeContinuationRotations<ThreeContinuationRotations<S>>
    typealias Left = TargetFrame<End.Left, End.Right.Left, End.Right.Right>
    typealias Right = S
}

enum SixTailExchangesAlsoReturnTheWhole<A: Structure, B: Structure,
    C: Structure>: Null {
    typealias S = TargetFrame<A, B, C>
    typealias Left = ThreeContinuationTailExchanges<ThreeContinuationTailExchanges<S>>
    typealias Right = S
}

// Agreement and complete recoverability do not certify the original task.
// Both constructions are made from their actual source fields.
enum RewrittenTargetIsLocallyAgreed<A: Structure, B: Structure>: Null {
    typealias Result = Paired<Paired<B, B>, A>
    typealias Left = Result.Left.Left
    typealias Right = Result.Left.Right
}

enum RewrittenTargetStillRetainsTheWhole<A: Structure, B: Structure>: Null {
    typealias Result = Paired<Paired<B, B>, A>
    typealias Left = Paired<Result.Right, Result.Left.Left>
    typealias Right = Paired<A, B>
}

enum SourceBoundAgreementAnswersTheOriginalTarget<A: Structure,
    B: Structure>: Null {
    typealias Source = Paired<A, B>
    typealias Result = Paired<Paired<Source.Left, Source.Left>, Source.Right>
    typealias Left = Result.Left.Right
    typealias Right = Source.Left
}

// The source supplies two independent agreements. Either ordering preserves
// the relation in the first pair, without preserving which value fills it.
enum FirstPairAgreementSurvivesEitherOrdering<S: Pair>: Null
where S.Left: Null, S.Right: Null,
      S.Left.Left: Structure, S.Right.Left: Structure {
    typealias Exchanged = SwapBoundaryReading<S>.Answer
    typealias Left = Paired<S.Left.Left, Exchanged.Left.Left>
    typealias Right = Paired<S.Left.Right, Exchanged.Left.Right>
}

// The two encodings are interconvertible, but this application supplies no
// translation. The refusal concerns this unjoined constructor, not an
// impossibility of relating the memories or physical instance identity.
#if LEAST_DIFFERENT_MEMORY
enum RejectedUnjoinedObservationEncodings: Null {
    typealias OtherNext = JointEvidenceRetainsFirst<ContinuationNext, ContinuationNow>
    typealias Invalid = FramePairFromSufficientObservation<ContinuationSource,
        ActualNow, OtherNext>
    typealias Left = Invalid.Left
    typealias Right = Invalid.Right
}
#endif

#if LEAST_CURRENT_ONLY
enum RejectedPresentAnswerAsFutureAnswer: Null {
    typealias Invalid = FramePairFromSufficientObservation<ContinuationSource,
        ActualNow, ActualNow>
    typealias Left = Invalid.Left
    typealias Right = Invalid.Right
}
#endif

#if LEAST_WRONG_JOINT
enum RejectedResidualFromAnotherJointView: Null {
    typealias Other = JointEvidenceRetainsFirst<ContinuationNext, ContinuationNow>
    typealias Invalid = LeastJointEvidence<ContinuationNow, ContinuationNext, Other>
    typealias Left = Invalid.Left.Answer
    typealias Right = Invalid.Right.Answer
}
#endif

#if LEAST_WHOLE_RETURN
enum RejectedThreeCallsAsWholeSourceReturn: Null {
    typealias Left = ThreeContinuationTailExchanges<ContinuationSource>
    typealias Right = ContinuationSource
}
#endif

#if LEAST_INDEPENDENT_REPEATS
enum RejectedIndependentActionsAsOnePreservedAction: Null {
    typealias First = ExchangeContinuationTail<ContinuationSource>
    typealias Second = RotateThree<First>
    typealias Third = RotateThree<Second>
    typealias Left = Third.Left
    typealias Right = ContinuationSource.Left
}
#endif

#if LEAST_REWRITTEN_TARGET
enum RejectedPresentAgreementAsOriginalTaskCompletion: Null {
    typealias Source = Paired<ContinuationA, ContinuationB>
    typealias Result = Paired<Paired<Source.Right, Source.Right>, Source.Left>
    typealias Left = Result.Left.Right
    typealias Right = Source.Left
}
#endif

#if LEAST_RELATION_AS_VALUE
enum RejectedPreservedAgreementAsPreservedValue: Null {
    typealias Source = Paired<Paired<ContinuationA, ContinuationA>,
        Paired<ContinuationB, ContinuationB>>
    typealias Exchanged = SwapBoundaryReading<Source>.Answer
    typealias Left = Exchanged.Left.Left
    typealias Right = Source.Left.Left
}
#endif
