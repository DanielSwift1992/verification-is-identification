import VerificationIsIdentification

public enum TargetFrameSpace: Close {}
public enum TargetFrameEncoding: Close {}
public enum TargetFrameQuestion: Close {}
public enum TargetFramePairQuestion: Close {}
public enum TargetFrameChangeQuestion: Close {}

/// Inverse images of two addressed targets, followed by the other fields.
/// The constructors also make sense for arbitrary records; permutation
/// membership is a separate premise of the paper's group instance.
public typealias TargetFrame<A: Structure, B: Structure, R: Structure> =
    Paired<A, Paired<B, R>>

public enum ReadFrameTarget<S: Pair>: PredicateReading
where S.Left: Structure {
    public typealias Left = S
    public typealias Right = S.Left
    public typealias Sigma = TargetFrameSpace
    public typealias Encoding = TargetFrameEncoding
    public typealias Predicate = TargetFrameQuestion
    public typealias Answer = Right
}

public enum ReadFrameTargetPair<S: Pair>: PredicateReading
where S.Left: Structure, S.Right: Pair, S.Right.Left: Structure {
    public typealias Left = S
    public typealias Right = Paired<S.Left, S.Right.Left>
    public typealias Sigma = TargetFrameSpace
    public typealias Encoding = TargetFrameEncoding
    public typealias Predicate = TargetFramePairQuestion
    public typealias Answer = Right
}

/// Exchange target roles, retaining the actual other fields.
public enum ExchangeFrameTargets<S: Pair>: PredicateReading
where S.Left: Structure, S.Right: Pair,
      S.Right.Left: Structure, S.Right.Right: Structure {
    public typealias Left = S
    public typealias Right = TargetFrame<S.Right.Left, S.Left, S.Right.Right>
    public typealias Sigma = TargetFrameSpace
    public typealias Encoding = TargetFrameEncoding
    public typealias Predicate = TargetFrameChangeQuestion
    public typealias Answer = Right
}

/// This update receives only the retained pair, not the original frame.
public enum ExchangeRetainedTargets<M: Pair>: PredicateReading
where M.Left: Structure, M.Right: Structure {
    public typealias Left = M
    public typealias Right = SwapBoundaryReading<M>.Answer
    public typealias Sigma = TargetFrameSpace
    public typealias Encoding = TargetFrameEncoding
    public typealias Predicate = TargetFrameChangeQuestion
    public typealias Answer = Right
}

/// The whole retained pair commutes with the actual source contact.
/// Final equality is derived; no answer equality is asked of the caller.
public enum TargetFrameTransport<S: Pair>: Null
where S.Left: Structure, S.Right: Pair,
      S.Right.Left: Structure, S.Right.Right: Structure {
    public typealias Contact = ExchangeFrameTargets<S>
    public typealias Observation = ReadFrameTargetPair<S>
    public typealias SourcePath = SequentialReading<Contact,
        ReadFrameTargetPair<Contact.Answer>>
    public typealias MemoryPath = SequentialReading<Observation,
        ExchangeRetainedTargets<Observation.Answer>>
    public typealias Left = SourcePath.Answer
    public typealias Right = MemoryPath.Answer
}
