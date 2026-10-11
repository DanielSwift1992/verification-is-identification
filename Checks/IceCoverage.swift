import VerificationIsIdentification
import Examples

// Leaf presence belongs to the original CandidateNode conformance. Reading
// it through that protocol must not pick a later shadowing typealias.
enum CandidateNodeLeaf<N: CandidateNode>: Pair {
    typealias Left = N
    typealias Right = N.Leaf
}

enum EmptyPayloadDoesNotEraseLeaf<X>: Null {
    typealias Left = CandidateNodeLeaf<CandidateLeaf<X>>.Right
    typealias Right = CandidateLeaf<X>
}

enum ShadowLeafPayload: Close {}
extension CandidateLeaf where X == ShadowLeafPayload {
    typealias Leaf = Never
}

enum OriginalLeafConformanceDoesNotChange: Null {
    typealias Left = CandidateNodeLeaf<CandidateLeaf<ShadowLeafPayload>>.Right
    typealias Right = CandidateLeaf<ShadowLeafPayload>
}

// This graph has no leaf on any finite child path, but has infinite depth.
enum LeaflessSupportCycle: EmptyCandidateSupport {
    typealias Left = LeaflessSupportCycle
    typealias Right = LeaflessSupportCycle
    typealias Leaf = Never
}

typealias EmptyPayloadVertex = CandidateLeaf<Never>
typealias TwoEmptyPayloadVertices = CandidateFork<EmptyPayloadVertex, EmptyPayloadVertex>
typealias TakeFirstEmptyPayload = SelectCandidateLeft<SelectCandidateLeaf<Never>, EmptyPayloadVertex>
typealias AllocateFirstEmptyPayload = AllocateIceVertex<TwoEmptyPayloadVertices,
    TakeFirstEmptyPayload, Never, BeamSpace, SaturationEncoding>
typealias TakeSecondEmptyPayload = SelectCandidateRight<Never, SelectCandidateLeaf<Never>>
typealias AllocateSecondEmptyPayload = AllocateIceVertex<TwoEmptyPayloadVertices,
    TakeSecondEmptyPayload, AllocateFirstEmptyPayload.Answer.Right.Right, BeamSpace, SaturationEncoding>
typealias BothEmptyPayloadVerticesAllocated = AllocatedIcePorts<
    SequentialReading<AllocateFirstEmptyPayload, AllocateSecondEmptyPayload>>

enum FirstAllocationRetainsSecondOccurrence: Null {
    typealias Left = AllocateFirstEmptyPayload.Answer.Right.Left.Right
    typealias Right = EmptyPayloadVertex
}

#if ICE_EMPTY_PAYLOAD_LEAF_IS_EMPTY
extension CandidateLeaf: @retroactive EmptyCandidateSupport where X: EmptyCandidateSupport {}
typealias RejectedEmptyPayloadAllocation = AllocatedIcePorts<AllocateFirstEmptyPayload>
#endif

#if ICE_EMPTY_LEAF_ALIAS_OVERRIDE
extension CandidateLeaf where X == Never { public typealias Leaf = Never }
extension CandidateLeaf: @retroactive EmptyCandidateSupport where X == Never {}
typealias RejectedAliasedEmptyAllocation = AllocatedIcePorts<AllocateFirstEmptyPayload>
#endif

#if ICE_EMPTY_LEAF_WITNESS_OVERRIDE
extension CandidateLeaf: @retroactive EmptyCandidateSupport where X: EmptyCandidateSupport {
    public typealias Leaf = Never
}
typealias RejectedOverriddenEmptyAllocation = AllocatedIcePorts<AllocateFirstEmptyPayload>
#endif

#if ICE_CYCLIC_EMPTY_ERASES_LEAF
enum RejectedCyclicEmptyWithLeaf: EmptyCandidateSupport {
    typealias Left = CandidateLeaf<Never>
    typealias Right = RejectedCyclicEmptyWithLeaf
    typealias Leaf = Never
}
#endif

// Exhaustion does not identify an independently specified source graph.
// This source has two loops at four distinct ports of one vertex. Rewiring
// their heads preserves every port and both degree counts, but changes edges.
typealias IceBindingSource = Paired<Paired<IcePort<Never, Never>, IcePort<Never, Lit1>>, Paired<IcePort<Never, Two>, IcePort<Never, Three>>>
enum IceBindingRewiredFirst: PredicateReading {
    typealias Left = IceBindingSource
    typealias Right = RegroupDistanceLegs<IceBindingSource>.Right.Left
    typealias Answer = Right
    typealias Sigma = Never
    typealias Encoding = Never
    typealias Predicate = OperationSequence<FirstProjection, SecondProjection>
}
enum IceBindingRewiredSecond: PredicateReading {
    typealias Left = IceBindingSource
    typealias Right = RegroupDistanceLegs<IceBindingSource>.Right.Right
    typealias Answer = Right
    typealias Sigma = Never
    typealias Encoding = Never
    typealias Predicate = OperationSequence<SecondProjection, FirstProjection>
}
typealias IceBindingAllocation = AllocateIceVertex<CandidateLeaf<Never>, SelectCandidateLeaf<Never>, Never, Never, Never>
typealias IceBindingEdges = CandidateFork<CandidateLeaf<IceBindingRewiredFirst>, CandidateLeaf<IceBindingRewiredSecond>>
typealias IceBindingTakeFirst = SelectCandidateLeft<SelectCandidateLeaf<IceBindingEdges.Left.Left>, IceBindingEdges.Right>
typealias IceBindingTailFirst = SelectCandidateLeft<SelectCandidateLeft<SelectCandidateLeft<SelectCandidateLeaf<IceBindingAllocation.Answer.Right.Right.Left.Left.Left.Left>, IceBindingAllocation.Answer.Right.Right.Left.Left.Right>, IceBindingAllocation.Answer.Right.Right.Left.Right>, IceBindingAllocation.Answer.Right.Right.Right>
typealias IceBindingHeadFirst = SelectCandidateLeft<SelectCandidateRight<IceBindingTailFirst.Remainder.Left.Left, SelectCandidateRight<IceBindingTailFirst.Remainder.Left.Right.Left, SelectCandidateLeaf<IceBindingTailFirst.Remainder.Left.Right.Right.Left>>>, IceBindingTailFirst.Remainder.Right>
typealias IceBindingUseFirst = ConsumeIceEdge<IceBindingTakeFirst, IceBindingTailFirst, IceBindingHeadFirst>
typealias IceBindingTakeSecond = SelectCandidateRight<IceBindingUseFirst.Answer.Right.Left.Left, SelectCandidateLeaf<IceBindingUseFirst.Answer.Right.Left.Right.Left>>
typealias IceBindingTailSecond = SelectCandidateLeft<SelectCandidateRight<IceBindingUseFirst.Answer.Right.Right.Left.Left, SelectCandidateLeft<SelectCandidateLeaf<IceBindingUseFirst.Answer.Right.Right.Left.Right.Left.Left>, IceBindingUseFirst.Answer.Right.Right.Left.Right.Right>>, IceBindingUseFirst.Answer.Right.Right.Right>
typealias IceBindingHeadSecond = SelectCandidateLeft<SelectCandidateLeft<SelectCandidateRight<IceBindingTailSecond.Remainder.Left.Left.Left, SelectCandidateLeaf<IceBindingTailSecond.Remainder.Left.Left.Right.Left>>, IceBindingTailSecond.Remainder.Left.Right>, IceBindingTailSecond.Remainder.Right>
typealias IceBindingUseSecond = ConsumeIceEdge<IceBindingTakeSecond, IceBindingTailSecond, IceBindingHeadSecond>
typealias IceBindingClosed = ExhaustedIceIncidence<IceBindingAllocation, SequentialReading<IceBindingUseFirst, IceBindingUseSecond>>
enum IceRewiredCoverageKeepsItsActualSource: Null {
    typealias Left = IceBindingClosed.Answer.Left
    typealias Right = IceBindingSource
}
#if ICE_COVERAGE_IMPLIES_ORIGINAL_GRAPH
enum RejectedIceCoverageAsSourceGraph: Null {
    typealias Left = Paired<IceBindingRewiredFirst.Answer, IceBindingRewiredSecond.Answer>
    typealias Right = IceBindingSource
}
#endif


