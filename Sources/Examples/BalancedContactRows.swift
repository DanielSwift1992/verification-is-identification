import VerificationIsIdentification

/// The first field is the current H value. Each branch carries its actual
/// next H value and its relative rate. These are finite numeral relations,
/// not physical states identified by their numerical names.
public typealias TwoBranchRow<H: IntegerValued, L: IntegerValued,
    R: IntegerValued, A: IntegerValued, B: IntegerValued> =
    Paired<H, Paired<Paired<L, A>, Paired<R, B>>>

/// Read the weighted next-value sum and the current value times total rate.
/// All operands come from the actual row. Equality is not a premise here;
/// the concrete finite constructor proofs below calculate the two sides.
public enum ContactRowMoment<R: Pair, L: NaturalProduct, P: NaturalProduct,
    W: NaturalSum, V: NaturalSum, C: NaturalProduct>: Pair
where R.Right: Pair, R.Right.Left: Pair, R.Right.Right: Pair,
      L.Left.Left == R.Right.Left.Right, L.Left.Right == R.Right.Left.Left,
      P.Left.Left == R.Right.Right.Right, P.Left.Right == R.Right.Right.Left,
      W.Left.Left == R.Right.Left.Right, W.Left.Right == R.Right.Right.Right,
      V.Left.Left == L.Answer, V.Left.Right == P.Answer,
      C.Left.Left == W.Answer, C.Left.Right == R.Left {
    public typealias Left = V.Answer
    public typealias Right = C.Answer
}

/// Only the displayed AddZero/AddSuccessor and product constructor grammar
/// supplies arithmetic meaning. Arbitrary NaturalSum/Product conformances
/// do not certify a branch law or a probability. M64ax proves that part.
public enum BalancedContactRows: Close {
    public typealias One = Examples.Succ<Never>
    public typealias Two = Examples.Succ<One>
    public typealias Three = Examples.Succ<Two>
    public typealias Four = Examples.Succ<Three>
    public typealias PlusOne<N: IntegerValued> = AddSuccessor<AddZero<N>>
    public typealias PlusTwo<N: IntegerValued> = AddSuccessor<PlusOne<N>>
    public typealias PlusThree<N: IntegerValued> = AddSuccessor<PlusTwo<N>>
    public typealias PlusFour<N: IntegerValued> = AddSuccessor<PlusThree<N>>
    public typealias TimesOne<N: IntegerValued> =
        ProductSuccessor<ProductZero<N>, AddZero<N>>
    public typealias TwiceZero = ProductSuccessor<TimesOne<Never>, AddZero<Never>>
    public typealias TwiceOne = ProductSuccessor<TimesOne<One>, PlusOne<One>>
    public typealias TwiceTwo = ProductSuccessor<TimesOne<Two>, PlusTwo<Two>>
    public typealias TwiceThree = ProductSuccessor<TimesOne<Three>, PlusThree<Three>>
    public typealias TwiceFour = ProductSuccessor<TimesOne<Four>, PlusFour<Four>>
    public typealias ThreeTimesOne = ProductSuccessor<TwiceOne, PlusTwo<One>>
    public typealias ThreeTimesThree = ProductSuccessor<TwiceThree,
        AddSuccessor<AddSuccessor<PlusFour<Three>>>>

    public typealias ShortOne = TwoBranchRow<One, Never, Two, One, One>
    public typealias ShortTwo = TwoBranchRow<Two, One, Three, One, One>
    public typealias ShortThree = TwoBranchRow<Three, Two, Four, One, One>
    public typealias LongOne = TwoBranchRow<One, Never, Three, Two, One>
    public typealias LongTwo = TwoBranchRow<Two, Never, Four, One, One>
    public typealias LongThree = TwoBranchRow<Three, One, Four, One, Two>

    public typealias ShortOneMoment = ContactRowMoment<ShortOne,
        TimesOne<Never>, TimesOne<Two>, PlusOne<One>, AddZero<Two>, TwiceOne>
    public typealias ShortTwoMoment = ContactRowMoment<ShortTwo,
        TimesOne<One>, TimesOne<Three>, PlusOne<One>, PlusOne<Three>, TwiceTwo>
    public typealias ShortThreeMoment = ContactRowMoment<ShortThree,
        TimesOne<Two>, TimesOne<Four>, PlusOne<One>, PlusTwo<Four>, TwiceThree>
    public typealias LongOneMoment = ContactRowMoment<LongOne,
        TwiceZero, TimesOne<Three>, PlusTwo<One>, AddZero<Three>, ThreeTimesOne>
    public typealias LongTwoMoment = ContactRowMoment<LongTwo,
        TimesOne<Never>, TimesOne<Four>, PlusOne<One>, AddZero<Four>, TwiceTwo>
    public typealias LongThreeMoment = ContactRowMoment<LongThree,
        TimesOne<One>, TwiceFour, PlusOne<Two>, PlusOne<TwiceFour.Answer>,
        ThreeTimesThree>
}
