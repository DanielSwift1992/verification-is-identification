import VerificationIsIdentification
import Examples

// Both counters come from the finite In/Out constructors. In-count alone
// formerly admitted short and long expressions as four-bond ice vertices.
enum IceVertexHasBalancedCounts<V: IceVertex>: Null {
    typealias Left = V.InCount
    typealias Right = V.OutCount
}
typealias ValidIceCounts = IceVertexHasBalancedCounts<In<Out<In<Out<Vacuum>>>>>

#if MARKER_ICE_ACCEPTS_TWO_BONDS
typealias RejectedShortIceVertex = Survivor<In<In<Vacuum>>>
#endif

#if MARKER_ICE_ACCEPTS_FIVE_BONDS
typealias RejectedLongIceVertex = Survivor<In<In<Out<Out<Out<Vacuum>>>>>>
#endif

#if MARKER_ICE_ACCEPTS_THREE_IN
typealias RejectedUnbalancedIceVertex = Survivor<In<In<In<Out<Vacuum>>>>>
#endif

// A recorded research boundary: the current StructuresFinite protocol accepts
// a nonterminal cycle. Successful compilation is evidence of that limitation,
// not evidence that the following type denotes a finite tree.
enum UnboundedLeft: StructuresFinite, OperationsClosed {
    typealias Left = UnboundedLeft
    typealias Right = Never
    typealias Sigma = UnboundedLeft
}

// A bounded alternative can state its floor explicitly. These experimental
// claims live here, not in the public lattice: two levels do not settle an
// arbitrary depth. Neither marker uses a self-referential depth witness.
protocol FloorWithinOne: Pair where Left == Never, Right == Never {}
protocol FloorWithinTwo: Pair where Left: FloorWithinOne, Right: FloorWithinOne {}
extension Never: FloorWithinOne {}

enum OneLevel: FloorWithinOne {
    typealias Left = Never
    typealias Right = Never
}

enum TwoLevels: FloorWithinTwo {
    typealias Left = OneLevel
    typealias Right = Never
}

#if BAD_LEFT_FLOOR
enum RejectedLeftCycle: FloorWithinOne {
    typealias Left = RejectedLeftCycle
    typealias Right = Never
}
#endif

// A generic budget step actually yields its predecessor. Iterating over a
// finite Never/Succ expression stops by induction on that expression.
enum BudgetStepUsesPredecessor<P: IntegerValued>: Null {
    typealias Left = SpendSuccessor<P>.Right
    typealias Right = SpendSuccessor<P>.Left.Right
}

enum SuccessiveBudgetStepsMatch<P: IntegerValued>: Null {
    typealias Left = SpendSuccessor<VerificationIsIdentification.Succ<P>>.Right
    typealias Right = SpendSuccessor<P>.Left
}

enum FinalBudgetStepReachesFloor: Null {
    typealias Left = SpendSuccessor<Never>.Right
    typealias Right = Never
}

// The open numeral protocol itself still admits a nonterminal cycle.
enum CyclicNumeral: IntegerValued {
    typealias Left = Never
    typealias Right = CyclicNumeral
}

#if BUDGET_DID_NOT_DECREASE
enum RejectedUnchangedBudget: Null {
    typealias Left = SpendSuccessor<VerificationIsIdentification.Succ<Never>>.Right
    typealias Right = SpendSuccessor<VerificationIsIdentification.Succ<Never>>.Left
}
#endif

#if BUDGET_SPENDS_ZERO
enum RejectedZeroBudgetStep: Null {
    typealias Left = SpendSuccessor<Never>.Left
    typealias Right = Never
}
#endif

#if BAD_RIGHT_FLOOR
enum RejectedRightCycle: FloorWithinOne {
    typealias Left = Never
    typealias Right = RejectedRightCycle
}
#endif
