import VerificationIsIdentification

/// Two actual point acquisitions plus three resident anchors supply the
/// node packet. There is no separately supplied copy of either reply.
public enum ProbePairWitnessNodes<P: PredicateReading, Q: PredicateReading,
    T: Structure>: Pair
where P.Left: Structure, Q.Left: Structure, P.Answer: Pair, Q.Answer: Pair,
      P.Answer.Right: HasVerdict & Structure, Q.Answer.Right: HasVerdict & Structure,
      P.Answer.Right.Answer: Structure, Q.Answer.Right.Answer: Structure,
      P.Sigma == BeamSpace, Q.Sigma == BeamSpace,
      P.Encoding == SaturationEncoding, Q.Encoding == SaturationEncoding,
      P.Answer.Right.Sigma == BeamSpace, Q.Answer.Right.Sigma == BeamSpace,
      P.Answer.Right.Encoding == SaturationEncoding, Q.Answer.Right.Encoding == SaturationEncoding {
    public typealias Probes = PairedApplication<P, Q>
    public typealias Run = StepBeside<Probes, T>
    public typealias Both = FirstEvidenceImage<Run.Right, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias FirstProbe = SequentialReading<Both,
        FirstEvidenceImage<Probes.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias SecondProbe = SequentialReading<Both,
        SecondEvidenceImage<Probes.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias FirstFact = SequentialReading<FirstProbe,
        SecondEvidenceImage<P.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias SecondFact = SequentialReading<SecondProbe,
        SecondEvidenceImage<Q.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias A = SequentialReading<FirstFact, ReadRecordedAnswer<P.Answer.Right>>
    public typealias B = SequentialReading<SecondFact, ReadRecordedAnswer<Q.Answer.Right>>
    public typealias Targets = SecondEvidenceImage<Run.Right, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Reading = JointEvidence<JointEvidence<A, B>, Targets>
    public typealias Record = RecordReading<Reading>
    public typealias Actual = FollowedPair<Run, Record>
    public typealias Left = Actual.Left
    public typealias Right = Actual.Right
}

public typealias DistinctFrameNodes = ProbePairWitnessNodes<
    FourLeafSecondProbe<Never>.ZWW, FourLeafSecondProbe<Never>.WZWW,
    AddressTriple<RoutingAddress00, RoutingAddress01, RoutingAddress10>>

// These are the same nine edge clauses at a different actual node record.
// Their function tables are reused. Keeping this finite clause explicit
// avoids the compiler's unsupported recursion on a generic nine-edge join.
public enum EncodedDistinctFrameWitness: Close {

