import VerificationIsIdentification

/// Acquire the five values from the previous actual resident-and-return
/// path, rather than supply an independently selected node packet.
public enum WitnessNodesFromReturns: Close {
    public typealias F = ReturnCoverageCalibration.Full
    public typealias S = F.Run.Right
    public typealias P0 = FirstEvidenceImage<S, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias P1 = SequentialReading<P0,
        FirstEvidenceImage<P0.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias P2 = SequentialReading<P1,
        FirstEvidenceImage<P1.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias P3 = SequentialReading<P2,
        FirstEvidenceImage<P2.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Archive = SequentialReading<P3,
        FirstEvidenceImage<P3.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias A = SequentialReading<Archive, LocalEchoCalibration.E33.RawA>
    public typealias B = SequentialReading<Archive, LocalEchoCalibration.E33.RawB>
    public typealias Reading = JointEvidence<JointEvidence<A, B>, F.Samples.Targets>
    public typealias Record = RecordReading<Reading>
    public typealias Acquisition = FollowedPair<F.Run, Record>
    public enum NodesAreActual: Null {
        public typealias Left = Record.Right.Right.Answer
        public typealias Right = FiveWitnessValues<RoutingAddress11, RoutingAddress11,
            RoutingAddress00, RoutingAddress01, RoutingAddress10>
    }
}

