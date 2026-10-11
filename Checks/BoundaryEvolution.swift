import VerificationIsIdentification
import Examples

enum EvolutionLeft<A: IntegerValued>: Close, BeamShape {
    typealias AlphaLevel = A
    typealias BetaLevel = Never
    typealias PaschenLevel = Never
}
enum EvolutionRight<A: IntegerValued>: Close, BeamShape {
    typealias AlphaLevel = A
    typealias BetaLevel = Lit1
    typealias PaschenLevel = Lit1
}
enum EvolutionEvidence<A: IntegerValued, B: IntegerValued>: Pair {
    typealias Source = Paired<EvolutionLeft<A>, EvolutionRight<B>>
    typealias Advance = AdvancePreparedTrace<StartObservations<Source>, BoundaryFirstAlpha<Source>, BoundarySecondAlpha<Source>>
    typealias T = Advance.Next.Trace
    typealias F = RetainTraceAnswer<T, LastAnswerFromTrace<Advance.First.Trace>>
    typealias G = LastAnswerFromTrace<T>
    typealias Evidence = JointEvidenceFromMemory<F, G>
    typealias Left = Source
    typealias Right = T.Right
}
typealias Evolution00 = EvolutionEvidence<Never, Never>
typealias Evolution01 = EvolutionEvidence<Never, Lit1>
typealias Evolution10 = EvolutionEvidence<Lit1, Never>
typealias Evolution11 = EvolutionEvidence<Lit1, Lit1>

enum EvolutionJointRecoversImage<A: IntegerValued, B: IntegerValued>: Null {
    typealias E = EvolutionEvidence<A, B>
    typealias Left = E.Evidence.Left
    typealias Right = BoundaryPairReading<E.Source>
}
enum EvolutionJointDecoderReadsMemory<A: IntegerValued, B: IntegerValued>: Null {
    typealias E = EvolutionEvidence<A, B>
    typealias Left = E.Evidence.Right.Left
    typealias Right = E.T.Right
}

typealias EvolutionSwap00 = ReobservedTransition<SwapBoundaryTransition<Evolution00.Source>, AgreedBoundarySwap<BoundaryPairReading<Evolution00.Source>.Answer>>
typealias EvolutionSwap11 = ReobservedTransition<SwapBoundaryTransition<Evolution11.Source>, AgreedBoundarySwap<BoundaryPairReading<Evolution11.Source>.Answer>>
typealias EvolutionSwap01 = ReobservedTransition<SwapBoundaryTransition<Evolution01.Source>, ZeroSuccessorBoundarySwap<BoundaryPairReading<Evolution01.Source>.Answer, Never>>
typealias EvolutionSwap10 = ReobservedTransition<SwapBoundaryTransition<Evolution10.Source>, SuccessorZeroBoundarySwap<BoundaryPairReading<Evolution10.Source>.Answer, Never>>

enum EvolutionAllSwapClassesPreserved: Null {
    typealias Left = Paired<EvolutionSwap00.Left.Answer, Paired<EvolutionSwap11.Left.Answer, Paired<EvolutionSwap01.Left.Answer, EvolutionSwap10.Left.Answer>>>
    typealias Right = Paired<EvolutionSwap00.Right.Answer, Paired<EvolutionSwap11.Right.Answer, Paired<EvolutionSwap01.Right.Answer, EvolutionSwap10.Right.Answer>>>
}
enum EvolutionFailureSwapHasOneImageAction: Null {
    typealias Left = EvolutionSwap01.ImageStep
    typealias Right = EvolutionSwap10.ImageStep
}

// Use the three-class certificate itself as evidence. A question asking for
// the endpoint class identity reads only the old class image after the swap.
typealias EvolutionSwapClassQuestion = QuestionOnObservation<EvolutionSwap01.Right, IdentityReading<EvolutionSwap01.Right.Answer, BeamSpace, SaturationEncoding>>
typealias EvolutionFutureFromClass = QuestionAlongTransition<EvolutionSwap01, EvolutionSwapClassQuestion>
enum EvolutionCoarseFutureInput: Null {
    typealias Left = EvolutionFutureFromClass.Right.Left
    typealias Right = EvolutionSwap01.Left.Answer
}
typealias EvolutionInitialClassFactors = QuestionOnObservation<BoundaryPairReading<Evolution01.Source>, ZeroSuccessorBoundaryPairClass<BoundaryPairReading<Evolution01.Source>.Answer, Never>>
typealias EvolutionAcquiredClass = AnswerOnRefinement<EvolutionInitialClassFactors, Evolution01.Evidence>
typealias EvolutionSwapFromOldMemory = FutureOnEvidence<EvolutionSwap01, EvolutionSwapClassQuestion, EvolutionAcquiredClass>
enum EvolutionSwapUsesOldMemory: Null {
    typealias Left = EvolutionSwapFromOldMemory.Right.Left
    typealias Right = Evolution01.T.Right
}

