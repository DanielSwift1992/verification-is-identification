import VerificationIsIdentification

/// Both readings retain their actual source and have one question signature.
/// This supplies their pair without asking their answers to agree.
public enum SuppliedReadingPair<L: PredicateReading, R: PredicateReading>: ComparedReadings
where L.Sigma == R.Sigma, L.Encoding == R.Encoding, L.Predicate == R.Predicate {
    public typealias Left = L
    public typealias Right = R
}

public enum PrismQuestion: Close {}
public enum MatteQuestion: Close {}
public enum MirrorQuestion: Close {}

public enum PrismReading<B: BeamShape>: PredicateReading {
    public typealias Left = B
    public typealias Right = PrismImage<B>
    public typealias Sigma = BeamSpace
    public typealias Encoding = PrismSeparator
    public typealias Predicate = PrismQuestion
    public typealias Answer = Right
}

public enum MatteReading<S: SceneLight>: PredicateReading {
    public typealias Left = S
    public typealias Right = MatteImage<S>
    public typealias Sigma = MirrorSpace
    public typealias Encoding = MatteEncoding
    public typealias Predicate = MatteQuestion
    public typealias Answer = Right
}

public enum MirrorReading<S: SceneLight>: PredicateReading {
    public typealias Left = S
    public typealias Right = MirrorImage<S>
    public typealias Sigma = MirrorSpace
    public typealias Encoding = MirrorSeparator
    public typealias Predicate = MirrorQuestion
    public typealias Answer = Right
}

/// Salt is an explicit construction parameter, not a proved source fact.
/// The common labels alone do not make these one deterministic encoder.
public enum SaltedVisibleReading<B: BeamShape, S: Structure>: PredicateReading {
    public typealias Left = B
    public typealias Right = SaltedImage<B, S>
    public typealias Sigma = BeamSpace
    public typealias Encoding = EyeEncoding
    public typealias Predicate = VisibleQuestion
    public typealias Answer = Right
}
