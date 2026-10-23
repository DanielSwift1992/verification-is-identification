// GENERATED owner publication: Worlds/Documentation/Publications/VisibleClaim.swift@sha256:6c0d2cca45b0e886170696edd9297b138aee9eeb2cd7254dea75ecd9359d7458
import VerificationIsIdentification
import Examples

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
