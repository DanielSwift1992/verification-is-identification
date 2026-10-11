import VerificationIsIdentification

/// Read the same two connection patterns through a supplied output frame.
/// On the identity frame these are the actual current tables after the
/// first acquisition of JointReplyExecutionInputs: ZW and I as point maps.
/// The array action is inverse to its point map, hence WWZ on frame values.
public enum ReplyChannelsInFrame<A: Structure, B: Structure,
    C: Structure, D: Structure>: PredicateReading {
    public typealias Frame = BoundaryWorking<A, B, C, D>
    public typealias First = PhaseWordCatalogue<A, B, C, D>.WWZ
    public typealias Second = IdentityReading<Frame, BeamSpace, SaturationEncoding>
    public typealias Actual = JointEvidence<First, Second>
    public typealias Left = Frame
    public typealias Right = Paired<BoundaryWorking<B, C, A, D>, Frame>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = ReplyChannelsInFrame.Right
    }
}

/// The second connection retains the entire frame. Recover it, exchange
/// its first two basis labels, and express both connections through it again.
/// This transition is defined on the displayed coherent connection family;
/// it is not a claimed reframe operation on two unrelated arbitrary tables.
public enum ReplyFrameChange<A: Structure, B: Structure,
    C: Structure, D: Structure>: PredicateReading {
    public typealias Frame = BoundaryWorking<A, B, C, D>
    public typealias Before = ReplyChannelsInFrame<A, B, C, D>
    public typealias Recover = SecondEvidenceImage<Before.Answer,
        BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Change = FourLeafPhase0<A, B, C, D>
    public typealias After = ReplyChannelsInFrame<B, A, C, D>
    public typealias Actual = SequentialReading<SequentialReading<Recover, Change>, After>
    public typealias Left = Before.Answer
    public typealias Right = After.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = ReplyFrameChange.Right
    }
    public enum Return: Null {
        public typealias Path = FollowedPair<ReplyFrameChange,
            ReplyFrameChange<B, A, C, D>>
        public typealias Left = Path.Right
        public typealias Right = Path.Left
    }
}

/// Read retained replies after the current connection field has changed.
/// No field of that current connection is part of this memory projection.
public enum RetainedJointReplyMemory<T: Pair>: PredicateReading
where T.Left: Pair, T.Left.Left: Pair, T.Left.Right: Structure,
      T.Left.Left.Right: Structure, T.Right: Structure {
    public typealias Trace = FirstEvidenceImage<T, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Old = SequentialReading<Trace,
        SecondEvidenceImage<T.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias NewTrace = SequentialReading<Trace,
        FirstEvidenceImage<T.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias New = SequentialReading<NewTrace,
        SecondEvidenceImage<T.Left.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Table = SecondEvidenceImage<T, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Actual = JointEvidence<JointEvidence<Old, New>, Table>
    public typealias Left = T
    public typealias Right = Paired<Paired<T.Left.Right, T.Left.Left.Right>, T.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = RetainedJointReplyMemory.Right
    }
}

/// A working-frame exchange, carrying the stage and all controller memory.
/// This is a supplied reversible transport, not a zero-cost physical claim.
public enum ReplyWorkingFrame<A: Structure, B: Structure, C: Structure,
    D: Structure, K: Structure>: PredicateReading {
    public typealias Actual = PairedApplication<
        IdentityReading<FourLeafCenter, BeamSpace, SaturationEncoding>,
        ExperimentReadingBeside<FourLeafPhase0<A, B, C, D>, K>>
    public typealias Left = Actual.Left
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
}
