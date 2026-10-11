import VerificationIsIdentification

/// The two orientations retain both ports of this very reference pair.
public typealias IceReferenceDirections<E: Pair> = CandidateFork<
    CandidateLeaf<E>, CandidateLeaf<Paired<E.Right, E.Left>>
>
where E.Left: Structure, E.Right: Structure
public typealias ForwardIceReference<E: Pair> = SelectCandidateLeft<
    SelectCandidateLeaf<E>, CandidateLeaf<Paired<E.Right, E.Left>>
>
where E.Left: Structure, E.Right: Structure
public typealias ReverseIceReference<E: Pair> = SelectCandidateRight<
    CandidateLeaf<E>, SelectCandidateLeaf<Paired<E.Right, E.Left>>
>
where E.Left: Structure, E.Right: Structure

/// A finite catalogue retains the original fields, directed fields and
/// actual readings in the same tree shape. The constructors supply coverage.
public protocol IceCatalogue: HasEncoding {
    associatedtype Source: Structure
    associatedtype References: Structure
    associatedtype Directions: Structure
    associatedtype Edges: Pair
    associatedtype ReferenceEdges: Pair
}

/// Bind the actual direction R to a selection from M's two orientations.
/// Matching only their whole source would still permit rewiring endpoints.
public enum IceCatalogueEdge<R: PredicateReading, M: PredicateReading, P: CandidateRemoval>: IceCatalogue
where R.Left: Structure, R.Left == M.Left,
      R.Sigma == M.Sigma, R.Encoding == M.Encoding, M.Answer: Pair,
      M.Answer.Left: Structure, M.Answer.Right: Structure, R.Answer: Pair, P.Right: Pair,
      P.Left == IceReferenceDirections<M.Answer>,
      P.Right.Left == R.Answer.Left, P.Right.Right == R.Answer.Right {
    public typealias Source = R.Left
    public typealias References = M.Answer
    public typealias Directions = R.Answer
    public typealias Edges = CandidateLeaf<R>
    public typealias ReferenceEdges = CandidateLeaf<M.Answer>
    public typealias Sigma = R.Sigma
    public typealias Encoding = R.Encoding
}

/// A measured pair keeps its actual direction; it supplies no free choice.
public typealias MeasuredIceEdge<R: PredicateReading> = IceCatalogueEdge<R, R, ForwardIceReference<R.Answer>>
where R.Left: Structure, R.Answer: Pair, R.Answer.Left: Structure, R.Answer.Right: Structure

public enum EmptyIceCatalogue<G: Structure, S, E>: IceCatalogue {
    public typealias Source = G
    public typealias References = Never
    public typealias Directions = Never
    public typealias Edges = Never
    public typealias ReferenceEdges = Never
    public typealias Sigma = S
    public typealias Encoding = E
}

public enum JoinIceCatalogue<L: IceCatalogue, R: IceCatalogue>: IceCatalogue
where L.Source == R.Source, L.Sigma == R.Sigma, L.Encoding == R.Encoding {
    public typealias Source = L.Source
    public typealias References = Paired<L.References, R.References>
    public typealias Directions = Paired<L.Directions, R.Directions>
    public typealias Edges = CandidateFork<L.Edges, R.Edges>
    public typealias ReferenceEdges = CandidateFork<L.ReferenceEdges, R.ReferenceEdges>
    public typealias Sigma = L.Sigma
    public typealias Encoding = L.Encoding
}

/// Cover the original two source branches and retain all measured pins.
/// This binding can be checked before an incidence allocation is supplied.
public typealias SourceIceCatalogue<P: IceCatalogue, U: IceCatalogue> = JoinIceCatalogue<P, U>
where P.Source == U.Source, P.Sigma == U.Sigma, P.Encoding == U.Encoding,
      P.Source == Paired<P.References, U.References>, P.Directions == P.References

/// Four different slots at one vertex address, using the existing support
/// tree. Vertex addresses below come from actual declaration positions.
public typealias FourIcePorts<V: Structure> = CandidateFork<
    CandidateFork<CandidateLeaf<Paired<V, Never>>, CandidateLeaf<Paired<V, Lit1>>>,
    CandidateFork<CandidateLeaf<Paired<V, Two>>, CandidateLeaf<Paired<V, Three>>>
