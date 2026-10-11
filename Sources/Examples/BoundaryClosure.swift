import VerificationIsIdentification

/// The four working coordinates. Hidden fields stay in the actual source.
public enum BoundaryCoordinates<P: Pair>: PredicateReading
where P.Left: BeamShape, P.Right: BeamShape {
    public typealias Left = P
    public typealias Right = Paired<EyeImage<P.Left>, EyeImage<P.Right>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = BoundaryCoordinatesQuestion
    public typealias Answer = Right
}

public enum BoundaryCoordinatesQuestion: Close {}
public enum BoundaryTableQuestion: Close {}

/// Exchange the coordinates inside the first row. This updates the working
/// coordinates under E; its old first value remains at the second address.
public enum ExchangeFirstImage<I: Pair>: PredicateReading
where I.Left: Pair, I.Left.Left: Structure, I.Left.Right: Structure,
      I.Right: Structure {
    public typealias Left = I
    public typealias Right = Paired<Paired<I.Left.Right, I.Left.Left>, I.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = FirstFieldsOperation
    public typealias Answer = Right
}

public enum BoundaryCoordinatesExchange<P: Pair>: CommutingTransition
where P.Left: BeamShape, P.Right: BeamShape {
    public typealias Left = BoundaryCoordinates<P>
    public typealias Right = BoundaryCoordinates<ExchangedBoundaryFirst<P>>
    public typealias SourceStep = ExchangeBoundaryFirst<P>
    public typealias ImageStep = ExchangeFirstImage<Left.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Operation = FirstFieldsOperation
}

public enum BoundaryCoordinatesSwap<P: Pair>: CommutingTransition
where P.Left: BeamShape & Structure, P.Right: BeamShape & Structure {
    public typealias Left = BoundaryCoordinates<P>
    public typealias Right = BoundaryCoordinates<SwapBoundaryReading<P>.Answer>
    public typealias SourceStep = SwapBoundaryReading<P>
    public typealias ImageStep = SwapBoundaryReading<Left.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Operation = SwapOperation
}

/// Four supplied comparisons at their exact coordinate addresses. In VC69
/// the admitted leaves are the three binary clauses from BoundaryEvolution.
/// PredicateReading alone does not seal that grammar or prove its coverage.
public enum BoundaryTable<I: Pair, A: PredicateReading, B: PredicateReading,
                          C: PredicateReading, D: PredicateReading>: PredicateReading
where I.Left: Pair, I.Right: Pair,
      I.Left.Left: Structure, I.Left.Right: Structure,
      I.Right.Left: Structure, I.Right.Right: Structure,
      A.Left == Paired<I.Left.Left, I.Right.Left>,
      B.Left == Paired<I.Left.Left, I.Right.Right>,
      C.Left == Paired<I.Left.Right, I.Right.Left>,
      D.Left == Paired<I.Left.Right, I.Right.Right>,
      A.Sigma == BeamSpace, B.Sigma == A.Sigma, C.Sigma == A.Sigma, D.Sigma == A.Sigma,
      A.Encoding == SaturationEncoding, B.Encoding == A.Encoding,
      C.Encoding == A.Encoding, D.Encoding == A.Encoding,
      A.Predicate == CommonBoundaryQuestion, B.Predicate == A.Predicate,
      C.Predicate == A.Predicate, D.Predicate == A.Predicate,
      A.Answer: Structure, B.Answer: Structure, C.Answer: Structure, D.Answer: Structure {
    public typealias Left = I
    public typealias Right = Paired<Paired<A.Answer, B.Answer>, Paired<C.Answer, D.Answer>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = BoundaryTableQuestion
    public typealias Answer = Right
}

/// Row exchange on the table has E's operation address. It differs from
/// ExchangeFirstImage, which exchanges coordinates inside the first row.
public enum ExchangeTableRows<I: Pair>: PredicateReading
where I.Left: Structure, I.Right: Structure {
    public typealias Left = I
    public typealias Right = Paired<I.Right, I.Left>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = FirstFieldsOperation
    public typealias Answer = Right
}

