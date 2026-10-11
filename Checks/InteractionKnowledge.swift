import VerificationIsIdentification
import Examples

enum KnowledgeBeam<A: IntegerValued, B: IntegerValued, C: IntegerValued>: Close, BeamShape {
    typealias AlphaLevel = A
    typealias BetaLevel = B
    typealias PaschenLevel = C
}

typealias Knowledge000 = KnowledgeBeam<Never, Never, Never>
typealias Knowledge001 = KnowledgeBeam<Never, Never, Lit1>
typealias Knowledge010 = KnowledgeBeam<Never, Lit1, Never>
typealias Knowledge011 = KnowledgeBeam<Never, Lit1, Lit1>
typealias Knowledge100 = KnowledgeBeam<Lit1, Never, Never>
typealias Knowledge101 = KnowledgeBeam<Lit1, Never, Lit1>
typealias Knowledge110 = KnowledgeBeam<Lit1, Lit1, Never>
typealias Knowledge111 = KnowledgeBeam<Lit1, Lit1, Lit1>

enum KnowledgeTwin010: Close, BeamShape {
    typealias AlphaLevel = Never
    typealias BetaLevel = Lit1
    typealias PaschenLevel = Never
}

// One generic acquisition relation serves all three classification clauses.
typealias AcquiredReadyClass<B: BeamShape & Structure> = AnswerFromAcquiredObservation<ReadyClassFactors<B>>
where B.AlphaLevel == B.PaschenLevel

typealias AcquiredZeroClass<B: BeamShape & Structure, N: IntegerValued> = AnswerFromAcquiredObservation<ZeroBlockedClassFactors<B, N>>
where B.AlphaLevel == Never, B.PaschenLevel == Examples.Succ<N>

typealias AcquiredSuccessorClass<B: BeamShape & Structure, N: IntegerValued> = AnswerFromAcquiredObservation<SuccessorBlockedClassFactors<B, N>>
where B.AlphaLevel == Examples.Succ<N>, B.PaschenLevel == Never

enum AcquiredReadyPayload<B: BeamShape & Structure>: Null
where B.AlphaLevel == B.PaschenLevel {
    typealias Left = AcquiredReadyClass<B>.Right.Answer
    typealias Right = ReadyAlpha<B.AlphaLevel, B.BetaLevel>
}

enum AcquiredZeroPayload<B: BeamShape & Structure, N: IntegerValued>: Null
where B.AlphaLevel == Never, B.PaschenLevel == Examples.Succ<N> {
    typealias Left = AcquiredZeroClass<B, N>.Right.Answer
    typealias Right = BlockedAlpha<Never>
}

enum AcquiredSuccessorPayload<B: BeamShape & Structure, N: IntegerValued>: Null
where B.AlphaLevel == Examples.Succ<N>, B.PaschenLevel == Never {
    typealias Left = AcquiredSuccessorClass<B, N>.Right.Answer
    typealias Right = BlockedAlpha<Examples.Succ<N>>
}

// Equal complete images give the exact same decoder type despite distinct
// source names. The acquisition certificates still have their own sources.
enum SameImageSameFactDecoder<A: BeamShape & Structure, B: BeamShape & Structure>: Null
where FullSpectrumImage<A> == FullSpectrumImage<B>, A.AlphaLevel == A.PaschenLevel {
    typealias Left = AcquiredReadyClass<A>.Right
    typealias Right = AcquiredReadyClass<B>.Right
}

typealias TwinDecoder = SameImageSameFactDecoder<Knowledge010, KnowledgeTwin010>

// Each independently specified present question factors through the class
// and then the acquired full image. The final decoder's input is the fact.
typealias ReadyCurrentFromFact<B: BeamShape & Structure> = AnswerOnRefinement<ReadyAlphaFactors<B>, AcquiredReadyClass<B>>
where B.AlphaLevel == B.PaschenLevel

typealias ZeroCurrentFromFact<B: BeamShape & Structure, N: IntegerValued> = AnswerOnRefinement<ZeroBlockedAlphaFactors<B, N>, AcquiredZeroClass<B, N>>
where B.AlphaLevel == Never, B.PaschenLevel == Examples.Succ<N>

typealias SuccessorCurrentFromFact<B: BeamShape & Structure, N: IntegerValued> = AnswerOnRefinement<SuccessorBlockedAlphaFactors<B, N>, AcquiredSuccessorClass<B, N>>
where B.AlphaLevel == Examples.Succ<N>, B.PaschenLevel == Never

