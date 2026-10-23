import VerificationIsIdentification

// A repeated S is a repeated opaque sort, not equal stored contents.
enum AddressIdentity<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source.Left
    typealias Question = Source.Left
}
enum OneEquality<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source.Left
    typealias Question = Source.Right
    typealias Equalities = Paired<Source.Left, Source.Right>
}
enum EqualityChain<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Observation = Source.Left
    typealias Question = Source.Right.Right
    typealias Equalities = Paired<Paired<Source.Left, Source.Right.Left>, Paired<Source.Right.Left, Source.Right.Right>>
}
enum ReversedChain<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Observation = Source.Right.Right
    typealias Question = Source.Left
    typealias Equalities = Paired<Paired<Source.Left, Source.Right.Left>, Paired<Source.Right.Left, Source.Right.Right>>
}
enum JointQuestion<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Observation = Paired<Source.Left, Source.Right.Left>
    typealias Question = Paired<Source.Right.Right, Paired<Source.Left, Source.Right.Left>>
    typealias Equalities = Paired<Source.Right.Left, Source.Right.Right>
}
enum DisconnectedClass<S: Structure> {
    typealias Source = Paired<Paired<S, S>, Paired<S, S>>
    typealias Observation = Source.Left.Left
    typealias Question = Source.Right.Right
    typealias Equalities = Paired<Source.Left.Left, Source.Left.Right>
}
enum SameSortDifferentPlaces<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source.Left
    typealias Question = Source.Right
}
enum DisplayCoincidence<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source.Left
    typealias Question = Source.Right
    static var displayedLeft: String { "same" }
    static var displayedRight: String { "same" }
}
enum TwoSorts<A: Structure, B: Structure> {
    typealias Source = Paired<A, B>
    typealias Observation = Source.Left
    typealias Question = Source.Right
}
enum CrossSortEquality<A: Structure, B: Structure> {
    typealias Source = Paired<A, B>
    typealias Observation = Source.Left
    typealias Question = Source.Right
    typealias Equalities = Paired<Source.Left, Source.Right>
}
typealias RightView<T: Pair> = T.Right
enum AliasedView<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Observation = RightView<Source>
    typealias Question = Paired<Source.Left, Source.Right.Right>
    typealias Equalities = Paired<Source.Left, Source.Right.Left>
}
enum MismatchedEdgeTrees<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source.Left
    typealias Question = Source.Right
    typealias Equalities = Paired<Paired<Source.Left, Source.Right>, Source.Right>
}
enum SortIsNotSourcePlace<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source.Left
    typealias Question = S
}
// One unknown may be visible twice; no new source occurrence is created.
enum DuplicatedOrigin<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Paired<Source.Left, Source.Left>
    typealias Question = Source.Left
}
enum WholeAsObservation<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source
    typealias Question = Paired<Source.Right, Source.Left>
}
enum UnrootedObservation<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Paired<Source.Left, S>
    typealias Question = Source.Right
}
typealias DetachedShape<S: Structure> = Paired<S, S>
enum UnrootedQuestionAlias<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source.Left
    typealias Question = DetachedShape<S>
}
enum OtherWhole<S: Structure> {
    typealias Source = Paired<S, S>
}
enum ForeignWholeView<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source.Left
    typealias Question = OtherWhole<S>.Source.Right
}
enum MultiClassResidue<S: Structure> {
    typealias Source = Paired<Paired<S, S>, Paired<S, S>>
    typealias Observation = Source.Left.Left
    typealias Question = Paired<Source.Right.Left, Paired<Source.Right.Right, Source.Right.Left>>
    typealias Equalities = Paired<Source.Left.Left, Source.Left.Right>
}
enum ResidueEqualityClass<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Observation = Source.Left
    typealias Question = Paired<Source.Right.Left, Source.Right.Right>
    typealias Equalities = Paired<Source.Right.Left, Source.Right.Right>
}
enum ResiduePartialQuestion<S: Structure> {
    typealias Source = Paired<Paired<S, S>, Paired<S, S>>
    typealias Observation = Source.Left.Left
    typealias Question = Paired<Source.Left.Right, Paired<Source.Right.Left, Source.Right.Right>>
    typealias Equalities = Paired<Source.Left.Left, Source.Left.Right>
}
