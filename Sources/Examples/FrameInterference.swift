import VerificationIsIdentification

/// An actual fixed-port acquisition followed by an actual change of the
/// resident frame. The archive is retained; its applicability is not assumed.
public enum FrameProbeThenMove<T: Pair, P: Structure, M: PredicateReading>: Pair
where T.Right: Pair, T.Left: Structure, T.Right.Left: Structure, T.Right.Right: Structure,
      M.Left == T, M.Sigma == BeamSpace, M.Encoding == SaturationEncoding,
      M.Answer: Pair, M.Answer.Right: Pair, M.Answer.Left: Structure,
      M.Answer.Right.Left: Structure, M.Answer.Right.Right: Structure {
    public typealias Read = RecordedFrameFixedPoint<T, P>
    public typealias Move = PairedApplication<
        PairedApplication<M, IdentityReading<P, BeamSpace, SaturationEncoding>>,
        IdentityReading<Read.Fact, BeamSpace, SaturationEncoding>>
    public typealias Changed = FollowedPair<Read.Record, Move>
    public typealias Actual = FollowedPair<Changed, ReassociateProfileRecord<Changed.Right>>
    public typealias Left = Read.Root
    public typealias Result = Paired<M.Answer, Paired<P, Read.Fact>>
    public typealias Right = Result
    public typealias Frame = M.Answer
    public typealias Memory = Paired<P, Read.Fact>
    public typealias Saved = SecondEvidenceImage<Result, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias OldFact = SequentialReading<Saved,
        SecondEvidenceImage<Memory, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Payload = SequentialReading<Saved,
        FirstEvidenceImage<Memory, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Current = ReadFirstProfileSource<Result, CycleProfileTriple<Frame>.C>
    public enum Endpoint: Null {
        public typealias Left = Actual.Right
        public typealias Right = Result
    }
    public enum ArchiveIsTheAcquiredFact: Null {
        public typealias Left = OldFact.Answer
        public typealias Right = Read.Fact
    }
}

/// An arbitrary first-pair exchange changes the frame without changing the
/// acquired fixed-port question. No equality of the full frames is required.
public enum FrameMovePreservesFixedPort<T: Pair, P: Structure>: ReadingFactors
where T.Right: Pair, T.Left: Structure, T.Right.Left: Structure, T.Right.Right: Structure {
    public typealias M = TripleFrameMaps<T>.F102
    public typealias R = FrameProbeThenMove<T, P, M>
    public typealias Left = R.Current
    public typealias Observation = R.OldFact
    public typealias Right = ReadRecordedAnswer<R.Read.Fact>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Left.Predicate
    public typealias Answer = Left.Answer
}

/// Move the requested occurrence with the frame. After exchanging slots
/// 1/2, the old third-slot question is now at slot 1. Its correspondence
/// follows from the actual composite projection for arbitrary contents.
public enum FrameMoveTransportsRequest<T: Pair, P: Structure>: Close
where T.Right: Pair, T.Left: Structure, T.Right.Left: Structure, T.Right.Right: Structure {
    public typealias M = TripleFrameMaps<T>.F021
    public typealias R = FrameProbeThenMove<T, P, M>
    public typealias Now = CycleProfileTriple<M.Answer>.B
    public typealias Pullback = SequentialReading<M, Now>
    public typealias Current = ReadFirstProfileSource<R.Result, Now>
    public enum OriginalOccurrence: Null {
        public typealias Left = Pullback.Answer
        public typealias Right = CycleProfileTriple<T>.C.Answer
    }
    public enum OldFactAnswersTransportedRequest: Null {
        public typealias Left = Current.Answer
        public typealias Right = ReadRecordedAnswer<R.Read.Fact>.Answer
    }
}

/// Use a retained fact after an actual change, without a new contact.
/// Applicability is established for the transported request below; it is
/// not asserted for arbitrary choices or for the old coordinate request.
public enum ExecuteMovedFrameSwap<T: Pair, P: Structure,
    M: PredicateReading, D: PredicateReading>: Pair
