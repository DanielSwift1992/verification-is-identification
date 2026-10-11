import VerificationIsIdentification

/// Combine two actual squares at one and the same source step. The image
/// functions may differ; neither their names nor their answers are identified.
public enum SharedChannelTransition<P: CommutingTransition, S: CommutingTransition>: CommutingTransition
where P.SourceStep == S.SourceStep,
      P.Left.Answer: Structure, S.Left.Answer: Structure,
      P.Right.Answer: Structure, S.Right.Answer: Structure {
    public typealias Left = JointEvidence<P.Left, S.Left>
    public typealias Right = JointEvidence<P.Right, S.Right>
    public typealias SourceStep = P.SourceStep
    public typealias Sigma = P.Sigma
    public typealias Encoding = P.Encoding
    public typealias Operation = P.Operation
    public enum ImageStep: PredicateReading {
        public typealias Actual = PairedApplication<P.ImageStep, S.ImageStep>
        public typealias Left = Actual.Left
        public typealias Right = Actual.Answer
        public typealias Sigma = P.Sigma
        public typealias Encoding = P.Encoding
        public typealias Predicate = P.Operation
        public typealias Answer = Right
    }
}

/// Perform the supplied common step once, then acquire both current readings.
/// Each acquisition retains that successor and the earlier memory. The final
/// decoder receives only its two actual facts. This does not establish the
/// supplied squares for other sources or for an arbitrary unknown mechanism.
public enum RecordedSharedChannelStep<P: CommutingTransition, S: CommutingTransition,
    H: Structure>: Close
where P.SourceStep == S.SourceStep, P.Sigma == BeamSpace,
      P.Encoding == SaturationEncoding,
      P.SourceStep.Left: Structure, P.SourceStep.Answer: Structure,
      P.Left.Answer: Structure, S.Left.Answer: Structure,
      P.Right.Answer: Structure, S.Right.Answer: Structure {
    public typealias Joint = SharedChannelTransition<P, S>
    public typealias Root = Paired<P.SourceStep.Left, H>
    public typealias Step = StepBeside<P.SourceStep, H>
    public typealias First = ArchiveProfileRead<Step.Right, P.Right>
    public typealias Second = ArchiveProfileRead<First.Right, S.Right>
    public typealias Actual = FollowedPair<FollowedPair<Step, First>, Second>
    public typealias FP = FactOf<P.Right>
    public typealias FS = FactOf<S.Right>
    public typealias Memory = Paired<Paired<H, FP>, FS>
    public typealias Result = Paired<P.SourceStep.Answer, Memory>
    public typealias Saved = SecondEvidenceImage<Result, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Old = SequentialReading<Saved,
        FirstEvidenceImage<Memory, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias PFact = SequentialReading<Old,
        SecondEvidenceImage<Memory.Left, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias SFact = SequentialReading<Saved,
        SecondEvidenceImage<Memory, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Facts = JointEvidence<PFact, SFact>
    public enum Endpoint: Null {
        public typealias Left = Paired<Actual.Left, Actual.Right>
        public typealias Right = Paired<Root, Result>
    }
    public enum CurrentJointFromAcquiredFacts: ReadingFactors {
        public typealias Left = ReadFirstProfileSource<Result, Joint.Right>
        public typealias Observation = Facts
        public typealias Right = TwoRecordedAnswers<Paired<FP, FS>>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Left.Predicate
        public typealias Answer = Left.Answer
    }
}

public enum FirstProfileChannel: Close {}
public enum SecondProfileChannel: Close {}

