import VerificationIsIdentification

/// The sixteen possible ordered resident replies, through one common
/// coordinate frame. Probe names do not occur in the decoder inputs.
public enum PairedProbeCalibration: Close {
    public typealias P = FourLeafSecondProbe<Never>
    public typealias Frame = BoundaryWorking<RoutingAddress00, RoutingAddress01, RoutingAddress10, RoutingAddress11>
    public typealias E00 = PairedProbeInFrame<P.Z, P.Z, Frame, Route00<Frame>, Route00<Frame>>
    public typealias D00 = PairedProbeDecision<E00, Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>>
    public typealias E01 = PairedProbeInFrame<P.Z, P.I, Frame, Route00<Frame>, Route01<Frame>>
    public typealias D01 = PairedProbeDecision<E01, Route00<PhaseEqualityTable>, Route01<FourLeafPhaseMark0>>
    public typealias E02 = PairedProbeInFrame<P.Z, P.ZW, Frame, Route00<Frame>, Route10<Frame>>
    public typealias D02 = PairedProbeDecision<E02, Route00<PhaseEqualityTable>, Route10<FourLeafPhaseMark0>>
    public typealias E03 = PairedProbeInFrame<P.Z, P.ZWW, Frame, Route00<Frame>, Route11<Frame>>
    public typealias D03 = PairedProbeDecision<E03, Route00<PhaseEqualityTable>, Route11<FourLeafPhaseMark0>>
    public typealias E10 = PairedProbeInFrame<P.I, P.Z, Frame, Route01<Frame>, Route00<Frame>>
    public typealias D10 = PairedProbeDecision<E10, Route01<PhaseEqualityTable>, Route00<FourLeafPhaseMark1>>
    public typealias E11 = PairedProbeInFrame<P.I, P.I, Frame, Route01<Frame>, Route01<Frame>>
    public typealias D11 = PairedProbeDecision<E11, Route01<PhaseEqualityTable>, Route01<FourLeafPhaseMark1>>
    public typealias E12 = PairedProbeInFrame<P.I, P.ZW, Frame, Route01<Frame>, Route10<Frame>>
    public typealias D12 = PairedProbeDecision<E12, Route01<PhaseEqualityTable>, Route10<FourLeafPhaseMark1>>
    public typealias E13 = PairedProbeInFrame<P.I, P.ZWW, Frame, Route01<Frame>, Route11<Frame>>
    public typealias D13 = PairedProbeDecision<E13, Route01<PhaseEqualityTable>, Route11<FourLeafPhaseMark1>>
    public typealias E20 = PairedProbeInFrame<P.ZW, P.Z, Frame, Route10<Frame>, Route00<Frame>>
    public typealias D20 = PairedProbeDecision<E20, Route10<PhaseEqualityTable>, Route00<FourLeafPhaseMark2>>
    public typealias E21 = PairedProbeInFrame<P.ZW, P.I, Frame, Route10<Frame>, Route01<Frame>>
    public typealias D21 = PairedProbeDecision<E21, Route10<PhaseEqualityTable>, Route01<FourLeafPhaseMark2>>
    public typealias E22 = PairedProbeInFrame<P.ZW, P.ZW, Frame, Route10<Frame>, Route10<Frame>>
    public typealias D22 = PairedProbeDecision<E22, Route10<PhaseEqualityTable>, Route10<FourLeafPhaseMark2>>
    public typealias E23 = PairedProbeInFrame<P.ZW, P.ZWW, Frame, Route10<Frame>, Route11<Frame>>
    public typealias D23 = PairedProbeDecision<E23, Route10<PhaseEqualityTable>, Route11<FourLeafPhaseMark2>>
    public typealias E30 = PairedProbeInFrame<P.ZWW, P.Z, Frame, Route11<Frame>, Route00<Frame>>
    public typealias D30 = PairedProbeDecision<E30, Route11<PhaseEqualityTable>, Route00<FourLeafPhaseMark3>>
    public typealias E31 = PairedProbeInFrame<P.ZWW, P.I, Frame, Route11<Frame>, Route01<Frame>>
    public typealias D31 = PairedProbeDecision<E31, Route11<PhaseEqualityTable>, Route01<FourLeafPhaseMark3>>
    public typealias E32 = PairedProbeInFrame<P.ZWW, P.ZW, Frame, Route11<Frame>, Route10<Frame>>
    public typealias D32 = PairedProbeDecision<E32, Route11<PhaseEqualityTable>, Route10<FourLeafPhaseMark3>>
    public typealias E33 = PairedProbeInFrame<P.ZWW, P.ZWW, Frame, Route11<Frame>, Route11<Frame>>
    public typealias D33 = PairedProbeDecision<E33, Route11<PhaseEqualityTable>, Route11<FourLeafPhaseMark3>>
    public enum Verdicts: Null {
        public typealias Left = BoundaryWorking<
            BoundaryWorking<D00.Read.Answer, D01.Read.Answer, D02.Read.Answer, D03.Read.Answer>,
            BoundaryWorking<D10.Read.Answer, D11.Read.Answer, D12.Read.Answer, D13.Read.Answer>,
            BoundaryWorking<D20.Read.Answer, D21.Read.Answer, D22.Read.Answer, D23.Read.Answer>,
            BoundaryWorking<D30.Read.Answer, D31.Read.Answer, D32.Read.Answer, D33.Read.Answer>>
        public typealias Right = PhaseEqualityTable
    }
    // Every one of the twelve resident laws belongs to one of these four
    // actual reply classes. This supports pairing all classes without
    // making 144 copies of the same two-channel composition.
    public enum ReplyClasses: Null {
        public typealias Left = BoundaryWorking<
            AddressTriple<P.Z.Answer.Right, P.WZ.Answer.Right, P.WWZ.Answer.Right>,
            AddressTriple<P.I.Answer.Right, P.W.Answer.Right, P.WW.Answer.Right>,
            AddressTriple<P.ZW.Answer.Right, P.WZW.Answer.Right, P.WWZW.Answer.Right>,
            AddressTriple<P.ZWW.Answer.Right, P.WZWW.Answer.Right, P.WWZWW.Answer.Right>>
        public typealias Right = BoundaryWorking<
            AddressTriple<P.Z.Answer.Right, P.Z.Answer.Right, P.Z.Answer.Right>,
            AddressTriple<P.I.Answer.Right, P.I.Answer.Right, P.I.Answer.Right>,
            AddressTriple<P.ZW.Answer.Right, P.ZW.Answer.Right, P.ZW.Answer.Right>,
            AddressTriple<P.ZWW.Answer.Right, P.ZWW.Answer.Right, P.ZWW.Answer.Right>>
    }