where T.Right: Pair, T.Left: Structure, T.Right.Left: Structure, T.Right.Right: Structure,
      M.Left == T, M.Sigma == BeamSpace, M.Encoding == SaturationEncoding,
      M.Answer: Pair, M.Answer.Right: Pair, M.Answer.Left: Structure,
      M.Answer.Right.Left: Structure, M.Answer.Right.Right: Structure,
      D.Left == Paired<FrameProbeThenMove<T, P, M>.Read.Fact, P>,
      D.Sigma == BeamSpace, D.Encoding == SaturationEncoding, D.Answer: Structure {
    public typealias Read = FrameProbeThenMove<T, P, M>
    public typealias Input = JointEvidence<Read.OldFact, Read.Payload>
    public typealias Choice = SequentialReading<Input, D>
    public typealias Frame = FirstEvidenceImage<Read.Result, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Retain = JointEvidence<Frame, JointEvidence<Choice, Read.OldFact>>
    public typealias Actual = FollowedPair<Read, Retain>
    public typealias Left = Read.Left
    public typealias Result = Paired<M.Answer, Paired<D.Answer, Read.Read.Fact>>
    public typealias Right = Result
    public enum Endpoint: Null {
        public typealias Left = Actual.Right
        public typealias Right = Result
    }
}

/// A new contact at the changed source, retaining the previous occurrence.
/// The new answer is produced by that source, not selected from its old fact.
public enum ReprobeMovedFrame<T: Pair, P: Structure, M: PredicateReading>: Pair
where T.Right: Pair, T.Left: Structure, T.Right.Left: Structure, T.Right.Right: Structure,
      M.Left == T, M.Sigma == BeamSpace, M.Encoding == SaturationEncoding,
      M.Answer: Pair, M.Answer.Right: Pair, M.Answer.Left: Structure,
      M.Answer.Right.Left: Structure, M.Answer.Right.Right: Structure {
    public typealias Before = FrameProbeThenMove<T, P, M>
    public typealias Read = RecordedFrameFixedPoint<M.Answer, Before.Memory>
    public typealias Actual = FollowedPair<Before, Read.Record>
    public typealias Left = Before.Left
    public typealias Result = Paired<Paired<M.Answer, Before.Memory>, Read.Fact>
    public typealias Right = Result
    public typealias Frame = Read.SavedFrame
    public typealias Memory = Read.Payload
    public typealias Payload = SequentialReading<Memory,
        FirstEvidenceImage<Before.Memory, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias OldFact = SequentialReading<Memory,
        SecondEvidenceImage<Before.Memory, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias NewFact = Read.SavedFact
    public typealias Input = JointEvidence<NewFact, Payload>
    public enum Endpoint: Null {
        public typealias Left = Actual.Right
        public typealias Right = Result
    }
    public enum CurrentFixedPointFactors: ReadingFactors {
        public typealias Left = ReadFirstProfileSource<Result,
            ReadFirstProfileSource<Result.Left, CycleProfileTriple<M.Answer>.C>>
        public typealias Observation = NewFact
        public typealias Right = ReadRecordedAnswer<Read.Fact>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Left.Predicate
        public typealias Answer = Left.Answer
    }
}

/// Use only the new acquired fact and the payload to select an action.
/// Both occurrences remain beside the current frame and actual result.
public enum ExecuteReprobedFrameSwap<T: Pair, P: Structure,
    M: PredicateReading, D: PredicateReading>: Pair
