import VerificationIsIdentification

public typealias PhaseEqualityTable = BoundaryWorking<FourLeafPhaseMark0,
    FourLeafPhaseMark1, FourLeafPhaseMark2, FourLeafPhaseMark3>

/// Two actual resident probes run in one paired source. Both replies then
/// pass through the same resident frame C. Only the resulting joint fact
/// will be available to the equality decoder; the earlier records survive.
public enum PairedProbeInFrame<P: PredicateReading, Q: PredicateReading,
    C: Structure, F: PredicateReading, G: PredicateReading>: Pair
where P.Left: Structure, Q.Left: Structure, P.Answer: Pair, Q.Answer: Pair,
      P.Answer.Right: HasVerdict & Structure, Q.Answer.Right: HasVerdict & Structure,
      P.Answer.Right.Answer: Structure, Q.Answer.Right.Answer: Structure,
      P.Sigma == BeamSpace, Q.Sigma == BeamSpace,
      P.Encoding == SaturationEncoding, Q.Encoding == SaturationEncoding,
      P.Answer.Right.Sigma == BeamSpace, Q.Answer.Right.Sigma == BeamSpace,
      P.Answer.Right.Encoding == SaturationEncoding, Q.Answer.Right.Encoding == SaturationEncoding,
      F.Left == Paired<P.Answer.Right.Answer, C>, G.Left == Paired<Q.Answer.Right.Answer, C>,
      F.Answer: Structure, G.Answer: Structure,
      F.Sigma == BeamSpace, G.Sigma == BeamSpace,
      F.Encoding == SaturationEncoding, G.Encoding == SaturationEncoding {
    public typealias Probes = PairedApplication<P, Q>
    public typealias Run = StepBeside<Probes, C>
    public enum ThroughFrame: PredicateReading {
        public typealias Left = Run.Right
        public typealias Both = FirstEvidenceImage<Left, BeamSpace, SaturationEncoding, FirstProjection>
        public typealias FirstProbe = SequentialReading<Both,
            FirstEvidenceImage<Both.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
        public typealias SecondProbe = SequentialReading<Both,
            SecondEvidenceImage<Both.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
        public typealias FirstFact = SequentialReading<FirstProbe,
            SecondEvidenceImage<P.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
        public typealias SecondFact = SequentialReading<SecondProbe,
            SecondEvidenceImage<Q.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
        public typealias A = SequentialReading<FirstFact, ReadRecordedAnswer<P.Answer.Right>>
        public typealias B = SequentialReading<SecondFact, ReadRecordedAnswer<Q.Answer.Right>>
        public typealias Frame = SecondEvidenceImage<Left, BeamSpace, SaturationEncoding, SecondProjection>
        public typealias First = SequentialReading<JointEvidence<A, Frame>, F>
        public typealias Second = SequentialReading<JointEvidence<B, Frame>, G>
        public typealias Actual = JointEvidence<First, Second>
        public typealias Right = Paired<F.Answer, G.Answer>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Actual.Predicate
        public typealias Answer = Right
        public enum Endpoint: Null {
            public typealias Left = Actual.Answer
            public typealias Right = ThroughFrame.Right
        }
    }
    public typealias Record = RecordReading<ThroughFrame>
    public typealias Actual = FollowedPair<Run, Record>
    public typealias Left = Run.Left
    public typealias Right = Record.Right
    public enum KeepsOriginalProbeResults: Null {
        public typealias Left = Paired<PairedProbeInFrame.Right.Left.Left,
            PairedProbeInFrame.Right.Left.Right>
        public typealias Right = Paired<Probes.Answer, C>
    }
}

/// Equality is read from the joint acquired fact through the existing four
/// coordinate clauses. Neither raw replies nor the common frame enter here.
public enum EqualJointReply<F: HasVerdict & Structure,
    R: PredicateReading, L: PredicateReading>: PredicateReading
where F.Answer: Pair, F.Answer.Left: Structure, F.Answer.Right: Structure,
      F.Sigma == BeamSpace, F.Encoding == SaturationEncoding,
      R.Left == Paired<F.Answer.Left, PhaseEqualityTable>, R.Answer: Structure,
      L.Left == Paired<F.Answer.Right, R.Answer>,
      R.Sigma == BeamSpace, L.Sigma == BeamSpace,
      R.Encoding == SaturationEncoding, L.Encoding == SaturationEncoding {
    public typealias Left = Paired<F, PhaseEqualityTable>
    public typealias Fact = FirstEvidenceImage<Left, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Replies = SequentialReading<Fact, ReadRecordedAnswer<F>>
    public typealias A = SequentialReading<Replies,
        FirstEvidenceImage<F.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias B = SequentialReading<Replies,
        SecondEvidenceImage<F.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Table = SecondEvidenceImage<Left, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Row = SequentialReading<JointEvidence<A, Table>, R>
    public typealias Actual = SequentialReading<JointEvidence<B, Row>, L>
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
}

/// Apply the fact-only comparison to a supplied actual framed acquisition.
/// The source is linked by composition, not by a separate applicability flag.
public enum PairedProbeDecision<E: Pair, R: PredicateReading,
    L: PredicateReading>: Pair
where E.Left: Structure, E.Right: Pair, E.Right.Right: HasVerdict & Structure,
      E.Right.Right.Answer: Pair,
      E.Right.Right.Answer.Left: Structure, E.Right.Right.Answer.Right: Structure,
      E.Right.Right.Sigma == BeamSpace, E.Right.Right.Encoding == SaturationEncoding,
      R.Left == Paired<E.Right.Right.Answer.Left, PhaseEqualityTable>, R.Answer: Structure,
      L.Left == Paired<E.Right.Right.Answer.Right, R.Answer>,
      R.Sigma == BeamSpace, L.Sigma == BeamSpace,
      R.Encoding == SaturationEncoding, L.Encoding == SaturationEncoding {
    public typealias Run = StepBeside<E, PhaseEqualityTable>
    public typealias FrameResult = FirstEvidenceImage<Run.Right, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Fact = SequentialReading<FrameResult,
        SecondEvidenceImage<E.Right, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Table = SecondEvidenceImage<Run.Right, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Observation = JointEvidence<Fact, Table>
    public typealias Decode = EqualJointReply<E.Right.Right, R, L>
    public typealias Read = SequentialReading<Observation, Decode>
    public typealias Record = RecordReading<Read>
    public typealias Actual = FollowedPair<Run, Record>
    public typealias Left = Actual.Left
    public typealias Right = Actual.Right
    public enum RetainsWhole: Null {
        public typealias Left = PairedProbeDecision.Right.Left
        public typealias Right = Run.Right
    }
}
