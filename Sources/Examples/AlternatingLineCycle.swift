import VerificationIsIdentification

/// Twelve two-contact advances expose the twenty-five phase preparations
/// without evaluating an integer loop. Each successor comes from the actual
/// previous output. Descent uses the inverse matching edges in reverse order.
public enum AlternatingLineTravel<K: Structure>: Close {
    public typealias P = TwentyFivePhaseLine
    public typealias D0 = AlternatingLineSteps<P.J0, K>
    public typealias D1 = AlternatingLineSteps<P.J1, K>
    public typealias D2 = AlternatingLineSteps<P.J2, K>
    public typealias D3 = AlternatingLineSteps<P.J3, K>
    public typealias D4 = AlternatingLineSteps<P.J4, K>
    public typealias D5 = AlternatingLineSteps<P.J5, K>
    public typealias D6 = AlternatingLineSteps<P.J6, K>
    public typealias D7 = AlternatingLineSteps<P.J7, K>
    public typealias D8 = AlternatingLineSteps<P.J8, K>
    public typealias D9 = AlternatingLineSteps<P.J9, K>
    public typealias D10 = AlternatingLineSteps<P.J10, K>
    public typealias D11 = AlternatingLineSteps<P.J11, K>
    public typealias U0 = FollowedPair<D0.Up, D1.Up>
    public typealias U1 = FollowedPair<D2.Up, D3.Up>
    public typealias U2 = FollowedPair<D4.Up, D5.Up>
    public typealias U3 = FollowedPair<D6.Up, D7.Up>
    public typealias U4 = FollowedPair<D8.Up, D9.Up>
    public typealias U5 = FollowedPair<D10.Up, D11.Up>
    public typealias Up = FollowedPair<FollowedPair<FollowedPair<U0, U1>, U2>,
        FollowedPair<FollowedPair<U3, U4>, U5>>
    public typealias B0 = FollowedPair<D11.Down, D10.Down>
    public typealias B1 = FollowedPair<D9.Down, D8.Down>
    public typealias B2 = FollowedPair<D7.Down, D6.Down>
    public typealias B3 = FollowedPair<D5.Down, D4.Down>
    public typealias B4 = FollowedPair<D3.Down, D2.Down>
    public typealias B5 = FollowedPair<D1.Down, D0.Down>
    public typealias Down = FollowedPair<FollowedPair<FollowedPair<B0, B1>, B2>,
        FollowedPair<FollowedPair<B3, B4>, B5>>
    public typealias TopLeave = PairedApplication<FourLeafStage0<Never, Lit1, Never, Never, Never>,
        ExperimentReadingBeside<IdentityReading<P.Top, BeamSpace, SaturationEncoding>, K>>
    public typealias TopEnter = PairedApplication<FourLeafStage3<Lit1, Never, Never, Never, Never>,
        ExperimentReadingBeside<IdentityReading<P.Top, BeamSpace, SaturationEncoding>, K>>
    public typealias BottomLeave = PairedApplication<FourLeafStage3<Never, Never, Never, Never, Lit1>,
        ExperimentReadingBeside<IdentityReading<P.Bottom, BeamSpace, SaturationEncoding>, K>>
    public typealias BottomEnter = PairedApplication<FourLeafStage0<Lit1, Never, Never, Never, Never>,
        ExperimentReadingBeside<IdentityReading<P.Bottom, BeamSpace, SaturationEncoding>, K>>
    public typealias BeforeExit = FollowedPair<Up, TopLeave>
    public enum Cycle: Null {
        public typealias Actual = FollowedPair<
            FollowedPair<FollowedPair<Up, TopLeave>, TopEnter>,
            FollowedPair<FollowedPair<Down, BottomLeave>, BottomEnter>>
        public typealias Left = Actual.Left
        public typealias Right = Actual.Answer
    }
    public enum Endpoints: Null {
        public typealias Left = Paired<Up.Answer, Paired<TopLeave.Answer, Down.Answer>>
        public typealias Right = Paired<
            LocalPhaseWorld<FourLeafStageLabels<Never, Lit1, Never, Never, Never>, P.Top, K>,
            Paired<LocalPhaseWorld<FourLeafCenter, P.Top, K>,
            LocalPhaseWorld<FourLeafStageLabels<Never, Never, Never, Never, Lit1>, P.Bottom, K>>>
    }
}

/// Contact1 exchanges these center/leaf1 pairs. In the declared completion,
/// Odd is used for cells0…11 and Even for cells1…11. The two excluded center
/// endpoints already occur in the main52-cycle.
public enum AlternatingLineRemainder<J: IntegerValued, K: Structure>: Close {
    public typealias P = AlternatingPhaseCell<J>
    public typealias FromOdd = PairedApplication<FourLeafStage1<Lit1, Never, Never, Never, Never>,
        ExperimentReadingBeside<P.WithinDown, K>>
    public typealias ToOdd = PairedApplication<FourLeafStage1<Never, Never, Lit1, Never, Never>,
        ExperimentReadingBeside<P.WithinUp, K>>
    public typealias FromEven = PairedApplication<FourLeafStage1<Lit1, Never, Never, Never, Never>,
        ExperimentReadingBeside<P.WithinUp, K>>
    public typealias ToEven = PairedApplication<FourLeafStage1<Never, Never, Lit1, Never, Never>,
        ExperimentReadingBeside<P.WithinDown, K>>
    public enum Odd: Null {
        public typealias Actual = FollowedPair<FromOdd, ToOdd>
        public typealias Left = Actual.Left
        public typealias Right = Actual.Answer
    }
    public enum Even: Null {
        public typealias Actual = FollowedPair<FromEven, ToEven>
        public typealias Left = Actual.Left
        public typealias Right = Actual.Answer
    }
}

/// Every leaf2 phase is fixed by the actual contact0. The declared carrier
/// supplies the twenty-five phases, rather than a claim about all Structures.
public enum AlternatingLineFixedLeaf2<P: Structure, K: Structure>: Null {
    public typealias Actual = PairedApplication<FourLeafStage0<Never, Never, Never, Lit1, Never>,
        ExperimentReadingBeside<IdentityReading<P, BeamSpace, SaturationEncoding>, K>>
    public typealias Left = Actual.Left
    public typealias Right = Actual.Answer
}

public enum AlternatingLineFixedLeaf1<P: Structure, K: Structure>: Null {
    public typealias Actual = PairedApplication<FourLeafStage0<Never, Never, Lit1, Never, Never>,
        ExperimentReadingBeside<IdentityReading<P, BeamSpace, SaturationEncoding>, K>>
    public typealias Left = Actual.Left
    public typealias Right = Actual.Answer
}
