import VerificationIsIdentification

// J(pi/2) conjugates a Pauli by S and then H. Errors are mathematical
// residuals of actual reports; the executor is never supplied these bits.
public enum ResidentOrientationReply0<F: CoherentBlock>: Close {
    public typealias After = F.ConjugatedS.ConjugatedH
}
public enum ResidentOrientationReply1<F: CoherentBlock>: Close {
    public typealias After = F.ConjugatedS.ConjugatedH.LeftX
}
public enum ResidentOrientationWordRoot: Close {
    public typealias Source = ResidentReporterPolicyRoot
    // The first and last positions receive the requested Z and X angles,
    // in addition to the common pi/2 offset. The middle has only the offset.
    public typealias ZPlacement = Paired<QBit1, Paired<QBit0, QBit0>>
    public typealias XPlacement = Paired<QBit0, Paired<QBit0, QBit1>>
    public typealias E000 = ResidentOrientationReply0<ResidentOrientationReply0<ResidentOrientationReply0<CoherentI<CoherentPhase0>>.After>.After>.After
    public typealias E001 = ResidentOrientationReply1<ResidentOrientationReply0<ResidentOrientationReply0<CoherentI<CoherentPhase0>>.After>.After>.After
    public typealias E010 = ResidentOrientationReply0<ResidentOrientationReply1<ResidentOrientationReply0<CoherentI<CoherentPhase0>>.After>.After>.After
    public typealias E011 = ResidentOrientationReply1<ResidentOrientationReply1<ResidentOrientationReply0<CoherentI<CoherentPhase0>>.After>.After>.After
    public typealias E100 = ResidentOrientationReply0<ResidentOrientationReply0<ResidentOrientationReply1<CoherentI<CoherentPhase0>>.After>.After>.After
    public typealias E101 = ResidentOrientationReply1<ResidentOrientationReply0<ResidentOrientationReply1<CoherentI<CoherentPhase0>>.After>.After>.After
    public typealias E110 = ResidentOrientationReply0<ResidentOrientationReply1<ResidentOrientationReply1<CoherentI<CoherentPhase0>>.After>.After>.After
    public typealias E111 = ResidentOrientationReply1<ResidentOrientationReply1<ResidentOrientationReply1<CoherentI<CoherentPhase0>>.After>.After>.After
}
