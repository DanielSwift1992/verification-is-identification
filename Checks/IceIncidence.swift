import VerificationIsIdentification
import Examples

// The source has three measured directed edges and one reference edge.
// Each endpoint is an actual (vertex, slot), including the remote slot.
typealias IcePort<V: Structure, P: IntegerValued> = Paired<V, P>
typealias IceLeafData<V: Structure, W: Structure, A: Structure, B: Structure, C: Structure> = Paired<
    Paired<Paired<IcePort<A, Never>, IcePort<V, Never>>, Paired<IcePort<B, Never>, IcePort<V, Lit1>>>,
    Paired<Paired<IcePort<V, Two>, IcePort<C, Never>>, Paired<IcePort<V, Three>, IcePort<W, Never>>>
>
typealias IceReverseLeafData<V: Structure, W: Structure, A: Structure, B: Structure, C: Structure> = Paired<
    Paired<Paired<IcePort<V, Never>, IcePort<A, Never>>, Paired<IcePort<V, Lit1>, IcePort<B, Never>>>,
    Paired<Paired<IcePort<C, Never>, IcePort<V, Two>>, Paired<IcePort<V, Three>, IcePort<W, Never>>>
>

typealias IceRead00<G: Pair> = SequentialReading<FirstEvidenceImage<G, Never, Never, FirstProjection>, FirstEvidenceImage<G.Left, Never, Never, FirstProjection>>
where G.Left: Pair
typealias IceRead01<G: Pair> = SequentialReading<FirstEvidenceImage<G, Never, Never, FirstProjection>, SecondEvidenceImage<G.Left, Never, Never, SecondProjection>>
where G.Left: Pair
typealias IceRead10<G: Pair> = SequentialReading<SecondEvidenceImage<G, Never, Never, SecondProjection>, FirstEvidenceImage<G.Right, Never, Never, FirstProjection>>
where G.Right: Pair
typealias IceRead11<G: Pair> = SequentialReading<SecondEvidenceImage<G, Never, Never, SecondProjection>, SecondEvidenceImage<G.Right, Never, Never, SecondProjection>>
where G.Right: Pair

typealias IceFirstThree<V: Structure, W: Structure, A: Structure, B: Structure, C: Structure> = OutAtIcePort<
    IceRead10<IceLeafData<V, W, A, B, C>>,
    InAtIcePort<IceRead01<IceLeafData<V, W, A, B, C>>,
        InAtIcePort<IceRead00<IceLeafData<V, W, A, B, C>>, EmptyIcePorts<IceLeafData<V, W, A, B, C>, V, Never, Never>>>
>
typealias IceReverseFirstThree<V: Structure, W: Structure, A: Structure, B: Structure, C: Structure> = InAtIcePort<
    IceRead10<IceReverseLeafData<V, W, A, B, C>>,
    OutAtIcePort<IceRead01<IceReverseLeafData<V, W, A, B, C>>,
        OutAtIcePort<IceRead00<IceReverseLeafData<V, W, A, B, C>>, EmptyIcePorts<IceReverseLeafData<V, W, A, B, C>, V, Never, Never>>>
>
typealias IceForcedOut<V: Structure, W: Structure, A: Structure, B: Structure, C: Structure> = IceLeafOut<
    IceRead11<IceLeafData<V, W, A, B, C>>, IceFirstThree<V, W, A, B, C>
>
typealias IceForcedIn<V: Structure, W: Structure, A: Structure, B: Structure, C: Structure> = IceLeafIn<
    IceRead11<IceReverseLeafData<V, W, A, B, C>>, IceReverseFirstThree<V, W, A, B, C>
>

