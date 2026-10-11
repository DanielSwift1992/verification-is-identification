import VerificationIsIdentification

/// This question reports the first output coordinate of a supplied actual
/// application. Its name contains neither the operation nor its input.
public enum MechanismOutputQuestion: Close {}
public enum MechanismLawQuestion: Close {}

/// The application is the source of this reading. It contains the actual
/// probe and its outcome. Equal output facts do not identify applications.
public enum MechanismOutput<R: PredicateReading>: PredicateReading
where R.Answer: Pair, R.Answer.Left: BeamShape {
    public typealias Left = R
    public typealias Right = R.Answer.Left.AlphaLevel
    public typealias Sigma = R.Sigma
    public typealias Encoding = R.Encoding
    public typealias Predicate = MechanismOutputQuestion
    public typealias Answer = Right
}

/// The operation code is interpreted as a law only on the declared E/K
/// constructor family. An arbitrary PredicateReading's tag is not that law.
public enum MechanismLaw<R: PredicateReading>: PredicateReading {
    public typealias Left = R
    public typealias Right = R.Predicate
    public typealias Sigma = R.Sigma
    public typealias Encoding = R.Encoding
    public typealias Predicate = MechanismLawQuestion
    public typealias Answer = Right
}

/// On the admitted probe family, E returns zero and K returns one.
/// These decoder inputs contain no mechanism or application parameter.
public enum ExchangeFromZeroProbe: PredicateReading {
    public typealias Left = Never
    public typealias Right = FirstFieldsOperation
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = MechanismLawQuestion
    public typealias Answer = Right
}

public enum CrossFromOneProbe: PredicateReading {
    public typealias Left = Lit1
    public typealias Right = CrossBoundaryOperation
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = MechanismLawQuestion
    public typealias Answer = Right
}

/// One clause of the finite law decoder. Preparation fixes only the two
/// coordinates needed to distinguish E from K, not every source field.
public enum ExchangeLawFromProbe<P: Pair>: ReadingFactors
where P.Left: BeamShape, P.Right: BeamShape,
      P.Left.BetaLevel == Never, P.Right.BetaLevel == Lit1 {
    public typealias Application = ExchangeBoundaryFirst<P>
    public typealias Left = MechanismLaw<Application>
    public typealias Observation = MechanismOutput<Application>
    public typealias Right = ExchangeFromZeroProbe
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = MechanismLawQuestion
    public typealias Answer = Left.Answer
}

public enum CrossLawFromProbe<P: Pair>: ReadingFactors
where P.Left: BeamShape, P.Right: BeamShape,
      P.Left.BetaLevel == Never, P.Right.BetaLevel == Lit1 {
    public typealias Application = CrossBoundaryReading<P>
    public typealias Left = MechanismLaw<Application>
    public typealias Observation = MechanismOutput<Application>
    public typealias Right = CrossFromOneProbe
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = MechanismLawQuestion
    public typealias Answer = Left.Answer
}

public typealias AcquiredExchangeLaw<P: Pair> = AnswerFromAcquiredObservation<ExchangeLawFromProbe<P>>
where P.Left: BeamShape, P.Right: BeamShape,
      P.Left.BetaLevel == Never, P.Right.BetaLevel == Lit1

public typealias AcquiredCrossLaw<P: Pair> = AnswerFromAcquiredObservation<CrossLawFromProbe<P>>
where P.Left: BeamShape, P.Right: BeamShape,
      P.Left.BetaLevel == Never, P.Right.BetaLevel == Lit1

/// The prepared slot records this actual application's output. The retained
/// application includes both sides of the intervention, inside the whole.
public typealias PreparedMechanismProbe<R: PredicateReading> = PreparedTraceExtension<
    StartObservations<R>, MechanismOutput<R>
>
where R.Answer: Pair, R.Answer.Left: BeamShape

public typealias ExchangeLawFromTrace<P: Pair> = AnswerOnRefinement<
    ExchangeLawFromProbe<P>,
    LastAnswerFromTrace<PreparedMechanismProbe<ExchangeBoundaryFirst<P>>.Trace>
>
where P.Left: BeamShape, P.Right: BeamShape,
      P.Left.BetaLevel == Never, P.Right.BetaLevel == Lit1

public typealias CrossLawFromTrace<P: Pair> = AnswerOnRefinement<
    CrossLawFromProbe<P>,
    LastAnswerFromTrace<PreparedMechanismProbe<CrossBoundaryReading<P>>.Trace>
>
where P.Left: BeamShape, P.Right: BeamShape,
      P.Left.BetaLevel == Never, P.Right.BetaLevel == Lit1
