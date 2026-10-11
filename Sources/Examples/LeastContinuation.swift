import VerificationIsIdentification

/// The second projection of the same joint reading. Both fields come from
/// its supplied source; matching answer labels alone would not suffice.
public enum JointEvidenceRetainsSecond<A: PredicateReading, B: PredicateReading>: ReadingFactors
where A.Left == B.Left, A.Sigma == B.Sigma, A.Encoding == B.Encoding,
      A.Answer: Structure, B.Answer: Structure {
    public typealias Left = B
    public typealias Observation = JointEvidence<A, B>
    public typealias Right = SecondEvidenceImage<Observation.Answer,
        B.Sigma, B.Encoding, B.Predicate>
    public typealias Sigma = B.Sigma
    public typealias Encoding = B.Encoding
    public typealias Predicate = B.Predicate
    public typealias Answer = B.Answer
}

/// If F decodes its question from the actual joint (P,D), this constructor
/// decodes (P,F.Left) from that same observation. Its output is the least
/// JOINT information for retaining P and answering F.Left (System U6).
/// It neither acquires D nor makes D a least standalone residual.
/// The existing factors remain premises in their declared interpretation.
public typealias LeastJointEvidence<
    P: PredicateReading,
    D: PredicateReading,
    F: ReadingFactors
> = JointEvidenceFromMemory<JointEvidenceRetainsFirst<P, D>, F>
where P.Left == D.Left, P.Sigma == D.Sigma, P.Encoding == D.Encoding,
      P.Answer: Structure, D.Answer: Structure, F.Answer: Structure,
      F.Observation == JointEvidence<P, D>

/// The independently fixed question after the actual frame exchange.
public typealias NextFrameTarget<S: Pair> = SequentialReading<
    ExchangeFrameTargets<S>,
    ReadFrameTarget<ExchangeFrameTargets<S>.Answer>
>
where S.Left: Structure, S.Right: Pair,
      S.Right.Left: Structure, S.Right.Right: Structure

/// Any ONE observation supporting these two addressed questions also
/// supports the retained pair used by TargetFrameTransport. Decoder is
/// constructed from the actual two decoders. No equality with the desired
/// pair is requested from the caller; it follows from the two source paths.
/// This is System U7's lower factorization for this existing action family,
/// not an automatic search for the factors or a physical copying theorem.
public enum FramePairFromSufficientObservation<
    S: Pair,
    Now: ReadingFactors,
    Next: ReadingFactors
>: Null
where S.Left: Structure, S.Right: Pair,
      S.Right.Left: Structure, S.Right.Right: Structure,
      Now.Left == ReadFrameTarget<S>, Next.Left == NextFrameTarget<S>,
      Now.Observation == Next.Observation {
    public typealias Decoder = JointEvidence<Now.Right, Next.Right>
    public typealias Left = ReadFrameTargetPair<S>.Answer
    public typealias Right = Decoder.Answer
}
