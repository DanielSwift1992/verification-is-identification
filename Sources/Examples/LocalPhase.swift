import VerificationIsIdentification

/// The closed three-stage restriction A, Signal, B of ReversibleExperiment.
/// Its first edge swaps A/Signal; its second swaps Signal/B. The old table's
/// observation field is not this experiment's interface. Only B exposes V.
public typealias LocalPhaseZero = Paired<Never, Lit1>
public typealias LocalPhaseOne = Paired<Lit1, Never>
public typealias LocalPhaseWorld<S: Structure, C: Structure, V: Structure> = Paired<S, Paired<C, V>>
public typealias LocalPhaseTable = Paired<FirstProjection, SecondProjection>

/// Both operations flip the actual resident phase and retain the payload.
/// Their stage effects are projections of the existing experiment table.
public enum LocalPhaseFirst<W: Pair>: PredicateReading
where W.Left: Pair, W.Left.Right: Pair, W.Left.Right.Left: Structure,
      W.Right: Pair, W.Right.Left: Pair, W.Right.Right: Structure,
      W.Right.Left.Left: Structure, W.Right.Left.Right: Structure {
    public typealias Left = W
    public typealias Right = LocalPhaseWorld<W.Left.Right.Left,
        Paired<W.Right.Left.Right, W.Right.Left.Left>, W.Right.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = FirstProjection
    public typealias Answer = Right
}

public enum LocalPhaseSecond<W: Pair>: PredicateReading
where W.Left: Pair, W.Left.Right: Pair, W.Left.Right.Right: Structure,
      W.Right: Pair, W.Right.Left: Pair, W.Right.Right: Structure,
      W.Right.Left.Left: Structure, W.Right.Left.Right: Structure {
    public typealias Left = W
    public typealias Right = LocalPhaseWorld<W.Left.Right.Right,
        Paired<W.Right.Left.Right, W.Right.Left.Left>, W.Right.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = SecondProjection
    public typealias Answer = Right
}

/// Only the resident phase head and the fixed program enter action selection.
/// The program can equivalently be carried unchanged beside the whole.
public enum LocalPhaseProgramInput<W: Pair, J: Pair>: PredicateReading
where W.Right: Pair, W.Right.Left: Pair, W.Right.Left.Left: Structure {
    public typealias Left = W
    public typealias Right = Paired<W.Right.Left.Left, J>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = AcquisitionChoice
    public typealias Answer = Right
}

public typealias LocalPhaseControlInput<W: Pair> = LocalPhaseProgramInput<W, LocalPhaseTable>
where W.Right: Pair, W.Right.Left: Pair, W.Right.Left.Left: Structure

public enum LocalPhaseAtZero<S: Pair, V: Structure>: Close
where S.Right: Pair, S.Right.Left: Structure {
    public typealias Whole = LocalPhaseWorld<S, LocalPhaseZero, V>
    public typealias Choice = LocalPolicyAtZero<LocalPhaseTable>
    public typealias Step = LocalPhaseFirst<Whole>
    public enum ActualChoice: Null {
        public typealias Left = Paired<LocalPhaseControlInput<Whole>.Answer, Choice.Answer>
        public typealias Right = Paired<Choice.Left, Step.Predicate>
    }
}

public enum LocalPhaseAtOne<S: Pair, V: Structure>: Close
where S.Right: Pair, S.Right.Right: Structure {
    public typealias Whole = LocalPhaseWorld<S, LocalPhaseOne, V>
    public typealias Choice = LocalPolicyAtOne<LocalPhaseTable>
    public typealias Step = LocalPhaseSecond<Whole>
    public enum ActualChoice: Null {
        public typealias Left = Paired<LocalPhaseControlInput<Whole>.Answer, Choice.Answer>
        public typealias Right = Paired<Choice.Left, Step.Predicate>
    }
}

/// The original question reads the payload irrespective of its accessibility.
/// It is used by the proof, not as a hidden input to the controller.
public enum LocalPhaseTarget<W: Pair>: PredicateReading
where W.Right: Pair {
    public typealias Left = W
    public typealias Right = W.Right.Right
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = BetaQuestion
    public typealias Answer = Right
}

/// This declared interface exposes the payload only at stage B. A and Signal
/// have one common quiet image in this experiment. Being a verifier able to
/// name those stages does not grant the actor their distinction.
public enum LocalPhaseWindow<W: Pair>: PredicateReading
where W.Left == ReversibleExperiment.B, W.Right: Pair, W.Right.Right: Structure {
    public typealias Left = W
    public typealias Right = Paired<ExperimentSignal, W.Right.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = BetaQuestion
    public typealias Answer = Right
}

/// Two locally selected steps expose the original payload. The readout is a
/// window in a reversible cycle, not a permanently absorbing whole state.
public enum LocalPhaseFindsOriginal<V: Structure>: ReadingFactors {
    public typealias First = LocalPhaseAtZero<ReversibleExperiment.A, V>.Step
    public typealias Second = LocalPhaseAtOne<First.Answer.Left, V>.Step
    public typealias Path = SequentialReading<First, Second>
    public typealias Left = LocalPhaseTarget<First.Left>
    public typealias Observation = SequentialReading<Path, LocalPhaseWindow<Path.Answer>>
    public typealias Right = SecondEvidenceImage<Observation.Answer,
        BeamSpace, SaturationEncoding, BetaQuestion>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = BetaQuestion
    public typealias Answer = Left.Answer
}