enum IceForcedEndsAreTheReference<V: Structure, W: Structure, A: Structure, B: Structure, C: Structure>: Null {
    typealias D = IceForcedOut<V, W, A, B, C>
    typealias Left = D.Answer
    typealias Right = D.ReferenceEdge
}
enum IceOppositePinsReverseTheSameEdge<V: Structure, W: Structure, A: Structure, B: Structure, C: Structure>: Null {
    typealias D = IceForcedOut<V, W, A, B, C>
    typealias Left = IceForcedIn<V, W, A, B, C>.Answer
    typealias Right = Paired<D.Answer.Right, D.Answer.Left>
}
enum IceCompletionHasFourActualPorts<V: Structure, W: Structure, A: Structure, B: Structure, C: Structure>: Null {
    typealias Left = IceForcedOut<V, W, A, B, C>.Completed.Next
    typealias Right = Examples.Succ<Three>
}
enum IceCompletionDerivesEqualCounts<V: Structure, W: Structure, A: Structure, B: Structure, C: Structure>: Null {
    typealias D = IceForcedOut<V, W, A, B, C>
    typealias Left = D.Completed.Word.InCount
    typealias Right = D.Completed.Word.OutCount
}

// The next vertex consumes the SAME inferred reading. Changing its source,
// endpoint or direction cannot serve as this propagation step.
typealias IceParentAfterLeaf<V: Structure, W: Structure, A: Structure, B: Structure, C: Structure> = InAtIcePort<
    IceForcedOut<V, W, A, B, C>, EmptyIcePorts<IceLeafData<V, W, A, B, C>, W, Never, Never>
>
typealias IceParentAfterReverseLeaf<V: Structure, W: Structure, A: Structure, B: Structure, C: Structure> = OutAtIcePort<
    IceForcedIn<V, W, A, B, C>, EmptyIcePorts<IceReverseLeafData<V, W, A, B, C>, W, Never, Never>
>
enum IceTransferRetainsTheActualInference<V: Structure, W: Structure, A: Structure, B: Structure, C: Structure>: Null {
    typealias Left = IceParentAfterLeaf<V, W, A, B, C>.Readings.Left
    typealias Right = IceForcedOut<V, W, A, B, C>
}
enum IceTransferUsesTheSameWhole<V: Structure, W: Structure, A: Structure, B: Structure, C: Structure>: Null {
    typealias Left = IceParentAfterLeaf<V, W, A, B, C>.Source
    typealias Right = IceForcedOut<V, W, A, B, C>.Completed.Source
}

typealias IceExampleSource = IceLeafData<Never, Lit1, Two, Three, Examples.Succ<Three>>
typealias IceExampleKnown = IceFirstThree<Never, Lit1, Two, Three, Examples.Succ<Three>>
typealias IceExampleInference = IceForcedOut<Never, Lit1, Two, Three, Examples.Succ<Three>>
typealias IceExampleEmpty = EmptyIcePorts<IceExampleSource, Never, Never, Never>

// A second leaf is resolved inside a larger whole. The first inference is
// lifted through the actual source projection, then supplies the parent's
// port 0. Its other measured ports are 1 and 2, and its remaining edge is 3.
typealias IceChainSource<Z: Structure, P: Structure, Q: Structure> = Paired<
    IceExampleSource,
    Paired<Paired<IcePort<P, Never>, IcePort<Lit1, Lit1>>,
        Paired<Paired<IcePort<Lit1, Two>, IcePort<Q, Never>>, Paired<IcePort<Lit1, Three>, IcePort<Z, Never>>>>
>
typealias IceFirstInferenceInChain<Z: Structure, P: Structure, Q: Structure> = SequentialReading<
    FirstEvidenceImage<IceChainSource<Z, P, Q>, Never, Never, FirstProjection>, IceExampleInference
>
typealias IceChainParentFields<Z: Structure, P: Structure, Q: Structure> = SecondEvidenceImage<IceChainSource<Z, P, Q>, Never, Never, SecondProjection>
typealias IceChainPin1<Z: Structure, P: Structure, Q: Structure> = SequentialReading<
    IceChainParentFields<Z, P, Q>, FirstEvidenceImage<IceChainSource<Z, P, Q>.Right, Never, Never, FirstProjection>
>
typealias IceChainLastFields<Z: Structure, P: Structure, Q: Structure> = SequentialReading<
    IceChainParentFields<Z, P, Q>, SecondEvidenceImage<IceChainSource<Z, P, Q>.Right, Never, Never, SecondProjection>
>
typealias IceChainPin2<Z: Structure, P: Structure, Q: Structure> = SequentialReading<
    IceChainLastFields<Z, P, Q>, FirstEvidenceImage<IceChainSource<Z, P, Q>.Right.Right, Never, Never, FirstProjection>
