import VerificationIsIdentification

// Exact external controls on the existing computed joint profile.
// These do not reset E or enter the unknown A/B module as a classical input.
public enum WholeWordXLabel: Close {}
public enum WholeWordYLabel: Close {}
public enum WholeWordZLabel: Close {}
public enum WholeWordX<P: JointProfile>: JointProfile {
    public typealias Left = Paired<WholeWordXLabel, P>
    public typealias Block0 = P.Block0.LeftX
    public typealias Block1 = P.Block1.LeftX
    public typealias Ideal = P.Ideal
    public typealias Right = Paired<Paired<Block0, Block1>, Ideal.Word>
}
public enum WholeWordY<P: JointProfile>: JointProfile {
    public typealias Left = Paired<WholeWordYLabel, P>
    public typealias Block0 = P.Block0.LeftZ.LeftX.TimesI
    public typealias Block1 = P.Block1.LeftZ.LeftX.TimesI
    public typealias Ideal = P.Ideal
    public typealias Right = Paired<Paired<Block0, Block1>, Ideal.Word>
}
public enum WholeWordZ<P: JointProfile>: JointProfile {
    public typealias Left = Paired<WholeWordZLabel, P>
    public typealias Block0 = P.Block0.LeftZ
    public typealias Block1 = P.Block1.LeftZ
    public typealias Ideal = P.Ideal
    public typealias Right = Paired<Paired<Block0, Block1>, Ideal.Word>
}
// Used only to compare ordinary channels. A coherent superposition of routes
// would also have to preserve this phase; no such access is exported here.
public enum WholeWordNegated<P: JointProfile>: JointProfile {
    public typealias Left = P.Left
    public typealias Block0 = P.Block0.TimesI.TimesI
    public typealias Block1 = P.Block1.TimesI.TimesI
    public typealias Ideal = P.Ideal
    public typealias Right = Paired<Paired<Block0, Block1>, Ideal.Word>
}
