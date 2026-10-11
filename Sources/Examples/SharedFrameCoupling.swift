import VerificationIsIdentification

public enum FrameSwapMenuQuestion: Close {}

/// The six addressed three-port readings, built from actual projections.
/// The subscripts name input positions; arbitrary payload values are kept.
public enum TripleFrameMaps<P: Pair>: Close
where P.Right: Pair, P.Left: Structure, P.Right.Left: Structure, P.Right.Right: Structure {
    public typealias V = CycleProfileTriple<P>
    public typealias F012 = JointEvidence<V.A, JointEvidence<V.B, V.C>>
    public typealias F102 = JointEvidence<V.B, JointEvidence<V.A, V.C>>
    public typealias F021 = JointEvidence<V.A, JointEvidence<V.C, V.B>>
    public typealias F201 = JointEvidence<V.C, JointEvidence<V.A, V.B>>
    public typealias F120 = JointEvidence<V.B, JointEvidence<V.C, V.A>>
    public typealias F210 = JointEvidence<V.C, JointEvidence<V.B, V.A>>
    /// Fixed point 0 selects swap 1/2; 1 selects 0/2; 2 selects 0/1.
    /// The fourth slot is outside the declared three-port answer family.
    public enum SwapMenu: PredicateReading {
        public typealias Actual = JointEvidence<JointEvidence<F021, F210>, JointEvidence<F102, F012>>
        public typealias Left = P
        public typealias Right = BoundaryWorking<
            AddressTriple<P.Left, P.Right.Right, P.Right.Left>,
            AddressTriple<P.Right.Right, P.Right.Left, P.Left>,
            AddressTriple<P.Right.Left, P.Left, P.Right.Right>,
            AddressTriple<P.Left, P.Right.Left, P.Right.Right>>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = FrameSwapMenuQuestion
        public typealias Answer = Right
        public enum Endpoint: Null {
            public typealias Left = Actual.Answer
            public typealias Right = SwapMenu.Answer
        }
    }
}

/// The selector sees its acquired answer and the supplied payload menu.
/// No other entry of the unknown frame is an input to this construction.
public enum FrameSwapInput<F: HasVerdict & Structure, P: Pair>: PredicateReading
where F.Sigma == BeamSpace, F.Encoding == SaturationEncoding, F.Answer: Structure,
      P.Right: Pair, P.Left: Structure, P.Right.Left: Structure, P.Right.Right: Structure {
    public typealias Left = Paired<F, P>
    public typealias Fact = FirstEvidenceImage<Left, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Reply = SequentialReading<Fact, ReadRecordedAnswer<F>>
    public typealias Payload = SecondEvidenceImage<Left, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Menu = SequentialReading<Payload, TripleFrameMaps<P>.SwapMenu>
    public typealias Actual = JointEvidence<Reply, Menu>
    public typealias Right = Paired<F.Answer, TripleFrameMaps<P>.SwapMenu.Answer>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = FrameSwapInput.Answer
    }
}

public typealias FrameSwapAt00<F: HasVerdict & Structure, P: Pair> = SequentialReading<
    FrameSwapInput<F, P>, Route00<TripleFrameMaps<P>.SwapMenu.Answer>>
where F.Sigma == BeamSpace, F.Encoding == SaturationEncoding, F.Answer == RoutingAddress00,
      P.Right: Pair, P.Left: Structure, P.Right.Left: Structure, P.Right.Right: Structure

public typealias FrameSwapAt01<F: HasVerdict & Structure, P: Pair> = SequentialReading<
    FrameSwapInput<F, P>, Route01<TripleFrameMaps<P>.SwapMenu.Answer>>
where F.Sigma == BeamSpace, F.Encoding == SaturationEncoding, F.Answer == RoutingAddress01,
      P.Right: Pair, P.Left: Structure, P.Right.Left: Structure, P.Right.Right: Structure

public typealias FrameSwapAt10<F: HasVerdict & Structure, P: Pair> = SequentialReading<
    FrameSwapInput<F, P>, Route10<TripleFrameMaps<P>.SwapMenu.Answer>>
where F.Sigma == BeamSpace, F.Encoding == SaturationEncoding, F.Answer == RoutingAddress10,
      P.Right: Pair, P.Left: Structure, P.Right.Left: Structure, P.Right.Right: Structure

