import VerificationIsIdentification

/// Actual signed-coordinate words for the four control branches 00,01,10,11.
/// Each branch is generic in all four terms, so its equation can be applied
/// independently to each control block. Complex linear interpretation and
/// the controlled-gate connection are stated in IiS28, not inferred from
/// distinguishable labels. X,Z,N are the existing IiS9 field operations.
public enum BorrowedPhaseBranches<A: Structure, B: Structure, C: Structure, D: Structure>: Close {
    public typealias S = SignedModes<A, B, C, D>
    public typealias I = IdentityReading<S, TwoModeSpace, ModePhaseEncoding>
    public typealias X = ExchangeModes<S>
    public typealias Z = ReverseSecondPhase<S>
    public typealias N = ReverseBothPhases<S>
    public typealias XX = SequentialReading<X, ExchangeModes<X.Answer>>
    public typealias ZZ = SequentialReading<Z, ReverseSecondPhase<Z.Answer>>
    public typealias XZ = SequentialReading<X, ReverseSecondPhase<X.Answer>>
    public typealias ZX = SequentialReading<Z, ExchangeModes<Z.Answer>>
    public typealias XZX = SequentialReading<XZ, ExchangeModes<XZ.Answer>>
    public typealias ZXZ = SequentialReading<ZX, ReverseSecondPhase<ZX.Answer>>
    public typealias XZXZ = SequentialReading<XZX, ReverseSecondPhase<XZX.Answer>>
    public typealias NX = ReverseBothPhases<X.Answer>
    public typealias NZ = ReverseBothPhases<Z.Answer>

    /// CX(A,C), CZ(B,C), CX(A,C), CZ(B,C): only branch 11 has
    /// a common sign on its borrowed modes; the complete action is CZ(A,B).
    public enum Unperturbed: Null {
        public typealias Left = BoundaryWorking<I.Answer, ZZ.Answer, XX.Answer, XZXZ.Answer>
        public typealias Right = BoundaryWorking<S, S, S, N.Answer>
    }

    public typealias ZZZ = SequentialReading<ZZ, ReverseSecondPhase<ZZ.Answer>>
    public typealias XZZ = SequentialReading<XZ, ReverseSecondPhase<XZ.Answer>>
    public typealias XZZX = SequentialReading<XZZ, ExchangeModes<XZZ.Answer>>
    public typealias XZZXZ = SequentialReading<XZZX, ReverseSecondPhase<XZZX.Answer>>
    /// One Z in the central gap. Relative to CZ(A,B) followed by Z(C),
    /// the additional sign is Z(A), even when Z(C) leaves a specimen fixed.
    public enum MidpointZ: Null {
        public typealias Left = BoundaryWorking<Z.Answer, ZZZ.Answer, XZX.Answer, XZZXZ.Answer>
        public typealias Right = BoundaryWorking<Z.Answer, Z.Answer, NZ.Answer, Z.Answer>
    }

    public typealias XXX = SequentialReading<XX, ExchangeModes<XX.Answer>>
    public typealias XZXX = SequentialReading<XZX, ExchangeModes<XZX.Answer>>
    public typealias XZXXZ = SequentialReading<XZXX, ReverseSecondPhase<XZXX.Answer>>
    /// One X in the same gap instead introduces the control sign Z(B).
    public enum MidpointX: Null {
        public typealias Left = BoundaryWorking<X.Answer, ZXZ.Answer, XXX.Answer, XZXXZ.Answer>
        public typealias Right = BoundaryWorking<X.Answer, NX.Answer, X.Answer, X.Answer>
    }

    /// Conjugation by the one-contact prefixes supplies the edge-gap
    /// contrast: XZX=-Z, ZXZ=-X, whereas XXX=X and ZZZ=Z.
    public enum GapRelations: Null {
        public typealias Left = BoundaryWorking<XZX.Answer, ZXZ.Answer, XXX.Answer, ZZZ.Answer>
        public typealias Right = BoundaryWorking<NZ.Answer, NX.Answer, X.Answer, Z.Answer>
    }
}
