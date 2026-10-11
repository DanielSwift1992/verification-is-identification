import VerificationIsIdentification
import Examples

enum RecordedReturnCase {
    typealias K = Paired<Lit1, Never>
    typealias C = FourLeafRecordedReturn<Lit1, Never, Never, Never, Never, K>
    typealias NextU = FourLeafControl<Never, Lit1, Never, Never, Never, K>.At1
}

enum RecordedReturnRetainsOriginalContextAndFact: Null {
    typealias C = RecordedReturnCase.C
    typealias Left = Paired<C.Path0.Right.Left.Right.Right, C.Path0.Right.Right>
    typealias Right = Paired<Paired<FourLeafAddressProgram, RecordedReturnCase.K>, FourLeafSelectionRecords.Fact0>
}

enum RecordedReturnDecoderSeesOnlyFactAndProgram: Null {
    typealias C = RecordedReturnCase.C
    typealias Left = C.I0.Answer
    typealias Right = Paired<FourLeafSelectionRecords.Fact0, FourLeafAddressProgram>
}

enum RecordedReturnUsesPastChoice: Null {
    typealias C = RecordedReturnCase.C
    typealias Left = Paired<C.Back0.Selection.Answer, RecordedReturnCase.NextU.Selection.Answer>
    typealias Right = Paired<FourLeafAddressProgram.Left.Left, FourLeafAddressProgram.Left.Right>
}

// The current catalogue can change while the retained address stays true.
// Its new contact0 preserves phase and remains an involution. Its expression
// is built from the changed actual rows; no old library name is forged.
enum ChangedAfterRecordedChoice: Pair {
    typealias Base = RecordedReturnCase.C.R0
    typealias Phase = Base.Left.Right.Left
    typealias Context = Base.Left.Right.Right
    typealias S0 = PairedApplication<FourLeafStage0<Never, Lit1, Never, Never, Never>,
        ExperimentReadingBeside<IdentityReading<Phase, BeamSpace, SaturationEncoding>, Context>>
    typealias Low = CandidateFork<CandidateLeaf<S0>, CandidateLeaf<Base.S1>>
    typealias Catalogue = CandidateFork<Low, Base.High>
    typealias Select0 = SelectCandidateLeft<
        SelectCandidateLeft<SelectCandidateLeaf<S0>, CandidateLeaf<Base.S1>>, Base.High>
    typealias Expression = BoundaryWorking<S0.Predicate, Base.S1.Predicate, Base.S2.Predicate, Base.S3.Predicate>
    typealias Left = Base.Left
    typealias Right = Paired<Expression, Catalogue>
}

// Both prepared catalogues are already inside the source. Exchange their
// current/reserve positions while keeping the target and acquired fact.
enum RecordedChoiceCatalogueExchange: Pair {
    typealias C = RecordedReturnCase.C
    typealias Left = Paired<C.Keep0.Right, Paired<C.R0.Right, ChangedAfterRecordedChoice.Right>>
    typealias Right = Paired<C.Keep0.Right, Paired<ChangedAfterRecordedChoice.Right, C.R0.Right>>
}

enum RecordedReturnChangedLawCase {
    typealias C = RecordedReturnCase.C
    typealias Exchange = RecordedChoiceCatalogueExchange
    typealias CurrentRoot = Paired<Exchange.Right.Left, Exchange.Right.Right.Left>
    typealias Back = SelectedLocalApplication<CurrentRoot, C.I0,
        ReadLocalChoice<C.I0.Answer>, ChangedAfterRecordedChoice.Select0>
    typealias PreparedCatalogues = Exchange.Left.Right
    typealias Forward = ExperimentReadingBeside<C.F0.RecordedPrimitive, PreparedCatalogues>
    typealias Keep = StepBeside<C.Keep0, PreparedCatalogues>
    typealias Apply = ExperimentReadingBeside<Back, Exchange.Right.Right>
    typealias Actual = FollowedPair<FollowedPair<Forward, Keep>, FollowedPair<Exchange, Apply>>
}

enum RecordedCatalogueExchangeRetainsPreviousBasis: Null {
    typealias C = RecordedReturnChangedLawCase
    typealias Left = Paired<C.Actual.Right.Right.Right, C.Actual.Right.Left.Right.Right.Right.Right>
    typealias Right = Paired<RecordedReturnCase.C.R0.Right, FourLeafSelectionRecords.Fact0>
}

enum ChangedLawStillSelectsTheAcquiredAddress: Null {
    typealias Left = RecordedReturnChangedLawCase.Back.Selection.Answer
    typealias Right = FourLeafSelectionRecords.Fact0.Answer
}

enum ChangedContactIsStillInvolutive: Null {
    typealias R = ChangedAfterRecordedChoice
    typealias Again = PairedApplication<FourLeafStage0<Lit1, Never, Never, Never, Never>,
        ExperimentReadingBeside<IdentityReading<R.Phase, BeamSpace, SaturationEncoding>, R.Context>>
    typealias Actual = FollowedPair<R.S0, Again>
    typealias Left = Actual.Left
    typealias Right = Actual.Answer
}

#if LOCAL_PHASE_RECORDED_CHOICE_ALLOWS_OTHER_ADDRESS
enum RejectedRecordedChoiceOtherAddress: Pair {
    typealias C = RecordedReturnCase.C
    typealias Wrong = SelectedLocalApplication<C.R0, C.I0, ReadLocalChoice<C.I0.Answer>, C.R0.Select1>
    typealias Left = Wrong.Left
    typealias Right = Wrong.Answer
}
#endif

#if LOCAL_PHASE_RECORDED_CHOICE_NEXT_U_IS_INVERSE
enum RejectedRecordedChoiceNextU: Null {
    typealias C = RecordedReturnCase.C
    typealias Actual = FollowedPair<C.F0, RecordedReturnCase.NextU>
    typealias Left = Actual.Left
    typealias Right = Actual.Answer
}
#endif

#if LOCAL_PHASE_RECORDED_CHOICE_SURVIVES_LAW_CHANGE
enum RejectedRecordedChoiceChangedLaw: Null {
    typealias C = RecordedReturnCase.C
    typealias Left = RecordedReturnChangedLawCase.Actual.Right.Left
    typealias Right = C.Back0.Answer
}
#endif
