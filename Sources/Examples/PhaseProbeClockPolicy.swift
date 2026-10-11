import VerificationIsIdentification

public enum PhaseProbeClockReplyQuestion: Close {}

/// Read the last phase slot of the contacted probe. The clock is outside
/// this reading. With the shared preparation a, Q1 gives c and Q2 gives d.
public enum PhaseProbeClockReply<W: Pair>: PredicateReading
where W.Left: Pair, W.Left.Right: Pair, W.Left.Right.Right: Structure {
    public typealias Phase = FirstEvidenceImage<W, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Tail = FollowedPair<Phase,
        SecondEvidenceImage<W.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Actual = FollowedPair<Tail,
        SecondEvidenceImage<W.Left.Right, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Left = W
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = PhaseProbeClockReplyQuestion
    public typealias Answer = Right
}

/// Three actual Q contacts, with a single record after the first. The next
/// two contacts use their reached sources and retain that same original fact.
public enum PhaseProbeClockReturn<P: PredicateReading, Q: PredicateReading,
    R: PredicateReading>: Pair
where P.Answer == Q.Left, Q.Answer == R.Left,
      P.Left: Structure, P.Answer: Pair, Q.Answer: Structure, R.Answer: Structure,
      P.Answer.Left: Pair, P.Answer.Left.Right: Pair,
      P.Answer.Left.Right.Right: Structure,
      P.Sigma == BeamSpace, Q.Sigma == BeamSpace, R.Sigma == BeamSpace,
      P.Encoding == SaturationEncoding, Q.Encoding == SaturationEncoding,
      R.Encoding == SaturationEncoding {
    public typealias Reply = PhaseProbeClockReply<P.Answer>
    public typealias Fact = FactOf<Reply>
    public typealias First = FollowedPair<P, RecordReading<Reply>>
    public typealias KeepFact = IdentityReading<Fact, BeamSpace, SaturationEncoding>
    public typealias Second = PairedApplication<Q, KeepFact>
    public typealias Third = PairedApplication<R, KeepFact>
    public typealias Path = FollowedPair<FollowedPair<First, Second>, Third>
    public typealias Left = P.Left
    public typealias Right = Paired<R.Answer, Fact>
    public enum Endpoints: Null {
        public typealias Left = Paired<Path.Left, Path.Right>
        public typealias Right = Paired<PhaseProbeClockReturn.Left, PhaseProbeClockReturn.Right>
    }
}

public enum PhaseProbeClockExperiment: Close {
    public typealias AtA = PhaseCyclingContacts<Lit1, Never, Never, Never>
    public typealias AtB = PhaseCyclingContacts<Never, Lit1, Never, Never>
    public typealias AtC = PhaseCyclingContacts<Never, Never, Lit1, Never>
    public typealias AtD = PhaseCyclingContacts<Never, Never, Never, Lit1>
    public typealias Zero = PhaseProbeClockReturn<AtA.AtZero, AtC.AtOne, AtB.AtTwo>
    public typealias One = PhaseProbeClockReturn<AtA.AtOne, AtC.AtTwo, AtC.AtZero>
    public typealias Two = PhaseProbeClockReturn<AtA.AtTwo, AtD.AtZero, AtD.AtOne>
    public enum ReturnedClocks: Null {
        public typealias Left = Paired<Zero.Right.Left.Right,
            Paired<One.Right.Left.Right, Two.Right.Left.Right>>
        public typealias Right = Paired<PhaseBridgeClock.Zero,
            Paired<PhaseBridgeClock.One, PhaseBridgeClock.Two>>
    }
    public enum RetainedReplies: Null {
        public typealias Left = Paired<Zero.Right.Right.Answer,
            Paired<One.Right.Right.Answer, Two.Right.Right.Answer>>
        public typealias Right = Paired<Never, Paired<Never, Lit1>>
    }
    public enum ProbeResidues: Null {
        public typealias Left = Paired<Zero.Right.Left.Left,
            Paired<One.Right.Left.Left, Two.Right.Left.Left>>
        public typealias Right = Paired<FourLeafPhaseMark0,
            Paired<FourLeafPhaseMark1, FourLeafPhaseMark3>>
    }
}

