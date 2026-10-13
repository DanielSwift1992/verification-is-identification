import VerificationIsIdentification

/// This is the device class C_order of CK.1: one unknown constant mixer and one bank of port
/// delays, before or after it. A bank after the mixer commutes with the readable projector, and
/// a bank before it multiplies the prepared port input by a phase. Either way the readable power
/// at one frequency is the readable power at every frequency of the band. The builder supplies
/// the class with the device. The side is invisible to these steady port-input power readings,
/// and the certificate needs no answer to it. [CK.1–3, A/B AB.3, R-Q RQ.5]
public enum OneMixerAndDelayBank: Close {}

/// This is the contrasting class C_bank of CK.4: a bank of delays between two unknown mixers.
/// The readable power can then differ between frequencies, so one reading is no certificate
/// for the band. One exact reading above the tolerance is still a refusal. [CK.4–5]
public enum DelayBetweenMixers: Close {}

/// This is the precision premise: the reading is the exact readable power, with zero error.
public enum ExactReading: Close {}

/// This is a reading within a stated nonzero error. Both certificates below require
/// ``ExactReading``, so this reading has neither verdict: it is unresolved. The rule for this
/// precision has the error in its arithmetic (R-Q RQc), and this file has no such rule.
public enum ReadingWithinError: Close {}

/// This is the continuation premise: the continuation reads only the summed power of the
/// readable ports, the quantity the certificate is about. [A/B AB.1, R-Q RQ.1]
public enum SummedPowerContinuation: Close {}

/// This is a continuation with a new mixer after the ports. The delays are then visible in
/// its reading, and both certificates below require ``SummedPowerContinuation``. [R-Q RQ-c1]
public enum MixerAfterPortsContinuation: Close {}

/// A count order is a pair of counts with the first at most the second. ``ZeroAtMost`` and
/// ``SuccessorAtMost`` are its two constructors, and each side of a step has one reference to
/// the previous step.
///
/// > Important: Only the two constructors supply the order. A hand-written conformance can
/// > name any pair of counts. The counts themselves are finite Never/Examples.Succ
/// > expressions. IntegerValued alone also admits cycles.
public protocol CountOrder: Pair
where Left: IntegerValued, Right: IntegerValued {}

/// Zero is at most any count B.
public enum ZeroAtMost<B: IntegerValued>: CountOrder {
    public typealias Left = Never
    public typealias Right = B
}

/// One successor on both sides keeps the order of the previous step.
public enum SuccessorAtMost<P: CountOrder>: CountOrder {
    public typealias Left = Examples.Succ<P.Left>
    public typealias Right = Examples.Succ<P.Right>
}

/// This is the requirement of the projection question: the squared tolerance, counted in a
/// unit of the input power. [A/B AB.3]
public typealias ProjectionTolerance<Unit: Structure, SquaredTolerance: IntegerValued> =
    Paired<Unit, SquaredTolerance>

/// This is one steady reading of the projection question: the held setting at the reading,
/// the three premises, and the readable power counted in a unit of the input power.
/// The question is how much power of the one prepared input reaches the readable ports.
/// The reading is at a frequency of the band, after the longest delay has settled. [A/B AB.3]
public typealias ProjectionDefectReading<
    Setting: Structure, Class: Structure, Precision: Structure, Continuation: Structure,
    Unit: Structure, Power: IntegerValued
> = Paired<Paired<Setting, Paired<Class, Paired<Precision, Continuation>>>, Paired<Unit, Power>>

/// A projection pass is a pass certificate. It names the held setting and the requirement.
///
/// > Important: ``ProjectionDefectPasses`` is the one conformance. A hand-written conformance
/// > admits its setting with no reading at all.
public protocol ProjectionPass: Close {
    associatedtype Setting
    associatedtype Request: Pair
}

/// This is the certificate that the readable power is at most the squared tolerance.
/// The where binds the reading to the requirement in one unit, and the order witness has the
/// power on its left and the squared tolerance on its right. With all three premises the defect
/// is then at most the tolerance at every frequency of the band. [A/B AB.3, R-Q RQ.5]
public enum ProjectionDefectPasses<Requirement: Pair, Reading: Pair, Order: CountOrder>:
    ProjectionPass
where Reading.Left: Pair, Reading.Left.Right: Pair, Reading.Left.Right.Right: Pair,
      Reading.Right: Pair,
      Reading.Left.Right.Left == OneMixerAndDelayBank,
      Reading.Left.Right.Right.Left == ExactReading,
      Reading.Left.Right.Right.Right == SummedPowerContinuation,
      Requirement.Left == Reading.Right.Left,
      Order.Left == Reading.Right.Right,
      Order.Right == Requirement.Right {
    public typealias Setting = Reading.Left.Left
    public typealias Request = Requirement
}

