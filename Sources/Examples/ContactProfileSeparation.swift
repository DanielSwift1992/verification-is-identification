import VerificationIsIdentification

/// P supplies four arbitrary observation symbols a,b,c,d. Each constructor
/// accepts one proposed profile collision and derives a=b. No conclusion
/// equality is requested separately. The concrete contrast is supplied by
/// the acquired reading, outside these implications.
public enum ProfileCollision01<P: Pair>: Null
where P.Left: Pair, P.Right: Pair,
      P.Left.Left: Structure, P.Left.Right: Structure,
      P.Right.Left: Structure, P.Right.Right: Structure,
      AddressTriple<P.Left.Left, P.Left.Right, P.Right.Left>
        == AddressTriple<P.Right.Right, P.Right.Right, P.Right.Right> {
    public typealias Left = P.Left.Left
    public typealias Right = P.Left.Right
}

public enum ProfileCollision02<P: Pair>: Null
where P.Left: Pair, P.Right: Pair,
      P.Left.Left: Structure, P.Left.Right: Structure,
      P.Right.Left: Structure, P.Right.Right: Structure,
      AddressTriple<P.Left.Left, P.Left.Right, P.Right.Left>
        == AddressTriple<P.Left.Right, P.Right.Left, P.Left.Left> {
    public typealias Left = P.Left.Left
    public typealias Right = P.Left.Right
}

public enum ProfileCollision03<P: Pair>: Null
where P.Left: Pair, P.Right: Pair,
      P.Left.Left: Structure, P.Left.Right: Structure,
      P.Right.Left: Structure, P.Right.Right: Structure,
      AddressTriple<P.Left.Left, P.Left.Right, P.Right.Left>
        == AddressTriple<P.Right.Left, P.Left.Left, P.Left.Right> {
    public typealias Left = P.Left.Left
    public typealias Right = P.Left.Right
}

public enum ProfileCollision12<P: Pair>: Null
where P.Left: Pair, P.Right: Pair,
      P.Left.Left: Structure, P.Left.Right: Structure,
      P.Right.Left: Structure, P.Right.Right: Structure,
      AddressTriple<P.Right.Right, P.Right.Right, P.Right.Right>
        == AddressTriple<P.Left.Right, P.Right.Left, P.Left.Left> {
    public typealias Left = P.Left.Left
    public typealias Right = P.Left.Right
}

public enum ProfileCollision13<P: Pair>: Null
where P.Left: Pair, P.Right: Pair,
      P.Left.Left: Structure, P.Left.Right: Structure,
      P.Right.Left: Structure, P.Right.Right: Structure,
      AddressTriple<P.Right.Right, P.Right.Right, P.Right.Right>
        == AddressTriple<P.Right.Left, P.Left.Left, P.Left.Right> {
    public typealias Left = P.Left.Left
    public typealias Right = P.Left.Right
}

public enum ProfileCollision23<P: Pair>: Null
where P.Left: Pair, P.Right: Pair,
      P.Left.Left: Structure, P.Left.Right: Structure,
      P.Right.Left: Structure, P.Right.Right: Structure,
      AddressTriple<P.Left.Right, P.Right.Left, P.Left.Left>
        == AddressTriple<P.Right.Left, P.Left.Left, P.Left.Right> {
    public typealias Left = P.Left.Left
    public typealias Right = P.Left.Right
}
