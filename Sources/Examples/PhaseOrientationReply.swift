import VerificationIsIdentification

/// The directed triples (0,3,2), (2,0,3), (3,2,0), indexed by the three
/// acquired values in that order. All other cells are empty. This fixed
/// resource describes W's oriented orbit, not an unknown source's law.
public enum PhaseOrientationTable: Pair {
    public typealias Empty = BoundaryWorking<Never, Never, Never, Never>
    public typealias Row0 = BoundaryWorking<Empty, Empty, Empty, FourLeafPhaseMark2>
    public typealias Row1 = BoundaryWorking<Empty, Empty, Empty, Empty>
    public typealias Row2 = BoundaryWorking<FourLeafPhaseMark3, Empty, Empty, Empty>
    public typealias Row3 = BoundaryWorking<Empty, Empty, FourLeafPhaseMark0, Empty>
    public typealias Left = Paired<Row0, Row1>
    public typealias Right = Paired<Row2, Row3>
}

/// Three recorded answers address a fixed tensor. Only finite Route clauses
/// are used by the calibration; a named arbitrary reading is not certified.
public enum PhaseOrientationReply<M: Pair, R: PredicateReading,
    S: PredicateReading, T: PredicateReading>: PredicateReading
where M.Left: Pair, M.Left.Right: Pair, M.Right == PhaseOrientationTable,
      M.Left.Left: HasVerdict & Structure,
      M.Left.Right.Left: HasVerdict & Structure, M.Left.Right.Right: HasVerdict & Structure,
      M.Left.Left.Answer: Structure, M.Left.Right.Left.Answer: Structure,
      M.Left.Right.Right.Answer: Structure,
      M.Left.Left.Sigma == BeamSpace, M.Left.Right.Left.Sigma == BeamSpace,
      M.Left.Right.Right.Sigma == BeamSpace,
      M.Left.Left.Encoding == SaturationEncoding, M.Left.Right.Left.Encoding == SaturationEncoding,
      M.Left.Right.Right.Encoding == SaturationEncoding,
      R.Left == Paired<M.Left.Left.Answer, PhaseOrientationTable>, R.Answer: Structure,
      S.Left == Paired<M.Left.Right.Left.Answer, R.Answer>, S.Answer: Structure,
      T.Left == Paired<M.Left.Right.Right.Answer, S.Answer>,
      R.Sigma == BeamSpace, S.Sigma == BeamSpace, T.Sigma == BeamSpace,
      R.Encoding == SaturationEncoding, S.Encoding == SaturationEncoding, T.Encoding == SaturationEncoding {
    public typealias Facts = FirstEvidenceImage<M, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias F0 = SequentialReading<Facts,
        FirstEvidenceImage<M.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Tail = SequentialReading<Facts,
        SecondEvidenceImage<M.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias F1 = SequentialReading<Tail,
        FirstEvidenceImage<M.Left.Right, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias F2 = SequentialReading<Tail,
        SecondEvidenceImage<M.Left.Right, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias A0 = SequentialReading<F0, ReadRecordedAnswer<M.Left.Left>>
    public typealias A1 = SequentialReading<F1, ReadRecordedAnswer<M.Left.Right.Left>>
    public typealias A2 = SequentialReading<F2, ReadRecordedAnswer<M.Left.Right.Right>>
    public typealias Resource = SecondEvidenceImage<M, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Slab = SequentialReading<JointEvidence<A0, Resource>, R>
    public typealias Row = SequentialReading<JointEvidence<A1, Slab>, S>
    public typealias Actual = SequentialReading<JointEvidence<A2, Row>, T>
    public typealias Left = M
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
}

/// The source returns before this verdict is recorded. The decoder sees
/// only facts and the resource that travelled beside the whole experiment.
public enum PhaseExcursionDecision<A: Structure, B: Structure,
    C: Structure, D: Structure, R: PredicateReading,
    S: PredicateReading, T: PredicateReading>: Pair
where R.Left == Paired<A, PhaseOrientationTable>, R.Answer: Structure,
      S.Left == Paired<D, R.Answer>, S.Answer: Structure,
      T.Left == Paired<C, S.Answer>,
      R.Sigma == BeamSpace, S.Sigma == BeamSpace, T.Sigma == BeamSpace,
      R.Encoding == SaturationEncoding, S.Encoding == SaturationEncoding, T.Encoding == SaturationEncoding {
    public typealias E = PhaseExcursionMemory<A, B, C, D, PhaseOrientationTable>
    public typealias Decode = PhaseOrientationReply<E.Read.Answer, R, S, T>
    public typealias Read = SequentialReading<E.Read, Decode>
    public typealias Record = RecordReading<Read>
    public typealias Actual = FollowedPair<E.Run, Record>
    public typealias Left = Actual.Left
    public typealias Right = Actual.Right
    public enum KeepsReturnedWhole: Null {
        public typealias Left = PhaseExcursionDecision.Right.Left
        public typealias Right = E.Run.Right
    }
}
