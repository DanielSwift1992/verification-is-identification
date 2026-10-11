import VerificationIsIdentification

// A narrow computed operator profile for the existing equality court.
// Reuses exact CoherentBlock/CoherentIdeal arithmetic. The older full
// CoherentProgram generic conformance is outside that court's current reader.
public protocol JointProfile: Pair {
    associatedtype Block0: CoherentBlock
    associatedtype Block1: CoherentBlock
    associatedtype Ideal: CoherentIdeal
}
public enum JointReturnStart: JointProfile {
    public typealias Left = Never
    public typealias Block0 = CoherentI<CoherentPhase0>
    public typealias Block1 = CoherentI<CoherentPhase0>
    public typealias Ideal = CoherentIdealEmpty
    public typealias Right = Paired<Paired<Block0, Block1>, Ideal.Word>
}
public enum JointCZLabel: Close {}
public enum JointCZ<P: JointProfile>: JointProfile {
    public typealias Left = Paired<JointCZLabel, P>
    public typealias Block0 = P.Block0
    public typealias Block1 = P.Block1.LeftZ
    public typealias Ideal = P.Ideal
    public typealias Right = Paired<Paired<Block0, Block1>, Ideal.Word>
}
public enum JointHLabel: Close {}
public enum JointH<P: JointProfile>: JointProfile {
    public typealias Left = Paired<JointHLabel, P>
    public typealias Block0 = P.Block0.ConjugatedH
    public typealias Block1 = P.Block1.ConjugatedH
    public typealias Ideal = P.Ideal.AfterH
    public typealias Right = Paired<Paired<Block0, Block1>, Ideal.Word>
}
public enum JointSLabel: Close {}
public enum JointS<P: JointProfile>: JointProfile {
    public typealias Left = Paired<JointSLabel, P>
    public typealias Block0 = P.Block0.ConjugatedS
    public typealias Block1 = P.Block1.ConjugatedS
    public typealias Ideal = P.Ideal.AfterS
    public typealias Right = Paired<Paired<Block0, Block1>, Ideal.Word>
}
public enum JointMemorySLabel: Close {}
public enum JointMemoryS<P: JointProfile>: JointProfile {
    public typealias Left = Paired<JointMemorySLabel, P>
    public typealias Block0 = P.Block0
    public typealias Block1 = P.Block1.TimesI
    public typealias Ideal = P.Ideal
    public typealias Right = Paired<Paired<Block0, Block1>, Ideal.Word>
}

// One actual D,E operator pair, not two separately calibrated D channels.
public typealias JointKeepA<P: JointProfile> = JointCZ<P>
public typealias JointKeepB<P: JointProfile> = P
public typealias JointMovingA<P: JointProfile> = JointMemoryS<JointCZ<P>>
public typealias JointMovingB<P: JointProfile> = JointMemoryS<P>

public enum JointKeep: Close {}
public enum JointMoving: Close {}
public enum JointBetweenPairs: Close {}
public enum JointEveryCall: Close {}

// Eight-bit unsigned numerator/denominator, most significant bit first.
// These declare a simulated full-DE convex-mixture construction, not a
// confidence interval or an empirical statement about physical hardware.
public enum JointRateZero: Pair {
    public typealias Left = Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Never>>>>>>>>
    public typealias Right = Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit1, Never>>>>>>>>
}
public enum JointRateFast: Pair {
    public typealias Left = Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit1, Never>>>>>>>>
    public typealias Right = Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit1, Paired<QBit1, Paired<QBit0, Paired<QBit0, Paired<QBit1, Never>>>>>>>>
}
public enum JointRateProtected: Pair {
    public typealias Left = Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit1, Never>>>>>>>>
    public typealias Right = Paired<QBit1, Paired<QBit1, Paired<QBit0, Paired<QBit0, Paired<QBit1, Paired<QBit0, Paired<QBit0, Paired<QBit0, Never>>>>>>>>
}
public enum JointRateAlways: Pair {
    public typealias Left = Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit1, Never>>>>>>>>
    public typealias Right = Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit1, Never>>>>>>>>
}
public enum JointOfferKeep: Pair {
    public typealias Left = JointKeep
    public typealias Right = Paired<JointBetweenPairs, JointRateZero>
    public typealias Cost = Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit1, Paired<QBit1, Paired<QBit0, Never>>>>>>>>
}
public enum JointOfferMoving: Pair {
    public typealias Left = JointMoving
    public typealias Right = Paired<JointBetweenPairs, JointRateZero>
    public typealias Cost = Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit1, Paired<QBit0, Paired<QBit0, Paired<QBit0, Never>>>>>>>>
}
public enum JointOfferFast: Pair {
    public typealias Left = JointKeep
    public typealias Right = Paired<JointBetweenPairs, JointRateFast>
    public typealias Cost = Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit1, Paired<QBit1, Paired<QBit0, Never>>>>>>>>
}
public enum JointOfferProtected: Pair {
    public typealias Left = JointKeep
    public typealias Right = Paired<JointBetweenPairs, JointRateProtected>
    public typealias Cost = Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit1, Paired<QBit0, Paired<QBit1, Paired<QBit0, Never>>>>>>>>
}
public enum JointOfferReplace: Pair {
    public typealias Left = JointKeep
    public typealias Right = Paired<JointEveryCall, JointRateAlways>
    public typealias Cost = Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit0, Paired<QBit1, Never>>>>>>>>
}