/// Actual column projections of a three-row joint profile. No decoding from
/// a channel name is used: all six entries are read at their source addresses.
public enum ThreeRowChannels<A: Pair, B: Pair, C: Pair>: Close
where A.Left: Structure, A.Right: Structure, B.Left: Structure,
      B.Right: Structure, C.Left: Structure, C.Right: Structure {
    public typealias Source = AddressTriple<A, B, C>
    public typealias Rows = CycleProfileTriple<Source>
    public enum P: PredicateReading {
        public typealias Actual = JointEvidence<SequentialReading<Rows.A,
            FirstEvidenceImage<A, BeamSpace, SaturationEncoding, FirstProjection>>,
            JointEvidence<SequentialReading<Rows.B,
                FirstEvidenceImage<B, BeamSpace, SaturationEncoding, FirstProjection>>,
                SequentialReading<Rows.C,
                FirstEvidenceImage<C, BeamSpace, SaturationEncoding, FirstProjection>>>>
        public typealias Left = Source
        public typealias Right = AddressTriple<A.Left, B.Left, C.Left>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = FirstProfileChannel
        public typealias Answer = Right
        public enum Endpoint: Null {
            public typealias Left = Actual.Answer
            public typealias Right = P.Answer
        }
    }
    public enum S: PredicateReading {
        public typealias Actual = JointEvidence<SequentialReading<Rows.A,
            SecondEvidenceImage<A, BeamSpace, SaturationEncoding, SecondProjection>>,
            JointEvidence<SequentialReading<Rows.B,
                SecondEvidenceImage<B, BeamSpace, SaturationEncoding, SecondProjection>>,
                SequentialReading<Rows.C,
                SecondEvidenceImage<C, BeamSpace, SaturationEncoding, SecondProjection>>>>
        public typealias Left = Source
        public typealias Right = AddressTriple<A.Right, B.Right, C.Right>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = SecondProfileChannel
        public typealias Answer = Right
        public enum Endpoint: Null {
            public typealias Left = Actual.Answer
            public typealias Right = S.Answer
        }
    }
}

/// A whole-row exchange gives two independently constructed image squares.
/// The last selected row stays in place; both channels commute at every value.
public enum SharedFirstRowsExchange<A: Pair, B: Pair, C: Pair>: Close
where A.Left: Structure, A.Right: Structure, B.Left: Structure,
      B.Right: Structure, C.Left: Structure, C.Right: Structure {
    public typealias Before = ThreeRowChannels<A, B, C>
    public typealias After = ThreeRowChannels<B, A, C>
    public typealias Move = TripleFrameMaps<Before.Source>.F102
    public enum P: CommutingTransition {
        public typealias Left = Before.P
        public typealias Right = After.P
        public typealias SourceStep = Move
        public typealias ImageStep = TripleFrameMaps<Before.P.Answer>.F102
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Operation = SourceStep.Predicate
    }
    public enum S: CommutingTransition {
        public typealias Left = Before.S
        public typealias Right = After.S
        public typealias SourceStep = Move
        public typealias ImageStep = TripleFrameMaps<Before.S.Answer>.F102
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Operation = SourceStep.Predicate
    }
    public enum Return: Null {
        public typealias Left = FollowedPair<Move, SharedFirstRowsExchange<B, A, C>.Move>.Right
        public typealias Right = Before.Source
    }
}

/// The two nontrivial clauses of M64an's source law, plus the third actual
/// source that prevents its S channel from having an autonomous successor.
/// All omitted source clauses are identity in the finite mathematical law.
public enum HiddenTernaryExchange: Close {
    public typealias Bits = BinaryChangeWithoutTernaryLift
    public typealias O = Bits.Code0
    public typealias L = Bits.CodeL
    public typealias R = Bits.CodeR
    public typealias Outside0 = ThreeRowChannels<O, R, R>
    public typealias Outside1 = ThreeRowChannels<R, O, R>
    public typealias Available = ThreeRowChannels<L, R, R>
    public typealias Move = SharedFirstRowsExchange<O, R, R>
    public typealias Back = SharedFirstRowsExchange<R, O, R>
    public typealias Stay = IdentityReading<Available.Source, BeamSpace, SaturationEncoding>
    public typealias ChangedS = SequentialReading<Move.Move, Outside1.S>
    public typealias KeptS = SequentialReading<Stay, Available.S>
    public enum SameActualChannelInput: Null {
        public typealias Left = Outside0.S.Answer
        public typealias Right = Available.S.Answer
    }
    public enum TheSelectedRowAndWholeSourceReturn: Null {
        public typealias Left = Paired<FollowedPair<Move.Move, Back.Move>.Right,
            CycleProfileTriple<Move.Move.Answer>.C.Answer>
        public typealias Right = Paired<Outside0.Source, R>
    }
    public enum DifferentActualChannelSuccessors: Null {
        public typealias Left = Paired<ChangedS.Answer, KeptS.Answer>
        public typealias Right = Paired<AddressTriple<Bits.Bit1, Bits.Bit0, Bits.Bit1>,
            AddressTriple<Bits.Bit0, Bits.Bit1, Bits.Bit1>>
    }
}