typealias KnownCurrent000 = ReadyCurrentFromFact<Knowledge000>
typealias KnownCurrent001 = ZeroCurrentFromFact<Knowledge001, Never>
typealias KnownCurrent010 = ReadyCurrentFromFact<Knowledge010>
typealias KnownCurrent011 = ZeroCurrentFromFact<Knowledge011, Never>
typealias KnownCurrent100 = SuccessorCurrentFromFact<Knowledge100, Never>
typealias KnownCurrent101 = ReadyCurrentFromFact<Knowledge101>
typealias KnownCurrent110 = SuccessorCurrentFromFact<Knowledge110, Never>
typealias KnownCurrent111 = ReadyCurrentFromFact<Knowledge111>

// No final equality, output-image assumption or arbitrary decoder is supplied.
typealias ExitFromZero<B: BeamShape & Structure, N: IntegerValued> = FutureOnEvidence<
    ZeroSuccessorClassTransition<B, N>,
    SuccessorBlockedAlphaFactors<SwapVisible<B>, N>,
    AcquiredReadyClass<B>
>
where B.AlphaLevel == Never, B.BetaLevel == Examples.Succ<N>, B.PaschenLevel == Never

typealias ExitFromSuccessor<B: BeamShape & Structure, N: IntegerValued> = FutureOnEvidence<
    SuccessorZeroClassTransition<B, N>,
    ZeroBlockedAlphaFactors<SwapVisible<B>, N>,
    AcquiredReadyClass<B>
>
where B.AlphaLevel == Examples.Succ<N>, B.BetaLevel == Never, B.PaschenLevel == Examples.Succ<N>

enum ExitAnswerIsOldBeta<B: BeamShape & Structure, N: IntegerValued>: Null
where B.AlphaLevel == Never, B.BetaLevel == Examples.Succ<N>, B.PaschenLevel == Never {
    typealias Left = ExitFromZero<B, N>.Right.Answer
    typealias Right = B.BetaLevel
}

enum ReverseExitAnswerIsZero<B: BeamShape & Structure, N: IntegerValued>: Null
where B.AlphaLevel == Examples.Succ<N>, B.BetaLevel == Never, B.PaschenLevel == Examples.Succ<N> {
    typealias Left = ExitFromSuccessor<B, N>.Right.Answer
    typealias Right = Never
}

enum ExitUsesOnlyOriginalFact<B: BeamShape & Structure, N: IntegerValued>: Null
where B.AlphaLevel == Never, B.BetaLevel == Examples.Succ<N>, B.PaschenLevel == Never {
    typealias Left = ExitFromZero<B, N>.Right.Left
    typealias Right = FactOf<FullSpectrumReading<B>>
}

// A path may have any constructed length. Appending the same branch at its
// actual new source leaves it in the branch again. This is the induction step.
enum RepeatClassIsClosed<P: CommutingTransition, B: BeamShape>: Null
where P.Right == ReadyClassReading<B>,
      B.AlphaLevel == B.PaschenLevel, B.AlphaLevel == B.BetaLevel {
    typealias Next = AppendRepeatClass<P, B>
    typealias Further = AppendRepeatClass<Next, SwapVisible<B>>
    typealias Left = Further.Right.Answer
    typealias Right = P.Right.Answer
}

// The initial evidence is fixed while the certified path may be extended.
enum EveryConstructedFutureUsesSameEvidence<
    P: CommutingTransition, F: ReadingFactors, G: ReadingFactors
>: Null
where F.Observation == P.Right, G.Left == P.Left {
    typealias Left = FutureOnEvidence<P, F, G>.Right.Left
    typealias Right = G.Observation.Answer
}

enum EveryConstructedFutureHasEndpointAnswer<
    P: CommutingTransition, F: ReadingFactors, G: ReadingFactors
>: VerdictIsInvariant
where F.Observation == P.Right, G.Left == P.Left {
    typealias Left = FutureOnEvidence<P, F, G>.Right
    typealias Right = QuestionAlongTransition<P, F>.Left
    typealias Sigma = F.Sigma
    typealias Encoding = F.Encoding
    typealias Predicate = OperationSequence<P.Operation, F.Predicate>
    typealias Answer = F.Answer
}

typealias ThreeClassSteps<B: BeamShape> = AppendRepeatClass<
    AppendRepeatClass<RepeatClassTransition<B>, SwapVisible<B>>,
    SwapVisible<SwapVisible<B>>
