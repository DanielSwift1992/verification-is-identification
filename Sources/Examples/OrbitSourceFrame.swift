import VerificationIsIdentification

// A constructed exchange of two existing coordinates. This describes the
// address relation; an actual coherent Swap implementing it is a separate
// declared access, checked by the operator/QPY realization.
public enum OrbitCoordinateExchange<B: Structure, C: Structure>: Close {
    public typealias Before = Paired<B, C>
    public typealias After = Paired<C, B>
    public typealias Reversed = OrbitCoordinateExchange<C, B>
}