/// Acquire only the image of the local fixed port, while retaining the
/// full resident frame and the payload beside its actual fact occurrence.
public enum RecordedFrameFixedPoint<T: Pair, P: Structure>: Close
where T.Right: Pair, T.Left: Structure, T.Right.Left: Structure, T.Right.Right: Structure {
    public typealias Root = Paired<T, P>
    public enum Probe: PredicateReading {
        public typealias Actual = ReadFirstProfileSource<Root, CycleProfileTriple<T>.C>
        public typealias Left = Root
        public typealias Right = T.Right.Right
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = OperationSequence<SecondProjection, SecondProjection>
        public typealias Answer = Right
        public enum Endpoint: Null {
            public typealias Left = AddressTriple<Actual.Left, Actual.Answer, Actual.Predicate>
            public typealias Right = AddressTriple<Probe.Left, Probe.Answer, Probe.Predicate>
        }
    }
    public typealias Record = RecordReading<Probe>
    public typealias Fact = FactOf<Probe>
    public typealias SavedFact = SecondEvidenceImage<Record.Right, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias SavedFrame = ReadFirstProfileSource<Record.Right,
        FirstEvidenceImage<Root, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Payload = ReadFirstProfileSource<Record.Right,
        SecondEvidenceImage<Root, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Input = JointEvidence<SavedFact, Payload>
}

/// Compose the actual probe with a supplied fact-only choice. Correct
/// coupling is proved below for the three explicit selectors, not for an
/// arbitrary D that only happens to satisfy this input interface.
public enum ExecuteRecordedFrameSwap<T: Pair, P: Structure, D: PredicateReading>: Pair
where T.Right: Pair, T.Left: Structure, T.Right.Left: Structure, T.Right.Right: Structure,
      D.Left == Paired<RecordedFrameFixedPoint<T, P>.Fact, P>,
      D.Sigma == BeamSpace, D.Encoding == SaturationEncoding, D.Answer: Structure {
    public typealias Read = RecordedFrameFixedPoint<T, P>
    public typealias Choice = SequentialReading<Read.Input, D>
    public typealias RetainedResult = JointEvidence<Read.SavedFrame, JointEvidence<Choice, Read.SavedFact>>
    public typealias Actual = FollowedPair<Read.Record, RetainedResult>
    public typealias Left = Read.Root
    public typealias Result = Paired<T, Paired<D.Answer, Read.Fact>>
    public typealias Right = Result
    public typealias Payload = Result.Right.Left
    public enum Endpoint: Null {
        public typealias Left = Actual.Right
        public typealias Right = Result
    }
    public enum RetainedFrameAndFact: Null {
        public typealias Left = Paired<Result.Left, Result.Right.Right>
        public typealias Right = Paired<T, Read.Fact>
    }
    public enum CurrentFixedPointFactors: ReadingFactors {
        public typealias Left = ReadFirstProfileSource<Result, CycleProfileTriple<T>.C>
        public typealias Observation = SequentialReading<
            SecondEvidenceImage<Result, BeamSpace, SaturationEncoding, SecondProjection>,
            SecondEvidenceImage<Result.Right, BeamSpace, SaturationEncoding, SecondProjection>>
        public typealias Right = ReadRecordedAnswer<Read.Fact>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Left.Predicate
        public typealias Answer = Left.Answer
    }
}

