import VerificationIsIdentification

public typealias PhaseLawProbe2<L: Pair> = SequentialReading<
    SecondEvidenceImage<L, BeamSpace, SaturationEncoding, SecondProjection>,
    FirstEvidenceImage<L.Right, BeamSpace, SaturationEncoding, FirstProjection>>
where L.Right: Pair

/// The actual W action on coordinate labels describes which old input is at
/// each new input. Its entry at new input 2 is old input 0.
public typealias PhaseLawWInputTransport = FourLeafPhaseWord<
    RoutingAddress00, RoutingAddress01, RoutingAddress10, RoutingAddress11>.Right

public enum PhaseLawTransportedPoint2Question: Close {}

/// Independently read point 2 of the actual current law after the trace.
/// W contains the changed law and the one old fact beside the transport.
public enum CurrentPhasePoint2<W: Pair>: PredicateReading
where W.Left: Pair, W.Left.Left: Pair, W.Left.Left.Right: Pair {
    public typealias Trace = FirstEvidenceImage<W, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Law = SequentialReading<Trace,
        FirstEvidenceImage<W.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Actual = SequentialReading<Law, PhaseLawProbe2<Law.Answer>>
    public typealias Left = W
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = PhaseLawTransportedPoint2Question
    public typealias Answer = Right
}

/// Only the old point-0 fact and the supplied input transport are available.
/// The transport must send new input 2 to old input 0. The original fact keeps
/// its original question; the new reading is justified by the factor below.
public enum EarlierPoint0AtCurrent2<M: Pair>: PredicateReading
where M.Left: HasVerdict & Structure, M.Left.Answer: Structure,
      M.Left.Sigma == BeamSpace, M.Left.Encoding == SaturationEncoding,
      M.Left.Predicate == OperationSequence<FirstProjection, FirstProjection>,
      M.Right: Pair, M.Right.Right: Pair,
      M.Right.Right.Left == RoutingAddress00 {
    public typealias Fact = FirstEvidenceImage<M, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Actual = SequentialReading<Fact, ReadRecordedAnswer<M.Left>>
    public typealias Left = M
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = PhaseLawTransportedPoint2Question
    public typealias Answer = Right
}

/// A known change preserves an earlier answer by moving its current input
/// address. No equality between old and new laws is assumed. Agreement of
/// the requested answers follows from the actual W path, not a caller premise.
public enum KnownPhaseLawTransport<A: Structure, B: Structure,
    C: Structure, D: Structure>: ReadingFactors {
    public typealias Initial = BoundaryWorking<A, B, C, D>
    public typealias First = RecordReading<PhaseLawProbe0<Initial>>
    public typealias Change = StepBeside<FourLeafPhaseWord<A, B, C, D>, First.Right.Right>
    public typealias Path = FollowedPair<First, Change>
    public typealias Run = StepBeside<Path, PhaseLawWInputTransport>
    public typealias Trace = FirstEvidenceImage<Run.Right, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias CurrentLaw = SequentialReading<Trace,
        FirstEvidenceImage<Run.Right.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias FirstFact = SequentialReading<Trace,
        SecondEvidenceImage<Run.Right.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Transport = SecondEvidenceImage<Run.Right, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Left = CurrentPhasePoint2<Run.Right>
    public typealias Observation = JointEvidence<FirstFact, Transport>
    public typealias Right = EarlierPoint0AtCurrent2<Observation.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = PhaseLawTransportedPoint2Question
    public typealias Answer = Left.Answer

    public enum KeepsOriginalFact: Null {
        public typealias Left = Observation.Answer.Left
        public typealias Right = First.Right.Right
    }
    public enum ActualReaddressing: Null {
        public typealias Left = Paired<PhaseLawWInputTransport.Right.Left, Answer>
        public typealias Right = Paired<RoutingAddress00, A>
    }
}
