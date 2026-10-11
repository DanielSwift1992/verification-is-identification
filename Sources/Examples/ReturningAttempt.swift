import VerificationIsIdentification

// A supplied, finite law family. The learner sees B and Parity through actual
// contacts; it is not given Control or Residue. A third available contact can
// read Residue, but it is unnecessary for the present working request.
// Physical instrument semantics
// are established separately by exact operators, not by the names below.
public enum ReturningLawB0<A: QuantumBit, C: QuantumBit>: Close {
    public typealias Control = A
    public typealias ProbeB = QBit0
    public typealias ProbeParity = A
    public typealias Residue = C
}

public enum ReturningLawB1<A: QuantumBit, C: QuantumBit>: Close {
    public typealias Control = A
    public typealias ProbeB = QBit1
    public typealias ProbeParity = A.Flipped
    public typealias Residue = C
}

public enum ReturningAttemptRoot: Close {
    public typealias Row0 = ReturningLawB0<QBit0, QBit0>
    public typealias Row1 = ReturningLawB0<QBit0, QBit1>
    public typealias Row2 = ReturningLawB1<QBit0, QBit0>
    public typealias Row3 = ReturningLawB1<QBit0, QBit1>
    public typealias Row4 = ReturningLawB0<QBit1, QBit0>
    public typealias Row5 = ReturningLawB0<QBit1, QBit1>
    public typealias Row6 = ReturningLawB1<QBit1, QBit0>
    public typealias Row7 = ReturningLawB1<QBit1, QBit1>
}

// These use the existing monitor's computed parity reading. They accept the
// acquired first reply; the second reply selects which constructor is used.
public typealias ReturningControlAfter0<B: QuantumBit> =
    ResidentHistoryLast0<QBit0, B>.Different
public typealias ReturningControlAfter1<B: QuantumBit> =
    ResidentHistoryLast1<QBit0, B>.Different

public enum ReturningReply0<F: QuantumPauli>: Close {
    public typealias Disturbed = F
    public typealias Restored = Disturbed
}

public enum ReturningReply1<F: QuantumPauli>: Close {
    public typealias Disturbed = F.AfterZ
    public typealias Restored = Disturbed.AfterZ
}
