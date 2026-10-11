import VerificationIsIdentification

/// The complete admitted state: working phase, shared clock, auxiliary phase.
/// Both phases carry arbitrary values. There is no prepared blank or record.
public typealias PhaseInterfaceWorld<A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure, G: Structure, H: Structure, K: Structure> =
    Paired<Paired<BoundaryWorking<A, B, C, D>, K>, BoundaryWorking<E, F, G, H>>

/// Refocusing is an involutive structural exchange, not a clock measurement.
public enum ExchangeActivePhase<S: Pair>: Pair
where S.Left: Pair, S.Left.Left: Structure, S.Left.Right: Structure, S.Right: Structure {
    public typealias Left = S
    public typealias Right = Paired<Paired<S.Right, S.Left.Right>, S.Left.Left>
}

/// Apply a supplied actual phase-and-clock contact to the auxiliary register,
/// carrying the working register unchanged through both focus changes.
public enum AuxiliaryPhaseContact<Q: Pair, V: Structure, P: Structure, K: Structure>: Pair
where Q.Left == Paired<P, K>, Q.Right: Pair,
      Q.Right.Left: Structure, Q.Right.Right: Structure {
    public typealias Left = Paired<Paired<V, K>, P>
    public typealias Focus = ExchangeActivePhase<Left>
    public typealias Contact = StepBeside<Q, V>
    public typealias Restore = ExchangeActivePhase<Contact.Right>
    public typealias Path = FollowedPair<FollowedPair<Focus, Contact>, Restore>
    public typealias Right = Paired<Paired<V, Q.Right.Right>, Q.Right.Left>
    public enum Endpoints: Null {
        public typealias Left = Paired<Path.Left, Path.Right>
        public typealias Right = Paired<AuxiliaryPhaseContact.Left, AuxiliaryPhaseContact.Right>
    }
}

/// W on working data leaves the actual shared clock and auxiliary data alone.
public enum WorkingPhaseW<A: Structure, B: Structure, C: Structure, D: Structure,
    K: Structure, P: Structure>: Pair {
    public typealias Working = PairedApplication<FourLeafPhaseWord<A, B, C, D>,
        IdentityReading<K, BeamSpace, SaturationEncoding>>
    public typealias Path = StepBeside<Working, P>
    public typealias Left = Paired<Paired<BoundaryWorking<A, B, C, D>, K>, P>
    public typealias Right = Paired<Paired<BoundaryWorking<D, B, A, C>, K>, P>
    public enum Endpoints: Null {
        public typealias Left = Paired<Path.Left, Path.Right>
        public typealias Right = Paired<WorkingPhaseW.Left, WorkingPhaseW.Right>
    }
}

/// F = Q_work Q_aux Q_aux. Every clause uses the same physical schedule:
/// Q1 at zero/one, Q2 at two, then advance the shared clock.
public enum UnobservedClockReturn<A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure, G: Structure, H: Structure>: Close {
    public typealias Clock = PhaseBridgeClock
    public typealias Work = PhaseCyclingContacts<A, B, C, D>
    public typealias Aux = BoundaryWorking<E, F, G, H>
    public typealias Work1 = BoundaryWorking<B, C, A, D>
    public typealias Work2 = BoundaryWorking<B, D, C, A>

    public typealias StartZero = StepBeside<Work.AtZero, Aux>
    public typealias AuxZero1 = AuxiliaryPhaseContact<PhaseCyclingContacts<E, F, G, H>.AtOne,
        Work1, Aux, Clock.One>
    public typealias AuxZero2 = AuxiliaryPhaseContact<PhaseCyclingContacts<F, G, E, H>.AtTwo,
        Work1, BoundaryWorking<F, G, E, H>, Clock.Two>
    public typealias ZeroPath = FollowedPair<FollowedPair<StartZero, AuxZero1>, AuxZero2>
    public enum AtZero: Pair {
        public typealias Left = PhaseInterfaceWorld<A, B, C, D, E, F, G, H, Clock.Zero>
        public typealias Right = PhaseInterfaceWorld<B, C, A, D, G, H, E, F, Clock.Zero>
        public enum Endpoints: Null {
            public typealias Left = Paired<ZeroPath.Left, ZeroPath.Right>
            public typealias Right = Paired<AtZero.Left, AtZero.Right>
        }
    }

