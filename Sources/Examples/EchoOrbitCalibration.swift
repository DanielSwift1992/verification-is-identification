import VerificationIsIdentification

/// Sixteen source-bound paths share one actual four-cycle. Their original
/// resident probes run once, before any of the three local comparisons.
public enum EchoOrbitCalibration: Close {
    public typealias H = LocalEchoCalibration
    public typealias C = FourReturnCycle.Table
    public typealias S00 = PrepareEchoOrbit<H.E00.Run, H.E00.ReturnA, C>
    public typealias R00_0 = EchoOrbitRound<H.E00.RawA, H.E00.RawB, H.E00.Equality,
        RoutingAddress00, C, Route00<C>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>>
    public typealias R00_1 = EchoOrbitRound<H.E00.RawA, H.E00.RawB, H.E00.Equality,
        RoutingAddress01, C, Route01<C>,
        Route00<PhaseEqualityTable>, Route01<FourLeafPhaseMark0>,
        Route00<PhaseEqualityTable>, Route01<FourLeafPhaseMark0>>
    public typealias R00_2 = EchoOrbitRound<H.E00.RawA, H.E00.RawB, H.E00.Equality,
        RoutingAddress10, C, Route10<C>,
        Route00<PhaseEqualityTable>, Route10<FourLeafPhaseMark0>,
        Route00<PhaseEqualityTable>, Route10<FourLeafPhaseMark0>>
    public typealias O00 = ThreeEchoRounds<R00_0.Echo, R00_1.Echo, R00_2.Echo,
        R00_0.Advance, R00_1.Advance>
    public typealias E00 = FollowedPair<S00, O00>
    public typealias M00 = EchoOrbitMemory<E00>
    public typealias D00 = EchoOrbitAnswer<M00.Observation.Answer,
        Route11<EchoBitEquality>, Route00<EchoBitEquality>, Route00<EchoBitEquality>,
        Route11<EchoAllThree>, LocalPolicyAtOne<Paired<Never, Lit1>>>
    public typealias Q00 = EchoOrbitDecision<E00, D00>
    public typealias S01 = PrepareEchoOrbit<H.E01.Run, H.E01.ReturnA, C>
    public typealias R01_0 = EchoOrbitRound<H.E01.RawA, H.E01.RawB, H.E01.Equality,
        RoutingAddress00, C, Route00<C>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route01<PhaseEqualityTable>, Route00<FourLeafPhaseMark1>>
    public typealias R01_1 = EchoOrbitRound<H.E01.RawA, H.E01.RawB, H.E01.Equality,
        RoutingAddress01, C, Route01<C>,
        Route00<PhaseEqualityTable>, Route01<FourLeafPhaseMark0>,
        Route01<PhaseEqualityTable>, Route01<FourLeafPhaseMark1>>
    public typealias R01_2 = EchoOrbitRound<H.E01.RawA, H.E01.RawB, H.E01.Equality,
        RoutingAddress10, C, Route10<C>,
        Route00<PhaseEqualityTable>, Route10<FourLeafPhaseMark0>,
        Route01<PhaseEqualityTable>, Route10<FourLeafPhaseMark1>>
    public typealias O01 = ThreeEchoRounds<R01_0.Echo, R01_1.Echo, R01_2.Echo,
        R01_0.Advance, R01_1.Advance>
    public typealias E01 = FollowedPair<S01, O01>
    public typealias M01 = EchoOrbitMemory<E01>
    public typealias D01 = EchoOrbitAnswer<M01.Observation.Answer,
        Route10<EchoBitEquality>, Route01<EchoBitEquality>, Route00<EchoBitEquality>,
        Route00<EchoAllThree>, LocalPolicyAtOne<Paired<Never, Never>>>
    public typealias Q01 = EchoOrbitDecision<E01, D01>
    public typealias S02 = PrepareEchoOrbit<H.E02.Run, H.E02.ReturnA, C>
    public typealias R02_0 = EchoOrbitRound<H.E02.RawA, H.E02.RawB, H.E02.Equality,
        RoutingAddress00, C, Route00<C>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route10<PhaseEqualityTable>, Route00<FourLeafPhaseMark2>>
    public typealias R02_1 = EchoOrbitRound<H.E02.RawA, H.E02.RawB, H.E02.Equality,
        RoutingAddress01, C, Route01<C>,
        Route00<PhaseEqualityTable>, Route01<FourLeafPhaseMark0>,
        Route10<PhaseEqualityTable>, Route01<FourLeafPhaseMark2>>
    public typealias R02_2 = EchoOrbitRound<H.E02.RawA, H.E02.RawB, H.E02.Equality,
        RoutingAddress10, C, Route10<C>,
        Route00<PhaseEqualityTable>, Route10<FourLeafPhaseMark0>,
        Route10<PhaseEqualityTable>, Route10<FourLeafPhaseMark2>>
    public typealias O02 = ThreeEchoRounds<R02_0.Echo, R02_1.Echo, R02_2.Echo,
        R02_0.Advance, R02_1.Advance>
    public typealias E02 = FollowedPair<S02, O02>
    public typealias M02 = EchoOrbitMemory<E02>
    public typealias D02 = EchoOrbitAnswer<M02.Observation.Answer,
        Route10<EchoBitEquality>, Route00<EchoBitEquality>, Route01<EchoBitEquality>,
        Route01<EchoAllThree>, LocalPolicyAtZero<Paired<Never, Never>>>
    public typealias Q02 = EchoOrbitDecision<E02, D02>
    public typealias S03 = PrepareEchoOrbit<H.E03.Run, H.E03.ReturnA, C>
    public typealias R03_0 = EchoOrbitRound<H.E03.RawA, H.E03.RawB, H.E03.Equality,
        RoutingAddress00, C, Route00<C>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route11<PhaseEqualityTable>, Route00<FourLeafPhaseMark3>>
    public typealias R03_1 = EchoOrbitRound<H.E03.RawA, H.E03.RawB, H.E03.Equality,
        RoutingAddress01, C, Route01<C>,
        Route00<PhaseEqualityTable>, Route01<FourLeafPhaseMark0>,
        Route11<PhaseEqualityTable>, Route01<FourLeafPhaseMark3>>
    public typealias R03_2 = EchoOrbitRound<H.E03.RawA, H.E03.RawB, H.E03.Equality,
        RoutingAddress10, C, Route10<C>,
        Route00<PhaseEqualityTable>, Route10<FourLeafPhaseMark0>,
        Route11<PhaseEqualityTable>, Route10<FourLeafPhaseMark3>>
    public typealias O03 = ThreeEchoRounds<R03_0.Echo, R03_1.Echo, R03_2.Echo,
        R03_0.Advance, R03_1.Advance>
    public typealias E03 = FollowedPair<S03, O03>
    public typealias M03 = EchoOrbitMemory<E03>
    public typealias D03 = EchoOrbitAnswer<M03.Observation.Answer,
        Route10<EchoBitEquality>, Route00<EchoBitEquality>, Route00<EchoBitEquality>,
        Route01<EchoAllThree>, LocalPolicyAtOne<Paired<Never, Never>>>
    public typealias Q03 = EchoOrbitDecision<E03, D03>
    public typealias S10 = PrepareEchoOrbit<H.E10.Run, H.E10.ReturnA, C>
    public typealias R10_0 = EchoOrbitRound<H.E10.RawA, H.E10.RawB, H.E10.Equality,
        RoutingAddress00, C, Route00<C>,
        Route01<PhaseEqualityTable>, Route00<FourLeafPhaseMark1>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>>
    public typealias R10_1 = EchoOrbitRound<H.E10.RawA, H.E10.RawB, H.E10.Equality,
        RoutingAddress01, C, Route01<C>,
        Route01<PhaseEqualityTable>, Route01<FourLeafPhaseMark1>,
        Route00<PhaseEqualityTable>, Route01<FourLeafPhaseMark0>>
    public typealias R10_2 = EchoOrbitRound<H.E10.RawA, H.E10.RawB, H.E10.Equality,
        RoutingAddress10, C, Route10<C>,
        Route01<PhaseEqualityTable>, Route10<FourLeafPhaseMark1>,
        Route00<PhaseEqualityTable>, Route10<FourLeafPhaseMark0>>
    public typealias O10 = ThreeEchoRounds<R10_0.Echo, R10_1.Echo, R10_2.Echo,
        R10_0.Advance, R10_1.Advance>
    public typealias E10 = FollowedPair<S10, O10>
    public typealias M10 = EchoOrbitMemory<E10>
    public typealias D10 = EchoOrbitAnswer<M10.Observation.Answer,
        Route01<EchoBitEquality>, Route10<EchoBitEquality>, Route00<EchoBitEquality>,
        Route00<EchoAllThree>, LocalPolicyAtOne<Paired<Never, Never>>>
    public typealias Q10 = EchoOrbitDecision<E10, D10>
    public typealias S11 = PrepareEchoOrbit<H.E11.Run, H.E11.ReturnA, C>
    public typealias R11_0 = EchoOrbitRound<H.E11.RawA, H.E11.RawB, H.E11.Equality,
        RoutingAddress00, C, Route00<C>,
        Route01<PhaseEqualityTable>, Route00<FourLeafPhaseMark1>,
        Route01<PhaseEqualityTable>, Route00<FourLeafPhaseMark1>>
    public typealias R11_1 = EchoOrbitRound<H.E11.RawA, H.E11.RawB, H.E11.Equality,
        RoutingAddress01, C, Route01<C>,
        Route01<PhaseEqualityTable>, Route01<FourLeafPhaseMark1>,
        Route01<PhaseEqualityTable>, Route01<FourLeafPhaseMark1>>
    public typealias R11_2 = EchoOrbitRound<H.E11.RawA, H.E11.RawB, H.E11.Equality,
        RoutingAddress10, C, Route10<C>,
        Route01<PhaseEqualityTable>, Route10<FourLeafPhaseMark1>,
        Route01<PhaseEqualityTable>, Route10<FourLeafPhaseMark1>>
    public typealias O11 = ThreeEchoRounds<R11_0.Echo, R11_1.Echo, R11_2.Echo,
        R11_0.Advance, R11_1.Advance>
    public typealias E11 = FollowedPair<S11, O11>
    public typealias M11 = EchoOrbitMemory<E11>
    public typealias D11 = EchoOrbitAnswer<M11.Observation.Answer,
        Route00<EchoBitEquality>, Route11<EchoBitEquality>, Route00<EchoBitEquality>,
        Route11<EchoAllThree>, LocalPolicyAtOne<Paired<Never, Lit1>>>
    public typealias Q11 = EchoOrbitDecision<E11, D11>
    public typealias S12 = PrepareEchoOrbit<H.E12.Run, H.E12.ReturnA, C>
    public typealias R12_0 = EchoOrbitRound<H.E12.RawA, H.E12.RawB, H.E12.Equality,
        RoutingAddress00, C, Route00<C>,
        Route01<PhaseEqualityTable>, Route00<FourLeafPhaseMark1>,
        Route10<PhaseEqualityTable>, Route00<FourLeafPhaseMark2>>
    public typealias R12_1 = EchoOrbitRound<H.E12.RawA, H.E12.RawB, H.E12.Equality,
        RoutingAddress01, C, Route01<C>,
        Route01<PhaseEqualityTable>, Route01<FourLeafPhaseMark1>,
        Route10<PhaseEqualityTable>, Route01<FourLeafPhaseMark2>>
    public typealias R12_2 = EchoOrbitRound<H.E12.RawA, H.E12.RawB, H.E12.Equality,
        RoutingAddress10, C, Route10<C>,
        Route01<PhaseEqualityTable>, Route10<FourLeafPhaseMark1>,
        Route10<PhaseEqualityTable>, Route10<FourLeafPhaseMark2>>
    public typealias O12 = ThreeEchoRounds<R12_0.Echo, R12_1.Echo, R12_2.Echo,
        R12_0.Advance, R12_1.Advance>
    public typealias E12 = FollowedPair<S12, O12>
    public typealias M12 = EchoOrbitMemory<E12>
    public typealias D12 = EchoOrbitAnswer<M12.Observation.Answer,
        Route00<EchoBitEquality>, Route10<EchoBitEquality>, Route01<EchoBitEquality>,
        Route10<EchoAllThree>, LocalPolicyAtZero<Paired<Never, Never>>>
    public typealias Q12 = EchoOrbitDecision<E12, D12>
    public typealias S13 = PrepareEchoOrbit<H.E13.Run, H.E13.ReturnA, C>
    public typealias R13_0 = EchoOrbitRound<H.E13.RawA, H.E13.RawB, H.E13.Equality,
        RoutingAddress00, C, Route00<C>,
        Route01<PhaseEqualityTable>, Route00<FourLeafPhaseMark1>,
        Route11<PhaseEqualityTable>, Route00<FourLeafPhaseMark3>>
    public typealias R13_1 = EchoOrbitRound<H.E13.RawA, H.E13.RawB, H.E13.Equality,
        RoutingAddress01, C, Route01<C>,
        Route01<PhaseEqualityTable>, Route01<FourLeafPhaseMark1>,
        Route11<PhaseEqualityTable>, Route01<FourLeafPhaseMark3>>
    public typealias R13_2 = EchoOrbitRound<H.E13.RawA, H.E13.RawB, H.E13.Equality,
        RoutingAddress10, C, Route10<C>,
        Route01<PhaseEqualityTable>, Route10<FourLeafPhaseMark1>,
        Route11<PhaseEqualityTable>, Route10<FourLeafPhaseMark3>>
    public typealias O13 = ThreeEchoRounds<R13_0.Echo, R13_1.Echo, R13_2.Echo,
        R13_0.Advance, R13_1.Advance>
    public typealias E13 = FollowedPair<S13, O13>
    public typealias M13 = EchoOrbitMemory<E13>
    public typealias D13 = EchoOrbitAnswer<M13.Observation.Answer,
        Route00<EchoBitEquality>, Route10<EchoBitEquality>, Route00<EchoBitEquality>,
        Route10<EchoAllThree>, LocalPolicyAtOne<Paired<Never, Never>>>
    public typealias Q13 = EchoOrbitDecision<E13, D13>
    public typealias S20 = PrepareEchoOrbit<H.E20.Run, H.E20.ReturnA, C>
    public typealias R20_0 = EchoOrbitRound<H.E20.RawA, H.E20.RawB, H.E20.Equality,
        RoutingAddress00, C, Route00<C>,
        Route10<PhaseEqualityTable>, Route00<FourLeafPhaseMark2>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>>
    public typealias R20_1 = EchoOrbitRound<H.E20.RawA, H.E20.RawB, H.E20.Equality,
        RoutingAddress01, C, Route01<C>,
        Route10<PhaseEqualityTable>, Route01<FourLeafPhaseMark2>,
        Route00<PhaseEqualityTable>, Route01<FourLeafPhaseMark0>>
    public typealias R20_2 = EchoOrbitRound<H.E20.RawA, H.E20.RawB, H.E20.Equality,
        RoutingAddress10, C, Route10<C>,
        Route10<PhaseEqualityTable>, Route10<FourLeafPhaseMark2>,
        Route00<PhaseEqualityTable>, Route10<FourLeafPhaseMark0>>
    public typealias O20 = ThreeEchoRounds<R20_0.Echo, R20_1.Echo, R20_2.Echo,
        R20_0.Advance, R20_1.Advance>
    public typealias E20 = FollowedPair<S20, O20>
    public typealias M20 = EchoOrbitMemory<E20>
    public typealias D20 = EchoOrbitAnswer<M20.Observation.Answer,
        Route01<EchoBitEquality>, Route00<EchoBitEquality>, Route10<EchoBitEquality>,
        Route01<EchoAllThree>, LocalPolicyAtZero<Paired<Never, Never>>>
    public typealias Q20 = EchoOrbitDecision<E20, D20>
    public typealias S21 = PrepareEchoOrbit<H.E21.Run, H.E21.ReturnA, C>
    public typealias R21_0 = EchoOrbitRound<H.E21.RawA, H.E21.RawB, H.E21.Equality,
        RoutingAddress00, C, Route00<C>,
        Route10<PhaseEqualityTable>, Route00<FourLeafPhaseMark2>,
        Route01<PhaseEqualityTable>, Route00<FourLeafPhaseMark1>>
    public typealias R21_1 = EchoOrbitRound<H.E21.RawA, H.E21.RawB, H.E21.Equality,
        RoutingAddress01, C, Route01<C>,
        Route10<PhaseEqualityTable>, Route01<FourLeafPhaseMark2>,
        Route01<PhaseEqualityTable>, Route01<FourLeafPhaseMark1>>
    public typealias R21_2 = EchoOrbitRound<H.E21.RawA, H.E21.RawB, H.E21.Equality,
        RoutingAddress10, C, Route10<C>,
        Route10<PhaseEqualityTable>, Route10<FourLeafPhaseMark2>,
        Route01<PhaseEqualityTable>, Route10<FourLeafPhaseMark1>>
    public typealias O21 = ThreeEchoRounds<R21_0.Echo, R21_1.Echo, R21_2.Echo,
        R21_0.Advance, R21_1.Advance>
    public typealias E21 = FollowedPair<S21, O21>
    public typealias M21 = EchoOrbitMemory<E21>
    public typealias D21 = EchoOrbitAnswer<M21.Observation.Answer,
        Route00<EchoBitEquality>, Route01<EchoBitEquality>, Route10<EchoBitEquality>,
        Route10<EchoAllThree>, LocalPolicyAtZero<Paired<Never, Never>>>
    public typealias Q21 = EchoOrbitDecision<E21, D21>
    public typealias S22 = PrepareEchoOrbit<H.E22.Run, H.E22.ReturnA, C>
    public typealias R22_0 = EchoOrbitRound<H.E22.RawA, H.E22.RawB, H.E22.Equality,
        RoutingAddress00, C, Route00<C>,
        Route10<PhaseEqualityTable>, Route00<FourLeafPhaseMark2>,
        Route10<PhaseEqualityTable>, Route00<FourLeafPhaseMark2>>
    public typealias R22_1 = EchoOrbitRound<H.E22.RawA, H.E22.RawB, H.E22.Equality,
        RoutingAddress01, C, Route01<C>,
        Route10<PhaseEqualityTable>, Route01<FourLeafPhaseMark2>,
        Route10<PhaseEqualityTable>, Route01<FourLeafPhaseMark2>>
    public typealias R22_2 = EchoOrbitRound<H.E22.RawA, H.E22.RawB, H.E22.Equality,
        RoutingAddress10, C, Route10<C>,
        Route10<PhaseEqualityTable>, Route10<FourLeafPhaseMark2>,
        Route10<PhaseEqualityTable>, Route10<FourLeafPhaseMark2>>
    public typealias O22 = ThreeEchoRounds<R22_0.Echo, R22_1.Echo, R22_2.Echo,
        R22_0.Advance, R22_1.Advance>
    public typealias E22 = FollowedPair<S22, O22>
    public typealias M22 = EchoOrbitMemory<E22>
    public typealias D22 = EchoOrbitAnswer<M22.Observation.Answer,
        Route00<EchoBitEquality>, Route00<EchoBitEquality>, Route11<EchoBitEquality>,
        Route11<EchoAllThree>, LocalPolicyAtOne<Paired<Never, Lit1>>>
    public typealias Q22 = EchoOrbitDecision<E22, D22>
    public typealias S23 = PrepareEchoOrbit<H.E23.Run, H.E23.ReturnA, C>
    public typealias R23_0 = EchoOrbitRound<H.E23.RawA, H.E23.RawB, H.E23.Equality,
        RoutingAddress00, C, Route00<C>,
        Route10<PhaseEqualityTable>, Route00<FourLeafPhaseMark2>,
        Route11<PhaseEqualityTable>, Route00<FourLeafPhaseMark3>>
    public typealias R23_1 = EchoOrbitRound<H.E23.RawA, H.E23.RawB, H.E23.Equality,
        RoutingAddress01, C, Route01<C>,
        Route10<PhaseEqualityTable>, Route01<FourLeafPhaseMark2>,
        Route11<PhaseEqualityTable>, Route01<FourLeafPhaseMark3>>
    public typealias R23_2 = EchoOrbitRound<H.E23.RawA, H.E23.RawB, H.E23.Equality,
        RoutingAddress10, C, Route10<C>,
        Route10<PhaseEqualityTable>, Route10<FourLeafPhaseMark2>,
        Route11<PhaseEqualityTable>, Route10<FourLeafPhaseMark3>>
    public typealias O23 = ThreeEchoRounds<R23_0.Echo, R23_1.Echo, R23_2.Echo,
        R23_0.Advance, R23_1.Advance>
    public typealias E23 = FollowedPair<S23, O23>
    public typealias M23 = EchoOrbitMemory<E23>
    public typealias D23 = EchoOrbitAnswer<M23.Observation.Answer,
        Route00<EchoBitEquality>, Route00<EchoBitEquality>, Route10<EchoBitEquality>,
        Route11<EchoAllThree>, LocalPolicyAtZero<Paired<Never, Lit1>>>
    public typealias Q23 = EchoOrbitDecision<E23, D23>
    public typealias S30 = PrepareEchoOrbit<H.E30.Run, H.E30.ReturnA, C>
    public typealias R30_0 = EchoOrbitRound<H.E30.RawA, H.E30.RawB, H.E30.Equality,
        RoutingAddress00, C, Route00<C>,
        Route11<PhaseEqualityTable>, Route00<FourLeafPhaseMark3>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>>
    public typealias R30_1 = EchoOrbitRound<H.E30.RawA, H.E30.RawB, H.E30.Equality,
        RoutingAddress01, C, Route01<C>,
        Route11<PhaseEqualityTable>, Route01<FourLeafPhaseMark3>,
        Route00<PhaseEqualityTable>, Route01<FourLeafPhaseMark0>>
    public typealias R30_2 = EchoOrbitRound<H.E30.RawA, H.E30.RawB, H.E30.Equality,
        RoutingAddress10, C, Route10<C>,
        Route11<PhaseEqualityTable>, Route10<FourLeafPhaseMark3>,
        Route00<PhaseEqualityTable>, Route10<FourLeafPhaseMark0>>
    public typealias O30 = ThreeEchoRounds<R30_0.Echo, R30_1.Echo, R30_2.Echo,
        R30_0.Advance, R30_1.Advance>
    public typealias E30 = FollowedPair<S30, O30>
    public typealias M30 = EchoOrbitMemory<E30>
    public typealias D30 = EchoOrbitAnswer<M30.Observation.Answer,
        Route01<EchoBitEquality>, Route00<EchoBitEquality>, Route00<EchoBitEquality>,
        Route01<EchoAllThree>, LocalPolicyAtOne<Paired<Never, Never>>>
    public typealias Q30 = EchoOrbitDecision<E30, D30>
    public typealias S31 = PrepareEchoOrbit<H.E31.Run, H.E31.ReturnA, C>
    public typealias R31_0 = EchoOrbitRound<H.E31.RawA, H.E31.RawB, H.E31.Equality,
        RoutingAddress00, C, Route00<C>,
        Route11<PhaseEqualityTable>, Route00<FourLeafPhaseMark3>,
        Route01<PhaseEqualityTable>, Route00<FourLeafPhaseMark1>>
    public typealias R31_1 = EchoOrbitRound<H.E31.RawA, H.E31.RawB, H.E31.Equality,
        RoutingAddress01, C, Route01<C>,
        Route11<PhaseEqualityTable>, Route01<FourLeafPhaseMark3>,
        Route01<PhaseEqualityTable>, Route01<FourLeafPhaseMark1>>
    public typealias R31_2 = EchoOrbitRound<H.E31.RawA, H.E31.RawB, H.E31.Equality,
        RoutingAddress10, C, Route10<C>,
        Route11<PhaseEqualityTable>, Route10<FourLeafPhaseMark3>,
        Route01<PhaseEqualityTable>, Route10<FourLeafPhaseMark1>>
    public typealias O31 = ThreeEchoRounds<R31_0.Echo, R31_1.Echo, R31_2.Echo,
        R31_0.Advance, R31_1.Advance>
    public typealias E31 = FollowedPair<S31, O31>
    public typealias M31 = EchoOrbitMemory<E31>
    public typealias D31 = EchoOrbitAnswer<M31.Observation.Answer,
        Route00<EchoBitEquality>, Route01<EchoBitEquality>, Route00<EchoBitEquality>,
        Route10<EchoAllThree>, LocalPolicyAtOne<Paired<Never, Never>>>
    public typealias Q31 = EchoOrbitDecision<E31, D31>
    public typealias S32 = PrepareEchoOrbit<H.E32.Run, H.E32.ReturnA, C>
    public typealias R32_0 = EchoOrbitRound<H.E32.RawA, H.E32.RawB, H.E32.Equality,
        RoutingAddress00, C, Route00<C>,
        Route11<PhaseEqualityTable>, Route00<FourLeafPhaseMark3>,
        Route10<PhaseEqualityTable>, Route00<FourLeafPhaseMark2>>
    public typealias R32_1 = EchoOrbitRound<H.E32.RawA, H.E32.RawB, H.E32.Equality,
        RoutingAddress01, C, Route01<C>,
        Route11<PhaseEqualityTable>, Route01<FourLeafPhaseMark3>,
        Route10<PhaseEqualityTable>, Route01<FourLeafPhaseMark2>>
    public typealias R32_2 = EchoOrbitRound<H.E32.RawA, H.E32.RawB, H.E32.Equality,
        RoutingAddress10, C, Route10<C>,
        Route11<PhaseEqualityTable>, Route10<FourLeafPhaseMark3>,
        Route10<PhaseEqualityTable>, Route10<FourLeafPhaseMark2>>
    public typealias O32 = ThreeEchoRounds<R32_0.Echo, R32_1.Echo, R32_2.Echo,
        R32_0.Advance, R32_1.Advance>
    public typealias E32 = FollowedPair<S32, O32>
    public typealias M32 = EchoOrbitMemory<E32>
    public typealias D32 = EchoOrbitAnswer<M32.Observation.Answer,
        Route00<EchoBitEquality>, Route00<EchoBitEquality>, Route01<EchoBitEquality>,
        Route11<EchoAllThree>, LocalPolicyAtZero<Paired<Never, Lit1>>>
    public typealias Q32 = EchoOrbitDecision<E32, D32>
    public typealias S33 = PrepareEchoOrbit<H.E33.Run, H.E33.ReturnA, C>
    public typealias R33_0 = EchoOrbitRound<H.E33.RawA, H.E33.RawB, H.E33.Equality,
        RoutingAddress00, C, Route00<C>,
        Route11<PhaseEqualityTable>, Route00<FourLeafPhaseMark3>,
        Route11<PhaseEqualityTable>, Route00<FourLeafPhaseMark3>>
    public typealias R33_1 = EchoOrbitRound<H.E33.RawA, H.E33.RawB, H.E33.Equality,
        RoutingAddress01, C, Route01<C>,
        Route11<PhaseEqualityTable>, Route01<FourLeafPhaseMark3>,
        Route11<PhaseEqualityTable>, Route01<FourLeafPhaseMark3>>
    public typealias R33_2 = EchoOrbitRound<H.E33.RawA, H.E33.RawB, H.E33.Equality,
        RoutingAddress10, C, Route10<C>,
        Route11<PhaseEqualityTable>, Route10<FourLeafPhaseMark3>,
        Route11<PhaseEqualityTable>, Route10<FourLeafPhaseMark3>>
    public typealias O33 = ThreeEchoRounds<R33_0.Echo, R33_1.Echo, R33_2.Echo,
        R33_0.Advance, R33_1.Advance>
    public typealias E33 = FollowedPair<S33, O33>
    public typealias M33 = EchoOrbitMemory<E33>
    public typealias D33 = EchoOrbitAnswer<M33.Observation.Answer,
        Route00<EchoBitEquality>, Route00<EchoBitEquality>, Route00<EchoBitEquality>,
        Route11<EchoAllThree>, LocalPolicyAtOne<Paired<Never, Lit1>>>
    public typealias Q33 = EchoOrbitDecision<E33, D33>
    public enum Verdicts: Null {
        public typealias Left = BoundaryWorking<
            BoundaryWorking<Q00.Read.Answer, Q01.Read.Answer, Q02.Read.Answer, Q03.Read.Answer>,
            BoundaryWorking<Q10.Read.Answer, Q11.Read.Answer, Q12.Read.Answer, Q13.Read.Answer>,
            BoundaryWorking<Q20.Read.Answer, Q21.Read.Answer, Q22.Read.Answer, Q23.Read.Answer>,
            BoundaryWorking<Q30.Read.Answer, Q31.Read.Answer, Q32.Read.Answer, Q33.Read.Answer>>
        public typealias Right = PhaseEqualityTable
    }
    public enum AllFailedReturnsStillGiveEquality: Null {
        public typealias Left = Paired<AddressTriple<O33.F0.Answer, O33.F1.Answer, O33.F2.Answer>,
            Q33.Read.Answer>
        public typealias Failure = Paired<Never, Never>
        public typealias Right = Paired<AddressTriple<Failure, Failure, Failure>, Lit1>
    }
    public enum SameTwoFacts: Null {
        public typealias Left = Paired<O22.F0, O22.F1>
        public typealias Right = Paired<O23.F0, O23.F1>
    }
    public enum ThirdFactSeparates: Null {
        public typealias Left = Paired<Paired<O22.F2.Answer, O23.F2.Answer>,
            Paired<Q22.Read.Answer, Q23.Read.Answer>>
        public typealias Right = Paired<Paired<Paired<Lit1, Lit1>, Paired<Lit1, Never>>,
            Paired<Lit1, Never>>
    }
    public enum OriginalAcquisitionIsRetained: Null {
        public typealias Left = Paired<E33.Right.Left.Left.Left.Left,
            E23.Right.Left.Left.Left.Left>
        public typealias Right = Paired<H.E33.Run.Right, H.E23.Run.Right>
    }

