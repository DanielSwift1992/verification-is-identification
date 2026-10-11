import VerificationIsIdentification

/// P = Q Q W Q Q Q Q on one working register and the actual shared clock.
/// All three clauses follow this same fixed schedule. P returns the clock
/// and has phase action w q^2, independently of its initial clock.
public enum PrimitivePhaseReturnCore<A: Structure, B: Structure,
    C: Structure, D: Structure>: Close {
    public typealias Clock = PhaseBridgeClock

    public typealias ZeroQQ = FollowedPair<PhaseCyclingContacts<A, B, C, D>.AtZero,
        PhaseCyclingContacts<B, C, A, D>.AtOne>
    public typealias ZeroW = PairedApplication<FourLeafPhaseWord<C, A, B, D>,
        IdentityReading<Clock.Two, BeamSpace, SaturationEncoding>>
    public typealias Zero3 = FollowedPair<FollowedPair<ZeroQQ, ZeroW>,
        PhaseCyclingContacts<D, A, C, B>.AtTwo>
    public typealias Zero4 = FollowedPair<Zero3, PhaseCyclingContacts<A, B, C, D>.AtZero>
    public typealias Zero5 = FollowedPair<Zero4, PhaseCyclingContacts<B, C, A, D>.AtOne>
    public typealias ZeroPath = FollowedPair<Zero5, PhaseCyclingContacts<C, A, B, D>.AtTwo>
    public enum AtZero: Pair {
        public typealias Left = Paired<BoundaryWorking<A, B, C, D>, Clock.Zero>
        public typealias Right = Paired<BoundaryWorking<A, D, B, C>, Clock.Zero>
        public enum Endpoints: Null {
            public typealias Left = Paired<ZeroPath.Left, ZeroPath.Right>
            public typealias Right = Paired<AtZero.Left, AtZero.Right>
        }
    }

    public typealias OneQQ = FollowedPair<PhaseCyclingContacts<A, B, C, D>.AtOne,
        PhaseCyclingContacts<B, C, A, D>.AtTwo>
    public typealias OneW = PairedApplication<FourLeafPhaseWord<C, D, A, B>,
        IdentityReading<Clock.Zero, BeamSpace, SaturationEncoding>>
    public typealias One3 = FollowedPair<FollowedPair<OneQQ, OneW>,
        PhaseCyclingContacts<B, D, C, A>.AtZero>
    public typealias One4 = FollowedPair<One3, PhaseCyclingContacts<D, C, B, A>.AtOne>
    public typealias One5 = FollowedPair<One4, PhaseCyclingContacts<C, B, D, A>.AtTwo>
    public typealias OnePath = FollowedPair<One5, PhaseCyclingContacts<B, A, D, C>.AtZero>
    public enum AtOne: Pair {
        public typealias Left = Paired<BoundaryWorking<A, B, C, D>, Clock.One>
        public typealias Right = Paired<BoundaryWorking<A, D, B, C>, Clock.One>
        public enum Endpoints: Null {
            public typealias Left = Paired<OnePath.Left, OnePath.Right>
            public typealias Right = Paired<AtOne.Left, AtOne.Right>
        }
    }

    public typealias TwoQQ = FollowedPair<PhaseCyclingContacts<A, B, C, D>.AtTwo,
        PhaseCyclingContacts<B, D, C, A>.AtZero>
    public typealias TwoW = PairedApplication<FourLeafPhaseWord<D, C, B, A>,
        IdentityReading<Clock.One, BeamSpace, SaturationEncoding>>
    public typealias Two3 = FollowedPair<FollowedPair<TwoQQ, TwoW>,
        PhaseCyclingContacts<A, C, D, B>.AtOne>
    public typealias Two4 = FollowedPair<Two3, PhaseCyclingContacts<C, D, A, B>.AtTwo>
    public typealias Two5 = FollowedPair<Two4, PhaseCyclingContacts<D, B, A, C>.AtZero>
    public typealias TwoPath = FollowedPair<Two5, PhaseCyclingContacts<B, A, D, C>.AtOne>
    public enum AtTwo: Pair {
        public typealias Left = Paired<BoundaryWorking<A, B, C, D>, Clock.Two>
        public typealias Right = Paired<BoundaryWorking<A, D, B, C>, Clock.Two>
        public enum Endpoints: Null {
            public typealias Left = Paired<TwoPath.Left, TwoPath.Right>
            public typealias Right = Paired<AtTwo.Left, AtTwo.Right>
        }
    }
}

/// T = W Q Q W Q Q Q Q W W. The six actual Q calls return the clock;
/// no call touches the carried P. Here P may be any structure, not merely
/// a specially prepared auxiliary phase. The output is (q(x), t, P).
public enum PrimitivePhaseReturn<A: Structure, B: Structure, C: Structure,
    D: Structure, P: Structure>: Close {
    public typealias Clock = PhaseBridgeClock
    public typealias Core = PrimitivePhaseReturnCore<D, B, A, C>
    public typealias FinalWW = PhaseWordCatalogue<D, C, B, A>.WW

    public typealias ZeroStart = FollowedPair<WorkingPhaseW<A, B, C, D, Clock.Zero, P>,
        StepBeside<Core.AtZero, P>>
    public typealias ZeroEnd = StepBeside<PairedApplication<FinalWW,
        IdentityReading<Clock.Zero, BeamSpace, SaturationEncoding>>, P>
    public typealias ZeroPath = FollowedPair<ZeroStart, ZeroEnd>
    public enum AtZero: Pair {
        public typealias Left = Paired<Paired<BoundaryWorking<A, B, C, D>, Clock.Zero>, P>
        public typealias Right = Paired<Paired<BoundaryWorking<B, C, A, D>, Clock.Zero>, P>
        public enum Endpoints: Null {
            public typealias Left = Paired<ZeroPath.Left, ZeroPath.Right>
            public typealias Right = Paired<AtZero.Left, AtZero.Right>
        }
    }

    public typealias OneStart = FollowedPair<WorkingPhaseW<A, B, C, D, Clock.One, P>,
        StepBeside<Core.AtOne, P>>
    public typealias OneEnd = StepBeside<PairedApplication<FinalWW,
        IdentityReading<Clock.One, BeamSpace, SaturationEncoding>>, P>
    public typealias OnePath = FollowedPair<OneStart, OneEnd>
    public enum AtOne: Pair {
        public typealias Left = Paired<Paired<BoundaryWorking<A, B, C, D>, Clock.One>, P>
        public typealias Right = Paired<Paired<BoundaryWorking<B, C, A, D>, Clock.One>, P>
        public enum Endpoints: Null {
            public typealias Left = Paired<OnePath.Left, OnePath.Right>
            public typealias Right = Paired<AtOne.Left, AtOne.Right>
        }
    }

    public typealias TwoStart = FollowedPair<WorkingPhaseW<A, B, C, D, Clock.Two, P>,
        StepBeside<Core.AtTwo, P>>
    public typealias TwoEnd = StepBeside<PairedApplication<FinalWW,
        IdentityReading<Clock.Two, BeamSpace, SaturationEncoding>>, P>
    public typealias TwoPath = FollowedPair<TwoStart, TwoEnd>
    public enum AtTwo: Pair {
        public typealias Left = Paired<Paired<BoundaryWorking<A, B, C, D>, Clock.Two>, P>
        public typealias Right = Paired<Paired<BoundaryWorking<B, C, A, D>, Clock.Two>, P>
        public enum Endpoints: Null {
            public typealias Left = Paired<TwoPath.Left, TwoPath.Right>
            public typealias Right = Paired<AtTwo.Left, AtTwo.Right>
        }
    }
}
