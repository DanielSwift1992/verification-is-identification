import VerificationIsIdentification
import Examples

#if !LOCAL_PHASE_ACQUIRED_ACTION_CHANGES_QUESTION && !LOCAL_PHASE_ACQUIRED_ACTION_IDENTIFIES_FRAMES && !LOCAL_PHASE_ACQUIRED_ACTION_WRONG_INVERSE
enum AcquiredFramesHaveOneUsefulAnswer: Null {
    typealias C = AcquiredDistinctFrames
    typealias Left = Paired<C.Decision.Read.Answer, C.SameReceiverInput.Left>
    typealias Right = Paired<EchoEqual, C.SameReceiverInput.Right>
}

enum AcquiredFrameActionOnAnyPayload<A: Structure, B: Structure,
    C: Structure, D: Structure, K: Structure>: Null {
    typealias F = AcquiredFrameActions<A, B, C, D, K>
    typealias Left = Paired<F.SameFullAction.Left,
        Paired<F.ResultAndArchive.Left, F.ContextsReturned.Left>>
    typealias Right = Paired<F.SameFullAction.Right,
        Paired<F.ResultAndArchive.Right, F.ContextsReturned.Right>>
}

enum AcquiredActionQuestionReallyMatters: Null {
    typealias F = AcquiredFrameActions<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11, Never>
    typealias Left = F.DifferentQuestion.Left
    typealias Right = F.DifferentQuestion.Right
}
#endif

#if LOCAL_PHASE_ACQUIRED_ACTION_CHANGES_QUESTION
enum RejectedAcquiredActionChangesQuestion: Null {
    typealias F = AcquiredFrameActions<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11, Never>
    typealias Left = F.ZThroughH.Right.Left.Right.Right
    typealias Right = F.ZThroughK.Right.Left.Right.Right
}
#endif

#if LOCAL_PHASE_ACQUIRED_ACTION_IDENTIFIES_FRAMES
enum RejectedAcquiredActionIdentifiesFrames: Null {
    typealias Left = AcquiredFrameContexts.H.Answer
    typealias Right = AcquiredFrameContexts.K.Answer
}
#endif

// The inverse is selected at the actual retained frame address. The other
// frame's inverse address is not admitted by that same resident selector.
#if LOCAL_PHASE_ACQUIRED_ACTION_WRONG_INVERSE
enum RejectedAcquiredActionWrongInverse: Null {
    typealias F = AcquiredFrameActions<Never, Never, Never, Never, Never>
    typealias Left = F.KI.Address.Answer
    typealias Right = F.KR.SelectZWW.Address
}
#endif
