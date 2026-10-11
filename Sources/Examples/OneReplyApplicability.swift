import VerificationIsIdentification

/// A fixed finite reading: accept exactly the recorded label 1. Its
/// commutation meaning is supplied by the A4 calibration below, not by
/// the marker value or by arbitrary PredicateReading conformances.
public typealias FixedPointReply<F: HasVerdict & Structure,
    L: PredicateReading> = SequentialReading<
        ReadingBesideInput<ReadRecordedAnswer<F>, FourLeafPhaseMark1>, L>
where F.Answer: Structure, F.Sigma == BeamSpace,
      F.Encoding == SaturationEncoding,
      L.Left == Paired<F.Answer, FourLeafPhaseMark1>,
      L.Sigma == BeamSpace, L.Encoding == SaturationEncoding

/// Execute the already constructed resident point probe, read only its
/// acquired fact beside the fixed table, then retain the computed answer
/// beside the whole resulting experiment. There is no hidden-law argument
/// in the decoder input.
public enum OneReplyDecision<P: PredicateReading, L: PredicateReading>: Pair
where P.Left: Structure, P.Answer: Pair,
      P.Answer.Right: HasVerdict & Structure, P.Answer.Right.Answer: Structure,
      P.Answer.Right.Sigma == BeamSpace, P.Answer.Right.Encoding == SaturationEncoding,
      L.Left == Paired<P.Answer.Right.Answer, FourLeafPhaseMark1>,
      L.Sigma == BeamSpace, L.Encoding == SaturationEncoding {
    public typealias Run = StepBeside<P, FourLeafPhaseMark1>
    public typealias Observation = ExperimentReadingBeside<
        SecondEvidenceImage<P.Answer, BeamSpace, SaturationEncoding, SecondProjection>,
        FourLeafPhaseMark1>
    public typealias Decode = FixedPointReply<P.Answer.Right, L>
    public typealias Read = SequentialReading<Observation, Decode>
    public typealias Record = RecordReading<Read>
    public typealias Actual = FollowedPair<Run, Record>
    public typealias Left = Actual.Left
    public typealias Right = Actual.Right
    public enum KeepsExperiment: Null {
        public typealias Left = OneReplyDecision.Right.Left
        public typealias Right = Run.Right
    }
}

