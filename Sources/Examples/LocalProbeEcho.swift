import VerificationIsIdentification

/// Compare two readings of one actual source through its resident equality
/// table. The admitted comparison clauses are the existing finite Routes.
public enum CompareLocalReadings<A: PredicateReading, B: PredicateReading,
    T: PredicateReading, R: PredicateReading, S: PredicateReading>: PredicateReading
where A.Left == B.Left, A.Left == T.Left,
      A.Answer: Structure, B.Answer: Structure, T.Answer == PhaseEqualityTable,
      A.Sigma == BeamSpace, B.Sigma == BeamSpace, T.Sigma == BeamSpace,
      A.Encoding == SaturationEncoding, B.Encoding == SaturationEncoding,
      T.Encoding == SaturationEncoding,
      R.Left == Paired<A.Answer, PhaseEqualityTable>, R.Answer: Structure,
      S.Left == Paired<B.Answer, R.Answer>,
      R.Sigma == BeamSpace, S.Sigma == BeamSpace,
      R.Encoding == SaturationEncoding, S.Encoding == SaturationEncoding {
    public typealias Row = SequentialReading<JointEvidence<A, T>, R>
    public typealias Actual = SequentialReading<JointEvidence<B, Row>, S>
    public typealias Left = A.Left
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
}

/// Continue a PairedProbeInFrame-shaped acquisition with two actual return
/// readings through one resident D. Compare each return with its retained
/// original probe reply. Neither return is required to succeed.
///
/// Source sharing alone does not certify arbitrary F/G conformances as one
/// function. The finite experiments instantiate both with Route clauses on D.
public enum LocalProbeEcho<E: Pair, D: Structure,
    F: PredicateReading, G: PredicateReading,
    R: PredicateReading, S: PredicateReading,
    T: PredicateReading, U: PredicateReading>: Pair
where E.Left: Structure, E.Right: Pair,
      E.Right.Left: Pair, E.Right.Left.Left: Pair,
      E.Right.Left.Left.Left: Pair, E.Right.Left.Left.Right: Pair,
      E.Right.Left.Left.Left.Right: HasVerdict & Structure,
      E.Right.Left.Left.Right.Right: HasVerdict & Structure,
      E.Right.Left.Left.Left.Right.Answer: Structure,
      E.Right.Left.Left.Right.Right.Answer: Structure,
      E.Right.Left.Left.Left.Right.Sigma == BeamSpace,
      E.Right.Left.Left.Right.Right.Sigma == BeamSpace,
      E.Right.Left.Left.Left.Right.Encoding == SaturationEncoding,
      E.Right.Left.Left.Right.Right.Encoding == SaturationEncoding,
      E.Right.Right: HasVerdict & Structure, E.Right.Right.Answer: Pair,
      E.Right.Right.Answer.Left: Structure, E.Right.Right.Answer.Right: Structure,
      E.Right.Right.Sigma == BeamSpace, E.Right.Right.Encoding == SaturationEncoding,
      F.Left == Paired<E.Right.Right.Answer.Left, D>,
      G.Left == Paired<E.Right.Right.Answer.Right, D>,
      F.Answer: Structure, G.Answer: Structure,
      F.Sigma == BeamSpace, G.Sigma == BeamSpace,
      F.Encoding == SaturationEncoding, G.Encoding == SaturationEncoding,
      R.Left == Paired<E.Right.Left.Left.Left.Right.Answer, PhaseEqualityTable>,
      R.Answer: Structure, S.Left == Paired<F.Answer, R.Answer>, S.Answer: Structure,
      T.Left == Paired<E.Right.Left.Left.Right.Right.Answer, PhaseEqualityTable>,
      T.Answer: Structure, U.Left == Paired<G.Answer, T.Answer>, U.Answer: Structure,
      R.Sigma == BeamSpace, S.Sigma == BeamSpace, T.Sigma == BeamSpace, U.Sigma == BeamSpace,
      R.Encoding == SaturationEncoding, S.Encoding == SaturationEncoding,
      T.Encoding == SaturationEncoding, U.Encoding == SaturationEncoding {
    public typealias Run = StepBeside<E, Paired<D, PhaseEqualityTable>>
    public typealias Prior = FirstEvidenceImage<Run.Right, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Earlier = SequentialReading<Prior,
        FirstEvidenceImage<E.Right, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Probes = SequentialReading<Earlier,
        FirstEvidenceImage<E.Right.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias FirstProbe = SequentialReading<Probes,
        FirstEvidenceImage<E.Right.Left.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias SecondProbe = SequentialReading<Probes,
        SecondEvidenceImage<E.Right.Left.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias FirstFact = SequentialReading<FirstProbe,
        SecondEvidenceImage<FirstProbe.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias SecondFact = SequentialReading<SecondProbe,
        SecondEvidenceImage<SecondProbe.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias RawA = SequentialReading<FirstFact, ReadRecordedAnswer<FirstFact.Answer>>
    public typealias RawB = SequentialReading<SecondFact, ReadRecordedAnswer<SecondFact.Answer>>
    public typealias ForwardFact = SequentialReading<Prior,
        SecondEvidenceImage<E.Right, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Encoded = SequentialReading<ForwardFact, ReadRecordedAnswer<E.Right.Right>>
    public typealias EncodedA = SequentialReading<Encoded,
        FirstEvidenceImage<Encoded.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias EncodedB = SequentialReading<Encoded,
        SecondEvidenceImage<Encoded.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Resources = SecondEvidenceImage<Run.Right, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias ReturnFrame = SequentialReading<Resources,
        FirstEvidenceImage<Resources.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Equality = SequentialReading<Resources,
        SecondEvidenceImage<Resources.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias ReturnA = SequentialReading<JointEvidence<EncodedA, ReturnFrame>, F>
    public typealias ReturnB = SequentialReading<JointEvidence<EncodedB, ReturnFrame>, G>
    public typealias FirstEcho = CompareLocalReadings<RawA, ReturnA, Equality, R, S>
    public typealias SecondEcho = CompareLocalReadings<RawB, ReturnB, Equality, T, U>
    public typealias Echoes = JointEvidence<FirstEcho, SecondEcho>
    public typealias Record = RecordReading<Echoes>
    public typealias Actual = FollowedPair<Run, Record>
    public typealias Left = Run.Left
    public typealias Right = Record.Right

    public typealias Retained = FirstEvidenceImage<Right, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias AvailableForward = SequentialReading<Retained, ForwardFact>
    public typealias AvailableEcho = SecondEvidenceImage<Right, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Memory = JointEvidence<AvailableForward, AvailableEcho>
    public enum AcquiredMemory: Null {
        public typealias Left = Memory.Answer
        public typealias Right = Paired<E.Right.Right, FactOf<Echoes>>
    }
    public enum KeepsAcquisition: Null {
        public typealias Left = LocalProbeEcho.Right.Left.Left
        public typealias Right = E.Right
    }
}