// Payloads repeat, but selected declaration POSITIONS are different vertices.
typealias K5VertexDeclaration = CandidateFork<CandidateLeaf<Never>, CandidateFork<CandidateLeaf<Never>, CandidateFork<CandidateLeaf<Never>, CandidateFork<CandidateLeaf<Never>, CandidateLeaf<Never>>>>>
typealias K5TakeVertexA = SelectCandidateLeft<SelectCandidateLeaf<K5VertexDeclaration.Left.Left>, K5VertexDeclaration.Right>
typealias K5AllocateA = AllocateIceVertex<K5VertexDeclaration, K5TakeVertexA, Never, Never, Never>
typealias K5TakeVertexB = SelectCandidateRight<K5AllocateA.Answer.Right.Left.Left, SelectCandidateLeft<SelectCandidateLeaf<K5AllocateA.Answer.Right.Left.Right.Left.Left>, K5AllocateA.Answer.Right.Left.Right.Right>>
typealias K5AllocateB = AllocateIceVertex<K5VertexDeclaration, K5TakeVertexB, K5AllocateA.Answer.Right.Right, Never, Never>
typealias K5TakeVertexC = SelectCandidateRight<K5AllocateB.Answer.Right.Left.Left, SelectCandidateRight<K5AllocateB.Answer.Right.Left.Right.Left, SelectCandidateLeft<SelectCandidateLeaf<K5AllocateB.Answer.Right.Left.Right.Right.Left.Left>, K5AllocateB.Answer.Right.Left.Right.Right.Right>>>
typealias K5AllocateC = AllocateIceVertex<K5VertexDeclaration, K5TakeVertexC, K5AllocateB.Answer.Right.Right, Never, Never>
typealias K5TakeVertexD = SelectCandidateRight<K5AllocateC.Answer.Right.Left.Left, SelectCandidateRight<K5AllocateC.Answer.Right.Left.Right.Left, SelectCandidateRight<K5AllocateC.Answer.Right.Left.Right.Right.Left, SelectCandidateLeft<SelectCandidateLeaf<K5AllocateC.Answer.Right.Left.Right.Right.Right.Left.Left>, K5AllocateC.Answer.Right.Left.Right.Right.Right.Right>>>>
typealias K5AllocateD = AllocateIceVertex<K5VertexDeclaration, K5TakeVertexD, K5AllocateC.Answer.Right.Right, Never, Never>
typealias K5TakeVertexO = SelectCandidateRight<K5AllocateD.Answer.Right.Left.Left, SelectCandidateRight<K5AllocateD.Answer.Right.Left.Right.Left, SelectCandidateRight<K5AllocateD.Answer.Right.Left.Right.Right.Left, SelectCandidateRight<K5AllocateD.Answer.Right.Left.Right.Right.Right.Left, SelectCandidateLeaf<K5AllocateD.Answer.Right.Left.Right.Right.Right.Right.Left>>>>>
typealias K5AllocateO = AllocateIceVertex<K5VertexDeclaration, K5TakeVertexO, K5AllocateD.Answer.Right.Right, Never, Never>
typealias K5VertexAllocation = AllocatedIcePorts<SequentialReading<SequentialReading<SequentialReading<SequentialReading<K5AllocateA, K5AllocateB>, K5AllocateC>, K5AllocateD>, K5AllocateO>>

// These are the actual six pin readings and four completion readings.
typealias K5PinCatalogue = JoinIceCatalogue<
    JoinIceCatalogue<MeasuredIceEdge<K5AB>, MeasuredIceEdge<K5AC>>,
    JoinIceCatalogue<JoinIceCatalogue<MeasuredIceEdge<K5DA>, MeasuredIceEdge<K5BC>>, JoinIceCatalogue<MeasuredIceEdge<K5BD>, MeasuredIceEdge<K5CD>>>
>
typealias K5ReferenceCatalogue = JoinIceCatalogue<JoinIceCatalogue<K5ForcedA.Catalogue, K5ForcedB.Catalogue>, JoinIceCatalogue<K5ForcedC.Catalogue, K5ForcedD.Catalogue>>
typealias K5BoundCatalogue = SourceIceCatalogue<K5PinCatalogue, K5ReferenceCatalogue>
typealias K5EdgeDeclaration = K5BoundCatalogue.Edges

