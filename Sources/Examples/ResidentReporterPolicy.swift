import VerificationIsIdentification

// Candidate readings of three actual reports. No probability or device
// correctness is asserted by these tables. Their applicability is a separate
// question about acquired report likelihoods.
public enum ResidentReporterPolicyRoot: Close {
    public typealias Source = ResidentRepeatedReadRoot.Source
    public typealias Report = Source.Reply
    public typealias AnyOne = Paired<
        Paired<Paired<QBit0, QBit1>, Paired<QBit1, QBit1>>,
        Paired<Paired<QBit1, QBit1>, Paired<QBit1, QBit1>>>
    public typealias Majority = ResidentRepeatedReadRoot.Decode
    public typealias AllOne = Paired<
        Paired<Paired<QBit0, QBit0>, Paired<QBit0, QBit0>>,
        Paired<Paired<QBit0, QBit0>, Paired<QBit0, QBit1>>>
}
