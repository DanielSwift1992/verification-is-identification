import VerificationIsIdentification

/// Two ends of a cell. The cell index is a finite successor expression in
/// the declared line below; IntegerValued alone does not impose that domain.
public typealias LineEven<J: IntegerValued> = Paired<Paired<Lit1, Never>, J>
public typealias LineOdd<J: IntegerValued> = Paired<Paired<Never, Lit1>, J>
public enum AcrossLineMatching: Close {}

/// The two alternating matching edges. These generic row constructors do not
/// declare an unlimited carrier: the total twenty-five-point matching uses
/// cells0 through11, the fixed top for matching1, and fixed bottom for matching2.
public enum AlternatingPhaseCell<J: IntegerValued>: Close {
    public typealias Even = LineEven<J>
    public typealias Odd = LineOdd<J>
    public typealias Next = LineEven<VerificationIsIdentification.Succ<J>>
    public typealias WithinUp = PairedApplication<SwapBoundaryReading<Paired<Lit1, Never>>,
        IdentityReading<J, BeamSpace, SaturationEncoding>>
    public typealias WithinDown = PairedApplication<SwapBoundaryReading<Paired<Never, Lit1>>,
        IdentityReading<J, BeamSpace, SaturationEncoding>>
    public enum AcrossUp: PredicateReading {
        public typealias Left = Odd
        public typealias Right = Next
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = AcrossLineMatching
        public typealias Answer = Right
    }
    public enum AcrossDown: PredicateReading {
        public typealias Left = Next
        public typealias Right = Odd
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = AcrossLineMatching
        public typealias Answer = Right
    }
    public enum InverseEdges: Null {
        public typealias W0 = FollowedPair<WithinUp, WithinDown>
        public typealias W1 = FollowedPair<WithinDown, WithinUp>
        public typealias A0 = FollowedPair<AcrossUp, AcrossDown>
        public typealias A1 = FollowedPair<AcrossDown, AcrossUp>
        public typealias Left = BoundaryWorking<W0.Left, W1.Left, A0.Left, A1.Left>
        public typealias Right = BoundaryWorking<W0.Answer, W1.Answer, A0.Answer, A1.Answer>
    }
}

/// A finite declared source, not a universal natural-number conformance.
/// Its matching1 edges pair Even/ Odd in each cell; matching2 pairs Odd/Next.
public enum TwentyFivePhaseLine: Close {
    public typealias J0 = Never
    public typealias J1 = VerificationIsIdentification.Succ<J0>
    public typealias J2 = VerificationIsIdentification.Succ<J1>
    public typealias J3 = VerificationIsIdentification.Succ<J2>
    public typealias J4 = VerificationIsIdentification.Succ<J3>
    public typealias J5 = VerificationIsIdentification.Succ<J4>
    public typealias J6 = VerificationIsIdentification.Succ<J5>
    public typealias J7 = VerificationIsIdentification.Succ<J6>
    public typealias J8 = VerificationIsIdentification.Succ<J7>
    public typealias J9 = VerificationIsIdentification.Succ<J8>
    public typealias J10 = VerificationIsIdentification.Succ<J9>
    public typealias J11 = VerificationIsIdentification.Succ<J10>
    public typealias J12 = VerificationIsIdentification.Succ<J11>
    public typealias C0 = AlternatingPhaseCell<J0>
    public typealias C1 = AlternatingPhaseCell<J1>
    public typealias C2 = AlternatingPhaseCell<J2>
    public typealias C3 = AlternatingPhaseCell<J3>
    public typealias C4 = AlternatingPhaseCell<J4>
    public typealias C5 = AlternatingPhaseCell<J5>
    public typealias C6 = AlternatingPhaseCell<J6>
    public typealias C7 = AlternatingPhaseCell<J7>
    public typealias C8 = AlternatingPhaseCell<J8>
    public typealias C9 = AlternatingPhaseCell<J9>
    public typealias C10 = AlternatingPhaseCell<J10>
    public typealias C11 = AlternatingPhaseCell<J11>
    public typealias Bottom = C0.Even
    public typealias Top = C11.Next
    public typealias FirstAtTop = IdentityReading<Top, BeamSpace, SaturationEncoding>
    public typealias SecondAtBottom = IdentityReading<Bottom, BeamSpace, SaturationEncoding>
    public typealias P0 = BoundaryWorking<C0.Even, C0.Odd, C1.Even, C1.Odd>
    public typealias P1 = BoundaryWorking<C2.Even, C2.Odd, C3.Even, C3.Odd>
    public typealias P2 = BoundaryWorking<C4.Even, C4.Odd, C5.Even, C5.Odd>
    public typealias P3 = BoundaryWorking<C6.Even, C6.Odd, C7.Even, C7.Odd>
    public typealias P4 = BoundaryWorking<C8.Even, C8.Odd, C9.Even, C9.Odd>
    public typealias P5 = BoundaryWorking<C10.Even, C10.Odd, C11.Even, C11.Odd>
    public typealias Points = Paired<Paired<P0, Paired<P1, P2>>, Paired<Paired<P3, Paired<P4, P5>>, Top>>
    public enum AdjacentCellsMeet: Null {
        public typealias Left = Paired<C0.Next, Paired<C1.Next, Paired<C2.Next, Paired<C3.Next,
            Paired<C4.Next, Paired<C5.Next, Paired<C6.Next, Paired<C7.Next, Paired<C8.Next,
            Paired<C9.Next, C10.Next>>>>>>>>>>
        public typealias Right = Paired<C1.Even, Paired<C2.Even, Paired<C3.Even, Paired<C4.Even,
            Paired<C5.Even, Paired<C6.Even, Paired<C7.Even, Paired<C8.Even, Paired<C9.Even,
            Paired<C10.Even, C11.Even>>>>>>>>>>
    }
}

/// Both selected advances are actual coupled contacts. Their stage actions
/// preserve leaf0 during ascent and leaf3 during descent. K stays beside phase.
public enum AlternatingLineSteps<J: IntegerValued, K: Structure>: Close {
    public typealias P = AlternatingPhaseCell<J>
    public typealias UpFirst = PairedApplication<FourLeafStage1<Never, Lit1, Never, Never, Never>,
        ExperimentReadingBeside<P.WithinUp, K>>
    public typealias UpSecond = PairedApplication<FourLeafStage2<Never, Lit1, Never, Never, Never>,
        ExperimentReadingBeside<P.AcrossUp, K>>
    public typealias Up = FollowedPair<UpFirst, UpSecond>
    public typealias DownFirst = PairedApplication<FourLeafStage2<Never, Never, Never, Never, Lit1>,
        ExperimentReadingBeside<P.AcrossDown, K>>
    public typealias DownSecond = PairedApplication<FourLeafStage1<Never, Never, Never, Never, Lit1>,
        ExperimentReadingBeside<P.WithinDown, K>>
    public typealias Down = FollowedPair<DownFirst, DownSecond>
    public enum Outcomes: Null {
        public typealias Left = Paired<Up.Answer, Down.Answer>
        public typealias Right = Paired<
            LocalPhaseWorld<FourLeafStageLabels<Never, Lit1, Never, Never, Never>, P.Next, K>,
            LocalPhaseWorld<FourLeafStageLabels<Never, Never, Never, Never, Lit1>, P.Even, K>>
    }
}