typealias K5TakeEdgeAB = SelectCandidateLeft<SelectCandidateLeft<SelectCandidateLeft<SelectCandidateLeaf<K5EdgeDeclaration.Left.Left.Left.Left>, K5EdgeDeclaration.Left.Left.Right>, K5EdgeDeclaration.Left.Right>, K5EdgeDeclaration.Right>
typealias K5TakeTailAB = SelectCandidateRight<K5VertexAllocation.Answer.Right.Right.Left, SelectCandidateRight<K5VertexAllocation.Answer.Right.Right.Right.Left, SelectCandidateRight<K5VertexAllocation.Answer.Right.Right.Right.Right.Left, SelectCandidateRight<K5VertexAllocation.Answer.Right.Right.Right.Right.Right.Left, SelectCandidateLeft<SelectCandidateLeft<SelectCandidateLeft<SelectCandidateLeaf<K5VertexAllocation.Answer.Right.Right.Right.Right.Right.Right.Left.Left.Left.Left>, K5VertexAllocation.Answer.Right.Right.Right.Right.Right.Right.Left.Left.Right>, K5VertexAllocation.Answer.Right.Right.Right.Right.Right.Right.Left.Right>, K5VertexAllocation.Answer.Right.Right.Right.Right.Right.Right.Right>>>>>
typealias K5TakeHeadAB = SelectCandidateRight<K5TakeTailAB.Remainder.Left, SelectCandidateRight<K5TakeTailAB.Remainder.Right.Left, SelectCandidateRight<K5TakeTailAB.Remainder.Right.Right.Left, SelectCandidateLeft<SelectCandidateLeft<SelectCandidateLeft<SelectCandidateLeaf<K5TakeTailAB.Remainder.Right.Right.Right.Left.Left.Left.Left>, K5TakeTailAB.Remainder.Right.Right.Right.Left.Left.Right>, K5TakeTailAB.Remainder.Right.Right.Right.Left.Right>, K5TakeTailAB.Remainder.Right.Right.Right.Right>>>>
typealias K5ConsumeAB = ConsumeIceEdge<K5TakeEdgeAB, K5TakeTailAB, K5TakeHeadAB>
typealias K5TakeEdgeAC = SelectCandidateLeft<SelectCandidateLeft<SelectCandidateRight<K5ConsumeAB.Answer.Right.Left.Left.Left.Left, SelectCandidateLeaf<K5ConsumeAB.Answer.Right.Left.Left.Left.Right.Left>>, K5ConsumeAB.Answer.Right.Left.Left.Right>, K5ConsumeAB.Answer.Right.Left.Right>
typealias K5TakeTailAC = SelectCandidateRight<K5ConsumeAB.Answer.Right.Right.Left, SelectCandidateRight<K5ConsumeAB.Answer.Right.Right.Right.Left, SelectCandidateRight<K5ConsumeAB.Answer.Right.Right.Right.Right.Left, SelectCandidateRight<K5ConsumeAB.Answer.Right.Right.Right.Right.Right.Left, SelectCandidateLeft<SelectCandidateLeft<SelectCandidateRight<K5ConsumeAB.Answer.Right.Right.Right.Right.Right.Right.Left.Left.Left, SelectCandidateLeaf<K5ConsumeAB.Answer.Right.Right.Right.Right.Right.Right.Left.Left.Right.Left>>, K5ConsumeAB.Answer.Right.Right.Right.Right.Right.Right.Left.Right>, K5ConsumeAB.Answer.Right.Right.Right.Right.Right.Right.Right>>>>>
typealias K5TakeHeadAC = SelectCandidateRight<K5TakeTailAC.Remainder.Left, SelectCandidateRight<K5TakeTailAC.Remainder.Right.Left, SelectCandidateLeft<SelectCandidateLeft<SelectCandidateLeft<SelectCandidateLeaf<K5TakeTailAC.Remainder.Right.Right.Left.Left.Left.Left>, K5TakeTailAC.Remainder.Right.Right.Left.Left.Right>, K5TakeTailAC.Remainder.Right.Right.Left.Right>, K5TakeTailAC.Remainder.Right.Right.Right>>>
typealias K5ConsumeAC = ConsumeIceEdge<K5TakeEdgeAC, K5TakeTailAC, K5TakeHeadAC>
typealias K5TakeEdgeDA = SelectCandidateLeft<SelectCandidateRight<K5ConsumeAC.Answer.Right.Left.Left.Left, SelectCandidateLeft<SelectCandidateLeft<SelectCandidateLeaf<K5ConsumeAC.Answer.Right.Left.Left.Right.Left.Left.Left>, K5ConsumeAC.Answer.Right.Left.Left.Right.Left.Right>, K5ConsumeAC.Answer.Right.Left.Left.Right.Right>>, K5ConsumeAC.Answer.Right.Left.Right>
typealias K5TakeTailDA = SelectCandidateRight<K5ConsumeAC.Answer.Right.Right.Left, SelectCandidateLeft<SelectCandidateLeft<SelectCandidateLeft<SelectCandidateLeaf<K5ConsumeAC.Answer.Right.Right.Right.Left.Left.Left.Left>, K5ConsumeAC.Answer.Right.Right.Right.Left.Left.Right>, K5ConsumeAC.Answer.Right.Right.Right.Left.Right>, K5ConsumeAC.Answer.Right.Right.Right.Right>>
typealias K5TakeHeadDA = SelectCandidateRight<K5TakeTailDA.Remainder.Left, SelectCandidateRight<K5TakeTailDA.Remainder.Right.Left, SelectCandidateRight<K5TakeTailDA.Remainder.Right.Right.Left, SelectCandidateRight<K5TakeTailDA.Remainder.Right.Right.Right.Left, SelectCandidateLeft<SelectCandidateRight<K5TakeTailDA.Remainder.Right.Right.Right.Right.Left.Left, SelectCandidateLeft<SelectCandidateLeaf<K5TakeTailDA.Remainder.Right.Right.Right.Right.Left.Right.Left.Left>, K5TakeTailDA.Remainder.Right.Right.Right.Right.Left.Right.Right>>, K5TakeTailDA.Remainder.Right.Right.Right.Right.Right>>>>>
typealias K5ConsumeDA = ConsumeIceEdge<K5TakeEdgeDA, K5TakeTailDA, K5TakeHeadDA>
typealias K5TakeEdgeBC = SelectCandidateLeft<SelectCandidateRight<K5ConsumeDA.Answer.Right.Left.Left.Left, SelectCandidateLeft<SelectCandidateRight<K5ConsumeDA.Answer.Right.Left.Left.Right.Left.Left, SelectCandidateLeaf<K5ConsumeDA.Answer.Right.Left.Left.Right.Left.Right.Left>>, K5ConsumeDA.Answer.Right.Left.Left.Right.Right>>, K5ConsumeDA.Answer.Right.Left.Right>
typealias K5TakeTailBC = SelectCandidateRight<K5ConsumeDA.Answer.Right.Right.Left, SelectCandidateRight<K5ConsumeDA.Answer.Right.Right.Right.Left, SelectCandidateRight<K5ConsumeDA.Answer.Right.Right.Right.Right.Left, SelectCandidateLeft<SelectCandidateLeft<SelectCandidateRight<K5ConsumeDA.Answer.Right.Right.Right.Right.Right.Left.Left.Left, SelectCandidateLeaf<K5ConsumeDA.Answer.Right.Right.Right.Right.Right.Left.Left.Right.Left>>, K5ConsumeDA.Answer.Right.Right.Right.Right.Right.Left.Right>, K5ConsumeDA.Answer.Right.Right.Right.Right.Right.Right>>>>
typealias K5TakeHeadBC = SelectCandidateRight<K5TakeTailBC.Remainder.Left, SelectCandidateRight<K5TakeTailBC.Remainder.Right.Left, SelectCandidateLeft<SelectCandidateLeft<SelectCandidateRight<K5TakeTailBC.Remainder.Right.Right.Left.Left.Left, SelectCandidateLeaf<K5TakeTailBC.Remainder.Right.Right.Left.Left.Right.Left>>, K5TakeTailBC.Remainder.Right.Right.Left.Right>, K5TakeTailBC.Remainder.Right.Right.Right>>>
typealias K5ConsumeBC = ConsumeIceEdge<K5TakeEdgeBC, K5TakeTailBC, K5TakeHeadBC>
typealias K5TakeEdgeBD = SelectCandidateLeft<SelectCandidateRight<K5ConsumeBC.Answer.Right.Left.Left.Left, SelectCandidateRight<K5ConsumeBC.Answer.Right.Left.Left.Right.Left, SelectCandidateLeft<SelectCandidateLeaf<K5ConsumeBC.Answer.Right.Left.Left.Right.Right.Left.Left>, K5ConsumeBC.Answer.Right.Left.Left.Right.Right.Right>>>, K5ConsumeBC.Answer.Right.Left.Right>
typealias K5TakeTailBD = SelectCandidateRight<K5ConsumeBC.Answer.Right.Right.Left, SelectCandidateRight<K5ConsumeBC.Answer.Right.Right.Right.Left, SelectCandidateRight<K5ConsumeBC.Answer.Right.Right.Right.Right.Left, SelectCandidateLeft<SelectCandidateRight<K5ConsumeBC.Answer.Right.Right.Right.Right.Right.Left.Left, SelectCandidateLeft<SelectCandidateLeaf<K5ConsumeBC.Answer.Right.Right.Right.Right.Right.Left.Right.Left.Left>, K5ConsumeBC.Answer.Right.Right.Right.Right.Right.Left.Right.Right>>, K5ConsumeBC.Answer.Right.Right.Right.Right.Right.Right>>>>
typealias K5TakeHeadBD = SelectCandidateRight<K5TakeTailBD.Remainder.Left, SelectCandidateLeft<SelectCandidateLeft<SelectCandidateRight<K5TakeTailBD.Remainder.Right.Left.Left.Left, SelectCandidateLeaf<K5TakeTailBD.Remainder.Right.Left.Left.Right.Left>>, K5TakeTailBD.Remainder.Right.Left.Right>, K5TakeTailBD.Remainder.Right.Right>>
typealias K5ConsumeBD = ConsumeIceEdge<K5TakeEdgeBD, K5TakeTailBD, K5TakeHeadBD>
typealias K5TakeEdgeCD = SelectCandidateLeft<SelectCandidateRight<K5ConsumeBD.Answer.Right.Left.Left.Left, SelectCandidateRight<K5ConsumeBD.Answer.Right.Left.Left.Right.Left, SelectCandidateRight<K5ConsumeBD.Answer.Right.Left.Left.Right.Right.Left, SelectCandidateLeaf<K5ConsumeBD.Answer.Right.Left.Left.Right.Right.Right.Left>>>>, K5ConsumeBD.Answer.Right.Left.Right>
typealias K5TakeTailCD = SelectCandidateRight<K5ConsumeBD.Answer.Right.Right.Left, SelectCandidateRight<K5ConsumeBD.Answer.Right.Right.Right.Left, SelectCandidateLeft<SelectCandidateRight<K5ConsumeBD.Answer.Right.Right.Right.Right.Left.Left, SelectCandidateLeft<SelectCandidateLeaf<K5ConsumeBD.Answer.Right.Right.Right.Right.Left.Right.Left.Left>, K5ConsumeBD.Answer.Right.Right.Right.Right.Left.Right.Right>>, K5ConsumeBD.Answer.Right.Right.Right.Right.Right>>>
typealias K5TakeHeadCD = SelectCandidateRight<K5TakeTailCD.Remainder.Left, SelectCandidateLeft<SelectCandidateRight<K5TakeTailCD.Remainder.Right.Left.Left, SelectCandidateLeft<SelectCandidateLeaf<K5TakeTailCD.Remainder.Right.Left.Right.Left.Left>, K5TakeTailCD.Remainder.Right.Left.Right.Right>>, K5TakeTailCD.Remainder.Right.Right>>
typealias K5ConsumeCD = ConsumeIceEdge<K5TakeEdgeCD, K5TakeTailCD, K5TakeHeadCD>
typealias K5TakeEdgeAO = SelectCandidateRight<K5ConsumeCD.Answer.Right.Left.Left, SelectCandidateLeft<SelectCandidateLeft<SelectCandidateLeaf<K5ConsumeCD.Answer.Right.Left.Right.Left.Left.Left>, K5ConsumeCD.Answer.Right.Left.Right.Left.Right>, K5ConsumeCD.Answer.Right.Left.Right.Right>>
typealias K5TakeTailAO = SelectCandidateLeft<SelectCandidateLeft<SelectCandidateLeft<SelectCandidateLeaf<K5ConsumeCD.Answer.Right.Right.Left.Left.Left.Left>, K5ConsumeCD.Answer.Right.Right.Left.Left.Right>, K5ConsumeCD.Answer.Right.Right.Left.Right>, K5ConsumeCD.Answer.Right.Right.Right>
typealias K5TakeHeadAO = SelectCandidateRight<K5TakeTailAO.Remainder.Left, SelectCandidateRight<K5TakeTailAO.Remainder.Right.Left, SelectCandidateRight<K5TakeTailAO.Remainder.Right.Right.Left, SelectCandidateRight<K5TakeTailAO.Remainder.Right.Right.Right.Left, SelectCandidateLeft<SelectCandidateRight<K5TakeTailAO.Remainder.Right.Right.Right.Right.Left.Left, SelectCandidateRight<K5TakeTailAO.Remainder.Right.Right.Right.Right.Left.Right.Left, SelectCandidateLeaf<K5TakeTailAO.Remainder.Right.Right.Right.Right.Left.Right.Right.Left>>>, K5TakeTailAO.Remainder.Right.Right.Right.Right.Right>>>>>
typealias K5ConsumeAO = ConsumeIceEdge<K5TakeEdgeAO, K5TakeTailAO, K5TakeHeadAO>
typealias K5TakeEdgeBO = SelectCandidateRight<K5ConsumeAO.Answer.Right.Left.Left, SelectCandidateLeft<SelectCandidateRight<K5ConsumeAO.Answer.Right.Left.Right.Left.Left, SelectCandidateLeaf<K5ConsumeAO.Answer.Right.Left.Right.Left.Right.Left>>, K5ConsumeAO.Answer.Right.Left.Right.Right>>
typealias K5TakeTailBO = SelectCandidateLeft<SelectCandidateLeft<SelectCandidateRight<K5ConsumeAO.Answer.Right.Right.Left.Left.Left, SelectCandidateLeaf<K5ConsumeAO.Answer.Right.Right.Left.Left.Right.Left>>, K5ConsumeAO.Answer.Right.Right.Left.Right>, K5ConsumeAO.Answer.Right.Right.Right>
typealias K5TakeHeadBO = SelectCandidateRight<K5TakeTailBO.Remainder.Left, SelectCandidateRight<K5TakeTailBO.Remainder.Right.Left, SelectCandidateRight<K5TakeTailBO.Remainder.Right.Right.Left, SelectCandidateLeft<SelectCandidateRight<K5TakeTailBO.Remainder.Right.Right.Right.Left.Left, SelectCandidateRight<K5TakeTailBO.Remainder.Right.Right.Right.Left.Right.Left, SelectCandidateLeaf<K5TakeTailBO.Remainder.Right.Right.Right.Left.Right.Right.Left>>>, K5TakeTailBO.Remainder.Right.Right.Right.Right>>>>
typealias K5ConsumeBO = ConsumeIceEdge<K5TakeEdgeBO, K5TakeTailBO, K5TakeHeadBO>
typealias K5TakeEdgeCO = SelectCandidateRight<K5ConsumeBO.Answer.Right.Left.Left, SelectCandidateRight<K5ConsumeBO.Answer.Right.Left.Right.Left, SelectCandidateLeft<SelectCandidateLeaf<K5ConsumeBO.Answer.Right.Left.Right.Right.Left.Left>, K5ConsumeBO.Answer.Right.Left.Right.Right.Right>>>
typealias K5TakeTailCO = SelectCandidateRight<K5ConsumeBO.Answer.Right.Right.Left, SelectCandidateRight<K5ConsumeBO.Answer.Right.Right.Right.Left, SelectCandidateLeft<SelectCandidateRight<K5ConsumeBO.Answer.Right.Right.Right.Right.Left.Left, SelectCandidateRight<K5ConsumeBO.Answer.Right.Right.Right.Right.Left.Right.Left, SelectCandidateLeaf<K5ConsumeBO.Answer.Right.Right.Right.Right.Left.Right.Right.Left>>>, K5ConsumeBO.Answer.Right.Right.Right.Right.Right>>>
typealias K5TakeHeadCO = SelectCandidateLeft<SelectCandidateRight<K5TakeTailCO.Remainder.Left.Left, SelectCandidateLeft<SelectCandidateLeaf<K5TakeTailCO.Remainder.Left.Right.Left.Left>, K5TakeTailCO.Remainder.Left.Right.Right>>, K5TakeTailCO.Remainder.Right>
typealias K5ConsumeCO = ConsumeIceEdge<K5TakeEdgeCO, K5TakeTailCO, K5TakeHeadCO>
typealias K5TakeEdgeDO = SelectCandidateRight<K5ConsumeCO.Answer.Right.Left.Left, SelectCandidateRight<K5ConsumeCO.Answer.Right.Left.Right.Left, SelectCandidateRight<K5ConsumeCO.Answer.Right.Left.Right.Right.Left, SelectCandidateLeaf<K5ConsumeCO.Answer.Right.Left.Right.Right.Right.Left>>>>
typealias K5TakeTailDO = SelectCandidateRight<K5ConsumeCO.Answer.Right.Right.Left, SelectCandidateLeft<SelectCandidateRight<K5ConsumeCO.Answer.Right.Right.Right.Left.Left, SelectCandidateRight<K5ConsumeCO.Answer.Right.Right.Right.Left.Right.Left, SelectCandidateLeaf<K5ConsumeCO.Answer.Right.Right.Right.Left.Right.Right.Left>>>, K5ConsumeCO.Answer.Right.Right.Right.Right>>
typealias K5TakeHeadDO = SelectCandidateLeft<SelectCandidateRight<K5TakeTailDO.Remainder.Left.Left, SelectCandidateRight<K5TakeTailDO.Remainder.Left.Right.Left, SelectCandidateLeaf<K5TakeTailDO.Remainder.Left.Right.Right.Left>>>, K5TakeTailDO.Remainder.Right>
typealias K5ConsumeDO = ConsumeIceEdge<K5TakeEdgeDO, K5TakeTailDO, K5TakeHeadDO>
typealias K5IncidenceSequence = SequentialReading<SequentialReading<SequentialReading<SequentialReading<SequentialReading<SequentialReading<SequentialReading<SequentialReading<SequentialReading<K5ConsumeAB, K5ConsumeAC>, K5ConsumeDA>, K5ConsumeBC>, K5ConsumeBD>, K5ConsumeCD>, K5ConsumeAO>, K5ConsumeBO>, K5ConsumeCO>, K5ConsumeDO>
typealias K5WholeIncidence = DeclaredIceIncidence<K5VertexAllocation, K5IncidenceSequence, K5PinCatalogue, K5ReferenceCatalogue>

