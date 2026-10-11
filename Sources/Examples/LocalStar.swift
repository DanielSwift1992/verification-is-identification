import VerificationIsIdentification

/// Three exchanges of one center with its leaves. The action catalogue has
/// shape (first, (second, third)); each column is a total stage permutation.
public enum LocalStarStage: Close {
    public enum Center: Pair {
        public typealias Left = Never
        public typealias Right = Paired<A, Paired<B, C>>
    }
    public enum A: Pair {
        public typealias Left = Lit1
        public typealias Right = Paired<Center, Paired<A, A>>
    }
    public enum B: Pair {
        public typealias Left = Lit2
        public typealias Right = Paired<B, Paired<Center, B>>
    }
    public enum C: Pair {
        public typealias Left = Succ<Lit2>
        public typealias Right = Paired<C, Paired<C, Center>>
    }
}

/// The same three columns exchange phases 0/1, 1/2, and 2/0. Selecting column
/// i at phase i advances it cyclically. Other available selections may not.
public enum LocalStarPhase: Close {
    public enum Zero: Pair {
        public typealias Left = Never
        public typealias Right = Paired<One, Paired<Zero, Two>>
    }
    public enum One: Pair {
        public typealias Left = Lit1
        public typealias Right = Paired<Zero, Paired<Two, One>>
    }
    public enum Two: Pair {
        public typealias Left = Lit2
        public typealias Right = Paired<Two, Paired<One, Zero>>
    }
}

/// Keep the complete projection path in each operation expression. Its final
/// left/right projection alone would identify distinct catalogue columns.
public typealias LocalStarColumn0<N: Pair> = SequentialReading<
    SecondEvidenceImage<N, BeamSpace, SaturationEncoding, SecondProjection>,
    FirstEvidenceImage<N.Right, BeamSpace, SaturationEncoding, FirstProjection>>
where N.Right: Pair
public typealias LocalStarCatalogueTail<N: Pair> = SequentialReading<
    SecondEvidenceImage<N, BeamSpace, SaturationEncoding, SecondProjection>,
    SecondEvidenceImage<N.Right, BeamSpace, SaturationEncoding, SecondProjection>>
where N.Right: Pair
public typealias LocalStarColumn1<N: Pair> = SequentialReading<
    LocalStarCatalogueTail<N>,
    FirstEvidenceImage<N.Right.Right, BeamSpace, SaturationEncoding, FirstProjection>>
where N.Right: Pair, N.Right.Right: Pair
public typealias LocalStarColumn2<N: Pair> = SequentialReading<
    LocalStarCatalogueTail<N>,
    SecondEvidenceImage<N.Right.Right, BeamSpace, SaturationEncoding, SecondProjection>>
where N.Right: Pair, N.Right.Right: Pair