where T.Right: Pair, T.Left: Structure, T.Right.Left: Structure, T.Right.Right: Structure,
      M.Left == T, M.Sigma == BeamSpace, M.Encoding == SaturationEncoding,
      M.Answer: Pair, M.Answer.Right: Pair, M.Answer.Left: Structure,
      M.Answer.Right.Left: Structure, M.Answer.Right.Right: Structure,
      D.Left == Paired<ReprobeMovedFrame<T, P, M>.Read.Fact, P>,
      D.Sigma == BeamSpace, D.Encoding == SaturationEncoding, D.Answer: Structure {
    public typealias Read = ReprobeMovedFrame<T, P, M>
    public typealias Choice = SequentialReading<Read.Input, D>
    public typealias Facts = JointEvidence<Read.OldFact, Read.NewFact>
    public typealias Retain = JointEvidence<Read.Frame, JointEvidence<Choice, Facts>>
    public typealias Actual = FollowedPair<Read, Retain>
    public typealias Left = Read.Left
    public typealias Result = Paired<M.Answer,
        Paired<D.Answer, Paired<Read.Before.Read.Fact, Read.Read.Fact>>>
    public typealias Right = Result
    public enum Endpoint: Null {
        public typealias Left = Actual.Right
        public typealias Right = Result
    }
}

/// The same old reply and the same intervening word need different new
/// actions. One actual new point contact separates the two live cases.
public enum ThreePortInterference<A: Structure, B: Structure, C: Structure>: Close {
    public typealias P = AddressTriple<A, B, C>
    public typealias T0 = AddressTriple<RoutingAddress00, RoutingAddress01, RoutingAddress10>
    public typealias T1 = AddressTriple<RoutingAddress01, RoutingAddress00, RoutingAddress10>
    public typealias M0 = TripleFrameMaps<T0>.F021
    public typealias M1 = TripleFrameMaps<T1>.F021
    public typealias Old0 = FrameProbeThenMove<T0, P, M0>
    public typealias Old1 = FrameProbeThenMove<T1, P, M1>
    public typealias KeptD0 = FrameSwapAt10<Old0.Read.Fact, P>
    public typealias KeptD1 = FrameSwapAt10<Old1.Read.Fact, P>
    public typealias KeptRun0 = ExecuteMovedFrameSwap<T0, P, M0, KeptD0>
    public typealias KeptRun1 = ExecuteMovedFrameSwap<T1, P, M1, KeptD1>
    public typealias New0 = ReprobeMovedFrame<T0, P, M0>
    public typealias New1 = ReprobeMovedFrame<T1, P, M1>
    public typealias D0 = FrameSwapAt01<New0.Read.Fact, P>
    public typealias D1 = FrameSwapAt00<New1.Read.Fact, P>
    public typealias Run0 = ExecuteReprobedFrameSwap<T0, P, M0, D0>
    public typealias Run1 = ExecuteReprobedFrameSwap<T1, P, M1, D1>
    public enum SameOldInputAndKnownWord: Null {
        public typealias Left = Paired<Old0.Read.Fact, M0.Predicate>
        public typealias Right = Paired<Old1.Read.Fact, M1.Predicate>
    }
    public enum CurrentRepliesAreTheOtherOldField: Null {
        public typealias Left = Paired<Old0.Current.Answer, Old1.Current.Answer>
        public typealias Right = Paired<RoutingAddress01, RoutingAddress00>
    }
    public enum BothNewContactsAddressTheChangedSource: Null {
        public typealias Left = Paired<New0.Endpoint.Left, New1.Endpoint.Left>
        public typealias Right = Paired<New0.Endpoint.Right, New1.Endpoint.Right>
    }
    public enum BothChoicesAreCoupledAtTheCurrentFrame: Null {
        public typealias Left = Paired<TripleFrameMaps<D0.Answer>.F021.Answer,
            TripleFrameMaps<D1.Answer>.F120.Answer>
        public typealias Right = Paired<SwapFirstTwoTriple<TripleFrameMaps<P>.F021.Answer>.Answer,
            SwapFirstTwoTriple<TripleFrameMaps<P>.F120.Answer>.Answer>
    }
    public enum ActualUsesRetainBothOccurrences: Null {
        public typealias Left = Paired<Run0.Endpoint.Left, Run1.Endpoint.Left>
        public typealias Right = Paired<Run0.Endpoint.Right, Run1.Endpoint.Right>
    }
    public enum BothOldChoicesServeTheTransportedRequest: Null {
        public typealias Left = Paired<TripleFrameMaps<KeptD0.Answer>.F021.Answer,
            TripleFrameMaps<KeptD1.Answer>.F120.Answer>
        public typealias Right = Paired<TripleFrameMaps<TripleFrameMaps<P>.F021.Answer>.F210.Answer,
            TripleFrameMaps<TripleFrameMaps<P>.F120.Answer>.F210.Answer>
    }
    public enum TransportedUsesNeedNoSecondFact: Null {
        public typealias Left = Paired<KeptRun0.Endpoint.Left, KeptRun1.Endpoint.Left>
        public typealias Right = Paired<KeptRun0.Endpoint.Right, KeptRun1.Endpoint.Right>
    }
}

