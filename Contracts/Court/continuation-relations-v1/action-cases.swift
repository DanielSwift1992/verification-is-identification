// Named U7/U8 requests; opaque same-sort occurrences remain distinct places.
enum PreservesEqualities<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Observation = Source.Left
    typealias Question = Source.Left
    typealias Equalities = Paired<Source.Left, Source.Right.Left>
    typealias Actions = Paired<Source.Right.Left, Paired<Source.Left, Source.Right.Right>>
}
enum BreaksEqualities<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Observation = Source.Left
    typealias Question = Source.Left
    typealias Equalities = Paired<Source.Left, Source.Right.Left>
    typealias Actions = Paired<Source.Left, Paired<Source.Right.Right, Source.Right.Left>>
}
enum CyclicQuestion<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Observation = Source.Left
    typealias Question = Source.Left
    typealias Actions = Paired<Source.Right.Right, Paired<Source.Left, Source.Right.Left>>
}
enum EmptyActions<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Observation = Source.Left
    typealias Question = Source.Right.Right
}
enum HiddenDisagreement<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source
    typealias Question = Source
    typealias Actions = Paired<Source, Paired<Source.Right, Source.Left>>
    typealias HiddenActions = Actions
}
enum HiddenCommon<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Observation = Source.Left
    typealias Question = Source.Left
    typealias Actions = Source
    typealias HiddenActions = Paired<Source, Paired<Source.Left, Paired<Source.Right.Right, Source.Right.Left>>>
}
enum HiddenOutside<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source.Left
    typealias Question = Source.Left
    typealias Actions = Source
    typealias HiddenActions = Paired<Source.Right, Source.Left>
}
enum HiddenInvalidEqualities<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Observation = Source.Left
    typealias Question = Source.Left
    typealias Equalities = Paired<Source.Left, Source.Right.Left>
    typealias HiddenActions = Paired<Source.Left, Paired<Source.Right.Right, Source.Right.Left>>
}
enum HiddenEquivalentProjections<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source
    typealias Question = Source.Left
    typealias Equalities = Paired<Source.Left, Source.Right>
    typealias Actions = Source
    typealias HiddenActions = Paired<Source, Paired<Source.Right, Source.Left>>
}
typealias Exchanged<S: Pair> = Paired<S.Right, S.Left> where S.Left: Structure, S.Right: Structure
enum AliasedActions<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source
    typealias Question = Source
    typealias Actions = Paired<Source, Exchanged<Source>>
    typealias HiddenActions = Actions.Left
}
enum MalformedActionShape<A: Structure, B: Structure> {
    typealias Source = Paired<A, B>
    typealias Observation = Source.Left
    typealias Question = Source.Right
    typealias Actions = Source.Left
}
enum UnrootedAction<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source.Left
    typealias Question = Source.Right
    typealias Actions = Paired<S, S>
}
enum UnreadActionAxis<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source.Left
    typealias Question = Source.Right
    typealias Action = Source
}
enum HiddenOnly<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source.Left
    typealias Question = Source.Left
    typealias HiddenActions = Source
}
enum NoncommutingWords<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Observation = Source.Left
    typealias Question = Source.Left
    typealias Actions = Paired<Paired<Source.Right.Left, Paired<Source.Right.Left, Source.Right.Right>>, Paired<Source.Left, Paired<Source.Right.Right, Source.Right.Right>>>
}
enum SortChangingAction<A: Structure, B: Structure> {
    typealias Source = Paired<A, B>
    typealias Observation = Source.Left
    typealias Question = Source.Right
    typealias Actions = Paired<Source.Right, Source.Left>
}
enum ScalarActions<S: Structure> {
    typealias Source = S
    typealias Observation = Source
    typealias Question = Source
    typealias Actions = Paired<Source, Paired<Source, Source>>
    typealias HiddenActions = Actions
}
