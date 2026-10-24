// U10/U10a declare output obligations before a step is chosen.
typealias AgreementTwin<T: Structure> = Paired<T, T>
enum AgreementOther<S: Structure> {
    typealias Source = S
    typealias Output = Source
}
enum AgreeThree<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Output = Paired<S, S>
    typealias Promise = Paired<Output.Left, Output.Right>
    typealias Question = Source
}
enum BindOriginal<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Output = Paired<S, S>
    typealias Promise = Paired<Output.Left, Output.Right>
    typealias Question = Source
    typealias BoundOutputs = Output.Left
    typealias BoundSources = Source.Left
}
enum ZeroResidual<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Output = Paired<S, S>
    typealias Question = Source
}
enum ScalarAgreement<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Output = S
    typealias Question = Source
}
enum RepeatedQuestion<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Output = S
    typealias Question = Paired<Source.Right, Source.Right>
}
enum EqualSource<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Equalities = Paired<Source.Left, Source.Right>
    typealias Output = Paired<S, S>
    typealias Promise = Paired<Output.Left, Output.Right>
    typealias Question = Source
}
enum ExtraOutputPlaces<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Output = Paired<S, Paired<S, S>>
    typealias Question = Source
}
enum TwoSortCapacity<A: Structure, B: Structure> {
    typealias Source = Paired<A, Paired<A, B>>
    typealias Output = Paired<A, B>
    typealias Question = Source
}
enum QuestionSortNotInOutput<A: Structure, B: Structure> {
    typealias Source = Paired<A, B>
    typealias Output = A
    typealias Question = Source
}
enum BoundOutsideQuestion<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Output = Paired<S, S>
    typealias Promise = Paired<Output.Left, Output.Right>
    typealias Question = Source.Left
    typealias BoundOutputs = Output.Left
    typealias BoundSources = Source.Right
}
enum DuplicateFixed<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Output = Paired<S, S>
    typealias Question = Source
    typealias BoundOutputs = Output
    typealias BoundSources = Paired<Source.Left, Source.Left>
}
enum FreeBeforeFixed<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Output = Paired<S, S>
    typealias Question = Source
    typealias BoundOutputs = Output.Right
    typealias BoundSources = Source.Left
}
enum FixedAndFreeCover<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Output = Paired<S, S>
    typealias Question = Source
    typealias BoundOutputs = Output.Right
    typealias BoundSources = Source.Left
}
enum EquivalentBindings<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Equalities = Paired<Source.Left, Source.Right>
    typealias Output = Paired<S, S>
    typealias Promise = Paired<Output.Left, Output.Right>
    typealias Question = Source
    typealias BoundOutputs = Output
    typealias BoundSources = Source
}
enum ChainedBindings<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Equalities = Paired<Paired<Source.Left, Source.Right.Left>, Paired<Source.Right.Left, Source.Right.Right>>
    typealias Output = Paired<S, S>
    typealias Promise = Paired<Output.Left, Output.Right>
    typealias Question = Source
    typealias BoundOutputs = Output
    typealias BoundSources = Paired<Source.Left, Source.Right.Right>
}
enum IndependentOutputClasses<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Output = Paired<S, Paired<S, S>>
    typealias Promise = Paired<Output.Left, Output.Right.Right>
    typealias Question = Source
}
enum SeparateSortBindings<A: Structure, B: Structure> {
    typealias Source = Paired<A, Paired<B, A>>
    typealias Output = Paired<A, B>
    typealias Question = Source
    typealias BoundOutputs = Output.Left
    typealias BoundSources = Source.Right.Right
}
enum ScalarSource<S: Structure> {
    typealias Source = S
    typealias Output = Paired<S, S>
    typealias Promise = Paired<Output.Left, Output.Right>
    typealias Question = Source
}
enum EmptySourceRelations<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Output = Paired<S, S>
    typealias Question = Source
}
enum BoundRepeatSameLeaf<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Output = Paired<S, S>
    typealias Promise = Paired<Output.Left, Output.Right>
    typealias Question = Source
    typealias BoundOutputs = Paired<Output.Left, Output.Left>
    typealias BoundSources = Paired<Source.Left, Source.Left>
}
enum AliasedObligations<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Output = AgreementTwin<S>
    typealias Endpoint = Output.Right
    typealias Promise = Paired<Output.Left, Endpoint>
    typealias Question = Source
}
enum SourceAliasOutput<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Output = Source
    typealias Question = Source
}
enum MissingSort<A: Structure, B: Structure> {
    typealias Source = A
    typealias Output = B
    typealias Question = Source
}
enum IncompatibleBindings<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Output = Paired<S, S>
    typealias Promise = Paired<Output.Left, Output.Right>
    typealias Question = Source
    typealias BoundOutputs = Output
    typealias BoundSources = Source
}
enum IncompatibleSameOutput<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Output = Paired<S, S>
    typealias Question = Source
    typealias BoundOutputs = Paired<Output.Left, Output.Left>
    typealias BoundSources = Source
}
enum WrongBindingSort<A: Structure, B: Structure> {
    typealias Source = Paired<A, B>
    typealias Output = A
    typealias Question = Source
    typealias BoundOutputs = Output
    typealias BoundSources = Source.Right
}
enum WrongSortSecond<A: Structure, B: Structure> {
    typealias Source = Paired<A, B>
    typealias Output = Paired<A, A>
    typealias Promise = Paired<Output.Left, Output.Right>
    typealias Question = Source
    typealias BoundOutputs = Output
    typealias BoundSources = Source
}
enum MissingBoundSources<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Output = Paired<S, S>
    typealias Question = Source
    typealias BoundOutputs = Output.Left
}
enum MissingBoundOutputs<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Output = Paired<S, S>
    typealias Question = Source
    typealias BoundSources = Source.Left
}
enum MismatchedBindingTrees<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Output = Paired<S, S>
    typealias Question = Source
    typealias BoundOutputs = Output
    typealias BoundSources = Source
}
enum SourceIsNotOutputPromise<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Output = Source
    typealias Promise = Paired<Source.Left, Source.Right>
    typealias Question = Source
}
enum DifferentAgreementSorts<A: Structure, B: Structure> {
    typealias Source = Paired<A, B>
    typealias Output = Paired<A, B>
    typealias Promise = Paired<Output.Left, Output.Right>
    typealias Question = Source
}
enum UnreadBindingAxis<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Output = Paired<S, S>
    typealias Question = Source
    typealias BoundSource = Source.Left
}
enum BorrowedOutput<S: Structure> {
    typealias Source = S
    typealias Output = AgreementOther<S>.Output
    typealias Question = Source
}
enum UnrootedAgreementQuestion<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Output = Paired<S, S>
    typealias Question = S
}
enum UnavailableBoundSort<A: Structure, B: Structure> {
    typealias Source = A
    typealias Output = B
    typealias Question = Source
    typealias BoundOutputs = Output
    typealias BoundSources = Source
}
enum BoundDistinctSlots<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Output = Paired<S, S>
    typealias Question = Source
    typealias BoundOutputs = Output
    typealias BoundSources = Source
}
