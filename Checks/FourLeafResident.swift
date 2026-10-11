import VerificationIsIdentification
import Examples

enum FourLeafResidentReadsTheLeaf<K: Structure>: Null {
    typealias R0 = FourLeafStageAddress<FourLeafSelected0<K>.Answer, FourLeafMarked0>
    typealias R1 = FourLeafStageAddress<FourLeafSelected1<K>.Answer, FourLeafMarked1>
    typealias R2 = FourLeafStageAddress<FourLeafSelected2<K>.Answer, FourLeafMarked2>
    typealias R3 = FourLeafStageAddress<FourLeafSelected3<K>.Answer, FourLeafMarked3>
    typealias Left = BoundaryWorking<R0.Answer, R1.Answer, R2.Answer, R3.Answer>
    typealias Right = IdentityRouting
}

enum FourLeafOneVisibleQuestion<K: Structure>: Null {
    typealias Q = OperationSequence<OperationSequence<FirstProjection, SecondProjection>, MarkedPositionQuestion>
    typealias Left = BoundaryWorking<
        FourLeafStageAddress<FourLeafSelected0<K>.Answer, FourLeafMarked0>.Predicate,
        FourLeafStageAddress<FourLeafSelected1<K>.Answer, FourLeafMarked1>.Predicate,
        FourLeafStageAddress<FourLeafSelected2<K>.Answer, FourLeafMarked2>.Predicate,
        FourLeafStageAddress<FourLeafSelected3<K>.Answer, FourLeafMarked3>.Predicate>
    typealias Right = BoundaryWorking<Q, Q, Q, Q>
}

// Arbitrarily different whole contexts yield exactly the same visible fact
// after the same marked leaf. No law address or source type is in its payload.
enum FourLeafFactForgetsHiddenContext<K: Structure, T: Structure>: Null {
    typealias Left = FactOf<FourLeafStageAddress<FourLeafSelected0<K>.Answer, FourLeafMarked0>>
    typealias Right = FactOf<FourLeafStageAddress<FourLeafSelected0<T>.Answer, FourLeafMarked0>>
}

enum FourLeafControlIsCarried<K: Structure>: Null {
    typealias R = FourLeafResidentInput<FourLeafMarked2, Paired<FourLeafAddressProgram, K>>
    typealias Left = R.Answer
    typealias Right = Paired<RoutingAddress10, R.Left.Right.Right.Left>
}

#if LOCAL_PHASE_RESIDENT_WRONG_TABLE_ROW
enum RejectedFourLeafResidentRow: Pair {
    typealias K = Paired<FourLeafAddressProgram, Never>
    typealias Root = FourLeafResidentRoot<Lit1, Never, Never, Never, K>
    typealias Wrong = SelectedLocalApplication<Root,
        FourLeafResidentInput<FourLeafMarked0, K>, Route01<FourLeafAddressProgram>, Root.Select1>
    typealias Left = Wrong.Left
    typealias Right = Wrong.Answer
}
#endif

#if LOCAL_PHASE_RESIDENT_READS_PHASE_AS_STAGE
enum RejectedFourLeafPhaseForStage: Pair {
    // U from phase 0 arrives at leaf 0 and phase 1. These are different axes.
    typealias Wrong = FourLeafStageAddress<FourLeafSelected0<Never>.Answer, FourLeafMarked1>
    typealias Left = Wrong.Left
    typealias Right = Wrong.Answer
}
#endif
