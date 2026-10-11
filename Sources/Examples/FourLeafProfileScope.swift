import VerificationIsIdentification

/// The current stage and phase are read from their actual fields. The
/// surrounding context is omitted from this image, not from the source.
public enum LocalStagePhaseImage<W: Pair>: PredicateReading
where W.Left: Structure, W.Right: Pair, W.Right.Left: Structure {
    public typealias Stage = FirstEvidenceImage<W, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Tail = SecondEvidenceImage<W, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Phase = FollowedPair<Tail,
        FirstEvidenceImage<Tail.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Actual = JointEvidence<Stage, Phase>
    public typealias Left = W
    public typealias Right = Paired<W.Left, W.Right.Left>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Right
    public enum Endpoints: Null {
        public typealias Left = Paired<LocalStagePhaseImage.Left, LocalStagePhaseImage.Right>
        public typealias Right = Paired<Actual.Left, Actual.Answer>
    }
}

/// Each actual primitive preserves equality of the stage/phase images
/// across arbitrary different contexts. No final image equality is required
/// from the caller, and the phase labels need not be one-hot here.
public enum FourLeafPrimitiveProfiles<O: Structure, A: Structure, B: Structure,
    C: Structure, D: Structure, P: Structure, Q: Structure, R: Structure,
    T: Structure, K: Structure, L: Structure>: Null {
    public typealias X = FourLeafControlRoot<O, A, B, C, D, P, Q, R, T, K>
    public typealias Y = FourLeafControlRoot<O, A, B, C, D, P, Q, R, T, L>
    public typealias Left = BoundaryWorking<LocalStagePhaseImage<X.S0.Answer>.Answer,
        LocalStagePhaseImage<X.S1.Answer>.Answer, LocalStagePhaseImage<X.S2.Answer>.Answer,
        LocalStagePhaseImage<X.S3.Answer>.Answer>
    public typealias Right = BoundaryWorking<LocalStagePhaseImage<Y.S0.Answer>.Answer,
        LocalStagePhaseImage<Y.S1.Answer>.Answer, LocalStagePhaseImage<Y.S2.Answer>.Answer,
        LocalStagePhaseImage<Y.S3.Answer>.Answer>
}

/// The same carried program selects the same actual address in all four
/// admitted phase clauses, independently of K. Its selected results preserve
/// the same image equality as the primitive contacts.
public enum FourLeafControlProfiles<O: Structure, A: Structure, B: Structure,
    C: Structure, D: Structure, K: Structure, L: Structure>: Close {
    public typealias X = FourLeafControl<O, A, B, C, D, K>
    public typealias Y = FourLeafControl<O, A, B, C, D, L>
    public enum SelectedImages: Null {
        public typealias Left = BoundaryWorking<LocalStagePhaseImage<X.At0.Answer>.Answer,
            LocalStagePhaseImage<X.At1.Answer>.Answer, LocalStagePhaseImage<X.At2.Answer>.Answer,
            LocalStagePhaseImage<X.At3.Answer>.Answer>
        public typealias Right = BoundaryWorking<LocalStagePhaseImage<Y.At0.Answer>.Answer,
            LocalStagePhaseImage<Y.At1.Answer>.Answer, LocalStagePhaseImage<Y.At2.Answer>.Answer,
            LocalStagePhaseImage<Y.At3.Answer>.Answer>
    }
    public enum SelectedAddresses: Null {
        public typealias Left = BoundaryWorking<X.At0.Selection.Answer, X.At1.Selection.Answer,
            X.At2.Selection.Answer, X.At3.Selection.Answer>
        public typealias Right = BoundaryWorking<Y.At0.Selection.Answer, Y.At1.Selection.Answer,
            Y.At2.Selection.Answer, Y.At3.Selection.Answer>
    }
}

/// An actual exchange inside the context can occur between target steps.
/// Both exchanged fields remain in the source. The image is unchanged.
public enum LocalContextExchange<S: Structure, P: Structure, Program: Structure,
    H: Structure, J: Structure>: Null {
    public typealias Swap = PairedApplication<IdentityReading<S, BeamSpace, SaturationEncoding>,
        PairedApplication<IdentityReading<P, BeamSpace, SaturationEncoding>,
            PairedApplication<IdentityReading<Program, BeamSpace, SaturationEncoding>,
                SwapBoundaryReading<Paired<H, J>>>>>
    public typealias Left = LocalStagePhaseImage<Swap.Left>.Answer
    public typealias Right = LocalStagePhaseImage<Swap.Answer>.Answer
}
