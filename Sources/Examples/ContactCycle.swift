import VerificationIsIdentification

/// Read h at x, Dx and D²x through the same resident h and D fields.
/// The resulting record stores three images once for subsequent contacts.
public enum ThreeCycleImages<V: Structure, H: Structure, D: Structure,
    C: Structure, D0: PredicateReading, D1: PredicateReading,
    H0: PredicateReading, H1: PredicateReading, H2: PredicateReading>: PredicateReading
where D0.Left == Paired<V, D>, D0.Answer: Structure,
      D1.Left == Paired<D0.Answer, D>, D1.Answer: Structure,
      H0.Left == Paired<V, H>, H1.Left == Paired<D0.Answer, H>,
      H2.Left == Paired<D1.Answer, H>,
      H0.Answer: Structure, H1.Answer: Structure, H2.Answer: Structure,
      D0.Sigma == BeamSpace, D1.Sigma == BeamSpace,
      H0.Sigma == BeamSpace, H1.Sigma == BeamSpace, H2.Sigma == BeamSpace,
      D0.Encoding == SaturationEncoding, D1.Encoding == SaturationEncoding,
      H0.Encoding == SaturationEncoding, H1.Encoding == SaturationEncoding,
      H2.Encoding == SaturationEncoding {
    public typealias Left = Paired<V, AddressTriple<H, D, C>>
    public typealias Point = FirstEvidenceImage<Left, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Tables = SecondEvidenceImage<Left, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Channel = SequentialReading<Tables,
        FirstEvidenceImage<Tables.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Tail = SequentialReading<Tables,
        SecondEvidenceImage<Tables.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias InputContact = SequentialReading<Tail,
        FirstEvidenceImage<Tail.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Next = SequentialReading<JointEvidence<Point, InputContact>, D0>
    public typealias Last = SequentialReading<JointEvidence<Next, InputContact>, D1>
    public typealias Image0 = SequentialReading<JointEvidence<Point, Channel>, H0>
    public typealias Image1 = SequentialReading<JointEvidence<Next, Channel>, H1>
    public typealias Image2 = SequentialReading<JointEvidence<Last, Channel>, H2>
    public typealias Actual = JointEvidence<Image0, JointEvidence<Image1, Image2>>
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
}

/// Apply the current C to the first two recorded images, compare with the
/// next two, and record only the pair of square verdicts for the receiver.
/// A generic Pair shape does not by itself assert the cycle or bijection
/// scope; the admitted finite table constructions and M64m supply it.
public enum TwoCycleSquares<I: PredicateReading,
    C0: PredicateReading, C1: PredicateReading,
    R0: PredicateReading, S0: PredicateReading,
    R1: PredicateReading, S1: PredicateReading>: Pair
where I.Left: Pair, I.Left.Right: Pair, I.Left.Right.Right: Pair,
      I.Left.Right.Right.Right: Structure,
      I.Answer: Pair, I.Answer.Right: Pair,
      I.Answer.Left: Structure, I.Answer.Right.Left: Structure, I.Answer.Right.Right: Structure,
      I.Sigma == BeamSpace, I.Encoding == SaturationEncoding,
      C0.Left == Paired<I.Answer.Left, I.Left.Right.Right.Right>, C0.Answer: Structure,
      C1.Left == Paired<I.Answer.Right.Left, I.Left.Right.Right.Right>, C1.Answer: Structure,
      R0.Left == Paired<C0.Answer, PhaseEqualityTable>, R0.Answer: Structure,
      S0.Left == Paired<I.Answer.Right.Left, R0.Answer>, S0.Answer: Structure,
      R1.Left == Paired<C1.Answer, PhaseEqualityTable>, R1.Answer: Structure,
      S1.Left == Paired<I.Answer.Right.Right, R1.Answer>, S1.Answer: Structure,
      C0.Sigma == BeamSpace, C1.Sigma == BeamSpace,
      R0.Sigma == BeamSpace, S0.Sigma == BeamSpace, R1.Sigma == BeamSpace, S1.Sigma == BeamSpace,
      C0.Encoding == SaturationEncoding, C1.Encoding == SaturationEncoding,
      R0.Encoding == SaturationEncoding, S0.Encoding == SaturationEncoding,
      R1.Encoding == SaturationEncoding, S1.Encoding == SaturationEncoding {
    public typealias RecordImages = RecordReading<I>
    public typealias Run = StepBeside<RecordImages, PhaseEqualityTable>
    public typealias Recorded = FirstEvidenceImage<Run.Right, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Source = SequentialReading<Recorded,
        FirstEvidenceImage<RecordImages.Right, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Tables = SequentialReading<Source,
        SecondEvidenceImage<I.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Tail = SequentialReading<Tables,
        SecondEvidenceImage<Tables.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Contact = SequentialReading<Tail,
        SecondEvidenceImage<Tail.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Fact = SequentialReading<Recorded,
        SecondEvidenceImage<RecordImages.Right, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Values = SequentialReading<Fact, ReadRecordedAnswer<Fact.Answer>>
    public typealias V0 = SequentialReading<Values,
        FirstEvidenceImage<Values.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias VTail = SequentialReading<Values,
        SecondEvidenceImage<Values.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias V1 = SequentialReading<VTail,
        FirstEvidenceImage<VTail.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias V2 = SequentialReading<VTail,
        SecondEvidenceImage<VTail.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Image0 = SequentialReading<JointEvidence<V0, Contact>, C0>
    public typealias Image1 = SequentialReading<JointEvidence<V1, Contact>, C1>
    public typealias Equality = SecondEvidenceImage<Run.Right, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias First = CompareLocalReadings<Image0, V1, Equality, R0, S0>
    public typealias Second = CompareLocalReadings<Image1, V2, Equality, R1, S1>
    public typealias Squares = JointEvidence<First, Second>
    public typealias Record = RecordReading<Squares>
    public typealias Actual = FollowedPair<Run, Record>
    public typealias Left = Actual.Left
    public typealias Right = Actual.Right
    public enum RetainsSourceAndImages: Null {
        public typealias Left = TwoCycleSquares.Right.Left.Left
        public typealias Right = RecordImages.Right
    }
}