/// On all four joint codes, two different reversible image operations have
/// one actual common reversible source operation. The middle row starts at
/// (0,1), so its successor (1,1) pinpoints the missing ternary possibility.
public enum IndependentFourProfileChannels: Close {
    public typealias Bits = BinaryChangeWithoutTernaryLift
    public typealias O = Bits.Code0
    public typealias R = Bits.CodeR
    public typealias Both = Paired<Bits.Bit1, Bits.Bit1>
    public typealias Before = ThreeRowChannels<O, R, R>
    public typealias After = ThreeRowChannels<O, Both, R>
    public typealias Flip = SwapBoundaryReading<Bits.Bit0>
    public typealias FlipBack = SwapBoundaryReading<Bits.Bit1>
    public typealias Middle = PairedApplication<Flip,
        IdentityReading<Bits.Bit1, BeamSpace, SaturationEncoding>>
    public typealias MiddleBack = PairedApplication<FlipBack,
        IdentityReading<Bits.Bit1, BeamSpace, SaturationEncoding>>
    public typealias Move = PairedApplication<IdentityReading<O, BeamSpace, SaturationEncoding>,
        PairedApplication<Middle, IdentityReading<R, BeamSpace, SaturationEncoding>>>
    public typealias Back = PairedApplication<IdentityReading<O, BeamSpace, SaturationEncoding>,
        PairedApplication<MiddleBack, IdentityReading<R, BeamSpace, SaturationEncoding>>>
    public enum PImage: PredicateReading {
        public typealias Actual = PairedApplication<IdentityReading<Bits.Bit0, BeamSpace, SaturationEncoding>,
            PairedApplication<Flip, IdentityReading<Bits.Bit0, BeamSpace, SaturationEncoding>>>
        public typealias Left = Actual.Left
        public typealias Right = Actual.Answer
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Predicate = Move.Predicate
        public typealias Answer = Right
    }
    public enum P: CommutingTransition {
        public typealias Left = Before.P
        public typealias Right = After.P
        public typealias SourceStep = Move
        public typealias ImageStep = PImage
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Operation = Move.Predicate
    }
    public enum S: CommutingTransition {
        public typealias Left = Before.S
        public typealias Right = After.S
        public typealias SourceStep = Move
        public typealias ImageStep = KeepMarkedFrameAnswer<Before.S.Answer, Move.Predicate>
        public typealias Sigma = BeamSpace
        public typealias Encoding = SaturationEncoding
        public typealias Operation = Move.Predicate
    }
    public enum FullReturnAndSelectedRow: Null {
        public typealias Left = Paired<FollowedPair<Move, Back>.Right,
            CycleProfileTriple<Move.Answer>.C.Answer>
        public typealias Right = Paired<Before.Source, R>
    }
    public enum TheFourthProfileIsActuallyRead: Null {
        public typealias Left = CycleProfileTriple<Move.Answer>.B.Answer
        public typealias Right = Both
    }
}

/// The middle P value is complemented and its S value replaced by the
/// resident first-row zero. Two different ternary sources then merge in
/// the current profile. Recording this reading retains the complete source.
public enum RetainedLossyProfile<B: Pair>: Close
where B.Left == BinaryChangeWithoutTernaryLift.Bit0, B.Right: Structure {
    public typealias Bits = BinaryChangeWithoutTernaryLift
    public typealias Before = ThreeRowChannels<Bits.Code0, B, Bits.CodeR>
    public typealias Rows = Before.Rows
    public typealias MiddleP = SequentialReading<Rows.B,
        FirstEvidenceImage<B, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias ChangedP = SequentialReading<MiddleP, SwapBoundaryReading<Bits.Bit0>>
    public typealias ResidentZero = SequentialReading<Rows.A,
        SecondEvidenceImage<Bits.Code0, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Move = JointEvidence<Rows.A,
        JointEvidence<JointEvidence<ChangedP, ResidentZero>, Rows.C>>
    public typealias Result = AddressTriple<Bits.Code0, Bits.CodeL, Bits.CodeR>
    public typealias Record = RecordReading<Move>
    public typealias RecoverSource = FirstEvidenceImage<Record.Right,
        BeamSpace, SaturationEncoding, FirstProjection>
    public enum ActualCurrentProfile: Null {
        public typealias Left = Move.Answer
        public typealias Right = Result
    }
    public enum HistoryRetainsTheWholeInput: Null {
        public typealias Left = RecoverSource.Answer
        public typealias Right = Before.Source
    }
}