/// All six unknown frame laws, one identical probe and one three-clause
/// selector. Two laws per acquired reply remain unresolved. Each selected
/// remote swap nevertheless implements the same local first-port swap.
public enum ThreePortSharedCoupling<A: Structure, B: Structure, C: Structure>: Close {
    public typealias P = AddressTriple<A, B, C>
    public typealias Ports = AddressTriple<RoutingAddress00, RoutingAddress01, RoutingAddress10>
    public typealias Frames = TripleFrameMaps<Ports>
    public typealias F = TripleFrameMaps<P>
    public typealias T012 = Ports
    public typealias T102 = AddressTriple<RoutingAddress01, RoutingAddress00, RoutingAddress10>
    public typealias T021 = AddressTriple<RoutingAddress00, RoutingAddress10, RoutingAddress01>
    public typealias T201 = AddressTriple<RoutingAddress10, RoutingAddress00, RoutingAddress01>
    public typealias T120 = AddressTriple<RoutingAddress01, RoutingAddress10, RoutingAddress00>
    public typealias T210 = AddressTriple<RoutingAddress10, RoutingAddress01, RoutingAddress00>
    public enum FrameSources: Null {
        public typealias Left = AddressTriple<Paired<Frames.F012.Answer, Frames.F102.Answer>,
            Paired<Frames.F021.Answer, Frames.F201.Answer>, Paired<Frames.F120.Answer, Frames.F210.Answer>>
        public typealias Right = AddressTriple<Paired<T012, T102>, Paired<T021, T201>, Paired<T120, T210>>
    }
    public typealias Q012 = RecordedFrameFixedPoint<T012, P>
    public typealias Q102 = RecordedFrameFixedPoint<T102, P>
    public typealias Q021 = RecordedFrameFixedPoint<T021, P>
    public typealias Q201 = RecordedFrameFixedPoint<T201, P>
    public typealias Q120 = RecordedFrameFixedPoint<T120, P>
    public typealias Q210 = RecordedFrameFixedPoint<T210, P>
    public typealias D012 = FrameSwapAt10<Q012.Fact, P>
    public typealias D102 = FrameSwapAt10<Q102.Fact, P>
    public typealias D021 = FrameSwapAt01<Q021.Fact, P>
    public typealias D201 = FrameSwapAt01<Q201.Fact, P>
    public typealias D120 = FrameSwapAt00<Q120.Fact, P>
    public typealias D210 = FrameSwapAt00<Q210.Fact, P>
    public typealias R012 = ExecuteRecordedFrameSwap<T012, P, D012>
    public typealias R102 = ExecuteRecordedFrameSwap<T102, P, D102>
    public typealias R021 = ExecuteRecordedFrameSwap<T021, P, D021>
    public typealias R201 = ExecuteRecordedFrameSwap<T201, P, D201>
    public typealias R120 = ExecuteRecordedFrameSwap<T120, P, D120>
    public typealias R210 = ExecuteRecordedFrameSwap<T210, P, D210>
    public enum SixActualCouplings: Null {
        public typealias Left = AddressTriple<
            Paired<TripleFrameMaps<R012.Payload>.F012.Answer, TripleFrameMaps<R102.Payload>.F102.Answer>,
            Paired<TripleFrameMaps<R021.Payload>.F021.Answer, TripleFrameMaps<R201.Payload>.F201.Answer>,
            Paired<TripleFrameMaps<R120.Payload>.F120.Answer, TripleFrameMaps<R210.Payload>.F210.Answer>>
        public typealias Right = AddressTriple<
            Paired<SwapFirstTwoTriple<F.F012.Answer>.Answer, SwapFirstTwoTriple<F.F102.Answer>.Answer>,
            Paired<SwapFirstTwoTriple<F.F021.Answer>.Answer, SwapFirstTwoTriple<F.F201.Answer>.Answer>,
            Paired<SwapFirstTwoTriple<F.F120.Answer>.Answer, SwapFirstTwoTriple<F.F210.Answer>.Answer>>
    }
    public enum OnlyTheAcquiredFixedPointIsUsed: Null {
        public typealias Left = AddressTriple<Paired<D012.Left, D102.Left>,
            Paired<D021.Left, D201.Left>, Paired<D120.Left, D210.Left>>
        public typealias Right = AddressTriple<Paired<Paired<Q012.Fact, P>, Paired<Q102.Fact, P>>,
            Paired<Paired<Q021.Fact, P>, Paired<Q201.Fact, P>>,
            Paired<Paired<Q120.Fact, P>, Paired<Q210.Fact, P>>>
    }
    public enum EachReplyLeavesTwoFrames: Null {
        public typealias Left = AddressTriple<Paired<Q012.Probe.Answer, Q102.Probe.Answer>,
            Paired<Q021.Probe.Answer, Q201.Probe.Answer>, Paired<Q120.Probe.Answer, Q210.Probe.Answer>>
        public typealias Right = AddressTriple<Paired<RoutingAddress10, RoutingAddress10>,
            Paired<RoutingAddress01, RoutingAddress01>, Paired<RoutingAddress00, RoutingAddress00>>
    }
}
