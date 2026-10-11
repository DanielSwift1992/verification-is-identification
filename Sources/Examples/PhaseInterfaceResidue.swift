import VerificationIsIdentification

/// K = (W_work M)^2 has identity working action and advances the residue twice.
/// Every path uses the actual next clock and complete auxiliary tuple.
public enum PhaseInterfaceResidue<A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure, G: Structure, H: Structure>: Close {
    public typealias Clock = PhaseBridgeClock
    public typealias First = ReusablePhaseInterface<A, B, C, D, E, F, G, H>
    public typealias Second = ReusablePhaseInterface<B, A, D, C, E, F, G, H>
    public typealias SecondChanged = ReusablePhaseInterface<B, A, D, C, F, G, E, H>
    public typealias ZeroPath = FollowedPair<First.WMZero.SourceStep, Second.WMOne.SourceStep>
    public typealias OnePath = FollowedPair<First.WMOne.SourceStep, Second.WMTwo.SourceStep>
    public typealias TwoPath = FollowedPair<First.WMTwo.SourceStep, SecondChanged.WMZero.SourceStep>

    public enum AtZero: Pair {
        public typealias Left = PhaseInterfaceWorld<A, B, C, D, E, F, G, H, Clock.Zero>
        public typealias Right = PhaseInterfaceWorld<A, B, C, D, E, F, G, H, Clock.Two>
        public enum Endpoints: Null {
            public typealias Left = Paired<ZeroPath.Left, ZeroPath.Right>
            public typealias Right = Paired<AtZero.Left, AtZero.Right>
        }
    }
    public enum AtOne: Pair {
        public typealias Left = PhaseInterfaceWorld<A, B, C, D, E, F, G, H, Clock.One>
        public typealias Right = PhaseInterfaceWorld<A, B, C, D, F, G, E, H, Clock.Zero>
        public enum Endpoints: Null {
            public typealias Left = Paired<OnePath.Left, OnePath.Right>
            public typealias Right = Paired<AtOne.Left, AtOne.Right>
        }
    }
    public enum AtTwo: Pair {
        public typealias Left = PhaseInterfaceWorld<A, B, C, D, E, F, G, H, Clock.Two>
        public typealias Right = PhaseInterfaceWorld<A, B, C, D, F, G, E, H, Clock.One>
        public enum Endpoints: Null {
            public typealias Left = Paired<TwoPath.Left, TwoPath.Right>
            public typealias Right = Paired<AtTwo.Left, AtTwo.Right>
        }
    }
}

/// B = K M: three M and two W, hence 29 Q/W calls under the macro cost.
/// It returns the clock but applies q to both registers. This is a full
/// environment return only on auxiliary tuples fixed by q.
public enum PairedPhaseInterface<A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure, G: Structure, H: Structure>: Close {
    public typealias Clock = PhaseBridgeClock
    public typealias K = PhaseInterfaceResidue<A, B, C, D, E, F, G, H>
    public typealias M = UnobservedClockInterface<A, B, C, D, E, F, G, H>
    public typealias Changed = UnobservedClockInterface<A, B, C, D, F, G, E, H>
    public typealias ZeroPath = FollowedPair<K.AtZero, M.AtTwo>
    public typealias OnePath = FollowedPair<K.AtOne, Changed.AtZero>
    public typealias TwoPath = FollowedPair<K.AtTwo, Changed.AtOne>

    public enum AtZero: Pair {
        public typealias Left = PhaseInterfaceWorld<A, B, C, D, E, F, G, H, Clock.Zero>
        public typealias Right = PhaseInterfaceWorld<B, C, A, D, F, G, E, H, Clock.Zero>
        public enum Endpoints: Null {
            public typealias Left = Paired<ZeroPath.Left, ZeroPath.Right>
            public typealias Right = Paired<AtZero.Left, AtZero.Right>
        }
    }
    public enum AtOne: Pair {
        public typealias Left = PhaseInterfaceWorld<A, B, C, D, E, F, G, H, Clock.One>
        public typealias Right = PhaseInterfaceWorld<B, C, A, D, F, G, E, H, Clock.One>
        public enum Endpoints: Null {
            public typealias Left = Paired<OnePath.Left, OnePath.Right>
            public typealias Right = Paired<AtOne.Left, AtOne.Right>
        }
    }
    public enum AtTwo: Pair {
        public typealias Left = PhaseInterfaceWorld<A, B, C, D, E, F, G, H, Clock.Two>
        public typealias Right = PhaseInterfaceWorld<B, C, A, D, F, G, E, H, Clock.Two>
        public enum Endpoints: Null {
            public typealias Left = Paired<TwoPath.Left, TwoPath.Right>
            public typealias Right = Paired<AtTwo.Left, AtTwo.Right>
        }
    }
}

/// N = K M^7 = (K M) M^3 M^3, in performed order. The two actual cubes
/// restore the remaining auxiliary change. No clock or auxiliary read occurs.
/// Nine M and two W cost 83 Q/W calls. VC100n proves optimality only in
/// this forward macro alphabet, not among unrestricted primitive programs.
public enum RestoredPhaseInterface<A: Structure, B: Structure, C: Structure, D: Structure,
    E: Structure, F: Structure, G: Structure, H: Structure>: Close {
    public typealias Clock = PhaseBridgeClock
    public typealias First = PairedPhaseInterface<A, B, C, D, E, F, G, H>
    public typealias Cube1 = ReusablePhaseInterface<B, C, A, D, F, G, E, H>
    public typealias Cube2 = ReusablePhaseInterface<B, C, A, D, G, E, F, H>
    public typealias ZeroPath = FollowedPair<FollowedPair<First.AtZero,
        Cube1.CubeZero.SourceStep>, Cube2.CubeZero.SourceStep>
    public typealias OnePath = FollowedPair<FollowedPair<First.AtOne,
        Cube1.CubeOne.SourceStep>, Cube2.CubeOne.SourceStep>
    public typealias TwoPath = FollowedPair<FollowedPair<First.AtTwo,
        Cube1.CubeTwo.SourceStep>, Cube2.CubeTwo.SourceStep>

    public enum AtZero: Pair {
        public typealias Left = PhaseInterfaceWorld<A, B, C, D, E, F, G, H, Clock.Zero>
        public typealias Right = PhaseInterfaceWorld<B, C, A, D, E, F, G, H, Clock.Zero>
        public enum Endpoints: Null {
            public typealias Left = Paired<ZeroPath.Left, ZeroPath.Right>
            public typealias Right = Paired<AtZero.Left, AtZero.Right>
        }
    }
    public enum AtOne: Pair {
        public typealias Left = PhaseInterfaceWorld<A, B, C, D, E, F, G, H, Clock.One>
        public typealias Right = PhaseInterfaceWorld<B, C, A, D, E, F, G, H, Clock.One>
        public enum Endpoints: Null {
            public typealias Left = Paired<OnePath.Left, OnePath.Right>
            public typealias Right = Paired<AtOne.Left, AtOne.Right>
        }
    }
    public enum AtTwo: Pair {
        public typealias Left = PhaseInterfaceWorld<A, B, C, D, E, F, G, H, Clock.Two>
        public typealias Right = PhaseInterfaceWorld<B, C, A, D, E, F, G, H, Clock.Two>
        public enum Endpoints: Null {
            public typealias Left = Paired<TwoPath.Left, TwoPath.Right>
            public typealias Right = Paired<AtTwo.Left, AtTwo.Right>
        }
    }
}