>

/// Remove one vertex occurrence and allocate its four addressed ports.
/// Finite sequences starting with an empty port inventory allocate every
/// selected position once. Repeated vertex payloads do not repeat addresses.
/// The original declaration stays beside the remaining obligations.
public enum AllocateIceVertex<V: Pair, P: CandidateRemoval, Ports: Pair, S, E>: PredicateReading {
    public typealias Left = Paired<V, Paired<P.Left, Ports>>
    public typealias Right = Paired<V, Paired<P.Remainder, CandidateFork<FourIcePorts<P.Address>, Ports>>>
    public typealias Sigma = S
    public typealias Encoding = E
    public typealias Predicate = P.Address
    public typealias Answer = Right
}

/// Keep the actual allocation sequence while requiring empty initial ports
/// and no unallocated vertex at its end. Constructor grammar is essential.
public typealias AllocatedIcePorts<C: PredicateReading> = C
where C.Left: Pair, C.Left.Right: Pair,
      C.Left.Left == C.Left.Right.Left, C.Left.Right.Right == Never,
      C.Answer: Pair, C.Answer.Right: Pair,
      C.Answer.Left == C.Left.Left, C.Answer.Right.Left: EmptyCandidateSupport

/// Consume one declared edge reading and its actual tail and head ports.
/// The next step receives BOTH remainders and the same retained source.
/// Geometry, edge occurrence and port occurrence cannot be replaced by a
/// count. The edge catalogue itself still needs its declaration binding.
public enum ConsumeIceEdge<E: CandidateRemoval, T: CandidateRemoval, H: CandidateRemoval>: PredicateReading
where E.Right: PredicateReading, E.Right.Left: Structure, E.Right.Answer: Pair,
      T.Right == E.Right.Answer.Left, H.Right == E.Right.Answer.Right,
      H.Left == T.Remainder {
    public typealias Left = Paired<E.Right.Left, Paired<E.Left, T.Left>>
    public typealias Right = Paired<E.Right.Left, Paired<E.Remainder, H.Remainder>>
    public typealias Sigma = E.Right.Sigma
    public typealias Encoding = E.Right.Encoding
    public typealias Predicate = OperationSequence<E.Right.Predicate, Paired<E.Address, Paired<T.Address, H.Address>>>
    public typealias Answer = Right
}

/// Exhaust both inventories, retaining the source of the actual readings.
/// This accepts the original sequence rather than introducing a global
/// graph marker. Use finite ConsumeIceEdge/SequentialReading expressions.
public typealias ExhaustedIceIncidence<A: PredicateReading, C: PredicateReading> = C
where A.Left: Pair, A.Left.Right: Pair,
      A.Sigma == C.Sigma, A.Encoding == C.Encoding,
      A.Left.Left == A.Left.Right.Left, A.Left.Right.Right == Never,
      A.Answer: Pair, A.Answer.Right: Pair,
      A.Answer.Left == A.Left.Left, A.Answer.Right.Left: EmptyCandidateSupport,
      C.Left: Pair, C.Left.Right: Pair,
      C.Left.Right.Right == A.Answer.Right.Right,
      C.Answer: Pair, C.Answer.Right: Pair,
      C.Answer.Left == C.Left.Left,
      C.Answer.Right.Left: EmptyCandidateSupport,
      C.Answer.Right.Right: EmptyCandidateSupport

/// Bind exhaustion to the original (pins, unmeasured references) source.
/// Reconstructing that source covers its fields. Equality of the pin trees
/// retains every measured direction. The consumed readings are precisely
/// those from this reference-bound catalogue, not another list on the source.
public typealias DeclaredIceIncidence<A: PredicateReading, C: PredicateReading, P: IceCatalogue, U: IceCatalogue> = ExhaustedIceIncidence<A, C>
where A.Left: Pair, A.Left.Right: Pair,
      A.Sigma == C.Sigma, A.Encoding == C.Encoding,
      A.Left.Left == A.Left.Right.Left, A.Left.Right.Right == Never,
      A.Answer: Pair, A.Answer.Right: Pair,
      A.Answer.Left == A.Left.Left, A.Answer.Right.Left: EmptyCandidateSupport,
      C.Left: Pair, C.Left.Right: Pair,
      C.Left.Right.Right == A.Answer.Right.Right,
      C.Answer: Pair, C.Answer.Right: Pair, C.Answer.Left == C.Left.Left,
      C.Answer.Right.Left: EmptyCandidateSupport, C.Answer.Right.Right: EmptyCandidateSupport,
      P.Source == U.Source, P.Sigma == U.Sigma, P.Encoding == U.Encoding,
      P.Source == Paired<P.References, U.References>, P.Directions == P.References,
      C.Left.Left == P.Source, C.Sigma == P.Sigma, C.Encoding == P.Encoding,
      C.Left.Right.Left == SourceIceCatalogue<P, U>.Edges

