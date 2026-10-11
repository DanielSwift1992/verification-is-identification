import VerificationIsIdentification
import Examples

enum ObserverBeam<A: IntegerValued, B: IntegerValued, C: IntegerValued>: Close, BeamShape {
    typealias AlphaLevel = A
    typealias BetaLevel = B
    typealias PaschenLevel = C
}

typealias Observer000 = ObserverBeam<Never, Never, Never>
typealias Observer001 = ObserverBeam<Never, Never, Lit1>
typealias Observer010 = ObserverBeam<Never, Lit1, Never>
typealias Observer011 = ObserverBeam<Never, Lit1, Lit1>
typealias Observer100 = ObserverBeam<Lit1, Never, Never>
typealias Observer101 = ObserverBeam<Lit1, Never, Lit1>
typealias Observer110 = ObserverBeam<Lit1, Lit1, Never>
typealias Observer111 = ObserverBeam<Lit1, Lit1, Lit1>

enum ObserverTwin001: Close, BeamShape {
    typealias AlphaLevel = Never
    typealias BetaLevel = Never
    typealias PaschenLevel = Lit1
}

// The channel address is identical even when the measured values differ.
enum ChannelContainsNoSourceAnswer<A: BeamShape, B: BeamShape>: Null {
    typealias Left = ChannelOf<SpectrumBetaSource<A>>
    typealias Right = ChannelOf<SpectrumBetaSource<B>>
}

// Recovery uses only output fields, not the original T or R as decoder inputs.
enum WholePreparedInputRecovered<T: ObservationTrace, R: PredicateReading>: Null
where T.Left == R.Left, T.Left: Structure {
    typealias Step = PreparedTraceExtension<T, R>
    typealias Earlier = PreparedPredecessor<Step.Right>
    typealias Left = Paired<Earlier.Left, Earlier.Right>
    typealias Right = Step.Left
}

enum SameSourceAcrossAcquisition<T: ObservationTrace, R: PredicateReading>: Null
where T.Left == R.Left, T.Left: Structure {
    typealias Step = PreparedTraceExtension<T, R>
    typealias Left = Step.Right.Left
    typealias Right = R.Left
}

enum AcquisitionRetainsOldMemory<T: ObservationTrace, R: PredicateReading>: Null
where T.Left == R.Left, T.Left: Structure {
    typealias Step = PreparedTraceExtension<T, R>
    typealias Left = Step.Right.Right.Right.Right.Left
    typealias Right = T.Right
}

enum ActualAcquisitionAnswer<T: ObservationTrace, R: PredicateReading>: VerdictIsInvariant
where T.Left == R.Left, T.Left: Structure {
    typealias Step = PreparedTraceExtension<T, R>
    typealias F = LastAnswerFromTrace<Step.Trace>
    typealias Left = R
    typealias Right = AnswerInReadyWhole<Step.Right, F>
    typealias Sigma = R.Sigma
    typealias Encoding = R.Encoding
    typealias Predicate = R.Predicate
    typealias Answer = R.Answer
}

typealias ZeroInternalSpectrum<B: BeamShape & Structure> = AnswerInReadyWhole<
    AcquireZeroBlockedBeta<B>.Right, ZeroBlockedPreparedSpectrum<B>
>
where B.AlphaLevel == Never, B.PaschenLevel == Lit1

typealias OneInternalSpectrum<B: BeamShape & Structure> = AnswerInReadyWhole<
    AcquireOneBlockedBeta<B>.Right, OneBlockedPreparedSpectrum<B>
>
where B.AlphaLevel == Lit1, B.PaschenLevel == Never

// All eight sources get the complete image: four use their old class, four
// use one prepared beta reading. The final image equality is never a premise.
typealias ObserverResult000 = ReadySpectrumFromOldTrace<Observer000>
typealias ObserverResult001 = ZeroInternalSpectrum<Observer001>
typealias ObserverResult010 = ReadySpectrumFromOldTrace<Observer010>
typealias ObserverResult011 = ZeroInternalSpectrum<Observer011>
typealias ObserverResult100 = OneInternalSpectrum<Observer100>
typealias ObserverResult101 = ReadySpectrumFromOldTrace<Observer101>
typealias ObserverResult110 = OneInternalSpectrum<Observer110>
typealias ObserverResult111 = ReadySpectrumFromOldTrace<Observer111>

enum ReadyAddsNoReading<B: BeamShape & Structure>: Null
where B.AlphaLevel == B.PaschenLevel {
    typealias Left = KeepReadyKnowledge<B>.Answer
    typealias Right = ReadyObserverWhole<B>
}

// The whole distinguishes these sources before measurement, while the entire
// accessible instrument state (channel, phase and old memory) is identical.
enum InternalObserverInitiallyCannotDistinguish: Null {
    typealias Left = AcquireZeroBlockedBeta<Observer001>.Left.Right
    typealias Right = AcquireZeroBlockedBeta<Observer011>.Left.Right
}

