import VerificationIsIdentification

/// Read one fixed port, perform the actual supplied source change, and read
/// the same port again. The second fact belongs to the reached source.
public enum RepeatedPhaseProbe<C: Pair>: Pair
where C.Left: Pair, C.Left.Left: Pair, C.Right: Pair, C.Right.Left: Pair {
    public typealias First = RecordReading<PhaseLawProbe0<C.Left>>
    public typealias Move = StepBeside<C, First.Right.Right>
    public typealias Second = RecordReading<PhaseLawProbe0<C.Right>>
    public typealias Finish = StepBeside<Second, First.Right.Right>
    public typealias Path = FollowedPair<FollowedPair<First, Move>, Finish>
    public typealias Left = C.Left
    public typealias Right = Paired<Second.Right, First.Right.Right>
    public enum Endpoint: Null {
        public typealias Left = Path.Right
        public typealias Right = RepeatedPhaseProbe.Right
    }
}

/// The partner relation is the actual Z action on the four singleton rows.
/// No unknown source or chosen answer is part of this fixed resource.
public typealias PhasePartnerTable = FourLeafShortPhaseWord<
    FourLeafPhaseMark0, FourLeafPhaseMark1,
    FourLeafPhaseMark2, FourLeafPhaseMark3>.Right

/// On a point table r, the actual input exchange produces r composed with Z.
/// Thus the same port acquires r(0), then r(1), while the current table changes.
public enum PartnerProbe<A: Structure, B: Structure,
    C: Structure, D: Structure>: Close {
    public typealias Change = FourLeafShortPhaseWord<A, B, C, D>
    public typealias Trace = RepeatedPhaseProbe<Change>
    public typealias Run = StepBeside<Trace, PhasePartnerTable>
    public typealias Memory = RetainedJointReplyMemory<Run.Right>
    public enum Replies: Null {
        public typealias Left = Paired<Memory.Answer.Left.Left.Answer,
            Memory.Answer.Left.Right.Answer>
        public typealias Right = Paired<A, B>
    }
    public enum CurrentTable: Null {
        public typealias Left = Run.Right.Left.Left.Left
        public typealias Right = BoundaryWorking<B, A, D, C>
    }
}

/// Two actual recorded answers select a row and cell of the fixed partner
/// resource. R and C are the existing finite Route projections in the
/// calibration; arbitrary PredicateReading conformance does not prove meaning.
public enum PartnerReply<M: Pair, R: PredicateReading,
    C: PredicateReading>: PredicateReading
where M.Left: Pair, M.Right == PhasePartnerTable,
      M.Left.Left: HasVerdict & Structure, M.Left.Right: HasVerdict & Structure,
      M.Left.Left.Answer: Structure, M.Left.Right.Answer: Structure,
      M.Left.Left.Sigma == BeamSpace, M.Left.Right.Sigma == BeamSpace,
      M.Left.Left.Encoding == SaturationEncoding, M.Left.Right.Encoding == SaturationEncoding,
      R.Left == Paired<M.Left.Left.Answer, PhasePartnerTable>, R.Answer: Structure,
      C.Left == Paired<M.Left.Right.Answer, R.Answer>,
      R.Sigma == BeamSpace, C.Sigma == BeamSpace,
      R.Encoding == SaturationEncoding, C.Encoding == SaturationEncoding {
    public typealias Facts = FirstEvidenceImage<M, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Old = SequentialReading<Facts,
        FirstEvidenceImage<M.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias New = SequentialReading<Facts,
        SecondEvidenceImage<M.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias FirstAnswer = SequentialReading<Old, ReadRecordedAnswer<M.Left.Left>>
    public typealias SecondAnswer = SequentialReading<New, ReadRecordedAnswer<M.Left.Right>>
    public typealias Table = SecondEvidenceImage<M, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Row = SequentialReading<JointEvidence<FirstAnswer, Table>, R>
    public typealias Actual = SequentialReading<JointEvidence<SecondAnswer, Row>, C>
    public typealias Left = M
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
}

/// The conclusion is produced from the two acquired records. It is then
/// retained beside the complete changed source and those records.
public enum PartnerDecision<A: Structure, B: Structure, C: Structure,
    D: Structure, R: PredicateReading, L: PredicateReading>: Pair
