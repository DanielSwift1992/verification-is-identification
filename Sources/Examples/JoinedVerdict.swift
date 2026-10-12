import VerificationIsIdentification

/// Join two applications of the same question when their answers coincide.
public enum JoinedVerdict<
    L: PredicateReading,
    R: PredicateReading
>: VerdictIsInvariant
where L.Sigma == R.Sigma, L.Encoding == R.Encoding,
      L.Predicate == R.Predicate, L.Answer == R.Answer {
    public typealias Left = L
    public typealias Right = R
    public typealias Sigma = L.Sigma
    public typealias Encoding = L.Encoding
    public typealias Predicate = L.Predicate
    public typealias Answer = L.Answer
}
