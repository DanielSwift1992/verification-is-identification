import VerificationIsIdentification

/// Equality survives both generating output-frame changes on every pair
/// of resident reply classes. Composition gives every finite word of them.
public enum CommonProbeFrameGenerators: Close {
    public typealias P = FourLeafSecondProbe<Never>
    public typealias T = FourLeafPhase0<RoutingAddress00, RoutingAddress01, RoutingAddress10, RoutingAddress11>.Right
    public typealias W = FourLeafPhaseWord<RoutingAddress00, RoutingAddress01, RoutingAddress10, RoutingAddress11>.Right
    public typealias ET00 = PairedProbeInFrame<P.Z, P.Z, T, Route00<T>, Route00<T>>
    public typealias DT00 = PairedProbeDecision<ET00, Route01<PhaseEqualityTable>, Route01<FourLeafPhaseMark1>>
    public typealias ET01 = PairedProbeInFrame<P.Z, P.I, T, Route00<T>, Route01<T>>
    public typealias DT01 = PairedProbeDecision<ET01, Route01<PhaseEqualityTable>, Route00<FourLeafPhaseMark1>>
    public typealias ET02 = PairedProbeInFrame<P.Z, P.ZW, T, Route00<T>, Route10<T>>
    public typealias DT02 = PairedProbeDecision<ET02, Route01<PhaseEqualityTable>, Route10<FourLeafPhaseMark1>>
    public typealias ET03 = PairedProbeInFrame<P.Z, P.ZWW, T, Route00<T>, Route11<T>>
    public typealias DT03 = PairedProbeDecision<ET03, Route01<PhaseEqualityTable>, Route11<FourLeafPhaseMark1>>
    public typealias ET10 = PairedProbeInFrame<P.I, P.Z, T, Route01<T>, Route00<T>>
    public typealias DT10 = PairedProbeDecision<ET10, Route00<PhaseEqualityTable>, Route01<FourLeafPhaseMark0>>
    public typealias ET11 = PairedProbeInFrame<P.I, P.I, T, Route01<T>, Route01<T>>
    public typealias DT11 = PairedProbeDecision<ET11, Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>>
    public typealias ET12 = PairedProbeInFrame<P.I, P.ZW, T, Route01<T>, Route10<T>>
    public typealias DT12 = PairedProbeDecision<ET12, Route00<PhaseEqualityTable>, Route10<FourLeafPhaseMark0>>
    public typealias ET13 = PairedProbeInFrame<P.I, P.ZWW, T, Route01<T>, Route11<T>>
    public typealias DT13 = PairedProbeDecision<ET13, Route00<PhaseEqualityTable>, Route11<FourLeafPhaseMark0>>
    public typealias ET20 = PairedProbeInFrame<P.ZW, P.Z, T, Route10<T>, Route00<T>>
    public typealias DT20 = PairedProbeDecision<ET20, Route10<PhaseEqualityTable>, Route01<FourLeafPhaseMark2>>
    public typealias ET21 = PairedProbeInFrame<P.ZW, P.I, T, Route10<T>, Route01<T>>
    public typealias DT21 = PairedProbeDecision<ET21, Route10<PhaseEqualityTable>, Route00<FourLeafPhaseMark2>>
    public typealias ET22 = PairedProbeInFrame<P.ZW, P.ZW, T, Route10<T>, Route10<T>>
    public typealias DT22 = PairedProbeDecision<ET22, Route10<PhaseEqualityTable>, Route10<FourLeafPhaseMark2>>
    public typealias ET23 = PairedProbeInFrame<P.ZW, P.ZWW, T, Route10<T>, Route11<T>>
    public typealias DT23 = PairedProbeDecision<ET23, Route10<PhaseEqualityTable>, Route11<FourLeafPhaseMark2>>
    public typealias ET30 = PairedProbeInFrame<P.ZWW, P.Z, T, Route11<T>, Route00<T>>
    public typealias DT30 = PairedProbeDecision<ET30, Route11<PhaseEqualityTable>, Route01<FourLeafPhaseMark3>>
    public typealias ET31 = PairedProbeInFrame<P.ZWW, P.I, T, Route11<T>, Route01<T>>
    public typealias DT31 = PairedProbeDecision<ET31, Route11<PhaseEqualityTable>, Route00<FourLeafPhaseMark3>>
    public typealias ET32 = PairedProbeInFrame<P.ZWW, P.ZW, T, Route11<T>, Route10<T>>
    public typealias DT32 = PairedProbeDecision<ET32, Route11<PhaseEqualityTable>, Route10<FourLeafPhaseMark3>>
    public typealias ET33 = PairedProbeInFrame<P.ZWW, P.ZWW, T, Route11<T>, Route11<T>>
    public typealias DT33 = PairedProbeDecision<ET33, Route11<PhaseEqualityTable>, Route11<FourLeafPhaseMark3>>
    public enum PreservesT: Null {
        public typealias Left = BoundaryWorking<
            BoundaryWorking<DT00.Read.Answer, DT01.Read.Answer, DT02.Read.Answer, DT03.Read.Answer>,
            BoundaryWorking<DT10.Read.Answer, DT11.Read.Answer, DT12.Read.Answer, DT13.Read.Answer>,
            BoundaryWorking<DT20.Read.Answer, DT21.Read.Answer, DT22.Read.Answer, DT23.Read.Answer>,
            BoundaryWorking<DT30.Read.Answer, DT31.Read.Answer, DT32.Read.Answer, DT33.Read.Answer>>
        public typealias Right = PairedProbeCalibration.Verdicts.Left
    }
    public typealias EW00 = PairedProbeInFrame<P.Z, P.Z, W, Route00<W>, Route00<W>>
    public typealias DW00 = PairedProbeDecision<EW00, Route11<PhaseEqualityTable>, Route11<FourLeafPhaseMark3>>
    public typealias EW01 = PairedProbeInFrame<P.Z, P.I, W, Route00<W>, Route01<W>>
    public typealias DW01 = PairedProbeDecision<EW01, Route11<PhaseEqualityTable>, Route01<FourLeafPhaseMark3>>
    public typealias EW02 = PairedProbeInFrame<P.Z, P.ZW, W, Route00<W>, Route10<W>>
    public typealias DW02 = PairedProbeDecision<EW02, Route11<PhaseEqualityTable>, Route00<FourLeafPhaseMark3>>
    public typealias EW03 = PairedProbeInFrame<P.Z, P.ZWW, W, Route00<W>, Route11<W>>
    public typealias DW03 = PairedProbeDecision<EW03, Route11<PhaseEqualityTable>, Route10<FourLeafPhaseMark3>>
    public typealias EW10 = PairedProbeInFrame<P.I, P.Z, W, Route01<W>, Route00<W>>
    public typealias DW10 = PairedProbeDecision<EW10, Route01<PhaseEqualityTable>, Route11<FourLeafPhaseMark1>>
    public typealias EW11 = PairedProbeInFrame<P.I, P.I, W, Route01<W>, Route01<W>>
    public typealias DW11 = PairedProbeDecision<EW11, Route01<PhaseEqualityTable>, Route01<FourLeafPhaseMark1>>
    public typealias EW12 = PairedProbeInFrame<P.I, P.ZW, W, Route01<W>, Route10<W>>
    public typealias DW12 = PairedProbeDecision<EW12, Route01<PhaseEqualityTable>, Route00<FourLeafPhaseMark1>>
    public typealias EW13 = PairedProbeInFrame<P.I, P.ZWW, W, Route01<W>, Route11<W>>
    public typealias DW13 = PairedProbeDecision<EW13, Route01<PhaseEqualityTable>, Route10<FourLeafPhaseMark1>>
    public typealias EW20 = PairedProbeInFrame<P.ZW, P.Z, W, Route10<W>, Route00<W>>
    public typealias DW20 = PairedProbeDecision<EW20, Route00<PhaseEqualityTable>, Route11<FourLeafPhaseMark0>>
    public typealias EW21 = PairedProbeInFrame<P.ZW, P.I, W, Route10<W>, Route01<W>>
    public typealias DW21 = PairedProbeDecision<EW21, Route00<PhaseEqualityTable>, Route01<FourLeafPhaseMark0>>
    public typealias EW22 = PairedProbeInFrame<P.ZW, P.ZW, W, Route10<W>, Route10<W>>
    public typealias DW22 = PairedProbeDecision<EW22, Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>>
    public typealias EW23 = PairedProbeInFrame<P.ZW, P.ZWW, W, Route10<W>, Route11<W>>
    public typealias DW23 = PairedProbeDecision<EW23, Route00<PhaseEqualityTable>, Route10<FourLeafPhaseMark0>>
    public typealias EW30 = PairedProbeInFrame<P.ZWW, P.Z, W, Route11<W>, Route00<W>>
    public typealias DW30 = PairedProbeDecision<EW30, Route10<PhaseEqualityTable>, Route11<FourLeafPhaseMark2>>
    public typealias EW31 = PairedProbeInFrame<P.ZWW, P.I, W, Route11<W>, Route01<W>>
    public typealias DW31 = PairedProbeDecision<EW31, Route10<PhaseEqualityTable>, Route01<FourLeafPhaseMark2>>
    public typealias EW32 = PairedProbeInFrame<P.ZWW, P.ZW, W, Route11<W>, Route10<W>>
    public typealias DW32 = PairedProbeDecision<EW32, Route10<PhaseEqualityTable>, Route00<FourLeafPhaseMark2>>
    public typealias EW33 = PairedProbeInFrame<P.ZWW, P.ZWW, W, Route11<W>, Route11<W>>
    public typealias DW33 = PairedProbeDecision<EW33, Route10<PhaseEqualityTable>, Route10<FourLeafPhaseMark2>>
    public enum PreservesW: Null {
        public typealias Left = BoundaryWorking<
            BoundaryWorking<DW00.Read.Answer, DW01.Read.Answer, DW02.Read.Answer, DW03.Read.Answer>,
            BoundaryWorking<DW10.Read.Answer, DW11.Read.Answer, DW12.Read.Answer, DW13.Read.Answer>,
            BoundaryWorking<DW20.Read.Answer, DW21.Read.Answer, DW22.Read.Answer, DW23.Read.Answer>,
            BoundaryWorking<DW30.Read.Answer, DW31.Read.Answer, DW32.Read.Answer, DW33.Read.Answer>>
        public typealias Right = PairedProbeCalibration.Verdicts.Left
    }
}
