import VerificationIsIdentification
import Examples

// A generic body checks the equality the declaration relation must imply.
enum DeclaredSupportFollows<C: CoverageMatchesDeclaration>: Null {
    typealias Left = C.Left.Candidates
    typealias Right = C.Right
}

enum SharedAnswerFollows<C: SharedDecoder>: Null {
    typealias Left = C.Left.Left.Answer
    typealias Right = C.Right.Left.Answer
}

typealias CompleteThree = DeclaredSupportFollows<ThreeBeamsCovered>
typealias AlphaAgrees = SharedAnswerFollows<SharedVisibleImage<RedBeam, RedBeamWithIR>>
typealias DerivedAlphaVerdict = AnswersThroughSharedDecoder<SharedVisibleImage<RedBeam, RedBeamWithIR>>
typealias ArbitrarilyDeeperRed<H: IntegerValued> = RedFamilyVerdict<RedWithHidden<H>, RedWithHidden<Examples.Succ<H>>>
typealias ArbitraryBeamFactors<B: BeamShape> = AlphaFactors<B>

enum IdentityAnswerAgreementIdentifies<C: VerdictIsInvariant>: Null
where C.Left.Answer == C.Left.Left, C.Right.Answer == C.Right.Left {
    typealias Left = IdentityVerdictIdentifiesSources<C>.Left
    typealias Right = IdentityVerdictIdentifiesSources<C>.Right
}

// Two occurrences, one candidate type. No new support or counting mechanism.
typealias IdentityAtOne = CoveredIdentity<Lit1, BeamSpace, SaturationEncoding>
typealias RepeatedIdentitySupport = CoveredJoin<IdentityAtOne, IdentityAtOne>
typealias DeclaredRepeatedOne = CandidateFork<CandidateLeaf<Lit1>, CandidateLeaf<Lit1>>
typealias RepeatedOneIsCovered = CheckedCoverage<RepeatedIdentitySupport, DeclaredRepeatedOne>
typealias RepeatedOneIsIdentified = IdentityVerdictIdentifiesSources<RepeatedIdentitySupport>

enum RepeatedIdentityKeepsItsCandidate: Null {
    typealias Left = RepeatedOneIsIdentified.Left
    typealias Right = Lit1
}

enum RepeatedSupportSuppliesOneMember<X>: Null {
    typealias Support = CandidateFork<CandidateLeaf<X>, CandidateFork<CandidateLeaf<X>, CandidateLeaf<X>>>
    typealias Left = Support.Member
    typealias Right = X
}

typealias IdentifiedByDeclaredSupport = DeclaredSingleCandidate<RepeatedOneIsCovered>
enum DeclarationAndCertificateIdentifyOneMember: Null {
    typealias Left = IdentifiedByDeclaredSupport.Left
    typealias Right = Lit1
}

enum SelectionDerivesCommonMember<P: SingletonCandidateSelection>: Null {
    typealias Left = P.Right
    typealias Right = P.Left.Member
}

// Different paths through a nested support, with a coarse visible question.
// The answer need not be the source. Each candidate is derived from a leaf.
enum CoveredPathsIdentify<B: BeamShape>: Null {
    typealias Leaf = CoveredLeaf<VisibleReading<B>>
    typealias Certificate = CoveredJoin<Leaf, CoveredGroup<CoveredJoin<Leaf, Leaf>>>
    typealias Declaration = CandidateFork<CandidateLeaf<B>, CandidateFork<CandidateLeaf<B>, CandidateLeaf<B>>>
    typealias Coverage = CheckedCoverage<Certificate, Declaration>
    typealias First = SelectCandidateLeft<SelectCandidateLeaf<B>, CandidateFork<CandidateLeaf<B>, CandidateLeaf<B>>>
    typealias Last = SelectCandidateRight<CandidateLeaf<B>, SelectCandidateRight<CandidateLeaf<B>, SelectCandidateLeaf<B>>>
    typealias Identification = IdentifyCoveredCandidates<Coverage, First, Last>
    typealias Left = Identification.Left
    typealias Right = Identification.Right
}

typealias RepeatedFirst = SelectCandidateLeft<SelectCandidateLeaf<Lit1>, CandidateLeaf<Lit1>>
typealias RepeatedLast = SelectCandidateRight<CandidateLeaf<Lit1>, SelectCandidateLeaf<Lit1>>
typealias RepeatedPathsIdentify = IdentifyCoveredCandidates<RepeatedOneIsCovered, RepeatedFirst, RepeatedLast>
typealias NeverLeafIsSelected = SelectionDerivesCommonMember<SelectCandidateLeaf<Never>>

// Assignment identity is derived without requiring identity of task wrappers.
enum AnotherPinnedTask: Task { typealias Assigned = MachineA }
typealias AnotherScheduleIsForced = PinnedScheduleIsForced<AnotherPinnedTask, T1, T2, T3>
enum ActualScheduleCoordinatesAreForced: Null {
    typealias Left = AnotherScheduleIsForced.Left
    typealias Right = ScheduleAssignment<T0, T1, T2, T3>
}