    public typealias StartOne = StepBeside<Work.AtOne, Aux>
    public typealias AuxOne1 = AuxiliaryPhaseContact<PhaseCyclingContacts<E, F, G, H>.AtTwo,
        Work1, Aux, Clock.Two>
    public typealias AuxOne2 = AuxiliaryPhaseContact<PhaseCyclingContacts<F, H, G, E>.AtZero,
        Work1, BoundaryWorking<F, H, G, E>, Clock.Zero>
    public typealias OnePath = FollowedPair<FollowedPair<StartOne, AuxOne1>, AuxOne2>
    public enum AtOne: Pair {
        public typealias Left = PhaseInterfaceWorld<A, B, C, D, E, F, G, H, Clock.One>
        public typealias Right = PhaseInterfaceWorld<B, C, A, D, H, G, F, E, Clock.One>
        public enum Endpoints: Null {
            public typealias Left = Paired<OnePath.Left, OnePath.Right>
            public typealias Right = Paired<AtOne.Left, AtOne.Right>
        }
    }

    public typealias StartTwo = StepBeside<Work.AtTwo, Aux>
    public typealias AuxTwo1 = AuxiliaryPhaseContact<PhaseCyclingContacts<E, F, G, H>.AtZero,
        Work2, Aux, Clock.Zero>
    public typealias AuxTwo2 = AuxiliaryPhaseContact<PhaseCyclingContacts<F, G, E, H>.AtOne,
        Work2, BoundaryWorking<F, G, E, H>, Clock.One>
    public typealias TwoPath = FollowedPair<FollowedPair<StartTwo, AuxTwo1>, AuxTwo2>
    public enum AtTwo: Pair {
        public typealias Left = PhaseInterfaceWorld<A, B, C, D, E, F, G, H, Clock.Two>
        public typealias Right = PhaseInterfaceWorld<B, D, C, A, G, E, F, H, Clock.Two>
        public enum Endpoints: Null {
            public typealias Left = Paired<TwoPath.Left, TwoPath.Right>
            public typealias Right = Paired<AtTwo.Left, AtTwo.Right>
        }
    }

    public enum ActualWholeOutputs: Null {
        public typealias Left = Paired<AtZero.Right, Paired<AtOne.Right, AtTwo.Right>>
        public typealias Right = Paired<
            PhaseInterfaceWorld<B, C, A, D, G, H, E, F, Clock.Zero>,
            Paired<PhaseInterfaceWorld<B, C, A, D, H, G, F, E, Clock.One>,
                PhaseInterfaceWorld<B, D, C, A, G, E, F, H, Clock.Two>>>
    }
}

/// M = F F W_work Q_work W_work: nine Q/W calls, in performed order.
/// The three clauses verify one fixed program, not a selector reading a clock.
public enum UnobservedClockInterface<A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure, G: Structure, H: Structure>: Close {
    public typealias Clock = PhaseBridgeClock
    public typealias First = UnobservedClockReturn<A, B, C, D, E, F, G, H>
    public typealias Aux = BoundaryWorking<E, F, G, H>
    public typealias ChangedAux = BoundaryWorking<F, G, E, H>

