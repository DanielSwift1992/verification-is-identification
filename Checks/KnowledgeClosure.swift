import VerificationIsIdentification
import Examples

// Generic answers and actual decoder inputs. No expected answer is a premise.
enum KnowledgeThreeCases<B: BeamShape & Structure>: Null {
    typealias Left = Paired<KnowledgeCurrent<B>.Answer, Paired<KnowledgeSwapFromTwo<B>.Answer, KnowledgeMixedFromThree<B>.Answer>>
    typealias Right = FullSpectrumImage<B>
}
enum KnowledgeTwoReadsUseSameMemory<B: BeamShape & Structure>: Null {
    typealias Left = KnowledgeCurrent<B>.Right.Left
    typealias Right = KnowledgeSwapFromTwo<B>.Right.Left
}
enum KnowledgeMixedUsesOnlyNewMemory<B: BeamShape & Structure>: Null {
    typealias Left = KnowledgeMixedFromThree<B>.Right.Left
    typealias Right = ResidentThreeFacts<KnowledgeAcquisition<B>.Right>
}
enum KnowledgeIndependentMixedQuestion<B: BeamShape & Structure>: Null {
    typealias Left = KnowledgeMixedFromThree<B>.Left
    typealias Right = KnowledgeMixedQuestion<B>
}
enum KnowledgeOldMemoryOmitsHidden<A: IntegerValued, B: IntegerValued, H: IntegerValued, K: IntegerValued>: Null {
    typealias Left = KnowledgeOldObservation<BoundaryBeam<A, B, H>>.Answer
    typealias Right = KnowledgeOldObservation<BoundaryBeam<A, B, K>>.Answer
}
enum KnowledgeOldDecoderOmitsHidden<A: IntegerValued, B: IntegerValued, H: IntegerValued, K: IntegerValued>: Null {
    typealias Left = KnowledgeSwapFromTwo<BoundaryBeam<A, B, H>>.Right
    typealias Right = KnowledgeSwapFromTwo<BoundaryBeam<A, B, K>>.Right
}
enum KnowledgeEarlierFactsStillUsable<B: BeamShape & Structure>: Null {
    typealias Reused = AnswerOnRefinement<KnowledgeSwapFromTwo<B>, KnowledgeRetainsOld<B>>
    typealias Left = Paired<Reused.Answer, Reused.Right.Left>
    typealias Right = Paired<B.BetaLevel, KnowledgeObservation<B>.Answer>
}

// Every supplied compatible path over the full image reuses these records.
// The generator constructors and JoinedTransition give the induction grammar.
enum KnowledgeAnyCertifiedContinuation<
    B: BeamShape & Structure,
    P: CommutingTransition,
    F: ReadingFactors
>: Null
where P.Left == FullSpectrumReading<B>, F.Observation == P.Right {
    typealias Reused = FutureOnEvidence<P, F, KnowledgeFromThree<B>>
    typealias Left = Reused.Right.Left
    typealias Right = KnowledgeObservation<B>.Answer
}

// At the intermediate cut only two instruments have signalled. The third
// channel and its blank are already present, independent of its future answer.
enum KnowledgeThirdWasAlreadyResident<B: BeamShape & Structure>: Null {
    typealias Run = KnowledgeAcquisition<B>
    typealias Left = Run.First.Left.Right
    typealias Right = Run.Last.Left.Right
}
enum KnowledgeThirdStillQuietAfterTwo<B: BeamShape & Structure>: Null {
    typealias Left = KnowledgeAcquisition<B>.First.Right.Right.Right.Left
    typealias Right = ExperimentQuiet
}
enum KnowledgeTwoFactsAtIntermediateCut<B: BeamShape & Structure>: Null {
    typealias Left = ResidentProbeFacts<KnowledgeAcquisition<B>.First.Right.Left>
    typealias Right = KnowledgeOldObservation<B>.Answer
}
enum KnowledgeThirdInstrumentOmitsSource<A: IntegerValued, B: IntegerValued, H: IntegerValued, K: IntegerValued>: Null {
    typealias Left = KnowledgeAcquisition<BoundaryBeam<A, B, H>>.Last.Left.Right
    typealias Right = KnowledgeAcquisition<BoundaryBeam<A, B, K>>.Last.Left.Right
}