    public typealias AcquireNodes = DistinctFrameNodes
    public typealias Fact = AcquireNodes.Right.Right
    public typealias C0 = EncodedFullWitness.C0
    public typealias C1 = EncodedFullWitness.C1
    public typealias C2 = EncodedFullWitness.C2
    public typealias C3 = EncodedFullWitness.C3
    public typealias C4 = EncodedFullWitness.C4
    public typealias C5 = EncodedFullWitness.C5
    public typealias C6 = EncodedFullWitness.C6
    public typealias C7 = EncodedFullWitness.C7
    public typealias C8 = EncodedFullWitness.C8
    public typealias Frames = AddressTriple<AddressTriple<C0, C1, C2>,
        AddressTriple<C3, C4, C5>, AddressTriple<C6, C7, C8>>
    public typealias Resources = Paired<Frames, EchoBitEquality>
    public typealias N = WitnessNodeReadings<Fact, Resources>
    public typealias FramesRead = SequentialReading<N.Resources,
        FirstEvidenceImage<Resources, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Eq = SequentialReading<N.Resources,
        SecondEvidenceImage<Resources, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias G0 = SequentialReading<FramesRead,
        FirstEvidenceImage<Frames, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias GTail = SequentialReading<FramesRead,
        SecondEvidenceImage<Frames, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias G1 = SequentialReading<GTail,
        FirstEvidenceImage<GTail.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias G2 = SequentialReading<GTail,
        SecondEvidenceImage<GTail.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Tail0 = SequentialReading<G0, SecondEvidenceImage<G0.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Frame0 = SequentialReading<G0, FirstEvidenceImage<G0.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Frame1 = SequentialReading<Tail0, FirstEvidenceImage<Tail0.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Frame2 = SequentialReading<Tail0, SecondEvidenceImage<Tail0.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Tail1 = SequentialReading<G1, SecondEvidenceImage<G1.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Frame3 = SequentialReading<G1, FirstEvidenceImage<G1.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Frame4 = SequentialReading<Tail1, FirstEvidenceImage<Tail1.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Frame5 = SequentialReading<Tail1, SecondEvidenceImage<Tail1.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Tail2 = SequentialReading<G2, SecondEvidenceImage<G2.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Frame6 = SequentialReading<G2, FirstEvidenceImage<G2.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Frame7 = SequentialReading<Tail2, FirstEvidenceImage<Tail2.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Frame8 = SequentialReading<Tail2, SecondEvidenceImage<Tail2.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias E0 = EncodedSeparation<N.A, N.X, Frame0, Eq, Route11<C0>, Route00<C0>, Route10<EchoBitEquality>>
    public typealias E1 = EncodedSeparation<N.A, N.Y, Frame1, Eq, Route11<C1>, Route01<C1>, Route01<EchoBitEquality>>
    public typealias E2 = EncodedSeparation<N.A, N.Z, Frame2, Eq, Route11<C2>, Route10<C2>, Route10<EchoBitEquality>>
    public typealias E3 = EncodedSeparation<N.B, N.X, Frame3, Eq, Route11<C3>, Route00<C3>, Route01<EchoBitEquality>>
    public typealias E4 = EncodedSeparation<N.B, N.Y, Frame4, Eq, Route11<C4>, Route01<C4>, Route10<EchoBitEquality>>
    public typealias E5 = EncodedSeparation<N.B, N.Z, Frame5, Eq, Route11<C5>, Route10<C5>, Route01<EchoBitEquality>>
    public typealias E6 = EncodedSeparation<N.X, N.Y, Frame6, Eq, Route00<C6>, Route01<C6>, Route10<EchoBitEquality>>
    public typealias E7 = EncodedSeparation<N.X, N.Z, Frame7, Eq, Route00<C7>, Route10<C7>, Route01<EchoBitEquality>>
    public typealias E8 = EncodedSeparation<N.Y, N.Z, Frame8, Eq, Route01<C8>, Route10<C8>, Route10<EchoBitEquality>>
    public typealias Network = NineSeparationReadings<E0, E1, E2, E3, E4, E5, E6, E7, E8>
    public typealias Acquisition = AcquireRecordedNetwork<AcquireNodes, Resources, Network>
    public typealias Answer = UnmatchedReturnAnswer<Acquisition.Right.Right,
        Route00<ReturnCoverageTable>, LocalPolicyAtZero<Paired<EchoEqual, EchoUndetermined>>>
    public typealias Decision = ApplyReturnCoverage<Acquisition, Answer>
}

/// These distinct resident laws both send the prepared fixed point 1 to
/// position 3. The receiver is given their acquired separation network.
public enum AcquiredDistinctFrames: Close {
    public typealias P = FourLeafSecondProbe<Never>
    public typealias Nodes = ProbePairWitnessNodes<P.ZWW, P.WZWW,
        AddressTriple<RoutingAddress00, RoutingAddress01, RoutingAddress10>>
    public typealias Witness = EncodedDistinctFrameWitness
    public typealias Decision = Witness.Decision
    public enum SameVisibleBits: Null {
        public typealias Left = Decision.Observation.Answer.Left.Answer
        public typealias Right = EncodedFullWitness.Decision.Observation.Answer.Left.Answer
    }
    public typealias OtherNodes = ProbePairWitnessNodes<P.WZWW, P.WWZWW,
        AddressTriple<RoutingAddress00, RoutingAddress01, RoutingAddress10>>
    public typealias OtherAcquisition = AcquireRecordedNetwork<OtherNodes,
        Witness.Resources, Witness.Network>
    public typealias OtherDecision = ApplyReturnCoverage<OtherAcquisition, Witness.Answer>
    public enum SameReceiverInput: Null {
        public typealias Left = OtherDecision.Observation.Answer
        public typealias Right = Decision.Observation.Answer
    }
    public enum ActualContexts: Null {
        public typealias Left = Paired<Nodes.Run.Right.Left.Left.Left.Right.Right,
            Nodes.Run.Right.Left.Right.Left.Right.Right>
        public typealias Right = Paired<FourLeafLawContext<FourLeafLawAddresses.ZWW, Never>,
            FourLeafLawContext<FourLeafLawAddresses.WZWW, Never>>
    }
}

