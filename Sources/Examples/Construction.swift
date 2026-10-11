import VerificationIsIdentification

/// The previous whole contains its context and the two addressed operands.
/// The local result is another retained field. It need not recover the inputs.
public typealias RetainedConstruction<
    H: Structure,
    A: Structure,
    B: Structure,
    Result: Structure
> = RetainedWhole<Paired<H, Paired<A, B>>, Result>

/// Read the operand boundary through the retained predecessor. The input to
/// this projection is the output record, not a separately supplied old copy.
public typealias RecordedOperands<R: Permanent> = Paired<
    R.Right.Left.Right.Left,
    R.Right.Left.Right.Right
>
where R.Left: Pair, R.Left.Right: Pair,
      R.Left.Right.Left: Structure, R.Left.Right.Right: Structure

/// Permanent supplies the source equality. Only the operand address is a
/// further premise. Their reconstruction is the conclusion. [EiF EF8]
public enum ConstructionRecoversOperands<R: Permanent>: Null
where R.Left: Pair, R.Left.Right: Pair,
      R.Left.Right.Left: Structure, R.Left.Right.Right: Structure {
    public typealias Left = RecordedOperands<R>
    public typealias Right = Paired<R.Left.Right.Left, R.Left.Right.Right>
}

/// Histories and local results may differ. An equal admitted operand boundary
/// forces the same reconstructed answer through any two retaining records.
public enum SameBoundaryForcesOperands<P: Permanent, Q: Permanent>: Null
where P.Left: Pair, Q.Left: Pair, P.Left.Right == Q.Left.Right,
      P.Left.Right: Pair,
      P.Left.Right.Left: Structure, P.Left.Right.Right: Structure {
    public typealias Left = RecordedOperands<P>
    public typealias Right = RecordedOperands<Q>
}

/// Apply the same recovery address to an alleged equality of complete outputs.
/// Input equality follows, rather than being supplied by the caller.
public enum RetainedOutputIdentifiesSource<P: Permanent, Q: Permanent>: Null
where P.Right == Q.Right {
    public typealias Left = P.Left
    public typealias Right = Q.Left
}

/// A concrete partial construction family admits equal operand types only.
/// Retention remains available without admitting every formal ordered pair.
public typealias DiagonalConstruction<
    H: Structure,
    A: Structure
> = RetainedConstruction<H, A, A, Paired<A, A>>
