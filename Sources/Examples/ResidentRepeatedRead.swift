import VerificationIsIdentification

public typealias ResidentThreeVotes<A: QuantumBit, B: QuantumBit, C: QuantumBit> = Paired<A, Paired<B, C>>

// The true bit is shared by the three reads. These are the allowed error
// patterns in a stated one-error contract, not a physical noise guarantee.
public enum ResidentRepeatedBranch<B: QuantumBit>: Close {
    public typealias Truth = B
    public typealias NoError = ResidentThreeVotes<B, B, B>
    public typealias FirstWrong = ResidentThreeVotes<B.Flipped, B, B>
    public typealias SecondWrong = ResidentThreeVotes<B, B.Flipped, B>
    public typealias ThirdWrong = ResidentThreeVotes<B, B, B.Flipped>
}

public enum ResidentRepeatedReadRoot: Close {
    public typealias Source = ResidentMeasurementWireRoot
    public typealias Branch0 = ResidentRepeatedBranch<Source.Reply.Left>
    public typealias Branch1 = ResidentRepeatedBranch<Source.Reply.Right>
    // A concrete proposed reading, tested against every source realization.
    // The fields are selected by the acquired votes, never by Truth.
    public typealias Decode = Paired<
        Paired<Paired<QBit0, QBit0>, Paired<QBit0, QBit1>>,
        Paired<Paired<QBit0, QBit1>, Paired<QBit1, QBit1>>>
}
