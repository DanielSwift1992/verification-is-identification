import VerificationIsIdentification

/// Ordinary one-qubit channel composition. Signed X/Z images determine a
/// Clifford channel, not a phase-sensitive controlled invocation of it.
/// The generic input is the preceding derived profile, never a desired answer.
public protocol RoutedProfile: Pair {
    associatedtype OnX: CoherentBlock
    associatedtype OnZ: CoherentBlock
}
public enum RoutedStart: RoutedProfile {
    public typealias Left = Never
    public typealias OnX = CoherentX<CoherentPhase0>
    public typealias OnZ = CoherentZ<CoherentPhase0>
    public typealias Right = Paired<OnX, OnZ>
}
public enum RoutedHLabel: Close {}
public enum RoutedSLabel: Close {}

public enum RoutedH<P: RoutedProfile>: RoutedProfile {
    public typealias Left = Paired<RoutedHLabel, P>
    public typealias OnX = P.OnX.ConjugatedH
    public typealias OnZ = P.OnZ.ConjugatedH
    public typealias Right = Paired<OnX, OnZ>
}

public enum RoutedS<P: RoutedProfile>: RoutedProfile {
    public typealias Left = Paired<RoutedSLabel, P>
    public typealias OnX = P.OnX.ConjugatedS
    public typealias OnZ = P.OnZ.ConjugatedS
    public typealias Right = Paired<OnX, OnZ>
}

public enum RoutedI<P: RoutedProfile>: RoutedProfile {
    public typealias Left = Paired<QI, P>
    public typealias OnX = P.OnX
    public typealias OnZ = P.OnZ
    public typealias Right = Paired<OnX, OnZ>
}

public enum RoutedX<P: RoutedProfile>: RoutedProfile {
    public typealias Left = Paired<QX, P>
    public typealias OnX = P.OnX.ConjugatedH.ConjugatedS.ConjugatedS.ConjugatedH
    public typealias OnZ = P.OnZ.ConjugatedH.ConjugatedS.ConjugatedS.ConjugatedH
    public typealias Right = Paired<OnX, OnZ>
}

public enum RoutedY<P: RoutedProfile>: RoutedProfile {
    public typealias Left = Paired<QY, P>
    public typealias OnX = P.OnX.ConjugatedS.ConjugatedS.ConjugatedH.ConjugatedS.ConjugatedS.ConjugatedH
    public typealias OnZ = P.OnZ.ConjugatedS.ConjugatedS.ConjugatedH.ConjugatedS.ConjugatedS.ConjugatedH
    public typealias Right = Paired<OnX, OnZ>
}

public enum RoutedZ<P: RoutedProfile>: RoutedProfile {
    public typealias Left = Paired<QZ, P>
    public typealias OnX = P.OnX.ConjugatedS.ConjugatedS
    public typealias OnZ = P.OnZ.ConjugatedS.ConjugatedS
    public typealias Right = Paired<OnX, OnZ>
}

