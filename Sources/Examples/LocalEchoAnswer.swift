import VerificationIsIdentification

/// The two fields admit inequality and equality respectively. Keeping both
/// alternatives is different from returning an unsupported negative answer.
public typealias EchoDifferent = Paired<Lit1, Never>
public typealias EchoEqual = Paired<Never, Lit1>
public typealias EchoUndetermined = Paired<Lit1, Lit1>

/// Addressed first by the two acquired echo bits, then by equality of the
/// encoded replies. Its meaning is proved in M64h for the shared c,d model.
public typealias EchoCompletionTable = BoundaryWorking<
    Paired<EchoDifferent, EchoUndetermined>,
    Paired<EchoDifferent, EchoDifferent>,
    Paired<EchoDifferent, EchoDifferent>,
    Paired<EchoDifferent, EchoEqual>>
public typealias EchoDecisionResources = Paired<PhaseEqualityTable, EchoCompletionTable>

/// Only two acquired facts and fixed resources enter the answer reader.
/// R,S compare the encoded pair; T selects by the acquired echo bits;
/// U is LocalPolicyAtZero/One on the selected pair of possibilities.
public enum LocalEchoAnswer<M: Pair, R: PredicateReading,
    S: PredicateReading, T: PredicateReading, U: PredicateReading>: PredicateReading
where M.Left: Pair, M.Right == EchoDecisionResources,
      M.Left.Left: HasVerdict & Structure, M.Left.Right: HasVerdict & Structure,
      M.Left.Left.Answer: Pair, M.Left.Right.Answer: Structure,
      M.Left.Left.Answer.Left: Structure, M.Left.Left.Answer.Right: Structure,
      M.Left.Left.Sigma == BeamSpace, M.Left.Right.Sigma == BeamSpace,
      M.Left.Left.Encoding == SaturationEncoding, M.Left.Right.Encoding == SaturationEncoding,
      R.Left == Paired<M.Left.Left.Answer.Left, PhaseEqualityTable>, R.Answer: Structure,
      S.Left == Paired<M.Left.Left.Answer.Right, R.Answer>, S.Answer: Structure,
      T.Left == Paired<M.Left.Right.Answer, EchoCompletionTable>, T.Answer: Structure,
      U.Left == Paired<S.Answer, T.Answer>,
      R.Sigma == BeamSpace, S.Sigma == BeamSpace, T.Sigma == BeamSpace, U.Sigma == BeamSpace,
      R.Encoding == SaturationEncoding, S.Encoding == SaturationEncoding,
      T.Encoding == SaturationEncoding, U.Encoding == SaturationEncoding {
    public typealias Facts = FirstEvidenceImage<M, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias ForwardFact = SequentialReading<Facts,
        FirstEvidenceImage<M.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias EchoFact = SequentialReading<Facts,
        SecondEvidenceImage<M.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Resources = SecondEvidenceImage<M, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Equality = SequentialReading<Resources,
        FirstEvidenceImage<M.Right, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Completion = SequentialReading<Resources,
        SecondEvidenceImage<M.Right, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias EncodedEqual = SequentialReading<JointEvidence<ForwardFact, Equality>,
        EqualJointReply<M.Left.Left, R, S>>
    public typealias EchoBits = SequentialReading<EchoFact, ReadRecordedAnswer<M.Left.Right>>
    public typealias Possibilities = SequentialReading<JointEvidence<EchoBits, Completion>, T>
    public typealias Actual = SequentialReading<JointEvidence<EncodedEqual, Possibilities>, U>
    public typealias Left = M
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
}

/// Acquire, expose the actual two-fact memory, apply its reader, record.
/// The decoder does not receive the acquisition source or either channel.
public enum LocalEchoDecision<E: Pair, M: PredicateReading,
    D: PredicateReading>: Pair
where E.Left: Structure, E.Right: Structure,
      M.Left == E.Right, M.Answer: Structure,
      M.Sigma == BeamSpace, M.Encoding == SaturationEncoding,
      D.Left == Paired<M.Answer, EchoDecisionResources>,
      D.Sigma == BeamSpace, D.Encoding == SaturationEncoding {
    public typealias Run = StepBeside<E, EchoDecisionResources>
    public typealias Whole = FirstEvidenceImage<Run.Right, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Facts = SequentialReading<Whole, M>
    public typealias Resources = SecondEvidenceImage<Run.Right, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Observation = JointEvidence<Facts, Resources>
    public typealias Read = SequentialReading<Observation, D>
    public typealias Record = RecordReading<Read>
    public typealias Actual = FollowedPair<Run, Record>
    public typealias Left = Actual.Left
    public typealias Right = Actual.Right
    public enum RetainsWhole: Null {
        public typealias Left = LocalEchoDecision.Right.Left.Left
        public typealias Right = E.Right
    }
}
