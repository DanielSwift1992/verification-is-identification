import VerificationIsIdentification

public typealias EchoBitEquality = BoundaryWorking<Lit1, Never, Never, Lit1>
public typealias EchoAllThree = BoundaryWorking<Paired<Never, Never>,
    Paired<Never, Never>, Paired<Never, Never>, Paired<Never, Lit1>>
public typealias EchoOrbitResources = Paired<EchoBitEquality, EchoAllThree>

/// Compare the two bits in each acquired echo, then read their conjunction.
/// Under M64i's coverage this answers equality of the original signals.
/// No original signal, cycle origin or current return value enters here.
public enum EchoOrbitAnswer<M: Pair, A: PredicateReading,
    B: PredicateReading, C: PredicateReading,
    D: PredicateReading, E: PredicateReading>: PredicateReading
where M.Left: Pair, M.Left.Right: Pair, M.Right == EchoOrbitResources,
      M.Left.Left: HasVerdict & Structure,
      M.Left.Right.Left: HasVerdict & Structure, M.Left.Right.Right: HasVerdict & Structure,
      M.Left.Left.Answer: Structure, M.Left.Right.Left.Answer: Structure,
      M.Left.Right.Right.Answer: Structure,
      M.Left.Left.Sigma == BeamSpace, M.Left.Right.Left.Sigma == BeamSpace,
      M.Left.Right.Right.Sigma == BeamSpace,
      M.Left.Left.Encoding == SaturationEncoding, M.Left.Right.Left.Encoding == SaturationEncoding,
      M.Left.Right.Right.Encoding == SaturationEncoding,
      A.Left == Paired<M.Left.Left.Answer, EchoBitEquality>, A.Answer: Structure,
      B.Left == Paired<M.Left.Right.Left.Answer, EchoBitEquality>, B.Answer: Structure,
      C.Left == Paired<M.Left.Right.Right.Answer, EchoBitEquality>, C.Answer: Structure,
      D.Left == Paired<Paired<A.Answer, B.Answer>, EchoAllThree>, D.Answer: Structure,
      E.Left == Paired<C.Answer, D.Answer>,
      A.Sigma == BeamSpace, B.Sigma == BeamSpace, C.Sigma == BeamSpace,
      D.Sigma == BeamSpace, E.Sigma == BeamSpace,
      A.Encoding == SaturationEncoding, B.Encoding == SaturationEncoding,
      C.Encoding == SaturationEncoding, D.Encoding == SaturationEncoding,
      E.Encoding == SaturationEncoding {
    public typealias Facts = FirstEvidenceImage<M, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias F0 = SequentialReading<Facts,
        FirstEvidenceImage<M.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Tail = SequentialReading<Facts,
        SecondEvidenceImage<M.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias F1 = SequentialReading<Tail,
        FirstEvidenceImage<M.Left.Right, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias F2 = SequentialReading<Tail,
        SecondEvidenceImage<M.Left.Right, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias V0 = SequentialReading<F0, ReadRecordedAnswer<M.Left.Left>>
    public typealias V1 = SequentialReading<F1, ReadRecordedAnswer<M.Left.Right.Left>>
    public typealias V2 = SequentialReading<F2, ReadRecordedAnswer<M.Left.Right.Right>>
    public typealias Resources = SecondEvidenceImage<M, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Equality = SequentialReading<Resources,
        FirstEvidenceImage<M.Right, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Conjunction = SequentialReading<Resources,
        SecondEvidenceImage<M.Right, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Equal0 = SequentialReading<JointEvidence<V0, Equality>, A>
    public typealias Equal1 = SequentialReading<JointEvidence<V1, Equality>, B>
    public typealias Equal2 = SequentialReading<JointEvidence<V2, Equality>, C>
    public typealias Row = SequentialReading<JointEvidence<JointEvidence<Equal0, Equal1>, Conjunction>, D>
    public typealias Actual = SequentialReading<JointEvidence<Equal2, Row>, E>
    public typealias Left = M
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
}

public enum EchoOrbitMemory<E: Pair>: Close
where E.Left: Structure, E.Right: Pair, E.Right.Left: Pair,
      E.Right.Left.Left: Pair, E.Right.Right: Structure,
      E.Right.Left.Right: Structure, E.Right.Left.Left.Right: Structure {
    public typealias Run = StepBeside<E, EchoOrbitResources>
    public typealias Facts = ThreeStageFacts<Run.Right>
    public typealias Resources = SecondEvidenceImage<Run.Right, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Observation = JointEvidence<Facts, Resources>
}

/// Apply the available reader only after the actual three recorded rounds.
public enum EchoOrbitDecision<E: Pair, D: PredicateReading>: Pair
where E.Left: Structure, E.Right: Pair, E.Right.Left: Pair,
      E.Right.Left.Left: Pair, E.Right.Right: Structure,
      E.Right.Left.Right: Structure, E.Right.Left.Left.Right: Structure,
      D.Left == Paired<AddressTriple<E.Right.Right, E.Right.Left.Right,
          E.Right.Left.Left.Right>, EchoOrbitResources>,
      D.Sigma == BeamSpace, D.Encoding == SaturationEncoding {
    public typealias Acquisition = EchoOrbitMemory<E>
    public typealias Read = SequentialReading<Acquisition.Observation, D>
    public typealias Record = RecordReading<Read>
    public typealias Actual = FollowedPair<Acquisition.Run, Record>
    public typealias Left = Actual.Left
    public typealias Right = Actual.Right
    public enum RetainsWhole: Null {
        public typealias Left = EchoOrbitDecision.Right.Left.Left
        public typealias Right = E.Right
    }
}