/// The same four-port change word has a two-element orbit on opposite
/// swaps and a four-element orbit on adjacent swaps. Each rewrite below
/// composes the existing turn, actual swap word and actual inverse turn.
public enum RotatingSwapQuestions<A: Structure, B: Structure, C: Structure, D: Structure>: Close {
    public typealias P = BoundaryWorking<A, B, C, D>
    public typealias Turn = FourSlotTurn<A, B, C, D>.Forward
    public typealias Opposite = FollowedPair<FourLeafPhase1<A, B, C, D>,
        FollowedPair<FourLeafPhase0<A, C, B, D>, FourLeafPhase1<C, A, B, D>>>
    public typealias Complement = FollowedPair<FourLeafPhase1<A, B, C, D>,
        FollowedPair<FourLeafPhase2<A, C, B, D>, FourLeafPhase1<A, C, D, B>>>
    public typealias Rotated = RotatingSwapQuestions<B, C, D, A>
    public typealias TurnOpposite = FollowedPair<Turn,
        FollowedPair<Rotated.Opposite, FourSlotTurn<D, C, B, A>.Backward>>
    public typealias TurnComplement = FollowedPair<Turn,
        FollowedPair<Rotated.Complement, FourSlotTurn<B, A, D, C>.Backward>>
    public enum TwoQuestionClosure: Null {
        public typealias Left = Paired<TurnOpposite.Right, TurnComplement.Right>
        public typealias Right = Paired<Complement.Right, Opposite.Right>
    }
    public typealias TurnAdjacent0 = FollowedPair<Turn,
        FollowedPair<FourLeafPhase0<B, C, D, A>, FourSlotTurn<C, B, D, A>.Backward>>
    public typealias TurnAdjacent1 = FollowedPair<Turn,
        FollowedPair<FourLeafPhase1<B, C, D, A>, FourSlotTurn<B, D, C, A>.Backward>>
    public typealias TurnAdjacent2 = FollowedPair<Turn,
        FollowedPair<FourLeafPhase2<B, C, D, A>, FourSlotTurn<B, C, A, D>.Backward>>
    public typealias TurnAdjacent3 = FollowedPair<Turn,
        FollowedPair<FourLeafPhase3<B, C, D, A>, FourSlotTurn<A, C, D, B>.Backward>>
    public enum FourQuestionClosure: Null {
        public typealias Left = BoundaryWorking<TurnAdjacent0.Right, TurnAdjacent1.Right,
            TurnAdjacent2.Right, TurnAdjacent3.Right>
        public typealias Right = BoundaryWorking<FourLeafPhase1<A, B, C, D>.Right,
            FourLeafPhase2<A, B, C, D>.Right, FourLeafPhase3<A, B, C, D>.Right,
            FourLeafPhase0<A, B, C, D>.Right>
    }
    public enum AllWordsBeginAtTheActualWorkingSource: Null {
        public typealias Left = AddressTriple<Paired<TurnOpposite.Left, TurnComplement.Left>,
            Paired<TurnAdjacent0.Left, TurnAdjacent1.Left>,
            Paired<TurnAdjacent2.Left, TurnAdjacent3.Left>>
        public typealias Right = AddressTriple<Paired<P, P>, Paired<P, P>, Paired<P, P>>
    }
}