/// Each primitive applies the same catalogue column to stage and phase and
/// retains V. Its Predicate is the existing composition's operation expression.
public enum LocalStarStep0<S: Pair, C: Pair, V: Structure>: PredicateReading
where S.Right: Pair, S.Right.Left: Structure, C.Right: Pair, C.Right.Left: Structure {
    public typealias Application = PairedApplication<LocalStarColumn0<S>,
        PairedApplication<LocalStarColumn0<C>, IdentityReading<V, BeamSpace, SaturationEncoding>>>
    public typealias Left = LocalPhaseWorld<S, C, V>
    public typealias Right = LocalPhaseWorld<S.Right.Left, C.Right.Left, V>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Application.Predicate
    public typealias Answer = Right
    public enum Endpoints: Null {
        public typealias Left = Paired<LocalStarStep0.Left, LocalStarStep0.Right>
        public typealias Right = Paired<Application.Left, Application.Answer>
    }
}
public enum LocalStarStep1<S: Pair, C: Pair, V: Structure>: PredicateReading
where S.Right: Pair, S.Right.Right: Pair, S.Right.Right.Left: Structure,
      C.Right: Pair, C.Right.Right: Pair, C.Right.Right.Left: Structure {
    public typealias Application = PairedApplication<LocalStarColumn1<S>,
        PairedApplication<LocalStarColumn1<C>, IdentityReading<V, BeamSpace, SaturationEncoding>>>
    public typealias Left = LocalPhaseWorld<S, C, V>
    public typealias Right = LocalPhaseWorld<S.Right.Right.Left, C.Right.Right.Left, V>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Application.Predicate
    public typealias Answer = Right
    public enum Endpoints: Null {
        public typealias Left = Paired<LocalStarStep1.Left, LocalStarStep1.Right>
        public typealias Right = Paired<Application.Left, Application.Answer>
    }
}
public enum LocalStarStep2<S: Pair, C: Pair, V: Structure>: PredicateReading
where S.Right: Pair, S.Right.Right: Pair, S.Right.Right.Right: Structure,
      C.Right: Pair, C.Right.Right: Pair, C.Right.Right.Right: Structure {
    public typealias Application = PairedApplication<LocalStarColumn2<S>,
        PairedApplication<LocalStarColumn2<C>, IdentityReading<V, BeamSpace, SaturationEncoding>>>
    public typealias Left = LocalPhaseWorld<S, C, V>
    public typealias Right = LocalPhaseWorld<S.Right.Right.Right, C.Right.Right.Right, V>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Application.Predicate
    public typealias Answer = Right
    public enum Endpoints: Null {
        public typealias Left = Paired<LocalStarStep2.Left, LocalStarStep2.Right>
        public typealias Right = Paired<Application.Left, Application.Answer>
    }
}

/// The fixed local catalogue carries the three actual operation expressions.
/// Generic ActualSelections below establish their independence of S and V.
public typealias LocalStarTable = LocalStarApplicationRoot<
    LocalStarStage.Center, LocalStarPhase.Zero, Never>.Expression
public typealias LocalStarInverseTable = Paired<LocalStarTable.Right.Right,
    Paired<LocalStarTable.Left, LocalStarTable.Right.Left>>

public typealias LocalStarChoose1<J: Pair> = DecodeRefinedEvidence<
    LocalPolicyAtOne<J>,
    FirstEvidenceImage<J.Right, BeamSpace, SaturationEncoding, AcquisitionChoice>>
where J.Right: Pair
public enum LocalStarChoose2<J: Pair>: PredicateReading
where J.Right: Pair {
    public typealias Left = Paired<Lit2, J>
    public typealias Right = J.Right.Right
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AcquisitionChoice
    public typealias Answer = Right
}

/// The exposed input is the current phase label and one fixed resident J.
/// Neither the stage nor the carried payload enters a selection row.
public enum LocalStarInput<S: Structure, C: Pair, V: Structure, J: Pair>: PredicateReading
where C.Left: Structure {
    public typealias Left = LocalPhaseWorld<S, C, V>
    public typealias Right = Paired<C.Left, J>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AcquisitionChoice
    public typealias Answer = Right
}

/// Read the resident phase label through its actual address in the whole.
/// The stage reading is already LocalStageImage<W>. These are different
/// questions; neither projection is a read of the original phase after a path.
public typealias LocalStarPhaseImage<W: Pair> = SequentialReading<
    SecondEvidenceImage<W, BeamSpace, SaturationEncoding, SecondProjection>,
    LocalStageImage<W.Right>>
where W.Right: Pair, W.Right.Left: Pair

/// Each return is selected in advance and derives its inputs from the actual
/// arrived whole. It receives no parameter naming that whole's predecessor.
public typealias LocalStarReturn0<W: Pair> = LocalStarStep0<W.Left, W.Right.Left, W.Right.Right>
where W.Left: Pair, W.Left.Right: Pair, W.Left.Right.Left: Structure,
      W.Right: Pair, W.Right.Left: Pair, W.Right.Left.Right: Pair,
      W.Right.Left.Right.Left: Structure, W.Right.Right: Structure
