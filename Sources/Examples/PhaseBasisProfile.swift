import VerificationIsIdentification

/// Append zero, one or two actual W calls to a supplied path at its reached
/// whole source. This seam assumes no intended meaning of the prefix.
public enum PhaseBasisRow<P: Pair, A: Structure, B: Structure, C: Structure,
    D: Structure, K: Structure, R: Structure>: Close
where P.Right == Paired<Paired<BoundaryWorking<A, B, C, D>, K>, R> {
    public typealias I = P
    public typealias W = FollowedPair<I, WorkingPhaseW<A, B, C, D, K, R>>
    public typealias WW = FollowedPair<W, WorkingPhaseW<D, B, A, C, K, R>>
    public typealias Answers = Paired<I.Right, Paired<W.Right, WW.Right>>
}

/// The twelve actual context-returning paths: I,W,WW and W^i P W^j,
/// i,j=0,1,2. P is the previously derived seven-contact core. VC100p
/// proves their exact primitive costs; the paths here supply attainment.
public enum PhaseBasisProfile<A: Structure, B: Structure, C: Structure,
    D: Structure, R: Structure>: Close {
    public typealias Clock = PhaseBridgeClock
    public typealias P0 = PrimitivePhaseReturnCore<A, B, C, D>
    public typealias P1 = PrimitivePhaseReturnCore<D, B, A, C>
    public typealias P2 = PrimitivePhaseReturnCore<C, B, D, A>

    public enum Zero: Close {
        public typealias I = IdentityReading<Paired<Paired<BoundaryWorking<A, B, C, D>, Clock.Zero>, R>,
            BeamSpace, SaturationEncoding>
        public typealias W = WorkingPhaseW<A, B, C, D, Clock.Zero, R>
        public typealias WW = FollowedPair<W, WorkingPhaseW<D, B, A, C, Clock.Zero, R>>
        public typealias Row0 = PhaseBasisRow<StepBeside<P0.AtZero, R>, A, D, B, C, Clock.Zero, R>
        public typealias Row1 = PhaseBasisRow<FollowedPair<W, StepBeside<P1.AtZero, R>>,
            D, C, B, A, Clock.Zero, R>
        public typealias Row2 = PhaseBasisRow<FollowedPair<WW, StepBeside<P2.AtZero, R>>,
            C, A, B, D, Clock.Zero, R>
        public typealias Pure = Paired<I.Right, Paired<W.Right, WW.Right>>
        public typealias Answers = Paired<Pure, Paired<Row0.Answers, Paired<Row1.Answers, Row2.Answers>>>
        public typealias Starts = Paired<Row0.I.Left, Paired<Row1.I.Left, Row2.I.Left>>
    }

    public enum One: Close {
        public typealias I = IdentityReading<Paired<Paired<BoundaryWorking<A, B, C, D>, Clock.One>, R>,
            BeamSpace, SaturationEncoding>
        public typealias W = WorkingPhaseW<A, B, C, D, Clock.One, R>
        public typealias WW = FollowedPair<W, WorkingPhaseW<D, B, A, C, Clock.One, R>>
        public typealias Row0 = PhaseBasisRow<StepBeside<P0.AtOne, R>, A, D, B, C, Clock.One, R>
        public typealias Row1 = PhaseBasisRow<FollowedPair<W, StepBeside<P1.AtOne, R>>,
            D, C, B, A, Clock.One, R>
        public typealias Row2 = PhaseBasisRow<FollowedPair<WW, StepBeside<P2.AtOne, R>>,
            C, A, B, D, Clock.One, R>
        public typealias Pure = Paired<I.Right, Paired<W.Right, WW.Right>>
        public typealias Answers = Paired<Pure, Paired<Row0.Answers, Paired<Row1.Answers, Row2.Answers>>>
        public typealias Starts = Paired<Row0.I.Left, Paired<Row1.I.Left, Row2.I.Left>>
    }

    public enum Two: Close {
        public typealias I = IdentityReading<Paired<Paired<BoundaryWorking<A, B, C, D>, Clock.Two>, R>,
            BeamSpace, SaturationEncoding>
        public typealias W = WorkingPhaseW<A, B, C, D, Clock.Two, R>
        public typealias WW = FollowedPair<W, WorkingPhaseW<D, B, A, C, Clock.Two, R>>
        public typealias Row0 = PhaseBasisRow<StepBeside<P0.AtTwo, R>, A, D, B, C, Clock.Two, R>
        public typealias Row1 = PhaseBasisRow<FollowedPair<W, StepBeside<P1.AtTwo, R>>,
            D, C, B, A, Clock.Two, R>
        public typealias Row2 = PhaseBasisRow<FollowedPair<WW, StepBeside<P2.AtTwo, R>>,
            C, A, B, D, Clock.Two, R>
        public typealias Pure = Paired<I.Right, Paired<W.Right, WW.Right>>
        public typealias Answers = Paired<Pure, Paired<Row0.Answers, Paired<Row1.Answers, Row2.Answers>>>
        public typealias Starts = Paired<Row0.I.Left, Paired<Row1.I.Left, Row2.I.Left>>
    }
}