enum K5CoverageRetainsTheActualSource: Null {
    typealias Left = K5WholeIncidence.Answer.Left
    typealias Right = K5Source
}
enum K5CoverageStartsAtTheDeclaredEdges: Null {
    typealias Left = K5WholeIncidence.Left.Right.Left
    typealias Right = K5EdgeDeclaration
}
enum K5CoverageStartsAtTheAllocatedPorts: Null {
    typealias Left = K5WholeIncidence.Left.Right.Right
    typealias Right = K5VertexAllocation.Answer.Right.Right
}

enum K5RepeatedVertexPayloadsStillAgree: Null {
    typealias Left = K5TakeVertexA.Right
    typealias Right = K5TakeVertexB.Right
}
enum CandidateAddressSurvivesRemovalOfSibling<X, Y>: Null {
    typealias Left = SelectCandidateRight<CandidateLeaf<X>, SelectCandidateLeaf<Y>>.Address
    typealias Right = SelectCandidateRight<Never, SelectCandidateLeaf<Y>>.Address
}

#if ICE_COVERAGE_MERGES_EQUAL_PAYLOADS
enum RejectedIceMergedVertexAddresses: Null {
    typealias Left = K5A
    typealias Right = K5B
}
#endif
#if ICE_COVERAGE_OMITS_VERTEX
typealias RejectedIceUnallocatedVertex = AllocatedIcePorts<SequentialReading<SequentialReading<SequentialReading<K5AllocateA, K5AllocateB>, K5AllocateC>, K5AllocateD>>
#endif
#if ICE_COVERAGE_STARTS_WITH_EXTRA_PORT
typealias RejectedIceUnallocatedExtraPort = AllocatedIcePorts<AllocateIceVertex<CandidateLeaf<Never>, SelectCandidateLeaf<Never>, CandidateLeaf<Paired<Never, Never>>, Never, Never>>
#endif
#if ICE_COVERAGE_REUSES_VERTEX
typealias RejectedIceVertexReuse = SequentialReading<K5AllocateA, AllocateIceVertex<K5VertexDeclaration, K5TakeVertexA, K5AllocateA.Answer.Right.Right, Never, Never>>
#endif
#if ICE_COVERAGE_TAKES_OTHER_EDGE
typealias RejectedIceOtherEdgeOccurrence = ConsumeIceEdge<K5TakeEdgeAC, K5TakeTailAB, K5TakeHeadAB>
#endif
#if ICE_COVERAGE_REUSES_TAIL_AS_HEAD
typealias RejectedIceTailReusedAsHead = ConsumeIceEdge<K5TakeEdgeAB, K5TakeTailAB, K5TakeTailAB>
#endif
#if ICE_COVERAGE_OMITS_EDGES
typealias RejectedIceUnconsumedEdges = ExhaustedIceIncidence<K5VertexAllocation, K5ConsumeAB>
#endif
#if ICE_COVERAGE_SUBSTITUTES_PORTS
typealias RejectedIceOtherPortAllocation = ExhaustedIceIncidence<AllocateIceVertex<CandidateLeaf<Never>, SelectCandidateLeaf<Never>, Never, Never, Never>, K5IncidenceSequence>
#endif
#if ICE_COVERAGE_CHANGES_CONTEXT
typealias IceOtherAllocateA = AllocateIceVertex<K5VertexDeclaration, K5TakeVertexA, Never, Lit1, Never>
typealias IceOtherAllocateB = AllocateIceVertex<K5VertexDeclaration, K5TakeVertexB, K5AllocateA.Answer.Right.Right, Lit1, Never>
typealias IceOtherAllocateC = AllocateIceVertex<K5VertexDeclaration, K5TakeVertexC, K5AllocateB.Answer.Right.Right, Lit1, Never>
typealias IceOtherAllocateD = AllocateIceVertex<K5VertexDeclaration, K5TakeVertexD, K5AllocateC.Answer.Right.Right, Lit1, Never>
typealias IceOtherAllocateO = AllocateIceVertex<K5VertexDeclaration, K5TakeVertexO, K5AllocateD.Answer.Right.Right, Lit1, Never>
typealias IceOtherAllocation = SequentialReading<SequentialReading<SequentialReading<SequentialReading<IceOtherAllocateA, IceOtherAllocateB>, IceOtherAllocateC>, IceOtherAllocateD>, IceOtherAllocateO>
typealias RejectedIceCoverageContext = ExhaustedIceIncidence<IceOtherAllocation, K5IncidenceSequence>
#endif

