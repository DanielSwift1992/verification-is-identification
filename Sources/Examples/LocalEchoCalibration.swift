import VerificationIsIdentification

/// All sixteen raw reply classes through one constant forward table and
/// one identity return table. Every echo bit is computed, not supplied.
public enum LocalEchoCalibration: Close {
    public typealias P = FourLeafSecondProbe<Never>
    public typealias C = BoundaryWorking<RoutingAddress00, RoutingAddress00,
        RoutingAddress00, RoutingAddress00>
    public typealias D = BoundaryWorking<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11>
    public typealias F00 = PairedProbeInFrame<P.Z, P.Z, C, Route00<C>, Route00<C>>
    public typealias E00 = LocalProbeEcho<F00, D, Route00<D>, Route00<D>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>>
    public typealias A00 = LocalEchoAnswer<Paired<E00.Memory.Answer, EchoDecisionResources>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route11<EchoCompletionTable>, LocalPolicyAtOne<Paired<EchoDifferent, EchoEqual>>>
    public typealias Q00 = LocalEchoDecision<E00, E00.Memory, A00>
    public typealias F01 = PairedProbeInFrame<P.Z, P.I, C, Route00<C>, Route01<C>>
    public typealias E01 = LocalProbeEcho<F01, D, Route00<D>, Route00<D>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route01<PhaseEqualityTable>, Route00<FourLeafPhaseMark1>>
    public typealias A01 = LocalEchoAnswer<Paired<E01.Memory.Answer, EchoDecisionResources>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route10<EchoCompletionTable>, LocalPolicyAtOne<Paired<EchoDifferent, EchoDifferent>>>
    public typealias Q01 = LocalEchoDecision<E01, E01.Memory, A01>
    public typealias F02 = PairedProbeInFrame<P.Z, P.ZW, C, Route00<C>, Route10<C>>
    public typealias E02 = LocalProbeEcho<F02, D, Route00<D>, Route00<D>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route10<PhaseEqualityTable>, Route00<FourLeafPhaseMark2>>
    public typealias A02 = LocalEchoAnswer<Paired<E02.Memory.Answer, EchoDecisionResources>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route10<EchoCompletionTable>, LocalPolicyAtOne<Paired<EchoDifferent, EchoDifferent>>>
    public typealias Q02 = LocalEchoDecision<E02, E02.Memory, A02>
    public typealias F03 = PairedProbeInFrame<P.Z, P.ZWW, C, Route00<C>, Route11<C>>
    public typealias E03 = LocalProbeEcho<F03, D, Route00<D>, Route00<D>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route11<PhaseEqualityTable>, Route00<FourLeafPhaseMark3>>
    public typealias A03 = LocalEchoAnswer<Paired<E03.Memory.Answer, EchoDecisionResources>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route10<EchoCompletionTable>, LocalPolicyAtOne<Paired<EchoDifferent, EchoDifferent>>>
    public typealias Q03 = LocalEchoDecision<E03, E03.Memory, A03>
    public typealias F10 = PairedProbeInFrame<P.I, P.Z, C, Route01<C>, Route00<C>>
    public typealias E10 = LocalProbeEcho<F10, D, Route00<D>, Route00<D>,
        Route01<PhaseEqualityTable>, Route00<FourLeafPhaseMark1>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>>
    public typealias A10 = LocalEchoAnswer<Paired<E10.Memory.Answer, EchoDecisionResources>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route01<EchoCompletionTable>, LocalPolicyAtOne<Paired<EchoDifferent, EchoDifferent>>>
    public typealias Q10 = LocalEchoDecision<E10, E10.Memory, A10>
    public typealias F11 = PairedProbeInFrame<P.I, P.I, C, Route01<C>, Route01<C>>
    public typealias E11 = LocalProbeEcho<F11, D, Route00<D>, Route00<D>,
        Route01<PhaseEqualityTable>, Route00<FourLeafPhaseMark1>,
        Route01<PhaseEqualityTable>, Route00<FourLeafPhaseMark1>>
    public typealias A11 = LocalEchoAnswer<Paired<E11.Memory.Answer, EchoDecisionResources>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route00<EchoCompletionTable>, LocalPolicyAtOne<Paired<EchoDifferent, EchoUndetermined>>>
    public typealias Q11 = LocalEchoDecision<E11, E11.Memory, A11>
    public typealias F12 = PairedProbeInFrame<P.I, P.ZW, C, Route01<C>, Route10<C>>
    public typealias E12 = LocalProbeEcho<F12, D, Route00<D>, Route00<D>,
        Route01<PhaseEqualityTable>, Route00<FourLeafPhaseMark1>,
        Route10<PhaseEqualityTable>, Route00<FourLeafPhaseMark2>>
    public typealias A12 = LocalEchoAnswer<Paired<E12.Memory.Answer, EchoDecisionResources>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route00<EchoCompletionTable>, LocalPolicyAtOne<Paired<EchoDifferent, EchoUndetermined>>>
    public typealias Q12 = LocalEchoDecision<E12, E12.Memory, A12>
    public typealias F13 = PairedProbeInFrame<P.I, P.ZWW, C, Route01<C>, Route11<C>>
    public typealias E13 = LocalProbeEcho<F13, D, Route00<D>, Route00<D>,
        Route01<PhaseEqualityTable>, Route00<FourLeafPhaseMark1>,
        Route11<PhaseEqualityTable>, Route00<FourLeafPhaseMark3>>
    public typealias A13 = LocalEchoAnswer<Paired<E13.Memory.Answer, EchoDecisionResources>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route00<EchoCompletionTable>, LocalPolicyAtOne<Paired<EchoDifferent, EchoUndetermined>>>
    public typealias Q13 = LocalEchoDecision<E13, E13.Memory, A13>
    public typealias F20 = PairedProbeInFrame<P.ZW, P.Z, C, Route10<C>, Route00<C>>
    public typealias E20 = LocalProbeEcho<F20, D, Route00<D>, Route00<D>,
        Route10<PhaseEqualityTable>, Route00<FourLeafPhaseMark2>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>>
    public typealias A20 = LocalEchoAnswer<Paired<E20.Memory.Answer, EchoDecisionResources>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route01<EchoCompletionTable>, LocalPolicyAtOne<Paired<EchoDifferent, EchoDifferent>>>
    public typealias Q20 = LocalEchoDecision<E20, E20.Memory, A20>
    public typealias F21 = PairedProbeInFrame<P.ZW, P.I, C, Route10<C>, Route01<C>>
    public typealias E21 = LocalProbeEcho<F21, D, Route00<D>, Route00<D>,
        Route10<PhaseEqualityTable>, Route00<FourLeafPhaseMark2>,
        Route01<PhaseEqualityTable>, Route00<FourLeafPhaseMark1>>
    public typealias A21 = LocalEchoAnswer<Paired<E21.Memory.Answer, EchoDecisionResources>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route00<EchoCompletionTable>, LocalPolicyAtOne<Paired<EchoDifferent, EchoUndetermined>>>
    public typealias Q21 = LocalEchoDecision<E21, E21.Memory, A21>
    public typealias F22 = PairedProbeInFrame<P.ZW, P.ZW, C, Route10<C>, Route10<C>>
    public typealias E22 = LocalProbeEcho<F22, D, Route00<D>, Route00<D>,
        Route10<PhaseEqualityTable>, Route00<FourLeafPhaseMark2>,
        Route10<PhaseEqualityTable>, Route00<FourLeafPhaseMark2>>
    public typealias A22 = LocalEchoAnswer<Paired<E22.Memory.Answer, EchoDecisionResources>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route00<EchoCompletionTable>, LocalPolicyAtOne<Paired<EchoDifferent, EchoUndetermined>>>
    public typealias Q22 = LocalEchoDecision<E22, E22.Memory, A22>
    public typealias F23 = PairedProbeInFrame<P.ZW, P.ZWW, C, Route10<C>, Route11<C>>
    public typealias E23 = LocalProbeEcho<F23, D, Route00<D>, Route00<D>,
        Route10<PhaseEqualityTable>, Route00<FourLeafPhaseMark2>,
        Route11<PhaseEqualityTable>, Route00<FourLeafPhaseMark3>>
    public typealias A23 = LocalEchoAnswer<Paired<E23.Memory.Answer, EchoDecisionResources>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route00<EchoCompletionTable>, LocalPolicyAtOne<Paired<EchoDifferent, EchoUndetermined>>>
    public typealias Q23 = LocalEchoDecision<E23, E23.Memory, A23>
    public typealias F30 = PairedProbeInFrame<P.ZWW, P.Z, C, Route11<C>, Route00<C>>
    public typealias E30 = LocalProbeEcho<F30, D, Route00<D>, Route00<D>,
        Route11<PhaseEqualityTable>, Route00<FourLeafPhaseMark3>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>>
    public typealias A30 = LocalEchoAnswer<Paired<E30.Memory.Answer, EchoDecisionResources>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route01<EchoCompletionTable>, LocalPolicyAtOne<Paired<EchoDifferent, EchoDifferent>>>
    public typealias Q30 = LocalEchoDecision<E30, E30.Memory, A30>
    public typealias F31 = PairedProbeInFrame<P.ZWW, P.I, C, Route11<C>, Route01<C>>
    public typealias E31 = LocalProbeEcho<F31, D, Route00<D>, Route00<D>,
        Route11<PhaseEqualityTable>, Route00<FourLeafPhaseMark3>,
        Route01<PhaseEqualityTable>, Route00<FourLeafPhaseMark1>>
    public typealias A31 = LocalEchoAnswer<Paired<E31.Memory.Answer, EchoDecisionResources>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route00<EchoCompletionTable>, LocalPolicyAtOne<Paired<EchoDifferent, EchoUndetermined>>>
    public typealias Q31 = LocalEchoDecision<E31, E31.Memory, A31>
    public typealias F32 = PairedProbeInFrame<P.ZWW, P.ZW, C, Route11<C>, Route10<C>>
    public typealias E32 = LocalProbeEcho<F32, D, Route00<D>, Route00<D>,
        Route11<PhaseEqualityTable>, Route00<FourLeafPhaseMark3>,
        Route10<PhaseEqualityTable>, Route00<FourLeafPhaseMark2>>
    public typealias A32 = LocalEchoAnswer<Paired<E32.Memory.Answer, EchoDecisionResources>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route00<EchoCompletionTable>, LocalPolicyAtOne<Paired<EchoDifferent, EchoUndetermined>>>
    public typealias Q32 = LocalEchoDecision<E32, E32.Memory, A32>
    public typealias F33 = PairedProbeInFrame<P.ZWW, P.ZWW, C, Route11<C>, Route11<C>>
    public typealias E33 = LocalProbeEcho<F33, D, Route00<D>, Route00<D>,
        Route11<PhaseEqualityTable>, Route00<FourLeafPhaseMark3>,
        Route11<PhaseEqualityTable>, Route00<FourLeafPhaseMark3>>
    public typealias A33 = LocalEchoAnswer<Paired<E33.Memory.Answer, EchoDecisionResources>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route00<EchoCompletionTable>, LocalPolicyAtOne<Paired<EchoDifferent, EchoUndetermined>>>
    public typealias Q33 = LocalEchoDecision<E33, E33.Memory, A33>
    public enum Answers: Null {
        public typealias Left = BoundaryWorking<
            BoundaryWorking<Q00.Read.Answer, Q01.Read.Answer, Q02.Read.Answer, Q03.Read.Answer>,
            BoundaryWorking<Q10.Read.Answer, Q11.Read.Answer, Q12.Read.Answer, Q13.Read.Answer>,
            BoundaryWorking<Q20.Read.Answer, Q21.Read.Answer, Q22.Read.Answer, Q23.Read.Answer>,
            BoundaryWorking<Q30.Read.Answer, Q31.Read.Answer, Q32.Read.Answer, Q33.Read.Answer>>
        public typealias UndecidedRow = BoundaryWorking<EchoDifferent, EchoUndetermined,
            EchoUndetermined, EchoUndetermined>
        public typealias Right = BoundaryWorking<
            BoundaryWorking<EchoEqual, EchoDifferent, EchoDifferent, EchoDifferent>,
            UndecidedRow, UndecidedRow, UndecidedRow>
    }
    public enum EchoesWereAcquired: Null {
        public typealias Left = BoundaryWorking<E00.Echoes.Answer, E02.Echoes.Answer,
            E20.Echoes.Answer, E12.Echoes.Answer>
        public typealias Right = BoundaryWorking<Paired<Lit1, Lit1>, Paired<Lit1, Never>,
            Paired<Never, Lit1>, Paired<Never, Never>>
    }
    public enum SameUndeterminedMemory: Null {
        public typealias Left = Q11.Observation.Answer
        public typealias Right = Q12.Observation.Answer
    }
    public enum SourcesBehindThatMemory: Null {
        public typealias Left = Paired<Paired<E11.RawA.Answer, E11.RawB.Answer>,
            Paired<E12.RawA.Answer, E12.RawB.Answer>>
        public typealias Right = Paired<Paired<RoutingAddress01, RoutingAddress01>,
            Paired<RoutingAddress01, RoutingAddress10>>
    }

    /// Neither table nor either law is identified by this positive memory.
    public typealias OtherC = BoundaryWorking<RoutingAddress00, RoutingAddress01,
        RoutingAddress00, RoutingAddress11>
    public typealias OtherD = BoundaryWorking<RoutingAddress00, RoutingAddress00,
        RoutingAddress00, RoutingAddress00>
    public typealias OtherForward = PairedProbeInFrame<P.WZ, P.WWZ, OtherC,
        Route00<OtherC>, Route00<OtherC>>
    public typealias OtherEcho = LocalProbeEcho<OtherForward, OtherD,
        Route00<OtherD>, Route00<OtherD>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>>
    public enum SamePositiveMemory: Null {
        public typealias Left = E00.Memory.Answer
        public typealias Right = OtherEcho.Memory.Answer
    }
}
