import VerificationIsIdentification

/// The third coordinate is an available declared channel, not a value inferred
/// from failure of the old memory. These coordinates have symbolic semantics.
public enum HiddenCoordinateQuestion: Close {}

public enum HiddenCoordinateReading<B: BeamShape>: PredicateReading {
    public typealias Left = B
    public typealias Right = B.PaschenLevel
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = HiddenCoordinateQuestion
    public typealias Answer = Right
}

/// Readdress three resident instruments without copying the source. The
/// previously focused and parked instruments remain together in the bank.
public enum FocusThirdInstrument<W: Pair>: Pair
where W.Left: Pair, W.Left.Left: Pair,
      W.Left.Left.Left: Structure, W.Left.Left.Right: Structure,
      W.Left.Right: Structure, W.Right: Structure {
    public typealias Left = W
    public typealias Right = Paired<
        Paired<W.Left.Left.Left, W.Right>,
        Paired<W.Left.Left.Right, W.Left.Right>
    >
}

/// Three prepared slots and their channels are inside the initial whole.
/// First finishes two readings while the third instrument stays quiet.
/// Third acquires one additional fact and preserves both earlier instruments.
public enum ThreeResidentReadings<
    A: PredicateReading,
    B: PredicateReading,
    C: PredicateReading
>: Pair
where A.Left == B.Left, A.Left == C.Left, A.Left: Structure {
    public typealias Earlier = TwoResidentReadings<A, B>
    public typealias Last = PreparedTraceExtension<StartObservations<C.Left>, C>
    public typealias First = StepBeside<Earlier, Last.Left.Right>
    public typealias Focus = FocusThirdInstrument<First.Right>
    public typealias Third = StepBeside<Last, Paired<Earlier.Right.Left.Right, Earlier.Right.Right>>
    public typealias Path = FollowedPair<FollowedPair<First, Focus>, Third>
    public typealias Left = Path.Left
    public typealias Right = Path.Right
}

/// Read the three final fact addresses in original acquisition order.
public typealias ResidentThreeFacts<W: Pair> = Paired<
    W.Right.Right.Right.Right.Right,
    Paired<W.Right.Left.Right.Right.Right, W.Left.Right.Right.Right.Right>
>
where W.Left: Pair, W.Left.Right: Pair, W.Left.Right.Right: Pair,
      W.Left.Right.Right.Left == ExperimentSignal,
      W.Left.Right.Right.Right: Pair,
      W.Left.Right.Right.Right.Right: HasVerdict & Structure,
      W.Right: Pair, W.Right.Left: Pair, W.Right.Left.Right: Pair,
      W.Right.Left.Right.Left == ExperimentSignal,
      W.Right.Left.Right.Right: Pair,
      W.Right.Left.Right.Right.Right: HasVerdict & Structure,
      W.Right.Right: Pair, W.Right.Right.Right: Pair,
      W.Right.Right.Right.Left == ExperimentSignal,
      W.Right.Right.Right.Right: Pair,
      W.Right.Right.Right.Right.Right: HasVerdict & Structure

public typealias KnowledgeAcquisition<B: BeamShape & Structure> = ThreeResidentReadings<
    SpectrumAlphaSource<B>, SpectrumBetaSource<B>, HiddenCoordinateReading<B>
>

public typealias KnowledgeOldObservation<B: BeamShape & Structure> = ObserveTwoResidentFacts<
    SpectrumAlphaSource<B>, SpectrumBetaSource<B>
>

/// The observation is tied to the output of the complete prepared schedule.
public enum KnowledgeObservation<B: BeamShape & Structure>: PredicateReading {
    public typealias Left = B
    public typealias Right = ResidentThreeFacts<KnowledgeAcquisition<B>.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RecordReadingOperation
    public typealias Answer = Right
}

/// The input consists only of recorded facts. No source type parameter or
/// new source reading is passed to this reconstruction.
public enum KnowledgeCoordinates<M: Pair>: PredicateReading
where M.Left: HasVerdict, M.Right: Pair,
      M.Right.Left: HasVerdict, M.Right.Right: HasVerdict,
      M.Left.Answer: Structure, M.Right.Left.Answer: Structure,
      M.Right.Right.Answer: Structure {
    public typealias Left = M
    public typealias Right = Paired<M.Left.Answer, Paired<M.Right.Left.Answer, M.Right.Right.Answer>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = FullSpectrumQuestion
    public typealias Answer = Right
}

/// Source-answer equality follows from the three actual reading laws.
/// The fact decoder alone would not authenticate arbitrary fact-shaped data.
public enum KnowledgeFromThree<B: BeamShape & Structure>: ReadingFactors {
    public typealias Left = FullSpectrumReading<B>
    public typealias Observation = KnowledgeObservation<B>
    public typealias Right = KnowledgeCoordinates<Observation.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = FullSpectrumQuestion
    public typealias Answer = Left.Answer
}