// The command word is resident before any acquisition. Instrument memory
// survives the actual source transition. Both command heads are retained.
enum KnowledgeResidentAnswerMatchesPrediction<B: BeamShape & Structure>: Null {
    typealias Run = KnowledgeResidentRun<B>
    typealias Left = SpectrumAlphaSource<Run.Right.Left.Left>.Answer
    typealias Right = KnowledgeMixedFromThree<B>.Answer
}
enum KnowledgeResidentEndpointMatchesQuestion<B: BeamShape & Structure>: Null {
    typealias Left = KnowledgeResidentRun<B>.Right.Left.Left
    typealias Right = KnowledgeMixedPath<B>.SourceStep.Answer
}
enum KnowledgeResidentBankUnchanged<B: BeamShape & Structure>: Null {
    typealias Run = KnowledgeResidentRun<B>
    typealias Left = Run.Execution.Left.Right
    typealias Right = Run.Execution.Right.Right
}
enum KnowledgeResidentTapeConsumedInside<B: BeamShape & Structure>: Null {
    typealias Left = KnowledgeResidentRun<B>.Right.Left.Right
    typealias Right = Paired<Never, Paired<SwapOperation, Paired<SwapBetaHiddenOperation, Never>>>
}
enum KnowledgeMemoryReadableAfterCommands<B: BeamShape & Structure>: Null {
    typealias W = KnowledgeResidentRun<B>.Right
    typealias View = Paired<Paired<W.Left.Left, W.Right.Left>, W.Right.Right>
    typealias Left = ResidentThreeFacts<View>
    typealias Right = KnowledgeMixedFromThree<B>.Right.Left
}

// Positive binary separators witness each indispensable coordinate.
typealias ClosureKnowledge000 = BoundaryBeam<Never, Never, Never>
typealias ClosureKnowledge100 = BoundaryBeam<Lit1, Never, Never>
typealias ClosureKnowledge010 = BoundaryBeam<Never, Lit1, Never>
typealias ClosureKnowledge001 = BoundaryBeam<Never, Never, Lit1>
typealias KnowledgeNeedFirst = ZeroSuccessorBoundary<SpectrumAlphaSource<ClosureKnowledge000>, SpectrumAlphaSource<ClosureKnowledge100>, Never>
typealias KnowledgeNeedSecond = ZeroSuccessorBoundary<KnowledgeSwapFromTwo<ClosureKnowledge000>.Left, KnowledgeSwapFromTwo<ClosureKnowledge010>.Left, Never>
typealias KnowledgeNeedThird = ZeroSuccessorBoundary<KnowledgeMixedQuestion<ClosureKnowledge000>, KnowledgeMixedQuestion<ClosureKnowledge001>, Never>
enum KnowledgeCurrentCannotDistinguishSecond: Null {
    typealias Left = FactOf<SpectrumAlphaSource<ClosureKnowledge000>>
    typealias Right = FactOf<SpectrumAlphaSource<ClosureKnowledge010>>
}
enum KnowledgeAllOldFactsCannotDistinguishThird: Null {
    typealias Left = KnowledgeOldObservation<ClosureKnowledge000>.Answer
    typealias Right = KnowledgeOldObservation<ClosureKnowledge001>.Answer
}

// A reverse word is a different question and exposes a different coordinate.
typealias KnowledgeReverse = JoinedTransition<SpectrumFirstTransition<ClosureKnowledge001>, SpectrumSecondTransition<SwapVisible<ClosureKnowledge001>>>
typealias KnowledgeReverseAnswer = FutureOnEvidence<KnowledgeReverse, SpectrumAlphaFactors<SwapBetaHidden<SwapVisible<ClosureKnowledge001>>>, KnowledgeFromThree<ClosureKnowledge001>>
enum KnowledgeWordOrderMatters: Null {
    typealias Left = Paired<KnowledgeReverseAnswer.Answer, KnowledgeMixedFromThree<ClosureKnowledge001>.Answer>
    typealias Right = Paired<Never, Lit1>
}