public enum ContactCycleCalibration: Close {
    public typealias Identity = BoundaryWorking<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11>
    public typealias Words = PhaseWordCatalogue<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11>
    // Tables encode point images; they are inverse to the corresponding
    // payload transport. D has point cycle (0 2 3), fixed point 1.
    public typealias D = Words.WW.Right
    public typealias T = FourLeafPhase0<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11>.Right
    public typealias Conjugate = Words.WWZWW.Right
    public typealias Missing = BoundaryWorking<RoutingAddress00, RoutingAddress11,
        RoutingAddress10, RoutingAddress01>
    public typealias UncoveredFixed = BoundaryWorking<RoutingAddress00, RoutingAddress00,
        RoutingAddress10, RoutingAddress11>
    public typealias Collapsed = BoundaryWorking<RoutingAddress01, RoutingAddress01,
        RoutingAddress01, RoutingAddress01>
    public typealias GoodImages = ThreeCycleImages<RoutingAddress00, Identity, D, D,
        Route00<D>, Route10<D>, Route00<Identity>, Route10<Identity>, Route11<Identity>>
    public typealias OddImages = ThreeCycleImages<RoutingAddress00, T, D, Conjugate,
        Route00<D>, Route10<D>, Route00<T>, Route10<T>, Route11<T>>
    public typealias MissingImages = ThreeCycleImages<RoutingAddress00, Missing, D, D,
        Route00<D>, Route10<D>, Route00<Missing>, Route10<Missing>, Route11<Missing>>
    public typealias Good = TwoCycleSquares<GoodImages, Route00<D>, Route10<D>,
        Route10<PhaseEqualityTable>, Route10<FourLeafPhaseMark2>,
        Route11<PhaseEqualityTable>, Route11<FourLeafPhaseMark3>>
    public typealias Odd = TwoCycleSquares<OddImages, Route01<Conjugate>, Route10<Conjugate>,
        Route10<PhaseEqualityTable>, Route10<FourLeafPhaseMark2>,
        Route11<PhaseEqualityTable>, Route11<FourLeafPhaseMark3>>
    public typealias MissingPoint = TwoCycleSquares<MissingImages, Route00<D>, Route10<D>,
        Route10<PhaseEqualityTable>, Route10<FourLeafPhaseMark2>,
        Route11<PhaseEqualityTable>, Route01<FourLeafPhaseMark3>>
    public typealias UncoveredImages = ThreeCycleImages<RoutingAddress00, UncoveredFixed, D, D,
        Route00<D>, Route10<D>, Route00<UncoveredFixed>, Route10<UncoveredFixed>, Route11<UncoveredFixed>>
    public typealias Uncovered = TwoCycleSquares<UncoveredImages, Route00<D>, Route10<D>,
        Route10<PhaseEqualityTable>, Route10<FourLeafPhaseMark2>,
        Route11<PhaseEqualityTable>, Route11<FourLeafPhaseMark3>>
    public typealias CollapsedImages = ThreeCycleImages<RoutingAddress00, Collapsed, D, D,
        Route00<D>, Route10<D>, Route00<Collapsed>, Route10<Collapsed>, Route11<Collapsed>>
    public typealias Collapse = TwoCycleSquares<CollapsedImages, Route01<D>, Route01<D>,
        Route01<PhaseEqualityTable>, Route01<FourLeafPhaseMark1>,
        Route01<PhaseEqualityTable>, Route01<FourLeafPhaseMark1>>
    // These direct table compositions expose the missing fixed-point
    // relation. They are not an additional acquired bit in the two-test run.
    public typealias UncoveredFixedReply = PairedApplication<Route01<UncoveredFixed>,
        IdentityReading<D, BeamSpace, SaturationEncoding>>
    public typealias UncoveredFixedThenC = SequentialReading<UncoveredFixedReply, Route00<D>>
    public enum SameEvidenceOutsideBijections: Null {
        public typealias Left = Paired<Uncovered.Right.Right, Collapse.Right.Right>
        public typealias Right = Paired<Good.Right.Right, Good.Right.Right>
    }
    public enum MissingFixedEquation: Null {
        public typealias Left = Paired<UncoveredFixedReply.Answer.Left, UncoveredFixedThenC.Answer>
        public typealias Right = Paired<RoutingAddress00, RoutingAddress10>
    }
    public enum CollapseHasNoContrast: Null {
        public typealias Left = CollapsedImages.Image0.Answer
        public typealias Right = CollapsedImages.Image1.Answer
    }
    public enum CollapseIntertwines: Null {
        public typealias Left = PhaseWordCatalogue<Collapsed.Left.Left, Collapsed.Left.Right,
            Collapsed.Right.Left, Collapsed.Right.Right>.WW.Right
        public typealias Image = Route01<D>.Answer
        public typealias Right = BoundaryWorking<Image, Image, Image, Image>
    }
    public enum Verdicts: Null {
        public typealias Left = AddressTriple<Good.Squares.Answer, Odd.Squares.Answer,
            MissingPoint.Squares.Answer>
        public typealias Right = AddressTriple<Paired<Lit1, Lit1>, Paired<Lit1, Lit1>, Paired<Lit1, Never>>
    }
    public enum SameFullPositiveEvidence: Null {
        public typealias Left = Good.Right.Right
        public typealias Right = Odd.Right.Right
    }
    public enum DifferentPrivateImages: Null {
        public typealias Left = Paired<GoodImages.Answer, OddImages.Answer>
        public typealias Right = Paired<AddressTriple<RoutingAddress00, RoutingAddress10, RoutingAddress11>,
            AddressTriple<RoutingAddress01, RoutingAddress10, RoutingAddress11>>
    }
}