/// The earlier two facts are still at readable addresses after acquisition.
public enum KnowledgeOldFacts<M: Pair>: PredicateReading
where M.Left: Structure, M.Right: Pair, M.Right.Left: Structure {
    public typealias Left = M
    public typealias Right = Paired<M.Left, M.Right.Left>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RecordReadingOperation
    public typealias Answer = Right
}

public enum KnowledgeRetainsOld<B: BeamShape & Structure>: ReadingFactors {
    public typealias Left = KnowledgeOldObservation<B>
    public typealias Observation = KnowledgeObservation<B>
    public typealias Right = KnowledgeOldFacts<Observation.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RecordReadingOperation
    public typealias Answer = Left.Answer
}

/// The current question uses the first fact, although two facts are available.
public enum KnowledgeCurrent<B: BeamShape & Structure>: ReadingFactors {
    public typealias Left = SpectrumAlphaSource<B>
    public typealias Observation = KnowledgeOldObservation<B>
    public typealias Right = DecodeRefinedEvidence<
        FirstEvidenceImage<Observation.Answer, BeamSpace, SaturationEncoding, AlphaQuestion>,
        ReadRecordedAnswer<Observation.Answer.Left>
    >
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AlphaQuestion
    public typealias Answer = Left.Answer
}

public enum KnowledgeSwapDecoder<M: Pair>: PredicateReading
where M.Right: HasVerdict {
    public typealias Left = M
    public typealias Right = M.Right.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = OperationSequence<SwapOperation, AlphaQuestion>
    public typealias Answer = Right
}

/// The direct question applies the exchange and then reads alpha. The old
/// second record supplies its answer without another acquisition.
public enum KnowledgeSwapFromTwo<B: BeamShape & Structure>: ReadingFactors {
    public typealias Left = SequentialReading<SpectrumSwapSource<B>, SpectrumAlphaSource<SwapVisible<B>>>
    public typealias Observation = KnowledgeOldObservation<B>
    public typealias Right = KnowledgeSwapDecoder<Observation.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Left.Predicate
    public typealias Answer = Left.Answer
}

/// Exchange beta with the hidden coordinate, then alpha with beta.
public typealias KnowledgeMixedPath<B: BeamShape> = JoinedTransition<
    SpectrumSecondTransition<B>, SpectrumFirstTransition<SwapBetaHidden<B>>
>

public typealias KnowledgeMixedQuestion<B: BeamShape> = SequentialReading<
    KnowledgeMixedPath<B>.SourceStep,
    SpectrumAlphaSource<SwapVisible<SwapBetaHidden<B>>>
>

public typealias KnowledgeMixedFromThree<B: BeamShape & Structure> = FutureOnEvidence<
    KnowledgeMixedPath<B>,
    SpectrumAlphaFactors<SwapVisible<SwapBetaHidden<B>>>,
    KnowledgeFromThree<B>
>

/// Put the resident source beside its resident command tape. Keep every
/// instrument field in the bank. This step only changes their addresses.
public enum FocusKnowledgeCommand<W: Pair, Tape: Structure>: Pair
where W.Left: Pair, W.Left.Left: Structure,
      W.Left.Right: Structure, W.Right: Structure {
    public typealias Left = Paired<W, Paired<Tape, Never>>
    public typealias Right = Paired<
        Paired<W.Left.Left, Paired<Tape, Never>>,
        Paired<W.Left.Right, W.Right>
    >
}

/// The fixed word is inside the initial whole. Both consumed commands move
/// into its past. Old instruments stay beside the changing source.
public enum KnowledgeResidentRun<B: BeamShape & Structure>: Pair {
    public typealias Tape = Paired<SwapBetaHiddenOperation, Paired<SwapOperation, Never>>
    public typealias Acquisition = StepBeside<KnowledgeAcquisition<B>, Paired<Tape, Never>>
    public typealias Focus = FocusKnowledgeCommand<KnowledgeAcquisition<B>.Right, Tape>
    public typealias First = ResidentBoundaryCommand<HiddenSwapSource<B>, Tape, Never>
    public typealias Second = ResidentBoundaryCommand<
        SpectrumSwapSource<SwapBetaHidden<B>>, Tape.Right, Paired<Tape.Left, Never>
    >
    public typealias Execution = StepBeside<FollowedPair<First, Second>, Focus.Right.Right>
    public typealias Path = FollowedPair<FollowedPair<Acquisition, Focus>, Execution>
    public typealias Left = Path.Left
    public typealias Right = Path.Right
}
