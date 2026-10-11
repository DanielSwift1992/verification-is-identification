import VerificationIsIdentification

public enum MarkedPositionQuestion: Close {}

/// Four clauses of one finite calibration: locate the unique internal marker.
/// Their sources are the complete four-slot masks, not a hidden phase tag.
public enum FourLeafMarked0: PredicateReading {
    public typealias Left = FourLeafPhaseMark0
    public typealias Right = RoutingAddress00
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = MarkedPositionQuestion
    public typealias Answer = Right
}
public enum FourLeafMarked1: PredicateReading {
    public typealias Left = FourLeafPhaseMark1
    public typealias Right = RoutingAddress01
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = MarkedPositionQuestion
    public typealias Answer = Right
}
public enum FourLeafMarked2: PredicateReading {
    public typealias Left = FourLeafPhaseMark2
    public typealias Right = RoutingAddress10
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = MarkedPositionQuestion
    public typealias Answer = Right
}
public enum FourLeafMarked3: PredicateReading {
    public typealias Left = FourLeafPhaseMark3
    public typealias Right = RoutingAddress11
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = MarkedPositionQuestion
    public typealias Answer = Right
}

/// A named, inspectable program body shared by all source instantiations.
/// Its actual fields remain the four operation expressions. Keeping this
/// one object avoids embedding the same expanded tree in every fact's type.
public enum FourLeafResidentLibrary: Pair {
    public typealias Prototype = FourLeafResidentRoot<Never, Never, Never, Never, Never>
    public typealias Left = Paired<Prototype.S0.Predicate, Prototype.S1.Predicate>
    public typealias Right = Paired<Prototype.S2.Predicate, Prototype.S3.Predicate>
}

/// All four actual contacts at the known returned center. This is a view of
/// their existing constructors at one current working source, not four freely
/// chosen evaluators attached to the same names or to matching final answers.
public enum FourLeafResidentRoot<A: Structure, B: Structure, C: Structure,
                                D: Structure, K: Structure>: Pair {
    public typealias S0 = PairedApplication<FourLeafStage0<Lit1, Never, Never, Never, Never>,
        ExperimentReadingBeside<FourLeafPhase0<A, B, C, D>, K>>
    public typealias S1 = PairedApplication<FourLeafStage1<Lit1, Never, Never, Never, Never>,
        ExperimentReadingBeside<FourLeafPhase1<A, B, C, D>, K>>
    public typealias S2 = PairedApplication<FourLeafStage2<Lit1, Never, Never, Never, Never>,
        ExperimentReadingBeside<FourLeafPhase2<A, B, C, D>, K>>
    public typealias S3 = PairedApplication<FourLeafStage3<Lit1, Never, Never, Never, Never>,
        ExperimentReadingBeside<FourLeafPhase3<A, B, C, D>, K>>
    public typealias Low = CandidateFork<CandidateLeaf<S0>, CandidateLeaf<S1>>
    public typealias High = CandidateFork<CandidateLeaf<S2>, CandidateLeaf<S3>>
    public typealias Catalogue = CandidateFork<Low, High>
    public typealias ActualExpression = BoundaryWorking<S0.Predicate, S1.Predicate, S2.Predicate, S3.Predicate>
    public typealias Expression = FourLeafResidentLibrary
    public typealias Left = LocalPhaseWorld<FourLeafCenter, BoundaryWorking<A, B, C, D>, K>
    public typealias Right = Paired<Expression, Catalogue>
    public typealias Select0 = SelectCandidateLeft<
        SelectCandidateLeft<SelectCandidateLeaf<S0>, CandidateLeaf<S1>>, High>
    public typealias Select1 = SelectCandidateLeft<
        SelectCandidateRight<CandidateLeaf<S0>, SelectCandidateLeaf<S1>>, High>
    public typealias Select2 = SelectCandidateRight<Low,
        SelectCandidateLeft<SelectCandidateLeaf<S2>, CandidateLeaf<S3>>>
    public typealias Select3 = SelectCandidateRight<Low,
        SelectCandidateRight<CandidateLeaf<S2>, SelectCandidateLeaf<S3>>>
    public enum LibraryMatches: Null {
        public typealias Left = ActualExpression
        public typealias Right = Paired<Expression.Left, Expression.Right>
    }
}

public typealias FourLeafAddressRoot = FourLeafResidentRoot<Never, Never, Never, Never, Never>
public typealias FourLeafAddressProgram = BoundaryWorking<
    FourLeafAddressRoot.Select0.Address, FourLeafAddressRoot.Select1.Address,
    FourLeafAddressRoot.Select2.Address, FourLeafAddressRoot.Select3.Address>