/// Reuse the existing phase-1 resident preparation and U acquisitions for
/// all twelve unknown even laws. It is called SecondProbe in the older
/// two-probe experiment; here it is the only probe being acquired.
public enum EvenFrameApplicability: Close {
    public typealias P = FourLeafSecondProbe<Never>
    public typealias I = OneReplyDecision<P.I, Route01<FourLeafPhaseMark1>>
    public typealias W = OneReplyDecision<P.W, Route01<FourLeafPhaseMark1>>
    public typealias WW = OneReplyDecision<P.WW, Route01<FourLeafPhaseMark1>>
    public typealias Z = OneReplyDecision<P.Z, Route00<FourLeafPhaseMark1>>
    public typealias ZW = OneReplyDecision<P.ZW, Route10<FourLeafPhaseMark1>>
    public typealias ZWW = OneReplyDecision<P.ZWW, Route11<FourLeafPhaseMark1>>
    public typealias WZ = OneReplyDecision<P.WZ, Route00<FourLeafPhaseMark1>>
    public typealias WZW = OneReplyDecision<P.WZW, Route10<FourLeafPhaseMark1>>
    public typealias WZWW = OneReplyDecision<P.WZWW, Route11<FourLeafPhaseMark1>>
    public typealias WWZ = OneReplyDecision<P.WWZ, Route00<FourLeafPhaseMark1>>
    public typealias WWZW = OneReplyDecision<P.WWZW, Route10<FourLeafPhaseMark1>>
    public typealias WWZWW = OneReplyDecision<P.WWZWW, Route11<FourLeafPhaseMark1>>
    public enum ResidentLawsRemain: Null {
        public typealias Left = BoundaryWorking<Paired<Paired<I.Left.Left.Right.Right.Right.Left, I.Right.Left.Left.Left.Right.Right.Right.Left>, Paired<Paired<W.Left.Left.Right.Right.Right.Left, W.Right.Left.Left.Left.Right.Right.Right.Left>, Paired<WW.Left.Left.Right.Right.Right.Left, WW.Right.Left.Left.Left.Right.Right.Right.Left>>>, Paired<Paired<Z.Left.Left.Right.Right.Right.Left, Z.Right.Left.Left.Left.Right.Right.Right.Left>, Paired<Paired<ZW.Left.Left.Right.Right.Right.Left, ZW.Right.Left.Left.Left.Right.Right.Right.Left>, Paired<ZWW.Left.Left.Right.Right.Right.Left, ZWW.Right.Left.Left.Left.Right.Right.Right.Left>>>, Paired<Paired<WZ.Left.Left.Right.Right.Right.Left, WZ.Right.Left.Left.Left.Right.Right.Right.Left>, Paired<Paired<WZW.Left.Left.Right.Right.Right.Left, WZW.Right.Left.Left.Left.Right.Right.Right.Left>, Paired<WZWW.Left.Left.Right.Right.Right.Left, WZWW.Right.Left.Left.Left.Right.Right.Right.Left>>>, Paired<Paired<WWZ.Left.Left.Right.Right.Right.Left, WWZ.Right.Left.Left.Left.Right.Right.Right.Left>, Paired<Paired<WWZW.Left.Left.Right.Right.Right.Left, WWZW.Right.Left.Left.Left.Right.Right.Right.Left>, Paired<WWZWW.Left.Left.Right.Right.Right.Left, WWZWW.Right.Left.Left.Left.Right.Right.Right.Left>>>>
        public typealias Right = BoundaryWorking<Paired<Paired<FourLeafLawAddresses.I, FourLeafLawAddresses.I>, Paired<Paired<FourLeafLawAddresses.W, FourLeafLawAddresses.W>, Paired<FourLeafLawAddresses.WW, FourLeafLawAddresses.WW>>>, Paired<Paired<FourLeafLawAddresses.Z, FourLeafLawAddresses.Z>, Paired<Paired<FourLeafLawAddresses.ZW, FourLeafLawAddresses.ZW>, Paired<FourLeafLawAddresses.ZWW, FourLeafLawAddresses.ZWW>>>, Paired<Paired<FourLeafLawAddresses.WZ, FourLeafLawAddresses.WZ>, Paired<Paired<FourLeafLawAddresses.WZW, FourLeafLawAddresses.WZW>, Paired<FourLeafLawAddresses.WZWW, FourLeafLawAddresses.WZWW>>>, Paired<Paired<FourLeafLawAddresses.WWZ, FourLeafLawAddresses.WWZ>, Paired<Paired<FourLeafLawAddresses.WWZW, FourLeafLawAddresses.WWZW>, Paired<FourLeafLawAddresses.WWZWW, FourLeafLawAddresses.WWZWW>>>>
    }
    public enum SamePositiveEvidence: Null {
        public typealias Left = Paired<I.Decode.Left, W.Decode.Left>
        public typealias Right = Paired<WW.Decode.Left, WW.Decode.Left>
    }
    public enum Verdicts: Null {
        public typealias Left = BoundaryWorking<
            Paired<I.Read.Answer, Paired<W.Read.Answer, WW.Read.Answer>>,
            Paired<Z.Read.Answer, Paired<ZW.Read.Answer, ZWW.Read.Answer>>,
            Paired<WZ.Read.Answer, Paired<WZW.Read.Answer, WZWW.Read.Answer>>,
            Paired<WWZ.Read.Answer, Paired<WWZW.Read.Answer, WWZWW.Read.Answer>>>
        public typealias Yes = Paired<Lit1, Paired<Lit1, Lit1>>
        public typealias No = Paired<Never, Paired<Never, Never>>
        public typealias Right = BoundaryWorking<Yes, No, No, No>
    }
}

