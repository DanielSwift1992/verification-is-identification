import VerificationIsIdentification

public enum OuterCycleQuestion: Close {}
public enum InnerCycleQuestion: Close {}

/// Matching indices 0...4 denote M_i; index 5 denotes the spoke matching.
/// Both cycles are read from the actual fifteen-edge source of M64at.
public enum PetersenCycleReadings<A: Structure, B: Structure, C: Structure,
    D: Structure, E: Structure, F: Structure, G: Structure, H: Structure,
    I: Structure, J: Structure, K: Structure, L: Structure, M: Structure,
    N: Structure, O: Structure>: Close {
    public typealias Rows = PetersenContactRows<A, B, C, D, E, F, G, H, I, J, K, L, M, N, O>
    public typealias Source = Rows.Source
    /// Outer edges o_0,...,o_4 are matching pairs 24,03,14,02,13.
    public enum Outer: PredicateReading {
        public typealias Left = Source
        public typealias Right = Paired<Source.Right.Right.Left.Right.Left,
            Paired<Source.Left.Right.Right.Left,
                Paired<Source.Right.Left.Right.Right.Left,
                    Paired<Source.Left.Right.Left, Source.Right.Left.Right.Left>>>>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = OuterCycleQuestion
        public typealias Answer = Right
    }
    /// Inner edges k_0,...,k_4 are matching pairs 34,04,01,12,23.
    public enum Inner: PredicateReading {
        public typealias Left = Source
        public typealias Right = Paired<Source.Right.Right.Right.Left.Left,
            Paired<Source.Left.Right.Right.Right.Left,
                Paired<Source.Left.Left,
                    Paired<Source.Right.Left.Left, Source.Right.Right.Left.Left>>>>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = InnerCycleQuestion
        public typealias Answer = Right
    }
    public typealias Both = JointEvidence<Outer, Inner>
}

/// Four actual applications reduce the five supplied bits. Only the finite
/// parity clauses in WitnessTransfer justify the XOR interpretation used in
/// M64au; an arbitrary reading with the same predicate name is not a law proof.
/// Each intermediate input is the preceding application's actual output.
public enum FiveBitParity<R: PredicateReading, P0: PredicateReading,
    P1: PredicateReading, P2: PredicateReading, P3: PredicateReading>: PredicateReading
where R.Answer: Pair, R.Answer.Right: Pair,
      R.Answer.Right.Right: Pair, R.Answer.Right.Right.Right: Pair,
      R.Answer.Left: Structure, R.Answer.Right.Left: Structure,
      R.Answer.Right.Right.Left: Structure,
      R.Answer.Right.Right.Right.Left: Structure,
      R.Answer.Right.Right.Right.Right: Structure,
      P0.Answer: Pair, P1.Answer: Pair, P2.Answer: Pair, P3.Answer: Pair,
      P0.Answer.Left: Structure, P1.Answer.Left: Structure,
      P2.Answer.Left: Structure, P3.Answer.Left: Structure,
      P0.Left == Paired<R.Answer.Left, R.Answer.Right.Left>,
      P1.Left == Paired<P0.Answer.Left, R.Answer.Right.Right.Left>,
      P2.Left == Paired<P1.Answer.Left, R.Answer.Right.Right.Right.Left>,
      P3.Left == Paired<P2.Answer.Left, R.Answer.Right.Right.Right.Right>,
      R.Sigma == P0.Sigma, R.Sigma == P1.Sigma,
      R.Sigma == P2.Sigma, R.Sigma == P3.Sigma,
      R.Encoding == P0.Encoding, R.Encoding == P1.Encoding,
      R.Encoding == P2.Encoding, R.Encoding == P3.Encoding,
      P0.Predicate == DuplicateParityOperation, P1.Predicate == DuplicateParityOperation,
      P2.Predicate == DuplicateParityOperation, P3.Predicate == DuplicateParityOperation {
    public typealias Left = R.Left
    public typealias Right = P3.Answer.Left
    public typealias Sigma = R.Sigma
    public typealias Encoding = R.Encoding
    public typealias Predicate = R.Predicate
    public typealias Answer = Right
}

/// X on all outer edges, Y on all inner edges, zero on the spokes. Each
/// matching contains two copies of each cycle value and one zero. The two
/// cycles instead contain five copies, giving the independent lost parities.
public typealias UniformPetersenCycles<X: Structure, Y: Structure> =
    PetersenCycleReadings<Y, X, X, Y, Never, Y, X, X, Never, Y, X, Never, Y, Never, Never>

public enum CycleAdmissionCases: Close {
    public typealias Zero = UniformPetersenCycles<Never, Never>
    public typealias OuterOnly = UniformPetersenCycles<Lit1, Never>
    public typealias InnerOnly = UniformPetersenCycles<Never, Lit1>
    public typealias BothCycles = UniformPetersenCycles<Lit1, Lit1>
    public typealias ZeroOuter = FiveBitParity<Zero.Outer,
        EqualPairParity<Never>, EqualPairParity<Never>, EqualPairParity<Never>, EqualPairParity<Never>>
    public typealias ZeroInner = FiveBitParity<Zero.Inner,
        EqualPairParity<Never>, EqualPairParity<Never>, EqualPairParity<Never>, EqualPairParity<Never>>
    public typealias OuterOne = FiveBitParity<OuterOnly.Outer,
        EqualPairParity<Lit1>, ZeroOneParity, EqualPairParity<Lit1>, ZeroOneParity>
    public typealias OuterZero = FiveBitParity<OuterOnly.Inner,
        EqualPairParity<Never>, EqualPairParity<Never>, EqualPairParity<Never>, EqualPairParity<Never>>
    public typealias InnerZero = FiveBitParity<InnerOnly.Outer,
        EqualPairParity<Never>, EqualPairParity<Never>, EqualPairParity<Never>, EqualPairParity<Never>>
    public typealias InnerOne = FiveBitParity<InnerOnly.Inner,
        EqualPairParity<Lit1>, ZeroOneParity, EqualPairParity<Lit1>, ZeroOneParity>
    public typealias BothOuter = FiveBitParity<BothCycles.Outer,
        EqualPairParity<Lit1>, ZeroOneParity, EqualPairParity<Lit1>, ZeroOneParity>
    public typealias BothInner = FiveBitParity<BothCycles.Inner,
        EqualPairParity<Lit1>, ZeroOneParity, EqualPairParity<Lit1>, ZeroOneParity>
    public typealias ZeroChecks = JointEvidence<ZeroOuter, ZeroInner>
    public typealias OuterChecks = JointEvidence<OuterOne, OuterZero>
    public typealias InnerChecks = JointEvidence<InnerZero, InnerOne>
    public typealias BothChecks = JointEvidence<BothOuter, BothInner>

    /// The earlier triangle is the same raw source, not a separately invented
    /// witness. Its outer cycle is odd although all matching parities are zero.
    public typealias Triangle = PetersenCycleReadings<Lit1, Lit1, Never, Never, Never,
        Lit1, Never, Never, Never, Never, Never, Never, Never, Never, Never>
    public typealias TriangleOuter = FiveBitParity<Triangle.Outer,
        EqualPairParity<Never>, EqualPairParity<Never>, ZeroOneParity, OneZeroParity>
    public typealias TriangleInner = FiveBitParity<Triangle.Inner,
        EqualPairParity<Never>, ZeroOneParity, EqualPairParity<Lit1>, EqualPairParity<Never>>
    public typealias TriangleChecks = JointEvidence<TriangleOuter, TriangleInner>
}