enum KnowledgeForeign: Close, BeamShape {
    typealias AlphaLevel = Never
    typealias BetaLevel = Never
    typealias PaschenLevel = Never
}
enum KnowledgeForeignFactsCanMatch: Null {
    typealias Left = KnowledgeObservation<ClosureKnowledge000>.Answer
    typealias Right = KnowledgeObservation<KnowledgeForeign>.Answer
}

// Retention at an address is not yet strict temporal order. This positive
// inhabitant stays outside the declared finite-tree history grammar.
enum KnowledgeRetentionDoesNotForceAdvance: Null {
    typealias Left = StationaryRetention.Left
    typealias Right = StationaryRetention.Right
}

#if KCLOSURE_CURRENT_IS_SWAP
enum RejectedKnowledgeCurrent: Null {
    typealias Left = KnowledgeCurrent<ClosureKnowledge010>.Answer
    typealias Right = KnowledgeSwapFromTwo<ClosureKnowledge010>.Answer
}
#endif
#if KCLOSURE_OLD_MEMORY_IS_COMPLETE
enum RejectedKnowledgeOldComplete: Null {
    typealias Left = KnowledgeFromThree<ClosureKnowledge001>.Right.Left
    typealias Right = KnowledgeOldObservation<ClosureKnowledge001>.Answer
}
#endif
#if KCLOSURE_ONE_OLD_ANSWER_FOR_HIDDEN
enum RejectedKnowledgeHidden: Null {
    typealias Left = KnowledgeMixedQuestion<ClosureKnowledge000>.Answer
    typealias Right = KnowledgeMixedQuestion<ClosureKnowledge001>.Answer
}
#endif
#if KCLOSURE_FOREIGN_ACQUISITION
typealias RejectedKnowledgeForeign = FutureOnEvidence<KnowledgeMixedPath<ClosureKnowledge000>, SpectrumAlphaFactors<SwapVisible<SwapBetaHidden<ClosureKnowledge000>>>, KnowledgeFromThree<KnowledgeForeign>>
#endif
#if KCLOSURE_QUESTION_OMITS_OPERATION
enum RejectedKnowledgeQuestion: Null {
    typealias Left = KnowledgeMixedFromThree<ClosureKnowledge001>.Predicate
    typealias Right = AlphaQuestion
}
#endif
#if KCLOSURE_REVERSED_WORD
enum RejectedKnowledgeOrder: Null {
    typealias Left = KnowledgeReverseAnswer.Answer
    typealias Right = KnowledgeMixedFromThree<ClosureKnowledge001>.Answer
}
#endif
#if KCLOSURE_WRONG_TAPE_HEAD
typealias RejectedKnowledgeTape = ResidentBoundaryCommand<HiddenSwapSource<ClosureKnowledge001>, Paired<SwapOperation, Never>, Never>
#endif
#if KCLOSURE_SKIPS_RESIDENT_FOCUS
typealias RejectedKnowledgeFocus = FollowedPair<KnowledgeAcquisition<ClosureKnowledge001>.First, KnowledgeAcquisition<ClosureKnowledge001>.Third>
#endif
#if KCLOSURE_FORGED_THIRD_FACT
enum RejectedKnowledgeForged: ReadingFactors {
    typealias Left = FullSpectrumReading<ClosureKnowledge001>
    typealias Observation = KnowledgeObservation<ClosureKnowledge001>
    typealias Right = KnowledgeCoordinates<KnowledgeObservation<ClosureKnowledge000>.Answer>
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = FullSpectrumQuestion
    typealias Answer = Left.Answer
}
#endif