/// Four cycling positions and one fixed position. Two adjacent tested
/// edges leave a cycle vertex isolated; swapping it with the fixed vertex
/// preserves those tests but changes the full action.
public enum FourCycleUncoveredPoint<A: Structure, B: Structure, C: Structure,
    D: Structure, E: Structure>: Close {
    public typealias S0 = FourLeafStage0<A, B, C, D, E>
    public typealias S1 = FourLeafStage1<B, A, C, D, E>
    public typealias S2 = FourLeafStage2<C, A, B, D, E>
    public typealias Cycle = FollowedPair<FollowedPair<S0, S1>, S2>
    public enum Swap: Pair {
        public typealias Left = FourLeafStageLabels<A, B, C, D, E>
        public typealias Right = FourLeafStageLabels<A, B, C, E, D>
    }
    public enum AfterCycle: Pair {
        public typealias Left = Cycle.Right
        public typealias Right = FourLeafStageLabels<Left.Left, Left.Right.Left.Left,
            Left.Right.Left.Right, Left.Right.Right.Right, Left.Right.Right.Left>
    }
    public typealias Other0 = FourLeafStage0<A, B, C, E, D>
    public typealias Other1 = FourLeafStage1<B, A, C, E, D>
    public typealias Other2 = FourLeafStage2<C, A, B, E, D>
    public typealias LeftPath = FollowedPair<Cycle, AfterCycle>
    public typealias RightPath = FollowedPair<Swap, FollowedPair<FollowedPair<Other0, Other1>, Other2>>
    public enum SameTwoFields: Null {
        public typealias Left = LeftPath.Right.Right.Left
        public typealias Right = RightPath.Right.Right.Left
    }
    public enum DifferentOtherField: Null {
        public typealias Left = Paired<LeftPath.Right.Left, RightPath.Right.Left>
        public typealias Right = Paired<D, E>
    }
}
