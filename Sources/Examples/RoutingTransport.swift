import VerificationIsIdentification

/// Pull a factorization back along an actual source reading. The old
/// decoder is unchanged and receives no parameter naming the larger source.
public enum FactorOnSource<F: ReadingFactors, S: PredicateReading>: ReadingFactors
where S.Answer == F.Left.Left, S.Sigma == F.Sigma, S.Encoding == F.Encoding {
    public typealias Left = DecodeRefinedEvidence<S, F.Left>
    public typealias Observation = DecodeRefinedEvidence<S, F.Observation>
    public typealias Right = F.Right
    public typealias Sigma = F.Sigma
    public typealias Encoding = F.Encoding
    public typealias Predicate = F.Predicate
    public typealias Answer = F.Answer
}

/// Recover the old observation at a larger actual source, then reuse its
/// decoder. The seam concerns the observation, not the requested answer.
/// S names the original source inside that larger input; G supplies recovery
/// there. No equality of the final decoded answers is a caller premise.
public enum AnswerOnSourceRecovery<
    F: ReadingFactors, S: PredicateReading, G: ReadingFactors
>: ReadingFactors
where S.Answer == F.Left.Left, S.Sigma == F.Sigma, S.Encoding == F.Encoding,
      G.Left.Left == S.Left, G.Sigma == F.Sigma, G.Encoding == F.Encoding,
      G.Left.Answer == F.Observation.Answer {
    public typealias Left = DecodeRefinedEvidence<S, F.Left>
    public typealias Observation = G.Observation
    public typealias Right = DecodeRefinedEvidence<G.Right, F.Right>
    public typealias Sigma = F.Sigma
    public typealias Encoding = F.Encoding
    public typealias Predicate = F.Predicate
    public typealias Answer = F.Answer
}

/// One module (routing, internal state) beside a resident reserve state.
public typealias RoutingModule<I: Structure, H: Structure, J: Structure> = Paired<Paired<I, H>, J>

/// Read the routing inside the module at the first resident address.
public typealias ResidentRoutingSource<I: Structure, H: Structure, J: Structure> = DecodeRefinedEvidence<
    FirstEvidenceImage<RoutingModule<I, H, J>, BeamSpace, SaturationEncoding, RoutingQuestion>,
    FirstEvidenceImage<Paired<I, H>, BeamSpace, SaturationEncoding, RoutingQuestion>
>

public typealias ResidentRoutingFactors<I: Pair, H: Structure, J: Structure> = FactorOnSource<
    RoutingFromProbes<I>, ResidentRoutingSource<I, H, J>
>
where I.Left: Pair, I.Right: Pair,
      I.Left.Left: Pair, I.Left.Right: Pair, I.Right.Left: Pair, I.Right.Right: Pair,
      I.Left.Left.Left: Structure, I.Left.Left.Right: Structure,
      I.Left.Right.Left: Structure, I.Left.Right.Right: Structure,
      I.Right.Left.Left: Structure, I.Right.Left.Right: Structure,
      I.Right.Right.Left: Structure, I.Right.Right.Right: Structure

public enum ModuleStateExchangeOperation: Close {}

/// The same structural exchange used for resident instruments changes the
/// module's state and parks its previous state in the internal reserve.
public enum ExchangeModuleState<W: Pair>: PredicateReading
where W.Left: Pair, W.Left.Left: Structure, W.Left.Right: Structure, W.Right: Structure {
    public typealias Left = W
    public typealias Right = ExchangeResidentInstruments<W>.Right
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = ModuleStateExchangeOperation
    public typealias Answer = Right
}

public enum KeepRoutingOnModuleExchange<I>: PredicateReading {
    public typealias Left = I
    public typealias Right = I
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = ModuleStateExchangeOperation
    public typealias Answer = Right
}

/// The actual whole and module change from ((I,H),J) to ((I,J),H).
/// The routing image remains invariant by the generic body's projections.
/// Neither H==J nor equality of final routing answers is a caller premise.
public enum RoutingModuleExchange<I: Pair, H: Structure, J: Structure>: CommutingTransition
where I.Left: Pair, I.Right: Pair,
      I.Left.Left: Pair, I.Left.Right: Pair, I.Right.Left: Pair, I.Right.Right: Pair,
      I.Left.Left.Left: Structure, I.Left.Left.Right: Structure,
      I.Left.Right.Left: Structure, I.Left.Right.Right: Structure,
      I.Right.Left.Left: Structure, I.Right.Left.Right: Structure,
      I.Right.Right.Left: Structure, I.Right.Right.Right: Structure {
    public typealias Left = ResidentRoutingFactors<I, H, J>.Left
    public typealias Right = ResidentRoutingFactors<I, J, H>.Left
    public typealias SourceStep = ExchangeModuleState<RoutingModule<I, H, J>>
    public typealias ImageStep = KeepRoutingOnModuleExchange<Left.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Operation = ModuleStateExchangeOperation
}

/// Carry a certified square beside explicitly supplied input data. The
/// source step, image step and both readings retain the same X argument.
public enum TransitionBesideInput<P: CommutingTransition, X: Structure>: CommutingTransition
where P.Left.Left: Structure, P.Right.Left: Structure,
      P.Left.Answer: Structure, P.Right.Answer: Structure {
    public typealias Left = ReadingBesideInput<P.Left, X>
    public typealias Right = ReadingBesideInput<P.Right, X>
    public typealias SourceStep = ReadingBesideInput<P.SourceStep, X>
    public typealias ImageStep = ReadingBesideInput<P.ImageStep, X>
    public typealias Sigma = P.Sigma
    public typealias Encoding = P.Encoding
    public typealias Operation = SourceStep.Predicate
}

public enum RoutingReserveExchangeOperation: Close {}

/// A different internal move replaces the routing itself. Its previous
/// value is retained in the reserve, but an old law-only fact omits the
/// arbitrary replacement. This is the positive boundary of law transport.
public enum ExchangeRoutingWithReserve<I: Structure, H: Structure, J: Structure>: PredicateReading {
    public typealias Left = RoutingModule<I, H, J>
    public typealias Right = RoutingModule<J, H, I>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = RoutingReserveExchangeOperation
    public typealias Answer = Right
}
