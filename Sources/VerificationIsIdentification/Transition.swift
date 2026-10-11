import Swift

/// An operation connects two applications of one observation in a fixed model.
/// The source and the observed answer may both change. The operation axis is
/// bound to the two step readings by ``CommutingTransition``. [VI 6e]
public protocol ObservedTransition: Pair, HasEncoding
where Left: PredicateReading, Right: PredicateReading,
      Left.Sigma == Sigma, Right.Sigma == Sigma,
      Left.Encoding == Encoding, Right.Encoding == Encoding,
      Left.Predicate == Right.Predicate {
    associatedtype Operation
}

/// One step on sources and one step on images have the same observed result.
/// The four corners are tied to their actual application addresses. Composing
/// two such squares with the same intermediate observation derives another
/// square, without adding the final output equality as a premise. [VI 6e]
public protocol CommutingTransition: ObservedTransition
where Operation == SourceStep.Predicate, SourceStep: PredicateReading, ImageStep: PredicateReading,
      Operation == ImageStep.Predicate,
      SourceStep.Sigma == Sigma, ImageStep.Sigma == Sigma,
      SourceStep.Encoding == Encoding, ImageStep.Encoding == Encoding,
      SourceStep.Left == Left.Left, SourceStep.Answer == Right.Left,
      ImageStep.Left == Left.Answer, ImageStep.Answer == Right.Answer {
    associatedtype SourceStep
    associatedtype ImageStep
}
