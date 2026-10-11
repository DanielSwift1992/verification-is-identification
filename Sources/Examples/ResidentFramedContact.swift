import VerificationIsIdentification

// Outer Left is the raw meter record; Right is the actual post-write PC.
// The first/second branch refers to the eigenvalue record of the service
// probe. It is not an extra answer supplied to the working executor.
public enum ResidentFramedRow<P: QuantumBit, C: QuantumBit>: Close {
    public typealias Input = Paired<P, C>
    public typealias Program0 = Paired<P, Paired<P, C>>
    public typealias Program1 = Paired<P.Flipped, Paired<P.Flipped, C>>
    public typealias Clock0 = Paired<C, Paired<C, C>>
    public typealias Clock1 = Paired<C.Flipped, Paired<C.Flipped, C>>
    // An exported relative question uses this post-write pair. Its answer
    // requires an actual joint PC-parity acquisition in the SDK semantics.
    public typealias ProgramReturn0 = Program0.Right
    public typealias ProgramReturn1 = Program1.Right
    public typealias ClockReturn0 = Clock0.Right
    public typealias ClockReturn1 = Clock1.Right
}

public enum ResidentFramedRoot: Close {
    public typealias Service = ResidentClassicalRoot
    public typealias Row00 = ResidentFramedRow<QBit0, QBit0>
    public typealias Row01 = ResidentFramedRow<QBit0, QBit1>
    public typealias Row10 = ResidentFramedRow<QBit1, QBit0>
    public typealias Row11 = ResidentFramedRow<QBit1, QBit1>
}