/// Prepare new working data beside the acquired whole. The law context is
/// read from an addressed retained frame, rather than chosen by the answer
/// decoder. The prepared center and payload already occur in the input.
public enum PrepareAcquiredFrame<E: Pair, C: PredicateReading,
    P: Structure>: Pair
where E.Left: Structure, E.Right: Structure, C.Left == E.Right,
      C.Answer: Structure, C.Sigma == BeamSpace, C.Encoding == SaturationEncoding {
    public typealias Prepared = Paired<FourLeafCenter, P>
    public typealias Begin = StepBeside<E, Prepared>
    public typealias ReadContext = PairedApplication<
        JointEvidence<IdentityReading<E.Right, BeamSpace, SaturationEncoding>, C>,
        IdentityReading<Prepared, BeamSpace, SaturationEncoding>>
    public enum Focus: Pair {
        public typealias Left = ReadContext.Answer
        public typealias Context = Left.Left.Right
        public typealias Right = Paired<LocalPhaseWorld<Left.Right.Left,
            Left.Right.Right, Context>, Left.Left.Left>
    }
    public typealias Actual = FollowedPair<FollowedPair<Begin, ReadContext>, Focus>
    public typealias Left = Actual.Left
    public typealias Right = Actual.Right
}

/// The addressed context is composed from the final acquisition back to
/// its actual paired probe results. Both the graph fact and result survive.
public enum AcquiredFrameContexts: Close {
    public typealias D = AcquiredDistinctFrames.Decision
    public typealias A0 = FirstEvidenceImage<D.Right, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias A1 = SequentialReading<A0,
        FirstEvidenceImage<A0.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias A2 = SequentialReading<A1,
        FirstEvidenceImage<A1.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Source = SequentialReading<A2,
        SecondEvidenceImage<A2.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Both = SequentialReading<Source,
        FirstEvidenceImage<Source.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias HProbe = SequentialReading<Both,
        FirstEvidenceImage<Both.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias KProbe = SequentialReading<Both,
        SecondEvidenceImage<Both.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias HWorld = SequentialReading<HProbe,
        FirstEvidenceImage<HProbe.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias KWorld = SequentialReading<KProbe,
        FirstEvidenceImage<KProbe.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias HTail = SequentialReading<HWorld,
        SecondEvidenceImage<HWorld.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias KTail = SequentialReading<KWorld,
        SecondEvidenceImage<KWorld.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias H = SequentialReading<HTail,
        SecondEvidenceImage<HTail.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias K = SequentialReading<KTail,
        SecondEvidenceImage<KTail.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
}

