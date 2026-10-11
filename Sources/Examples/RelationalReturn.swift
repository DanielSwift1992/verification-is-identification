import VerificationIsIdentification

/// C identifies the two descriptions at a return seam. The crossing relates
/// their addressed sides. Their agreement follows without an A == B premise.
/// This is static compatibility, with no temporal iteration. [Matter M58]
public enum SwapReturnForcesAgreement<C: Null>: Null
where C.Left: Pair, C.Right: Pair,
      C.Right.Left == C.Left.Right, C.Right.Right == C.Left.Left {
    public typealias Left = C.Left.Left
    public typealias Right = C.Left.Right
}

/// Every diagonal pair supplies an actual swap application and a return.
/// The component remains arbitrary; closure does not choose its value.
public enum DiagonalSwapReturn<A: Structure>: Null {
    public typealias Left = Paired<A, A>
    public typealias Right = SwapBoundaryReading<Left>.Answer
}

/// The derived side equality supplies the existing common-boundary answer.
/// The required equality is obtained through the generic return witness.
public typealias SwapReturnBoundary<C: Null> = AgreedBoundaryPairClass<
    Paired<SwapReturnForcesAgreement<C>.Left, SwapReturnForcesAgreement<C>.Right>
>
where C.Left: Pair, C.Right: Pair,
      C.Left.Left: Structure, C.Left.Right: Structure,
      C.Right.Left == C.Left.Right, C.Right.Right == C.Left.Left

/// An identity return admits unequal components as well as equal ones.
/// Return topology alone does not force the crossing's consequence.
public enum IdentityPairReturn<A: Structure, B: Structure>: Null {
    public typealias Left = Paired<A, B>
    public typealias Right = IdentityReading<Left, BeamSpace, SaturationEncoding>.Answer
}

/// Two actual swaps compose to the same addressed pair for every A and B.
/// The intermediate pair need not equal either endpoint. This composition
/// is also a static relation; physical succession is not a premise. [M58]
public enum DoubleSwapReturn<A: Structure, B: Structure>: Null {
    public typealias Left = Paired<A, B>
    public typealias First = SwapBoundaryReading<Left>
    public typealias Second = SwapBoundaryReading<First.Answer>
    public typealias Path = SequentialReading<First, Second>
    public typealias Right = Path.Answer
}

/// Two resident fields satisfy an actual transport relation. Both accessors
/// use the same source. T starts at the first field and computes the second.
/// The answer retains both accessors and that application, so JointEvidence
/// can join contacts only on a common source. These are static field laws,
/// without an observation event or a physical interpretation asserted. [IiS21]
public enum ResidentTransportContact<
    A: PredicateReading, B: PredicateReading, T: PredicateReading
>: PredicateReading
where A.Left == B.Left, A.Sigma == B.Sigma, A.Encoding == B.Encoding,
      T.Sigma == A.Sigma, T.Encoding == A.Encoding,
      T.Left == A.Answer, T.Answer == B.Answer {
    public typealias Left = A.Left
    public typealias Right = Paired<Paired<A, B>, T>
    public typealias Answer = Right
    public typealias Sigma = A.Sigma
    public typealias Encoding = A.Encoding
    public typealias Predicate = OperationSequence<
        OperationSequence<A.Predicate, B.Predicate>, T.Predicate
    >
}

/// Two direct contacts and one reversed contact use the three actual frame
/// fields of W. Their shared cycle forces the first frame's sides to agree.
/// Only these contact equations are premises. No nominal frame is equated
/// with its reconstruction, and the side agreement is derived. [IiS21]
public enum ThreePhaseContactsForceCollapse<W: Pair>: Null
where W.Left: Pair, W.Right: Pair, W.Right.Left: Pair, W.Right.Right: Pair,
      W.Right.Left.Left == W.Left.Left, W.Right.Left.Right == W.Left.Right,
      W.Right.Right.Left == W.Right.Left.Left, W.Right.Right.Right == W.Right.Left.Right,
      W.Right.Right.Right == W.Left.Left, W.Right.Right.Left == W.Left.Right {
    public typealias Left = W.Left.Left
    public typealias Right = W.Left.Right
}
