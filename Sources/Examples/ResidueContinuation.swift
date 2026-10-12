import VerificationIsIdentification

/// Two certified rows use one actual choice at their complete input.
/// The original question remains fixed across them. Outcomes and residue
/// records stay bound to each source and reached state. [Acquire Adequacy]
public enum CommonAdequateContinuationRows<
    L: AdequateResidueContinuation,
    R: AdequateResidueContinuation
>: Pair
where L.Choice == R.Choice, L.Predicate == R.Predicate {
    public typealias Left = L
    public typealias Right = R
}
