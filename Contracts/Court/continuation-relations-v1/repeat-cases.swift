// U11: one fixed, repeatable hidden member throughout the episode.
enum ReturnFirst<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Observation = Source.Left
    typealias Question = Source.Left
    typealias HiddenActions = Paired<Paired<Source.Left, Paired<Source.Right.Right, Source.Right.Left>>, Paired<Source.Right.Left, Paired<Source.Right.Right, Source.Left>>>
}
enum ReturnWhole<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Observation = Source.Left
    typealias Question = Source
    typealias HiddenActions = Paired<Paired<Source.Left, Paired<Source.Right.Right, Source.Right.Left>>, Paired<Source.Right.Left, Paired<Source.Right.Right, Source.Left>>>
}
enum TailQuestion<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source.Left
    typealias Question = Source.Right
    typealias HiddenActions = Paired<Source.Left, Source.Left>
}
enum FixedQuestion<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source.Left
    typealias Question = Source.Left
    typealias HiddenActions = Paired<Source.Left, Source.Left>
}
enum FourCycle<S: Structure> {
    typealias Source = Paired<Paired<S, S>, Paired<S, S>>
    typealias Observation = Source.Left.Left
    typealias Question = Source.Left.Left
    typealias HiddenActions = Paired<Paired<Source.Left.Right, Source.Right.Left>, Paired<Source.Right.Right, Source.Left.Left>>
}
enum IdentityReturn<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source.Left
    typealias Question = Source
    typealias HiddenActions = Source
}
enum EqualClassReturn<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source.Left
    typealias Question = Source
    typealias Equalities = Paired<Source.Left, Source.Right>
    typealias HiddenActions = Paired<Source.Right, Source.Left>
}
enum DuplicateReturnQuestion<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Observation = Source.Left
    typealias Question = Paired<Source.Left, Source.Left>
    typealias HiddenActions = Paired<Paired<Source.Left, Paired<Source.Right.Right, Source.Right.Left>>, Paired<Source.Right.Left, Paired<Source.Right.Right, Source.Left>>>
}
enum MissingHidden<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source.Left
    typealias Question = Source.Left
}
enum ReturnBadPreservation<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Observation = Source.Left
    typealias Question = Source.Left
    typealias Equalities = Paired<Source.Left, Source.Right.Left>
    typealias HiddenActions = Paired<Source.Left, Paired<Source.Right.Right, Source.Right.Right>>
}
enum UnreadRepeatAxis<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source.Left
    typealias Question = Source.Left
    typealias HiddenAction = Source
}
enum MalformedRepeatMember<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source.Left
    typealias Question = Source.Left
    typealias HiddenActions = Source.Left
}
enum AliasedRepeats<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source
    typealias Question = Source.Left
    typealias Swap = Paired<Source.Right, Source.Left>
    typealias HiddenActions = Paired<Source, Swap>
}
enum LongReturnTail<S: Structure> {
    typealias Source = Paired<Paired<S, S>, Paired<S, S>>
    typealias Observation = Source.Left.Left
    typealias Question = Source.Right.Right
    typealias HiddenActions = Paired<Paired<Source.Left.Left, Source.Left.Left>, Paired<Source.Left.Right, Source.Right.Left>>
}
enum OtherClassesMayHaveTails<S: Structure> {
    typealias Source = Paired<Paired<S, S>, Paired<S, S>>
    typealias Observation = Source.Left.Left
    typealias Question = Source.Left.Left
    typealias HiddenActions = Paired<Paired<Source.Left.Left, Source.Left.Left>, Paired<Source.Left.Right, Source.Right.Left>>
}
enum RepeatedHiddenCopies<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source.Left
    typealias Question = Source.Left
    typealias HiddenActions = Paired<Paired<Source.Right, Source.Left>, Paired<Source.Right, Source.Left>>
}
enum ScalarRepeats<S: Structure> {
    typealias Source = S
    typealias Observation = Source
    typealias Question = Source
    typealias HiddenActions = Paired<Source, Paired<Source, Source>>
}
