import VerificationIsIdentification
import Examples

#if !CONTACT_MOMENT_UNCOUPLED && !CONTACT_MOMENT_SOURCE
enum ShortContactOneHasComputedBalance: Null {
    typealias M = BalancedContactRows.ShortOneMoment
    typealias Left = M.Left
    typealias Right = M.Right
}
enum ShortContactTwoHasComputedBalance: Null {
    typealias M = BalancedContactRows.ShortTwoMoment
    typealias Left = M.Left
    typealias Right = M.Right
}
enum ShortContactThreeHasComputedBalance: Null {
    typealias M = BalancedContactRows.ShortThreeMoment
    typealias Left = M.Left
    typealias Right = M.Right
}
enum LongContactOneHasComputedBalance: Null {
    typealias M = BalancedContactRows.LongOneMoment
    typealias Left = M.Left
    typealias Right = M.Right
}
enum LongContactTwoHasComputedBalance: Null {
    typealias M = BalancedContactRows.LongTwoMoment
    typealias Left = M.Left
    typealias Right = M.Right
}
enum LongContactThreeHasComputedBalance: Null {
    typealias M = BalancedContactRows.LongThreeMoment
    typealias Left = M.Left
    typealias Right = M.Right
}
#endif

#if CONTACT_MOMENT_UNCOUPLED
enum RejectedChangedRelativeRateKeepsTheSameBalance: Null {
    typealias B = BalancedContactRows
    typealias Row = TwoBranchRow<B.One, Never, B.Three, B.One, B.One>
    typealias M = ContactRowMoment<Row, B.TimesOne<Never>, B.TimesOne<B.Three>,
        B.PlusOne<B.One>, AddZero<B.Three>, B.TwiceOne>
    typealias Left = M.Left
    typealias Right = M.Right
}
#endif

#if CONTACT_MOMENT_SOURCE
enum RejectedMomentProofForAnotherContactRow: Null {
    typealias B = BalancedContactRows
    // Both 1*0 and 2*0 answer zero. The remaining sums would balance,
    // but the first product does not read this row's actual weight 2.
    typealias M = ContactRowMoment<B.LongOne, B.TimesOne<Never>, B.TimesOne<B.Three>,
        B.PlusTwo<B.One>, AddZero<B.Three>, B.ThreeTimesOne>
    typealias Left = M.Left
    typealias Right = M.Right
}
#endif