>
where B.AlphaLevel == B.PaschenLevel, B.AlphaLevel == B.BetaLevel

typealias ThreeClassFuture<B: BeamShape & Structure> = FutureOnEvidence<
    ThreeClassSteps<B>,
    ReadyAlphaFactors<SwapVisible<SwapVisible<SwapVisible<B>>>>,
    AcquiredReadyClass<B>
>
where B.AlphaLevel == B.PaschenLevel, B.AlphaLevel == B.BetaLevel

typealias KnownRepeatedZero = ThreeClassFuture<Knowledge000>
typealias KnownRepeatedOne = ThreeClassFuture<Knowledge111>

// Vertical and horizontal composition have identical boundary readings and
// steps. This is not equality of the nominal proof expressions themselves.
enum RepresentationPathInterchange<
    P0: CommutingTransition, P1: CommutingTransition,
    Q0: CommutingTransition, Q1: CommutingTransition
>: Null
where P0.Right == P1.Left, Q0.Right == Q1.Left,
      P0.ImageStep == Q0.SourceStep, P1.ImageStep == Q1.SourceStep {
    typealias AcrossThenDown = ReobservedTransition<JoinedTransition<P0, P1>, JoinedTransition<Q0, Q1>>
    typealias DownThenAcross = JoinedTransition<ReobservedTransition<P0, Q0>, ReobservedTransition<P1, Q1>>
    typealias Left = Paired<AcrossThenDown.Left, Paired<AcrossThenDown.Right, Paired<AcrossThenDown.SourceStep, AcrossThenDown.ImageStep>>>
    typealias Right = Paired<DownThenAcross.Left, Paired<DownThenAcross.Right, Paired<DownThenAcross.SourceStep, DownThenAcross.ImageStep>>>
}

typealias ConcreteInterchange = RepresentationPathInterchange<
    MatchedSwapTransition<Knowledge111>,
    MatchedSwapTransition<SwapVisible<Knowledge111>>,
    RepeatSpectrumClassTransition<FullSpectrumImage<Knowledge111>>,
    RepeatSpectrumClassTransition<FullSpectrumImage<SwapVisible<Knowledge111>>>
>

// The blocked sources share the old class decoder, not the full source.
enum BlockedKnowledgeSharesDecoder: SharedDecoder {
    typealias Left = ZeroBlockedAlphaFactors<Knowledge001, Never>
    typealias Right = ZeroBlockedAlphaFactors<Knowledge011, Never>
}
typealias BlockedKnowledgeAgrees = AnswersThroughSharedDecoder<BlockedKnowledgeSharesDecoder>

// Enlarging the action vocabulary exposes the omitted beta. The old full
// fact suffices; the old minimal class cannot supply this new distinction.
typealias NewVocabularyQuestion<B: BeamShape> = QuestionAlongTransition<
    SpectrumFirstTransition<B>,
    SpectrumAlphaFactors<SwapVisible<B>>
>
typealias NewVocabularyFromOldFact<B: BeamShape & Structure> = AnswerFromAcquiredObservation<NewVocabularyQuestion<B>>

enum OldClassStillEqual: Null {
    typealias Left = ZeroBlockedClassReading<Knowledge001, Never>.Answer
    typealias Right = ZeroBlockedClassReading<Knowledge011, Never>.Answer
}

enum NewQuestionDistinguishesOldClass: Null {
    typealias Left = Paired<NewVocabularyFromOldFact<Knowledge001>.Answer, NewVocabularyFromOldFact<Knowledge011>.Answer>
    typealias Right = Paired<ZeroSuccessorDistinction<Never>.Left, ZeroSuccessorDistinction<Never>.Right>
}

enum EnlargedVocabularyUsesOldFact<B: BeamShape & Structure>: Null {
    typealias Left = NewVocabularyFromOldFact<B>.Right.Left
    typealias Right = FactOf<FullSpectrumReading<B>>
}

#if KNOWLEDGE_CLASS_FROM_ALPHA_FACT
typealias RejectedClassFromAlpha = AnswerOnRefinement<ReadyClassFactors<Knowledge010>, AcquireAnswer<SpectrumAlphaSource<Knowledge010>>>
#endif

#if KNOWLEDGE_CLASS_FROM_OTHER_SOURCE
typealias RejectedOtherSourceFact = AnswerOnRefinement<ReadyClassFactors<Knowledge010>, AcquireAnswer<FullSpectrumReading<KnowledgeTwin010>>>
#endif