// The empty graph is covered by identity composition, without an edge step.
typealias IceEmptySource = Paired<Never, Never>
typealias IceEmptyCatalogue = EmptyIceCatalogue<IceEmptySource, Never, Never>
typealias IceEmptyAllocation = IdentityReading<Paired<Never, Paired<Never, Never>>, Never, Never>
typealias IceEmptyConsumption = IdentityReading<Paired<IceEmptySource, Paired<CandidateFork<Never, Never>, Never>>, Never, Never>
typealias IceEmptyDeclaredIncidence = DeclaredIceIncidence<IceEmptyAllocation, IceEmptyConsumption, IceEmptyCatalogue, IceEmptyCatalogue>

// This reverse is a valid orientation of the SAME edge, but cannot replace
// its measured pin. The positive binding separates geometry from evidence.
enum IceOppositeDirection<R: PredicateReading>: PredicateReading
where R.Left: Structure, R.Answer: Pair, R.Answer.Left: Structure, R.Answer.Right: Structure {
    typealias Left = R.Left
    typealias Right = ReverseIceReference<R.Answer>.Right
    typealias Answer = Right
    typealias Sigma = R.Sigma
    typealias Encoding = R.Encoding
    typealias Predicate = IceDirectionQuestion<R.Answer>
}
typealias K5ReversedPin = IceOppositeDirection<K5AB>
typealias K5ReversedPinBinding = IceCatalogueEdge<K5ReversedPin, K5AB, ReverseIceReference<K5AB.Answer>>
typealias K5ChangedPinCatalogue = JoinIceCatalogue<JoinIceCatalogue<K5ReversedPinBinding, MeasuredIceEdge<K5AC>>, JoinIceCatalogue<JoinIceCatalogue<MeasuredIceEdge<K5DA>, MeasuredIceEdge<K5BC>>, JoinIceCatalogue<MeasuredIceEdge<K5BD>, MeasuredIceEdge<K5CD>>>>

