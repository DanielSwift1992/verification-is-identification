import VerificationIsIdentification

/// Three reversals of the same marker pair cannot close with distinct
/// markers. Reuse the established odd-circuit construction by traversing
/// one edge back and forth after the triangle. No collapse is requested.
/// The interpretation as unequal neighbors uses a genuine two-symbol
/// alphabet; arbitrary Pair conformances do not establish that alphabet.
public enum TriangularContactCalibration<A: Pair, B: Pair, C: Pair>: Null
where B.Left == A.Right, B.Right == A.Left,
      C.Left == B.Right, C.Right == B.Left,
      A.Left == C.Right, A.Right == C.Left {
    public typealias Circuit = OddContactCalibration<A, B, C, A, B>
    public typealias Left = Circuit.Left
    public typealias Right = Circuit.Right
}

/// Extract an actual triangle for every unequal input pair from the five
/// pullback tables I,W,Z,Z∘W,W². Reorienting an unordered comparison edge
/// exchanges its two fields; it does not assume a new sensor reading.
public enum FiveContactTriangles<S: Pair>: Null
where S.Left: Pair, S.Right: Pair,
      S.Left.Left: Structure, S.Left.Right: Structure,
      S.Right.Left: Structure, S.Right.Right: Structure {
    public typealias V = CoarseContactViews<S>
    public typealias WW = V.Words.W.Right
    public typealias T01 = Paired<Paired<V.I.Left.Left, V.I.Left.Right>,
        Paired<Paired<WW.Left.Right, WW.Left.Left>, Paired<V.ZW.Left.Left, V.ZW.Left.Right>>>
    public typealias T02 = Paired<Paired<V.I.Left.Left, V.I.Right.Left>,
        Paired<Paired<V.W.Left.Left, V.W.Right.Left>, Paired<WW.Left.Left, WW.Right.Left>>>
    public typealias T03 = Paired<Paired<V.I.Left.Left, V.I.Right.Right>,
        Paired<Paired<WW.Left.Left, WW.Right.Right>, Paired<V.W.Left.Left, V.W.Right.Right>>>
    public typealias T12 = Paired<Paired<V.I.Left.Right, V.I.Right.Left>,
        Paired<Paired<V.ZW.Right.Left, V.ZW.Left.Right>, Paired<WW.Right.Left, WW.Left.Right>>>
    public typealias T13 = Paired<Paired<V.W.Right.Right, V.W.Left.Right>,
        Paired<Paired<WW.Left.Right, WW.Right.Right>, Paired<V.Z.Right.Right, V.Z.Left.Right>>>
    public typealias T23 = Paired<Paired<V.I.Right.Left, V.I.Right.Right>,
        Paired<Paired<V.W.Right.Left, V.W.Right.Right>, Paired<WW.Right.Left, WW.Right.Right>>>
    public typealias A = S.Left.Left
    public typealias B = S.Left.Right
    public typealias C = S.Right.Left
    public typealias D = S.Right.Right
    public typealias Left = Paired<Paired<T01, Paired<T02, T03>>,
        Paired<T12, Paired<T13, T23>>>
    public typealias Right = Paired<
        Paired<Paired<Paired<A, B>, Paired<Paired<B, D>, Paired<D, A>>>,
            Paired<Paired<Paired<A, C>, Paired<Paired<C, D>, Paired<D, A>>>,
                Paired<Paired<A, D>, Paired<Paired<D, C>, Paired<C, A>>>>>,
        Paired<Paired<Paired<B, C>, Paired<Paired<C, A>, Paired<A, B>>>,
            Paired<Paired<Paired<A, B>, Paired<Paired<B, C>, Paired<C, A>>>,
                Paired<Paired<C, D>, Paired<Paired<D, A>, Paired<A, C>>>>>>
}
