import VerificationIsIdentification
import Examples

#if !CLOCK_MASS_GROUPING && !CLOCK_MASS_SOURCE
enum SharedClockClassesGiveEqualOutcomeMassLists<A: Structure, B: Structure>: Null {
    typealias P = ClockBalancedMass<Paired<A, B>>.EqualMassLists
    typealias Left = P.Left
    typealias Right = P.Right
}

enum ChangingBothUnknownClassMassesPreservesTheirBalance<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias Old = ClockBalancedMass<Paired<A, B>>.Reading
    typealias New = ClockBalancedMass<Paired<C, D>>.Reading
    typealias Left = Paired<Old.Answer.Left, New.Answer.Left>
    typealias Right = Paired<Old.Answer.Right, New.Answer.Right>
}

enum ClassGroupingAndOutcomeGroupingAreDifferentReadings<A: Structure, B: Structure>: Null {
    typealias P = ClockBalancedMass<Paired<A, B>>
    typealias Left = Paired<P.Expansion.Answer.Left, P.Reading.Answer.Left>
    typealias Right = Paired<Paired<A, A>, Paired<A, B>>
}

enum AClockMassRecordKeepsItsActualClassSource<A: Structure, B: Structure>: Null {
    typealias P = ClockBalancedMass<Paired<A, B>>
    typealias R = RecordReading<P.Reading>
    typealias Left = Paired<R.Right.Left, R.Right.Right.Answer>
    typealias Right = Paired<Paired<A, B>, Paired<Paired<A, B>, Paired<A, B>>>
}
#endif

#if CLOCK_MASS_GROUPING
enum RejectedClassGroupingIsNotAutomaticallyOutcomeBalance: Null {
    typealias P = ExpandClockClassMass<Paired<Examples.Succ<Never>,
        Examples.Succ<Examples.Succ<Examples.Succ<Never>>>>>
    typealias Left = P.Answer.Left
    typealias Right = P.Answer.Right
}
#endif

#if CLOCK_MASS_SOURCE
enum RejectedClockGroupingFromADifferentCurrentSource: Null {
    typealias Old = ExpandClockClassMass<Paired<Never, Examples.Succ<Never>>>
    typealias New = ExpandClockClassMass<Paired<Examples.Succ<Never>, Never>>
    typealias Invalid = SequentialReading<Old, GroupClockMassByOutcome<New.Answer>>
    typealias Left = Invalid.Answer
    typealias Right = Old.Answer
}
#endif
