import VerificationIsIdentification

/// Keep the representation code in the input address. Equal raw values under
/// different codes are different inputs in this declared tagged interpretation.
public enum AddressedRepresentation<
    Code,
    Value
>: Pair {
    public typealias Left = Code
    public typealias Right = Value
}

public enum TransportEnvelope: Close {}

/// Embed a supplied reading in a common tagged representation grammar. The
/// original code remains in Left. This preserves a supplied reading's answer,
/// without certifying the semantics of an arbitrary PredicateReading conformer.
public enum AddressedReading<R: PredicateReading>: PredicateReading {
    public typealias Left = AddressedRepresentation<R.Encoding, R.Left>
    public typealias Right = R.Answer
    public typealias Sigma = R.Sigma
    public typealias Encoding = TransportEnvelope
    public typealias Predicate = R.Predicate
    public typealias Answer = R.Answer
}

/// Two supplied factorizations compose through the same actual reading. The
/// final answer equality follows through that middle reading. No final-answer
/// premise is added. Observation composition also checks the middle input.
public enum JoinedFactorization<
    F: ReadingFactors,
    G: ReadingFactors
>: ReadingFactors
where F.Right == G.Left {
    public typealias Left = F.Left
    public typealias Right = G.Right
    public typealias Observation = SequentialReading<F.Observation, G.Observation>
    public typealias Sigma = F.Sigma
    public typealias Encoding = F.Encoding
    public typealias Predicate = F.Predicate
    public typealias Answer = F.Answer
}

/// The zero-length path for any supplied reading. Together with the generic
/// join this certifies every finite path constructed from compatible steps.
public enum IdentityFactorization<R: PredicateReading>: ReadingFactors {
    public typealias Left = R
    public typealias Right = R
    public typealias Observation = IdentityReading<R.Left, R.Sigma, R.Encoding>
    public typealias Sigma = R.Sigma
    public typealias Encoding = R.Encoding
    public typealias Predicate = R.Predicate
    public typealias Answer = R.Answer
}

public enum TransportSpace: Close {}
public enum NativeLayout: Close {}
public enum WireLayout: Close {}
public enum ScalarLayout: Close {}
public enum PayloadQuestion: Close {}
public enum ReverseLayoutOperation: Close {}
public enum ProjectPayloadOperation: Close {}

/// In the native layout the payload precedes a second, unrelated coordinate.
public enum NativePayload<P: Pair>: PredicateReading {
    public typealias Left = P
    public typealias Right = P.Left
    public typealias Sigma = TransportSpace
    public typealias Encoding = NativeLayout
    public typealias Predicate = PayloadQuestion
    public typealias Answer = P.Left
}

/// The wire layout reverses the two positions. Its payload is on the right.
public enum WirePayload<P: Pair>: PredicateReading {
    public typealias Left = P
    public typealias Right = P.Right
    public typealias Sigma = TransportSpace
    public typealias Encoding = WireLayout
    public typealias Predicate = PayloadQuestion
    public typealias Answer = P.Right
}

/// The final representation contains the payload alone.
public enum ScalarPayload<X>: PredicateReading {
    public typealias Left = X
    public typealias Right = X
    public typealias Sigma = TransportSpace
    public typealias Encoding = ScalarLayout
    public typealias Predicate = PayloadQuestion
    public typealias Answer = X
}

/// A symbolic change of layout with both codes retained in its endpoints.
public enum LayoutObservation<P: Pair>: PredicateReading
where P.Left: Structure, P.Right: Structure {
    public typealias Left = AddressedRepresentation<NativeLayout, P>
    public typealias Right = AddressedRepresentation<WireLayout, Paired<P.Right, P.Left>>
    public typealias Sigma = TransportSpace
    public typealias Encoding = TransportEnvelope
    public typealias Predicate = ReverseLayoutOperation
    public typealias Answer = Right
}

/// Read the payload out of a wire representation. This local projection can
/// lose its other coordinate. It is not an erasure law for a physical whole.
public enum PayloadObservation<P: Pair>: PredicateReading {
    public typealias Left = AddressedRepresentation<WireLayout, P>
    public typealias Right = AddressedRepresentation<ScalarLayout, P.Right>
    public typealias Sigma = TransportSpace
    public typealias Encoding = TransportEnvelope
    public typealias Predicate = ProjectPayloadOperation
    public typealias Answer = Right
}

/// For every permitted pair, reverse the layout and read its right coordinate.
/// The payload agrees by projection, with no equality of payloads assumed.
public enum LayoutFactorization<P: Pair>: ReadingFactors
where P.Left: Structure, P.Right: Structure {
    public typealias Left = AddressedReading<NativePayload<P>>
    public typealias Right = AddressedReading<WirePayload<Paired<P.Right, P.Left>>>
    public typealias Observation = LayoutObservation<P>
    public typealias Sigma = TransportSpace
    public typealias Encoding = TransportEnvelope
    public typealias Predicate = PayloadQuestion
    public typealias Answer = P.Left
}

/// Projecting the wire payload preserves this question for every pair. The
/// omitted coordinate need not be identified, fixed or equal to the payload.
public enum PayloadFactorization<P: Pair>: ReadingFactors {
    public typealias Left = AddressedReading<WirePayload<P>>
    public typealias Right = AddressedReading<ScalarPayload<P.Right>>
    public typealias Observation = PayloadObservation<P>
    public typealias Sigma = TransportSpace
    public typealias Encoding = TransportEnvelope
    public typealias Predicate = PayloadQuestion
    public typealias Answer = P.Right
}
