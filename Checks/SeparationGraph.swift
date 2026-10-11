import VerificationIsIdentification
import Examples

// The two images below come from the SAME source node, but different
// resident functions. A shared resource container does not repair that.
enum SplitEncodedSameNode: Close {
    typealias C = EncodedFullWitness
    typealias First = SequentialReading<JointEvidence<C.N.A, C.Frame0>, Route11<C.C0>>
    typealias Second = SequentialReading<JointEvidence<C.N.A, C.Frame1>, Route11<C.C1>>
    typealias Images = JointEvidence<First, Second>
    typealias Read = SequentialReading<JointEvidence<Images, C.Eq>, Route10<EchoBitEquality>>
}

#if !LOCAL_PHASE_SEPARATION_MISSING_TRIANGLE && !LOCAL_PHASE_SEPARATION_MISSING_SPOKE && !LOCAL_PHASE_SEPARATION_SPLIT_MAP
enum SeparationGraphAcquiredAnswer: Null {
    typealias C = EncodedWitnessResults
    typealias Left = Paired<C.Positive.Left, C.MixedFrameOrientations.Left>
    typealias Right = Paired<C.Positive.Right, C.MixedFrameOrientations.Right>
}

enum SeparationGraphEdgeOmissions: Null {
    typealias C = EncodedWitnessResults
    typealias Left = Paired<C.MissingTriangle.Left, C.MissingSpoke.Left>
    typealias Right = Paired<C.MissingTriangle.Right, C.MissingSpoke.Right>
}

enum SeparationGraphUsesActualResidentNodes: Null {
    typealias C = WitnessNodesFromReturns
    typealias Left = C.NodesAreActual.Left
    typealias Right = C.NodesAreActual.Right
}

enum SeparationGraphPreservesSource<K: Structure>: Null {
    typealias C = EncodedFullWitness
    typealias Path = StepBeside<C.Decision, K>
    typealias Left = Paired<C.Acquisition.RetainsSource.Left, Path.Right.Right>
    typealias Right = Paired<C.Acquisition.RetainsSource.Right, K>
}

enum SeparationGraphSplitMapCountermodel: Null {
    typealias C = SplitEncodedSameNode
    typealias Left = Paired<Paired<EncodedFullWitness.N.A.Answer, EncodedFullWitness.N.A.Answer>,
        Paired<C.Images.Answer, C.Read.Answer>>
    typealias Right = Paired<Paired<RoutingAddress11, RoutingAddress11>,
        Paired<Paired<Lit1, Never>, Never>>
}
#endif

#if LOCAL_PHASE_SEPARATION_MISSING_TRIANGLE
enum RejectedSeparationMissingTriangle: Null {
    typealias Left = EncodedMissingTriangleWitness.Decision.Read.Answer
    typealias Right = EchoEqual
}
#endif

// A missing spoke cannot be silently replaced with the required separation.
#if LOCAL_PHASE_SEPARATION_MISSING_SPOKE
enum RejectedSeparationMissingSpoke: Null {
    typealias Left = EncodedMissingSpokeWitness.E0.Answer
    typealias Right = Never
}
#endif

// The actual original pair is equal (the acquired full witness comes from
// Q33). Its two differently encoded images are unequal. Transporting this
// encoded equality bit as the raw equality answer is an invalid reading.
#if LOCAL_PHASE_SEPARATION_SPLIT_MAP
enum RejectedSeparationSplitMap: Null {
    typealias Left = SplitEncodedSameNode.Read.Answer
    typealias Right = EchoOrbitCalibration.Q33.Read.Answer
}
#endif
