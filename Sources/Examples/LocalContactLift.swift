import VerificationIsIdentification

/// The old stage word a,b,a exchanges the two end stages and fixes the middle.
/// It is a derived endpoint reading; its spelling does not grant a new physical
/// single-step instrument for an unknown source.
public enum LocalStageClosing<S: Pair>: PredicateReading
where S.Right: Pair, S.Right.Left: Pair, S.Right.Left.Right: Pair,
      S.Right.Left.Right.Right: Pair, S.Right.Left.Right.Right.Right: Pair,
      S.Right.Left.Right.Right.Right.Left: Structure {
    public typealias First = LocalStageSuccessor<S>
    public typealias Second = LocalStagePredecessor<First.Answer>
    public typealias Third = LocalStageSuccessor<Second.Answer>
    public typealias Actual = SequentialReading<SequentialReading<First, Second>, Third>
    public typealias Left = S
    public typealias Right = S.Right.Left.Right.Right.Right.Left
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = OperationSequence<OperationSequence<FirstProjection, SecondProjection>, FirstProjection>
    public typealias Answer = Right
    public enum Endpoints: Null {
        public typealias Left = Paired<LocalStageClosing.Left,
            Paired<LocalStageClosing.Right, LocalStageClosing.Predicate>>
        public typealias Right = Paired<Actual.Left, Paired<Actual.Answer, Actual.Predicate>>
    }
}

/// Compose the actual old whole operations. Their three phase exchanges leave
/// one exchange, even though their stage word is the closing stage contact.
public enum LocalPhaseMacroClosing<S: Pair, C: Pair, V: Structure>: PredicateReading
where S.Right: Pair, S.Right.Left: Pair, S.Right.Left.Right: Pair,
      S.Right.Left.Right.Right: Pair, S.Right.Left.Right.Right.Right: Pair,
      S.Right.Left.Right.Right.Right.Left: Structure,
      C.Left: Structure, C.Right: Structure {
    public typealias First = LocalPhaseFirst<LocalPhaseWorld<S, C, V>>
    public typealias Second = LocalPhaseSecond<First.Answer>
    public typealias Third = LocalPhaseFirst<Second.Answer>
    public typealias Actual = SequentialReading<SequentialReading<First, Second>, Third>
    public typealias Left = LocalPhaseWorld<S, C, V>
    public typealias Right = LocalPhaseWorld<LocalStageClosing<S>.Answer, Paired<C.Right, C.Left>, V>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = LocalStageClosing<S>.Predicate
    public typealias Answer = Right
    public enum Endpoints: Null {
        public typealias Left = Paired<LocalPhaseMacroClosing.Left,
            Paired<LocalPhaseMacroClosing.Right, LocalPhaseMacroClosing.Predicate>>
        public typealias Right = Paired<Actual.Left, Paired<Actual.Answer, Actual.Predicate>>
    }
}

/// A different whole contact with the same stage action. Only its stage field
/// uses the derived word; the phase/payload field is retained by the existing
/// product constructor. This is a candidate additional available contact.
public typealias LocalPhaseUnflippedClosing<S: Pair, C: Structure, V: Structure> = ExperimentReadingBeside<
    LocalStageClosing<S>, Paired<C, V>>
where S.Right: Pair, S.Right.Left: Pair, S.Right.Left.Right: Pair,
      S.Right.Left.Right.Right: Pair, S.Right.Left.Right.Right.Right: Pair,
      S.Right.Left.Right.Right.Right.Left: Structure

/// Both complete sources and the stage/payload projections agree. The proof
/// does not equate operation expressions or the two complete output phases.
public enum LocalClosingImagesAgree<S: Pair, C: Pair, V: Structure>: Null
where S.Right: Pair, S.Right.Left: Pair, S.Right.Left.Right: Pair,
      S.Right.Left.Right.Right: Pair, S.Right.Left.Right.Right.Right: Pair,
      S.Right.Left.Right.Right.Right.Left: Structure,
      C.Left: Structure, C.Right: Structure {
    public typealias Old = LocalPhaseMacroClosing<S, C, V>
    public typealias New = LocalPhaseUnflippedClosing<S, C, V>
    public typealias Left = Paired<Old.Left, Paired<Old.Answer.Left, LocalPhaseTarget<Old.Answer>.Answer>>
    public typealias Right = Paired<New.Left, Paired<New.Answer.Left, LocalPhaseTarget<New.Answer>.Answer>>
}

/// One source, two actual closing contacts, then the same resident phase law.
/// Its locally selected next action reveals a difference hidden by stage-only
/// calibration of the closing contacts themselves.
public enum LocalPhaseApplicationRoot<W: Pair>: Pair
where W.Left: Pair, W.Left.Right: Pair,
      W.Left.Right.Left: Structure, W.Left.Right.Right: Structure,
      W.Right: Pair, W.Right.Left: Pair, W.Right.Right: Structure,
      W.Right.Left.Left: Structure, W.Right.Left.Right: Structure {
    public typealias First = LocalPhaseFirst<W>
    public typealias Second = LocalPhaseSecond<W>
    public typealias Left = W
    public typealias Catalogue = CandidateFork<CandidateLeaf<First>, CandidateLeaf<Second>>
    public typealias Right = Paired<Paired<First.Predicate, Second.Predicate>, Catalogue>
    public typealias Select0 = SelectCandidateLeft<SelectCandidateLeaf<First>, CandidateLeaf<Second>>
    public typealias Select1 = SelectCandidateRight<CandidateLeaf<First>, SelectCandidateLeaf<Second>>
}

public typealias LocalPhaseAddressRoot = LocalPhaseApplicationRoot<
    LocalPhaseWorld<ReversibleExperiment.A, LocalPhaseZero, Never>>
public typealias LocalPhaseAddressProgram = Paired<
    LocalPhaseAddressRoot.Select0.Address, LocalPhaseAddressRoot.Select1.Address>

public enum LocalClosingFeedbackWitness<V: Structure>: Close {
    public typealias Old = LocalPhaseMacroClosing<ReversibleExperiment.A, LocalPhaseZero, V>
    public typealias New = LocalPhaseUnflippedClosing<ReversibleExperiment.A, LocalPhaseZero, V>
    public typealias OldNext = SelectedLocalApplication<
        LocalPhaseApplicationRoot<Old.Answer>,
        LocalPhaseProgramInput<Old.Answer, LocalPhaseAddressProgram>,
        LocalPolicyAtOne<LocalPhaseAddressProgram>, LocalPhaseApplicationRoot<Old.Answer>.Select1>
    public typealias NewNext = SelectedLocalApplication<
        LocalPhaseApplicationRoot<New.Answer>,
        LocalPhaseProgramInput<New.Answer, LocalPhaseAddressProgram>,
        LocalPolicyAtZero<LocalPhaseAddressProgram>, LocalPhaseApplicationRoot<New.Answer>.Select0>
    public typealias OldPath = SequentialReading<Old, OldNext>
    public typealias NewPath = SequentialReading<New, NewNext>
    public enum OneContinuationLaw: Null {
        public typealias Left = OldNext.Predicate
        public typealias Right = NewNext.Predicate
    }
}