    public typealias UnknownAlternative = PairedProbeInFrame<P.W, P.WW, Frame,
        Route01<Frame>, Route01<Frame>>
    public typealias Alternative = PairedProbeDecision<UnknownAlternative,
        Route01<PhaseEqualityTable>, Route01<FourLeafPhaseMark1>>
    public enum SameAvailablePositiveMemory: Null {
        public typealias Left = D11.Decode.Left
        public typealias Right = Alternative.Decode.Left
    }

    public typealias ChangedFrame = FourLeafPhase0<RoutingAddress00,
        RoutingAddress01, RoutingAddress10, RoutingAddress11>.Right
    public typealias SharedChange = PairedProbeInFrame<P.I, P.Z, ChangedFrame,
        Route01<ChangedFrame>, Route00<ChangedFrame>>
    public typealias SharedDecision = PairedProbeDecision<SharedChange,
        Route00<PhaseEqualityTable>, Route01<FourLeafPhaseMark0>>
    public enum SharedChangeKeepsVerdict: Null {
        public typealias Left = Paired<D10.Read.Answer, SharedDecision.Read.Answer>
        public typealias Right = Paired<Never, Never>
    }
}

/// Both acquired readings use the same resident frame field, with no
/// restriction on its unused entries. Equality of reply class 1 therefore
/// survives before any individual frame calibration.
public enum PairedReplyInUnknownFrame<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    public typealias P = FourLeafSecondProbe<Never>
    public typealias Frame = BoundaryWorking<A, B, C, D>
    public typealias First = PairedProbeInFrame<P.I, P.W, Frame,
        Route01<Frame>, Route01<Frame>>
    public typealias Second = PairedProbeInFrame<P.WW, P.I, Frame,
        Route01<Frame>, Route01<Frame>>
    public typealias Left = Paired<First.Right.Right, First.Right.Right.Answer>
    public typealias Right = Paired<Second.Right.Right, Paired<B, B>>
}