public enum EncodedFullWitness: Close {
    public typealias AcquireNodes = WitnessNodesFromReturns.Acquisition
    public typealias Fact = AcquireNodes.Right.Right
    public typealias C0 = BoundaryWorking<Never, Never, Never, Lit1>
    public typealias C1 = BoundaryWorking<Lit1, Lit1, Lit1, Never>
    public typealias C2 = BoundaryWorking<Never, Never, Never, Lit1>
    public typealias C3 = BoundaryWorking<Lit1, Lit1, Lit1, Never>
    public typealias C4 = BoundaryWorking<Never, Never, Never, Lit1>
    public typealias C5 = BoundaryWorking<Lit1, Lit1, Lit1, Never>
    public typealias C6 = BoundaryWorking<Lit1, Never, Never, Never>
    public typealias C7 = BoundaryWorking<Never, Lit1, Lit1, Lit1>
    public typealias C8 = BoundaryWorking<Never, Lit1, Never, Never>
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

public enum EncodedMissingTriangleWitness: Close {
    public typealias Values = FiveWitnessValues<RoutingAddress00, RoutingAddress01, RoutingAddress10, RoutingAddress10, RoutingAddress11>
    public typealias AcquireNodes = RecordReading<IdentityReading<Values, BeamSpace, SaturationEncoding>>
    public typealias Fact = AcquireNodes.Right.Right
    public typealias C0 = BoundaryWorking<Lit1, Never, Never, Never>
    public typealias C1 = BoundaryWorking<Never, Lit1, Lit1, Lit1>
    public typealias C2 = BoundaryWorking<Lit1, Never, Never, Never>
    public typealias C3 = BoundaryWorking<Lit1, Never, Lit1, Lit1>
    public typealias C4 = BoundaryWorking<Never, Lit1, Never, Never>
    public typealias C5 = BoundaryWorking<Lit1, Never, Lit1, Lit1>
    public typealias C6 = BoundaryWorking<Never, Never, Lit1, Never>
    public typealias C7 = BoundaryWorking<Lit1, Lit1, Never, Lit1>
    public typealias C8 = BoundaryWorking<Never, Never, Lit1, Never>
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
    public typealias E0 = EncodedSeparation<N.A, N.X, Frame0, Eq, Route00<C0>, Route10<C0>, Route10<EchoBitEquality>>
    public typealias E1 = EncodedSeparation<N.A, N.Y, Frame1, Eq, Route00<C1>, Route10<C1>, Route01<EchoBitEquality>>
    public typealias E2 = EncodedSeparation<N.A, N.Z, Frame2, Eq, Route00<C2>, Route11<C2>, Route10<EchoBitEquality>>
    public typealias E3 = EncodedSeparation<N.B, N.X, Frame3, Eq, Route01<C3>, Route10<C3>, Route01<EchoBitEquality>>
    public typealias E4 = EncodedSeparation<N.B, N.Y, Frame4, Eq, Route01<C4>, Route10<C4>, Route10<EchoBitEquality>>
    public typealias E5 = EncodedSeparation<N.B, N.Z, Frame5, Eq, Route01<C5>, Route11<C5>, Route01<EchoBitEquality>>
    public typealias E6 = EncodedSeparation<N.X, N.Y, Frame6, Eq, Route10<C6>, Route10<C6>, Route11<EchoBitEquality>>
    public typealias E7 = EncodedSeparation<N.X, N.Z, Frame7, Eq, Route10<C7>, Route11<C7>, Route01<EchoBitEquality>>
    public typealias E8 = EncodedSeparation<N.Y, N.Z, Frame8, Eq, Route10<C8>, Route11<C8>, Route10<EchoBitEquality>>
    public typealias Network = NineSeparationReadings<E0, E1, E2, E3, E4, E5, E6, E7, E8>
    public typealias Acquisition = AcquireRecordedNetwork<AcquireNodes, Resources, Network>
    public typealias Answer = UnmatchedReturnAnswer<Acquisition.Right.Right,
        Route10<ReturnCoverageTable>, LocalPolicyAtZero<Paired<EchoUndetermined, EchoUndetermined>>>
    public typealias Decision = ApplyReturnCoverage<Acquisition, Answer>
}

public enum EncodedMissingSpokeWitness: Close {
    public typealias Values = FiveWitnessValues<RoutingAddress00, RoutingAddress01, RoutingAddress00, RoutingAddress10, RoutingAddress11>
    public typealias AcquireNodes = RecordReading<IdentityReading<Values, BeamSpace, SaturationEncoding>>
    public typealias Fact = AcquireNodes.Right.Right
    public typealias C0 = BoundaryWorking<Lit1, Never, Never, Never>
    public typealias C1 = BoundaryWorking<Never, Lit1, Lit1, Lit1>
    public typealias C2 = BoundaryWorking<Lit1, Never, Never, Never>
    public typealias C3 = BoundaryWorking<Lit1, Never, Lit1, Lit1>
    public typealias C4 = BoundaryWorking<Never, Lit1, Never, Never>
    public typealias C5 = BoundaryWorking<Lit1, Never, Lit1, Lit1>
    public typealias C6 = BoundaryWorking<Lit1, Never, Never, Never>
    public typealias C7 = BoundaryWorking<Never, Lit1, Lit1, Lit1>
    public typealias C8 = BoundaryWorking<Never, Never, Lit1, Never>
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
    public typealias E0 = EncodedSeparation<N.A, N.X, Frame0, Eq, Route00<C0>, Route00<C0>, Route11<EchoBitEquality>>
    public typealias E1 = EncodedSeparation<N.A, N.Y, Frame1, Eq, Route00<C1>, Route10<C1>, Route01<EchoBitEquality>>
    public typealias E2 = EncodedSeparation<N.A, N.Z, Frame2, Eq, Route00<C2>, Route11<C2>, Route10<EchoBitEquality>>
    public typealias E3 = EncodedSeparation<N.B, N.X, Frame3, Eq, Route01<C3>, Route00<C3>, Route01<EchoBitEquality>>
    public typealias E4 = EncodedSeparation<N.B, N.Y, Frame4, Eq, Route01<C4>, Route10<C4>, Route10<EchoBitEquality>>
    public typealias E5 = EncodedSeparation<N.B, N.Z, Frame5, Eq, Route01<C5>, Route11<C5>, Route01<EchoBitEquality>>
    public typealias E6 = EncodedSeparation<N.X, N.Y, Frame6, Eq, Route00<C6>, Route10<C6>, Route10<EchoBitEquality>>
    public typealias E7 = EncodedSeparation<N.X, N.Z, Frame7, Eq, Route00<C7>, Route11<C7>, Route01<EchoBitEquality>>
    public typealias E8 = EncodedSeparation<N.Y, N.Z, Frame8, Eq, Route10<C8>, Route11<C8>, Route10<EchoBitEquality>>
    public typealias Network = NineSeparationReadings<E0, E1, E2, E3, E4, E5, E6, E7, E8>
    public typealias Acquisition = AcquireRecordedNetwork<AcquireNodes, Resources, Network>
}

public enum EncodedWitnessResults: Close {
    public enum Positive: Null {
        public typealias Left = Paired<EncodedFullWitness.Network.Answer,
            EncodedFullWitness.Decision.Read.Answer>
        public typealias Right = Paired<Paired<ThreeUnmatchedEchoes,
            AddressTriple<Never, Never, Never>>, EchoEqual>
    }
    public enum MixedFrameOrientations: Null {
        public typealias Left = Paired<EncodedFullWitness.E0.Images.Answer,
            EncodedFullWitness.E1.Images.Answer>
        public typealias Right = Paired<Paired<Lit1, Never>, Paired<Never, Lit1>>
    }
    public enum MissingTriangle: Null {
        public typealias Left = Paired<EncodedMissingTriangleWitness.Network.Answer,
            EncodedMissingTriangleWitness.Decision.Read.Answer>
        public typealias Right = Paired<Paired<ThreeUnmatchedEchoes,
            AddressTriple<Lit1, Never, Never>>, EchoUndetermined>
    }
    public enum MissingSpoke: Null {
        public typealias Left = EncodedMissingSpokeWitness.Network.Answer
        public typealias Right = Paired<AddressTriple<Paired<Lit1, Never>,
            Paired<Never, Never>, Paired<Never, Never>>, AddressTriple<Never, Never, Never>>
    }
}
