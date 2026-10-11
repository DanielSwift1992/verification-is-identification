import VerificationIsIdentification

public enum RoutingQuestion: Close {}
public enum FirstRoutingProbeQuestion: Close {}
public enum SecondRoutingProbeQuestion: Close {}

/// Four source-address signatures, in output-address order. Canonicalizing
/// their two coordinates identifies routing behavior, not an actual mechanism.
public enum RoutingCoordinates<I: Pair>: PredicateReading
where I.Left: Pair, I.Right: Pair,
      I.Left.Left: Pair, I.Left.Right: Pair,
      I.Right.Left: Pair, I.Right.Right: Pair,
      I.Left.Left.Left: Structure, I.Left.Left.Right: Structure,
      I.Left.Right.Left: Structure, I.Left.Right.Right: Structure,
      I.Right.Left.Left: Structure, I.Right.Left.Right: Structure,
      I.Right.Right.Left: Structure, I.Right.Right.Right: Structure {
    public typealias Left = I
    public typealias Right = BoundaryWorking<
        Paired<I.Left.Left.Left, I.Left.Left.Right>,
        Paired<I.Left.Right.Left, I.Left.Right.Right>,
        Paired<I.Right.Left.Left, I.Right.Left.Right>,
        Paired<I.Right.Right.Left, I.Right.Right.Right>
    >
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutingQuestion
    public typealias Answer = Right
}

/// A fixed coordinate permutation transports each probe bit along the same
/// wire. This is its first complete output image, with no operation tag.
public enum FirstRoutingProbe<I: Pair>: PredicateReading
where I.Left: Pair, I.Right: Pair,
      I.Left.Left: Pair, I.Left.Right: Pair,
      I.Right.Left: Pair, I.Right.Right: Pair,
      I.Left.Left.Left: Structure, I.Left.Right.Left: Structure,
      I.Right.Left.Left: Structure, I.Right.Right.Left: Structure {
    public typealias Left = I
    public typealias Right = BoundaryWorking<I.Left.Left.Left, I.Left.Right.Left, I.Right.Left.Left, I.Right.Right.Left>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = FirstRoutingProbeQuestion
    public typealias Answer = Right
}

public enum SecondRoutingProbe<I: Pair>: PredicateReading
where I.Left: Pair, I.Right: Pair,
      I.Left.Left: Pair, I.Left.Right: Pair,
      I.Right.Left: Pair, I.Right.Right: Pair,
      I.Left.Left.Right: Structure, I.Left.Right.Right: Structure,
      I.Right.Left.Right: Structure, I.Right.Right.Right: Structure {
    public typealias Left = I
    public typealias Right = BoundaryWorking<I.Left.Left.Right, I.Left.Right.Right, I.Right.Left.Right, I.Right.Right.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = SecondRoutingProbeQuestion
    public typealias Answer = Right
}

/// The two addressed probe images of this same routing. A pair of images
/// from unrelated mechanisms does not constitute this reading.
public typealias RoutingProbeImages<I: Pair> = JointEvidence<FirstRoutingProbe<I>, SecondRoutingProbe<I>>
where I.Left: Pair, I.Right: Pair,
      I.Left.Left: Pair, I.Left.Right: Pair,
      I.Right.Left: Pair, I.Right.Right: Pair,
      I.Left.Left.Left: Structure, I.Left.Left.Right: Structure,
      I.Left.Right.Left: Structure, I.Left.Right.Right: Structure,
      I.Right.Left.Left: Structure, I.Right.Left.Right: Structure,
      I.Right.Right.Left: Structure, I.Right.Right.Right: Structure

/// Transpose the two complete images back into four signatures. The only
/// parameter is the observation representation; no source or word is supplied.
public enum RoutingFromProbeImages<P: Pair>: PredicateReading
where P.Left: Pair, P.Right: Pair,
      P.Left.Left: Pair, P.Left.Right: Pair,
      P.Right.Left: Pair, P.Right.Right: Pair,
      P.Left.Left.Left: Structure, P.Left.Left.Right: Structure,
      P.Left.Right.Left: Structure, P.Left.Right.Right: Structure,
      P.Right.Left.Left: Structure, P.Right.Left.Right: Structure,
      P.Right.Right.Left: Structure, P.Right.Right.Right: Structure {
    public typealias Left = P
    public typealias Right = BoundaryWorking<
        Paired<P.Left.Left.Left, P.Right.Left.Left>,
        Paired<P.Left.Left.Right, P.Right.Left.Right>,
        Paired<P.Left.Right.Left, P.Right.Right.Left>,
        Paired<P.Left.Right.Right, P.Right.Right.Right>
    >
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutingQuestion
    public typealias Answer = Right
}

/// The equality of reconstructed and actual routing coordinates is derived
/// in the generic body. Binary signatures and permutation coverage are the
/// declared semantic scope of VC74, not extra final-answer equality premises.
public enum RoutingFromProbes<I: Pair>: ReadingFactors
where I.Left: Pair, I.Right: Pair,
      I.Left.Left: Pair, I.Left.Right: Pair,
      I.Right.Left: Pair, I.Right.Right: Pair,
      I.Left.Left.Left: Structure, I.Left.Left.Right: Structure,
      I.Left.Right.Left: Structure, I.Left.Right.Right: Structure,
      I.Right.Left.Left: Structure, I.Right.Left.Right: Structure,
      I.Right.Right.Left: Structure, I.Right.Right.Right: Structure {
    public typealias Left = RoutingCoordinates<I>
    public typealias Observation = RoutingProbeImages<I>
    public typealias Right = RoutingFromProbeImages<Observation.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutingQuestion
    public typealias Answer = Left.Answer
}

public typealias AcquiredRouting<I: Pair> = AnswerFromAcquiredObservation<RoutingFromProbes<I>>
where I.Left: Pair, I.Right: Pair,
      I.Left.Left: Pair, I.Left.Right: Pair,
      I.Right.Left: Pair, I.Right.Right: Pair,
      I.Left.Left.Left: Structure, I.Left.Left.Right: Structure,
      I.Left.Right.Left: Structure, I.Left.Right.Right: Structure,
      I.Right.Left.Left: Structure, I.Right.Left.Right: Structure,
      I.Right.Right.Left: Structure, I.Right.Right.Right: Structure

public typealias RoutingAddress00 = Paired<Never, Never>
public typealias RoutingAddress01 = Paired<Never, Lit1>
public typealias RoutingAddress10 = Paired<Lit1, Never>
public typealias RoutingAddress11 = Paired<Lit1, Lit1>
public typealias IdentityRouting = BoundaryWorking<RoutingAddress00, RoutingAddress01, RoutingAddress10, RoutingAddress11>
