import VerificationIsIdentification

/// Names the visible-reading question shared by the examples.
public enum VisibleQuestion: Close {}

/// Ask only for a beam's visible image. The answer is computed by the existing
/// EyeImage type alias, not supplied as a separate, unchecked answer parameter.
public enum VisibleReading<B: BeamShape>: PredicateReading {
    public typealias Left = B
    public typealias Right = EyeImage<B>
    public typealias Sigma = BeamSpace
    public typealias Encoding = EyeEncoding
    public typealias Predicate = VisibleQuestion
    public typealias Answer = EyeImage<B>
}