typealias IceBindingOriginalFirst = FirstEvidenceImage<IceBindingSource, Never, Never, FirstProjection>
#if ICE_BINDING_REWIRES_FORWARD
typealias RejectedIceRewiredForward = IceCatalogueEdge<IceBindingRewiredFirst, IceBindingOriginalFirst, ForwardIceReference<IceBindingOriginalFirst.Answer>>
#endif
#if ICE_BINDING_REWIRES_REVERSE
typealias RejectedIceRewiredReverse = IceCatalogueEdge<IceBindingRewiredFirst, IceBindingOriginalFirst, ReverseIceReference<IceBindingOriginalFirst.Answer>>
#endif
#if ICE_BINDING_CHANGES_MEASURED_PIN
typealias RejectedIceChangedPin = SourceIceCatalogue<K5ChangedPinCatalogue, K5ReferenceCatalogue>
#endif
#if ICE_BINDING_OMITS_REFERENCE
typealias RejectedIceMissingReference = SourceIceCatalogue<K5PinCatalogue, K5ForcedA.Catalogue>
#endif
#if ICE_BINDING_REORDERS_REFERENCE
typealias K5ReorderedReferences = JoinIceCatalogue<JoinIceCatalogue<K5ForcedB.Catalogue, K5ForcedA.Catalogue>, JoinIceCatalogue<K5ForcedC.Catalogue, K5ForcedD.Catalogue>>
typealias RejectedIceReorderedReference = SourceIceCatalogue<K5PinCatalogue, K5ReorderedReferences>
#endif
#if ICE_BINDING_USES_OTHER_CONTEXT
typealias IceBindingOtherContext = FirstEvidenceImage<IceBindingSource, Lit1, Never, FirstProjection>
typealias RejectedIceReferenceContext = IceCatalogueEdge<IceBindingOriginalFirst, IceBindingOtherContext, ForwardIceReference<IceBindingOriginalFirst.Answer>>
#endif
#if ICE_BINDING_SPENDS_ANOTHER_CATALOGUE
typealias K5ReacquiredPin = SequentialReading<K5AB, IdentityReading<K5AB.Answer, Never, Never>>
typealias K5OtherApplications = JoinIceCatalogue<JoinIceCatalogue<MeasuredIceEdge<K5ReacquiredPin>, MeasuredIceEdge<K5AC>>, JoinIceCatalogue<JoinIceCatalogue<MeasuredIceEdge<K5DA>, MeasuredIceEdge<K5BC>>, JoinIceCatalogue<MeasuredIceEdge<K5BD>, MeasuredIceEdge<K5CD>>>>
typealias K5OtherValidCatalogue = SourceIceCatalogue<K5OtherApplications, K5ReferenceCatalogue>
typealias RejectedIceOtherApplications = DeclaredIceIncidence<K5VertexAllocation, K5IncidenceSequence, K5OtherApplications, K5ReferenceCatalogue>
#endif

// Exhaust the independently bound residual catalogue by removing endpoints.
typealias K5ForestEdgeA = SelectCandidateLeft<SelectCandidateLeft<SelectCandidateLeaf<K5ReferenceCatalogue.ReferenceEdges.Left.Left.Left>, K5ReferenceCatalogue.ReferenceEdges.Left.Right>, K5ReferenceCatalogue.ReferenceEdges.Right>
typealias K5ForestVertexA = SelectCandidateLeft<SelectCandidateLeaf<K5VertexDeclaration.Left.Left>, K5VertexDeclaration.Right>
typealias K5ForestNeighborA = SelectCandidateRight<K5ForestVertexA.Remainder.Left, SelectCandidateRight<K5ForestVertexA.Remainder.Right.Left, SelectCandidateRight<K5ForestVertexA.Remainder.Right.Right.Left, SelectCandidateRight<K5ForestVertexA.Remainder.Right.Right.Right.Left, SelectCandidateLeaf<K5ForestVertexA.Remainder.Right.Right.Right.Right.Left>>>>>
typealias K5ForestA = RemoveIceForestEndpoint<K5ForestEdgeA, ForwardIceReference<K5ForestEdgeA.Right>, K5ForestVertexA, K5ForestNeighborA, Never, Never>
typealias K5ForestEdgeB = SelectCandidateLeft<SelectCandidateRight<K5ForestA.Answer.Left.Left.Left, SelectCandidateLeaf<K5ForestA.Answer.Left.Left.Right.Left>>, K5ForestA.Answer.Left.Right>
typealias K5ForestVertexB = SelectCandidateRight<K5ForestA.Answer.Right.Left, SelectCandidateLeft<SelectCandidateLeaf<K5ForestA.Answer.Right.Right.Left.Left>, K5ForestA.Answer.Right.Right.Right>>
typealias K5ForestNeighborB = SelectCandidateRight<K5ForestVertexB.Remainder.Left, SelectCandidateRight<K5ForestVertexB.Remainder.Right.Left, SelectCandidateRight<K5ForestVertexB.Remainder.Right.Right.Left, SelectCandidateRight<K5ForestVertexB.Remainder.Right.Right.Right.Left, SelectCandidateLeaf<K5ForestVertexB.Remainder.Right.Right.Right.Right.Left>>>>>
typealias K5ForestB = RemoveIceForestEndpoint<K5ForestEdgeB, ForwardIceReference<K5ForestEdgeB.Right>, K5ForestVertexB, K5ForestNeighborB, Never, Never>
typealias K5ForestEdgeC = SelectCandidateRight<K5ForestB.Answer.Left.Left, SelectCandidateLeft<SelectCandidateLeaf<K5ForestB.Answer.Left.Right.Left.Left>, K5ForestB.Answer.Left.Right.Right>>
typealias K5ForestVertexC = SelectCandidateRight<K5ForestB.Answer.Right.Left, SelectCandidateRight<K5ForestB.Answer.Right.Right.Left, SelectCandidateLeft<SelectCandidateLeaf<K5ForestB.Answer.Right.Right.Right.Left.Left>, K5ForestB.Answer.Right.Right.Right.Right>>>
typealias K5ForestNeighborC = SelectCandidateRight<K5ForestVertexC.Remainder.Left, SelectCandidateRight<K5ForestVertexC.Remainder.Right.Left, SelectCandidateRight<K5ForestVertexC.Remainder.Right.Right.Left, SelectCandidateRight<K5ForestVertexC.Remainder.Right.Right.Right.Left, SelectCandidateLeaf<K5ForestVertexC.Remainder.Right.Right.Right.Right.Left>>>>>
typealias K5ForestC = RemoveIceForestEndpoint<K5ForestEdgeC, ForwardIceReference<K5ForestEdgeC.Right>, K5ForestVertexC, K5ForestNeighborC, Never, Never>
typealias K5ForestEdgeD = SelectCandidateRight<K5ForestC.Answer.Left.Left, SelectCandidateRight<K5ForestC.Answer.Left.Right.Left, SelectCandidateLeaf<K5ForestC.Answer.Left.Right.Right.Left>>>
typealias K5ForestVertexD = SelectCandidateRight<K5ForestC.Answer.Right.Left, SelectCandidateRight<K5ForestC.Answer.Right.Right.Left, SelectCandidateRight<K5ForestC.Answer.Right.Right.Right.Left, SelectCandidateLeft<SelectCandidateLeaf<K5ForestC.Answer.Right.Right.Right.Right.Left.Left>, K5ForestC.Answer.Right.Right.Right.Right.Right>>>>
typealias K5ForestNeighborD = SelectCandidateRight<K5ForestVertexD.Remainder.Left, SelectCandidateRight<K5ForestVertexD.Remainder.Right.Left, SelectCandidateRight<K5ForestVertexD.Remainder.Right.Right.Left, SelectCandidateRight<K5ForestVertexD.Remainder.Right.Right.Right.Left, SelectCandidateLeaf<K5ForestVertexD.Remainder.Right.Right.Right.Right.Left>>>>>
typealias K5ForestD = RemoveIceForestEndpoint<K5ForestEdgeD, ForwardIceReference<K5ForestEdgeD.Right>, K5ForestVertexD, K5ForestNeighborD, Never, Never>
typealias K5ForestSequence = SequentialReading<SequentialReading<SequentialReading<K5ForestA, K5ForestB>, K5ForestC>, K5ForestD>
typealias K5ResidualForest = ResidualIceForest<K5VertexDeclaration, K5ReferenceCatalogue, K5ForestSequence>
enum K5ForestLeavesExactlyTheOriginalRootPosition: Null {
    typealias Left = K5ResidualForest.Answer.Right
    typealias Right = K5TakeVertexO.Left
}
typealias IceEmptyForestSequence = IdentityReading<Paired<Never, Never>, Never, Never>
typealias IceEmptyForest = ResidualIceForest<Never, IceEmptyCatalogue, IceEmptyForestSequence>

