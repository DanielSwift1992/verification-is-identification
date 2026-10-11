import VerificationIsIdentification

/// A deliberately bounded interpretation: A and B range over QI/QX/QY/QZ,
/// payload action is B T A, desired action T, final question X. These four
/// constructors state the Pauli/T readout law; they do not derive a physical
/// device from type conformance. The independent complex-matrix audit checks
/// this interpretation. Export admits only the sixteen actual rows below.
public enum FiniteTGate: Close {}

public enum FiniteTAI<B: QuantumPauli>: Close {
    public typealias A = QI
    public typealias Second = B
    public typealias Word = Paired<A, Paired<FiniteTGate, B>>
    public typealias AX = A.ForX
    public typealias AY = A.ForY
    public typealias AZ = A.ForZ
    public typealias BX = B.ForX
    public typealias BY = B.ForY
    public typealias BZ = B.ForZ
    public typealias NX = B.ForX
    public typealias NY = B.ForY
    public typealias NZ = B.ForZ
    public typealias CZ = NZ
    public typealias Answer = Paired<QuantumMeasureXQuestion, B.ForX>
}

public enum FiniteTAX<B: QuantumPauli>: Close {
    public typealias A = QX
    public typealias Second = B
    public typealias Word = Paired<A, Paired<FiniteTGate, B>>
    public typealias AX = A.ForX
    public typealias AY = A.ForY
    public typealias AZ = A.ForZ
    public typealias BX = B.ForX
    public typealias BY = B.ForY
    public typealias BZ = B.ForZ
    public typealias NX = B.ForX
    public typealias NY = B.ForY.Flipped
    public typealias NZ = B.ForZ.Flipped
    public typealias CZ = NZ
    public typealias Answer = Paired<QuantumMeasureYQuestion, B.ForY>
}

public enum FiniteTAY<B: QuantumPauli>: Close {
    public typealias A = QY
    public typealias Second = B
    public typealias Word = Paired<A, Paired<FiniteTGate, B>>
    public typealias AX = A.ForX
    public typealias AY = A.ForY
    public typealias AZ = A.ForZ
    public typealias BX = B.ForX
    public typealias BY = B.ForY
    public typealias BZ = B.ForZ
    public typealias NX = B.ForX.Flipped
    public typealias NY = B.ForY
    public typealias NZ = B.ForZ.Flipped
    public typealias CZ = NZ
    public typealias Answer = Paired<QuantumMeasureYQuestion, B.ForY.Flipped>
}

public enum FiniteTAZ<B: QuantumPauli>: Close {
    public typealias A = QZ
    public typealias Second = B
    public typealias Word = Paired<A, Paired<FiniteTGate, B>>
    public typealias AX = A.ForX
    public typealias AY = A.ForY
    public typealias AZ = A.ForZ
    public typealias BX = B.ForX
    public typealias BY = B.ForY
    public typealias BZ = B.ForZ
    public typealias NX = B.ForX.Flipped
    public typealias NY = B.ForY.Flipped
    public typealias NZ = B.ForZ
    public typealias CZ = NZ
    public typealias Answer = Paired<QuantumMeasureXQuestion, B.ForX.Flipped>
}

/// The active finite source, including the fixed target and caller's question.
/// Actual observations and a proposal must bind back to this root. An archive
/// or another independently named source is not an application of this root.
public enum FinitePauliTXSource: Close {
    public typealias Target = FiniteTGate
    public typealias Question = QuantumMeasureXQuestion
    public typealias Row0 = FiniteTAI<QI>
    public typealias Row1 = FiniteTAI<QX>
    public typealias Row2 = FiniteTAI<QY>
    public typealias Row3 = FiniteTAI<QZ>
    public typealias Row4 = FiniteTAX<QI>
    public typealias Row5 = FiniteTAX<QX>
    public typealias Row6 = FiniteTAX<QY>
    public typealias Row7 = FiniteTAX<QZ>
    public typealias Row8 = FiniteTAY<QI>
    public typealias Row9 = FiniteTAY<QX>
    public typealias Row10 = FiniteTAY<QY>
    public typealias Row11 = FiniteTAY<QZ>
    public typealias Row12 = FiniteTAZ<QI>
    public typealias Row13 = FiniteTAZ<QX>
    public typealias Row14 = FiniteTAZ<QY>
    public typealias Row15 = FiniteTAZ<QZ>
}
