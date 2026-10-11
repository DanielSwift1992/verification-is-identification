import VerificationIsIdentification
import Examples

enum UnequalEncodedEcho: Close {
    typealias C = PairedProbeCalibration
    typealias E = LocalProbeEcho<C.E01, C.Frame, Route00<C.Frame>, Route01<C.Frame>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route01<PhaseEqualityTable>, Route01<FourLeafPhaseMark1>>
    typealias A = LocalEchoAnswer<Paired<E.Memory.Answer, EchoDecisionResources>,
        Route00<PhaseEqualityTable>, Route01<FourLeafPhaseMark0>,
        Route11<EchoCompletionTable>, LocalPolicyAtZero<Paired<EchoDifferent, EchoEqual>>>
    typealias Q = LocalEchoDecision<E, E.Memory, A>
}

// These two compositions read DIFFERENT resident return tables. They are
// outside the single-table Route grammar of M64h. One common container
// holding both tables does not make them a common return function.
enum SplitEchoReturn: Close {
    typealias D0 = BoundaryWorking<RoutingAddress00, RoutingAddress00,
        RoutingAddress00, RoutingAddress00>
    typealias D2 = BoundaryWorking<RoutingAddress10, RoutingAddress10,
        RoutingAddress10, RoutingAddress10>
    typealias Input = Paired<RoutingAddress00, Paired<D0, D2>>
    typealias Address = FirstEvidenceImage<Input, BeamSpace, SaturationEncoding, FirstProjection>
    typealias Maps = SecondEvidenceImage<Input, BeamSpace, SaturationEncoding, SecondProjection>
    typealias Map0 = SequentialReading<Maps,
        FirstEvidenceImage<Maps.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    typealias Map2 = SequentialReading<Maps,
        SecondEvidenceImage<Maps.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    typealias First = SequentialReading<JointEvidence<Address, Map0>, Route00<D0>>
    typealias Second = SequentialReading<JointEvidence<Address, Map2>, Route00<D2>>
    typealias C = LocalEchoCalibration
    typealias E = LocalProbeEcho<C.F02, Paired<D0, D2>, First, Second,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route10<PhaseEqualityTable>, Route10<FourLeafPhaseMark2>>
    typealias A = LocalEchoAnswer<Paired<E.Memory.Answer, EchoDecisionResources>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route11<EchoCompletionTable>, LocalPolicyAtOne<Paired<EchoDifferent, EchoEqual>>>
    typealias Q = LocalEchoDecision<E, E.Memory, A>
}

#if !LOCAL_PHASE_ECHO_UNKNOWN_IS_FALSE && !LOCAL_PHASE_ECHO_UNKNOWN_IS_TRUE && !LOCAL_PHASE_ECHO_SPLIT_RETURN && !LOCAL_PHASE_ECHO_GLOBAL_RECOVERY
enum LocalEchoAcquisitionResults: Null {
    typealias C = LocalEchoCalibration
    typealias Left = AddressTriple<C.Answers.Left, C.EchoesWereAcquired.Left,
        Paired<C.SameUndeterminedMemory.Left, C.SourcesBehindThatMemory.Left>>
    typealias Right = AddressTriple<C.Answers.Right, C.EchoesWereAcquired.Right,
        Paired<C.SameUndeterminedMemory.Right, C.SourcesBehindThatMemory.Right>>
}

enum LocalEchoPositiveDoesNotCalibrateTheMaps: Null {
    typealias C = LocalEchoCalibration
    typealias Left = C.SamePositiveMemory.Left
    typealias Right = C.SamePositiveMemory.Right
}

enum LocalEchoUnresolvedHasBothActualAnswers: Null {
    typealias C = LocalEchoCalibration
    typealias B = PairedProbeCalibration
    typealias Left = AddressTriple<Paired<C.F11.Probes.Left, C.F12.Probes.Left>,
        Paired<B.D11.Read.Answer, B.D12.Read.Answer>,
        Paired<C.Q11.Read.Answer, C.Q12.Read.Answer>>
    typealias Right = AddressTriple<Paired<B.E11.Probes.Left, B.E12.Probes.Left>,
        Paired<Lit1, Never>, Paired<EchoUndetermined, EchoUndetermined>>
}

enum LocalEchoDifferentEncodedReplies: Null {
    typealias E = UnequalEncodedEcho
    typealias Left = Paired<E.E.Echoes.Answer, E.Q.Read.Answer>
    typealias Right = Paired<Paired<Lit1, Lit1>, EchoDifferent>
}

enum LocalEchoSplitReturnsReallySucceed: Null {
    typealias E = SplitEchoReturn.E
    typealias Left = AddressTriple<E.Encoded.Answer, E.Echoes.Answer,
        Paired<E.RawA.Answer, E.RawB.Answer>>
    typealias Right = AddressTriple<Paired<RoutingAddress00, RoutingAddress00>,
        Paired<Lit1, Lit1>, Paired<RoutingAddress00, RoutingAddress10>>
}

enum LocalEchoRetainsTheLaboratory<K: Structure>: Null {
    typealias E = StepBeside<LocalEchoCalibration.Q00, K>
    typealias Left = Paired<E.Right.Right, E.Right.Left.Left.Left.Left.Left>
    typealias Right = Paired<K, LocalEchoCalibration.F00.Right>
}
#endif

// Same acquired input allows a true source and a false source. Neither
// singleton answer may replace the two remaining possibilities.
#if LOCAL_PHASE_ECHO_UNKNOWN_IS_FALSE
enum RejectedEchoUnknownIsFalse: Null {
    typealias Left = LocalEchoCalibration.Q11.Read.Answer
    typealias Right = EchoDifferent
}
#endif

#if LOCAL_PHASE_ECHO_UNKNOWN_IS_TRUE
enum RejectedEchoUnknownIsTrue: Null {
    typealias Left = LocalEchoCalibration.Q12.Read.Answer
    typealias Right = EchoEqual
}
#endif

// The mechanical table yields "equal" outside its common-return scope.
// Actual underlying replies are 0,2, whose equality is already acquired
// canonically by the previous construction, independently of this table.
#if LOCAL_PHASE_ECHO_SPLIT_RETURN
enum RejectedEchoSplitReturn: Null {
    typealias Left = SplitEchoReturn.Q.Read.Answer.Right
    typealias Right = PairedProbeCalibration.D02.Read.Answer
}
#endif

// Local success at 0 does not recover an untested input 1 through d(c(1)).
#if LOCAL_PHASE_ECHO_GLOBAL_RECOVERY
enum RejectedEchoGlobalRecovery: Null {
    typealias C = LocalEchoCalibration
    typealias Forward = Route01<C.C>
    typealias Return = Route00<C.D>
    typealias Outward = StepBeside<Forward, C.D>
    typealias Actual = FollowedPair<Outward, Return>
    typealias Left = Actual.Right
    typealias Right = Outward.Left.Left.Left
}
#endif