// Removing the pin admits the exchanged assignment as well. Both close.
typealias ExchangedT0 = Pinned<MachineB>
typealias ExchangedT1 = Conflicts<ExchangedT0>
typealias ExchangedT2 = Conflicts<ExchangedT1>
typealias ExchangedT3 = Conflicts<ExchangedT2>
typealias ExchangedCycleCloses = Require<Conflict<ExchangedT3, ExchangedT0>>

// Both cycles exist before this added contact. The resident reference is
// independently pinned to A, so the exchanged schedule can join it.
typealias LaterContactAdmitsExchangedSchedule = Require<Conflict<
    AnotherPinnedTask, ExchangedT0
>>

#if UNIQUE_DEFAULT_PRESERVES_LATER_CONTACT
// Selecting the A-first schedule early discards the admitted completion.
typealias RejectedEarlyDefaultContact = Require<Conflict<AnotherPinnedTask, T0>>
#endif

#if UNIQUE_SCHEDULE_WITHOUT_PIN
typealias RejectedUnpinnedUniqueness = PinnedScheduleIsForced<ExchangedT0, ExchangedT1, ExchangedT2, ExchangedT3>
#endif

#if UNIQUE_SCHEDULE_WITHOUT_EDGE
typealias RejectedMissingScheduleEdge = PinnedScheduleIsForced<T0, T1, T1, T3>
#endif

#if UNIQUE_SCHEDULE_IGNORES_CLOSING_EDGE
typealias RejectedOddCycleClosure = Require<Conflict<T2, T0>>
#endif

// Membership alone remains possible when the source has different members.
typealias MixedFirst = SelectCandidateLeft<SelectCandidateLeaf<Never>, CandidateLeaf<Lit1>>
enum MixedSupportSelectionIsStillMembership: Null {
    typealias Left = MixedFirst.Right
    typealias Right = Never
}

#if UNIQUE_MEMBERSHIP_FORCES_SINGLETON
typealias RejectedMembershipAsSingleton = SelectionDerivesCommonMember<MixedFirst>
#endif

#if UNIQUE_SELECTION_CHANGES_CANDIDATE
enum RejectedSelectionCandidate: Null {
    typealias Left = RepeatedFirst.Right
    typealias Right = Never
}
#endif

#if UNIQUE_SELECTION_IGNORES_DECLARATION
// The candidate agrees, but the path starts in a different support tree.
typealias RejectedSelectionDeclaration = IdentifyCoveredCandidates<
    RepeatedOneIsCovered, SelectCandidateLeaf<Lit1>, RepeatedLast
>
#endif

#if UNIQUE_SELECTION_IGNORES_TARGET_SUPPORT
typealias RejectedTargetSupport = IdentifyCoveredCandidates<
    RepeatedOneIsCovered, RepeatedFirst,
    SelectCandidateRight<CandidateLeaf<Lit1>, SelectCandidateLeaf<Never>>
>
#endif

#if UNIQUE_SUPPORT_HAS_DIFFERENT_MEMBERS
enum RejectedDifferentSupportMembers: Null {
    typealias Support = CandidateFork<CandidateLeaf<Never>, CandidateLeaf<Lit1>>
    typealias Left = Support.Member
    typealias Right = Lit1
}
#endif

#if UNIQUE_VISIBLE_COVERAGE_IDENTIFIES_MEMBER
typealias RejectedVisibleSupportSingleton = DeclaredSingleCandidate<ThreeBeamsCovered>
#endif

// Never as a candidate type is one meta-level candidate, even though it
// has no runtime values. A support leaf is not the empty candidate set.
typealias NeverIsOneCandidate = CoveredIdentity<Never, BeamSpace, SaturationEncoding>
enum ALeafRetainsTheNeverCandidate: Null {
    typealias Left = NeverIsOneCandidate.Candidates
    typealias Right = CandidateLeaf<Never>
}

#if UNIQUE_COARSE_ANSWER_IDENTIFIES_SOURCE
typealias RejectedCoarseIdentification = IdentityVerdictIdentifiesSources<VisibleVerdict>
#endif

#if UNIQUE_DIFFERENT_IDENTITY_CANDIDATES_AGREE
typealias RejectedDifferentIdentityCandidates = CoveredJoin<
    CoveredIdentity<Never, BeamSpace, SaturationEncoding>, IdentityAtOne
>
#endif

#if UNIQUE_REPEATED_SUPPORT_IS_ONE_OCCURRENCE
enum RejectedSupportOccurrenceCollapse: Null {
    typealias Left = RepeatedIdentitySupport.Candidates
    typealias Right = CandidateLeaf<Lit1>
}
#endif

