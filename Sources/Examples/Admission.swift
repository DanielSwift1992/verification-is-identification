import VerificationIsIdentification

public enum AdmissionReadingResults<
    L: CheckedSpellingAdmission,
    R: CheckedSpellingAdmission
>: VerdictIsInvariant
where L.Sigma == R.Sigma, L.Encoding == R.Encoding,
      L.Predicate == R.Predicate {
    public typealias Left = L.Left
    public typealias Right = R.Left
    public typealias Sigma = L.Sigma
    public typealias Encoding = L.Encoding
    public typealias Predicate = L.Predicate
    public typealias Answer = Never
}
