import VerificationIsIdentification

/// Successive local ports, read from one source. Counts use the existing
/// Vacuum/In/Out grammar. The constructors below bind every added direction
/// to its actual vertex and next port address. [Matter M68]
/// Finite constructor expressions supply this interpretation. This open
/// interface alone does not prove a whole graph's inventory or coverage.
public protocol KnownIcePorts: HasEncoding {
    associatedtype Source: Structure
    associatedtype Vertex: Structure
    associatedtype Next: IntegerValued
    associatedtype Word: Bonds
    associatedtype Readings: Structure
}

public enum EmptyIcePorts<G: Structure, V: Structure, S, E>: KnownIcePorts {
    public typealias Source = G
    public typealias Vertex = V
    public typealias Sigma = S
    public typealias Encoding = E
    public typealias Next = Never
    public typealias Word = Vacuum
    public typealias Readings = Never
}

/// R.Answer is the directed pair (tail port, head port). Each port is
/// (vertex, slot). An incoming edge must end at this exact next slot.
public enum InAtIcePort<R: PredicateReading, K: KnownIcePorts>: KnownIcePorts
where R.Left == K.Source, R.Sigma == K.Sigma, R.Encoding == K.Encoding,
      R.Answer: Pair, R.Answer.Left: Pair,
      R.Answer.Right == Paired<K.Vertex, K.Next> {
    public typealias Source = K.Source
    public typealias Vertex = K.Vertex
    public typealias Sigma = K.Sigma
    public typealias Encoding = K.Encoding
    public typealias Next = Succ<K.Next>
    public typealias Word = In<K.Word>
    public typealias Readings = Paired<R, K.Readings>
}

/// The same outgoing direction is incoming at its other addressed end.
public enum OutAtIcePort<R: PredicateReading, K: KnownIcePorts>: KnownIcePorts
where R.Left == K.Source, R.Sigma == K.Sigma, R.Encoding == K.Encoding,
      R.Answer: Pair, R.Answer.Right: Pair,
      R.Answer.Left == Paired<K.Vertex, K.Next> {
    public typealias Source = K.Source
    public typealias Vertex = K.Vertex
    public typealias Sigma = K.Sigma
    public typealias Encoding = K.Encoding
    public typealias Next = Succ<K.Next>
    public typealias Word = Out<K.Word>
    public typealias Readings = Paired<R, K.Readings>
}

/// The question includes the retained reference pair of the inferred edge.
public enum IceDirectionQuestion<Edge: Pair>: Close {}

/// M reads the remaining reference edge (this vertex's slot 3, remote port)
/// from the same source as the three known directions. One known In and two
/// Out force the remaining direction toward this vertex. No direction of
/// that edge is supplied as a generic argument. [Matter M68]
public enum IceLeafIn<M: PredicateReading, K: KnownIcePorts>: PredicateReading
where M.Left == K.Source, M.Sigma == K.Sigma, M.Encoding == K.Encoding,
      K.Next == Three, K.Word.InCount == Lit1, K.Word.OutCount == Two,
      M.Answer: Pair, M.Answer.Right: Pair,
      M.Answer.Left == Paired<K.Vertex, Three> {
    public typealias Left = K.Source
    public typealias Right = Paired<M.Answer.Right, M.Answer.Left>
    public typealias Sigma = K.Sigma
    public typealias Encoding = K.Encoding
    public typealias Predicate = IceDirectionQuestion<M.Answer>
    public typealias Answer = Right
    public typealias Completed = InAtIcePort<IceLeafIn<M, K>, K>
    public typealias LocalRule = Survivor<Completed.Word>
    public typealias ReferenceEdge = M.Answer
    public typealias Catalogue = IceCatalogueEdge<IceLeafIn<M, K>, M, ReverseIceReference<M.Answer>>
}

/// Two known In and one Out force the remaining direction away from this
/// vertex. Both endpoints come from M's actual reference edge. The local
/// rule is derived from the completed word, not accepted as a separate tag.
public enum IceLeafOut<M: PredicateReading, K: KnownIcePorts>: PredicateReading
where M.Left == K.Source, M.Sigma == K.Sigma, M.Encoding == K.Encoding,
      K.Next == Three, K.Word.InCount == Two, K.Word.OutCount == Lit1,
      M.Answer: Pair, M.Answer.Right: Pair,
      M.Answer.Left == Paired<K.Vertex, Three> {
    public typealias Left = K.Source
    public typealias Right = Paired<M.Answer.Left, M.Answer.Right>
    public typealias Sigma = K.Sigma
    public typealias Encoding = K.Encoding
    public typealias Predicate = IceDirectionQuestion<M.Answer>
    public typealias Answer = Right
    public typealias Completed = OutAtIcePort<IceLeafOut<M, K>, K>
    public typealias LocalRule = Survivor<Completed.Word>
    public typealias ReferenceEdge = M.Answer
    public typealias Catalogue = IceCatalogueEdge<IceLeafOut<M, K>, M, ForwardIceReference<M.Answer>>
}
