import VerificationIsIdentification

// The question is the two coordinates (half, position); nuisance is not part
// of its answer. Contacts have independent definitions. A physical projective
// or coherent realization of these readings is a separate, explicit contract.
public enum CoarseLower<L: QuantumBit, N: QuantumBit>: Close {
    public typealias Question = Paired<QBit0, L>
    public typealias Half = QBit0
    public typealias Low = L
    public typealias High = N
    public typealias Nuisance = N
}

public enum CoarseUpper<L: QuantumBit, N: QuantumBit>: Close {
    public typealias Question = Paired<QBit1, L>
    public typealias Half = QBit1
    public typealias Low = N
    public typealias High = L
    public typealias Nuisance = N
}

public enum CoarseAcquisitionRoot: Close {
    public typealias Row0 = CoarseLower<QBit0, QBit0>
    public typealias Row1 = CoarseLower<QBit0, QBit1>
    public typealias Row2 = CoarseLower<QBit1, QBit0>
    public typealias Row3 = CoarseLower<QBit1, QBit1>
    public typealias Row4 = CoarseUpper<QBit0, QBit0>
    public typealias Row5 = CoarseUpper<QBit0, QBit1>
    public typealias Row6 = CoarseUpper<QBit1, QBit0>
    public typealias Row7 = CoarseUpper<QBit1, QBit1>
}
