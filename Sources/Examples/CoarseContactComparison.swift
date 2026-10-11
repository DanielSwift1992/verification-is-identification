import VerificationIsIdentification

/// Pull a fixed four-cell sensor back along I, W, Z and Z∘W.
/// The existing catalogue uses chronological push words. Its WW and ZWW
/// therefore supply the required pullback tables for W and Z∘W.
public enum CoarseContactViews<S: Pair>: Close
where S.Left: Pair, S.Right: Pair,
      S.Left.Left: Structure, S.Left.Right: Structure,
      S.Right.Left: Structure, S.Right.Right: Structure {
    public typealias Words = PhaseWordCatalogue<S.Left.Left, S.Left.Right,
        S.Right.Left, S.Right.Right>
    public typealias I = Words.Initial
    public typealias W = Words.WW.Right
    public typealias Z = Words.Z.Right
    public typealias ZW = Words.ZWW.Right
    public typealias All = BoundaryWorking<I, W, Z, ZW>
}

/// Each implication takes four acquired coarse agreements for one pair
/// of distinct source positions. It derives collapse of the whole sensor;
/// that collapse is not another condition imposed on the caller.
public enum CoarseAgreement01<S: Pair>: Null
where S.Left: Pair, S.Right: Pair,
      S.Left.Left: Structure, S.Left.Right: Structure,
      S.Right.Left: Structure, S.Right.Right: Structure,
      CoarseContactViews<S>.I.Left.Left == CoarseContactViews<S>.I.Left.Right,
      CoarseContactViews<S>.W.Left.Left == CoarseContactViews<S>.W.Left.Right,
      CoarseContactViews<S>.Z.Left.Left == CoarseContactViews<S>.Z.Left.Right,
      CoarseContactViews<S>.ZW.Left.Left == CoarseContactViews<S>.ZW.Left.Right {
    public typealias Left = CoarseContactViews<S>.I
    public typealias Right = BoundaryWorking<S.Left.Left, S.Left.Left, S.Left.Left, S.Left.Left>
}
public enum CoarseAgreement02<S: Pair>: Null
where S.Left: Pair, S.Right: Pair,
      S.Left.Left: Structure, S.Left.Right: Structure,
      S.Right.Left: Structure, S.Right.Right: Structure,
      CoarseContactViews<S>.I.Left.Left == CoarseContactViews<S>.I.Right.Left,
      CoarseContactViews<S>.W.Left.Left == CoarseContactViews<S>.W.Right.Left,
      CoarseContactViews<S>.Z.Left.Left == CoarseContactViews<S>.Z.Right.Left,
      CoarseContactViews<S>.ZW.Left.Left == CoarseContactViews<S>.ZW.Right.Left {
    public typealias Left = CoarseContactViews<S>.I
    public typealias Right = BoundaryWorking<S.Left.Left, S.Left.Left, S.Left.Left, S.Left.Left>
}
public enum CoarseAgreement03<S: Pair>: Null
where S.Left: Pair, S.Right: Pair,
      S.Left.Left: Structure, S.Left.Right: Structure,
      S.Right.Left: Structure, S.Right.Right: Structure,
      CoarseContactViews<S>.I.Left.Left == CoarseContactViews<S>.I.Right.Right,
      CoarseContactViews<S>.W.Left.Left == CoarseContactViews<S>.W.Right.Right,
      CoarseContactViews<S>.Z.Left.Left == CoarseContactViews<S>.Z.Right.Right,
      CoarseContactViews<S>.ZW.Left.Left == CoarseContactViews<S>.ZW.Right.Right {
    public typealias Left = CoarseContactViews<S>.I
    public typealias Right = BoundaryWorking<S.Left.Left, S.Left.Left, S.Left.Left, S.Left.Left>
}
public enum CoarseAgreement12<S: Pair>: Null
where S.Left: Pair, S.Right: Pair,
      S.Left.Left: Structure, S.Left.Right: Structure,
      S.Right.Left: Structure, S.Right.Right: Structure,
      CoarseContactViews<S>.I.Left.Right == CoarseContactViews<S>.I.Right.Left,
      CoarseContactViews<S>.W.Left.Right == CoarseContactViews<S>.W.Right.Left,
      CoarseContactViews<S>.Z.Left.Right == CoarseContactViews<S>.Z.Right.Left,
      CoarseContactViews<S>.ZW.Left.Right == CoarseContactViews<S>.ZW.Right.Left {
    public typealias Left = CoarseContactViews<S>.I
    public typealias Right = BoundaryWorking<S.Left.Left, S.Left.Left, S.Left.Left, S.Left.Left>
}
public enum CoarseAgreement13<S: Pair>: Null
where S.Left: Pair, S.Right: Pair,
      S.Left.Left: Structure, S.Left.Right: Structure,
      S.Right.Left: Structure, S.Right.Right: Structure,
      CoarseContactViews<S>.I.Left.Right == CoarseContactViews<S>.I.Right.Right,
      CoarseContactViews<S>.W.Left.Right == CoarseContactViews<S>.W.Right.Right,
      CoarseContactViews<S>.Z.Left.Right == CoarseContactViews<S>.Z.Right.Right,
      CoarseContactViews<S>.ZW.Left.Right == CoarseContactViews<S>.ZW.Right.Right {
    public typealias Left = CoarseContactViews<S>.I
    public typealias Right = BoundaryWorking<S.Left.Left, S.Left.Left, S.Left.Left, S.Left.Left>
}
public enum CoarseAgreement23<S: Pair>: Null
where S.Left: Pair, S.Right: Pair,
      S.Left.Left: Structure, S.Left.Right: Structure,
      S.Right.Left: Structure, S.Right.Right: Structure,
      CoarseContactViews<S>.I.Right.Left == CoarseContactViews<S>.I.Right.Right,
      CoarseContactViews<S>.W.Right.Left == CoarseContactViews<S>.W.Right.Right,
      CoarseContactViews<S>.Z.Right.Left == CoarseContactViews<S>.Z.Right.Right,
      CoarseContactViews<S>.ZW.Right.Left == CoarseContactViews<S>.ZW.Right.Right {
    public typealias Left = CoarseContactViews<S>.I
    public typealias Right = BoundaryWorking<S.Left.Left, S.Left.Left, S.Left.Left, S.Left.Left>
}