>
typealias IceChainReference<Z: Structure, P: Structure, Q: Structure> = SequentialReading<
    IceChainLastFields<Z, P, Q>, SecondEvidenceImage<IceChainSource<Z, P, Q>.Right.Right, Never, Never, SecondProjection>
>
typealias IceChainParentKnown<Z: Structure, P: Structure, Q: Structure> = OutAtIcePort<
    IceChainPin2<Z, P, Q>,
    InAtIcePort<IceChainPin1<Z, P, Q>,
        InAtIcePort<IceFirstInferenceInChain<Z, P, Q>, EmptyIcePorts<IceChainSource<Z, P, Q>, Lit1, Never, Never>>>
>
typealias IceSecondInferenceInChain<Z: Structure, P: Structure, Q: Structure> = IceLeafOut<IceChainReference<Z, P, Q>, IceChainParentKnown<Z, P, Q>>
enum IceTwoLeavesInferTheActualLastEdge<Z: Structure, P: Structure, Q: Structure>: Null {
    typealias Left = IceSecondInferenceInChain<Z, P, Q>.Answer
    typealias Right = Paired<IcePort<Lit1, Three>, IcePort<Z, Never>>
}
typealias IceChainGrandparent<Z: Structure, P: Structure, Q: Structure> = InAtIcePort<
    IceSecondInferenceInChain<Z, P, Q>, EmptyIcePorts<IceChainSource<Z, P, Q>, Z, Never, Never>
>
enum IceTwoLeavesRetainTheSameWhole<Z: Structure, P: Structure, Q: Structure>: Null {
    typealias Left = IceChainGrandparent<Z, P, Q>.Source
    typealias Right = IceFirstInferenceInChain<Z, P, Q>.Left
}

// A closed four-regular component: K5. The six measured leaf-to-leaf edges
// are stored ONCE. Four star edges are inferred. Slot names below make all
// twenty incidences explicit, including both uses of every measured edge.
typealias K5A = K5TakeVertexA.Address
typealias K5B = K5TakeVertexB.Address
typealias K5C = K5TakeVertexC.Address
typealias K5D = K5TakeVertexD.Address
typealias K5O = K5TakeVertexO.Address
typealias K5Pins = Paired<
    Paired<Paired<IcePort<K5A, Never>, IcePort<K5B, Never>>, Paired<IcePort<K5A, Lit1>, IcePort<K5C, Never>>>,
    Paired<Paired<Paired<IcePort<K5D, Never>, IcePort<K5A, Two>>, Paired<IcePort<K5B, Lit1>, IcePort<K5C, Lit1>>>,
        Paired<Paired<IcePort<K5B, Two>, IcePort<K5D, Lit1>>, Paired<IcePort<K5C, Two>, IcePort<K5D, Two>>>>
>
typealias K5References = Paired<
    Paired<Paired<IcePort<K5A, Three>, IcePort<K5O, Never>>, Paired<IcePort<K5B, Three>, IcePort<K5O, Lit1>>>,
    Paired<Paired<IcePort<K5C, Three>, IcePort<K5O, Two>>, Paired<IcePort<K5D, Three>, IcePort<K5O, Three>>>
