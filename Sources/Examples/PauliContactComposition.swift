import VerificationIsIdentification

/// Left multiplication by the second Pauli, on the actual residual after
/// the middle word conjugates the first Pauli. Frames quotient global phase;
/// signed ideal observables are tracked separately by CoherentBlock.
/// These four constructors are reductions used by the verifier. The executor
/// always calls its unknown B module, never a row-selected replacement gate.
public enum PauliContactI<F: QuantumPauli>: Pair {
    public typealias Left = Paired<QI, F>
    public typealias Right = F
}

public enum PauliContactX<F: QuantumPauli>: Pair {
    public typealias Left = Paired<QX, F>
    public typealias Right = F.AfterH.AfterZ.AfterH
}

public enum PauliContactY<F: QuantumPauli>: Pair {
    public typealias Left = Paired<QY, F>
    public typealias Right = F.AfterZ.AfterH.AfterZ.AfterH
}

public enum PauliContactZ<F: QuantumPauli>: Pair {
    public typealias Left = Paired<QZ, F>
    public typealias Right = F.AfterZ
}
