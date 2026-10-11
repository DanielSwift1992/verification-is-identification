import VerificationIsIdentification
import Examples

// Generic implications: no additional answer equality appears in the premises.
// If the lattice stops relating these addresses, these bodies stop compiling.
enum LeftAnswerFollows<C: VerdictRetainsLeft>: Null {
    typealias Left = C.Left.Answer
    typealias Right = C.Right.Answer
}

enum RightAnswerFollows<C: VerdictRetainsRight>: Null {
    typealias Left = C.Left.Answer
    typealias Right = C.Right.Answer
}

enum ReorderedAnswerFollows<C: VerdictReorders>: Null {
    typealias Left = C.Left.Answer
    typealias Right = C.Right.Answer
}

enum SameType<A, B>: Null where A == B {
    typealias Left = A
    typealias Right = B
}

typealias ThreeAnswersAgree = SameType<ThreeBeamVerdict.Answer, VisibleVerdict.Answer>
typealias SingletonAgrees = SameType<SingletonVerdict<VisibleReading<RedBeam>>.Answer, EyeImage<RedBeam>>
typealias LeftRetained = LeftAnswerFollows<RetainLeftVerdict<VisibleVerdict>>
typealias RightRetained = RightAnswerFollows<RetainRightVerdict<VisibleVerdict>>
typealias OrderChanged = ReorderedAnswerFollows<ReorderVerdict<ThreeBeamVerdict>>
typealias FirstAndThird = JoinedVerdict<
    RetainLeftVerdict<ThreeBeamVerdict.Left.Certificate>.Right,
    RetainRightVerdict<ThreeBeamVerdict>.Right
>
typealias SelectedAnswersAgree = SameType<FirstAndThird.Answer, ThreeBeamVerdict.Answer>

// Context mutation fixtures isolate each equality independently. An application
// record is a premise; these fixtures do not claim to compute an arbitrary P.
enum RecordedReading<S, E, P, A, Candidate>: PredicateReading {
    typealias Left = Candidate
    typealias Right = A
    typealias Sigma = S
    typealias Encoding = E
    typealias Predicate = P
    typealias Answer = A
}

enum OtherSpace {}
enum OtherEncoding {}
enum OtherQuestion {}

#if BAD_INFRARED
typealias RejectedInfrared = JoinedVerdict<InfraredReading<RedBeam>, InfraredReading<RedBeamWithIR>>
#endif

#if BAD_QUESTION
enum RejectedQuestion: ComparedReadings {
    typealias Left = VisibleReading<RedBeam>
    typealias Right = RecordedReading<BeamSpace, EyeEncoding, OtherQuestion, EyeImage<RedBeam>, RedBeamWithIR>
}
#endif

#if BAD_ENCODING
enum RejectedEncoding: ComparedReadings {
    typealias Left = VisibleReading<RedBeam>
    typealias Right = RecordedReading<BeamSpace, OtherEncoding, VisibleQuestion, EyeImage<RedBeam>, RedBeamWithIR>
}
#endif

#if BAD_SPACE
enum RejectedSpace: ComparedReadings {
    typealias Left = VisibleReading<RedBeam>
    typealias Right = RecordedReading<OtherSpace, EyeEncoding, VisibleQuestion, EyeImage<RedBeam>, RedBeamWithIR>
}
#endif

#if BAD_ANSWER
enum RejectedAnswer: VerdictIsInvariant {
    typealias Left = InfraredReading<RedBeam>
    typealias Right = InfraredReading<RedBeamWithIR>
    typealias Sigma = BeamSpace
    typealias Encoding = PrismSeparator
    typealias Predicate = InfraredQuestion
    typealias Answer = Lit1
}
#endif

#if BAD_RIGHT_ANSWER
enum RejectedRightAnswer: VerdictIsInvariant {
    typealias Left = InfraredReading<RedBeam>
    typealias Right = InfraredReading<RedBeamWithIR>
    typealias Sigma = BeamSpace
    typealias Encoding = PrismSeparator
    typealias Predicate = InfraredQuestion
    typealias Answer = Never
}
#endif

#if BAD_MEMBER
enum RejectedMember: VerdictRetainsLeft {
    typealias Left = VisibleVerdict
    // Same question and answer, but this source was not the retained member.
    typealias Right = VisibleReading<RedBeamWithMoreIR>
}
#endif

#if BAD_REORDER
enum RejectedReorder: VerdictReorders {
    typealias Left = VisibleVerdict
    typealias Right = VisibleVerdict
}
#endif

#if EMPTY_READINGS
enum RejectedEmpty: VerdictIsInvariant {
    typealias Left = Never
    typealias Right = Never
    typealias Sigma = BeamSpace
    typealias Encoding = EyeEncoding
    typealias Predicate = VisibleQuestion
    typealias Answer = Never
}
#endif

#if BAD_THIRD_BRANCH
enum DarkBeam: BeamShape {
    typealias AlphaLevel = Never
    typealias BetaLevel = Never
    typealias PaschenLevel = Never
}
typealias RejectedThird = JoinedVerdict<CertifiedGroup<VisibleVerdict>, VisibleReading<DarkBeam>>
#endif
