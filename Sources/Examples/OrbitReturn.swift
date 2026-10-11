import VerificationIsIdentification

// A new, declared coherent access: cycle the two nuisance coordinates while
// retaining the control. The four tags compute their successor; no caller
// supplies a proof that four steps return. Phase/instrument semantics are a
// separate obligation, not implied by these finite address equalities.
public enum OrbitReturn00<A: QuantumBit>: Close {
    public typealias Law = ReturningLawB0<A, QBit0>
    public typealias Next = OrbitReturn01<A>
}

public enum OrbitReturn01<A: QuantumBit>: Close {
    public typealias Law = ReturningLawB0<A, QBit1>
    public typealias Next = OrbitReturn10<A>
}

public enum OrbitReturn10<A: QuantumBit>: Close {
    public typealias Law = ReturningLawB1<A, QBit0>
    public typealias Next = OrbitReturn11<A>
}

public enum OrbitReturn11<A: QuantumBit>: Close {
    public typealias Law = ReturningLawB1<A, QBit1>
    public typealias Next = OrbitReturn00<A>
}

public enum OrbitReturnRoot: Close {
    public typealias Source = ReturningAttemptRoot
    public typealias Row0 = OrbitReturn00<QBit0>
    public typealias Row1 = OrbitReturn01<QBit0>
    public typealias Row2 = OrbitReturn10<QBit0>
    public typealias Row3 = OrbitReturn11<QBit0>
    public typealias Row4 = OrbitReturn00<QBit1>
    public typealias Row5 = OrbitReturn01<QBit1>
    public typealias Row6 = OrbitReturn10<QBit1>
    public typealias Row7 = OrbitReturn11<QBit1>
}