/// The other nonconstant phase table is also local and successful, but takes
/// three steps from the same preparation. Every selected row is tied to its
/// actual source phase. Together with the two constant traps this covers all
/// four action tables on the two quiet phase inputs.
public enum LocalPhaseOppositeFindsOriginal<V: Structure>: ReadingFactors {
    public typealias Program = Paired<SecondProjection, FirstProjection>
    public typealias Start = LocalPhaseWorld<ReversibleExperiment.A, LocalPhaseZero, V>
    public typealias First = LocalPhaseSecond<Start>
    public typealias Second = LocalPhaseFirst<First.Answer>
    public typealias Third = LocalPhaseSecond<Second.Answer>
    public typealias Path = SequentialReading<SequentialReading<First, Second>, Third>

    public enum SelectedRows: Null {
        public typealias AtZero = LocalPolicyAtZero<Program>
        public typealias AtOne = LocalPolicyAtOne<Program>
        public typealias Left = Paired<
            Paired<LocalPhaseProgramInput<First.Left, Program>.Answer, First.Predicate>,
            Paired<Paired<LocalPhaseProgramInput<Second.Left, Program>.Answer, Second.Predicate>,
                Paired<LocalPhaseProgramInput<Third.Left, Program>.Answer, Third.Predicate>>>
        public typealias Right = Paired<Paired<AtZero.Left, AtZero.Answer>,
            Paired<Paired<AtOne.Left, AtOne.Answer>, Paired<AtZero.Left, AtZero.Answer>>>
    }

    public typealias Left = LocalPhaseTarget<Start>
    public typealias Observation = SequentialReading<Path, LocalPhaseWindow<Path.Answer>>
    public typealias Right = SecondEvidenceImage<Observation.Answer,
        BeamSpace, SaturationEncoding, BetaQuestion>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = BetaQuestion
    public typealias Answer = Left.Answer
}

/// A different contract: one reversible four-position cycle, with the allowed
/// stage contacts, but without two total reversible primitive lifts. Left
/// holds the stage and a residual; Right holds successor and predecessor.
/// These four declared positions form a finite graph, not a finite expansion
/// of their recursive descriptions. [VC95]
public enum LocalStageCycle: Close {
    public enum X: Pair {
        public typealias Left = Paired<ReversibleExperiment.A, Never>
        public typealias Right = Paired<Outward, Returning>
    }
    public enum Outward: Pair {
        public typealias Left = Paired<ReversibleExperiment.Signal, Lit1>
        public typealias Right = Paired<Z, X>
    }
    public enum Z: Pair {
        public typealias Left = Paired<ReversibleExperiment.B, Lit1>
        public typealias Right = Paired<Returning, Outward>
    }
    public enum Returning: Pair {
        public typealias Left = Paired<ReversibleExperiment.Signal, Never>
        public typealias Right = Paired<X, Z>
    }
}

/// Actual graph projections, reused with the payload left beside the node.
public typealias LocalStageSuccessor<N: Pair> = DecodeRefinedEvidence<
    SecondEvidenceImage<N, BeamSpace, SaturationEncoding, SecondProjection>,
    FirstEvidenceImage<N.Right, BeamSpace, SaturationEncoding, FirstProjection>>
where N.Right: Pair
public typealias LocalStagePredecessor<N: Pair> = DecodeRefinedEvidence<
    SecondEvidenceImage<N, BeamSpace, SaturationEncoding, SecondProjection>,
    SecondEvidenceImage<N.Right, BeamSpace, SaturationEncoding, SecondProjection>>
where N.Right: Pair
public typealias LocalStageImage<N: Pair> = SequentialReading<
    FirstEvidenceImage<N, BeamSpace, SaturationEncoding, FirstProjection>,
    FirstEvidenceImage<N.Left, BeamSpace, SaturationEncoding, FirstProjection>>
where N.Left: Pair
public typealias LocalStageResidual<N: Pair> = SequentialReading<
    FirstEvidenceImage<N, BeamSpace, SaturationEncoding, FirstProjection>,
    SecondEvidenceImage<N.Left, BeamSpace, SaturationEncoding, SecondProjection>>
where N.Left: Pair
public typealias LocalStageStep<N: Pair, V: Structure> = PairedApplication<
    LocalStageSuccessor<N>, IdentityReading<V, BeamSpace, SaturationEncoding>>
where N.Right: Pair, N.Right.Left: Structure

/// This experiment exposes the payload only at its independently read z stage.
public enum LocalStageWindow<N: Pair, V: Structure>: PredicateReading
where N.Left: Pair, N.Left.Left == ReversibleExperiment.B {
    public typealias Left = Paired<N, V>
    public typealias Right = Paired<ExperimentSignal, V>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = BetaQuestion
    public typealias Answer = Right
}

/// Two applications of the ONE supplied cycle reach the original payload.
/// This does not claim two arbitrary calls of the old a/b instruments.
public enum LocalStageFindsOriginal<V: Structure>: ReadingFactors {
    public typealias First = LocalStageStep<LocalStageCycle.X, V>
    public typealias Second = LocalStageStep<First.Answer.Left, V>
    public typealias Path = SequentialReading<First, Second>
    public typealias Left = SecondEvidenceImage<Path.Left,
        BeamSpace, SaturationEncoding, BetaQuestion>
    public typealias Observation = SequentialReading<Path,
        LocalStageWindow<Path.Answer.Left, V>>
    public typealias Right = SecondEvidenceImage<Observation.Answer,
        BeamSpace, SaturationEncoding, BetaQuestion>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = BetaQuestion
    public typealias Answer = Left.Answer
}
