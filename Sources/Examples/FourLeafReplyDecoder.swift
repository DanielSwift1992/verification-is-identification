import VerificationIsIdentification

/// The inverse of VC100a's two-image table. Entries are addresses in the
/// actual word catalogue. A diagonal entry is no address in that catalogue.
/// This fixed decoder resource contains all laws, not the source's chosen law.
public enum FourLeafReplyTable: Pair {
    public typealias Row0 = BoundaryWorking<Never, FourLeafLawAddresses.I,
        FourLeafLawAddresses.WZW, FourLeafLawAddresses.WWZWW>
    public typealias Row1 = BoundaryWorking<FourLeafLawAddresses.Z, Never,
        FourLeafLawAddresses.ZW, FourLeafLawAddresses.ZWW>
    public typealias Row2 = BoundaryWorking<FourLeafLawAddresses.WWZ,
        FourLeafLawAddresses.W, Never, FourLeafLawAddresses.WZWW>
    public typealias Row3 = BoundaryWorking<FourLeafLawAddresses.WZ,
        FourLeafLawAddresses.WW, FourLeafLawAddresses.WWZW, Never>
    public typealias Left = Paired<Row0, Row1>
    public typealias Right = Paired<Row2, Row3>
}

public enum FourLeafResidentLawQuestion: Close {}

/// The independently specified question reads the resident law at the final
/// whole: ((current world, current fact), fixed decoder resource).
/// The two-probe constructions establish how that whole was acquired.
public enum FourLeafCurrentLaw<W: Pair>: PredicateReading
where W.Left: Pair, W.Left.Left: Pair, W.Left.Left.Right: Pair,
      W.Left.Left.Right.Right: Pair, W.Left.Left.Right.Right.Right: Pair {
    public typealias Probe = FirstEvidenceImage<W, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias World = SequentialReading<Probe,
        FirstEvidenceImage<Probe.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Tail = SequentialReading<World,
        SecondEvidenceImage<World.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Context = SequentialReading<Tail,
        SecondEvidenceImage<Tail.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias LawFields = SequentialReading<Context,
        SecondEvidenceImage<Context.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Actual = SequentialReading<LawFields,
        FirstEvidenceImage<LawFields.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Left = W
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = FourLeafResidentLawQuestion
    public typealias Answer = Right
}

/// Decode only two recorded answers and the fixed table beside them. R reads
/// the row addressed by the first answer; C reads that row at the second.
/// The actual paths expose no source law, hidden phase or consumed word.
/// The named law question is justified by the twelve acquisition factors,
/// not by this conformance alone or by an equality requested from its caller.
public enum FourLeafReplyDecoder<M: Pair, R: PredicateReading,
                                 C: PredicateReading>: PredicateReading
where M.Left: Pair, M.Right == FourLeafReplyTable,
      M.Left.Left: HasVerdict & Structure, M.Left.Right: HasVerdict & Structure,
      M.Left.Left.Answer: Structure, M.Left.Right.Answer: Structure,
      M.Left.Left.Sigma == BeamSpace, M.Left.Right.Sigma == BeamSpace,
      M.Left.Left.Encoding == SaturationEncoding, M.Left.Right.Encoding == SaturationEncoding,
      R.Left == Paired<M.Left.Left.Answer, FourLeafReplyTable>, R.Answer: Structure,
      C.Left == Paired<M.Left.Right.Answer, R.Answer>,
      R.Sigma == BeamSpace, C.Sigma == BeamSpace,
      R.Encoding == SaturationEncoding, C.Encoding == SaturationEncoding {
    public typealias Facts = FirstEvidenceImage<M, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias FirstFact = SequentialReading<Facts,
        FirstEvidenceImage<Facts.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias SecondFact = SequentialReading<Facts,
        SecondEvidenceImage<Facts.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias FirstAnswer = SequentialReading<FirstFact, ReadRecordedAnswer<M.Left.Left>>
    public typealias SecondAnswer = SequentialReading<SecondFact, ReadRecordedAnswer<M.Left.Right>>
    public typealias Table = SecondEvidenceImage<M, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias RowInput = JointEvidence<FirstAnswer, Table>
    public typealias Row = SequentialReading<RowInput, R>
    public typealias CellInput = JointEvidence<SecondAnswer, Row>
    public typealias Actual = SequentialReading<CellInput, C>
    public typealias Left = M
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = FourLeafResidentLawQuestion
    public typealias Answer = Right
}
