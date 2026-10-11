import VerificationIsIdentification

public enum MarkedFrameQuestion: Close {}

/// Three clauses of one reading on a three-row carrier with exactly one
/// selected row. A marker is carried beside its value by the actual moves.
public enum MarkedFrameAtFirst<A: Structure, B: Structure, C: Structure>: PredicateReading {
    public typealias Left = AddressTriple<Paired<A, Lit1>, Paired<B, Never>, Paired<C, Never>>
    public typealias Row = CycleProfileTriple<Left>.A
    public typealias Actual = SequentialReading<Row,
        FirstEvidenceImage<Paired<A, Lit1>, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Right = A
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = MarkedFrameQuestion
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = A
    }
}

public enum MarkedFrameAtMiddle<A: Structure, B: Structure, C: Structure>: PredicateReading {
    public typealias Left = AddressTriple<Paired<A, Never>, Paired<B, Lit1>, Paired<C, Never>>
    public typealias Row = CycleProfileTriple<Left>.B
    public typealias Actual = SequentialReading<Row,
        FirstEvidenceImage<Paired<B, Lit1>, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Right = B
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = MarkedFrameQuestion
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = B
    }
}

public enum MarkedFrameAtLast<A: Structure, B: Structure, C: Structure>: PredicateReading {
    public typealias Left = AddressTriple<Paired<A, Never>, Paired<B, Never>, Paired<C, Lit1>>
    public typealias Row = CycleProfileTriple<Left>.C
    public typealias Actual = SequentialReading<Row,
        FirstEvidenceImage<Paired<C, Lit1>, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Right = C
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = MarkedFrameQuestion
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = C
    }
}

/// The answer-side identity for a supplied structural step. Its actual
/// content is identity; O only retains which step this square addresses.
public enum KeepMarkedFrameAnswer<A: Structure, O>: PredicateReading {
    public typealias Actual = IdentityReading<A, BeamSpace, SaturationEncoding>
    public typealias Left = A
    public typealias Right = Actual.Answer
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = O
    public typealias Answer = Right
}

/// Every clause is closed under both adjacent whole-row exchanges. These
/// six generic squares suffice for finite words by composition; the receiver
/// need not acquire which such word occurred to keep the selected value.
public enum MarkedFrameMoves<A: Structure, B: Structure, C: Structure>: Close {
    public typealias S0 = MarkedFrameAtFirst<A, B, C>
    public typealias S1 = MarkedFrameAtMiddle<A, B, C>
    public typealias S2 = MarkedFrameAtLast<A, B, C>
    public enum First0: CommutingTransition {
        public typealias Left = S0
        public typealias Right = MarkedFrameAtMiddle<B, A, C>
        public typealias SourceStep = TripleFrameMaps<Left.Left>.F102
        public typealias ImageStep = KeepMarkedFrameAnswer<A, SourceStep.Predicate>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Operation = SourceStep.Predicate
    }
    public enum First1: CommutingTransition {
        public typealias Left = S1
        public typealias Right = MarkedFrameAtFirst<B, A, C>
        public typealias SourceStep = TripleFrameMaps<Left.Left>.F102
        public typealias ImageStep = KeepMarkedFrameAnswer<B, SourceStep.Predicate>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Operation = SourceStep.Predicate
    }
    public enum First2: CommutingTransition {
        public typealias Left = S2
        public typealias Right = MarkedFrameAtLast<B, A, C>
        public typealias SourceStep = TripleFrameMaps<Left.Left>.F102
        public typealias ImageStep = KeepMarkedFrameAnswer<C, SourceStep.Predicate>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Operation = SourceStep.Predicate
    }
    public enum Last0: CommutingTransition {
        public typealias Left = S0
        public typealias Right = MarkedFrameAtFirst<A, C, B>
        public typealias SourceStep = TripleFrameMaps<Left.Left>.F021
        public typealias ImageStep = KeepMarkedFrameAnswer<A, SourceStep.Predicate>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Operation = SourceStep.Predicate
    }
    public enum Last1: CommutingTransition {
        public typealias Left = S1
        public typealias Right = MarkedFrameAtLast<A, C, B>
        public typealias SourceStep = TripleFrameMaps<Left.Left>.F021
        public typealias ImageStep = KeepMarkedFrameAnswer<B, SourceStep.Predicate>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Operation = SourceStep.Predicate
    }
    public enum Last2: CommutingTransition {
        public typealias Left = S2
        public typealias Right = MarkedFrameAtMiddle<A, C, B>
        public typealias SourceStep = TripleFrameMaps<Left.Left>.F021
        public typealias ImageStep = KeepMarkedFrameAnswer<C, SourceStep.Predicate>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Operation = SourceStep.Predicate
    }
}

