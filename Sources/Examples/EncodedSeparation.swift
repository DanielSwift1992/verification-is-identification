import VerificationIsIdentification

public typealias FiveWitnessValues<A: Structure, B: Structure,
    X: Structure, Y: Structure, Z: Structure> = Paired<Paired<A, B>, AddressTriple<X, Y, Z>>

/// Five roles are read from one actual recorded value packet. Every edge
/// below reuses these same node readings at this same root.
public enum WitnessNodeReadings<F: HasVerdict & Structure, C: Structure>: Close
where F.Answer: Pair, F.Answer.Left: Pair, F.Answer.Right: Pair,
      F.Answer.Right.Right: Pair,
      F.Answer.Left.Left: Structure, F.Answer.Left.Right: Structure,
      F.Answer.Right.Left: Structure, F.Answer.Right.Right.Left: Structure,
      F.Answer.Right.Right.Right: Structure,
      F.Sigma == BeamSpace, F.Encoding == SaturationEncoding {
    public typealias Root = Paired<F, C>
    public typealias Fact = FirstEvidenceImage<Root, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Values = SequentialReading<Fact, ReadRecordedAnswer<F>>
    public typealias Originals = SequentialReading<Values,
        FirstEvidenceImage<F.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Targets = SequentialReading<Values,
        SecondEvidenceImage<F.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias LastTargets = SequentialReading<Targets,
        SecondEvidenceImage<F.Answer.Right, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias A = SequentialReading<Originals,
        FirstEvidenceImage<Originals.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias B = SequentialReading<Originals,
        SecondEvidenceImage<Originals.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias X = SequentialReading<Targets,
        FirstEvidenceImage<Targets.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Y = SequentialReading<LastTargets,
        FirstEvidenceImage<LastTargets.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Z = SequentialReading<LastTargets,
        SecondEvidenceImage<LastTargets.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Resources = SecondEvidenceImage<Root, BeamSpace, SaturationEncoding, SecondProjection>
}

/// Each edge has its own C reading, but uses it for BOTH endpoints. The
/// finite Route grammar realizes one shared function on that edge. No
/// agreement of frames across different edges or injectivity is required.
public enum EncodedSeparation<A: PredicateReading, B: PredicateReading,
    C: PredicateReading, T: PredicateReading,
    F: PredicateReading, G: PredicateReading, R: PredicateReading>: PredicateReading
where A.Left == B.Left, A.Left == C.Left, A.Left == T.Left,
      A.Answer: Structure, B.Answer: Structure, C.Answer: Structure,
      T.Answer == EchoBitEquality,
      F.Left == Paired<A.Answer, C.Answer>, G.Left == Paired<B.Answer, C.Answer>,
      F.Answer: Structure, G.Answer: Structure,
      R.Left == Paired<Paired<F.Answer, G.Answer>, EchoBitEquality>,
      A.Sigma == BeamSpace, B.Sigma == BeamSpace, C.Sigma == BeamSpace, T.Sigma == BeamSpace,
      F.Sigma == BeamSpace, G.Sigma == BeamSpace, R.Sigma == BeamSpace,
      A.Encoding == SaturationEncoding, B.Encoding == SaturationEncoding,
      C.Encoding == SaturationEncoding, T.Encoding == SaturationEncoding,
      F.Encoding == SaturationEncoding, G.Encoding == SaturationEncoding, R.Encoding == SaturationEncoding {
    public typealias First = SequentialReading<JointEvidence<A, C>, F>
    public typealias Second = SequentialReading<JointEvidence<B, C>, G>
    public typealias Images = JointEvidence<First, Second>
    public typealias Actual = SequentialReading<JointEvidence<Images, T>, R>
    public typealias Left = A.Left
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
}

/// Join nine actual edge readings at one root. Six spokes are paired by
/// their target; the three target edges form the final triple. This layout
/// allows the existing all-FF coverage reader to consume the acquired bits.
public enum NineSeparationReadings<A: PredicateReading, B: PredicateReading,
    C: PredicateReading, D: PredicateReading, E: PredicateReading,
    F: PredicateReading, G: PredicateReading, H: PredicateReading,
    I: PredicateReading>: PredicateReading
where A.Left == B.Left, A.Left == C.Left, A.Left == D.Left, A.Left == E.Left,
      A.Left == F.Left, A.Left == G.Left, A.Left == H.Left, A.Left == I.Left,
      A.Answer: Structure, B.Answer: Structure, C.Answer: Structure,
      D.Answer: Structure, E.Answer: Structure, F.Answer: Structure,
      G.Answer: Structure, H.Answer: Structure, I.Answer: Structure,
      A.Sigma == BeamSpace, B.Sigma == BeamSpace, C.Sigma == BeamSpace,
      D.Sigma == BeamSpace, E.Sigma == BeamSpace, F.Sigma == BeamSpace,
      G.Sigma == BeamSpace, H.Sigma == BeamSpace, I.Sigma == BeamSpace,
      A.Encoding == SaturationEncoding, B.Encoding == SaturationEncoding,
      C.Encoding == SaturationEncoding, D.Encoding == SaturationEncoding,
      E.Encoding == SaturationEncoding, F.Encoding == SaturationEncoding,
      G.Encoding == SaturationEncoding, H.Encoding == SaturationEncoding, I.Encoding == SaturationEncoding {
    public typealias Spokes = JointEvidence<JointEvidence<A, D>,
        JointEvidence<JointEvidence<B, E>, JointEvidence<C, F>>>
    public typealias Triangle = JointEvidence<G, JointEvidence<H, I>>
    public typealias Actual = JointEvidence<Spokes, Triangle>
    public typealias Left = A.Left
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
}

/// Run an actual node-record acquisition once, then the network at that
/// record and its resident resources. The earlier source remains parked.
public enum AcquireRecordedNetwork<E: Pair, C: Structure, P: PredicateReading>: Pair
where E.Left: Structure, E.Right: Pair, E.Right.Left: Structure,
      E.Right.Right: Structure, P.Left == Paired<E.Right.Right, C> {
    public typealias Begin = StepBeside<E, C>
    public enum Focus: Pair {
        public typealias Left = Begin.Right
        public typealias Right = Paired<Paired<Left.Left.Right, Left.Right>, Left.Left.Left>
    }
    public typealias Record = StepBeside<RecordReading<P>, E.Right.Left>
    public enum Park: Pair {
        public typealias Left = Record.Right
        public typealias Right = Paired<Paired<Left.Left.Left, Left.Right>, Left.Left.Right>
    }
    public typealias Actual = FollowedPair<FollowedPair<FollowedPair<Begin, Focus>, Record>, Park>
    public typealias Left = Begin.Left
    public typealias Right = Park.Right
    public enum RetainsSource: Null {
        public typealias Left = AcquireRecordedNetwork.Right.Left.Right
        public typealias Right = E.Right.Left
    }
}