    /// Shift the unobserved seed from 0 to 1 and originals from 3 to 0.
    /// Three failed echoes retain exactly the same receiving memory.
    public typealias ShiftD = BoundaryWorking<RoutingAddress01, RoutingAddress01,
        RoutingAddress01, RoutingAddress01>
    public typealias ShiftHost = LocalProbeEcho<H.F00, ShiftD, Route00<ShiftD>, Route00<ShiftD>,
        Route00<PhaseEqualityTable>, Route01<FourLeafPhaseMark0>,
        Route00<PhaseEqualityTable>, Route01<FourLeafPhaseMark0>>
    public typealias ShiftStart = PrepareEchoOrbit<ShiftHost.Run, ShiftHost.ReturnA, C>
    public typealias Shift0 = EchoOrbitRound<ShiftHost.RawA, ShiftHost.RawB, ShiftHost.Equality,
        RoutingAddress01, C, Route01<C>, Route00<PhaseEqualityTable>, Route01<FourLeafPhaseMark0>,
        Route00<PhaseEqualityTable>, Route01<FourLeafPhaseMark0>>
    public typealias Shift1 = EchoOrbitRound<ShiftHost.RawA, ShiftHost.RawB, ShiftHost.Equality,
        RoutingAddress10, C, Route10<C>, Route00<PhaseEqualityTable>, Route10<FourLeafPhaseMark0>,
        Route00<PhaseEqualityTable>, Route10<FourLeafPhaseMark0>>
    public typealias Shift2 = EchoOrbitRound<ShiftHost.RawA, ShiftHost.RawB, ShiftHost.Equality,
        RoutingAddress11, C, Route11<C>, Route00<PhaseEqualityTable>, Route11<FourLeafPhaseMark0>,
        Route00<PhaseEqualityTable>, Route11<FourLeafPhaseMark0>>
    public typealias ShiftRounds = ThreeEchoRounds<Shift0.Echo, Shift1.Echo, Shift2.Echo,
        Shift0.Advance, Shift1.Advance>
    public typealias Shift = FollowedPair<ShiftStart, ShiftRounds>
    public typealias ShiftMemory = EchoOrbitMemory<Shift>
    public typealias ShiftAnswer = EchoOrbitAnswer<ShiftMemory.Observation.Answer,
        Route00<EchoBitEquality>, Route00<EchoBitEquality>, Route00<EchoBitEquality>,
        Route11<EchoAllThree>, LocalPolicyAtOne<Paired<Never, Lit1>>>
    public typealias ShiftDecision = EchoOrbitDecision<Shift, ShiftAnswer>
    public enum UnobservedOriginStaysUnidentified: Null {
        public typealias Left = M33.Observation.Answer
        public typealias Right = ShiftMemory.Observation.Answer
    }
}