public typealias LocalStarReturn1<W: Pair> = LocalStarStep1<W.Left, W.Right.Left, W.Right.Right>
where W.Left: Pair, W.Left.Right: Pair, W.Left.Right.Right: Pair,
      W.Left.Right.Right.Left: Structure, W.Right: Pair, W.Right.Left: Pair,
      W.Right.Left.Right: Pair, W.Right.Left.Right.Right: Pair,
      W.Right.Left.Right.Right.Left: Structure, W.Right.Right: Structure
public typealias LocalStarReturn2<W: Pair> = LocalStarStep2<W.Left, W.Right.Left, W.Right.Right>
where W.Left: Pair, W.Left.Right: Pair, W.Left.Right.Right: Pair,
      W.Left.Right.Right.Right: Structure, W.Right: Pair, W.Right.Left: Pair,
      W.Right.Left.Right: Pair, W.Right.Left.Right.Right: Pair,
      W.Right.Left.Right.Right.Right: Structure, W.Right.Right: Structure

/// The generic proof binds all three actual inputs and chosen operations.
/// The caller supplies only the stage catalogue, not their answer equalities.
public enum LocalStarControls<S: Pair, V: Structure>: Close
where S.Right: Pair, S.Right.Right: Pair, S.Right.Left: Structure,
      S.Right.Right.Left: Structure, S.Right.Right.Right: Structure {
    public typealias First = LocalStarStep0<S, LocalStarPhase.Zero, V>
    public typealias Second = LocalStarStep1<S, LocalStarPhase.One, V>
    public typealias Third = LocalStarStep2<S, LocalStarPhase.Two, V>
    public enum ActualSelections: Null {
        public typealias Left = Paired<
            Paired<LocalStarInput<S, LocalStarPhase.Zero, V, LocalStarTable>.Answer, First.Predicate>,
            Paired<Paired<LocalStarInput<S, LocalStarPhase.One, V, LocalStarTable>.Answer, Second.Predicate>,
                Paired<LocalStarInput<S, LocalStarPhase.Two, V, LocalStarTable>.Answer, Third.Predicate>>>
        public typealias Right = Paired<
            Paired<LocalPolicyAtZero<LocalStarTable>.Left, LocalPolicyAtZero<LocalStarTable>.Answer>,
            Paired<Paired<LocalStarChoose1<LocalStarTable>.Left, LocalStarChoose1<LocalStarTable>.Answer>,
                Paired<LocalStarChoose2<LocalStarTable>.Left, LocalStarChoose2<LocalStarTable>.Answer>>>
    }
    public enum InverseSelections: Null {
        public typealias Left = Paired<
            Paired<LocalStarInput<S, LocalStarPhase.Zero, V, LocalStarInverseTable>.Answer,
                LocalStarStep2<S, LocalStarPhase.Zero, V>.Predicate>,
            Paired<Paired<LocalStarInput<S, LocalStarPhase.One, V, LocalStarInverseTable>.Answer,
                LocalStarStep0<S, LocalStarPhase.One, V>.Predicate>,
                Paired<LocalStarInput<S, LocalStarPhase.Two, V, LocalStarInverseTable>.Answer,
                    LocalStarStep1<S, LocalStarPhase.Two, V>.Predicate>>>
        public typealias Right = Paired<
            Paired<LocalPolicyAtZero<LocalStarInverseTable>.Left, LocalPolicyAtZero<LocalStarInverseTable>.Answer>,
            Paired<Paired<LocalStarChoose1<LocalStarInverseTable>.Left, LocalStarChoose1<LocalStarInverseTable>.Answer>,
                Paired<LocalStarChoose2<LocalStarInverseTable>.Left, LocalStarChoose2<LocalStarInverseTable>.Answer>>>
    }
}