/// Consume a reference pair and one endpoint vertex; the other must survive.
/// A completed finite sequence cannot strand another edge at a removed
/// vertex. Only reference pairs occur here, so changing pin values or derived
/// directions does not change this certificate of the residual topology.
public enum RemoveIceForestEndpoint<E: CandidateRemoval, D: CandidateRemoval, V: CandidateRemoval, N: CandidateRemoval, S, Z>: PredicateReading
where E.Right: Pair, E.Right.Left: Pair, E.Right.Right: Pair,
      D.Left == IceReferenceDirections<E.Right>, D.Right: Pair,
      D.Right.Left: Pair, D.Right.Right: Pair,
      V.Address == D.Right.Left.Left, N.Address == D.Right.Right.Left,
      N.Left == V.Remainder {
    public typealias Left = Paired<E.Left, V.Left>
    public typealias Right = Paired<E.Remainder, V.Remainder>
    public typealias Sigma = S
    public typealias Encoding = Z
    public typealias Predicate = Paired<E.Address, Paired<V.Address, N.Address>>
    public typealias Answer = Right
}

/// Cover every residual reference pair on the original vertex positions.
/// Remaining isolated roots are allowed. Finite removal/identity/composition
/// expressions establish acyclicity; an unfinished prefix need not do so.
public typealias ResidualIceForest<V: Pair, U: IceCatalogue, F: PredicateReading> = F
where F.Left == Paired<U.ReferenceEdges, V>,
      F.Sigma == U.Sigma, F.Encoding == U.Encoding,
      F.Answer: Pair, F.Answer.Left: EmptyCandidateSupport

/// Check one actual vertex word against four selected global readings.
/// Selections are membership witnesses: the shared edge fact is reusable at
/// both ends. Only this vertex's pending balance obligation is consumed.
public enum CheckIceVertex<C: IceCatalogue, K: KnownIcePorts, V: CandidateRemoval, E0: CandidateRemoval, E1: CandidateRemoval, E2: CandidateRemoval, E3: CandidateRemoval>: PredicateReading
where K.Source == C.Source, K.Sigma == C.Sigma, K.Encoding == C.Encoding,
      K.Vertex == V.Address, K.Next == Succ<Three>,
      K.Word.InCount == Two, K.Word.OutCount == Two,
      E0.Left == C.Edges, E1.Left == C.Edges, E2.Left == C.Edges, E3.Left == C.Edges,
      E0.Right: Structure, E1.Right: Structure, E2.Right: Structure, E3.Right: Structure,
      K.Readings == Paired<E3.Right, Paired<E2.Right, Paired<E1.Right, Paired<E0.Right, Never>>>> {
    public typealias Left = Paired<C.Source, V.Left>
    public typealias Right = Paired<C.Source, V.Remainder>
    public typealias Sigma = C.Sigma
    public typealias Encoding = C.Encoding
    public typealias Predicate = Paired<V.Address, Paired<E0.Address, Paired<E1.Address, Paired<E2.Address, E3.Address>>>>
    public typealias Answer = Right
}

/// Cover all original vertex positions with their actual catalogue readings.
/// The finite EmptyIcePorts/InAtIcePort/OutAtIcePort words and finite check
/// sequence supply local counts, incidence membership and complete coverage.
public typealias BalancedIceCatalogue<V: Pair, C: IceCatalogue, F: PredicateReading> = F
where F.Left == Paired<C.Source, V>, F.Sigma == C.Sigma, F.Encoding == C.Encoding,
      F.Answer: Pair, F.Answer.Left == C.Source, F.Answer.Right: EmptyCandidateSupport
