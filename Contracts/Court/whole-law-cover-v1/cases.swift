import VerificationIsIdentification

enum SharedLeaf<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Equalities = Paired<Paired<Source.Left, Source.Right.Left>, Paired<Source.Right.Left, Source.Right.Right>>
    typealias First = Paired<Source.Left, Source.Right.Left>
    typealias Second = Paired<Source.Right.Left, Source.Right.Right>
    typealias Coverage = Paired<First, Second>
}
enum SeparatedClass<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Equalities = Paired<Source.Left, Source.Right>
    typealias First = Source.Left
    typealias Second = Source.Right
    typealias Coverage = Paired<First, Second>
}
enum WiderClass<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Equalities = Paired<Paired<Source.Left, Source.Right.Left>, Paired<Source.Right.Left, Source.Right.Right>>
    typealias First = Paired<Source.Left, Source.Right.Left>
    typealias Second = Source.Right.Right
    typealias Coverage = Paired<First, Second>
}
// The first cut inherits a=c along an E-path outside itself.
enum ProjectedClosure<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Equalities = Paired<Paired<Source.Left, Source.Right.Left>, Paired<Source.Right.Left, Source.Right.Right>>
    typealias First = Paired<Source.Left, Source.Right.Right>
    typealias Second = Paired<Source.Right.Left, Source.Right.Right>
    typealias Coverage = Paired<First, Second>
}
enum FalseBridge<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Equalities = Paired<Source.Left, Source.Right.Right>
    typealias First = Paired<Source.Left, Source.Right.Left>
    typealias Second = Paired<Source.Right.Left, Source.Right.Right>
    typealias Coverage = Paired<First, Second>
}
enum RepeatedOrigin<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Equalities = Paired<Source.Left, Source.Right>
    typealias First = Paired<Source.Left, Source.Left>
    typealias Second = Paired<Source.Left, Source.Right>
    typealias Coverage = Paired<First, Second>
}
enum DisjointBlocks<S: Structure, T: Structure> {
    typealias Source = Paired<Paired<S, S>, T>
    typealias Equalities = Paired<Source.Left.Left, Source.Left.Right>
    typealias First = Source.Left
    typealias Second = Source.Right
    typealias Coverage = Paired<First, Second>
}
enum NoEqualities<S: Structure> {
    typealias Source = Paired<S, S>
    typealias First = Source.Left
    typealias Second = Source.Right
    typealias Coverage = Paired<First, Second>
}
enum WholeCut<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Coverage = Source
}
// Pairing family branches retains all three declared domain occurrences.
enum ThreeDomains<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Equalities = Paired<Paired<Source.Left, Source.Right.Left>, Paired<Source.Right.Left, Source.Right.Right>>
    typealias First = Paired<Source.Left, Source.Right.Left>
    typealias Second = Source.Right.Left
    typealias Third = Paired<Source.Right.Left, Source.Right.Right>
    typealias Coverage = Paired<First, Paired<Second, Third>>
}
enum Uncovered<S: Structure> {
    typealias Source = Paired<S, S>
    typealias First = Source.Left
    typealias Coverage = First
}
enum CrossSort<S: Structure, T: Structure> {
    typealias Source = Paired<S, T>
    typealias Equalities = Paired<Source.Left, Source.Right>
    typealias Coverage = Source
}
enum DetachedCut<S: Structure> {
    typealias Source = Paired<S, S>
    typealias First = S
    typealias Coverage = First
}
enum UnreadAxis<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Equality = Paired<Source.Left, Source.Right>
    typealias Coverage = Source
}
// A written projection is a cut, but lacks a declared family-leaf boundary.
enum MissingBoundary<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Coverage = Paired<Source.Left, Source.Right>
}

// A request field is one domain even if it pairs other cut fields.
enum UnionAlias<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Equalities = Paired<Source.Left, Source.Right>
    typealias First = Source.Left
    typealias Second = Source.Right
    typealias Both = Paired<First, Second>
    typealias Coverage = Both
}
// An external alias pairs family branches without declaring one cut field.
typealias Family<A: Structure, B: Structure> = Paired<A, B>
enum NestedFamily<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Equalities = Paired<Source.Left, Source.Right>
    typealias First = Source.Left
    typealias Second = Source.Right
    typealias Coverage = Family<First, Second>
}