where R.Left == Paired<A, PhasePartnerTable>, R.Answer: Structure,
      L.Left == Paired<B, R.Answer>,
      R.Sigma == BeamSpace, L.Sigma == BeamSpace,
      R.Encoding == SaturationEncoding, L.Encoding == SaturationEncoding {
    public typealias Probe = PartnerProbe<A, B, C, D>
    public typealias Decode = PartnerReply<Probe.Memory.Answer, R, L>
    public typealias Read = SequentialReading<Probe.Memory, Decode>
    public typealias Record = RecordReading<Read>
    public typealias Actual = FollowedPair<Probe.Run, Record>
    public typealias Left = Actual.Left
    public typealias Right = Actual.Right
    public enum RetainsExperiment: Null {
        public typealias Left = PartnerDecision.Right.Left
        public typealias Right = Probe.Run.Right
    }
}

/// Independently ask the partner question of the current source. This is
/// the verifier's direct question, not an extra input granted to the decoder
/// or a claim that the actor performed two more acquisitions.
public enum CurrentPartnerReading<A: Structure, B: Structure,
    C: Structure, D: Structure, R: PredicateReading,
    L: PredicateReading>: PredicateReading
where R.Left == Paired<B, PhasePartnerTable>, R.Answer: Structure,
      L.Left == Paired<A, R.Answer>,
      R.Sigma == BeamSpace, L.Sigma == BeamSpace,
      R.Encoding == SaturationEncoding, L.Encoding == SaturationEncoding {
    public typealias Probe = PartnerProbe<A, B, C, D>
    public typealias Left = Probe.Run.Right
    public typealias Trace = FirstEvidenceImage<Left, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Now = SequentialReading<Trace,
        FirstEvidenceImage<Left.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Source = SequentialReading<Now,
        FirstEvidenceImage<Left.Left.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias First = SequentialReading<Source, PhaseLawProbe0<Source.Answer>>
    public typealias Second = SequentialReading<Source, PhaseLawProbe1<Source.Answer>>
    public typealias Table = SecondEvidenceImage<Left, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Row = SequentialReading<JointEvidence<First, Table>, R>
    public typealias Actual = SequentialReading<JointEvidence<Second, Row>, L>
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
}

public enum PartnerReplyCalibration<C: Structure, D: Structure>: Close {
    public typealias A0 = RoutingAddress00
    public typealias A1 = RoutingAddress01
    public typealias A2 = RoutingAddress10
    public typealias A3 = RoutingAddress11
    public typealias P01 = PartnerDecision<A0, A1, C, D, Route00<PhasePartnerTable>, Route01<FourLeafPhaseMark1>>
    public typealias P02 = PartnerDecision<A0, A2, C, D, Route00<PhasePartnerTable>, Route10<FourLeafPhaseMark1>>
    public typealias P03 = PartnerDecision<A0, A3, C, D, Route00<PhasePartnerTable>, Route11<FourLeafPhaseMark1>>
    public typealias P10 = PartnerDecision<A1, A0, C, D, Route01<PhasePartnerTable>, Route00<FourLeafPhaseMark0>>
    public typealias P12 = PartnerDecision<A1, A2, C, D, Route01<PhasePartnerTable>, Route10<FourLeafPhaseMark0>>
    public typealias P13 = PartnerDecision<A1, A3, C, D, Route01<PhasePartnerTable>, Route11<FourLeafPhaseMark0>>
    public typealias P20 = PartnerDecision<A2, A0, C, D, Route10<PhasePartnerTable>, Route00<FourLeafPhaseMark3>>
    public typealias P21 = PartnerDecision<A2, A1, C, D, Route10<PhasePartnerTable>, Route01<FourLeafPhaseMark3>>
    public typealias P23 = PartnerDecision<A2, A3, C, D, Route10<PhasePartnerTable>, Route11<FourLeafPhaseMark3>>
    public typealias P30 = PartnerDecision<A3, A0, C, D, Route11<PhasePartnerTable>, Route00<FourLeafPhaseMark2>>
    public typealias P31 = PartnerDecision<A3, A1, C, D, Route11<PhasePartnerTable>, Route01<FourLeafPhaseMark2>>
    public typealias P32 = PartnerDecision<A3, A2, C, D, Route11<PhasePartnerTable>, Route10<FourLeafPhaseMark2>>
    public typealias Q01 = CurrentPartnerReading<A0, A1, C, D, Route01<PhasePartnerTable>, Route00<FourLeafPhaseMark0>>
    public typealias Q02 = CurrentPartnerReading<A0, A2, C, D, Route10<PhasePartnerTable>, Route00<FourLeafPhaseMark3>>
    public typealias Q03 = CurrentPartnerReading<A0, A3, C, D, Route11<PhasePartnerTable>, Route00<FourLeafPhaseMark2>>
    public typealias Q10 = CurrentPartnerReading<A1, A0, C, D, Route00<PhasePartnerTable>, Route01<FourLeafPhaseMark1>>
    public typealias Q12 = CurrentPartnerReading<A1, A2, C, D, Route10<PhasePartnerTable>, Route01<FourLeafPhaseMark3>>
    public typealias Q13 = CurrentPartnerReading<A1, A3, C, D, Route11<PhasePartnerTable>, Route01<FourLeafPhaseMark2>>
    public typealias Q20 = CurrentPartnerReading<A2, A0, C, D, Route00<PhasePartnerTable>, Route10<FourLeafPhaseMark1>>
    public typealias Q21 = CurrentPartnerReading<A2, A1, C, D, Route01<PhasePartnerTable>, Route10<FourLeafPhaseMark0>>
    public typealias Q23 = CurrentPartnerReading<A2, A3, C, D, Route11<PhasePartnerTable>, Route10<FourLeafPhaseMark2>>
    public typealias Q30 = CurrentPartnerReading<A3, A0, C, D, Route00<PhasePartnerTable>, Route11<FourLeafPhaseMark1>>
    public typealias Q31 = CurrentPartnerReading<A3, A1, C, D, Route01<PhasePartnerTable>, Route11<FourLeafPhaseMark0>>
    public typealias Q32 = CurrentPartnerReading<A3, A2, C, D, Route10<PhasePartnerTable>, Route11<FourLeafPhaseMark3>>
}

