import VerificationIsIdentification

public enum SuppliedInputQuestion: Close {}
public enum RoutedValueQuestion: Close {}
public enum RoutedOutputQuestion: Close {}

/// Lift a reading to the first component of a declared pair. The second
/// component is explicitly read and returned beside its answer.
public typealias ReadingBesideInput<R: PredicateReading, X: Structure> = JointEvidence<
    DecodeRefinedEvidence<FirstEvidenceImage<Paired<R.Left, X>, R.Sigma, R.Encoding, R.Predicate>, R>,
    SecondEvidenceImage<Paired<R.Left, X>, R.Sigma, R.Encoding, SuppliedInputQuestion>
>
where R.Left: Structure, R.Answer: Structure

/// Product transport of a factorization. Both the source and decoder input
/// contain X. It is neither guessed nor supplied only as a hidden parameter.
public enum EvidenceBesideInput<F: ReadingFactors, X: Structure>: ReadingFactors
where F.Left.Left: Structure, F.Observation.Answer: Structure, F.Answer: Structure {
    public typealias Left = ReadingBesideInput<F.Left, X>
    public typealias Observation = ReadingBesideInput<F.Observation, X>
    public typealias Right = ReadingBesideInput<F.Right, X>
    public typealias Sigma = F.Sigma
    public typealias Encoding = F.Encoding
    public typealias Predicate = Left.Predicate
    public typealias Answer = Left.Answer
}

/// These four clauses implement a signature-indexed coordinate read. Each
/// input includes the entire supplied data image, in its declared layout.
public enum Route00<X: Pair>: PredicateReading
where X.Left: Pair {
    public typealias Left = Paired<RoutingAddress00, X>
    public typealias Right = X.Left.Left
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutedValueQuestion
    public typealias Answer = Right
}
public enum Route01<X: Pair>: PredicateReading
where X.Left: Pair {
    public typealias Left = Paired<RoutingAddress01, X>
    public typealias Right = X.Left.Right
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutedValueQuestion
    public typealias Answer = Right
}
public enum Route10<X: Pair>: PredicateReading
where X.Right: Pair {
    public typealias Left = Paired<RoutingAddress10, X>
    public typealias Right = X.Right.Left
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutedValueQuestion
    public typealias Answer = Right
}
public enum Route11<X: Pair>: PredicateReading
where X.Right: Pair {
    public typealias Left = Paired<RoutingAddress11, X>
    public typealias Right = X.Right.Right
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutedValueQuestion
    public typealias Answer = Right
}

/// Apply a supplied routing to supplied input data. The admitted VC75
/// grammar chooses each clause from Route00/01/10/11. An arbitrary reading
/// with the same question label does not establish coordinate selection.
public enum RoutingApplication<I: Pair, X: Structure,
                               A: PredicateReading, C: PredicateReading,
                               B: PredicateReading, D: PredicateReading>: PredicateReading
where I.Left: Pair, I.Right: Pair,
      I.Left.Left: Pair, I.Left.Right: Pair, I.Right.Left: Pair, I.Right.Right: Pair,
      I.Left.Left.Left: Structure, I.Left.Left.Right: Structure,
      I.Left.Right.Left: Structure, I.Left.Right.Right: Structure,
      I.Right.Left.Left: Structure, I.Right.Left.Right: Structure,
      I.Right.Right.Left: Structure, I.Right.Right.Right: Structure,
      A.Left == Paired<Paired<I.Left.Left.Left, I.Left.Left.Right>, X>,
      C.Left == Paired<Paired<I.Left.Right.Left, I.Left.Right.Right>, X>,
      B.Left == Paired<Paired<I.Right.Left.Left, I.Right.Left.Right>, X>,
      D.Left == Paired<Paired<I.Right.Right.Left, I.Right.Right.Right>, X>,
      A.Sigma == BeamSpace, C.Sigma == A.Sigma, B.Sigma == A.Sigma, D.Sigma == A.Sigma,
      A.Encoding == SaturationEncoding, C.Encoding == A.Encoding, B.Encoding == A.Encoding, D.Encoding == A.Encoding,
      A.Predicate == RoutedValueQuestion, C.Predicate == A.Predicate, B.Predicate == A.Predicate, D.Predicate == A.Predicate,
      A.Answer: Structure, C.Answer: Structure, B.Answer: Structure, D.Answer: Structure {
    public typealias Left = Paired<I, X>
    public typealias Right = BoundaryWorking<A.Answer, C.Answer, B.Answer, D.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutedOutputQuestion
    public typealias Answer = Right
}

