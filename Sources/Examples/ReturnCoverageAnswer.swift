import VerificationIsIdentification

public typealias ThreeUnmatchedEchoes = AddressTriple<Paired<Never, Never>,
    Paired<Never, Never>, Paired<Never, Never>>
public typealias ReturnCoverageTable = BoundaryWorking<Paired<EchoEqual, EchoUndetermined>,
    Paired<EchoUndetermined, EchoUndetermined>, Paired<EchoUndetermined, EchoUndetermined>,
    Paired<EchoUndetermined, EchoUndetermined>>

/// The unresolved all-FF clause. TT and mismatched echoes already have
/// their local answers by M64h. This clause reads acquired target relations;
/// no generator or target label is an input. Its carrier bound is M64j's.
public enum UnmatchedReturnAnswer<F: HasVerdict & Structure,
    R: PredicateReading, S: PredicateReading>: PredicateReading
where F.Answer: Pair, F.Answer.Left == ThreeUnmatchedEchoes,
      F.Answer.Right: Pair, F.Answer.Right.Right: Pair,
      F.Answer.Right.Left: Structure, F.Answer.Right.Right.Left: Structure,
      F.Answer.Right.Right.Right: Structure,
      F.Sigma == BeamSpace, F.Encoding == SaturationEncoding,
      R.Left == Paired<Paired<F.Answer.Right.Left, F.Answer.Right.Right.Left>, ReturnCoverageTable>,
      R.Answer: Structure, S.Left == Paired<F.Answer.Right.Right.Right, R.Answer>,
      R.Sigma == BeamSpace, S.Sigma == BeamSpace,
      R.Encoding == SaturationEncoding, S.Encoding == SaturationEncoding {
    public typealias Left = Paired<F, ReturnCoverageTable>
    public typealias Fact = FirstEvidenceImage<Left, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Values = SequentialReading<Fact, ReadRecordedAnswer<F>>
    public typealias Relations = SequentialReading<Values,
        SecondEvidenceImage<F.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias C01 = SequentialReading<Relations,
        FirstEvidenceImage<Relations.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Tail = SequentialReading<Relations,
        SecondEvidenceImage<Relations.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias C02 = SequentialReading<Tail,
        FirstEvidenceImage<Tail.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias C12 = SequentialReading<Tail,
        SecondEvidenceImage<Tail.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Table = SecondEvidenceImage<Left, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Row = SequentialReading<JointEvidence<JointEvidence<C01, C02>, Table>, R>
    public typealias Actual = SequentialReading<JointEvidence<C12, Row>, S>
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
}

public enum ApplyReturnCoverage<E: Pair, D: PredicateReading>: Pair
where E.Left: Structure, E.Right: Pair, E.Right.Right: Structure,
      D.Left == Paired<E.Right.Right, ReturnCoverageTable>,
      D.Sigma == BeamSpace, D.Encoding == SaturationEncoding {
    public typealias Run = StepBeside<E, ReturnCoverageTable>
    public typealias Whole = FirstEvidenceImage<Run.Right, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Fact = SequentialReading<Whole,
        SecondEvidenceImage<E.Right, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Table = SecondEvidenceImage<Run.Right, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Observation = JointEvidence<Fact, Table>
    public typealias Read = SequentialReading<Observation, D>
    public typealias Record = RecordReading<Read>
    public typealias Actual = FollowedPair<Run, Record>
    public typealias Left = Actual.Left
    public typealias Right = Actual.Right
}
