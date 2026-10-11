import VerificationIsIdentification
import Examples
import DocumentKit

// The request refers to source readings directly, not to the proposal aliases.
// Changing the proposal cannot silently change what was requested.
typealias RequestedVisibleAnswers = CoveredJoin<
    CoveredGroup<CoveredJoin<
        CoveredLeaf<VisibleReading<RedBeam>>,
        CoveredLeaf<VisibleReading<RedBeamWithIR>>
    >>,
    CoveredLeaf<VisibleReading<RedBeamWithMoreIR>>
>

// The archive retains the former two-member support. CoveredStatement relates
// the request to the proposal; context labels alone do not establish that relation.
typealias ClaimPublicationRoot = Paired<
    Paired<DeclaredThreeBeams, RequestedVisibleAnswers>,
    Paired<ThreeBeamsCovered, CoveredTwoBeams.Candidates>
>

typealias PublishedVisibleClaim = CoveredStatement<ClaimPublicationRoot>
