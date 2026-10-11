import VerificationIsIdentification

/// Run the supplied word, then the actual resident contact, then record its
/// visible stage. All three sources meet. Only the final stage reading enters
/// FactOf; neither the word's expression nor its hidden source is a fact field.
/// The four aliases below use the fixed U rows and marker calibrations.
public enum FourLeafPointProbe<F: PredicateReading, U: PredicateReading,
                               R: PredicateReading>: PredicateReading
where F.Left: Structure, F.Answer == U.Left,
      U.Answer: Pair, U.Answer.Left: Pair, R.Left == U.Answer.Left.Right,
      F.Sigma == BeamSpace, U.Sigma == BeamSpace, R.Sigma == BeamSpace,
      F.Encoding == SaturationEncoding, U.Encoding == SaturationEncoding,
      R.Encoding == SaturationEncoding {
    public typealias Stage = FourLeafStageAddress<U.Answer, R>
    public typealias Record = RetainingRecordedReading<Stage>
    public typealias Path = FollowedPair<FollowedPair<F, U>, Record>
    public typealias Left = F.Left
    public typealias Right = Paired<U.Answer, FactOf<Stage>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Path.Predicate
    public typealias Answer = Right
    public enum Endpoints: Null {
        public typealias Left = Paired<FourLeafPointProbe.Left, FourLeafPointProbe.Right>
        public typealias Right = Paired<Path.Left, Path.Answer>
    }
}

public typealias FourLeafProbe0<F: PredicateReading, K: Structure> = FourLeafPointProbe<
    F, FourLeafSelected0<K>, FourLeafMarked0>
where F.Left: Structure, F.Answer == FourLeafSelected0<K>.Left,
      F.Sigma == BeamSpace, F.Encoding == SaturationEncoding
public typealias FourLeafProbe1<F: PredicateReading, K: Structure> = FourLeafPointProbe<
    F, FourLeafSelected1<K>, FourLeafMarked1>
where F.Left: Structure, F.Answer == FourLeafSelected1<K>.Left,
      F.Sigma == BeamSpace, F.Encoding == SaturationEncoding
public typealias FourLeafProbe2<F: PredicateReading, K: Structure> = FourLeafPointProbe<
    F, FourLeafSelected2<K>, FourLeafMarked2>
where F.Left: Structure, F.Answer == FourLeafSelected2<K>.Left,
      F.Sigma == BeamSpace, F.Encoding == SaturationEncoding
public typealias FourLeafProbe3<F: PredicateReading, K: Structure> = FourLeafPointProbe<
    F, FourLeafSelected3<K>, FourLeafMarked3>
where F.Left: Structure, F.Answer == FourLeafSelected3<K>.Left,
      F.Sigma == BeamSpace, F.Encoding == SaturationEncoding

/// Each first probe starts at the prepared center/phase 0, with a word
/// address resident in its source. R is arbitrary carried laboratory context.
public enum FourLeafFirstProbe<R: Structure>: Close {
    public typealias Words = FourLeafLawApplications<Lit1, Never, Never, Never, R>
    public typealias I = FourLeafProbe0<Words.I, Words.I.Answer.Right.Right.Right>
    public typealias W = FourLeafProbe2<Words.W, Words.W.Answer.Right.Right.Right>
    public typealias WW = FourLeafProbe3<Words.WW, Words.WW.Answer.Right.Right.Right>
    public typealias Z = FourLeafProbe1<Words.Z, Words.Z.Answer.Right.Right.Right>
    public typealias ZW = FourLeafProbe1<Words.ZW, Words.ZW.Answer.Right.Right.Right>
    public typealias ZWW = FourLeafProbe1<Words.ZWW, Words.ZWW.Answer.Right.Right.Right>
    public typealias WZ = FourLeafProbe3<Words.WZ, Words.WZ.Answer.Right.Right.Right>
    public typealias WZW = FourLeafProbe0<Words.WZW, Words.WZW.Answer.Right.Right.Right>
    public typealias WZWW = FourLeafProbe2<Words.WZWW, Words.WZWW.Answer.Right.Right.Right>
    public typealias WWZ = FourLeafProbe2<Words.WWZ, Words.WWZ.Answer.Right.Right.Right>
    public typealias WWZW = FourLeafProbe3<Words.WWZW, Words.WWZW.Answer.Right.Right.Right>
    public typealias WWZWW = FourLeafProbe0<Words.WWZWW, Words.WWZWW.Answer.Right.Right.Right>
}

/// The other prepared input is center/phase 1. This family alone does not
/// assert that these probes follow the first ones: the actual focus transition
/// must supply this preparation and the same retained law context.
public enum FourLeafSecondProbe<R: Structure>: Close {
    public typealias Words = FourLeafLawApplications<Never, Lit1, Never, Never, R>
    public typealias I = FourLeafProbe1<Words.I, Words.I.Answer.Right.Right.Right>
    public typealias W = FourLeafProbe1<Words.W, Words.W.Answer.Right.Right.Right>
    public typealias WW = FourLeafProbe1<Words.WW, Words.WW.Answer.Right.Right.Right>
    public typealias Z = FourLeafProbe0<Words.Z, Words.Z.Answer.Right.Right.Right>
    public typealias ZW = FourLeafProbe2<Words.ZW, Words.ZW.Answer.Right.Right.Right>
    public typealias ZWW = FourLeafProbe3<Words.ZWW, Words.ZWW.Answer.Right.Right.Right>
    public typealias WZ = FourLeafProbe0<Words.WZ, Words.WZ.Answer.Right.Right.Right>
    public typealias WZW = FourLeafProbe2<Words.WZW, Words.WZW.Answer.Right.Right.Right>
    public typealias WZWW = FourLeafProbe3<Words.WZWW, Words.WZWW.Answer.Right.Right.Right>
    public typealias WWZ = FourLeafProbe0<Words.WWZ, Words.WWZ.Answer.Right.Right.Right>
    public typealias WWZW = FourLeafProbe2<Words.WWZW, Words.WWZW.Answer.Right.Right.Right>
    public typealias WWZWW = FourLeafProbe3<Words.WWZWW, Words.WWZWW.Answer.Right.Right.Right>
}
