import VerificationIsIdentification

/// Record the actual available reading, then focus a prepared world on its
/// answer. The original whole and the new fact remain in the carried archive.
public enum JointReplyBegin<O: PredicateReading, P: Structure,
    R: Structure>: Pair
where O.Left: Structure, O.Answer: Structure {
    public typealias Prepared = LocalPhaseWorld<FourLeafCenter, P, Paired<FirstProjection, R>>
    public typealias Record = StepBeside<RecordReading<O>, Prepared>
    public enum Focus: Pair {
        public typealias Left = Record.Right
        public typealias Fact = Left.Left.Right
        public typealias Memory = ReadRecordedAnswer<Fact>
        public typealias World = Left.Right
        public typealias Context = Paired<Memory.Answer,
            Paired<World.Right.Right.Left, Paired<Left.Left, World.Right.Right.Right>>>
        public typealias Right = LocalPhaseWorld<World.Left, World.Right.Left, Context>
    }
    public typealias Actual = FollowedPair<Record, Focus>
    public typealias Left = Actual.Left
    public typealias Right = Actual.Right
    public enum RetainsAcquisition: Null {
        public typealias Whole = JointReplyBegin.Right
        public typealias Left = Paired<Whole.Right.Right.Right.Right.Left.Left,
            Whole.Right.Right.Right.Right.Right>
        public typealias Right = Paired<O.Left, R>
    }
}

/// The actual world carries (memory, (selector instruction, rest)).
/// Decode that memory, then project one side of the resulting word pair.
/// The current working data are absent from the decoder input.
public enum JointReplyPolicy<W: Pair, D: PredicateReading,
    Side: PredicateReading>: PredicateReading
where W.Right: Pair, W.Right.Right: Pair, W.Right.Right.Right: Pair,
      W.Right.Right.Right.Left == FirstProjection,
      D.Left == W.Right.Right.Left, Side.Left == D.Answer,
      Side.Answer: Structure,
      D.Sigma == BeamSpace, Side.Sigma == BeamSpace,
      D.Encoding == SaturationEncoding, Side.Encoding == SaturationEncoding {
    public typealias Tail = SecondEvidenceImage<W, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Context = SequentialReading<Tail,
        SecondEvidenceImage<W.Right, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Memory = SequentialReading<Context,
        FirstEvidenceImage<W.Right.Right, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Decoded = SequentialReading<Memory, D>
    public typealias Address = SequentialReading<Decoded, Side>
    public typealias Resources = SequentialReading<Context,
        SecondEvidenceImage<W.Right.Right, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Instruction = SequentialReading<Resources,
        FirstEvidenceImage<W.Right.Right.Right, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Actual = JointEvidence<Address, Instruction>
    public typealias Left = W
    public typealias Right = Paired<Side.Answer, FirstProjection>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Actual.Answer
}

/// Selection is bound both to this actual root and to the address read
/// from its memory. The admitted roots below are the calibrated forward
/// and inverse catalogues; the admitted Side are first/second projections.
/// Arbitrary root or PredicateReading conformances are not a calibration.
public enum JointReplySelection<Root: Pair, D: PredicateReading,
    Side: PredicateReading, S: CandidateRemoval>: PredicateReading
where Root.Left: Pair, Root.Left.Right: Pair, Root.Left.Right.Right: Pair,
      Root.Left.Right.Right.Right: Pair,
      Root.Left.Right.Right.Right.Left == FirstProjection,
      Root.Right: Pair, Root.Right.Left: Structure,
      D.Left == Root.Left.Right.Right.Left, Side.Left == D.Answer,
      Side.Answer: Structure, S.Address == Side.Answer,
      S.Left == Root.Right.Right, S.Right: PredicateReading,
      S.Right.Left == Root.Left,
      D.Sigma == BeamSpace, Side.Sigma == BeamSpace, S.Right.Sigma == BeamSpace,
      D.Encoding == SaturationEncoding, Side.Encoding == SaturationEncoding,
      S.Right.Encoding == SaturationEncoding {
    public typealias Input = JointReplyPolicy<Root.Left, D, Side>
    public typealias Choice = FirstEvidenceImage<Input.Answer,
        BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Actual = SelectedLocalApplication<Root, Input, Choice, S>
    public typealias Left = Root.Left
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
}