#if ICE_FOREST_OMITS_EDGE
typealias RejectedIceUnfinishedForest = ResidualIceForest<K5VertexDeclaration, K5ReferenceCatalogue, SequentialReading<SequentialReading<K5ForestA, K5ForestB>, K5ForestC>>
#endif
#if ICE_FOREST_REMOVES_BOTH_ENDPOINTS
typealias RejectedIceAbsentSurvivingEndpoint = RemoveIceForestEndpoint<K5ForestEdgeA, ForwardIceReference<K5AO.Answer>, K5ForestVertexA, K5ForestVertexA, Never, Never>
#endif
#if ICE_FOREST_ACCEPTS_LOOP
typealias RejectedIceForestLoop = RemoveIceForestEndpoint<SelectCandidateLeaf<IceBindingSource.Left>, ForwardIceReference<IceBindingSource.Left>, SelectCandidateLeaf<Never>, SelectCandidateLeaf<Never>, Never, Never>
#endif

// Removing the star's internal root is an admissible PREFIX. Its other
// edges then lose an endpoint, so it cannot certify the complete forest.
typealias K5PrematureRoot = SelectCandidateRight<K5VertexDeclaration.Left, SelectCandidateRight<K5VertexDeclaration.Right.Left, SelectCandidateRight<K5VertexDeclaration.Right.Right.Left, SelectCandidateRight<K5VertexDeclaration.Right.Right.Right.Left, SelectCandidateLeaf<K5VertexDeclaration.Right.Right.Right.Right.Left>>>>>
typealias K5PrematureNeighbor = SelectCandidateLeft<SelectCandidateLeaf<K5PrematureRoot.Remainder.Left.Left>, K5PrematureRoot.Remainder.Right>
typealias K5PrematureRemoval = RemoveIceForestEndpoint<K5ForestEdgeA, ReverseIceReference<K5AO.Answer>, K5PrematureRoot, K5PrematureNeighbor, Never, Never>
#if ICE_FOREST_REUSES_REMOVED_VERTEX
typealias K5StrandedEdgeB = SelectCandidateLeft<SelectCandidateRight<K5PrematureRemoval.Answer.Left.Left.Left, SelectCandidateLeaf<K5PrematureRemoval.Answer.Left.Left.Right.Left>>, K5PrematureRemoval.Answer.Left.Right>
typealias K5StrandedVertexB = SelectCandidateRight<K5PrematureRemoval.Answer.Right.Left, SelectCandidateLeft<SelectCandidateLeaf<K5PrematureRemoval.Answer.Right.Right.Left.Left>, K5PrematureRemoval.Answer.Right.Right.Right>>
typealias K5MissingNeighbor = SelectCandidateRight<K5StrandedVertexB.Remainder.Left, SelectCandidateRight<K5StrandedVertexB.Remainder.Right.Left, SelectCandidateRight<K5StrandedVertexB.Remainder.Right.Right.Left, SelectCandidateRight<K5StrandedVertexB.Remainder.Right.Right.Right.Left, SelectCandidateLeaf<K5StrandedVertexB.Remainder.Right.Right.Right.Right.Left>>>>>
typealias RejectedIceStrandedEdge = RemoveIceForestEndpoint<K5StrandedEdgeB, ForwardIceReference<K5BO.Answer>, K5StrandedVertexB, K5MissingNeighbor, Never, Never>
#endif

