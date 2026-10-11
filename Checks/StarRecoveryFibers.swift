import VerificationIsIdentification
import Examples

enum StarRecoveryEdge {
    typealias Edge = Paired<FourLeafAddressRoot.Select0.Address, FourLeafAddressRoot.Select1.Address>
    typealias P = StarContactPredecessors<Paired<Edge, FourLeafAddressProgram>>
}

enum StarRecoverySameOutputRetainsTheEdge: Null {
    typealias P = StarRecoveryEdge.P
    typealias Left = Paired<P.From0.Answer, P.From1.Answer>
    typealias Right = Paired<P.Center, P.Center>
}

enum StarRecoveryDifferentSourceQuestion: Null {
    typealias P = StarRecoveryEdge.P
    typealias Left = Paired<P.From0.Left.Left.Right.Left.Left, P.From1.Left.Left.Right.Left.Left>
    typealias Right = Paired<Lit1, Never>
}

enum StarRecoveryMergedAddressInputs<C: Structure>: Null {
    typealias Collision = MergedStarAddressInput<Paired<StarRecoveryEdge.Edge, FourLeafAddressProgram>, C>
    typealias Left = Collision.Left
    typealias Right = Collision.Right
}

#if LOCAL_PHASE_MERGED_STAR_ADDRESS_RECOVERS_BOTH
enum RejectedMergedStarInverse: Null {
    typealias P = StarRecoveryEdge.P
    // Both inverse applications have the same current source. A common
    // decoded address cannot make these distinct required source answers one.
    typealias Left = P.To0.Answer
    typealias Right = P.To1.Answer
}
#endif