/// Read the values while forgetting how the request is attached.
public enum MarkedFrameValues<R: Pair>: PredicateReading
where R.Left: Pair, R.Right: Pair, R.Right.Left: Pair, R.Right.Right: Pair,
      R.Left.Left: Structure, R.Left.Right: Structure,
      R.Right.Left.Left: Structure, R.Right.Left.Right: Structure,
      R.Right.Right.Left: Structure, R.Right.Right.Right: Structure {
    public typealias V = CycleProfileTriple<R>
    public typealias A = SequentialReading<V.A,
        FirstEvidenceImage<R.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias B = SequentialReading<V.B,
        FirstEvidenceImage<R.Right.Left, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias C = SequentialReading<V.C,
        FirstEvidenceImage<R.Right.Right, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Actual = JointEvidence<A, JointEvidence<B, C>>
    public typealias Left = R
    public typealias Right = AddressTriple<R.Left.Left, R.Right.Left.Left, R.Right.Right.Left>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = MarkedFrameValues.Answer
    }
}

/// Exchange the last two values while keeping their request markers in
/// place. This is a different actual transformation of the same source.
public enum MoveFrameValuesWithoutRequest<A: Structure, B: Structure, C: Structure>: PredicateReading {
    public typealias Left = MarkedFrameAtLast<A, B, C>.Left
    public typealias V = MarkedFrameValues<Left>
    public typealias Rows = CycleProfileTriple<Left>
    public typealias BM = SequentialReading<Rows.B,
        SecondEvidenceImage<Left.Right.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias CM = SequentialReading<Rows.C,
        SecondEvidenceImage<Left.Right.Right, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Actual = JointEvidence<Rows.A,
        JointEvidence<JointEvidence<V.C, BM>, JointEvidence<V.B, CM>>>
    public typealias Right = MarkedFrameAtLast<A, C, B>.Left
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = MoveFrameValuesWithoutRequest.Answer
    }
}

/// The acquired fact survives an actual joint move of value and request.
/// Moving only values leaves the same unmarked frame but a different question.
public enum RecordedMarkedFrameMove<A: Structure, B: Structure, C: Structure, P: Structure>: Close {
    public typealias T = MarkedFrameMoves<A, B, C>.Last2
    public typealias Root = Paired<T.Left.Left, P>
    public typealias Record = ArchiveProfileRead<Root, T.Left>
    public typealias Step = StepBeside<T.SourceStep, Record.Right.Right>
    public typealias Actual = FollowedPair<Record, Step>
    public typealias Result = Paired<T.Right.Left, Record.Right.Right>
    public typealias Fact = FactOf<T.Left>
    public enum Endpoint: Null {
        public typealias Left = Actual.Right
        public typealias Right = Result
    }
    public enum CurrentFromOldFact: ReadingFactors {
        public typealias Left = ReadFirstProfileSource<Result, T.Right>
        public typealias Memory = SecondEvidenceImage<Result, BeamSpace, SaturationEncoding, SecondProjection>
        public typealias Observation = SequentialReading<Memory,
            SecondEvidenceImage<Result.Right, BeamSpace, SaturationEncoding, SecondProjection>>
        public typealias Right = ReadRecordedAnswer<Fact>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Left.Predicate
        public typealias Answer = Left.Answer
    }
    public typealias Separate = MoveFrameValuesWithoutRequest<A, B, C>
    public enum SameUnmarkedFrame: Null {
        public typealias Left = MarkedFrameValues<T.SourceStep.Answer>.Answer
        public typealias Right = MarkedFrameValues<Separate.Answer>.Answer
    }
    public enum ActualSeparatedEndpoint: Null {
        public typealias Left = Separate.Actual.Answer
        public typealias Right = Separate.Answer
    }
}

public enum GatedUnmarkedFrameOperation: Close {}

