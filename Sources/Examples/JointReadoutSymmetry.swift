import VerificationIsIdentification

/// Normalize four actual rows and pull both argument positions through
/// the same established W or Z. FirstW moves only the first argument.
public enum PairReadoutViews<R0: Pair, R1: Pair, R2: Pair, R3: Pair>: Close
where R0.Left: Pair, R0.Right: Pair,
      R1.Left: Pair, R1.Right: Pair,
      R2.Left: Pair, R2.Right: Pair,
      R3.Left: Pair, R3.Right: Pair,
      R0.Left.Left: Structure, R0.Left.Right: Structure,
      R0.Right.Left: Structure, R0.Right.Right: Structure,
      R1.Left.Left: Structure, R1.Left.Right: Structure,
      R1.Right.Left: Structure, R1.Right.Right: Structure,
      R2.Left.Left: Structure, R2.Left.Right: Structure,
      R2.Right.Left: Structure, R2.Right.Right: Structure,
      R3.Left.Left: Structure, R3.Left.Right: Structure,
      R3.Right.Left: Structure, R3.Right.Right: Structure {
    public typealias V0 = CoarseContactViews<R0>
    public typealias V1 = CoarseContactViews<R1>
    public typealias V2 = CoarseContactViews<R2>
    public typealias V3 = CoarseContactViews<R3>
    public typealias I = BoundaryWorking<V0.I, V1.I, V2.I, V3.I>
    public typealias W = CoarseContactViews<BoundaryWorking<V0.W, V1.W, V2.W, V3.W>>.W
    public typealias Z = CoarseContactViews<BoundaryWorking<V0.Z, V1.Z, V2.Z, V3.Z>>.Z
    public typealias FirstW = CoarseContactViews<I>.W
}

/// An explicit table with two unconstrained output fields. Neither their
/// distinction nor their interpretation is supplied by their type names.
public enum TwoOrbitReadout<A: Structure, B: Structure>: Close {
    public typealias R0 = BoundaryWorking<A, B, B, B>
    public typealias R1 = BoundaryWorking<B, A, B, B>
    public typealias R2 = BoundaryWorking<B, B, A, B>
    public typealias R3 = BoundaryWorking<B, B, B, A>
    public typealias Table = BoundaryWorking<R0, R1, R2, R3>
    public typealias Views = PairReadoutViews<R0, R1, R2, R3>
}

/// Joint invariance of the actual table under W and Z derives its entire
/// two-orbit form. No Boolean range, answer equality or output count is
/// imposed separately on the caller.
public enum JointInvariantPairReadout<R0: Pair, R1: Pair, R2: Pair, R3: Pair>: Null
where R0.Left: Pair, R0.Right: Pair,
      R1.Left: Pair, R1.Right: Pair,
      R2.Left: Pair, R2.Right: Pair,
      R3.Left: Pair, R3.Right: Pair,
      R0.Left.Left: Structure, R0.Left.Right: Structure,
      R0.Right.Left: Structure, R0.Right.Right: Structure,
      R1.Left.Left: Structure, R1.Left.Right: Structure,
      R1.Right.Left: Structure, R1.Right.Right: Structure,
      R2.Left.Left: Structure, R2.Left.Right: Structure,
      R2.Right.Left: Structure, R2.Right.Right: Structure,
      R3.Left.Left: Structure, R3.Left.Right: Structure,
      R3.Right.Left: Structure, R3.Right.Right: Structure,
      PairReadoutViews<R0, R1, R2, R3>.I == PairReadoutViews<R0, R1, R2, R3>.W,
      PairReadoutViews<R0, R1, R2, R3>.I == PairReadoutViews<R0, R1, R2, R3>.Z {
    public typealias Left = PairReadoutViews<R0, R1, R2, R3>.I
    public typealias Right = TwoOrbitReadout<R0.Left.Left, R0.Left.Right>.Table
}

/// Requiring even this one independent argument change to leave the
/// jointly invariant table unchanged collapses its two output fields.
public enum IndependentReadoutCollapse<A: Structure, B: Structure>: Null
where TwoOrbitReadout<A, B>.Views.I == TwoOrbitReadout<A, B>.Views.FirstW {
    public typealias Left = A
    public typealias Right = B
}