/// Independently compose each actual word with W in both orders.
/// The three pure words commute on all payloads. Each other row gives
/// the displayed second-field disagreement on distinct marker inputs.
public enum EvenFrameCommutation<A: Structure, B: Structure,
    C: Structure, D: Structure>: Close {
    public typealias F = PhaseWordCatalogue<A, B, C, D>
    public typealias AfterW = PhaseWordCatalogue<D, B, A, C>
    public typealias LeftI = FollowedPair<F.I, FourLeafPhaseWord<A, B, C, D>>
    public typealias RightI = FollowedPair<F.W, AfterW.I>
    public typealias LeftW = FollowedPair<F.W, FourLeafPhaseWord<D, B, A, C>>
    public typealias RightW = FollowedPair<F.W, AfterW.W>
    public typealias LeftWW = FollowedPair<F.WW, FourLeafPhaseWord<C, B, D, A>>
    public typealias RightWW = FollowedPair<F.W, AfterW.WW>
    public typealias LeftZ = FollowedPair<F.Z, FourLeafPhaseWord<B, A, D, C>>
    public typealias RightZ = FollowedPair<F.W, AfterW.Z>
    public typealias LeftZW = FollowedPair<F.ZW, FourLeafPhaseWord<C, A, B, D>>
    public typealias RightZW = FollowedPair<F.W, AfterW.ZW>
    public typealias LeftZWW = FollowedPair<F.ZWW, FourLeafPhaseWord<D, A, C, B>>
    public typealias RightZWW = FollowedPair<F.W, AfterW.ZWW>
    public typealias LeftWZ = FollowedPair<F.WZ, FourLeafPhaseWord<B, D, C, A>>
    public typealias RightWZ = FollowedPair<F.W, AfterW.WZ>
    public typealias LeftWZW = FollowedPair<F.WZW, FourLeafPhaseWord<A, D, B, C>>
    public typealias RightWZW = FollowedPair<F.W, AfterW.WZW>
    public typealias LeftWZWW = FollowedPair<F.WZWW, FourLeafPhaseWord<C, D, A, B>>
    public typealias RightWZWW = FollowedPair<F.W, AfterW.WZWW>
    public typealias LeftWWZ = FollowedPair<F.WWZ, FourLeafPhaseWord<B, C, A, D>>
    public typealias RightWWZ = FollowedPair<F.W, AfterW.WWZ>
    public typealias LeftWWZW = FollowedPair<F.WWZW, FourLeafPhaseWord<D, C, B, A>>
    public typealias RightWWZW = FollowedPair<F.W, AfterW.WWZW>
    public typealias LeftWWZWW = FollowedPair<F.WWZWW, FourLeafPhaseWord<A, C, D, B>>
    public typealias RightWWZWW = FollowedPair<F.W, AfterW.WWZWW>
    public enum PureCommutes: Null {
        public typealias Left = AddressTriple<LeftI.Right, LeftW.Right, LeftWW.Right>
        public typealias Right = AddressTriple<RightI.Right, RightW.Right, RightWW.Right>
    }
    public enum OtherWitnesses: Null {
        public typealias Left = AddressTriple<AddressTriple<Paired<LeftZ.Right.Left.Right, RightZ.Right.Left.Right>, Paired<LeftZW.Right.Left.Right, RightZW.Right.Left.Right>, Paired<LeftZWW.Right.Left.Right, RightZWW.Right.Left.Right>>, AddressTriple<Paired<LeftWZ.Right.Left.Right, RightWZ.Right.Left.Right>, Paired<LeftWZW.Right.Left.Right, RightWZW.Right.Left.Right>, Paired<LeftWZWW.Right.Left.Right, RightWZWW.Right.Left.Right>>, AddressTriple<Paired<LeftWWZ.Right.Left.Right, RightWWZ.Right.Left.Right>, Paired<LeftWWZW.Right.Left.Right, RightWWZW.Right.Left.Right>, Paired<LeftWWZWW.Right.Left.Right, RightWWZWW.Right.Left.Right>>>
        public typealias ZGroup = AddressTriple<Paired<A, D>, Paired<A, D>, Paired<A, D>>
        public typealias OneGroup = AddressTriple<Paired<D, C>, Paired<D, C>, Paired<D, C>>
        public typealias TwoGroup = AddressTriple<Paired<C, A>, Paired<C, A>, Paired<C, A>>
        public typealias Right = AddressTriple<ZGroup, OneGroup, TwoGroup>
    }
}
