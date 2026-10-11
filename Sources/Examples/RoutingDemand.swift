import VerificationIsIdentification

/// Read two specified components of one paired source. This structural pair
/// makes no assertion of probabilistic independence between its components.
public typealias PairedSourceReadings<A: PredicateReading, B: PredicateReading> = JointEvidence<
    DecodeRefinedEvidence<FirstEvidenceImage<Paired<A.Left, B.Left>, A.Sigma, A.Encoding, A.Predicate>, A>,
    DecodeRefinedEvidence<SecondEvidenceImage<Paired<A.Left, B.Left>, B.Sigma, B.Encoding, B.Predicate>, B>
>
where A.Left: Structure, B.Left: Structure, A.Answer: Structure, B.Answer: Structure,
      A.Sigma == B.Sigma, A.Encoding == B.Encoding

public enum FirstDataCoordinateQuestion: Close {}

/// Only this address is read. The other input coordinates are not arguments
/// of the subsequent decoder and need not share a chosen value type.
public enum FirstDataCoordinate<X: Pair>: PredicateReading
where X.Left: Pair {
    public typealias Left = X
    public typealias Right = X.Left.Left
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = FirstDataCoordinateQuestion
    public typealias Answer = Right
}

public typealias RepeatedFirstRouting = BoundaryWorking<RoutingAddress00, RoutingAddress00, RoutingAddress00, RoutingAddress00>

/// The law fact supplies the four repeated 00 signatures. This decoder
/// accepts that acquired fact and one coordinate value, with no complete X.
public enum RepeatFromFirstRecord<M: Pair>: PredicateReading
where M.Left == FactOf<RoutingProbeImages<RepeatedFirstRouting>>, M.Right: Structure {
    public typealias Left = M
    public typealias Right = BoundaryWorking<M.Right, M.Right, M.Right, M.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutedOutputQuestion
    public typealias Answer = Right
}

/// The existing full-source application factors through the old law record
/// and the one newly read input coordinate. Output equality is derived for
/// arbitrary remaining input structure, not required as a caller premise.
public enum RepeatedFirstFromObservation<X: Pair>: ReadingFactors
where X.Left: Pair, X.Left.Left: Structure {
    public typealias Left = RoutingApplication<RepeatedFirstRouting, X, Route00<X>, Route00<X>, Route00<X>, Route00<X>>
    public typealias Observation = PairedSourceReadings<
        AcquireAnswer<RoutingProbeImages<RepeatedFirstRouting>>.Observation,
        FirstDataCoordinate<X>
    >
    public typealias Right = RepeatFromFirstRecord<Observation.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutedOutputQuestion
    public typealias Answer = Left.Answer
}
