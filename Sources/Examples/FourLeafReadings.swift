import VerificationIsIdentification

/// Complete source paths for the five stage slots. These are views used to
/// construct a contact, not five observations supplied to an outside actor.
public enum FourLeafStageViews<O: Structure, A: Structure, B: Structure,
                               C: Structure, D: Structure>: Close {
    public typealias Source = FourLeafStageLabels<O, A, B, C, D>
    public typealias Center = FirstEvidenceImage<Source, BeamSpace, SaturationEncoding, FirstProjection>
    public typealias Leaves = SecondEvidenceImage<Source, BeamSpace, SaturationEncoding, SecondProjection>
    public typealias Low = SequentialReading<Leaves,
        FirstEvidenceImage<Leaves.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias High = SequentialReading<Leaves,
        SecondEvidenceImage<Leaves.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Leaf0 = SequentialReading<Low,
        FirstEvidenceImage<Low.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Leaf1 = SequentialReading<Low,
        SecondEvidenceImage<Low.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
    public typealias Leaf2 = SequentialReading<High,
        FirstEvidenceImage<High.Answer, BeamSpace, SaturationEncoding, FirstProjection>>
    public typealias Leaf3 = SequentialReading<High,
        SecondEvidenceImage<High.Answer, BeamSpace, SaturationEncoding, SecondProjection>>
}

extension FourLeafStage0: PredicateReading {
    public typealias Views = FourLeafStageViews<O, A, B, C, D>
    public typealias Actual = JointEvidence<Views.Leaf0,
        JointEvidence<JointEvidence<Views.Center, Views.Leaf1>, JointEvidence<Views.Leaf2, Views.Leaf3>>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Actual.Answer
}
extension FourLeafStage1: PredicateReading {
    public typealias Views = FourLeafStageViews<O, A, B, C, D>
    public typealias Actual = JointEvidence<Views.Leaf1,
        JointEvidence<JointEvidence<Views.Leaf0, Views.Center>, JointEvidence<Views.Leaf2, Views.Leaf3>>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Actual.Answer
}
extension FourLeafStage2: PredicateReading {
    public typealias Views = FourLeafStageViews<O, A, B, C, D>
    public typealias Actual = JointEvidence<Views.Leaf2,
        JointEvidence<JointEvidence<Views.Leaf0, Views.Leaf1>, JointEvidence<Views.Center, Views.Leaf3>>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Actual.Answer
}
extension FourLeafStage3: PredicateReading {
    public typealias Views = FourLeafStageViews<O, A, B, C, D>
    public typealias Actual = JointEvidence<Views.Leaf3,
        JointEvidence<JointEvidence<Views.Leaf0, Views.Leaf1>, JointEvidence<Views.Leaf2, Views.Center>>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Actual.Answer
}

extension FourLeafPhase0: PredicateReading {
    public typealias Actual = PairedApplication<SwapBoundaryReading<Paired<A, B>>,
        IdentityReading<Paired<C, D>, BeamSpace, SaturationEncoding>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Actual.Answer
}
extension FourLeafPhase1: PredicateReading {
    public typealias Actual = TransposeBoundaryTable<BoundaryWorking<A, B, C, D>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Actual.Answer
}
extension FourLeafPhase2: PredicateReading {
    public typealias Actual = PairedApplication<IdentityReading<Paired<A, B>, BeamSpace, SaturationEncoding>,
        SwapBoundaryReading<Paired<C, D>>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Actual.Answer
}
extension FourLeafPhase3: PredicateReading {
    public typealias Actual = CrossBoundaryImage<BoundaryWorking<A, B, C, D>>
    public typealias Sigma = BeamSpace
    public typealias Encoding = SaturationEncoding
    public typealias Predicate = Actual.Predicate
    public typealias Answer = Actual.Answer
}

/// The existing paths supply the operation expression, and their inherited
/// reading endpoints must agree with the already stated Pair endpoints.
extension FourLeafShortStageWord: PredicateReading {
    public typealias Sigma = Path.Sigma
    public typealias Encoding = Path.Encoding
    public typealias Predicate = Path.Predicate
    public typealias Answer = Path.Answer
}
extension FourLeafShortPhaseWord: PredicateReading {
    public typealias Sigma = Path.Sigma
    public typealias Encoding = Path.Encoding
    public typealias Predicate = Path.Predicate
    public typealias Answer = Path.Answer
}
extension FourLeafStageWord: PredicateReading {
    public typealias Sigma = Path.Sigma
    public typealias Encoding = Path.Encoding
    public typealias Predicate = Path.Predicate
    public typealias Answer = Path.Answer
}
extension FourLeafPhaseWord: PredicateReading {
    public typealias Sigma = Path.Sigma
    public typealias Encoding = Path.Encoding
    public typealias Predicate = Path.Predicate
    public typealias Answer = Path.Answer
}