/// This is the refusal: the readable power is above the squared tolerance.
/// The order witness has one count above the squared tolerance on its left and the power on its
/// right. In the stationary one-preparation contract of AB.3 and CK, an exact reading of the
/// prepared input is the squared defect at its frequency, and that frequency is in the band.
/// The band requirement is then refused by this one frequency without the class premise.
/// [R-Q RQ.1, A/B AB.3, CK.3]
public enum ProjectionDefectExceeds<Requirement: Pair, Reading: Pair, Order: CountOrder>: Close
where Reading.Left: Pair, Reading.Left.Right: Pair, Reading.Left.Right.Right: Pair,
      Reading.Right: Pair, Requirement.Right: IntegerValued,
      Reading.Left.Right.Right.Left == ExactReading,
      Reading.Left.Right.Right.Right == SummedPowerContinuation,
      Requirement.Left == Reading.Right.Left,
      Order.Left == Examples.Succ<Requirement.Right>,
      Order.Right == Reading.Right.Right {
    public typealias Setting = Reading.Left.Left
}

/// This admits a held setting for the requested requirement. The where binds both the
/// setting and the requirement to the pass certificate. A refusal, another setting, or a
/// different squared tolerance admits nothing for this request.
public enum HeldSettingAdmitted<Setting, Request: Pair, Certificate: ProjectionPass>: Close
where Certificate.Setting == Setting, Certificate.Request == Request {}

/// This is the device of A/B AB.3 in the class of CK.1: an unknown constant mixer V and a bank
/// of delays 0 and 8 on one of its sides.
/// The tolerance is η = 1/2, so the squared tolerance is 25 hundredths, and the defect
/// β = |V₂₁| has the readable power β². The reading of the first setting is 16 hundredths
/// (β = 2/5), and ``HeldSettingAdmitted`` admits it. The reading of the second is 36 hundredths
/// (β = 3/5), and ``ProjectionDefectExceeds`` refuses it. [A/B AB.3]
///
/// > Note: The whole record is one steady reading per setting. For the same band the
/// > full-symbol rules of A/B AB.3 take 16 and 15 readings, and at β = 2/5 both are unresolved.
public enum ProjectionDefectOutputDelays: Close {
    /// This is the unit of the example: one hundredth of the input power.
    public enum Hundredths: Close {}
    /// These are the two held settings. Their defects 2/5 and 3/5 are unknown to the rule.
    public enum FirstSetting: Close {}
    public enum SecondSetting: Close {}

    public typealias FivePlus<N: IntegerValued> = Examples.Succ<Examples.Succ<Examples.Succ<
        Examples.Succ<Examples.Succ<N>>>>>
    public typealias Five = FivePlus<Never>
    public typealias Nine = Examples.Succ<Examples.Succ<Examples.Succ<Examples.Succ<Five>>>>
    public typealias Ten = FivePlus<Five>
    public typealias Sixteen = Examples.Succ<FivePlus<Ten>>
    public typealias TwentyFive = FivePlus<FivePlus<FivePlus<Ten>>>
    public typealias ThirtySix = Examples.Succ<FivePlus<FivePlus<TwentyFive>>>

    public typealias FiveAtMost<P: CountOrder> = SuccessorAtMost<SuccessorAtMost<
        SuccessorAtMost<SuccessorAtMost<SuccessorAtMost<P>>>>>
    public typealias TwentyFiveAtMost<P: CountOrder> =
        FiveAtMost<FiveAtMost<FiveAtMost<FiveAtMost<FiveAtMost<P>>>>>

    /// The squared tolerance η² = 1/4 is 25 hundredths.
    public typealias Tolerance = ProjectionTolerance<Hundredths, TwentyFive>
    public typealias FirstReading = ProjectionDefectReading<FirstSetting,
        OneMixerAndDelayBank, ExactReading, SummedPowerContinuation, Hundredths, Sixteen>
    public typealias SecondReading = ProjectionDefectReading<SecondSetting,
        OneMixerAndDelayBank, ExactReading, SummedPowerContinuation, Hundredths, ThirtySix>
    public typealias SecondReadingBetweenMixers = ProjectionDefectReading<SecondSetting,
        DelayBetweenMixers, ExactReading, SummedPowerContinuation, Hundredths, ThirtySix>

    /// 16 ≤ 25: sixteen steps above 0 ≤ 9.
    public typealias SixteenAtMostTwentyFive =
        FiveAtMost<FiveAtMost<FiveAtMost<SuccessorAtMost<ZeroAtMost<Nine>>>>>
    /// 26 ≤ 36: twenty-six steps above 0 ≤ 10.
    public typealias TwentySixAtMostThirtySix =
        SuccessorAtMost<TwentyFiveAtMost<ZeroAtMost<Ten>>>

    public typealias FirstPasses =
        ProjectionDefectPasses<Tolerance, FirstReading, SixteenAtMostTwentyFive>
    public typealias FirstAdmitted = HeldSettingAdmitted<FirstSetting, Tolerance, FirstPasses>
    public typealias SecondExceeds =
        ProjectionDefectExceeds<Tolerance, SecondReading, TwentySixAtMostThirtySix>
    /// The same refusal with a delay between two mixers: one exact frequency needs no class.
    public typealias SecondExceedsBetweenMixers =
        ProjectionDefectExceeds<Tolerance, SecondReadingBetweenMixers, TwentySixAtMostThirtySix>
}
