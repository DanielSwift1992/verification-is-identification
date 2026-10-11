import VerificationIsIdentification

// Four addressed roles, including the still-active fourth participant.
// These are symbolic rearrangements. No coherent physical control is granted.
public enum MovingContactQuadruple<A: Structure, B: Structure, C: Structure, D: Structure>: Pair {
    public typealias Left = DerivedContactTriple<A, B, C>
    public typealias Right = D
    public typealias P = MovingContactQuadruple<B, A, C, D>
    public typealias Q = MovingContactQuadruple<A, C, B, D>
    public typealias T = MovingContactQuadruple<A, B, D, C>
    // A description of the receiver's relative contact, not another primitive.
    public typealias ReceiverQ = MovingContactQuadruple<A, D, C, B>
}

public enum MovingContactTransportLaw<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    public typealias V = MovingContactQuadruple<A, B, C, D>
    public typealias Left = Paired<V.T.T, Paired<V.T.P.T, V.T.Q.T>>
    public typealias Right = Paired<V, Paired<V.P, V.ReceiverQ>>
}
