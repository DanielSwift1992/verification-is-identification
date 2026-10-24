// U9 declares the output Image and output-relative Promise independently.
enum PermutedPromise<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Equalities = Paired<Source.Left, Source.Right.Left>
    typealias Image = Paired<Source.Left, Paired<Source.Right.Right, Source.Right.Left>>
    typealias Promise = Paired<Image.Left, Image.Right.Right>
}
enum PermutedOldRelation<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Equalities = Paired<Source.Left, Source.Right.Left>
    typealias Image = Paired<Source.Left, Paired<Source.Right.Right, Source.Right.Left>>
    typealias Promise = Paired<Image.Left, Image.Right.Left>
}
enum IndependentPromise<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Image = Source
    typealias Promise = Paired<Image.Left, Image.Right>
}
enum UnrestrictedImage<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Image = Source
}
enum DuplicateImage<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Image = Paired<Source.Left, Source.Left>
    typealias Promise = Paired<Image.Left, Image.Right>
}
enum DuplicateOutputPlaces<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Image = Paired<Source.Left, Paired<Source.Left, Source.Right>>
    typealias Promise = Paired<Image.Left, Image.Right.Left>
}
enum LeftMarginal<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Image = Source.Left
}
enum RightMarginal<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Image = Source.Right
}
enum AliasedImage<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Swapped = Paired<Source.Right, Source.Left>
    typealias Image = Swapped
    typealias Promise = Paired<Image.Left, Image.Left>
}
enum TwoSortImage<A: Structure, B: Structure> {
    typealias Source = Paired<A, B>
    typealias Image = Paired<Source.Right, Source.Left>
}
enum ScalarImage<S: Structure> {
    typealias Source = S
    typealias Image = Source
    typealias Promise = Paired<Image, Image>
}
enum ChainedImage<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Equalities = Paired<Paired<Source.Left, Source.Right.Left>, Paired<Source.Right.Left, Source.Right.Right>>
    typealias Image = Source
    typealias Promise = Paired<Image.Left, Image.Right.Right>
}
enum OmittedIndependentPlaces<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Image = Source.Left
}
enum SourceIsNotOutput<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Image = Paired<Source.Right, Source.Left>
    typealias Promise = Paired<Source.Left, Source.Right>
}
enum UnreadPromiseAxis<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Image = Source
    typealias Promises = Paired<Image.Left, Image.Right>
}
enum DifferentPromiseSorts<A: Structure, B: Structure> {
    typealias Source = Paired<A, B>
    typealias Image = Source
    typealias Promise = Paired<Image.Left, Image.Right>
}
enum MalformedImagePromise<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Image = Source
    typealias Promise = Paired<Image, Image.Left>
}
enum UnrootedImage<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Image = S
}
enum HiddenPairPromise<S: Structure> {
    typealias Source = Paired<Paired<S, S>, Paired<S, S>>
    typealias Equalities = Paired<Paired<Source.Left.Left, Source.Right.Left>, Paired<Source.Left.Right, Source.Right.Right>>
    typealias Image = Source
    typealias HiddenActions = Paired<Source, Paired<Source.Right, Source.Left>>
    typealias Promise = Paired<Image.Left.Left, Image.Left.Right>
}
enum HiddenMixedPromise<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Image = Source
    typealias HiddenActions = Paired<Source, Paired<Source.Left, Source.Left>>
    typealias Promise = Paired<Image.Left, Image.Right>
}
enum ImageTemplateIsNotAChoice<S: Structure> {
    typealias Source = Paired<S, S>
    typealias Image = Source
    typealias HiddenActions = Paired<Paired<Source.Left, Source.Left>, Paired<Source.Right, Source.Right>>
    typealias Promise = Paired<Image.Left, Image.Right>
}
enum HiddenDifferentOutputShape<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Image = Paired<Source.Left, Source.Right.Left>
    typealias HiddenActions = Paired<Paired<Source.Left, Source.Left>, Paired<Source.Right.Left, Source.Right.Left>>
    typealias Promise = Paired<Image.Left, Image.Right>
}
enum HiddenScalarOutput<S: Structure> {
    typealias Source = S
    typealias Image = Paired<Source, Source>
    typealias HiddenActions = Paired<Image, Image>
    typealias Promise = Paired<Image.Left, Image.Right>
}
enum MalformedImageFamily<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Image = Paired<Source.Left, Source.Right.Left>
    typealias HiddenActions = Source
}
enum MultiImagePromise<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Equalities = Paired<Source.Left, Source.Right.Left>
    typealias Image = Paired<Source.Left, Paired<Source.Right.Right, Source.Right.Left>>
    typealias Promise = Paired<Paired<Image.Left, Image.Left>, Paired<Image.Right.Right, Image.Right.Right>>
}
enum MixedImagePromises<S: Structure> {
    typealias Source = Paired<S, Paired<S, S>>
    typealias Equalities = Paired<Source.Left, Source.Right.Left>
    typealias Image = Paired<Source.Left, Paired<Source.Right.Right, Source.Right.Left>>
    typealias Promise = Paired<Paired<Image.Left, Image.Left>, Paired<Image.Right.Right, Image.Right.Left>>
}
enum OmittedSortImage<A: Structure, B: Structure> {
    typealias Source = Paired<A, B>
    typealias Image = Source.Left
}
