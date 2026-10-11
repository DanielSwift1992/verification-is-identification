import VerificationIsIdentification

/// A two-code comparator is pulled back along q=(0 1 2) on its first
/// argument. The actual catalogue push word WWZ supplies that pullback;
/// ZW reverses it. Both prepared probes retain their fresh answer while
/// returning the whole comparator table. The codes themselves are free.
public enum TripleOrientationContact<A: Structure, B: Structure>: Close {
    public typealias C = TwoOrbitReadout<A, B>
    public typealias Words = PhaseWordCatalogue<C.R0, C.R1, C.R2, C.R3>
    public typealias Move = Words.WWZ
    public typealias Q = Move.Right
    public typealias Q0 = Q.Left.Left
    public typealias Q1 = Q.Left.Right
    public typealias Q2 = Q.Right.Left
    public typealias Q3 = Q.Right.Right
    public typealias ForwardProbe = SequentialReading<PhaseLawProbe0<Q>, PhaseLawProbe1<Q0>>
    public typealias ReverseProbe = SequentialReading<PhaseLawProbe1<Q>, PhaseLawProbe0<Q1>>
    public typealias ForwardRecord = RecordReading<ForwardProbe>
    public typealias ReverseRecord = RecordReading<ReverseProbe>
    public typealias ReturningWords = PhaseWordCatalogue<Q0, Q1, Q2, Q3>
    public typealias Back = ReturningWords.ZW
    public typealias ForwardPath = FollowedPair<FollowedPair<Move, ForwardRecord>,
        StepBeside<Back, ForwardRecord.Right.Right>>
    public typealias ReversePath = FollowedPair<FollowedPair<Move, ReverseRecord>,
        StepBeside<Back, ReverseRecord.Right.Right>>

    public enum ReturnedTableAndAcquiredAnswers: Null {
        public typealias Left = Paired<Paired<ForwardPath.Right.Left, ReversePath.Right.Left>,
            Paired<ForwardPath.Right.Right.Answer, ReversePath.Right.Right.Answer>>
        public typealias Right = Paired<Paired<C.Table, C.Table>, Paired<A, B>>
    }

    /// Relabel both positions by T=(0 1). This acts on the argument
    /// slots of C(qx,y), hence conjugates its effective contact q.
    public typealias T0 = FourLeafPhase0<Q0.Left.Left, Q0.Left.Right, Q0.Right.Left, Q0.Right.Right>.Right
    public typealias T1 = FourLeafPhase0<Q1.Left.Left, Q1.Left.Right, Q1.Right.Left, Q1.Right.Right>.Right
    public typealias T2 = FourLeafPhase0<Q2.Left.Left, Q2.Left.Right, Q2.Right.Left, Q2.Right.Right>.Right
    public typealias T3 = FourLeafPhase0<Q3.Left.Left, Q3.Left.Right, Q3.Right.Left, Q3.Right.Right>.Right
    public typealias Reflected = FourLeafPhase0<T0, T1, T2, T3>.Right
    public enum ReflectionConjugatesTheContact: Null {
        public typealias Left = Reflected
        public typealias Right = Words.ZW.Right
    }
}
