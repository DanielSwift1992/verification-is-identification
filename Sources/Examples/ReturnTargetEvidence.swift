import VerificationIsIdentification

/// Each private fact records (paired echo bits, actual target value) before
/// that value changes. Read those acquired values, never reconstruct them
/// from a proposed generator law. W also carries the comparison resource.
public enum SavedReturnTargets<W: Pair>: Close
where W.Right == PhaseEqualityTable,
      W.Left: Pair, W.Left.Left: Pair, W.Left.Left.Left: Pair,
      W.Left.Right: HasVerdict & Structure,
      W.Left.Left.Right: HasVerdict & Structure,
      W.Left.Left.Left.Right: HasVerdict & Structure,
      W.Left.Right.Answer: Pair, W.Left.Left.Right.Answer: Pair,
      W.Left.Left.Left.Right.Answer: Pair,
      W.Left.Right.Answer.Left: Structure, W.Left.Right.Answer.Right: Structure,
      W.Left.Left.Right.Answer.Left: Structure, W.Left.Left.Right.Answer.Right: Structure,
      W.Left.Left.Left.Right.Answer.Left: Structure, W.Left.Left.Left.Right.Answer.Right: Structure,
      W.Left.Right.Sigma == BeamSpace, W.Left.Left.Right.Sigma == BeamSpace,
      W.Left.Left.Left.Right.Sigma == BeamSpace,
      W.Left.Right.Encoding == SaturationEncoding, W.Left.Left.Right.Encoding == SaturationEncoding,
      W.Left.Left.Left.Right.Encoding == SaturationEncoding {
    public typealias Facts = ThreeStageFacts<W>
    public typealias F0 = SequentialReading<Facts,
        FirstEvidenceImage<Facts.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Tail = SequentialReading<Facts,
        SecondEvidenceImage<Facts.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias F1 = SequentialReading<Tail,
        FirstEvidenceImage<Tail.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias F2 = SequentialReading<Tail,
        SecondEvidenceImage<Tail.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias P0 = SequentialReading<F0, ReadRecordedAnswer<F0.Answer>>
    public typealias P1 = SequentialReading<F1, ReadRecordedAnswer<F1.Answer>>
    public typealias P2 = SequentialReading<F2, ReadRecordedAnswer<F2.Answer>>
    public typealias T0 = SequentialReading<P0,
        SecondEvidenceImage<P0.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias T1 = SequentialReading<P1,
        SecondEvidenceImage<P1.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias T2 = SequentialReading<P2,
        SecondEvidenceImage<P2.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias E0 = SequentialReading<P0,
        FirstEvidenceImage<P0.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias E1 = SequentialReading<P1,
        FirstEvidenceImage<P1.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias E2 = SequentialReading<P2,
        FirstEvidenceImage<P2.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Echoes = JointEvidence<E0, JointEvidence<E1, E2>>
    public typealias Targets = JointEvidence<T0, JointEvidence<T1, T2>>
    public typealias Equality = SecondEvidenceImage<W, BeamSpace, SaturationEncoding, SecondProjection>
}

/// Acquire three comparisons of the recorded targets, then transmit only
/// echo bits and comparison bits. Absolute target values stay in the whole.
public enum AcquireReturnCoverage<E: Pair, A: PredicateReading,
    B: PredicateReading, C: PredicateReading, D: PredicateReading,
    F: PredicateReading, G: PredicateReading>: Pair
where E.Left: Structure, E.Right: Pair, E.Right.Left: Pair, E.Right.Left.Left: Pair,
      E.Right.Right: HasVerdict & Structure,
      E.Right.Left.Right: HasVerdict & Structure, E.Right.Left.Left.Right: HasVerdict & Structure,
      E.Right.Right.Answer: Pair, E.Right.Left.Right.Answer: Pair,
      E.Right.Left.Left.Right.Answer: Pair,
      E.Right.Right.Answer.Left: Structure, E.Right.Right.Answer.Right: Structure,
      E.Right.Left.Right.Answer.Left: Structure, E.Right.Left.Right.Answer.Right: Structure,
      E.Right.Left.Left.Right.Answer.Left: Structure, E.Right.Left.Left.Right.Answer.Right: Structure,
      E.Right.Right.Sigma == BeamSpace, E.Right.Left.Right.Sigma == BeamSpace,
      E.Right.Left.Left.Right.Sigma == BeamSpace,
      E.Right.Right.Encoding == SaturationEncoding, E.Right.Left.Right.Encoding == SaturationEncoding,
      E.Right.Left.Left.Right.Encoding == SaturationEncoding,
      A.Left == Paired<E.Right.Right.Answer.Right, PhaseEqualityTable>, A.Answer: Structure,
      B.Left == Paired<E.Right.Left.Right.Answer.Right, A.Answer>, B.Answer: Structure,
      C.Left == Paired<E.Right.Right.Answer.Right, PhaseEqualityTable>, C.Answer: Structure,
      D.Left == Paired<E.Right.Left.Left.Right.Answer.Right, C.Answer>, D.Answer: Structure,
      F.Left == Paired<E.Right.Left.Right.Answer.Right, PhaseEqualityTable>, F.Answer: Structure,
      G.Left == Paired<E.Right.Left.Left.Right.Answer.Right, F.Answer>, G.Answer: Structure,
      A.Sigma == BeamSpace, B.Sigma == BeamSpace, C.Sigma == BeamSpace,
      D.Sigma == BeamSpace, F.Sigma == BeamSpace, G.Sigma == BeamSpace,
      A.Encoding == SaturationEncoding, B.Encoding == SaturationEncoding, C.Encoding == SaturationEncoding,
      D.Encoding == SaturationEncoding, F.Encoding == SaturationEncoding, G.Encoding == SaturationEncoding {
    public typealias Run = StepBeside<E, PhaseEqualityTable>
    public typealias Samples = SavedReturnTargets<Run.Right>
    public typealias C01 = CompareLocalReadings<Samples.T0, Samples.T1, Samples.Equality, A, B>
    public typealias C02 = CompareLocalReadings<Samples.T0, Samples.T2, Samples.Equality, C, D>
    public typealias C12 = CompareLocalReadings<Samples.T1, Samples.T2, Samples.Equality, F, G>
    public typealias Contacts = JointEvidence<C01, JointEvidence<C02, C12>>
    public typealias Record = RecordReading<Contacts>
    public typealias Prefix = FollowedPair<Run, Record>
    public typealias Retained = FirstEvidenceImage<Record.Right, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Echoes = SequentialReading<Retained, Samples.Echoes>
    public typealias ComparisonFact = SecondEvidenceImage<Record.Right, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Comparisons = SequentialReading<ComparisonFact, ReadRecordedAnswer<Record.Right.Right>>
    public typealias Visible = JointEvidence<Echoes, Comparisons>
    public typealias Transmit = RecordReading<Visible>
    public typealias Actual = FollowedPair<Prefix, Transmit>
    public typealias Left = Run.Left
    public typealias Right = Transmit.Right
    public enum KeepsPrivateRecords: Null {
        public typealias Left = AcquireReturnCoverage.Right.Left.Left.Left
        public typealias Right = E.Right
    }
}
