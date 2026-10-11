import VerificationIsIdentification

// These are support labels for a constructed contact, not claims about an
// arbitrary opaque instrument. The SDK construction measures M, flips it,
// and gives the unspecified payload operation access only to E.
// Payload names a port, not a quantum state claimed unchanged by that action.
public enum ResidentSupportedAt0<Payload: Close>: Close {
    public typealias Reply = QBit0
    public typealias After = ResidentSupportedAt1<Payload>
    public typealias PayloadPort = Payload
}

public enum ResidentSupportedAt1<Payload: Close>: Close {
    public typealias Reply = QBit1
    public typealias After = ResidentSupportedAt0<Payload>
    public typealias PayloadPort = Payload
}

public enum ResidentSupportedContactRoot: Close {
    public typealias Source = ResidentCompletionRoot
    public typealias PayloadPort = Source.Contact.Left
    public typealias SelectorPort = Source.RetainedMemory
    public typealias At0 = ResidentSupportedAt0<PayloadPort>
    public typealias At1 = ResidentSupportedAt1<PayloadPort>
    public typealias First0 = Source.Acquired0
    public typealias First1 = Source.Acquired1
    // Applicability requires the next actual reply to be Atb.After.Reply.
    // The source monitor itself supplies the resulting goal and relative bit.
    public typealias Next0 = ResidentFirstAfter1<First0.Relative, First0.First>
    public typealias Next1 = ResidentFirstAfter0<First1.Relative, First1.First>
    public typealias Completed0 = ResidentCompletionFlag<Next0.After>
    public typealias Completed1 = ResidentCompletionFlag<Next1.After>
}
