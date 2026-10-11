import VerificationIsIdentification
import Examples

enum JointPhaseQuestionActions: Null {
    typealias Q = JointPhaseQuestions<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11, RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11>
    typealias Left = Paired<Q.WDistributes.Left, Q.ZDistributes.Left>
    typealias Right = Paired<Q.WDistributes.Right, Q.ZDistributes.Right>
}

// Each separate word is admissible. Their independently valid outputs do
// not represent the two questions under the same W action on the common input.
#if LOCAL_PHASE_JOINT_QUESTIONS_MIX_ACTIONS
enum RejectedJointQuestionMixedActions: Null {
    typealias Q = JointPhaseQuestionActions.Q
    typealias Mixed = ZipFourQuestions<
        Q.WX.Right.Left.Left, Q.WX.Right.Left.Right, Q.WX.Right.Right.Left, Q.WX.Right.Right.Right,
        Q.ZY.Right.Left.Left, Q.ZY.Right.Left.Right, Q.ZY.Right.Right.Left, Q.ZY.Right.Right.Right>
    typealias Left = Mixed.Right
    typealias Right = Q.WBoth.Right
}
#endif
