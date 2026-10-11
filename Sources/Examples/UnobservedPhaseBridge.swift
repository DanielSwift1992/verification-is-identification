import VerificationIsIdentification

/// One fixed word is executed with either stable Q law. There is no acquired
/// answer, branch selector or intermediate readout in either construction.
/// Q occurrences in a path all use its same supplied law. W is common.
public enum UnobservedPhaseBridge<A: Structure, B: Structure,
    C: Structure, D: Structure>: Close {
    public typealias Base = PhaseAlignmentObstruction<A, B, C, D>

    // QQWQW under Q1.
    public typealias First1 = FollowedPair<Base.Q1Square, FourLeafPhaseWord<C, A, B, D>>
    public typealias Second1 = FollowedPair<First1, PhaseWordCatalogue<D, A, C, B>.WWZ>
    public typealias ToFirst1 = FollowedPair<Second1, FourLeafPhaseWord<A, C, D, B>>

    // The same QQWQW under Q2.
    public typealias First2 = FollowedPair<Base.Q2Square, FourLeafPhaseWord<D, A, C, B>>
    public typealias Second2 = FollowedPair<First2, PhaseWordCatalogue<B, A, D, C>.WZ>
    public typealias ToFirst2 = FollowedPair<Second2, FourLeafPhaseWord<A, C, D, B>>

    // QQWWQWW under Q1.
    public typealias ReverseFirst1 = FollowedPair<Base.Q1Square, PhaseWordCatalogue<C, A, B, D>.WW>
    public typealias ReverseSecond1 = FollowedPair<ReverseFirst1, PhaseWordCatalogue<B, A, D, C>.WWZ>
    public typealias ToSecond1 = FollowedPair<ReverseSecond1, PhaseWordCatalogue<A, D, B, C>.WW>

    // The same QQWWQWW under Q2.
    public typealias ReverseFirst2 = FollowedPair<Base.Q2Square, PhaseWordCatalogue<D, A, C, B>.WW>
    public typealias ReverseSecond2 = FollowedPair<ReverseFirst2, PhaseWordCatalogue<C, A, B, D>.WZ>
    public typealias ToSecond2 = FollowedPair<ReverseSecond2, PhaseWordCatalogue<A, D, B, C>.WW>

    public enum FirstActionWithoutIdentification: Null {
        public typealias Left = Paired<ToFirst1.Right, ToFirst2.Right>
        public typealias Right = Paired<Base.Q1.Right, Base.Q1.Right>
    }
    public enum SecondActionWithoutIdentification: Null {
        public typealias Left = Paired<ToSecond1.Right, ToSecond2.Right>
        public typealias Right = Paired<Base.Q2.Right, Base.Q2.Right>
    }
    public enum SamePreparedSource: Null {
        public typealias Left = Paired<Paired<ToFirst1.Left, ToFirst2.Left>,
            Paired<ToSecond1.Left, ToSecond2.Left>>
        public typealias Right = Paired<Paired<Base.Initial, Base.Initial>,
            Paired<Base.Initial, Base.Initial>>
    }
}

/// The two interfaces expose the same common W operation, but switching Q
/// just for the third invocation changes QQWQW into W. The first two actual
/// Q applications remain unchanged. This is not a stable-law construction.
public enum SwitchedUnobservedPhaseBridge<A: Structure, B: Structure,
    C: Structure, D: Structure>: Pair {
    public typealias Stable = UnobservedPhaseBridge<A, B, C, D>
    public typealias ChangedQ = FollowedPair<Stable.First1,
        PhaseWordCatalogue<D, A, C, B>.WZ>
    public typealias Path = FollowedPair<ChangedQ, FourLeafPhaseWord<A, B, C, D>>
    public typealias Left = Path.Left
    public typealias Right = Path.Right
    public enum ActualChangedAction: Null {
        public typealias Left = SwitchedUnobservedPhaseBridge.Right
        public typealias Right = Stable.Base.W.Right
    }
}
