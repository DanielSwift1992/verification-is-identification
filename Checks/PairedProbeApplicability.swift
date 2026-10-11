import VerificationIsIdentification
import Examples

// Re-encode just the second actual reply after the pair was acquired.
// This is an actual mixed-frame path, outside the common-frame construction.
enum MixedPairedReply: Close {
    typealias C = PairedProbeCalibration
    typealias Start = StepBeside<C.E10, C.ChangedFrame>
    typealias Old = FirstEvidenceImage<Start.Right, BeamSpace, SaturationEncoding, FirstProjection>
    typealias Fact = SequentialReading<Old,
        SecondEvidenceImage<C.E10.Right, BeamSpace, SaturationEncoding, SecondProjection>>
    typealias Answers = SequentialReading<Fact, ReadRecordedAnswer<C.E10.Right.Right>>
    typealias A = SequentialReading<Answers,
        FirstEvidenceImage<Answers.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    typealias B = SequentialReading<Answers,
        SecondEvidenceImage<Answers.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    typealias Frame = SecondEvidenceImage<Start.Right, BeamSpace, SaturationEncoding, SecondProjection>
    typealias EncodedB = SequentialReading<JointEvidence<B, Frame>, Route00<C.ChangedFrame>>
    typealias Mixed = JointEvidence<A, EncodedB>
    typealias Record = RecordReading<Mixed>
    typealias Actual = FollowedPair<Start, Record>
    typealias Decision = PairedProbeDecision<Actual,
        Route01<PhaseEqualityTable>, Route01<FourLeafPhaseMark1>>
}

enum CollapsedPairedReply: Close {
    typealias P = FourLeafSecondProbe<Never>
    typealias C = BoundaryWorking<RoutingAddress01, RoutingAddress01,
        RoutingAddress01, RoutingAddress01>
    typealias Actual = PairedProbeInFrame<P.I, P.Z, C, Route01<C>, Route00<C>>
    typealias Decision = PairedProbeDecision<Actual,
        Route01<PhaseEqualityTable>, Route01<FourLeafPhaseMark1>>
}

enum OddPairedFrame<A: Structure, B: Structure, C: Structure,
    D: Structure>: Close {
    typealias O = FourLeafPhase2<A, B, C, D>
    typealias W = FourLeafPhaseWord<A, B, C, D>
    typealias OW = FollowedPair<O, FourLeafPhaseWord<A, B, D, C>>
    typealias WO = FollowedPair<W, FourLeafPhase2<D, B, A, C>>
    typealias IRecord = RecordReading<PhaseLawProbe1<O.Left>>
    typealias ORecord = RecordReading<PhaseLawProbe1<O.Right>>
}

#if !LOCAL_PHASE_PAIRED_UNSHARED_FRAME && !LOCAL_PHASE_PAIRED_COLLAPSED_FRAME && !LOCAL_PHASE_PAIRED_NO_EVEN_SCOPE && !LOCAL_PHASE_PAIRED_IDENTIFIES_CHANNELS
enum PairedProbeResults: Null {
    typealias C = PairedProbeCalibration
    typealias Left = AddressTriple<C.Verdicts.Left, C.ReplyClasses.Left,
        C.SameAvailablePositiveMemory.Left>
    typealias Right = AddressTriple<C.Verdicts.Right, C.ReplyClasses.Right,
        C.SameAvailablePositiveMemory.Right>
}

enum PairedFrameGeneratorsPreserveComparison: Null {
    typealias C = CommonProbeFrameGenerators
    typealias Left = Paired<C.PreservesT.Left, C.PreservesW.Left>
    typealias Right = Paired<C.PreservesT.Right, C.PreservesW.Right>
}

// Both wrong interpretations really yield equal observed labels. The
// underlying I/Z relation remains the incompatible one of the canonical run.
enum PairedFrameFailuresAreActual: Null {
    typealias Left = AddressTriple<MixedPairedReply.Actual.Right.Right.Answer,
        CollapsedPairedReply.Actual.Right.Right.Answer,
        Paired<MixedPairedReply.Decision.Read.Answer, CollapsedPairedReply.Decision.Read.Answer>>
    typealias Same = Paired<RoutingAddress01, RoutingAddress01>
    typealias Right = AddressTriple<Same, Same, Paired<Lit1, Lit1>>
}

enum PairedOddAgreementDoesNotSettleAction<A: Structure, B: Structure,
    C: Structure, D: Structure>: Null {
    typealias O = OddPairedFrame<A, B, C, D>
    typealias Left = AddressTriple<O.IRecord.Right.Right,
        O.OW.Right, O.WO.Right>
    typealias Right = AddressTriple<O.ORecord.Right.Right,
        BoundaryWorking<C, B, A, D>, BoundaryWorking<D, B, C, A>>
}

enum PairedProbePreservesLaboratory<K: Structure>: Null {
    typealias E = StepBeside<PairedProbeCalibration.D11, K>
    typealias Left = E.Right.Right
    typealias Right = K
}
#endif

#if LOCAL_PHASE_PAIRED_UNSHARED_FRAME
enum RejectedPairedUnsharedFrame: Null {
    typealias Left = MixedPairedReply.Decision.Read.Answer
    typealias Right = PairedProbeCalibration.D10.Read.Answer
}
#endif

#if LOCAL_PHASE_PAIRED_COLLAPSED_FRAME
enum RejectedPairedCollapsedFrame: Null {
    typealias Left = CollapsedPairedReply.Decision.Read.Answer
    typealias Right = PairedProbeCalibration.D10.Read.Answer
}
#endif

#if LOCAL_PHASE_PAIRED_NO_EVEN_SCOPE
enum RejectedPairedNoEvenScope: Null {
    typealias O = OddPairedFrame<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11>
    typealias Left = O.OW.Right
    typealias Right = O.WO.Right
}
#endif

#if LOCAL_PHASE_PAIRED_IDENTIFIES_CHANNELS
enum RejectedPairedIdentifiesChannels: Null {
    typealias C = PairedProbeCalibration
    typealias Left = C.E11.Left.Left.Left
    typealias Right = C.UnknownAlternative.Left.Left.Left
}
#endif
