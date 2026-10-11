import VerificationIsIdentification

public enum AcquisitionChoice: Close {}

/// A blocked class selects the same resident channel for every hidden beta.
/// This rule has only the class as input. [VI VC58]
public enum ChooseBlockedBeta<A: IntegerValued>: PredicateReading {
    public typealias Left = BlockedAlpha<A>
    public typealias Right = AddressedRepresentation<BeamSpace, AddressedRepresentation<SaturationEncoding, BetaQuestion>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AcquisitionChoice
    public typealias Answer = Right
}

/// Never here means no acquisition, not a measured zero or an empty reserve.
public enum ChooseReadyReuse<A: IntegerValued, B: IntegerValued>: PredicateReading {
    public typealias Left = ReadyAlpha<A, B>
    public typealias Right = Never
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AcquisitionChoice
    public typealias Answer = Right
}

/// The chosen channel must be obtained from this trace's accessible memory.
/// This alias adds a selection seam to the existing acquisition relation.
/// A channel names context and question. Selecting among different readings
/// of that question additionally requires their resident catalogue address.
public typealias SelectedTraceExtension<
    T: ObservationTrace,
    R: PredicateReading,
    P: PredicateReading
> = PreparedTraceExtension<T, R>
where T.Left == R.Left, T.Left: Structure,
      P.Left == T.Right, P.Answer == ChannelOf<R>,
      P.Sigma == R.Sigma, P.Encoding == R.Encoding,
      P.Predicate == AcquisitionChoice

/// Carry another resident component through a relation unchanged.
public enum StepBeside<P: Pair, C: Structure>: Pair
where P.Left: Structure, P.Right: Structure {
    public typealias Left = Paired<P.Left, C>
    public typealias Right = Paired<P.Right, C>
}

/// Select an actual reading occurrence from a retained finite catalogue.
/// Memory chooses its path address. The selection supplies the reading and
/// therefore its actual preparation/source. The catalogue and policy remain
/// inside both endpoints. Interpretation uses the finite SelectCandidate grammar.
public typealias SelectedResidentTraceExtension<T: ObservationTrace, C: Pair,
    S: CandidateRemoval, P: PredicateReading> = StepBeside<
        PreparedTraceExtension<T, S.Right>, Paired<C, P>>
where T.Left: Structure, S.Left == C, S.Right: PredicateReading,
      S.Right.Left == T.Left, P.Left == T.Right, P.Answer == S.Address,
      P.Sigma == S.Right.Sigma, P.Encoding == S.Right.Encoding,
      P.Predicate == AcquisitionChoice

/// Exchange arbitrary old slot content for one explicitly resident blank.
/// The displaced content is appended to the archive. The reserve tail is
/// unchanged. Paired<Never,Tail> is a slot, distinct from the empty Never.
public enum PrepareTraceFromResidentSlot<
    T: ObservationTrace,
    R: PredicateReading,
    D: Structure,
    A: Structure,
    Tail: Structure
>: Pair
where T.Left == R.Left, T.Left: Structure {
    public typealias Step = PreparedTraceExtension<T, R>
    public typealias Work = Paired<T.Left, Paired<Step.Channel, Paired<ExperimentQuiet, Paired<T.Right, D>>>>
    public typealias Left = Paired<Work, Paired<A, Paired<Never, Tail>>>
    public typealias Right = Paired<Step.Left, Paired<Paired<A, D>, Tail>>
}

/// Move the acquired fact into a resident blank slot. The instrument returns
/// to its prepared state while the archive retains the answer. [VI VC59]
public enum ParkAcquiredTrace<
    T: ObservationTrace,
    R: PredicateReading,
    A: Structure,
    Tail: Structure
>: Pair
where T.Left == R.Left, T.Left: Structure {
    public typealias Step = PreparedTraceExtension<T, R>
    public typealias Left = Paired<Step.Right, Paired<A, Paired<Never, Tail>>>
    public typealias Right = Paired<Step.Left, Paired<Paired<A, FactOf<R>>, Tail>>
}

/// A view of two resident addresses: the instrument's retained prefix and
/// the latest archive slot. Pairing the addresses performs no acquisition.
public typealias ResidentTraceMemory<W: Pair> = Paired<
    W.Left.Right.Right.Right.Left,
    W.Right.Left.Right
>
where W.Left: Pair, W.Left.Right: Pair, W.Left.Right.Right: Pair,
      W.Left.Right.Right.Right: Pair, W.Left.Right.Right.Right.Left: Structure,
      W.Right: Pair, W.Right.Left: Pair, W.Right.Left.Right: Structure

/// The existing decoder reads the resident view after the instrument reset.
/// Its correctness still requires the source-bound factorization. Neither
/// the archive shape nor the instrument phase authenticates a fact.
public typealias AnswerFromResidentArchive<
    W: Pair,
    F: ReadingFactors
> = F.Right
where W.Left: Pair, W.Left.Left == F.Left.Left,
      W.Left.Right: Pair, W.Left.Right.Left: Pair,
      W.Left.Right.Left.Right: Pair,
      W.Left.Right.Left.Left == F.Sigma,
      W.Left.Right.Left.Right.Left == F.Encoding,
      W.Left.Right.Right: Pair, W.Left.Right.Right.Right: Pair,
      W.Left.Right.Right.Right.Left: Structure,
      W.Right: Pair, W.Right.Left: Pair, W.Right.Left.Right: Structure,
      ResidentTraceMemory<W> == F.Observation.Answer
