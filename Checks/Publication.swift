import VerificationIsIdentification
import Examples
import DocumentKit

// The declaration changes order, while all actual applications are retained.
typealias ReorderedVisibleProof = CoveredJoin<
    CoveredThreeBeams.Right,
    CoveredThreeBeams.Left
>
typealias ReorderedVisibleDeclaration = CandidateFork<
    CandidateLeaf<RedBeamWithMoreIR>,
    CandidateFork<CandidateLeaf<RedBeam>, CandidateLeaf<RedBeamWithIR>>
>
typealias ReorderedClaimRoot = Paired<
    Paired<ReorderedVisibleDeclaration, CoveredJoin<RequestedVisibleAnswers.Right, RequestedVisibleAnswers.Left>>,
    Paired<CheckedCoverage<ReorderedVisibleProof, ReorderedVisibleDeclaration>, ClaimPublicationRoot>
>
typealias ReorderedVisiblePublication = CoveredStatement<ReorderedClaimRoot>

enum CoveredReorderingKeepsAnswer<C: VerdictCoversBranches>: Null {
    typealias Left = CoveredJoin<C.Right, C.Left>.Answer
    typealias Right = C.Answer
}

typealias ArchivedVisibleCoverage = CheckedCoverage<
    CoveredTwoBeams,
    ClaimPublicationRoot.Right.Right
>

typealias CoveredAlpha = CoveredJoin<
    CoveredGroup<CoveredJoin<CoveredLeaf<AlphaReading<RedBeam>>, CoveredLeaf<AlphaReading<RedBeamWithIR>>>>,
    CoveredLeaf<AlphaReading<RedBeamWithMoreIR>>
>

// Distinct implementations can preserve a question through an actual
// factorization. Neither source nor answer equality is requested again.
enum FactoredPublicationRetainsSource<F: ReadingFactors>: Null {
    typealias Left = F.Left.Left
    typealias Right = SequentialReading<F.Observation, F.Right>.Left
}

enum FactoredPublicationRetainsAnswer<F: ReadingFactors>: Null {
    typealias Left = F.Left.Answer
    typealias Right = SequentialReading<F.Observation, F.Right>.Answer
}

typealias PublicationAlphaThroughImage<B: BeamShape> = SequentialReading<
    VisibleReading<B>, ImageAlphaReading<EyeImage<B>>
>
typealias CoveredAlphaThroughImage = CoveredJoin<
    CoveredGroup<CoveredJoin<
        CoveredLeaf<PublicationAlphaThroughImage<RedBeam>>,
        CoveredLeaf<PublicationAlphaThroughImage<RedBeamWithIR>>
    >>,
    CoveredLeaf<PublicationAlphaThroughImage<RedBeamWithMoreIR>>
>
typealias ImageAlphaPublicationRoot = Paired<
    Paired<DeclaredThreeBeams, CoveredAlpha>,
    Paired<CheckedCoverage<CoveredAlphaThroughImage, DeclaredThreeBeams>, ClaimPublicationRoot>
>
typealias ImageAlphaPublication = CoveredStatement<ImageAlphaPublicationRoot>
typealias AlphaPublicationSourceBridge<B: BeamShape> = FactoredPublicationRetainsSource<AlphaFactors<B>>
typealias AlphaPublicationAnswerBridge<B: BeamShape> = FactoredPublicationRetainsAnswer<AlphaFactors<B>>

// The open interface admits this declaration with the old question label.
// That label does not prove that this reading implements EyeImage.
enum PublicationDeclaredVisible<B: BeamShape>: PredicateReading {
    typealias Left = B
    typealias Right = Never
    typealias Answer = Never
    typealias Sigma = BeamSpace
    typealias Encoding = EyeEncoding
    typealias Predicate = VisibleQuestion
}

typealias CoveredDeclaredVisible = CoveredJoin<
    CoveredGroup<CoveredJoin<CoveredLeaf<PublicationDeclaredVisible<RedBeam>>, CoveredLeaf<PublicationDeclaredVisible<RedBeamWithIR>>>>,
    CoveredLeaf<PublicationDeclaredVisible<RedBeamWithMoreIR>>
>

enum PublicationContext<R: PredicateReading, S, E>: PredicateReading {
    typealias Left = R.Left
    typealias Right = R.Answer
    typealias Answer = R.Answer
    typealias Sigma = S
    typealias Encoding = E
    typealias Predicate = R.Predicate
}
typealias ContextualVisibleRequest<S, E> = CoveredJoin<
    CoveredGroup<CoveredJoin<CoveredLeaf<PublicationContext<VisibleReading<RedBeam>, S, E>>,
        CoveredLeaf<PublicationContext<VisibleReading<RedBeamWithIR>, S, E>>>>,
    CoveredLeaf<PublicationContext<VisibleReading<RedBeamWithMoreIR>, S, E>>
>

#if PUBLICATION_COHERENT_FALSE_READINGS
typealias RejectedCoherentPublication = CoveredStatement<
    Paired<ClaimPublicationRoot.Left,
        Paired<CheckedCoverage<CoveredDeclaredVisible, DeclaredThreeBeams>, ClaimPublicationRoot.Right.Right>>
>
#endif

#if PUBLICATION_SAME_LABEL_DIFFERENT_READING
typealias RejectedPublicationReadingBridge = JoinedVerdict<
    VisibleReading<RedBeam>, PublicationDeclaredVisible<RedBeam>
>
#endif

#if PUBLICATION_OTHER_QUESTION
typealias RejectedPublicationQuestion = CoveredStatement<
    Paired<ClaimPublicationRoot.Left,
        Paired<CheckedCoverage<CoveredAlpha, DeclaredThreeBeams>, ClaimPublicationRoot.Right.Right>>
>
#endif

#if PUBLICATION_OTHER_ENCODING
typealias RejectedPublicationEncoding = CoveredStatement<
    Paired<
        Paired<DeclaredThreeBeams, ContextualVisibleRequest<BeamSpace, PrismSeparator>>,
        ClaimPublicationRoot.Right
    >
>
#endif

#if PUBLICATION_OTHER_SPACE
typealias RejectedPublicationSpace = CoveredStatement<
    Paired<
        Paired<DeclaredThreeBeams, ContextualVisibleRequest<Never, EyeEncoding>>,
        ClaimPublicationRoot.Right
    >
>
#endif

#if PUBLICATION_ARCHIVE_IS_ACTIVE
typealias RejectedPublicationArchive = CoveredStatement<
    Paired<ClaimPublicationRoot.Left, Paired<ArchivedVisibleCoverage, ClaimPublicationRoot.Right.Right>>
>
#endif

#if PUBLICATION_VISIBLE_IDENTIFIES_SOURCE
typealias RejectedPublishedIdentification = IdentityVerdictIdentifiesSources<
    CoveredThreeBeams
>
#endif
