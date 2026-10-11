import VerificationIsIdentification

public enum ReturnCoverageCalibration: Close {
    public typealias O = EchoOrbitCalibration
    public typealias C = FourReturnCycle.Table
    public typealias FullRounds = ThreeEchoRounds<
        JointEvidence<O.R33_0.Echo, O.R33_0.Value>,
        JointEvidence<O.R33_1.Echo, O.R33_1.Value>,
        JointEvidence<O.R33_2.Echo, O.R33_2.Value>, O.R33_0.Advance, O.R33_1.Advance>
    public typealias FullPath = FollowedPair<O.S33, FullRounds>
    public typealias Full = AcquireReturnCoverage<FullPath,
        Route00<PhaseEqualityTable>, Route01<FourLeafPhaseMark0>,
        Route00<PhaseEqualityTable>, Route10<FourLeafPhaseMark0>,
        Route01<PhaseEqualityTable>, Route10<FourLeafPhaseMark1>>
    public typealias FullAnswer = UnmatchedReturnAnswer<Full.Right.Right,
        Route00<ReturnCoverageTable>, LocalPolicyAtZero<Paired<EchoEqual, EchoUndetermined>>>
    public typealias FullDecision = ApplyReturnCoverage<Full, FullAnswer>

    // The second generator ignores its current value and reads the last
    // table field, 0. This actually breaks the proposed single-U traversal.
    public typealias ResetInput = Paired<RoutingAddress01, C>
    public typealias ResetTable = SecondEvidenceImage<ResetInput, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias ResetHalf = SequentialReading<ResetTable,
        SecondEvidenceImage<C, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Reset = SequentialReading<ResetHalf,
        SecondEvidenceImage<C.Right, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Host22 = LocalEchoCalibration.E22
    public typealias Mid22 = EchoOrbitRound<Host22.RawA, Host22.RawB, Host22.Equality,
        RoutingAddress01, C, Reset, Route10<PhaseEqualityTable>, Route01<FourLeafPhaseMark2>,
        Route10<PhaseEqualityTable>, Route01<FourLeafPhaseMark2>>
    public typealias RepeatRounds22 = ThreeEchoRounds<
        JointEvidence<O.R22_0.Echo, O.R22_0.Value>,
        JointEvidence<Mid22.Echo, Mid22.Value>,
        JointEvidence<O.R22_0.Echo, O.R22_0.Value>, O.R22_0.Advance, Mid22.Advance>
    public typealias RepeatPath22 = FollowedPair<O.S22, RepeatRounds22>
    public typealias Repeat22 = AcquireReturnCoverage<RepeatPath22,
        Route00<PhaseEqualityTable>, Route01<FourLeafPhaseMark0>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route01<PhaseEqualityTable>, Route00<FourLeafPhaseMark1>>
    public typealias RepeatAnswer22 = UnmatchedReturnAnswer<Repeat22.Right.Right,
        Route01<ReturnCoverageTable>, LocalPolicyAtZero<Paired<EchoUndetermined, EchoUndetermined>>>
    public typealias RepeatDecision22 = ApplyReturnCoverage<Repeat22, RepeatAnswer22>
    public typealias Host23 = LocalEchoCalibration.E23
    public typealias Mid23 = EchoOrbitRound<Host23.RawA, Host23.RawB, Host23.Equality,
        RoutingAddress01, C, Reset, Route10<PhaseEqualityTable>, Route01<FourLeafPhaseMark2>,
        Route11<PhaseEqualityTable>, Route01<FourLeafPhaseMark3>>
    public typealias RepeatRounds23 = ThreeEchoRounds<
        JointEvidence<O.R23_0.Echo, O.R23_0.Value>,
        JointEvidence<Mid23.Echo, Mid23.Value>,
        JointEvidence<O.R23_0.Echo, O.R23_0.Value>, O.R23_0.Advance, Mid23.Advance>
    public typealias RepeatPath23 = FollowedPair<O.S23, RepeatRounds23>
    public typealias Repeat23 = AcquireReturnCoverage<RepeatPath23,
        Route00<PhaseEqualityTable>, Route01<FourLeafPhaseMark0>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route01<PhaseEqualityTable>, Route00<FourLeafPhaseMark1>>
    public typealias RepeatAnswer23 = UnmatchedReturnAnswer<Repeat23.Right.Right,
        Route01<ReturnCoverageTable>, LocalPolicyAtZero<Paired<EchoUndetermined, EchoUndetermined>>>
    public typealias RepeatDecision23 = ApplyReturnCoverage<Repeat23, RepeatAnswer23>
    public enum ObservedTargets: Null {
        public typealias Left = Paired<Full.Samples.Targets.Answer, Repeat23.Samples.Targets.Answer>
        public typealias Right = Paired<AddressTriple<RoutingAddress00, RoutingAddress01, RoutingAddress10>,
            AddressTriple<RoutingAddress00, RoutingAddress01, RoutingAddress00>>
    }
    public enum AcquiredTargetRelations: Null {
        public typealias Left = Paired<Full.Contacts.Answer, Repeat23.Contacts.Answer>
        public typealias Right = Paired<AddressTriple<Never, Never, Never>, AddressTriple<Never, Lit1, Never>>
    }
    public enum SameEchoBitsDifferentEvidence: Null {
        public typealias Left = Paired<Full.Echoes.Answer, Repeat23.Echoes.Answer>
        public typealias Right = Paired<ThreeUnmatchedEchoes, ThreeUnmatchedEchoes>
    }
    public enum RepetitionStillHasTwoSources: Null {
        public typealias Left = Repeat22.Right.Right
        public typealias Right = Repeat23.Right.Right
    }
    public enum Decisions: Null {
        public typealias Left = AddressTriple<FullDecision.Read.Answer,
            RepeatDecision22.Read.Answer, RepeatDecision23.Read.Answer>
        public typealias Right = AddressTriple<EchoEqual, EchoUndetermined, EchoUndetermined>
    }
}

