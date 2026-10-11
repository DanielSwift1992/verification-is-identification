import VerificationIsIdentification

/// Three actual positions on W's clock orbit. Q advances this clock; W on
/// the working phase leaves it in place. The clock is part of the source.
public enum PhaseBridgeClock: Close {
    public typealias Zero = FourLeafPhaseMark0
    public typealias One = FourLeafPhaseMark2
    public typealias Two = FourLeafPhaseMark3
    public typealias NextZero = FourLeafPhaseWord<Lit1, Never, Never, Never>
    public typealias NextOne = FourLeafPhaseWord<Never, Never, Lit1, Never>
    public typealias NextTwo = FourLeafPhaseWord<Never, Never, Never, Lit1>
    public typealias BackFromOne = PhaseWordCatalogue<Never, Never, Lit1, Never>.WW
    public typealias BackFromTwo = PhaseWordCatalogue<Never, Never, Never, Lit1>.WW
    public typealias BackFromZero = PhaseWordCatalogue<Lit1, Never, Never, Never>.WW
}

/// The three clauses of one fixed contact on phase × clock. The phase law
/// is Q1 at clock zero/one and Q2 at clock two. Each input clock has one
/// successor and every clause derives its inverse at its actual output.
public enum PhaseCyclingContacts<A: Structure, B: Structure,
    C: Structure, D: Structure>: Close {
    public typealias P = PhaseAlignmentObstruction<A, B, C, D>
    public typealias Clock = PhaseBridgeClock
    public typealias AtZero = PairedApplication<P.Q1, Clock.NextZero>
    public typealias AtOne = PairedApplication<P.Q1, Clock.NextOne>
    public typealias AtTwo = PairedApplication<P.Q2, Clock.NextTwo>
    public typealias UndoZero = PairedApplication<
        PhaseAlignmentObstruction<B, C, A, D>.Q1Square, Clock.BackFromOne>
    public typealias UndoOne = PairedApplication<
        PhaseAlignmentObstruction<B, C, A, D>.Q1Square, Clock.BackFromTwo>
    public typealias UndoTwo = PairedApplication<
        PhaseAlignmentObstruction<B, D, C, A>.Q2Square, Clock.BackFromZero>
    public enum ActualInverseClauses: Null {
        public typealias Left = Paired<FollowedPair<AtZero, UndoZero>.Right,
            Paired<FollowedPair<AtOne, UndoOne>.Right, FollowedPair<AtTwo, UndoTwo>.Right>>
        public typealias Right = Paired<AtZero.Left, Paired<AtOne.Left, AtTwo.Left>>
    }

    // A supplied current-clock policy: direct Q at zero/one, W then Q at two.
    // The added W does not advance the clock, so the last Q uses AtTwo.
    public typealias BeforeTwo = PairedApplication<P.W,
        IdentityReading<Clock.Two, BeamSpace, SaturationEncoding>>
    public typealias NormalizedTwo = FollowedPair<BeforeTwo,
        PhaseCyclingContacts<D, B, A, C>.AtTwo>
    public enum NormalizedPhaseAction: Null {
        public typealias Left = Paired<AtZero.Right.Left,
            Paired<AtOne.Right.Left, NormalizedTwo.Right.Left>>
        public typealias Right = Paired<P.Q1.Right, Paired<P.Q1.Right, P.Q1.Right>>
    }
    public enum PreservesActualClockAdvance: Null {
        public typealias Left = Paired<AtZero.Right.Right,
            Paired<AtOne.Right.Right, NormalizedTwo.Right.Right>>
        public typealias Right = Paired<Clock.One, Paired<Clock.Two, Clock.Zero>>
    }
}

/// QQWQW from clock zero, using the same fixed whole contact each time.
/// Its clock clauses supply Q1, Q1, Q2 at the three reached sources.
public enum PhaseCyclingBridge<A: Structure, B: Structure,
    C: Structure, D: Structure>: Pair {
    public typealias P = PhaseAlignmentObstruction<A, B, C, D>
    public typealias Clock = PhaseBridgeClock
    public typealias First = PhaseCyclingContacts<A, B, C, D>.AtZero
    public typealias Second = PhaseCyclingContacts<B, C, A, D>.AtOne
    public typealias FirstPair = FollowedPair<First, Second>
    public typealias WorkingW = PairedApplication<FourLeafPhaseWord<C, A, B, D>,
        IdentityReading<Clock.Two, BeamSpace, SaturationEncoding>>
    public typealias BeforeThird = FollowedPair<FirstPair, WorkingW>
    public typealias Third = PhaseCyclingContacts<D, A, C, B>.AtTwo
    public typealias AfterThird = FollowedPair<BeforeThird, Third>
    public typealias LastW = PairedApplication<P.W,
        IdentityReading<Clock.Zero, BeamSpace, SaturationEncoding>>
    public typealias Path = FollowedPair<AfterThird, LastW>
    public typealias Left = Path.Left
    public typealias Right = Path.Right
    public enum ActualEndpoint: Null {
        public typealias Left = PhaseCyclingBridge.Right
        public typealias Right = Paired<P.W.Right, Clock.Zero>
    }

    // Replace only the reached third clause by the actual current-clock
    // normalization. The whole path now implements the intended Q1 phase.
    public typealias CorrectedThird = PhaseCyclingContacts<D, A, C, B>.NormalizedTwo
    public typealias CorrectedPrefix = FollowedPair<BeforeThird, CorrectedThird>
    public typealias CorrectedLast = PairedApplication<FourLeafPhaseWord<A, C, D, B>,
        IdentityReading<Clock.Zero, BeamSpace, SaturationEncoding>>
    public typealias Corrected = FollowedPair<CorrectedPrefix, CorrectedLast>
    public enum RepairedEndpoint: Null {
        public typealias Left = Corrected.Right
        public typealias Right = Paired<P.Q1.Right, Clock.Zero>
    }
}