// Swapping again has its actual successor as input, and restores the pair
// of concrete source components. No history identity is inferred.
typealias EvolutionSwapTwice = JoinedTransition<SwapBoundaryTransition<Evolution01.Source>, SwapBoundaryTransition<SwapBoundaryReading<Evolution01.Source>.Answer>>
enum EvolutionTwoSwapsRestoreSource: Null {
    typealias Left = EvolutionSwapTwice.SourceStep.Answer
    typealias Right = Evolution01.Source
}

typealias EvolutionReset00 = BoundaryFirstZeroTransition<Evolution00.Source>
typealias EvolutionReset01 = BoundaryFirstZeroTransition<Evolution01.Source>
typealias EvolutionReset10 = BoundaryFirstZeroTransition<Evolution10.Source>
typealias EvolutionReset11 = BoundaryFirstZeroTransition<Evolution11.Source>
typealias EvolutionAfter00 = QuestionOnObservation<EvolutionReset00.Right, AgreedBoundaryPairClass<EvolutionReset00.Right.Answer>>
typealias EvolutionAfter10 = QuestionOnObservation<EvolutionReset10.Right, AgreedBoundaryPairClass<EvolutionReset10.Right.Answer>>
typealias EvolutionAfter01 = QuestionOnObservation<EvolutionReset01.Right, ZeroSuccessorBoundaryPairClass<EvolutionReset01.Right.Answer, Never>>
typealias EvolutionAfter11 = QuestionOnObservation<EvolutionReset11.Right, ZeroSuccessorBoundaryPairClass<EvolutionReset11.Right.Answer, Never>>
typealias EvolutionFuture00 = FutureOnEvidence<EvolutionReset00, EvolutionAfter00, Evolution00.Evidence>
typealias EvolutionFuture01 = FutureOnEvidence<EvolutionReset01, EvolutionAfter01, Evolution01.Evidence>
typealias EvolutionFuture10 = FutureOnEvidence<EvolutionReset10, EvolutionAfter10, Evolution10.Evidence>
typealias EvolutionFuture11 = FutureOnEvidence<EvolutionReset11, EvolutionAfter11, Evolution11.Evidence>

enum EvolutionOldFailureOneClass: Null {
    typealias Left = EvolutionSwap01.Left.Answer
    typealias Right = EvolutionSwap10.Left.Answer
}
enum EvolutionResetSeparatesOldFailures: Null {
    typealias Left = Paired<EvolutionFuture01.Answer, EvolutionFuture10.Answer>
    typealias Right = Paired<EvolutionSwap01.Left.Answer, EvolutionSwap00.Left.Answer>
}
enum EvolutionResetClassTable: Null {
    typealias Left = Paired<EvolutionFuture00.Answer, Paired<EvolutionFuture01.Answer, Paired<EvolutionFuture10.Answer, EvolutionFuture11.Answer>>>
    typealias Right = Paired<EvolutionSwap00.Left.Answer, Paired<EvolutionSwap01.Left.Answer, Paired<EvolutionSwap00.Left.Answer, EvolutionSwap01.Left.Answer>>>
}
enum EvolutionFutureUsesOriginalMemory: Null {
    typealias Left = EvolutionFuture11.Right.Left
    typealias Right = Evolution11.T.Right
}
enum EvolutionFutureRetainsOperationInQuestion: Null {
    typealias Left = EvolutionFuture11.Predicate
    typealias Right = OperationSequence<FirstFieldsOperation, CommonBoundaryQuestion>
}

// Apply the specified source step beside the existing memory. The memory
// is unchanged, but its trace remains a record of the initial source.
typealias EvolutionActualStep11 = StepBeside<EvolutionReset11.SourceStep, Evolution11.T.Right>
typealias EvolutionHistory11 = RetainedWhole<EvolutionActualStep11.Left, EvolutionActualStep11.Right>
enum EvolutionActualMemoryUnchanged: Null {
    typealias Left = EvolutionActualStep11.Right.Right
    typealias Right = Evolution11.T.Right
}
enum EvolutionActualEndpointMatchesQuestion: Null {
    typealias Left = EvolutionActualStep11.Right.Left
    typealias Right = EvolutionAfter11.Left.Left
}
enum EvolutionOldValueStillReadable: Null {
    typealias Left = Evolution11.F.Right.Answer
    typealias Right = Lit1
}
enum EvolutionOldAlphaBecomesResidentBeta<A: IntegerValued, B: IntegerValued>: Null {
    typealias E = EvolutionEvidence<A, B>
    typealias W = ExchangeBoundaryFirst<E.Source>.Answer
    typealias Left = Paired<W.Left.BetaLevel, Paired<W.Left.PaschenLevel, W.Right>>
    typealias Right = Paired<E.Source.Left.AlphaLevel, Paired<E.Source.Left.PaschenLevel, E.Source.Right>>
}
enum EvolutionLocalZeroAndRetainedOne: Null {
    typealias W = EvolutionActualStep11.Right.Left
    typealias Left = Paired<W.Left.AlphaLevel, W.Left.BetaLevel>
    typealias Right = Paired<ZeroSuccessorDistinction<Never>.Left, ZeroSuccessorDistinction<Never>.Right>
}
enum EvolutionHistoryKeepsActualPredecessor: Null {
    typealias Left = EvolutionHistory11.Right.Left
    typealias Right = EvolutionActualStep11.Left
}