/// Reassociate ((probe-and-clock, fact), (working, program)) as
/// (((working-and-clock, fact), program), probe). Every component survives;
/// the fact is neither remeasured nor relabelled as a different question.
public enum FocusWorkingAfterPhaseProbe<W: Pair>: Pair
where W.Left: Pair, W.Left.Left: Pair,
      W.Left.Left.Left: Structure, W.Left.Left.Right: Structure, W.Left.Right: Structure,
      W.Right: Pair, W.Right.Left: Structure, W.Right.Right: Structure {
    public typealias Left = W
    public typealias World = Paired<W.Right.Left, W.Left.Left.Right>
    public typealias Ready = Paired<Paired<World, W.Left.Right>, W.Right.Right>
    public typealias Right = Paired<Ready, W.Left.Left.Left>
}

public enum PhaseProbeDrivenRun<E: Pair, S: PredicateReading, V: Structure>: Pair
where E.Left: Structure, S.Answer: Structure,
      E.Right: Pair, E.Right.Left: Pair,
      E.Right.Left.Left: Structure, E.Right.Left.Right: Structure, E.Right.Right: Structure,
      S.Left == Paired<Paired<Paired<V, E.Right.Left.Right>, E.Right.Right>,
          PhaseClockNormalizationProgram> {
    public typealias Start = StepBeside<E, Paired<V, PhaseClockNormalizationProgram>>
    public typealias Focus = FocusWorkingAfterPhaseProbe<Start.Right>
    public typealias Apply = StepBeside<S, E.Right.Left.Left>
    public typealias Path = FollowedPair<FollowedPair<Start, Focus>, Apply>
    public typealias Left = Paired<E.Left, Paired<V, PhaseClockNormalizationProgram>>
    public typealias Right = Paired<S.Answer, E.Right.Left.Left>
    public enum Endpoints: Null {
        public typealias Left = Paired<Path.Left, Path.Right>
        public typealias Right = Paired<PhaseProbeDrivenRun.Left, PhaseProbeDrivenRun.Right>
    }
}

/// An unknown initial clock ranges over all three concrete source clauses.
/// The same acquired-reply decoder selects the actual Q or WQ application.
/// The working data remain parked until the probe has returned the clock.
public enum ProbeAcquiredPhaseClockPolicy<A: Structure, B: Structure,
    C: Structure, D: Structure>: Close {
    public typealias E = PhaseProbeClockExperiment
    public typealias V = BoundaryWorking<A, B, C, D>
    public typealias Contacts = PhaseCyclingContacts<A, B, C, D>
    public typealias Moved = PhaseCyclingContacts<D, B, A, C>
    public typealias Zero = PhaseClockPolicyRoot<A, B, C, D, PhaseBridgeClock.Zero,
        Contacts.AtZero, Moved.AtZero, E.Zero.Fact>
    public typealias One = PhaseClockPolicyRoot<A, B, C, D, PhaseBridgeClock.One,
        Contacts.AtOne, Moved.AtOne, E.One.Fact>
    public typealias Two = PhaseClockPolicyRoot<A, B, C, D, PhaseBridgeClock.Two,
        Contacts.AtTwo, Moved.AtTwo, E.Two.Fact>
    public typealias AtZero = PhaseProbeDrivenRun<E.Zero, Zero.Selected<Zero.SelectDirect>, V>
    public typealias AtOne = PhaseProbeDrivenRun<E.One, One.Selected<One.SelectDirect>, V>
    public typealias AtTwo = PhaseProbeDrivenRun<E.Two, Two.Selected<Two.SelectPrefix>, V>
    public enum ActualPhaseAndClock: Null {
        public typealias Left = Paired<AtZero.Right.Left.Left.Left,
            Paired<AtOne.Right.Left.Left.Left, AtTwo.Right.Left.Left.Left>>
        public typealias Target = Contacts.P.Q1.Right
        public typealias Right = Paired<Paired<Target, PhaseBridgeClock.One>,
            Paired<Paired<Target, PhaseBridgeClock.Two>, Paired<Target, PhaseBridgeClock.Zero>>>
    }
    public enum RetainsActualFactsAndProbes: Null {
        public typealias Left = Paired<Paired<AtZero.Right.Left.Left.Right, AtZero.Right.Right>,
            Paired<Paired<AtOne.Right.Left.Left.Right, AtOne.Right.Right>,
                Paired<AtTwo.Right.Left.Left.Right, AtTwo.Right.Right>>>
        public typealias Right = Paired<Paired<E.Zero.Fact, FourLeafPhaseMark0>,
            Paired<Paired<E.One.Fact, FourLeafPhaseMark1>, Paired<E.Two.Fact, FourLeafPhaseMark3>>>
    }
}