public enum TransposeBoundaryTable<I: Pair>: PredicateReading
where I.Left: Pair, I.Right: Pair,
      I.Left.Left: Structure, I.Left.Right: Structure,
      I.Right.Left: Structure, I.Right.Right: Structure {
    public typealias Left = I
    public typealias Right = Paired<Paired<I.Left.Left, I.Right.Left>, Paired<I.Left.Right, I.Right.Right>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = SwapOperation
    public typealias Answer = Right
}

/// Precompose a comparison with reversal of its input. On the admitted
/// three binary clauses this is the same common question (VC66). On an
/// arbitrary supplied reading that symmetry remains an explicit premise.
public enum ReverseBoundaryComparison<R: PredicateReading>: PredicateReading
where R.Left: Pair, R.Left.Left: Structure, R.Left.Right: Structure,
      R.Sigma == BeamSpace, R.Encoding == SaturationEncoding,
      R.Predicate == CommonBoundaryQuestion {
    public typealias Left = Paired<R.Left.Right, R.Left.Left>
    public typealias Right = R.Answer
    public typealias Sigma = R.Sigma
    public typealias Encoding = R.Encoding
    public typealias Predicate = R.Predicate
    public typealias Answer = Right
}

/// One generic square, no premise equating the final table answers.
public enum BoundaryTableExchange<I: Pair, A: PredicateReading, B: PredicateReading,
                                  C: PredicateReading, D: PredicateReading>: CommutingTransition
where I.Left: Pair, I.Right: Pair,
      I.Left.Left: Structure, I.Left.Right: Structure,
      I.Right.Left: Structure, I.Right.Right: Structure,
      I.Right: Structure,
      A.Left == Paired<I.Left.Left, I.Right.Left>,
      B.Left == Paired<I.Left.Left, I.Right.Right>,
      C.Left == Paired<I.Left.Right, I.Right.Left>,
      D.Left == Paired<I.Left.Right, I.Right.Right>,
      A.Sigma == BeamSpace, B.Sigma == A.Sigma, C.Sigma == A.Sigma, D.Sigma == A.Sigma,
      A.Encoding == SaturationEncoding, B.Encoding == A.Encoding,
      C.Encoding == A.Encoding, D.Encoding == A.Encoding,
      A.Predicate == CommonBoundaryQuestion, B.Predicate == A.Predicate,
      C.Predicate == A.Predicate, D.Predicate == A.Predicate,
      A.Answer: Structure, B.Answer: Structure, C.Answer: Structure, D.Answer: Structure {
    public typealias Left = BoundaryTable<I, A, B, C, D>
    public typealias SourceStep = ExchangeFirstImage<I>
    public typealias Right = BoundaryTable<SourceStep.Answer, C, D, A, B>
    public typealias ImageStep = ExchangeTableRows<Left.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Operation = FirstFieldsOperation
}

public enum BoundaryTableSwap<I: Pair, A: PredicateReading, B: PredicateReading,
                              C: PredicateReading, D: PredicateReading>: CommutingTransition
where I.Left: Pair, I.Right: Pair,
      I.Left.Left: Structure, I.Left.Right: Structure,
      I.Right.Left: Structure, I.Right.Right: Structure,
      A.Left == Paired<I.Left.Left, I.Right.Left>,
      B.Left == Paired<I.Left.Left, I.Right.Right>,
      C.Left == Paired<I.Left.Right, I.Right.Left>,
      D.Left == Paired<I.Left.Right, I.Right.Right>,
      A.Sigma == BeamSpace, B.Sigma == A.Sigma, C.Sigma == A.Sigma, D.Sigma == A.Sigma,
      A.Encoding == SaturationEncoding, B.Encoding == A.Encoding,
      C.Encoding == A.Encoding, D.Encoding == A.Encoding,
      A.Predicate == CommonBoundaryQuestion, B.Predicate == A.Predicate,
      C.Predicate == A.Predicate, D.Predicate == A.Predicate,
      A.Answer: Structure, B.Answer: Structure, C.Answer: Structure, D.Answer: Structure {
    public typealias Left = BoundaryTable<I, A, B, C, D>
    public typealias SourceStep = SwapBoundaryReading<I>
    public typealias Right = BoundaryTable<SourceStep.Answer,
        ReverseBoundaryComparison<A>, ReverseBoundaryComparison<C>,
        ReverseBoundaryComparison<B>, ReverseBoundaryComparison<D>>
    public typealias ImageStep = TransposeBoundaryTable<Left.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Operation = SwapOperation
}

