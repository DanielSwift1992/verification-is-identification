import VerificationIsIdentification

/// The first two values of a supplied phase-image table, as different source
/// questions. Full paths distinguish the two projections even on equal values.
public typealias PhaseLawProbe0<L: Pair> = SequentialReading<
    FirstEvidenceImage<L, BeamSpace, SaturationEncoding, FirstProjection>,
    FirstEvidenceImage<L.Left, BeamSpace, SaturationEncoding, FirstProjection>>
where L.Left: Pair
public typealias PhaseLawProbe1<L: Pair> = SequentialReading<
    FirstEvidenceImage<L, BeamSpace, SaturationEncoding, FirstProjection>,
    SecondEvidenceImage<L.Left, BeamSpace, SaturationEncoding, SecondProjection>>
where L.Left: Pair

/// Record one value, perform the supplied source change beside that record,
/// then record the second value from the actual new source. C is not assumed
/// to leave the law unchanged; neither record is retroactively moved in time.
public enum PhaseLawTwoProbeTrace<C: Pair>: Pair
where C.Left: Pair, C.Left.Left: Pair, C.Right: Pair, C.Right.Left: Pair {
    public typealias First = RecordReading<PhaseLawProbe0<C.Left>>
    public typealias Change = StepBeside<C, First.Right.Right>
    public typealias Second = RecordReading<PhaseLawProbe1<C.Right>>
    public typealias Finish = StepBeside<Second, First.Right.Right>
    public typealias Path = FollowedPair<FollowedPair<First, Change>, Finish>
    public typealias Left = C.Left
    public typealias Right = Paired<Second.Right, First.Right.Right>
    public enum Endpoints: Null {
        public typealias Left = Paired<PhaseLawTwoProbeTrace.Left, PhaseLawTwoProbeTrace.Right>
        public typealias Right = Paired<Path.Left, Path.Right>
    }
}

/// The supplied change construction stays in the description of each history.
/// The available fact projection below does not read that retained context.
public typealias RetainedPhaseLawInquiry<C: Pair> = StepBeside<PhaseLawTwoProbeTrace<C>, C>
where C.Left: Pair, C.Left.Left: Pair, C.Right: Pair, C.Right.Left: Pair

public enum PhaseLawFactsQuestion: Close {}
public enum PhaseLawProbeFacts<W: Pair>: PredicateReading
where W.Left: Pair, W.Left.Left: Pair,
      W.Left.Right: Structure, W.Left.Left.Right: Structure {
    public typealias Left = W
    public typealias Right = Paired<W.Left.Right, W.Left.Left.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = PhaseLawFactsQuestion
    public typealias Answer = Right
}

/// A separate question about the current law, not about the two past readings.
public typealias PhaseLawCurrent<W: Pair> = SequentialReading<
    SequentialReading<FirstEvidenceImage<W, BeamSpace, SaturationEncoding, FirstProjection>,
        FirstEvidenceImage<W.Left, BeamSpace, SaturationEncoding, FirstProjection>>,
    FirstEvidenceImage<W.Left.Left, BeamSpace, SaturationEncoding, FirstProjection>>
where W.Left: Pair, W.Left.Left: Pair

/// Both histories keep their full source and two true records. The second
/// applies the already derived even W permutation to the law table internally.
public enum PhaseLawMixedHistory<A: Structure, B: Structure, C: Structure, D: Structure>: Close {
    public typealias Initial = BoundaryWorking<A, B, C, D>
    public typealias Stable = RetainedPhaseLawInquiry<IdentityReading<Initial, BeamSpace, SaturationEncoding>>
    public typealias Changed = RetainedPhaseLawInquiry<FourLeafPhaseWord<A, B, C, D>>
    public typealias OldFacts = PhaseLawProbeFacts<Stable.Right>
    public typealias NewFacts = PhaseLawProbeFacts<Changed.Right>
    public typealias OldLaw = PhaseLawCurrent<Stable.Right>
    public typealias NewLaw = PhaseLawCurrent<Changed.Right>
    public enum SameAvailableFacts: Null {
        public typealias Left = OldFacts.Answer
        public typealias Right = NewFacts.Answer
    }
    public enum ActualCurrentLaws: Null {
        public typealias Left = Paired<OldLaw.Answer, NewLaw.Answer>
        public typealias Right = Paired<Initial, BoundaryWorking<D, B, A, C>>
    }
    public enum OneQuestion: Null {
        public typealias Left = Paired<OldFacts.Predicate, OldLaw.Predicate>
        public typealias Right = Paired<NewFacts.Predicate, NewLaw.Predicate>
    }
}
