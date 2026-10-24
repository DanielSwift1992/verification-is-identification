import VerificationIsIdentification

enum RetainOneClass<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source.Left
    typealias Question = Source.Right
}
enum RetainTwoSorts<A: Structure, B: Structure, C: Structure> {
    typealias Source = Paired<A, Paired<B, C>>
    typealias Observation = Source.Left
    typealias Question = Source
}
enum RetainRepeatedClass<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source.Left
    typealias Question = Paired<Source.Right, Source.Right>
}
enum RetainFromClassOutsideViews<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Observation = Source.Right.Right
    typealias Question = Source.Right.Left
    typealias Equalities = Paired<Source.Left, Source.Right.Left>
}
enum RetainNothing<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Observation = Source.Left
    typealias Question = Source.Right
    typealias Equalities = Paired<Source.Left, Source.Right>
}
