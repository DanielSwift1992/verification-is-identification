import VerificationIsIdentification

/// The completed trace becomes the next reading's prefix. One resident
/// blank supplies the new slot. Equal channel addresses are required here.
/// The previous signal phase is known on this constructed input range.
public enum AdvancePreparedTrace<
    T: ObservationTrace,
    L: PredicateReading,
    R: PredicateReading
>: Pair
where T.Left: Structure, T.Left == L.Left, T.Left == R.Left,
      L.Sigma == R.Sigma, L.Encoding == R.Encoding,
      L.Predicate == R.Predicate {
    public typealias First = PreparedTraceExtension<T, L>
    public typealias Next = PreparedTraceExtension<First.Trace, R>
    public typealias Left = Paired<First.Right, Never>
    public typealias Right = Next.Left
}

/// Agreement of decoders on the same actual evidence forces agreement of
/// their source readings. Source-answer equality is the conclusion. [VI VC64]
public typealias AgreementFromMemory<
    F: ReadingFactors,
    G: ReadingFactors,
    C: VerdictIsInvariant
> = JoinedVerdict<F.Left, G.Left>
where F.Observation == G.Observation, C.Left == F.Right, C.Right == G.Right

/// A positive memory distinction transfers to the same source readings.
/// The numeral heads are premises on the decoders, not on source answers.
public typealias ZeroSuccessorFromMemory<
    F: ReadingFactors,
    G: ReadingFactors,
    N: IntegerValued
> = ZeroSuccessorBoundary<F.Left, G.Left, N>
where F.Observation == G.Observation, F.Predicate == G.Predicate,
      F.Right.Answer == Never, G.Right.Answer == Succ<N>

public enum CommonBoundaryQuestion: Close {}

/// Classify a certified agreement using only its actual memory input.
/// The successful image is the existing canonical common fact. [VI VC64]
public enum AgreedMemoryBoundary<C: VerdictIsInvariant>: PredicateReading
where C.Left.Left == C.Right.Left {
    public typealias Left = C.Left.Left
    public typealias Right = FactOf<C.Left>
    public typealias Sigma = C.Sigma
    public typealias Encoding = C.Encoding
    public typealias Predicate = CommonBoundaryQuestion
    public typealias Answer = Right
}

/// The failed image omits orientation, while the ordered obstruction and
/// both acquired facts remain available in the supplied memory relation.
public enum ZeroSuccessorMemoryBoundary<
    L: PredicateReading,
    R: PredicateReading,
    N: IntegerValued
>: PredicateReading
where L.Left == R.Left,
      L.Sigma == R.Sigma, L.Encoding == R.Encoding,
      L.Predicate == R.Predicate,
      L.Answer == Never, R.Answer == Succ<N> {
    public typealias Obstruction = ZeroSuccessorBoundary<L, R, N>
    public typealias Left = L.Left
    public typealias Right = ZeroSuccessorBoundaryImage<L, R, N>
    public typealias Sigma = L.Sigma
    public typealias Encoding = L.Encoding
    public typealias Predicate = CommonBoundaryQuestion
    public typealias Answer = Right
}

public enum SuccessorZeroMemoryBoundary<
    L: PredicateReading,
    R: PredicateReading,
    N: IntegerValued
>: PredicateReading
where L.Left == R.Left,
      L.Sigma == R.Sigma, L.Encoding == R.Encoding,
      L.Predicate == R.Predicate,
      L.Answer == Succ<N>, R.Answer == Never {
    public typealias Obstruction = SuccessorZeroBoundary<L, R, N>
    public typealias Left = L.Left
    public typealias Right = SuccessorZeroBoundaryImage<L, R, N>
    public typealias Sigma = L.Sigma
    public typealias Encoding = L.Encoding
    public typealias Predicate = CommonBoundaryQuestion
    public typealias Answer = Right
}
