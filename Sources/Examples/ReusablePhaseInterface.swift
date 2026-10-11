import VerificationIsIdentification

public enum WorkingPhaseQuestion: Close {}
public enum InterfaceFirstPhaseOperation: Close {}
public enum InterfaceWOperation: Close {}

/// A transparent representation of a supplied pair path with an operation
/// address. This adapter alone makes no semantic or refinement claim.
public enum PhasePathReading<P: Pair, O>: PredicateReading {
    public typealias Left = P.Left
    public typealias Right = P.Right
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = O
    public typealias Answer = Right
}

/// The interface sees only working data at call boundaries. Clock and
/// auxiliary data remain in the complete source, outside this projection.
public enum WorkingPhaseReading<S: Pair>: PredicateReading
where S.Left: Pair {
    public typealias Outer = FirstEvidenceImage<S, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Inner = FirstEvidenceImage<S.Left, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Actual = FollowedPair<Outer, Inner>
    public typealias Left = S
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = WorkingPhaseQuestion
    public typealias Answer = Right
}

/// Three generic commuting squares for the nine-contact path. Callers
/// provide only eight arbitrary payloads; no endpoint equality is assumed.
public enum UnobservedInterfaceSquares<A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure, G: Structure, H: Structure>: Close {
    public typealias M = UnobservedClockInterface<A, B, C, D, E, F, G, H>
    public typealias Image = PhasePathReading<PhaseAlignmentObstruction<A, B, C, D>.Q1,
        InterfaceFirstPhaseOperation>

    public enum Zero: CommutingTransition {
        public typealias SourceStep = PhasePathReading<M.AtZero, InterfaceFirstPhaseOperation>
        public typealias ImageStep = Image
        public typealias Left = WorkingPhaseReading<SourceStep.Left>
        public typealias Right = WorkingPhaseReading<SourceStep.Right>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Operation = InterfaceFirstPhaseOperation
    }
    public enum One: CommutingTransition {
        public typealias SourceStep = PhasePathReading<M.AtOne, InterfaceFirstPhaseOperation>
        public typealias ImageStep = Image
        public typealias Left = WorkingPhaseReading<SourceStep.Left>
        public typealias Right = WorkingPhaseReading<SourceStep.Right>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Operation = InterfaceFirstPhaseOperation
    }
    public enum Two: CommutingTransition {
        public typealias SourceStep = PhasePathReading<M.AtTwo, InterfaceFirstPhaseOperation>
        public typealias ImageStep = Image
        public typealias Left = WorkingPhaseReading<SourceStep.Left>
        public typealias Right = WorkingPhaseReading<SourceStep.Right>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Operation = InterfaceFirstPhaseOperation
    }
}

public enum WorkingInterfaceSquare<A: Structure, B: Structure, C: Structure, D: Structure,
    K: Structure, P: Structure>: CommutingTransition {
    public typealias SourceStep = PhasePathReading<WorkingPhaseW<A, B, C, D, K, P>, InterfaceWOperation>
    public typealias ImageStep = PhasePathReading<FourLeafPhaseWord<A, B, C, D>, InterfaceWOperation>
    public typealias Left = WorkingPhaseReading<SourceStep.Left>
    public typealias Right = WorkingPhaseReading<SourceStep.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Operation = InterfaceWOperation
}

/// The actual output of each clause supplies a new generic instance. M and
/// W share one closed carrier; no new reserve, preparation, or fact is added.
/// JoinedTransition is the existing general finite-composition constructor.
public enum ReusablePhaseInterface<A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure, G: Structure, H: Structure>: Close {
    public typealias Clock = PhaseBridgeClock
    public typealias Aux = BoundaryWorking<E, F, G, H>
    public typealias ChangedAux = BoundaryWorking<F, G, E, H>
    public typealias M = UnobservedInterfaceSquares<A, B, C, D, E, F, G, H>
    public typealias Next = UnobservedInterfaceSquares<B, C, A, D, E, F, G, H>
    public typealias NextChanged = UnobservedInterfaceSquares<B, C, A, D, F, G, E, H>

    public typealias MMZero = JoinedTransition<M.Zero, Next.One>
    public typealias MMOne = JoinedTransition<M.One, Next.Two>
    public typealias MMTwo = JoinedTransition<M.Two, NextChanged.Zero>

    public typealias MWZero = JoinedTransition<M.Zero,
        WorkingInterfaceSquare<B, C, A, D, Clock.One, Aux>>
    public typealias MWOne = JoinedTransition<M.One,
        WorkingInterfaceSquare<B, C, A, D, Clock.Two, Aux>>
    public typealias MWTwo = JoinedTransition<M.Two,
        WorkingInterfaceSquare<B, C, A, D, Clock.Zero, ChangedAux>>

    public typealias AfterW = UnobservedInterfaceSquares<D, B, A, C, E, F, G, H>
    public typealias WMZero = JoinedTransition<WorkingInterfaceSquare<A, B, C, D, Clock.Zero, Aux>, AfterW.Zero>
    public typealias WMOne = JoinedTransition<WorkingInterfaceSquare<A, B, C, D, Clock.One, Aux>, AfterW.One>
    public typealias WMTwo = JoinedTransition<WorkingInterfaceSquare<A, B, C, D, Clock.Two, Aux>, AfterW.Two>

    public typealias Third = UnobservedInterfaceSquares<C, A, B, D, E, F, G, H>
    public typealias ThirdChanged = UnobservedInterfaceSquares<C, A, B, D, F, G, E, H>
    public typealias CubeZero = JoinedTransition<MMZero, Third.Two>
    public typealias CubeOne = JoinedTransition<MMOne, ThirdChanged.Zero>
    public typealias CubeTwo = JoinedTransition<MMTwo, ThirdChanged.One>

    public enum CubeWholeOutputs: Null {
        public typealias Left = Paired<CubeZero.SourceStep.Answer,
            Paired<CubeOne.SourceStep.Answer, CubeTwo.SourceStep.Answer>>
        public typealias Right = Paired<
            PhaseInterfaceWorld<A, B, C, D, F, G, E, H, Clock.Zero>,
            Paired<PhaseInterfaceWorld<A, B, C, D, F, G, E, H, Clock.One>,
                PhaseInterfaceWorld<A, B, C, D, F, G, E, H, Clock.Two>>>
    }
    public enum CubeWorkingReturn: Null {
        public typealias Left = Paired<CubeZero.Right.Answer,
            Paired<CubeOne.Right.Answer, CubeTwo.Right.Answer>>
        public typealias Initial = BoundaryWorking<A, B, C, D>
        public typealias Right = Paired<Initial, Paired<Initial, Initial>>
    }
}
