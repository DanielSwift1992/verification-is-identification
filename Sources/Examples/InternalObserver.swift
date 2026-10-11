import VerificationIsIdentification

/// This channel reads the resident second coordinate. Its implementation and
/// availability are declared here, not inferred from an arbitrary question.
public enum BetaQuestion: Close {}

public enum SpectrumBetaSource<B: BeamShape>: PredicateReading {
    public typealias Left = B
    public typealias Right = B.BetaLevel
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = BetaQuestion
    public typealias Answer = Right
}

/// The instrument's address contains context and question, never the source
/// or its answer. The declared reading family supplies the channel law.
public typealias ChannelOf<R: PredicateReading> = AddressedRepresentation<
    R.Sigma,
    AddressedRepresentation<R.Encoding, R.Predicate>
>

/// One prepared slot inside the whole receives a reading of that whole's
/// actual source. Old memory, the source and the channel address are retained.
/// This is a partial prepared relation, not a total reset of arbitrary memory.
/// Its trace is the existing source-bound AppendObservation. [VI VC55]
public enum PreparedTraceExtension<
    T: ObservationTrace,
    R: PredicateReading
>: Pair
where T.Left == R.Left, T.Left: Structure {
    public typealias Trace = AppendObservation<T, R>
    public typealias Channel = ChannelOf<R>
    public typealias Left = Paired<T.Left, Paired<Channel, Paired<ExperimentQuiet, Paired<T.Right, Never>>>>
    public typealias Right = Paired<T.Left, Paired<Channel, Paired<ExperimentSignal, Trace.Right>>>
}

/// The inverse relation names the same prepared pair with its ends reversed.
/// It applies to this constructed output, not to every signal-tagged record.
public typealias RewindPreparedTrace<
    T: ObservationTrace,
    R: PredicateReading
> = InternalSwap<PreparedTraceExtension<T, R>>
where T.Left == R.Left, T.Left: Structure

/// Recover the prepared whole from its output fields alone. Correctness is
/// asserted on the constructed acquisition range. A signal-tagged arbitrary
/// record is not thereby certified as a true earlier acquisition.
public enum PreparedPredecessor<W: Pair>: Pair
where W.Left: Structure, W.Right: Pair, W.Right.Left: Structure,
      W.Right.Right: Pair, W.Right.Right.Left == ExperimentSignal,
      W.Right.Right.Right: Pair, W.Right.Right.Right.Left: Structure {
    public typealias Left = W.Left
    public typealias Right = Paired<W.Right.Left, Paired<ExperimentQuiet, Paired<W.Right.Right.Right.Left, Never>>>
}

/// Name the existing decoder at a ready whole whose source, context and
/// accessible memory match its factorization. The decoder input is memory,
/// not the whole or its source. A ready marker alone supplies no factorization.
public typealias AnswerInReadyWhole<
    W: Pair,
    F: ReadingFactors
> = F.Right
where W.Left == F.Left.Left,
      W.Right: Pair, W.Right.Left: Pair, W.Right.Left.Right: Pair,
      W.Right.Left.Left == F.Sigma, W.Right.Left.Right.Left == F.Encoding,
      W.Right.Right: Pair, W.Right.Right.Left == ExperimentSignal,
      W.Right.Right.Right == F.Observation.Answer

public typealias ReadyClassTrace<B: BeamShape> = AppendObservation<
    StartObservations<B>, ReadyClassReading<B>
>
where B.AlphaLevel == B.PaschenLevel

public typealias ZeroBlockedTrace<B: BeamShape> = AppendObservation<
    StartObservations<B>, ZeroBlockedClassReading<B, Never>
>
where B.AlphaLevel == Never, B.PaschenLevel == Lit1

public typealias OneBlockedTrace<B: BeamShape> = AppendObservation<
    StartObservations<B>, SuccessorBlockedClassReading<B, Never>
>
where B.AlphaLevel == Lit1, B.PaschenLevel == Never

public typealias AcquireZeroBlockedBeta<B: BeamShape & Structure> = PreparedTraceExtension<
    ZeroBlockedTrace<B>, SpectrumBetaSource<B>
>
where B.AlphaLevel == Never, B.PaschenLevel == Lit1

public typealias AcquireOneBlockedBeta<B: BeamShape & Structure> = PreparedTraceExtension<
    OneBlockedTrace<B>, SpectrumBetaSource<B>
