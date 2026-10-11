import VerificationIsIdentification

/// An actual T,W,T word, with T the existing exchange 0/1. It moves
/// the input seen at port 1, unlike W alone, which fixes that port.
public enum CycleThroughPhaseProbe<A: Structure, B: Structure,
    C: Structure, D: Structure>: Pair {
    public typealias T = FourLeafPhase0<A, B, C, D>
    public typealias TW = FollowedPair<T, FourLeafPhaseWord<B, A, C, D>>
    public typealias Actual = FollowedPair<TW, FourLeafPhase0<D, A, B, C>>
    public typealias Left = BoundaryWorking<A, B, C, D>
    public typealias Right = BoundaryWorking<A, D, B, C>
    public enum Endpoint: Null {
        public typealias Left = Actual.Right
        public typealias Right = CycleThroughPhaseProbe.Right
    }
}

/// T; read1; T,W,T; read1; T,W,T; read1; T,W.
/// Three acquired facts survive the return of the original point table.
/// T is an explicitly available input exchange, not inferred from W alone.
public enum PhaseProbeExcursion<A: Structure, B: Structure,
    C: Structure, D: Structure>: Pair {
    public typealias Initial = BoundaryWorking<A, B, C, D>
    public typealias Prepare = FourLeafPhase0<A, B, C, D>
    public typealias First = RecordReading<PhaseLawProbe1<Prepare.Right>>
    public typealias F0 = First.Right.Right
    public typealias Cycle1 = CycleThroughPhaseProbe<B, A, C, D>
    public typealias Move1 = StepBeside<Cycle1, F0>
    public typealias Second = RecordReading<PhaseLawProbe1<Cycle1.Right>>
    public typealias F1 = Second.Right.Right
    public typealias Record1 = StepBeside<Second, F0>
    public typealias Cycle2 = CycleThroughPhaseProbe<B, D, A, C>
    public typealias Move2 = StepBeside<StepBeside<Cycle2, F1>, F0>
    public typealias Third = RecordReading<PhaseLawProbe1<Cycle2.Right>>
    public typealias F2 = Third.Right.Right
    public typealias Record2 = StepBeside<StepBeside<Third, F1>, F0>
    public typealias Restore = FollowedPair<FourLeafPhase0<B, C, D, A>,
        FourLeafPhaseWord<C, B, D, A>>
    public typealias Finish = StepBeside<StepBeside<StepBeside<Restore, F2>, F1>, F0>
    public typealias Start = FollowedPair<Prepare, First>
    public typealias Middle = FollowedPair<FollowedPair<Move1, Record1>,
        FollowedPair<Move2, Record2>>
    public typealias Actual = FollowedPair<FollowedPair<Start, Middle>, Finish>
    public typealias Left = Initial
    public typealias Right = Paired<Paired<Paired<Initial, F2>, F1>, F0>
    public enum Endpoint: Null {
        public typealias Left = Actual.Right
        public typealias Right = PhaseProbeExcursion.Right
    }
    public enum ReturnedTable: Null {
        public typealias Left = Actual.Right.Left.Left.Left
        public typealias Right = Initial
    }
    public enum AcquiredPoints: Null {
        public typealias Left = AddressTriple<F0.Answer, F1.Answer, F2.Answer>
        public typealias Right = AddressTriple<A, D, C>
    }
}

/// The existing three-fact projection ignores the returned source. A fixed
/// decoder resource is carried beside the entire experiment, not substituted
/// for an unknown source parameter after observation.
public enum PhaseExcursionMemory<A: Structure, B: Structure,
    C: Structure, D: Structure, R: Structure>: Close {
    public typealias Run = StepBeside<PhaseProbeExcursion<A, B, C, D>, R>
    public typealias Facts = ThreeStageFacts<Run.Right>
    public typealias Resource = SecondEvidenceImage<Run.Right, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Read = JointEvidence<Facts, Resource>
}

/// The unobserved field remains in the returned source but not in memory.
public enum PhaseExcursionMemoryIsLocal<A: Structure, B: Structure,
    C: Structure, D: Structure, E: Structure, R: Structure>: Null {
    public typealias First = PhaseExcursionMemory<A, B, C, D, R>
    public typealias Second = PhaseExcursionMemory<A, E, C, D, R>
    public typealias Left = Paired<First.Read.Answer, First.Read.Predicate>
    public typealias Right = Paired<Second.Read.Answer, Second.Read.Predicate>
}