/// A reserve is an actual fourth resident row. Exchange it with the first
/// working row; both old contents are retained and the same exchange returns.
public enum ExchangeFirstRowWithReserve<A: Structure, B: Structure,
    C: Structure, R: Structure>: PredicateReading {
    public typealias Source = AddressTriple<A, B, C>
    public typealias Left = Paired<Source, R>
    public typealias First = ReadFirstProfileSource<Left,
        FirstEvidenceImage<Source, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Tail = ReadFirstProfileSource<Left,
        SecondEvidenceImage<Source, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Reserve = SecondEvidenceImage<Left, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Actual = JointEvidence<JointEvidence<Reserve, Tail>, First>
    public typealias Right = Paired<AddressTriple<R, B, C>, A>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
    public enum Endpoint: Null {
        public typealias Left = Actual.Answer
        public typealias Right = ExchangeFirstRowWithReserve.Answer
    }
    public enum Return: Null {
        public typealias Left = SequentialReading<ExchangeFirstRowWithReserve,
            ExchangeFirstRowWithReserve<R, B, C, A>>.Answer
        public typealias Right = ExchangeFirstRowWithReserve.Left
    }
}

/// The fixed experiment uses the forward and return applications stored in
/// its own context. It prepares the previously unavailable profile, performs
/// that resident application, records the actual S reading, and returns both
/// target and reserve. The fact describes the contacted preparation, not the
/// restored target's current reading. No selection inspects the hidden law.
public enum ProbeOutsideFromResidentReserve<T: PredicateReading, B: PredicateReading,
    Q: PredicateReading, H: Structure>: Close
where T.Left == HiddenTernaryExchange.Outside0.Source,
      B.Left == T.Answer, B.Answer == T.Left, Q.Left == T.Answer,
      T.Sigma == BeamSpace, B.Sigma == BeamSpace, Q.Sigma == BeamSpace,
      T.Encoding == SaturationEncoding, B.Encoding == SaturationEncoding,
      Q.Encoding == SaturationEncoding, Q.Predicate == SecondProfileChannel,
      T.Answer: Structure, Q.Answer: Structure {
    public typealias C = HiddenTernaryExchange
    public typealias Prepare = ExchangeFirstRowWithReserve<C.L, C.R, C.R, C.O>
    public typealias Undo = ExchangeFirstRowWithReserve<C.O, C.R, C.R, C.L>
    public typealias Context = Paired<T, Paired<B, H>>
    public typealias Root = Paired<Prepare.Left, Context>
    public typealias Prepared = StepBeside<Prepare, Context>
    public typealias ResidentForward = Prepared.Right.Right.Left
    public typealias Change = StepBeside<StepBeside<ResidentForward, C.L>, Context>
    public typealias AtContact = FollowedPair<Prepared, Change>
    public typealias Reading = ReadFirstProfileSource<Paired<T.Answer, C.L>, Q>
    public typealias Record = ArchiveProfileRead<AtContact.Right, Reading>
    public typealias Acquired = FollowedPair<AtContact, Record>
    public typealias Memory = Paired<Context, FactOf<Q>>
    public typealias ResidentBack = Record.Right.Right.Left.Right.Left
    public typealias ReturnContact = StepBeside<StepBeside<ResidentBack, C.L>, Memory>
    public typealias ReturnPreparation = StepBeside<Undo, Memory>
    public typealias Actual = FollowedPair<FollowedPair<Acquired, ReturnContact>, ReturnPreparation>
    public typealias Result = Paired<Prepare.Left, Memory>
    public typealias Saved = SecondEvidenceImage<Result, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Fact = SequentialReading<Saved,
        SecondEvidenceImage<Memory, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Reply = SequentialReading<Fact, ReadRecordedAnswer<FactOf<Q>>>
    public enum CompletePath: Null {
        public typealias Left = Paired<Actual.Left, Actual.Right>
        public typealias Right = Paired<Root, Result>
    }
    public enum BothResidentApplicationsAndTheOldHistoryRemain: Null {
        public typealias Left = AddressTriple<Result.Right.Left.Left,
            Result.Right.Left.Right.Left, Result.Right.Left.Right.Right>
        public typealias Right = AddressTriple<T, B, H>
    }
    public enum ReadBackIsTheActualAcquiredReply: Null {
        public typealias Left = Reply.Answer
        public typealias Right = Q.Answer
    }
}

public enum InternalProfileContrast<H: Structure>: Close {
    public typealias C = HiddenTernaryExchange
    public typealias Idle = IdentityReading<C.Outside0.Source, BeamSpace, SaturationEncoding>
    public typealias Quiet = ProbeOutsideFromResidentReserve<Idle, Idle, C.Outside0.S, H>
    public typealias Active = ProbeOutsideFromResidentReserve<C.Move.Move, C.Back.Move, C.Outside1.S, H>
    public enum SameInitialAndReturnedWorkingWorld: Null {
        public typealias Left = Paired<Quiet.Root.Left, Active.Result.Left>
        public typealias Right = Paired<Active.Root.Left, Quiet.Result.Left>
    }
    public enum TheNewRepliesAreTheContrastingProfiles: Null {
        public typealias Left = Paired<Quiet.Reply.Answer, Active.Reply.Answer>
        public typealias Right = Paired<C.Outside0.S.Answer, C.Outside1.S.Answer>
    }
}