// The exchange itself also exists without a blank beta, but the zero-image
// square is then inappropriate. The reservoir condition is independently real.
typealias EvolutionOccupied = Paired<EvolutionRight<Never>, EvolutionLeft<Never>>
enum EvolutionOccupiedDoesNotProduceZero: Null {
    typealias Left = ExchangeBoundaryFirst<EvolutionOccupied>.Answer.Left.AlphaLevel
    typealias Right = Lit1
}

enum EvolutionSecondExchangeRestoresAlpha<A: IntegerValued, B: IntegerValued>: Null {
    typealias E = EvolutionEvidence<A, B>
    typealias Second = ExchangeBoundaryFirst<ExchangedBoundaryFirst<E.Source>>
    typealias Left = Second.Answer.Left.AlphaLevel
    typealias Right = E.Source.Left.AlphaLevel
}
enum EvolutionUpdatedImagesConflateReserve: Null {
    typealias Left = EvolutionReset00.Right.Answer
    typealias Right = EvolutionReset10.Right.Answer
}
enum EvolutionReserveSeparatesNextAnswers: Null {
    typealias Left = Paired<ExchangeBoundaryFirst<ExchangedBoundaryFirst<Evolution00.Source>>.Answer.Left.AlphaLevel, ExchangeBoundaryFirst<ExchangedBoundaryFirst<Evolution10.Source>>.Answer.Left.AlphaLevel>
    typealias Right = Paired<ZeroSuccessorDistinction<Never>.Left, ZeroSuccessorDistinction<Never>.Right>
}

#if EVOLUTION_FALSE_COARSE_RESET
enum RejectedEvolutionCoarseReset: Null {
    typealias Left = EvolutionFuture01.Answer
    typealias Right = EvolutionFuture10.Answer
}
#endif
#if EVOLUTION_UNPREPARED_ZERO_IMAGE
typealias RejectedEvolutionUnprepared = BoundaryFirstZeroTransition<EvolutionOccupied>
#endif
#if EVOLUTION_REUSES_ZERO_AFTER_CONSUMPTION
typealias RejectedEvolutionConsumed = BoundaryFirstZeroTransition<ExchangedBoundaryFirst<Evolution11.Source>>
#endif
#if EVOLUTION_OLD_FACT_IS_FRESH_TRACE
typealias RejectedEvolutionFreshTrace = AppendObservation<Evolution11.T, BoundaryFirstAlpha<ExchangedBoundaryFirst<Evolution11.Source>>>
#endif
#if EVOLUTION_OLD_READING_IS_CURRENT
typealias RejectedEvolutionOldReading = JoinedVerdict<Evolution11.F.Left, BoundaryFirstAlpha<ExchangedBoundaryFirst<Evolution11.Source>>>
#endif
#if EVOLUTION_WRONG_ACTUAL_ENDPOINT
typealias RejectedEvolutionEndpoint = FutureOnEvidence<EvolutionReset11, EvolutionAfter01, Evolution11.Evidence>
#endif
#if EVOLUTION_EQUAL_VALUE_FOREIGN_EVIDENCE
typealias EvolutionForeignSource = Paired<EvolutionRight<Lit1>, EvolutionLeft<Lit1>>
typealias EvolutionForeignFirst = AppendObservation<StartObservations<EvolutionForeignSource>, BoundaryFirstAlpha<EvolutionForeignSource>>
typealias EvolutionForeignTrace = AppendObservation<EvolutionForeignFirst, BoundarySecondAlpha<EvolutionForeignSource>>
typealias EvolutionForeignF = RetainTraceAnswer<EvolutionForeignTrace, LastAnswerFromTrace<EvolutionForeignFirst>>
typealias EvolutionForeignG = LastAnswerFromTrace<EvolutionForeignTrace>
typealias RejectedEvolutionForeign = FutureOnEvidence<EvolutionReset11, EvolutionAfter11, JointEvidenceFromMemory<EvolutionForeignF, EvolutionForeignG>>
#endif
#if EVOLUTION_FUTURE_OMITS_OPERATION
enum RejectedEvolutionQuestion: Null {
    typealias Left = EvolutionFuture11.Predicate
    typealias Right = CommonBoundaryQuestion
}
#endif
#if EVOLUTION_LOCAL_RESET_ERASES_OLD_VALUE
enum RejectedEvolutionErasure: Null {
    typealias Left = EvolutionActualStep11.Right.Left.Left.BetaLevel
    typealias Right = Never
}
#endif
#if EVOLUTION_SWAPS_WITH_OLD_ENDPOINT
typealias RejectedEvolutionSwapSeam = JoinedTransition<SwapBoundaryTransition<Evolution01.Source>, SwapBoundaryTransition<Evolution01.Source>>
#endif
#if EVOLUTION_HISTORY_IS_RETURNED_SOURCE
enum RejectedEvolutionHistory: Null {
    typealias Left = EvolutionHistory11.Right
    typealias Right = EvolutionActualStep11.Left
}
#endif
