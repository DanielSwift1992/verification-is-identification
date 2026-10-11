import VerificationIsIdentification

/// These declarations supply questions and available views, not a decoder or
/// an asserted final equality. The court constructs the addressed continuation.
/// Parameters denote unknown type fields, not observed runtime payload values.
public enum ContinuationFrameRequest<A: Structure, B: Structure, R: Structure> {
    public typealias Source = TargetFrame<A, B, R>
    public typealias Observation = Paired<Source.Right.Left, Source.Left>
    public typealias Question = Paired<Source.Left, Source.Right.Left>
}

public enum ContinuationLostRequest<A: Structure, B: Structure, C: Structure> {
    public typealias Source = TargetFrame<A, B, C>
    public typealias Observation = Source.Left
    public typealias Question = Paired<Source.Right.Left,
        Paired<Source.Right.Right, Source.Right.Left>>
}

public enum ContinuationRelatedRequest<A: Structure, R: Structure> {
    public typealias Source = TargetFrame<A, A, R>
    public typealias Observation = Source.Left
    public typealias Question = Source.Right.Left
}

/// A projection helper is read from its definition and its Pair premise.
public typealias ContinuationSecond<S: Pair> = S.Right

public enum ContinuationAliasRequest<A: Structure, B: Structure> {
    public typealias Source = Paired<A, B>
    public typealias Observation = ContinuationSecond<Source>
    public typealias Question = Source.Right
}
