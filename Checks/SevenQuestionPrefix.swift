import VerificationIsIdentification
import Examples

// The suffix contains three distinct occurrence labels, even though the
// value question assigns B to all three. The even alternatives fix those
// actual labelled inputs and one further selected input in the first block.
enum SevenPrefixNamedInputs: Null {
    typealias P = SevenQuestionPrefix<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11, Never, Lit1, Paired<Lit1, Lit1>>
    typealias Left = P.KeepsThreeNamedInputs.Left
    typealias Right = P.KeepsThreeNamedInputs.Right
}

enum SevenPrefixFourthPointAgrees: Null {
    typealias Left = SevenPrefixOneMorePoint.Left
    typealias Right = SevenPrefixOneMorePoint.Right
}

// One extra query after the old three-query optimum cannot distinguish
// identity from the corresponding alternative for any of the four choices.
// These are witnesses at the identity transcript; the paper's even-cycle
// argument transports the obstruction to every consistent transcript.
#if LOCAL_PHASE_PREFIX_FOURTH_POINT0
enum RejectedSevenPrefixPoint0: Null {
    typealias P = SevenPrefixNamedInputs.P
    typealias Left = P.Fix0.Right
    typealias Right = P.I.Right
}
#endif
#if LOCAL_PHASE_PREFIX_FOURTH_POINT1
enum RejectedSevenPrefixPoint1: Null {
    typealias P = SevenPrefixNamedInputs.P
    typealias Left = P.Fix1.Right
    typealias Right = P.I.Right
}
#endif
#if LOCAL_PHASE_PREFIX_FOURTH_POINT2
enum RejectedSevenPrefixPoint2: Null {
    typealias P = SevenPrefixNamedInputs.P
    typealias Left = P.Fix2.Right
    typealias Right = P.I.Right
}
#endif
#if LOCAL_PHASE_PREFIX_FOURTH_POINT3
enum RejectedSevenPrefixPoint3: Null {
    typealias P = SevenPrefixNamedInputs.P
    typealias Left = P.Fix3.Right
    typealias Right = P.I.Right
}
#endif