public enum PartnerAcquiredVerdicts<C: Structure, D: Structure>: Null {
    public typealias T = PartnerReplyCalibration<C, D>
    public typealias Left = BoundaryWorking<
        AddressTriple<T.P01.Read.Answer, T.P02.Read.Answer, T.P03.Read.Answer>,
        AddressTriple<T.P10.Read.Answer, T.P12.Read.Answer, T.P13.Read.Answer>,
        AddressTriple<T.P20.Read.Answer, T.P21.Read.Answer, T.P23.Read.Answer>,
        AddressTriple<T.P30.Read.Answer, T.P31.Read.Answer, T.P32.Read.Answer>>
    public typealias YesFirst = AddressTriple<Lit1, Never, Never>
    public typealias YesLast = AddressTriple<Never, Never, Lit1>
    public typealias Right = BoundaryWorking<YesFirst, YesFirst, YesLast, YesLast>
}

public enum PartnerVerdictAnswersCurrentSource<C: Structure, D: Structure>: Null {
    public typealias T = PartnerReplyCalibration<C, D>
    public typealias Left = BoundaryWorking<
        AddressTriple<T.P01.Read.Answer, T.P02.Read.Answer, T.P03.Read.Answer>,
        AddressTriple<T.P10.Read.Answer, T.P12.Read.Answer, T.P13.Read.Answer>,
        AddressTriple<T.P20.Read.Answer, T.P21.Read.Answer, T.P23.Read.Answer>,
        AddressTriple<T.P30.Read.Answer, T.P31.Read.Answer, T.P32.Read.Answer>>
    public typealias Right = BoundaryWorking<
        AddressTriple<T.Q01.Answer, T.Q02.Answer, T.Q03.Answer>,
        AddressTriple<T.Q10.Answer, T.Q12.Answer, T.Q13.Answer>,
        AddressTriple<T.Q20.Answer, T.Q21.Answer, T.Q23.Answer>,
        AddressTriple<T.Q30.Answer, T.Q31.Answer, T.Q32.Answer>>
}

public enum PartnerMemoryOmitsUnmeasured<A: Structure, B: Structure,
    C: Structure, D: Structure, E: Structure, F: Structure>: Null {
    public typealias P = PartnerProbe<A, B, C, D>
    public typealias Q = PartnerProbe<A, B, E, F>
    public typealias Left = Paired<P.Memory.Answer, P.Memory.Predicate>
    public typealias Right = Paired<Q.Memory.Answer, Q.Memory.Predicate>
}
