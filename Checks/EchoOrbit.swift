import VerificationIsIdentification
import Examples

// A real short orbit 0,1,0 leaves both 2 and 3 untested. The original
// paired probes run once and their actual records are kept throughout.
enum IncompleteEchoOrbit: Close {
    typealias H = LocalEchoCalibration.E23
    typealias C = FourLeafPhase0<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11>.Right
    typealias Start = PrepareEchoOrbit<H.Run, H.ReturnA, C>
    typealias R0 = EchoOrbitRound<H.RawA, H.RawB, H.Equality,
        RoutingAddress00, C, Route00<C>,
        Route10<PhaseEqualityTable>, Route00<FourLeafPhaseMark2>,
        Route11<PhaseEqualityTable>, Route00<FourLeafPhaseMark3>>
    typealias R1 = EchoOrbitRound<H.RawA, H.RawB, H.Equality,
        RoutingAddress01, C, Route01<C>,
        Route10<PhaseEqualityTable>, Route01<FourLeafPhaseMark2>,
        Route11<PhaseEqualityTable>, Route01<FourLeafPhaseMark3>>
    typealias R2 = EchoOrbitRound<H.RawA, H.RawB, H.Equality,
        RoutingAddress00, C, Route00<C>,
        Route10<PhaseEqualityTable>, Route00<FourLeafPhaseMark2>,
        Route11<PhaseEqualityTable>, Route00<FourLeafPhaseMark3>>
    typealias Rounds = ThreeEchoRounds<R0.Echo, R1.Echo, R2.Echo, R0.Advance, R1.Advance>
    typealias Path = FollowedPair<Start, Rounds>
    typealias Memory = EchoOrbitMemory<Path>
    typealias Read = EchoOrbitAnswer<Memory.Observation.Answer,
        Route00<EchoBitEquality>, Route00<EchoBitEquality>, Route00<EchoBitEquality>,
        Route11<EchoAllThree>, LocalPolicyAtOne<Paired<Never, Lit1>>>
    typealias Decision = EchoOrbitDecision<Path, Read>
}

enum ReindexedConstantReturn: Close {
    typealias Table = BoundaryWorking<RoutingAddress00, RoutingAddress00,
        RoutingAddress00, RoutingAddress00>
    typealias Move = FourLeafPhase0<RoutingAddress00, RoutingAddress00,
        RoutingAddress00, RoutingAddress00>
    typealias Read = Route00<Move.Right>
}

#if !LOCAL_PHASE_ECHO_ORBIT_TWO_ROUNDS && !LOCAL_PHASE_ECHO_ORBIT_MISSING_COVERAGE && !LOCAL_PHASE_ECHO_ORBIT_IDENTIFIES_SEED && !LOCAL_PHASE_ECHO_ORBIT_REINDEX_IS_RANGE
enum EchoOrbitConstructedAnswers: Null {
    typealias C = EchoOrbitCalibration
    typealias Left = AddressTriple<C.Verdicts.Left,
        C.AllFailedReturnsStillGiveEquality.Left, C.OriginalAcquisitionIsRetained.Left>
    typealias Right = AddressTriple<C.Verdicts.Right,
        C.AllFailedReturnsStillGiveEquality.Right, C.OriginalAcquisitionIsRetained.Right>
}

enum EchoOrbitExactThirdRoundBoundary: Null {
    typealias C = EchoOrbitCalibration
    typealias Left = Paired<C.SameTwoFacts.Left, C.ThirdFactSeparates.Left>
    typealias Right = Paired<C.SameTwoFacts.Right, C.ThirdFactSeparates.Right>
}

enum EchoOrbitWorksWithoutIdentifyingOrigin: Null {
    typealias C = EchoOrbitCalibration
    typealias Left = Paired<C.UnobservedOriginStaysUnidentified.Left,
        Paired<C.ShiftDecision.Read.Answer, C.Q33.Read.Answer>>
    typealias Right = Paired<C.UnobservedOriginStaysUnidentified.Right, Paired<Lit1, Lit1>>
}

// Same receiving memory does not establish the orbit coverage premise.
enum EchoOrbitShortCircuitHasSameMemory: Null {
    typealias Left = IncompleteEchoOrbit.Memory.Observation.Answer
    typealias Right = EchoOrbitCalibration.M33.Observation.Answer
}

enum EchoOrbitPreservesExtraLaboratory<K: Structure>: Null {
    typealias Path = StepBeside<EchoOrbitCalibration.Q33, K>
    typealias Left = Path.Right.Right
    typealias Right = K
}
#endif

#if LOCAL_PHASE_ECHO_ORBIT_TWO_ROUNDS
enum RejectedEchoOrbitTwoRounds: Null {
    typealias Left = EchoOrbitCalibration.Q22.Read.Answer
    typealias Right = EchoOrbitCalibration.Q23.Read.Answer
}
#endif

#if LOCAL_PHASE_ECHO_ORBIT_MISSING_COVERAGE
enum RejectedEchoOrbitMissingCoverage: Null {
    typealias Left = IncompleteEchoOrbit.Decision.Read.Answer
    typealias Right = EchoOrbitCalibration.Q23.Read.Answer
}
#endif

#if LOCAL_PHASE_ECHO_ORBIT_IDENTIFIES_SEED
enum RejectedEchoOrbitIdentifiesSeed: Null {
    typealias Left = EchoOrbitCalibration.S33.Seed.Answer
    typealias Right = EchoOrbitCalibration.ShiftStart.Seed.Answer
}
#endif

#if LOCAL_PHASE_ECHO_ORBIT_REINDEX_IS_RANGE
enum RejectedEchoOrbitReindexIsRange: Null {
    typealias Left = EchoOrbitCalibration.R33_0.NextValue.Answer
    typealias Right = ReindexedConstantReturn.Read.Answer
}
#endif