>
where B.AlphaLevel == Lit1, B.PaschenLevel == Never

/// The ready class needs no added reading. Quiet marks the unused new slot,
/// not an inability to read the already acquired prefix. [VI VC56]
public typealias ReadyObserverWhole<B: BeamShape & Structure> = PreparedTraceExtension<
    ReadyClassTrace<B>, SpectrumBetaSource<B>
>.Left
where B.AlphaLevel == B.PaschenLevel

public typealias KeepReadyKnowledge<B: BeamShape & Structure> = IdentityReading<
    ReadyObserverWhole<B>, BeamSpace, SaturationEncoding
>
where B.AlphaLevel == B.PaschenLevel

/// A ready class already determines the complete image. [VI VC56]
public enum ReadyClassSpectrum<A: IntegerValued, B: IntegerValued>: PredicateReading {
    public typealias Left = ReadyAlpha<A, B>
    public typealias Right = Paired<A, Paired<B, A>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = FullSpectrumQuestion
    public typealias Answer = Right
}

public enum ReadyClassRecoversSpectrum<B: BeamShape>: ReadingFactors
where B.AlphaLevel == B.PaschenLevel {
    public typealias Left = FullSpectrumReading<B>
    public typealias Observation = ReadyClassReading<B>
    public typealias Right = ReadyClassSpectrum<B.AlphaLevel, B.BetaLevel>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = FullSpectrumQuestion
    public typealias Answer = FullSpectrumImage<B>
}

public typealias ReadySpectrumFromOldTrace<B: BeamShape> = AnswerOnRefinement<
    ReadyClassRecoversSpectrum<B>, LastAnswerFromTrace<ReadyClassTrace<B>>
>
where B.AlphaLevel == B.PaschenLevel

/// Read the old class fact and the newly measured beta fact at their retained
/// addresses. The old zero-blocked class fixes c=1 only on the binary carrier.
public enum ZeroBlockedMemorySpectrum<M: Pair>: PredicateReading
where M.Left: Pair,
      M.Left.Right == AnswerFact<BeamSpace, SaturationEncoding, InteractionClassQuestion, BlockedAlpha<Never>>,
      M.Right: HasVerdict, M.Right.Sigma == BeamSpace,
      M.Right.Encoding == SaturationEncoding, M.Right.Predicate == BetaQuestion,
      M.Right.Answer: IntegerValued {
    public typealias Left = M
    public typealias Right = Paired<Never, Paired<M.Right.Answer, Lit1>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = FullSpectrumQuestion
    public typealias Answer = Right
}

public enum OneBlockedMemorySpectrum<M: Pair>: PredicateReading
where M.Left: Pair,
      M.Left.Right == AnswerFact<BeamSpace, SaturationEncoding, InteractionClassQuestion, BlockedAlpha<Lit1>>,
      M.Right: HasVerdict, M.Right.Sigma == BeamSpace,
      M.Right.Encoding == SaturationEncoding, M.Right.Predicate == BetaQuestion,
      M.Right.Answer: IntegerValued {
    public typealias Left = M
    public typealias Right = Paired<Lit1, Paired<M.Right.Answer, Never>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = FullSpectrumQuestion
    public typealias Answer = Right
}

/// Recovery follows from the actual old and new readings of this source.
/// A newly supplied equality with the complete image is not a premise.
public enum ZeroBlockedPreparedSpectrum<B: BeamShape & Structure>: ReadingFactors
where B.AlphaLevel == Never, B.PaschenLevel == Lit1 {
    public typealias Step = AcquireZeroBlockedBeta<B>
    public typealias Left = FullSpectrumReading<B>
    public typealias Observation = TraceEvidence<Step.Trace>
    public typealias Right = ZeroBlockedMemorySpectrum<Step.Trace.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = FullSpectrumQuestion
    public typealias Answer = FullSpectrumImage<B>
}

public enum OneBlockedPreparedSpectrum<B: BeamShape & Structure>: ReadingFactors
where B.AlphaLevel == Lit1, B.PaschenLevel == Never {
    public typealias Step = AcquireOneBlockedBeta<B>
    public typealias Left = FullSpectrumReading<B>
    public typealias Observation = TraceEvidence<Step.Trace>
    public typealias Right = OneBlockedMemorySpectrum<Step.Trace.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = FullSpectrumQuestion
    public typealias Answer = FullSpectrumImage<B>
}
