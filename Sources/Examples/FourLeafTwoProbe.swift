import VerificationIsIdentification

/// Each complete path shares one resident law address across its two probes.
/// The first source already includes its prepared reserve; the focus uses
/// that reserve and retains the first probe and fact in the second context.
public enum FourLeafTwoProbe: Close {
    public typealias First = FourLeafFirstProbe<FourLeafPreparedReserve<Never>>

    public typealias FocusI = FourLeafReserveFocus<First.I.Answer.Left.Left,
        First.I.Answer.Left.Right.Left, FourLeafLawAddresses.I, Never, First.I.Answer.Right>
    public typealias FocusW = FourLeafReserveFocus<First.W.Answer.Left.Left,
        First.W.Answer.Left.Right.Left, FourLeafLawAddresses.W, Never, First.W.Answer.Right>
    public typealias FocusWW = FourLeafReserveFocus<First.WW.Answer.Left.Left,
        First.WW.Answer.Left.Right.Left, FourLeafLawAddresses.WW, Never, First.WW.Answer.Right>
    public typealias FocusZ = FourLeafReserveFocus<First.Z.Answer.Left.Left,
        First.Z.Answer.Left.Right.Left, FourLeafLawAddresses.Z, Never, First.Z.Answer.Right>
    public typealias FocusZW = FourLeafReserveFocus<First.ZW.Answer.Left.Left,
        First.ZW.Answer.Left.Right.Left, FourLeafLawAddresses.ZW, Never, First.ZW.Answer.Right>
    public typealias FocusZWW = FourLeafReserveFocus<First.ZWW.Answer.Left.Left,
        First.ZWW.Answer.Left.Right.Left, FourLeafLawAddresses.ZWW, Never, First.ZWW.Answer.Right>
    public typealias FocusWZ = FourLeafReserveFocus<First.WZ.Answer.Left.Left,
        First.WZ.Answer.Left.Right.Left, FourLeafLawAddresses.WZ, Never, First.WZ.Answer.Right>
    public typealias FocusWZW = FourLeafReserveFocus<First.WZW.Answer.Left.Left,
        First.WZW.Answer.Left.Right.Left, FourLeafLawAddresses.WZW, Never, First.WZW.Answer.Right>
    public typealias FocusWZWW = FourLeafReserveFocus<First.WZWW.Answer.Left.Left,
        First.WZWW.Answer.Left.Right.Left, FourLeafLawAddresses.WZWW, Never, First.WZWW.Answer.Right>
    public typealias FocusWWZ = FourLeafReserveFocus<First.WWZ.Answer.Left.Left,
        First.WWZ.Answer.Left.Right.Left, FourLeafLawAddresses.WWZ, Never, First.WWZ.Answer.Right>
    public typealias FocusWWZW = FourLeafReserveFocus<First.WWZW.Answer.Left.Left,
        First.WWZW.Answer.Left.Right.Left, FourLeafLawAddresses.WWZW, Never, First.WWZW.Answer.Right>
    public typealias FocusWWZWW = FourLeafReserveFocus<First.WWZWW.Answer.Left.Left,
        First.WWZWW.Answer.Left.Right.Left, FourLeafLawAddresses.WWZWW, Never, First.WWZWW.Answer.Right>

    public typealias SecondI = FourLeafSecondProbe<FocusI.OutputLab>.I
    public typealias SecondW = FourLeafSecondProbe<FocusW.OutputLab>.W
    public typealias SecondWW = FourLeafSecondProbe<FocusWW.OutputLab>.WW
    public typealias SecondZ = FourLeafSecondProbe<FocusZ.OutputLab>.Z
    public typealias SecondZW = FourLeafSecondProbe<FocusZW.OutputLab>.ZW
    public typealias SecondZWW = FourLeafSecondProbe<FocusZWW.OutputLab>.ZWW
    public typealias SecondWZ = FourLeafSecondProbe<FocusWZ.OutputLab>.WZ
    public typealias SecondWZW = FourLeafSecondProbe<FocusWZW.OutputLab>.WZW
    public typealias SecondWZWW = FourLeafSecondProbe<FocusWZWW.OutputLab>.WZWW
    public typealias SecondWWZ = FourLeafSecondProbe<FocusWWZ.OutputLab>.WWZ
    public typealias SecondWWZW = FourLeafSecondProbe<FocusWWZW.OutputLab>.WWZW
    public typealias SecondWWZWW = FourLeafSecondProbe<FocusWWZWW.OutputLab>.WWZWW

    public typealias I = FollowedPair<FollowedPair<First.I, FocusI>, SecondI>
    public typealias W = FollowedPair<FollowedPair<First.W, FocusW>, SecondW>
    public typealias WW = FollowedPair<FollowedPair<First.WW, FocusWW>, SecondWW>
    public typealias Z = FollowedPair<FollowedPair<First.Z, FocusZ>, SecondZ>
    public typealias ZW = FollowedPair<FollowedPair<First.ZW, FocusZW>, SecondZW>
    public typealias ZWW = FollowedPair<FollowedPair<First.ZWW, FocusZWW>, SecondZWW>
    public typealias WZ = FollowedPair<FollowedPair<First.WZ, FocusWZ>, SecondWZ>
    public typealias WZW = FollowedPair<FollowedPair<First.WZW, FocusWZW>, SecondWZW>
    public typealias WZWW = FollowedPair<FollowedPair<First.WZWW, FocusWZWW>, SecondWZWW>
    public typealias WWZ = FollowedPair<FollowedPair<First.WWZ, FocusWWZ>, SecondWWZ>
    public typealias WWZW = FollowedPair<FollowedPair<First.WWZW, FocusWWZW>, SecondWWZW>
    public typealias WWZWW = FollowedPair<FollowedPair<First.WWZWW, FocusWWZWW>, SecondWWZWW>
}

/// Read the two actual final fact slots. The first is parked with its old
/// probe inside the current lab; the second is beside the current whole.
/// Full paths remain in the question, and neither source nor law is returned.
public enum FourLeafInquiryFacts<W: Pair>: PredicateReading
where W.Left: Pair, W.Left.Right: Pair, W.Left.Right.Right: Pair,
      W.Left.Right.Right.Right: Pair, W.Left.Right.Right.Right.Right: Pair,
      W.Left.Right.Right.Right.Right.Right: Pair,
      W.Left.Right.Right.Right.Right.Right.Left: Pair,
      W.Left.Right.Right.Right.Right.Right.Left.Right: Structure, W.Right: Structure {
    public typealias Current = FirstEvidenceImage<W, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Tail = SequentialReading<Current,
        SecondEvidenceImage<Current.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Context = SequentialReading<Tail,
        SecondEvidenceImage<Tail.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias LawFields = SequentialReading<Context,
        SecondEvidenceImage<Context.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias SelectorAndLab = SequentialReading<LawFields,
        SecondEvidenceImage<LawFields.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Lab = SequentialReading<SelectorAndLab,
        SecondEvidenceImage<SelectorAndLab.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Old = SequentialReading<Lab,
        FirstEvidenceImage<Lab.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias FirstFact = SequentialReading<Old,
        SecondEvidenceImage<Old.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias SecondFact = SecondEvidenceImage<W, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Actual = JointEvidence<FirstFact, SecondFact>
    public typealias Left = W
    public typealias Right = Paired<W.Left.Right.Right.Right.Right.Right.Left.Right, W.Right>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Actual.Answer
}
