import VerificationIsIdentification
import Examples

enum ProfileStage: Close {}

/// This additional contact is independently constructed from current fields.
/// It exchanges the resident phase with its reserve and retains the program.
enum ExchangePhaseReserve<S: Structure, P: Structure, J: Structure, R: Structure>: PredicateReading {
    typealias Source = LocalPhaseWorld<S, P, Paired<J, R>>
    typealias Stage = FirstEvidenceImage<Source, BeamSpace, SaturationEncoding, FirstProjection>
    typealias Tail = SecondEvidenceImage<Source, BeamSpace, SaturationEncoding, SecondProjection>
    typealias Phase = FollowedPair<Tail,
        FirstEvidenceImage<Tail.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    typealias Context = FollowedPair<Tail,
        SecondEvidenceImage<Tail.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    typealias Program = FollowedPair<Context,
        FirstEvidenceImage<Context.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    typealias Reserve = FollowedPair<Context,
        SecondEvidenceImage<Context.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    typealias Actual = JointEvidence<Stage, JointEvidence<Reserve, JointEvidence<Program, Phase>>>
    typealias Left = Source
    typealias Right = Actual.Answer
    typealias Sigma = BeamSpace
    typealias Encoding = SaturationEncoding
    typealias Predicate = Actual.Predicate
    typealias Answer = Right
}

enum ProfileChange {
    typealias X = ExchangePhaseReserve<FourLeafCenter, FourLeafPhaseMark0,
        FourLeafAddressProgram, FourLeafPhaseMark0>
    typealias Y = ExchangePhaseReserve<FourLeafCenter, FourLeafPhaseMark0,
        FourLeafAddressProgram, FourLeafPhaseMark1>
    typealias AfterX = FourLeafControl<Lit1, Never, Never, Never, Never, FourLeafPhaseMark0>.At0
    typealias AfterY = FourLeafControl<Lit1, Never, Never, Never, Never, FourLeafPhaseMark0>.At1
}

enum ProfileSameBeforeExchange: Null {
    typealias Left = LocalStagePhaseImage<ProfileChange.X.Left>.Answer
    typealias Right = LocalStagePhaseImage<ProfileChange.Y.Left>.Answer
}

enum ProfileCurrentRootsAreExchangedSources: Null {
    typealias Left = Paired<ProfileChange.X.Answer, ProfileChange.Y.Answer>
    typealias Right = Paired<ProfileChange.AfterX.Left, ProfileChange.AfterY.Left>
}

enum ProfileDifferentFutureStages: Null {
    typealias Left = Paired<ProfileChange.AfterX.Answer.Left.Right.Left.Left,
        ProfileChange.AfterY.Answer.Left.Right.Left.Left>
    typealias Right = Paired<Lit1, Never>
}

enum ProfileReserveExchangeIsInvolutive<S: Structure, P: Structure,
    J: Structure, R: Structure>: Null {
    typealias First = ExchangePhaseReserve<S, P, J, R>
    typealias Second = ExchangePhaseReserve<S, R, J, P>
    typealias Path = FollowedPair<First, Second>
    typealias Left = Path.Left
    typealias Right = Path.Answer
}

enum ProfileInternalContextExchangeKeepsImage<H: Structure, J: Structure>: Null {
    typealias X = LocalContextExchange<FourLeafCenter, FourLeafPhaseMark0,
        FourLeafAddressProgram, H, J>
    typealias Left = X.Left
    typealias Right = X.Right
}

#if LOCAL_PHASE_PROFILE_SURVIVES_NEW_CONTACT
enum RejectedProfileScopeExtension: Null {
    typealias Left = ProfileChange.AfterX.Answer.Left
    typealias Right = ProfileChange.AfterY.Answer.Left
}
#endif
