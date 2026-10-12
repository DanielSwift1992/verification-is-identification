import Swift

/// Two source answers agree with one actual late reading.
/// The boundary readings and supplied joining witnesses retain the original
/// source addresses. The equality follows from the shared late reading.
/// The boundary enters through completeness, which supplies that shared
/// partner. Completeness remains a premise of the source theorem. [Continuation E2]
public protocol SharedBoundaryContinuation: Pair
where Left: VerdictIsInvariant, Right: VerdictIsInvariant,
      Left.Right == Right.Right,
      Boundary.LeftSource == Left.Left.Left,
      Boundary.RightSource == Right.Left.Left,
      FirstJoin.Left == Left.Left.Left,
      FirstJoin.Right == Left.Right.Left,
      SecondJoin.Left == Right.Left.Left,
      SecondJoin.Right == Right.Right.Left {
    associatedtype Boundary: EncodingForgets
    associatedtype FirstJoin: Pair
    associatedtype SecondJoin: Pair
}