#if UNIQUE_COVERAGE_OMITS_IDENTITY_CANDIDATE
typealias RejectedIdentityCoverage = CheckedCoverage<
    RepeatedIdentitySupport,
    CandidateFork<CandidateLeaf<Lit1>, CandidateLeaf<Never>>
>
#endif

#if MISSING_CANDIDATE
typealias RejectedMissing = CheckedCoverage<CoveredTwoBeams, DeclaredThreeBeams>
#endif

#if REPEATED_CANDIDATE
typealias RepeatedThird = CoveredJoin<CoveredGroup<CoveredTwoBeams>, CoveredLeaf<VisibleReading<RedBeamWithIR>>>
typealias RejectedRepeated = CheckedCoverage<RepeatedThird, DeclaredThreeBeams>
#endif

#if FALSE_LEAF
enum RejectedLeaf: CandidateLeafReading {
    typealias Left = RedBeam
    typealias Right = EyeImage<RedBeam>
    typealias Sigma = BeamSpace
    typealias Encoding = EyeEncoding
    typealias Predicate = VisibleQuestion
    typealias Answer = Right
    typealias Candidates = CandidateLeaf<RedBeamWithIR>
}
#endif

#if FALSE_GROUP
enum RejectedGroup: CandidateGroupReading {
    typealias Certificate = CoveredTwoBeams
    typealias Left = Certificate
    typealias Right = Certificate.Answer
    typealias Sigma = Certificate.Sigma
    typealias Encoding = Certificate.Encoding
    typealias Predicate = Certificate.Predicate
    typealias Answer = Right
    typealias Candidates = DeclaredThreeBeams
}
#endif

#if FALSE_UNION
enum RejectedUnion: VerdictCoversBranches {
    typealias Left = CoveredLeaf<VisibleReading<RedBeam>>
    typealias Right = CoveredLeaf<VisibleReading<RedBeamWithIR>>
    typealias Sigma = BeamSpace
    typealias Encoding = EyeEncoding
    typealias Predicate = VisibleQuestion
    typealias Answer = Left.Answer
    typealias Candidates = CandidateFork<Left.Candidates, Left.Candidates>
}
#endif

#if FALSE_OBSERVATION_SOURCE
enum RejectedObservationSource: ReadingFactors {
    typealias Left = AlphaReading<RedBeam>
    typealias Right = ImageAlphaReading<EyeImage<RedBeam>>
    typealias Observation = VisibleReading<RedBeamWithIR>
    typealias Sigma = BeamSpace
    typealias Encoding = EyeEncoding
    typealias Predicate = AlphaQuestion
    typealias Answer = Lit1
}
#endif

#if FALSE_OBSERVATION_IMAGE
enum RejectedObservationImage: ReadingFactors {
    typealias Left = AlphaReading<RedBeam>
    typealias Right = ImageAlphaReading<EyeImage<RedBeam>>
    typealias Observation = RecordedReading<BeamSpace, EyeEncoding, VisibleQuestion, Lit1, RedBeam>
    typealias Sigma = BeamSpace
    typealias Encoding = EyeEncoding
    typealias Predicate = AlphaQuestion
    typealias Answer = Lit1
}
#endif

#if HIDDEN_DECODER
// A constant decoder happens to work for RedBeam but cannot recover every
// beam's infrared coordinate from the visible image. The generic body fails.
enum RejectedHiddenDecoder<B: BeamShape>: ReadingFactors {
    typealias Left = RecordedReading<BeamSpace, EyeEncoding, InfraredQuestion, B.PaschenLevel, B>
    typealias Right = RecordedReading<BeamSpace, EyeEncoding, InfraredQuestion, Never, EyeImage<B>>
    typealias Observation = VisibleReading<B>
    typealias Sigma = BeamSpace
    typealias Encoding = EyeEncoding
    typealias Predicate = InfraredQuestion
    typealias Answer = B.PaschenLevel
}
#endif

#if FALSE_SHARED_DECODER
enum CoverageDarkBeam: BeamShape {
    typealias AlphaLevel = Never
    typealias BetaLevel = Never
    typealias PaschenLevel = Never
}
enum RejectedSharedDecoder: SharedDecoder {
    typealias Left = AlphaFactors<RedBeam>
    typealias Right = AlphaFactors<CoverageDarkBeam>
}
#endif

#if FUTURE_OBSERVATION
typealias RejectedFuture = JoinedVerdict<
    VisibleReading<ExposeHidden<RedBeam>>,
    VisibleReading<ExposeHidden<RedBeamWithIR>>
>
#endif

// A permitted operation supplies its own factorization witness. The same
// shared-decoder theorem then gives agreement of the future observations.
typealias SafeFutureAnswer = AnswersThroughSharedDecoder<SharedSwappedImage<RedBeam, RedBeamWithIR>>
typealias ArbitrarySwapFactors<B: BeamShape> = SwapFactors<B>