#if KNOWLEDGE_OTHER_FACT_QUESTION
typealias MisnamedFullFact = AnswerFact<BeamSpace, SaturationEncoding, AlphaQuestion, FullSpectrumImage<Knowledge010>>
typealias RejectedFactQuestion = SequentialReading<IdentityReading<MisnamedFullFact, BeamSpace, SaturationEncoding>, AcquiredReadyClass<Knowledge010>.Right>
#endif

#if KNOWLEDGE_DECODER_FROM_SOURCE
typealias RejectedSourceAsFact = SequentialReading<IdentityReading<Knowledge010, BeamSpace, SaturationEncoding>, AcquiredReadyClass<Knowledge010>.Right>
#endif

#if KNOWLEDGE_BLOCKED_FACT_INVENTS_ACTION
typealias RejectedBlockedFactAction = DecodeRefinedEvidence<AcquiredZeroClass<Knowledge001, Never>.Right, RepeatReadyImage<Never>>
#endif

#if KNOWLEDGE_REPEATS_EXIT
typealias RejectedExitContinuation = JoinedTransition<ZeroSuccessorClassTransition<Knowledge010, Never>, RepeatClassTransition<Knowledge111>>
#endif

#if KNOWLEDGE_FUTURE_OTHER_ENDPOINT
typealias RejectedKnowledgeEndpoint = FutureOnEvidence<ZeroSuccessorClassTransition<Knowledge010, Never>, SuccessorBlockedAlphaFactors<Knowledge100, Never>, AcquiredReadyClass<Knowledge010>>
#endif

#if KNOWLEDGE_FUTURE_OTHER_INITIAL_EVIDENCE
typealias RejectedKnowledgeInitialEvidence = FutureOnEvidence<ZeroSuccessorClassTransition<Knowledge010, Never>, SuccessorBlockedAlphaFactors<SwapVisible<Knowledge010>, Never>, AcquiredReadyClass<Knowledge000>>
#endif

#if KNOWLEDGE_FUTURE_ERASES_PATH
enum RejectedKnowledgePathErasure: Null {
    typealias Left = ExitFromZero<Knowledge010, Never>.Predicate
    typealias Right = AlphaQuestion
}
#endif

#if KNOWLEDGE_REOBSERVES_OTHER_IMAGE
typealias RejectedReobservationImage = ReobservedTransition<MatchedSwapTransition<Knowledge000>, RepeatSpectrumClassTransition<FullSpectrumImage<Knowledge111>>>
#endif

#if KNOWLEDGE_REOBSERVES_TOTAL_AS_PARTIAL
typealias RejectedReobservationOperation = ReobservedTransition<SpectrumFirstTransition<Knowledge000>, RepeatSpectrumClassTransition<FullSpectrumImage<Knowledge000>>>
#endif

#if KNOWLEDGE_APPENDS_OTHER_SOURCE
typealias RejectedRepeatSource = AppendRepeatClass<RepeatClassTransition<Knowledge111>, Knowledge111>
#endif

#if KNOWLEDGE_NEW_ACTION_FROM_OLD_CLASS
typealias RejectedNewActionFromClass = AnswerOnRefinement<NewVocabularyQuestion<Knowledge001>, AcquireAnswer<ZeroBlockedClassReading<Knowledge001, Never>>>
#endif

#if KNOWLEDGE_NEW_ANSWERS_AGREE
typealias RejectedNewVocabularyAgreement = JoinedVerdict<NewVocabularyFromOldFact<Knowledge001>.Right, NewVocabularyFromOldFact<Knowledge011>.Right>
#endif

#if KNOWLEDGE_CLASS_IS_FULL_IMAGE
enum RejectedClassAsFullImage: Null {
    typealias Left = AcquiredZeroClass<Knowledge001, Never>.Answer
    typealias Right = FullSpectrumImage<Knowledge001>
}
#endif

#if KNOWLEDGE_ANSWER_IS_SOURCE_IDENTITY
enum RejectedKnowledgeSourceIdentity: Null {
    typealias Left = BlockedKnowledgeAgrees.Left.Left
    typealias Right = BlockedKnowledgeAgrees.Right.Left
}
#endif

#if KNOWLEDGE_EQUAL_BOUNDARIES_IDENTIFY_PROOFS
enum RejectedInterchangeProofIdentity: Null {
    typealias Left = ConcreteInterchange.AcrossThenDown
    typealias Right = ConcreteInterchange.DownThenAcross
}
#endif