/// Two different, non-injective generators produce targets 0,2,1. Their
/// actual target records establish enough coverage without a permutation law.
public enum ChangingReturnCoverage: Close {
    public typealias H = LocalEchoCalibration.E33
    public typealias To2 = BoundaryWorking<RoutingAddress10, RoutingAddress10,
        RoutingAddress10, RoutingAddress10>
    public typealias To1 = BoundaryWorking<RoutingAddress01, RoutingAddress01,
        RoutingAddress01, RoutingAddress01>
    public typealias Maps = Paired<To2, To1>
    public typealias FirstMap = PairedApplication<IdentityReading<RoutingAddress00, BeamSpace, SaturationEncoding>,
        FirstEvidenceImage<Maps, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Move0 = SequentialReading<FirstMap, Route00<To2>>
    public typealias SecondMap = PairedApplication<IdentityReading<RoutingAddress10, BeamSpace, SaturationEncoding>,
        SecondEvidenceImage<Maps, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Move1 = SequentialReading<SecondMap, Route10<To1>>
    public typealias ThirdMap = PairedApplication<IdentityReading<RoutingAddress01, BeamSpace, SaturationEncoding>,
        SecondEvidenceImage<Maps, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Move2 = SequentialReading<ThirdMap, Route01<To1>>
    public typealias Start = PrepareEchoOrbit<H.Run, H.ReturnA, Maps>
    public typealias R0 = EchoOrbitRound<H.RawA, H.RawB, H.Equality,
        RoutingAddress00, Maps, Move0, Route11<PhaseEqualityTable>, Route00<FourLeafPhaseMark3>,
        Route11<PhaseEqualityTable>, Route00<FourLeafPhaseMark3>>
    public typealias R1 = EchoOrbitRound<H.RawA, H.RawB, H.Equality,
        RoutingAddress10, Maps, Move1, Route11<PhaseEqualityTable>, Route10<FourLeafPhaseMark3>,
        Route11<PhaseEqualityTable>, Route10<FourLeafPhaseMark3>>
    public typealias R2 = EchoOrbitRound<H.RawA, H.RawB, H.Equality,
        RoutingAddress01, Maps, Move2, Route11<PhaseEqualityTable>, Route01<FourLeafPhaseMark3>,
        Route11<PhaseEqualityTable>, Route01<FourLeafPhaseMark3>>
    public typealias Rounds = ThreeEchoRounds<JointEvidence<R0.Echo, R0.Value>,
        JointEvidence<R1.Echo, R1.Value>, JointEvidence<R2.Echo, R2.Value>, R0.Advance, R1.Advance>
    public typealias Path = FollowedPair<Start, Rounds>
    public typealias Acquisition = AcquireReturnCoverage<Path,
        Route00<PhaseEqualityTable>, Route10<FourLeafPhaseMark0>,
        Route00<PhaseEqualityTable>, Route01<FourLeafPhaseMark0>,
        Route10<PhaseEqualityTable>, Route01<FourLeafPhaseMark2>>
    public typealias Answer = UnmatchedReturnAnswer<Acquisition.Right.Right,
        Route00<ReturnCoverageTable>, LocalPolicyAtZero<Paired<EchoEqual, EchoUndetermined>>>
    public typealias Decision = ApplyReturnCoverage<Acquisition, Answer>
    public enum SameAvailablePositiveRecord: Null {
        public typealias Left = Acquisition.Right.Right
        public typealias Right = ReturnCoverageCalibration.Full.Right.Right
    }
    public enum ActualTargetsAndAnswer: Null {
        public typealias Left = Paired<Acquisition.Samples.Targets.Answer, Decision.Read.Answer>
        public typealias Right = Paired<AddressTriple<RoutingAddress00, RoutingAddress10, RoutingAddress01>, EchoEqual>
    }
}