/// Actual inverse; requested contact; actual forward frame. Both selectors
/// read the same retained frame address. There is no decoder for that law.
public enum AcquiredFrameActions<A: Structure, B: Structure, C: Structure,
    D: Structure, R: Structure>: Close {
    public typealias F = AcquiredFrameContexts
    public typealias Decision = AcquiredDistinctFrames.Decision
    public typealias Payload = BoundaryWorking<A, B, C, D>
    public typealias HC = F.H.Answer
    public typealias KC = F.K.Answer
    public typealias BeginH = PrepareAcquiredFrame<Decision, F.H, Payload>
    public typealias BeginK = PrepareAcquiredFrame<Decision, F.K, Payload>
    public typealias HR = FourLeafInverseRoot<A, B, C, D, HC>
    public typealias KR = FourLeafInverseRoot<A, B, C, D, KC>
    public typealias HI = FourLeafLawInput<Payload, HC>
    public typealias KI = FourLeafLawInput<Payload, KC>
    public typealias HInverse = SelectedLocalApplication<HR, HI,
        FirstEvidenceImage<HI.Answer, BeamSpace, SaturationEncoding, FirstProjection>, HR.SelectZWW>
    public typealias KInverse = SelectedLocalApplication<KR, KI,
        FirstEvidenceImage<KI.Answer, BeamSpace, SaturationEncoding, FirstProjection>, KR.SelectWZWW>

    public typealias HW = FourLeafJointCatalogue<B, D, C, A, HC>.W
    public typealias KW = FourLeafJointCatalogue<C, D, A, B, KC>.W
    public typealias HF = FourLeafWordRoot<A, D, B, C, HC>
    public typealias KF = FourLeafWordRoot<B, D, C, A, KC>
    public typealias HWPath = FollowedPair<FollowedPair<HInverse, HW>, HF.Selected<HF.SelectZWW>>
    public typealias KWPath = FollowedPair<FollowedPair<KInverse, KW>, KF.Selected<KF.SelectWZWW>>

    public typealias HZ = FourLeafJointCatalogue<B, D, C, A, HC>.Z
    public typealias KZ = FourLeafJointCatalogue<C, D, A, B, KC>.Z
    public typealias HZF = FourLeafWordRoot<D, B, A, C, HC>
    public typealias KZF = FourLeafWordRoot<D, C, B, A, KC>
    public typealias HZPath = FollowedPair<FollowedPair<HInverse, HZ>, HZF.Selected<HZF.SelectZWW>>
    public typealias KZPath = FollowedPair<FollowedPair<KInverse, KZ>, KZF.Selected<KZF.SelectWZWW>>

    public enum CloseH: Pair {
        public typealias Left = Paired<HWPath.Answer, Decision.Right>
        public typealias Right = Paired<Left.Right, Paired<Left.Left.Left, Left.Left.Right.Left>>
    }
    public enum CloseK: Pair {
        public typealias Left = Paired<KWPath.Answer, Decision.Right>
        public typealias Right = Paired<Left.Right, Paired<Left.Left.Left, Left.Left.Right.Left>>
    }
    public enum CloseHZ: Pair {
        public typealias Left = Paired<HZPath.Answer, Decision.Right>
        public typealias Right = Paired<Left.Right, Paired<Left.Left.Left, Left.Left.Right.Left>>
    }
    public enum CloseKZ: Pair {
        public typealias Left = Paired<KZPath.Answer, Decision.Right>
        public typealias Right = Paired<Left.Right, Paired<Left.Left.Left, Left.Left.Right.Left>>
    }
    public typealias H = StepBeside<FollowedPair<FollowedPair<BeginH,
        StepBeside<HWPath, Decision.Right>>, CloseH>, R>
    public typealias K = StepBeside<FollowedPair<FollowedPair<BeginK,
        StepBeside<KWPath, Decision.Right>>, CloseK>, R>
    public typealias ZThroughH = StepBeside<FollowedPair<FollowedPair<BeginH,
        StepBeside<HZPath, Decision.Right>>, CloseHZ>, R>
    public typealias ZThroughK = StepBeside<FollowedPair<FollowedPair<BeginK,
        StepBeside<KZPath, Decision.Right>>, CloseKZ>, R>
    public enum SameFullAction: Null {
        public typealias Left = Paired<H.Left, H.Right>
        public typealias Right = Paired<K.Left, K.Right>
    }
    public enum ResultAndArchive: Null {
        public typealias Left = H.Right
        public typealias Right = Paired<Paired<Decision.Right,
            Paired<FourLeafCenter, BoundaryWorking<C, A, B, D>>>, R>
    }
    public enum ContextsReturned: Null {
        public typealias Left = Paired<HWPath.Answer.Right.Right, KWPath.Answer.Right.Right>
        public typealias Right = Paired<HC, KC>
    }
    public enum DifferentQuestion: Null {
        public typealias Left = Paired<ZThroughH.Right.Left.Right.Right,
            ZThroughK.Right.Left.Right.Right>
        public typealias Right = Paired<BoundaryWorking<C, D, A, B>, BoundaryWorking<B, A, D, C>>
    }
}