>
typealias K5Source = Paired<K5Pins, K5References>
typealias K5ReadPins = FirstEvidenceImage<K5Source, Never, Never, FirstProjection>
typealias K5ReadLastPins = SequentialReading<K5ReadPins, SecondEvidenceImage<K5Pins, Never, Never, SecondProjection>>
typealias K5ReadReferences = SecondEvidenceImage<K5Source, Never, Never, SecondProjection>
typealias K5AB = SequentialReading<K5ReadPins, IceRead00<K5Pins>>
typealias K5AC = SequentialReading<K5ReadPins, IceRead01<K5Pins>>
typealias K5DA = SequentialReading<K5ReadLastPins, IceRead00<K5Pins.Right>>
typealias K5BC = SequentialReading<K5ReadLastPins, IceRead01<K5Pins.Right>>
typealias K5BD = SequentialReading<K5ReadLastPins, IceRead10<K5Pins.Right>>
typealias K5CD = SequentialReading<K5ReadLastPins, IceRead11<K5Pins.Right>>
typealias K5AO = SequentialReading<K5ReadReferences, IceRead00<K5References>>
typealias K5BO = SequentialReading<K5ReadReferences, IceRead01<K5References>>
typealias K5CO = SequentialReading<K5ReadReferences, IceRead10<K5References>>
typealias K5DO = SequentialReading<K5ReadReferences, IceRead11<K5References>>
typealias K5KnownA = InAtIcePort<K5DA, OutAtIcePort<K5AC, OutAtIcePort<K5AB, EmptyIcePorts<K5Source, K5A, Never, Never>>>>
typealias K5KnownB = OutAtIcePort<K5BD, OutAtIcePort<K5BC, InAtIcePort<K5AB, EmptyIcePorts<K5Source, K5B, Never, Never>>>>
typealias K5KnownC = OutAtIcePort<K5CD, InAtIcePort<K5BC, InAtIcePort<K5AC, EmptyIcePorts<K5Source, K5C, Never, Never>>>>
typealias K5KnownD = InAtIcePort<K5CD, InAtIcePort<K5BD, OutAtIcePort<K5DA, EmptyIcePorts<K5Source, K5D, Never, Never>>>>
typealias K5ForcedA = IceLeafIn<K5AO, K5KnownA>
typealias K5ForcedB = IceLeafIn<K5BO, K5KnownB>
typealias K5ForcedC = IceLeafOut<K5CO, K5KnownC>
typealias K5ForcedD = IceLeafOut<K5DO, K5KnownD>
typealias K5Root = InAtIcePort<K5ForcedD, InAtIcePort<K5ForcedC, OutAtIcePort<K5ForcedB, OutAtIcePort<K5ForcedA, EmptyIcePorts<K5Source, K5O, Never, Never>>>>>

// Source reconstruction and complete vertex balance are checked through
// the catalogue and removal constructors in IceCoverage.swift.

#if ICE_REPEATS_A_PORT
typealias RejectedIceRepeatedPort = InAtIcePort<IceRead00<IceExampleSource>, InAtIcePort<IceRead00<IceExampleSource>, IceExampleEmpty>>
#endif
#if ICE_USES_OTHER_SOURCE
typealias RejectedIceOtherSource = InAtIcePort<IceRead00<IceExampleSource>, EmptyIcePorts<Paired<IceExampleSource, Never>, Never, Never, Never>>
#endif
#if ICE_USES_OTHER_VERTEX
typealias RejectedIceOtherVertex = InAtIcePort<IceRead00<IceExampleSource>, EmptyIcePorts<IceExampleSource, Lit1, Never, Never>>
#endif
#if ICE_USES_OTHER_CONTEXT
typealias RejectedIceOtherContext = InAtIcePort<IceRead00<IceExampleSource>, EmptyIcePorts<IceExampleSource, Never, Lit1, Never>>
#endif
#if ICE_REVERSES_FORCED_DIRECTION
typealias RejectedIceWrongCompletion = IceLeafIn<IceRead11<IceExampleSource>, IceExampleKnown>
#endif
#if ICE_INFERS_WITH_TWO_PORTS
typealias RejectedIceMissingPort = IceLeafOut<IceRead11<IceExampleSource>, InAtIcePort<IceRead01<IceExampleSource>, InAtIcePort<IceRead00<IceExampleSource>, IceExampleEmpty>>>
#endif
#if ICE_USES_OTHER_REFERENCE_EDGE
typealias RejectedIceOtherReference = IceLeafOut<IceRead10<IceExampleSource>, IceExampleKnown>
#endif
#if ICE_PROPAGATES_SAME_LOCAL_DIRECTION
typealias RejectedIceSameLocalDirection = OutAtIcePort<IceExampleInference, EmptyIcePorts<IceExampleSource, Lit1, Never, Never>>
#endif
#if ICE_SHARED_EDGE_POINTS_OUT_AT_BOTH_ENDS
typealias RejectedIceDoubleOut = OutAtIcePort<K5AB, EmptyIcePorts<K5Source, K5B, Never, Never>>
#endif
#if ICE_ROOT_OMITS_A_LEAF
typealias RejectedIceUncoveredRootPort = OutAtIcePort<K5ForcedB, EmptyIcePorts<K5Source, K5O, Never, Never>>
#endif