    public typealias TwiceZero = FollowedPair<First.AtZero,
        UnobservedClockReturn<B, C, A, D, G, H, E, F>.AtZero>
    public typealias BeforeZero = FollowedPair<TwiceZero,
        WorkingPhaseW<C, A, B, D, Clock.Zero, Aux>>
    public typealias LastQZero = StepBeside<PhaseCyclingContacts<D, A, C, B>.AtZero, Aux>
    public typealias ZeroPath = FollowedPair<FollowedPair<BeforeZero, LastQZero>,
        WorkingPhaseW<A, C, D, B, Clock.One, Aux>>
    public enum AtZero: Pair {
        public typealias Left = PhaseInterfaceWorld<A, B, C, D, E, F, G, H, Clock.Zero>
        public typealias Right = PhaseInterfaceWorld<B, C, A, D, E, F, G, H, Clock.One>
        public enum Endpoints: Null {
            public typealias Left = Paired<ZeroPath.Left, ZeroPath.Right>
            public typealias Right = Paired<AtZero.Left, AtZero.Right>
        }
    }

    public typealias TwiceOne = FollowedPair<First.AtOne,
        UnobservedClockReturn<B, C, A, D, H, G, F, E>.AtOne>
    public typealias BeforeOne = FollowedPair<TwiceOne,
        WorkingPhaseW<C, A, B, D, Clock.One, Aux>>
    public typealias LastQOne = StepBeside<PhaseCyclingContacts<D, A, C, B>.AtOne, Aux>
    public typealias OnePath = FollowedPair<FollowedPair<BeforeOne, LastQOne>,
        WorkingPhaseW<A, C, D, B, Clock.Two, Aux>>
    public enum AtOne: Pair {
        public typealias Left = PhaseInterfaceWorld<A, B, C, D, E, F, G, H, Clock.One>
        public typealias Right = PhaseInterfaceWorld<B, C, A, D, E, F, G, H, Clock.Two>
        public enum Endpoints: Null {
            public typealias Left = Paired<OnePath.Left, OnePath.Right>
            public typealias Right = Paired<AtOne.Left, AtOne.Right>
        }
    }

    public typealias TwiceTwo = FollowedPair<First.AtTwo,
        UnobservedClockReturn<B, D, C, A, G, E, F, H>.AtTwo>
    public typealias BeforeTwo = FollowedPair<TwiceTwo,
        WorkingPhaseW<D, A, C, B, Clock.Two, ChangedAux>>
    public typealias LastQTwo = StepBeside<PhaseCyclingContacts<B, A, D, C>.AtTwo, ChangedAux>
    public typealias TwoPath = FollowedPair<FollowedPair<BeforeTwo, LastQTwo>,
        WorkingPhaseW<A, C, D, B, Clock.Zero, ChangedAux>>
    public enum AtTwo: Pair {
        public typealias Left = PhaseInterfaceWorld<A, B, C, D, E, F, G, H, Clock.Two>
        public typealias Right = PhaseInterfaceWorld<B, C, A, D, F, G, E, H, Clock.Zero>
        public enum Endpoints: Null {
            public typealias Left = Paired<TwoPath.Left, TwoPath.Right>
            public typealias Right = Paired<AtTwo.Left, AtTwo.Right>
        }
    }

    public enum WholeSources: Null {
        public typealias Left = Paired<AtZero.Left, Paired<AtOne.Left, AtTwo.Left>>
        public typealias Right = Paired<
            PhaseInterfaceWorld<A, B, C, D, E, F, G, H, Clock.Zero>,
            Paired<PhaseInterfaceWorld<A, B, C, D, E, F, G, H, Clock.One>,
                PhaseInterfaceWorld<A, B, C, D, E, F, G, H, Clock.Two>>>
    }
    public enum WholeOutputs: Null {
        public typealias Left = Paired<AtZero.Right, Paired<AtOne.Right, AtTwo.Right>>
        public typealias Right = Paired<
            PhaseInterfaceWorld<B, C, A, D, E, F, G, H, Clock.One>,
            Paired<PhaseInterfaceWorld<B, C, A, D, E, F, G, H, Clock.Two>,
                PhaseInterfaceWorld<B, C, A, D, F, G, E, H, Clock.Zero>>>
    }
}