/// A complete six-state reversible realization of the losing ternary
/// profile change on residual-zero preparations. The residual is an input
/// field and changes the future rule; it is not a freely reusable blank.
public enum MinimalTernaryResidual: Close {
    public typealias Bits = BinaryChangeWithoutTernaryLift
    public typealias Z = Bits.Bit0
    public typealias I = Bits.Bit1
    public typealias O = Bits.Code0
    public typealias L = Bits.CodeL
    public typealias R = Bits.CodeR
    public typealias O0 = Paired<O, Z>
    public typealias L0 = Paired<L, Z>
    public typealias R0 = Paired<R, Z>
    public typealias O1 = Paired<O, I>
    public typealias L1 = Paired<L, I>
    public typealias R1 = Paired<R, I>
    public typealias Flip0 = SwapBoundaryReading<Z>
    public typealias Flip1 = SwapBoundaryReading<I>
    public typealias Keep0 = IdentityReading<Z, BeamSpace, SaturationEncoding>
    public typealias O0ToL0 = PairedApplication<PairedApplication<Flip0, Keep0>, Keep0>
    public typealias L0ToO0 = PairedApplication<PairedApplication<Flip1, Keep0>, Keep0>
    public typealias R0ToL1 = PairedApplication<PairedApplication<Flip0, Flip1>, Flip0>
    public typealias L1ToR0 = PairedApplication<PairedApplication<Flip1, Flip0>, Flip1>
    public typealias StayO1 = IdentityReading<O1, BeamSpace, SaturationEncoding>
    public typealias StayR1 = IdentityReading<R1, BeamSpace, SaturationEncoding>
    public enum AllActualEndpoints: Null {
        public typealias Left = Paired<
            Paired<AddressTriple<O0ToL0.Left, L0ToO0.Left, R0ToL1.Left>,
                AddressTriple<StayO1.Left, L1ToR0.Left, StayR1.Left>>,
            Paired<AddressTriple<O0ToL0.Answer, L0ToO0.Answer, R0ToL1.Answer>,
                AddressTriple<StayO1.Answer, L1ToR0.Answer, StayR1.Answer>>>
        public typealias Right = Paired<
            Paired<AddressTriple<O0, L0, R0>, AddressTriple<O1, L1, R1>>,
            Paired<AddressTriple<L0, O0, L1>, AddressTriple<O1, R0, R1>>>
    }
    public enum EveryCompleteInputReturns: Null {
        public typealias Left = Paired<AddressTriple<SequentialReading<O0ToL0, L0ToO0>.Answer,
            SequentialReading<L0ToO0, O0ToL0>.Answer, SequentialReading<R0ToL1, L1ToR0>.Answer>,
            AddressTriple<SequentialReading<StayO1, StayO1>.Answer,
            SequentialReading<L1ToR0, R0ToL1>.Answer, SequentialReading<StayR1, StayR1>.Answer>>
        public typealias Right = Paired<AddressTriple<O0, L0, R0>, AddressTriple<O1, L1, R1>>
    }
    public typealias OldZeroProfile = FirstEvidenceImage<O0, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias OldOneProfile = FirstEvidenceImage<O1, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias AfterZero = SequentialReading<O0ToL0,
        FirstEvidenceImage<L0, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias AfterOne = SequentialReading<StayO1,
        FirstEvidenceImage<O1, BeamSpace, SaturationEncoding, FirstProjection>>
    public enum SameProfileBeforeDifferentCurrentChanges: Null {
        public typealias Left = Paired<OldZeroProfile.Answer, OldOneProfile.Answer>
        public typealias Right = Paired<O, O>
    }
    public enum PreparedInputsHaveTheRequiredCurrentImages: Null {
        public typealias Left = AddressTriple<O0ToL0.Answer.Left,
            L0ToO0.Answer.Left, R0ToL1.Answer.Left>
        public typealias Right = AddressTriple<L, O, L>
    }
    public enum TheMergerUsesDifferentResiduals: Null {
        public typealias Left = Paired<O0ToL0.Answer.Right, R0ToL1.Answer.Right>
        public typealias Right = Paired<Z, I>
    }
}