/// The current common class, including refusal, is the first table cell.
public enum ReadBoundaryTable<I: Pair>: PredicateReading
where I.Left: Pair {
    public typealias Left = I
    public typealias Right = I.Left.Left
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = CommonBoundaryQuestion
    public typealias Answer = Right
}

/// The operation address is the next resident tape field. The consumed
/// head moves to the internal past, while the rest supplies the next step.
/// On the admitted S/E readings the working-coordinate action is reversible.
public enum ResidentBoundaryCommand<R: PredicateReading, Tape: Pair, Past: Structure>: PredicateReading
where R.Left: Structure, R.Answer: Structure,
      Tape.Left == R.Predicate, Tape.Left: Structure, Tape.Right: Structure {
    public typealias Left = Paired<R.Left, Paired<Tape, Past>>
    public typealias Right = Paired<R.Answer, Paired<Tape.Right, Paired<Tape.Left, Past>>>
    public typealias Sigma = R.Sigma
    public typealias Encoding = R.Encoding
    public typealias Predicate = R.Predicate
    public typealias Answer = Right
}

/// Recording an occurrence uses the existing retained-whole construction.
/// The command tape, its cursor and its past are already inside both states.
public typealias RecordedBoundaryCommand<R: PredicateReading, Tape: Pair, Past: Structure> = RetainedWhole<
    ResidentBoundaryCommand<R, Tape, Past>.Left,
    ResidentBoundaryCommand<R, Tape, Past>.Right
>
where R.Left: Structure, R.Answer: Structure,
      Tape.Left == R.Predicate, Tape.Left: Structure, Tape.Right: Structure

public enum CrossBoundaryOperation: Close {}

/// A new internal connection: exchange first alpha with second beta.
/// All six declared beam fields remain in the output. This reconstructs
/// beam contents, without identifying arbitrary nominal source wrappers.
public enum CrossBoundaryReading<P: Pair>: PredicateReading
where P.Left: BeamShape, P.Right: BeamShape {
    public typealias Left = P
    public typealias Right = Paired<
        BoundaryBeam<P.Right.BetaLevel, P.Left.BetaLevel, P.Left.PaschenLevel>,
        BoundaryBeam<P.Right.AlphaLevel, P.Left.AlphaLevel, P.Right.PaschenLevel>
    >
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = CrossBoundaryOperation
    public typealias Answer = Right
}

public enum CrossBoundaryImage<I: Pair>: PredicateReading
where I.Left: Pair, I.Right: Pair,
      I.Left.Left: Structure, I.Left.Right: Structure,
      I.Right.Left: Structure, I.Right.Right: Structure {
    public typealias Left = I
    public typealias Right = BoundaryWorking<I.Right.Right, I.Left.Right, I.Right.Left, I.Left.Left>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = CrossBoundaryOperation
    public typealias Answer = Right
}

public enum BoundaryCoordinatesCross<P: Pair>: CommutingTransition
where P.Left: BeamShape, P.Right: BeamShape {
    public typealias Left = BoundaryCoordinates<P>
    public typealias Right = BoundaryCoordinates<CrossBoundaryReading<P>.Answer>
    public typealias SourceStep = CrossBoundaryReading<P>
    public typealias ImageStep = CrossBoundaryImage<Left.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Operation = CrossBoundaryOperation
}
