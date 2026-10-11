import VerificationIsIdentification

public enum PhaseClockCorrectionQuestion: Close {}
public enum PhaseClockNormalizationProgram: Close {}

/// Read only the last slot of the resident clock. It is empty at clock zero
/// and one and marked at clock two. The working phase is outside this reading.
public enum PhaseClockCorrectionBit<W: Pair>: PredicateReading
where W.Right: Pair, W.Right.Right: Pair, W.Right.Right.Right: Structure {
    public typealias Clock = SecondEvidenceImage<W, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Tail = SequentialReading<Clock,
        SecondEvidenceImage<W.Right, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Actual = SequentialReading<Tail,
        SecondEvidenceImage<W.Right.Right, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Left = W
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = PhaseClockCorrectionQuestion
    public typealias Answer = Right
}

/// Select from the actual two-leaf catalogue using an acquired fact. The
/// acquisition is supplied separately, so a clock reading or a retained probe
/// reply can feed the same selector without copying or renaming its fact.
/// Concrete paths below establish its applicability to the current clock.
public enum PhaseClockPolicyRoot<A: Structure, B: Structure,
    C: Structure, D: Structure, K: Pair,
    Q: PredicateReading, R: PredicateReading, F: HasVerdict>: Close
where K.Right: Pair, K.Right.Right: Structure,
      Q.Left == Paired<BoundaryWorking<A, B, C, D>, K>,
      R.Left == Paired<BoundaryWorking<D, B, A, C>, K>,
      Q.Answer: Structure, R.Answer: Structure,
      Q.Sigma == BeamSpace, R.Sigma == BeamSpace,
      Q.Encoding == SaturationEncoding, R.Encoding == SaturationEncoding,
      F: Structure, F.Answer: Structure,
      F.Sigma == BeamSpace, F.Encoding == SaturationEncoding {
    public typealias Program = PhaseClockNormalizationProgram
    public typealias Fact = F
    public typealias BeforePrefix = PairedApplication<FourLeafPhaseWord<A, B, C, D>,
        IdentityReading<K, BeamSpace, SaturationEncoding>>
    public typealias Prefix = FollowedPair<BeforePrefix, R>
    public typealias KeepFact = IdentityReading<Fact, BeamSpace, SaturationEncoding>
    public typealias KeepProgram = IdentityReading<Program, BeamSpace, SaturationEncoding>
    public typealias Direct = PairedApplication<PairedApplication<Q, KeepFact>, KeepProgram>
    public typealias Prefixed = PairedApplication<PairedApplication<Prefix, KeepFact>, KeepProgram>
    public typealias Catalogue = CandidateFork<CandidateLeaf<Direct>, CandidateLeaf<Prefixed>>
    public typealias Left = Paired<Paired<Paired<BoundaryWorking<A, B, C, D>, K>, F>, Program>
    public typealias Right = Paired<Paired<Direct.Predicate, Prefixed.Predicate>, Catalogue>
    public typealias Root = Paired<Left, Right>

    public typealias Recorded = FirstEvidenceImage<Left, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias FactImage = SequentialReading<Recorded,
        SecondEvidenceImage<Left.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias AnswerImage = SequentialReading<FactImage, ReadRecordedAnswer<Fact>>
    public typealias ProgramImage = SecondEvidenceImage<Left, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Input = JointEvidence<AnswerImage, ProgramImage>
    public typealias Decoder = PostPairReading<
        FirstEvidenceImage<Input.Answer, BeamSpace, SaturationEncoding, FirstProjection>, Never>
    public typealias SelectDirect = SelectCandidateLeft<SelectCandidateLeaf<Direct>, CandidateLeaf<Prefixed>>
    public typealias SelectPrefix = SelectCandidateRight<CandidateLeaf<Direct>, SelectCandidateLeaf<Prefixed>>

    public typealias Selected<S: CandidateRemoval> = SelectedLocalApplication<
        Root, Input, Decoder, S>
    where S.Left == Catalogue, S.Right: PredicateReading, S.Right.Left == Left,
          S.Right.Sigma == BeamSpace, S.Right.Encoding == SaturationEncoding,
          S.Address == Decoder.Answer
}

/// All current clock sources acquire the signal and execute its selected
/// word. The phase result, next clock and retained fact follow from the path.
public enum AcquiredPhaseClockPolicy<A: Structure, B: Structure,
    C: Structure, D: Structure>: Close {
    public typealias Contacts = PhaseCyclingContacts<A, B, C, D>
    public typealias Moved = PhaseCyclingContacts<D, B, A, C>
    public typealias ZeroSignal = PhaseClockCorrectionBit<Paired<BoundaryWorking<A, B, C, D>, PhaseBridgeClock.Zero>>
    public typealias OneSignal = PhaseClockCorrectionBit<Paired<BoundaryWorking<A, B, C, D>, PhaseBridgeClock.One>>
    public typealias TwoSignal = PhaseClockCorrectionBit<Paired<BoundaryWorking<A, B, C, D>, PhaseBridgeClock.Two>>
    public typealias Zero = PhaseClockPolicyRoot<A, B, C, D, PhaseBridgeClock.Zero,
        Contacts.AtZero, Moved.AtZero, FactOf<ZeroSignal>>
    public typealias One = PhaseClockPolicyRoot<A, B, C, D, PhaseBridgeClock.One,
        Contacts.AtOne, Moved.AtOne, FactOf<OneSignal>>
    public typealias Two = PhaseClockPolicyRoot<A, B, C, D, PhaseBridgeClock.Two,
        Contacts.AtTwo, Moved.AtTwo, FactOf<TwoSignal>>
    public typealias AtZero = FollowedPair<StepBeside<RecordReading<ZeroSignal>, Zero.Program>,
        Zero.Selected<Zero.SelectDirect>>
    public typealias AtOne = FollowedPair<StepBeside<RecordReading<OneSignal>, One.Program>,
        One.Selected<One.SelectDirect>>
    public typealias AtTwo = FollowedPair<StepBeside<RecordReading<TwoSignal>, Two.Program>,
        Two.Selected<Two.SelectPrefix>>
    public enum ActualPhase: Null {
        public typealias Left = Paired<AtZero.Right.Left.Left.Left,
            Paired<AtOne.Right.Left.Left.Left, AtTwo.Right.Left.Left.Left>>
        public typealias Target = Contacts.P.Q1.Right
        public typealias Right = Paired<Target, Paired<Target, Target>>
    }
    public enum ClockAndRecordedBit: Null {
        public typealias Left = Paired<Paired<AtZero.Right.Left.Left.Right, AtZero.Right.Left.Right.Answer>,
            Paired<Paired<AtOne.Right.Left.Left.Right, AtOne.Right.Left.Right.Answer>,
                Paired<AtTwo.Right.Left.Left.Right, AtTwo.Right.Left.Right.Answer>>>
        public typealias Right = Paired<Paired<PhaseBridgeClock.One, Never>,
            Paired<Paired<PhaseBridgeClock.Two, Never>, Paired<PhaseBridgeClock.Zero, Lit1>>>
    }
}