/// Direct application uses the actual I. Decoding uses only the two probe
/// images and the supplied X. Their output equality follows by reconstruction
/// of the four signatures, without a final-answer equality premise.
/// A/C/B/D are supplied reading clauses on both paths. This transport does
/// not establish their coordinate-selection semantics. VC75 restricts them
/// to Route00/01/10/11; Checks/RoutingReuse exhibits a nonmember that also
/// transports, but gives another answer on the same declared input.
public enum RoutingApplicationFromProbes<I: Pair, X: Structure,
                                         A: PredicateReading, C: PredicateReading,
                                         B: PredicateReading, D: PredicateReading>: ReadingFactors
where I.Left: Pair, I.Right: Pair,
      I.Left.Left: Pair, I.Left.Right: Pair, I.Right.Left: Pair, I.Right.Right: Pair,
      I.Left.Left.Left: Structure, I.Left.Left.Right: Structure,
      I.Left.Right.Left: Structure, I.Left.Right.Right: Structure,
      I.Right.Left.Left: Structure, I.Right.Left.Right: Structure,
      I.Right.Right.Left: Structure, I.Right.Right.Right: Structure,
      A.Left == Paired<Paired<I.Left.Left.Left, I.Left.Left.Right>, X>,
      C.Left == Paired<Paired<I.Left.Right.Left, I.Left.Right.Right>, X>,
      B.Left == Paired<Paired<I.Right.Left.Left, I.Right.Left.Right>, X>,
      D.Left == Paired<Paired<I.Right.Right.Left, I.Right.Right.Right>, X>,
      A.Sigma == BeamSpace, C.Sigma == A.Sigma, B.Sigma == A.Sigma, D.Sigma == A.Sigma,
      A.Encoding == SaturationEncoding, C.Encoding == A.Encoding, B.Encoding == A.Encoding, D.Encoding == A.Encoding,
      A.Predicate == RoutedValueQuestion, C.Predicate == A.Predicate, B.Predicate == A.Predicate, D.Predicate == A.Predicate,
      A.Answer: Structure, C.Answer: Structure, B.Answer: Structure, D.Answer: Structure {
    public typealias Left = RoutingApplication<I, X, A, C, B, D>
    public typealias Observation = ReadingBesideInput<RoutingProbeImages<I>, X>
    public typealias Right = DecodeRefinedEvidence<
        ReadingBesideInput<RoutingFromProbes<I>.Right, X>,
        RoutingApplication<RoutingCoordinates<I>.Answer, X, A, C, B, D>
    >
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutedOutputQuestion
    public typealias Answer = Left.Answer
}

/// Acquire the law evidence and expose the new data through its own read.
/// The final decoder's input is (recorded probe images, supplied data).
public typealias RoutingMemoryBesideInput<I: Pair, X: Structure> = EvidenceBesideInput<AcquireAnswer<RoutingProbeImages<I>>, X>
where I.Left: Pair, I.Right: Pair,
      I.Left.Left: Pair, I.Left.Right: Pair, I.Right.Left: Pair, I.Right.Right: Pair,
      I.Left.Left.Left: Structure, I.Left.Left.Right: Structure,
      I.Left.Right.Left: Structure, I.Left.Right.Right: Structure,
      I.Right.Left.Left: Structure, I.Right.Left.Right: Structure,
      I.Right.Right.Left: Structure, I.Right.Right.Right: Structure
