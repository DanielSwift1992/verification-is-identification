import VerificationIsIdentification
import Examples

enum E2OriginalAnswersFollow<C: SharedBoundaryContinuation>: Null {
    typealias Left = C.Left.Left.Answer
    typealias Right = C.Right.Left.Answer
}

enum E2Space {}
enum E2Encoding {}
enum E2OriginalQuestion {}
enum E2BoundaryQuestion {}
enum E2PrefixA {}
enum E2PrefixB {}
enum E2Future {}
enum E2OtherFuture {}
enum E2UnrelatedPrefix {}
enum E2BoundaryImage {}
enum E2Answer {}
enum E2OtherAnswer {}

enum E2Reading<Source, Image, Question>: PredicateReading {
    typealias Left = Source
    typealias Right = Image
    typealias Sigma = E2Space
    typealias Encoding = E2Encoding
    typealias Predicate = Question
    typealias Answer = Image
}

enum E2Join<Prefix, Future>: Pair {
    typealias Left = Prefix
    typealias Right = Future
}

enum E2SharedBoundary: EncodingForgets {
    typealias Left = E2Reading<E2PrefixA, E2BoundaryImage, E2BoundaryQuestion>
    typealias Right = E2Reading<E2PrefixB, E2BoundaryImage, E2BoundaryQuestion>
    typealias Sigma = E2Space
    typealias Encoding = E2Encoding
    typealias Predicate = E2BoundaryQuestion
    typealias Answer = E2BoundaryImage
    typealias LeftSource = E2PrefixA
    typealias RightSource = E2PrefixB
    typealias SharedImage = E2BoundaryImage
}

typealias E2Late = E2Reading<E2Future, E2Answer, E2OriginalQuestion>
typealias E2DirectA = E2Reading<E2PrefixA, E2Answer, E2OriginalQuestion>
typealias E2DirectB = E2Reading<E2PrefixB, E2Answer, E2OriginalQuestion>

enum E2CommonContinuation: SharedBoundaryContinuation {
    typealias Left = JoinedVerdict<E2DirectA, E2Late>
    typealias Right = JoinedVerdict<E2DirectB, E2Late>
    typealias Boundary = E2SharedBoundary
    typealias FirstJoin = E2Join<E2PrefixA, E2Future>
    typealias SecondJoin = E2Join<E2PrefixB, E2Future>
}

typealias E2DerivedOriginalVerdict = OriginalAnswersThroughContinuation<E2CommonContinuation>
typealias E2DerivedEquality = E2OriginalAnswersFollow<E2CommonContinuation>

#if E2_BAD_LATE_SEAM
// Equal output values do not identify two distinct actual late sources.
enum E2RejectedLateSeam: SharedBoundaryContinuation {
    typealias Left = E2CommonContinuation.Left
    typealias Right = JoinedVerdict<E2DirectB, E2Reading<E2OtherFuture, E2Answer, E2OriginalQuestion>>
    typealias Boundary = E2SharedBoundary
    typealias FirstJoin = E2CommonContinuation.FirstJoin
    typealias SecondJoin = E2Join<E2PrefixB, E2OtherFuture>
}
#endif

#if E2_BAD_SOURCE_SEAM
// The joining witness cannot substitute a different original prefix.
enum E2RejectedSourceSeam: SharedBoundaryContinuation {
    typealias Left = E2CommonContinuation.Left
    typealias Right = E2CommonContinuation.Right
    typealias Boundary = E2SharedBoundary
    typealias FirstJoin = E2Join<E2UnrelatedPrefix, E2Future>
    typealias SecondJoin = E2CommonContinuation.SecondJoin
}
#endif

#if E2_BAD_ORIGINAL_ANSWER
// One late answer cannot be exact for two opposite original answers.
typealias E2RejectedOriginalAnswer = JoinedVerdict<
    E2Reading<E2PrefixB, E2OtherAnswer, E2OriginalQuestion>, E2Late
>
#endif