/// Three selected actions have their actual successive stage and phase inputs.
/// The cycle certificate composes four such blocks, starting at phase zero.
public enum LocalStarRound<S: Pair, V: Structure>: PredicateReading
where S.Right: Pair, S.Right.Left: Pair, S.Right.Left.Right: Pair,
      S.Right.Left.Right.Right: Pair, S.Right.Left.Right.Right.Left: Pair,
      S.Right.Left.Right.Right.Left.Right: Pair,
      S.Right.Left.Right.Right.Left.Right.Right: Pair,
      S.Right.Left.Right.Right.Left.Right.Right.Right: Structure {
    public typealias First = LocalStarStep0<S, LocalStarPhase.Zero, V>
    public typealias Second = LocalStarStep1<First.Answer.Left, First.Answer.Right.Left, V>
    public typealias Third = LocalStarStep2<Second.Answer.Left, Second.Answer.Right.Left, V>
    public typealias Path = SequentialReading<SequentialReading<First, Second>, Third>
    public typealias Left = LocalPhaseWorld<S, LocalStarPhase.Zero, V>
    public typealias Right = LocalPhaseWorld<
        S.Right.Left.Right.Right.Left.Right.Right.Right, LocalStarPhase.Zero, V>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = OperationSequence<
        OperationSequence<LocalStarTable.Left, LocalStarTable.Right.Left>, LocalStarTable.Right.Right>
    public typealias Answer = Right
    public enum Endpoints: Null {
        public typealias Left = Paired<LocalStarRound.Left,
            Paired<LocalStarRound.Right, LocalStarRound.Predicate>>
        public typealias Right = Paired<Path.Left, Paired<Path.Answer, Path.Predicate>>
    }
    public enum ActualSelections: Null {
        public typealias Left = Paired<
            Paired<LocalStarInput<S, LocalStarPhase.Zero, V, LocalStarTable>.Answer, First.Predicate>,
            Paired<Paired<LocalStarInput<First.Answer.Left, First.Answer.Right.Left, V, LocalStarTable>.Answer,
                Second.Predicate>,
                Paired<LocalStarInput<Second.Answer.Left, Second.Answer.Right.Left, V, LocalStarTable>.Answer,
                    Third.Predicate>>>
        public typealias Right = Paired<
            Paired<LocalPolicyAtZero<LocalStarTable>.Left, LocalPolicyAtZero<LocalStarTable>.Answer>,
            Paired<Paired<LocalStarChoose1<LocalStarTable>.Left, LocalStarChoose1<LocalStarTable>.Answer>,
                Paired<LocalStarChoose2<LocalStarTable>.Left, LocalStarChoose2<LocalStarTable>.Answer>>>
    }
}

public enum LocalStarWindow<W: Pair>: PredicateReading
where W.Left == LocalStarStage.C, W.Right: Pair, W.Right.Right: Structure {
    public typealias Left = W
    public typealias Right = Paired<ExperimentSignal, W.Right.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = BetaQuestion
    public typealias Answer = Right
}

/// The original payload is exposed at leaf C after three complete rounds.
/// Each round selects from its actual phase; no original-answer tag controls it.
public enum LocalStarFindsOriginal<V: Structure>: ReadingFactors {
    public typealias First = LocalStarRound<LocalStarStage.Center, V>
    public typealias Second = LocalStarRound<First.Answer.Left, V>
    public typealias Third = LocalStarRound<Second.Answer.Left, V>
    public typealias Path = SequentialReading<SequentialReading<First, Second>, Third>
    public typealias Left = LocalPhaseTarget<Path.Left>
    public typealias Observation = SequentialReading<Path, LocalStarWindow<Path.Answer>>
    public typealias Right = SecondEvidenceImage<Observation.Answer,
        BeamSpace, SaturationEncoding, BetaQuestion>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = BetaQuestion
    public typealias Answer = Left.Answer
}