/// One request-dependent rule: exchange the unselected rows when the
/// marker is first, otherwise retain the source. No value equality is read.
public enum GatedUnmarkedFrameMove<A: Structure, B: Structure, C: Structure>: Close {
    public typealias S0 = MarkedFrameAtFirst<A, B, C>
    public typealias S1 = MarkedFrameAtMiddle<A, B, C>
    public typealias S2 = MarkedFrameAtLast<A, B, C>
    public enum At0: PredicateReading {
        public typealias Actual = MarkedFrameMoves<A, B, C>.Last0.SourceStep
        public typealias Left = Actual.Left
        public typealias Right = Actual.Answer
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = GatedUnmarkedFrameOperation
        public typealias Answer = Right
    }
    public enum At1: PredicateReading {
        public typealias Actual = IdentityReading<S1.Left, BeamSpace, SaturationEncoding>
        public typealias Left = Actual.Left
        public typealias Right = Actual.Answer
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = GatedUnmarkedFrameOperation
        public typealias Answer = Right
    }
    public enum At2: PredicateReading {
        public typealias Actual = IdentityReading<S2.Left, BeamSpace, SaturationEncoding>
        public typealias Left = Actual.Left
        public typealias Right = Actual.Answer
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = GatedUnmarkedFrameOperation
        public typealias Answer = Right
    }
    public enum ThreeActualClauses: Null {
        public typealias Left = AddressTriple<At0.Left, At1.Left, At2.Left>
        public typealias Right = AddressTriple<S0.Left, S1.Left, S2.Left>
    }
    public enum EveryClauseKeepsItsSelectedValue: Null {
        public typealias Left = AddressTriple<SequentialReading<At0, MarkedFrameAtFirst<A, C, B>>.Answer,
            SequentialReading<At1, S1>.Answer, SequentialReading<At2, S2>.Answer>
        public typealias Right = AddressTriple<A, B, C>
    }
    public enum EveryClauseReturnsItsWholeSource: Null {
        public typealias Left = AddressTriple<FollowedPair<At0, GatedUnmarkedFrameMove<A, C, B>.At0>.Right,
            FollowedPair<At1, At1>.Right, FollowedPair<At2, At2>.Right>
        public typealias Right = AddressTriple<S0.Left, S1.Left, S2.Left>
    }
}

/// Individually reversible binary changes can require an unavailable joint
/// code. The selected position is first in this witness. Each bit itself
/// retains both contrasting fields, so complement is an actual swap.
public enum BinaryChangeWithoutTernaryLift: Close {
    public typealias Bit0 = Paired<Never, Lit1>
    public typealias Bit1 = Paired<Lit1, Never>
    public typealias Code0 = Paired<Bit0, Bit0>
    public typealias CodeL = Paired<Bit1, Bit0>
    public typealias CodeR = Paired<Bit0, Bit1>
    public typealias Carrier = Paired<Code0, Code0>
    public typealias FirstRow = FirstEvidenceImage<Carrier, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias LastRow = SecondEvidenceImage<Carrier, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias P = FirstEvidenceImage<Code0, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias S = SecondEvidenceImage<Code0, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias LeftImage = JointEvidence<SequentialReading<FirstRow, P>, SequentialReading<LastRow, P>>
    public typealias RightImage = JointEvidence<SequentialReading<FirstRow, S>, SequentialReading<LastRow, S>>
    public typealias Images = JointEvidence<LeftImage, RightImage>
    public typealias Step = PairedApplication<IdentityReading<Bit0, BeamSpace, SaturationEncoding>,
        SwapBoundaryReading<Bit0>>
    public typealias Back = PairedApplication<IdentityReading<Bit0, BeamSpace, SaturationEncoding>,
        SwapBoundaryReading<Bit1>>
    public typealias Cycle = SequentialReading<Step, Back>
    public typealias Both = SequentialReading<Images, PairedApplication<Step, Step>>
    public typealias FirstChanged = FirstEvidenceImage<Both.Answer, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias LastChanged = SecondEvidenceImage<Both.Answer, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias LastBit = SecondEvidenceImage<Step.Answer, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias JoinLast = JointEvidence<SequentialReading<FirstChanged, LastBit>,
        SequentialReading<LastChanged, LastBit>>
    public typealias Actual = SequentialReading<Both, JoinLast>
    public enum CommonSourceAndReversibleBinaryStep: Null {
        public typealias Left = AddressTriple<Images.Left, Cycle.Answer, Step.Answer.Left>
        public typealias Right = AddressTriple<Carrier, Code0, Bit0>
    }
    public enum ForcedJointProfile: Null {
        public typealias Left = Actual.Answer
        public typealias Right = Paired<Bit1, Bit1>
    }
}
