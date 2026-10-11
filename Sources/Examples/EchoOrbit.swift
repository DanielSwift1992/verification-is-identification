import VerificationIsIdentification

/// Acquire once, then obtain a common return seed from the actual retained
/// source. The cycle table travels beside the entire acquisition.
public enum PrepareEchoOrbit<E: Pair, R: PredicateReading, C: Structure>: Pair
where E.Left: Structure, E.Right: Structure, R.Left == E.Right, R.Answer: Structure,
      R.Sigma == BeamSpace, R.Encoding == SaturationEncoding {
    public typealias Run = StepBeside<E, C>
    public typealias Whole = FirstEvidenceImage<Run.Right, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Seed = SequentialReading<Whole, R>
    public typealias Cycle = SecondEvidenceImage<Run.Right, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Prepare = JointEvidence<Whole, JointEvidence<Seed, Cycle>>
    public typealias Actual = FollowedPair<Run, Prepare>
    public typealias Left = Run.Left
    public typealias Right = Paired<E.Right, Paired<R.Answer, C>>
    public enum Endpoint: Null {
        public typealias Left = Actual.Right
        public typealias Right = PrepareEchoOrbit.Right
    }
}

/// Read both retained originals against ONE current return value. Advance
/// acts on that value through C, not on the input positions of an unknown
/// return table. The raw source and the cycle table remain in the whole.
public enum EchoOrbitRound<A: PredicateReading, B: PredicateReading,
    Q: PredicateReading, V: Structure, C: Structure, M: PredicateReading,
    R: PredicateReading, S: PredicateReading,
    T: PredicateReading, U: PredicateReading>: Close
where A.Left == B.Left, A.Left == Q.Left, A.Left: Structure,
      A.Answer: Structure, B.Answer: Structure, Q.Answer == PhaseEqualityTable,
      A.Sigma == BeamSpace, B.Sigma == BeamSpace, Q.Sigma == BeamSpace,
      A.Encoding == SaturationEncoding, B.Encoding == SaturationEncoding,
      Q.Encoding == SaturationEncoding,
      M.Left == Paired<V, C>, M.Answer: Structure,
      M.Sigma == BeamSpace, M.Encoding == SaturationEncoding,
      R.Left == Paired<A.Answer, PhaseEqualityTable>, R.Answer: Structure,
      S.Left == Paired<V, R.Answer>, S.Answer: Structure,
      T.Left == Paired<B.Answer, PhaseEqualityTable>, T.Answer: Structure,
      U.Left == Paired<V, T.Answer>, U.Answer: Structure,
      R.Sigma == BeamSpace, S.Sigma == BeamSpace, T.Sigma == BeamSpace, U.Sigma == BeamSpace,
      R.Encoding == SaturationEncoding, S.Encoding == SaturationEncoding,
      T.Encoding == SaturationEncoding, U.Encoding == SaturationEncoding {
    public typealias State = Paired<A.Left, Paired<V, C>>
    public typealias Whole = FirstEvidenceImage<State, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias RawA = SequentialReading<Whole, A>
    public typealias RawB = SequentialReading<Whole, B>
    public typealias Equality = SequentialReading<Whole, Q>
    public typealias ReturnSite = SecondEvidenceImage<State, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Value = SequentialReading<ReturnSite,
        FirstEvidenceImage<ReturnSite.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Cycle = SequentialReading<ReturnSite,
        SecondEvidenceImage<ReturnSite.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias First = CompareLocalReadings<RawA, Value, Equality, R, S>
    public typealias Second = CompareLocalReadings<RawB, Value, Equality, T, U>
    public typealias Echo = JointEvidence<First, Second>
    public typealias NextValue = SequentialReading<ReturnSite, M>
    public enum Advance: PredicateReading {
        public typealias Actual = JointEvidence<Whole, JointEvidence<NextValue, Cycle>>
        public typealias Left = State
        public typealias Right = Paired<A.Left, Paired<M.Answer, C>>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Actual.Predicate
        public typealias Answer = Right
        public enum Endpoint: Null {
            public typealias Left = Actual.Answer
            public typealias Right = Advance.Right
        }
    }
}

/// Three readings with two actual intervening changes. Earlier records
/// travel beside each change and later reading. No source is reacquired.
public enum ThreeEchoRounds<A: PredicateReading, B: PredicateReading,
    C: PredicateReading, M: Pair, N: Pair>: Pair
where A.Left: Structure, B.Left: Structure, C.Left: Structure,
      M.Left == A.Left, M.Right == B.Left,
      N.Left == B.Left, N.Right == C.Left {
    public typealias First = RecordReading<A>
    public typealias F0 = First.Right.Right
    public typealias Move0 = StepBeside<M, F0>
    public typealias Second = RecordReading<B>
    public typealias F1 = Second.Right.Right
    public typealias Record1 = StepBeside<Second, F0>
    public typealias Move1 = StepBeside<StepBeside<N, F1>, F0>
    public typealias Third = RecordReading<C>
    public typealias F2 = Third.Right.Right
    public typealias Record2 = StepBeside<StepBeside<Third, F1>, F0>
    public typealias Prefix = FollowedPair<FollowedPair<First, Move0>, Record1>
    public typealias Actual = FollowedPair<FollowedPair<Prefix, Move1>, Record2>
    public typealias Left = A.Left
    public typealias Right = Paired<Paired<Paired<C.Left, F2>, F1>, F0>
    public enum Endpoint: Null {
        public typealias Left = Actual.Right
        public typealias Right = ThreeEchoRounds.Right
    }
}

/// The known four-cycle is built from three actual coordinate exchanges.
/// Its lookup use below acts on the value supplied to this fixed table.
public enum FourReturnCycle: Close {
    public typealias First = FourLeafPhase0<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11>
    public typealias Second = FourLeafPhase1<RoutingAddress01, RoutingAddress00,
        RoutingAddress10, RoutingAddress11>
    public typealias Third = FourLeafPhase2<RoutingAddress01, RoutingAddress10,
        RoutingAddress00, RoutingAddress11>
    public typealias Actual = FollowedPair<FollowedPair<First, Second>, Third>
    public typealias Table = Actual.Right
    public enum Orbit: Null {
        public typealias Left = BoundaryWorking<Route00<Table>.Answer, Route01<Table>.Answer,
            Route10<Table>.Answer, Route11<Table>.Answer>
        public typealias Right = BoundaryWorking<RoutingAddress01, RoutingAddress10,
            RoutingAddress11, RoutingAddress00>
    }
}
