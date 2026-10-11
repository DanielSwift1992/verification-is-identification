import VerificationIsIdentification

/// The original question concerns the two raw reply positions. Its local
/// realization compares acquired image profiles and selects a resident
/// payload. K is never an input of that comparison procedure.
public enum ContactProfileExperiment<K: Structure, A: Structure, B: Structure>: Close {
    public typealias Family = ContactProfileFamily<Never, Never, K>
    public typealias Probe = FourLeafSecondProbe<Never>
    public typealias Payloads = Paired<A, B>

    public typealias Different = PairedProbeInFrame<Probe.I, Probe.ZWW,
        Family.Images, Route01<Family.Images>, Route11<Family.Images>>
    public typealias Equal = PairedProbeInFrame<Probe.I, Probe.W,
        Family.Images, Route01<Family.Images>, Route01<Family.Images>>
    public typealias DifferentCalibration = ReadResidentContactProfiles<Different.Left, Family.Read>
    public typealias EqualCalibration = ReadResidentContactProfiles<Equal.Left, Family.Read>
    public typealias DifferentProfiles = PairedApplication<ContactProfile<Family.B>, ContactProfile<Family.DImage>>
    public typealias EqualProfiles = PairedApplication<ContactProfile<Family.B>, ContactProfile<Family.B>>
    public typealias DifferentAcquired = AcquireContactProfileComparison<Different,
        DifferentCalibration, DifferentProfiles>
    public typealias EqualAcquired = AcquireContactProfileComparison<Equal,
        EqualCalibration, EqualProfiles>
    public typealias DifferentFact = DifferentAcquired.Right.Right
    public typealias EqualFact = EqualAcquired.Right.Right
    public typealias DifferentCompare = CompareContactProfiles<DifferentFact,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route01<ContactProfileBitEquality>, Route10<ContactProfileBoth>>
    public typealias EqualCompare = CompareContactProfiles<EqualFact,
        Route00<PhaseEqualityTable>, Route00<FourLeafPhaseMark0>,
        Route00<ContactProfileBitEquality>, Route11<ContactProfileBoth>>
    public typealias DifferentDecision = ContactProfileDecision<AcceptedContactProfiles<DifferentAcquired.Right.Left.Right>,
        DifferentFact, DifferentCompare, LocalPolicyAtZero<Payloads>, Payloads>
    public typealias EqualDecision = ContactProfileDecision<AcceptedContactProfiles<EqualAcquired.Right.Left.Right>,
        EqualFact, EqualCompare, LocalPolicyAtOne<Payloads>, Payloads>
    public typealias DifferentApplied = ApplyContactProfileDecision<DifferentAcquired,
        DifferentDecision, Payloads>
    public typealias EqualApplied = ApplyContactProfileDecision<EqualAcquired,
        EqualDecision, Payloads>

    public enum RawQuestion: Null {
        public typealias Left = AddressTriple<Probe.I.Answer.Right.Answer,
            Probe.W.Answer.Right.Answer, Probe.ZWW.Answer.Right.Answer>
        public typealias Right = AddressTriple<RoutingAddress01, RoutingAddress01, RoutingAddress11>
    }
    public enum BothComparisons: Null {
        public typealias Left = Paired<DifferentCompare.Answer, EqualCompare.Answer>
        public typealias Right = Paired<Never, Lit1>
    }
    public enum ChosenPayloads: Null {
        public typealias Left = Paired<DifferentApplied.Right.Right.Answer,
            EqualApplied.Right.Right.Answer>
        public typealias Right = Payloads
    }
    public enum KeepsBothPayloads: Null {
        public typealias Left = Paired<DifferentApplied.Right.Left.Right.Right,
            EqualApplied.Right.Left.Right.Right>
        public typealias Right = Paired<Payloads, Payloads>
    }
    public enum TwoObservationsAgree: Null {
        public typealias Left = Paired<DifferentFact.Answer.Left.Left,
            DifferentFact.Answer.Left.Right.Left>
        public typealias Right = Paired<DifferentFact.Answer.Right.Left,
            DifferentFact.Answer.Right.Right.Left>
    }
    public enum ThirdObservationSeparates: Null {
        public typealias Left = Paired<DifferentFact.Answer.Left.Right.Right,
            DifferentFact.Answer.Right.Right.Right>
        public typealias Right = Paired<Never, Lit1>
    }
}

/// A change of complete unread tails changes neither acquired fact nor the
/// full local procedure/input, including the two resident payloads.
public enum ContactProfileTailChange<K: Structure, L: Structure,
    A: Structure, B: Structure>: Null {
    public typealias Old = ContactProfileExperiment<K, A, B>
    public typealias New = ContactProfileExperiment<L, A, B>
    public typealias Left = Paired<Old.DifferentDecision.Left, Old.EqualDecision.Left>
    public typealias Right = Paired<New.DifferentDecision.Left, New.EqualDecision.Left>
}