// Reuse these actual catalogue readings at both ends; do not consume facts.
typealias K5CatalogueAB = SelectCandidateLeft<SelectCandidateLeft<SelectCandidateLeft<SelectCandidateLeaf<K5BoundCatalogue.Edges.Left.Left.Left.Left>, K5BoundCatalogue.Edges.Left.Left.Right>, K5BoundCatalogue.Edges.Left.Right>, K5BoundCatalogue.Edges.Right>
typealias K5CatalogueAC = SelectCandidateLeft<SelectCandidateLeft<SelectCandidateRight<K5BoundCatalogue.Edges.Left.Left.Left, SelectCandidateLeaf<K5BoundCatalogue.Edges.Left.Left.Right.Left>>, K5BoundCatalogue.Edges.Left.Right>, K5BoundCatalogue.Edges.Right>
typealias K5CatalogueDA = SelectCandidateLeft<SelectCandidateRight<K5BoundCatalogue.Edges.Left.Left, SelectCandidateLeft<SelectCandidateLeft<SelectCandidateLeaf<K5BoundCatalogue.Edges.Left.Right.Left.Left.Left>, K5BoundCatalogue.Edges.Left.Right.Left.Right>, K5BoundCatalogue.Edges.Left.Right.Right>>, K5BoundCatalogue.Edges.Right>
typealias K5CatalogueBC = SelectCandidateLeft<SelectCandidateRight<K5BoundCatalogue.Edges.Left.Left, SelectCandidateLeft<SelectCandidateRight<K5BoundCatalogue.Edges.Left.Right.Left.Left, SelectCandidateLeaf<K5BoundCatalogue.Edges.Left.Right.Left.Right.Left>>, K5BoundCatalogue.Edges.Left.Right.Right>>, K5BoundCatalogue.Edges.Right>
typealias K5CatalogueBD = SelectCandidateLeft<SelectCandidateRight<K5BoundCatalogue.Edges.Left.Left, SelectCandidateRight<K5BoundCatalogue.Edges.Left.Right.Left, SelectCandidateLeft<SelectCandidateLeaf<K5BoundCatalogue.Edges.Left.Right.Right.Left.Left>, K5BoundCatalogue.Edges.Left.Right.Right.Right>>>, K5BoundCatalogue.Edges.Right>
typealias K5CatalogueCD = SelectCandidateLeft<SelectCandidateRight<K5BoundCatalogue.Edges.Left.Left, SelectCandidateRight<K5BoundCatalogue.Edges.Left.Right.Left, SelectCandidateRight<K5BoundCatalogue.Edges.Left.Right.Right.Left, SelectCandidateLeaf<K5BoundCatalogue.Edges.Left.Right.Right.Right.Left>>>>, K5BoundCatalogue.Edges.Right>
typealias K5CatalogueAO = SelectCandidateRight<K5BoundCatalogue.Edges.Left, SelectCandidateLeft<SelectCandidateLeft<SelectCandidateLeaf<K5BoundCatalogue.Edges.Right.Left.Left.Left>, K5BoundCatalogue.Edges.Right.Left.Right>, K5BoundCatalogue.Edges.Right.Right>>
typealias K5CatalogueBO = SelectCandidateRight<K5BoundCatalogue.Edges.Left, SelectCandidateLeft<SelectCandidateRight<K5BoundCatalogue.Edges.Right.Left.Left, SelectCandidateLeaf<K5BoundCatalogue.Edges.Right.Left.Right.Left>>, K5BoundCatalogue.Edges.Right.Right>>
typealias K5CatalogueCO = SelectCandidateRight<K5BoundCatalogue.Edges.Left, SelectCandidateRight<K5BoundCatalogue.Edges.Right.Left, SelectCandidateLeft<SelectCandidateLeaf<K5BoundCatalogue.Edges.Right.Right.Left.Left>, K5BoundCatalogue.Edges.Right.Right.Right>>>
typealias K5CatalogueDO = SelectCandidateRight<K5BoundCatalogue.Edges.Left, SelectCandidateRight<K5BoundCatalogue.Edges.Right.Left, SelectCandidateRight<K5BoundCatalogue.Edges.Right.Right.Left, SelectCandidateLeaf<K5BoundCatalogue.Edges.Right.Right.Right.Left>>>>
typealias K5BalanceA = CheckIceVertex<K5BoundCatalogue, K5ForcedA.Completed, K5TakeVertexA, K5CatalogueAB, K5CatalogueAC, K5CatalogueDA, K5CatalogueAO>
typealias K5BalanceB = CheckIceVertex<K5BoundCatalogue, K5ForcedB.Completed, K5TakeVertexB, K5CatalogueAB, K5CatalogueBC, K5CatalogueBD, K5CatalogueBO>
typealias K5BalanceC = CheckIceVertex<K5BoundCatalogue, K5ForcedC.Completed, K5TakeVertexC, K5CatalogueAC, K5CatalogueBC, K5CatalogueCD, K5CatalogueCO>
typealias K5BalanceD = CheckIceVertex<K5BoundCatalogue, K5ForcedD.Completed, K5TakeVertexD, K5CatalogueDA, K5CatalogueBD, K5CatalogueCD, K5CatalogueDO>
typealias K5BalanceO = CheckIceVertex<K5BoundCatalogue, K5Root, K5TakeVertexO, K5CatalogueAO, K5CatalogueBO, K5CatalogueCO, K5CatalogueDO>
typealias K5BalanceSequence = SequentialReading<SequentialReading<SequentialReading<SequentialReading<K5BalanceA, K5BalanceB>, K5BalanceC>, K5BalanceD>, K5BalanceO>
typealias K5AllBalances = BalancedIceCatalogue<K5VertexDeclaration, K5BoundCatalogue, K5BalanceSequence>
typealias K5StaticCompletionCertificate = Paired<K5WholeIncidence, Paired<K5AllBalances, K5ResidualForest>>
typealias IceEmptyBalanceSequence = IdentityReading<Paired<IceEmptySource, Never>, Never, Never>
typealias IceEmptyBalance = BalancedIceCatalogue<Never, IceEmptyCatalogue, IceEmptyBalanceSequence>

// Reversing all four readings preserves this local balance and its source,
// but disagrees with the directions actually stored in the global catalogue.
typealias K5OppositeA = OutAtIcePort<IceOppositeDirection<K5ForcedA>, OutAtIcePort<IceOppositeDirection<K5DA>, InAtIcePort<IceOppositeDirection<K5AC>, InAtIcePort<IceOppositeDirection<K5AB>, EmptyIcePorts<K5Source, K5A, Never, Never>>>>>
typealias K5OppositeARule = Survivor<K5OppositeA.Word>
#if ICE_BALANCE_USES_OTHER_ORIENTATIONS
typealias RejectedIceOtherLocalDirections = CheckIceVertex<K5BoundCatalogue, K5OppositeA, K5TakeVertexA, K5CatalogueAB, K5CatalogueAC, K5CatalogueDA, K5CatalogueAO>
#endif
#if ICE_BALANCE_OMITS_VERTEX
typealias RejectedIceUncoveredBalance = BalancedIceCatalogue<K5VertexDeclaration, K5BoundCatalogue, SequentialReading<SequentialReading<SequentialReading<K5BalanceA, K5BalanceB>, K5BalanceC>, K5BalanceD>>
#endif
#if ICE_BALANCE_USES_OTHER_VERTEX
typealias RejectedIceOtherBalanceVertex = CheckIceVertex<K5BoundCatalogue, K5ForcedA.Completed, K5TakeVertexB, K5CatalogueAB, K5CatalogueAC, K5CatalogueDA, K5CatalogueAO>
#endif

// A uniform geometry certificate is literally reusable across new pin
// values and direction readings. Whole-source equality is not a premise.
enum IceForestDependsOnlyOnReferenceTopology<V: Pair, L: IceCatalogue, R: IceCatalogue, F: PredicateReading>: Null
where L.ReferenceEdges == R.ReferenceEdges, L.Sigma == R.Sigma, L.Encoding == R.Encoding,
      F.Left == Paired<L.ReferenceEdges, V>, F.Sigma == L.Sigma, F.Encoding == L.Encoding,
      F.Answer: Pair, F.Answer.Left: EmptyCandidateSupport {
    typealias Left = ResidualIceForest<V, L, F>
    typealias Right = ResidualIceForest<V, R, F>
}
#if ICE_FOREST_CHANGES_CONTEXT
typealias RejectedIceForestContext = ResidualIceForest<Never, EmptyIceCatalogue<IceEmptySource, Lit1, Never>, IceEmptyForestSequence>
#endif
#if ICE_FOREST_SUBSTITUTES_TOPOLOGY
typealias RejectedIceOtherForestTopology = ResidualIceForest<K5VertexDeclaration, K5PinCatalogue, K5ForestSequence>
#endif