enum AcquiredDistinctionIsResidentBeta: Null {
    typealias L = AcquireZeroBlockedBeta<Observer001>
    typealias R = AcquireZeroBlockedBeta<Observer011>
    typealias Left = Paired<L.Trace.Reading.Answer, R.Trace.Reading.Answer>
    typealias Right = Paired<ZeroSuccessorDistinction<Never>.Left, ZeroSuccessorDistinction<Never>.Right>
}

enum RewindRestoresObserverAmbiguity: Null {
    typealias Left = RewindPreparedTrace<ZeroBlockedTrace<Observer001>, SpectrumBetaSource<Observer001>>.Right.Right
    typealias Right = RewindPreparedTrace<ZeroBlockedTrace<Observer011>, SpectrumBetaSource<Observer011>>.Right.Right
}

// The actual new trace still answers its old class question through prefix
// projection. The new measurement need not replace old evidence.
typealias OldClassAfterBeta<B: BeamShape & Structure> = RetainTraceAnswer<
    AcquireZeroBlockedBeta<B>.Trace,
    LastAnswerFromTrace<ZeroBlockedTrace<B>>
>
where B.AlphaLevel == Never, B.PaschenLevel == Lit1

enum OldClassStillReadable<B: BeamShape & Structure>: Null
where B.AlphaLevel == Never, B.PaschenLevel == Lit1 {
    typealias Left = AnswerInReadyWhole<AcquireZeroBlockedBeta<B>.Right, OldClassAfterBeta<B>>.Answer
    typealias Right = BlockedAlpha<Never>
}

// The newly acquired memory supplies every certified future from the full
// image, using the general previous-cycle rule. Here S then T is available
// at source 011 even though T was unavailable before S.
typealias NewInternalPath<B: BeamShape> = JoinedTransition<
    SpectrumFirstTransition<B>, MatchedSwapTransition<SwapVisible<B>>
>
where B.BetaLevel == B.PaschenLevel

typealias NewFutureFromInternalMemory<B: BeamShape & Structure> = FutureOnEvidence<
    NewInternalPath<B>,
    SpectrumAlphaFactors<SwapVisible<SwapVisible<B>>>,
    ZeroBlockedPreparedSpectrum<B>
>
where B.AlphaLevel == Never, B.BetaLevel == Lit1, B.PaschenLevel == Lit1

enum AcquiredMemoryAnswersMixedPath<B: BeamShape & Structure>: Null
where B.AlphaLevel == Never, B.BetaLevel == Lit1, B.PaschenLevel == Lit1 {
    typealias Left = AnswerInReadyWhole<AcquireZeroBlockedBeta<B>.Right, NewFutureFromInternalMemory<B>>.Answer
    typealias Right = B.AlphaLevel
}

// The address contains only retained facts. No original source is supplied
// as the input of the reconstructed-image decoder.
enum SpectrumDecoderUsesInternalMemory<B: BeamShape & Structure>: Null
where B.AlphaLevel == Never, B.PaschenLevel == Lit1 {
    typealias Left = ZeroInternalSpectrum<B>.Left
    typealias Right = AcquireZeroBlockedBeta<B>.Right.Right.Right.Right
}

typealias ObserverStepAt<W, P: Pair> = P where P.Left == W
typealias Step001 = AcquireZeroBlockedBeta<Observer001>
typealias Step011 = AcquireZeroBlockedBeta<Observer011>
typealias Rewind001 = RewindPreparedTrace<ZeroBlockedTrace<Observer001>, SpectrumBetaSource<Observer001>>
typealias ReadyInverse001 = ObserverStepAt<Step001.Right, Rewind001>

// If the whole additionally retains occurrences, a return of its current
// configuration does not remove the earlier readout from that archive.
typealias ObserverFirstHistory = RetainedWhole<Step001.Left, Step001.Right>
typealias ObserverRewoundHistory = RetainedWhole<ObserverFirstHistory.Right, Rewind001.Right>
typealias ArchivedWholeAfterRead = ObserverRewoundHistory.Right.Left.Right
typealias ArchivedBetaAfterRewind = AnswerInReadyWhole<ArchivedWholeAfterRead, LastAnswerFromTrace<Step001.Trace>>

enum CurrentWholeReturnsInsideLargerHistory: Null {
    typealias Left = ObserverRewoundHistory.Right.Right
    typealias Right = Step001.Left
}

enum HistoricalReadoutSurvives<T: ObservationTrace, R: PredicateReading>: Null
where T.Left == R.Left, T.Left: Structure {
    typealias Step = PreparedTraceExtension<T, R>
    typealias First = RetainedWhole<Step.Left, Step.Right>
    typealias AfterRewind = RetainedWhole<First.Right, RewindPreparedTrace<T, R>.Right>
    typealias Archived = AfterRewind.Right.Left.Right
    typealias Left = AnswerInReadyWhole<Archived, LastAnswerFromTrace<Step.Trace>>.Answer
    typealias Right = R.Answer
}

// A two-state closed constant map witnesses why closure is weaker than
// recovery. This fixture is a mathematical countermodel, not a physical law.
enum ClosedReset<S: Structure>: Pair {
    typealias Left = S
    typealias Right = Never
}

enum ClosedResetMergesInputs: Null {
    typealias Left = ClosedReset<Never>.Right
    typealias Right = ClosedReset<Lit1>.Right
}