/// The resident policy gets the actual current phase and the first field of
/// its carried context K. That field is its prepared address program. Neither
/// the stage nor the remaining context is an argument of the policy table.
public enum FourLeafResidentInput<R: PredicateReading, K: Pair>: PredicateReading
where R.Left: Structure, R.Answer: Structure, K.Left: Structure,
      R.Sigma == BeamSpace, R.Encoding == SaturationEncoding {
    public typealias Source = LocalPhaseWorld<FourLeafCenter, R.Left, K>
    public typealias Tail = SecondEvidenceImage<Source, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Phase = SequentialReading<Tail,
        FirstEvidenceImage<Tail.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Context = SequentialReading<Tail,
        SecondEvidenceImage<Tail.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Program = SequentialReading<Context,
        FirstEvidenceImage<K, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Actual = JointEvidence<SequentialReading<Phase, R>, Program>
    public typealias Left = Source
    public typealias Right = Paired<R.Answer, K.Left>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Actual.Answer
}

/// Four rows of the same fixed resident law. Every chosen object is the leaf
/// at the actual root. K includes the unknown word and retained apparatus;
/// the same prepared address program stays beside it throughout the contact.
public typealias FourLeafSelected0<K: Structure> = SelectedLocalApplication<
    FourLeafResidentRoot<Lit1, Never, Never, Never, Paired<FourLeafAddressProgram, K>>,
    FourLeafResidentInput<FourLeafMarked0, Paired<FourLeafAddressProgram, K>>,
    Route00<FourLeafAddressProgram>,
    FourLeafResidentRoot<Lit1, Never, Never, Never, Paired<FourLeafAddressProgram, K>>.Select0>
public typealias FourLeafSelected1<K: Structure> = SelectedLocalApplication<
    FourLeafResidentRoot<Never, Lit1, Never, Never, Paired<FourLeafAddressProgram, K>>,
    FourLeafResidentInput<FourLeafMarked1, Paired<FourLeafAddressProgram, K>>,
    Route01<FourLeafAddressProgram>,
    FourLeafResidentRoot<Never, Lit1, Never, Never, Paired<FourLeafAddressProgram, K>>.Select1>
public typealias FourLeafSelected2<K: Structure> = SelectedLocalApplication<
    FourLeafResidentRoot<Never, Never, Lit1, Never, Paired<FourLeafAddressProgram, K>>,
    FourLeafResidentInput<FourLeafMarked2, Paired<FourLeafAddressProgram, K>>,
    Route10<FourLeafAddressProgram>,
    FourLeafResidentRoot<Never, Never, Lit1, Never, Paired<FourLeafAddressProgram, K>>.Select2>
public typealias FourLeafSelected3<K: Structure> = SelectedLocalApplication<
    FourLeafResidentRoot<Never, Never, Never, Lit1, Paired<FourLeafAddressProgram, K>>,
    FourLeafResidentInput<FourLeafMarked3, Paired<FourLeafAddressProgram, K>>,
    Route11<FourLeafAddressProgram>,
    FourLeafResidentRoot<Never, Never, Never, Lit1, Paired<FourLeafAddressProgram, K>>.Select3>

/// The visible stage mask comes from the first field of the actual whole.
/// Its complete path differs from reading the phase in the second field.
public typealias FourLeafVisibleMask<W: Pair> = SequentialReading<
    FirstEvidenceImage<W, BeamSpace, SaturationEncoding, FirstProjection>,
    SecondEvidenceImage<W.Left, BeamSpace, SaturationEncoding, SecondProjection>>
where W.Left: Pair

/// Use one of the four fixed calibration clauses at that stage. A fact made
/// from this reading contains only its common stage question and the leaf.
/// The preceding unknown word and the phase-dependent U selection are absent.
public typealias FourLeafStageAddress<W: Pair, R: PredicateReading> = SequentialReading<
    FourLeafVisibleMask<W>, R>
where W.Left: Pair, R.Left == W.Left.Right,
      R.Sigma == BeamSpace, R.Encoding == SaturationEncoding

public enum FourLeafResidentOutcomes<K: Structure>: Null {
    public typealias A0 = FourLeafSelected0<K>
    public typealias A1 = FourLeafSelected1<K>
    public typealias A2 = FourLeafSelected2<K>
    public typealias A3 = FourLeafSelected3<K>
    public typealias Context = Paired<FourLeafAddressProgram, K>
    public typealias Left = BoundaryWorking<
        A0.Answer, A1.Answer, A2.Answer, A3.Answer>
    public typealias Right = BoundaryWorking<
        LocalPhaseWorld<Paired<Never, FourLeafPhaseMark0>, FourLeafPhaseMark1, Context>,
        LocalPhaseWorld<Paired<Never, FourLeafPhaseMark1>, FourLeafPhaseMark2, Context>,
        LocalPhaseWorld<Paired<Never, FourLeafPhaseMark2>, FourLeafPhaseMark3, Context>,
        LocalPhaseWorld<Paired<Never, FourLeafPhaseMark3>, FourLeafPhaseMark0, Context>>
}
