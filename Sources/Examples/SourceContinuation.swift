import VerificationIsIdentification

/// Two exact source answers through the same late reading agree.
/// The equality follows through the shared partner of the supplied joins.
/// The boundary's completeness remains a premise. [Continuation E2]
public typealias OriginalAnswersThroughContinuation<
    C: SharedBoundaryContinuation
> = JoinedVerdict<C.Left.Left, C.Right.Left>