#if OBSERVER_OTHER_SOURCE_SAME_VALUE
typealias RejectedObserverOtherSource = PreparedTraceExtension<ZeroBlockedTrace<Observer001>, SpectrumBetaSource<ObserverTwin001>>
#endif

#if OBSERVER_BEFORE_IS_READY
typealias RejectedObserverPrematureRead = AnswerInReadyWhole<Step001.Left, LastAnswerFromTrace<Step001.Trace>>
#endif

#if OBSERVER_OTHER_WHOLE_SOURCE
typealias RejectedObserverWholeSource = AnswerInReadyWhole<Step001.Right, ZeroBlockedPreparedSpectrum<ObserverTwin001>>
#endif

#if OBSERVER_OTHER_MEMORY
typealias WrongObserverWholeMemory = Paired<Observer001, Step011.Right.Right>
typealias RejectedObserverOtherMemory = AnswerInReadyWhole<WrongObserverWholeMemory, ZeroBlockedPreparedSpectrum<Observer001>>
#endif

#if OBSERVER_OTHER_CHANNEL
typealias WrongObserverChannel = Paired<Observer001, Paired<ChannelOf<SpectrumAlphaSource<Observer001>>, Step001.Left.Right.Right>>
typealias RejectedObserverChannel = ObserverStepAt<WrongObserverChannel, Step001>
#endif

#if OBSERVER_REUSES_CONSUMED_SLOT
typealias RejectedObserverConsumedSlot = ObserverStepAt<Step001.Right, PreparedTraceExtension<Step001.Trace, SpectrumBetaSource<Observer001>>>
#endif

#if OBSERVER_UNPREPARED_OCCUPIED_SLOT
typealias OccupiedObserver = Paired<Observer001, Paired<Step001.Channel, Paired<ExperimentQuiet, Paired<ZeroBlockedTrace<Observer001>.Right, FactOf<SpectrumBetaSource<Observer001>>>>>>
typealias RejectedObserverOccupiedSlot = ObserverStepAt<OccupiedObserver, Step001>
#endif

#if OBSERVER_BLANK_IS_RECORDED_ZERO
enum RejectedObserverBlankAsZero: Null {
    typealias Left = Step001.Left.Right.Right.Right.Right
    typealias Right = FactOf<SpectrumBetaSource<Observer001>>
}
#endif

#if OBSERVER_SWAPPED_RECORD_ORDER
typealias RejectedObserverRecordOrder = ZeroBlockedMemorySpectrum<Paired<FactOf<SpectrumBetaSource<Observer001>>, ZeroBlockedTrace<Observer001>.Right>>
#endif

#if OBSERVER_WRONG_RECORDED_QUESTION
typealias WrongObserverMemory = Paired<ZeroBlockedTrace<Observer001>.Right, FactOf<SpectrumAlphaSource<Observer001>>>
typealias RejectedObserverQuestion = ZeroBlockedMemorySpectrum<WrongObserverMemory>
#endif

#if OBSERVER_NEW_ANSWER_FROM_OLD_CLASS
typealias RejectedObserverOldClass = FutureOnEvidence<
    SpectrumFirstTransition<Observer001>,
    SpectrumAlphaFactors<SwapVisible<Observer001>>,
    LastAnswerFromTrace<ZeroBlockedTrace<Observer001>>
>
#endif

#if OBSERVER_WIDENS_BINARY_HIDDEN_SCOPE
typealias RejectedObserverHiddenScope = ZeroBlockedPreparedSpectrum<ObserverBeam<Never, Never, Lit2>>
#endif

#if OBSERVER_READY_CLASS_IS_BLOCKED
typealias RejectedObserverReadyAsBlocked = AcquireZeroBlockedBeta<Observer000>
#endif

#if OBSERVER_OBSERVATION_EXECUTES_SWAP
enum RejectedObserverSceneSwap: Null {
    typealias Left = Step011.Right.Left
    typealias Right = SwapVisible<Observer011>
}
#endif

#if OBSERVER_FUTURE_AVAILABLE_AT_OTHER_SOURCE
typealias RejectedObserverUnavailableFuture = NewInternalPath<Observer001>
#endif

#if OBSERVER_REWIND_PRESERVES_READY_ANSWER
typealias RejectedObserverReadyAfterRewind = AnswerInReadyWhole<Rewind001.Right, LastAnswerFromTrace<Step001.Trace>>
#endif

#if OBSERVER_LATER_RECORD_IS_EARLIER_WHOLE
enum RejectedObserverClockIdentity: Null {
    typealias Left = Step001.Right
    typealias Right = Step001.Left
}
#endif

#if OBSERVER_CLOSURE_PROVES_RECOVERY
enum RejectedClosedResetRecovery<S: Structure>: Null {
    typealias Left = ClosedReset<S>.Right
    typealias Right = S
}
#endif

#if OBSERVER_RECURRENCE_IDENTIFIES_HISTORY
enum RejectedObserverHistoryCollapse: Null {
    typealias Left = ObserverRewoundHistory.Right
    typealias Right = ObserverFirstHistory.Right
}
#endif
