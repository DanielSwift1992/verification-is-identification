import VerificationIsIdentification

/// Replace twelve calibration observations by the sufficient nine. The
/// raw probes, query profiles, comparison clauses and payloads are shared.
/// Referencing the earlier declarations does not execute their calibration.
public enum SparseContactProfileExperiment<K: Structure, A: Structure, B: Structure>: Close {
    public typealias Full = ContactProfileExperiment<K, A, B>
    public typealias H = Full.Family
    public typealias Reading = NineContactProfileReadings<H.A, H.B, H.CImage, H.DImage>
    public typealias DifferentCalibration = ReadResidentContactProfiles<Full.Different.Left, Reading>
    public typealias EqualCalibration = ReadResidentContactProfiles<Full.Equal.Left, Reading>
    public typealias DifferentAcquired = AcquireContactProfileComparison<Full.Different,
        DifferentCalibration, Full.DifferentProfiles>
    public typealias EqualAcquired = AcquireContactProfileComparison<Full.Equal,
        EqualCalibration, Full.EqualProfiles>
    public typealias DifferentDecision = ContactProfileDecision<
        AcceptedSparseContactProfiles<DifferentAcquired.Right.Left.Right>,
        DifferentAcquired.Right.Right, Full.DifferentCompare,
        LocalPolicyAtZero<Full.Payloads>, Full.Payloads>
    public typealias EqualDecision = ContactProfileDecision<
        AcceptedSparseContactProfiles<EqualAcquired.Right.Left.Right>,
        EqualAcquired.Right.Right, Full.EqualCompare,
        LocalPolicyAtOne<Full.Payloads>, Full.Payloads>
    public typealias DifferentApplied = ApplyContactProfileDecision<DifferentAcquired,
        DifferentDecision, Full.Payloads>
    public typealias EqualApplied = ApplyContactProfileDecision<EqualAcquired,
        EqualDecision, Full.Payloads>
    public enum SameQueryFacts: Null {
        public typealias Left = Paired<DifferentAcquired.Right.Right, EqualAcquired.Right.Right>
        public typealias Right = Paired<Full.DifferentFact, Full.EqualFact>
    }
    public enum SameChosenPayloads: Null {
        public typealias Left = Paired<DifferentApplied.Right.Right.Answer, EqualApplied.Right.Right.Answer>
        public typealias Right = Paired<A, B>
    }
    public enum KeepsBothPayloads: Null {
        public typealias Left = Paired<DifferentApplied.Right.Left.Right.Right,
            EqualApplied.Right.Left.Right.Right>
        public typealias Right = Paired<Full.Payloads, Full.Payloads>
    }
}
