import VerificationIsIdentification
import Examples

#if !LOCAL_PHASE_CONTACT_CYCLE_ONE_SQUARE && !LOCAL_PHASE_CONTACT_CYCLE_IDENTIFIES_FRAME && !LOCAL_PHASE_CONTACT_CYCLE_ADJACENT_GAPS && !LOCAL_PHASE_CONTACT_CYCLE_OMITS_BIJECTION
enum ContactCycleAcquiredVerdicts: Null {
    typealias C = ContactCycleCalibration
    typealias Left = Paired<C.Verdicts.Left,
        Paired<C.SameFullPositiveEvidence.Left, C.DifferentPrivateImages.Left>>
    typealias Right = Paired<C.Verdicts.Right,
        Paired<C.SameFullPositiveEvidence.Right, C.DifferentPrivateImages.Right>>
}

enum ContactCycleKeepsItsSource<K: Structure>: Null {
    typealias C = ContactCycleCalibration.Odd
    typealias Path = StepBeside<C, K>
    typealias Left = Paired<C.RetainsSourceAndImages.Left, Path.Right.Right>
    typealias Right = Paired<C.RetainsSourceAndImages.Right, K>
}

enum ContactCycleFivePointGap<A: Structure, B: Structure, C: Structure,
    D: Structure, E: Structure>: Null {
    typealias F = FourCycleUncoveredPoint<A, B, C, D, E>
    typealias Left = Paired<F.SameTwoFields.Left, F.DifferentOtherField.Left>
    typealias Right = Paired<F.SameTwoFields.Right, F.DifferentOtherField.Right>
}

enum ContactCycleBijectionBoundary: Null {
    typealias C = ContactCycleCalibration
    typealias Left = Paired<C.SameEvidenceOutsideBijections.Left,
        Paired<C.MissingFixedEquation.Left, Paired<C.CollapseIntertwines.Left, C.CollapseHasNoContrast.Left>>>
    typealias Right = Paired<C.SameEvidenceOutsideBijections.Right,
        Paired<C.MissingFixedEquation.Right, Paired<C.CollapseIntertwines.Right, C.CollapseHasNoContrast.Right>>>
}
#endif

#if LOCAL_PHASE_CONTACT_CYCLE_OMITS_BIJECTION
enum RejectedContactCycleOmitsBijection: Null {
    typealias Left = ContactCycleCalibration.UncoveredFixedReply.Answer.Left
    typealias Right = ContactCycleCalibration.UncoveredFixedThenC.Answer
}
#endif

#if LOCAL_PHASE_CONTACT_CYCLE_ONE_SQUARE
enum RejectedContactCycleOneSquare: Null {
    typealias Left = ContactCycleCalibration.MissingPoint.First.Answer
    typealias Right = ContactCycleCalibration.MissingPoint.Second.Answer
}
#endif

// Same complete positive fact, distinct actual first private image.
#if LOCAL_PHASE_CONTACT_CYCLE_IDENTIFIES_FRAME
enum RejectedContactCycleIdentifiesFrame: Null {
    typealias Left = ContactCycleCalibration.GoodImages.Image0.Answer
    typealias Right = ContactCycleCalibration.OddImages.Image0.Answer
}
#endif

// The same number of passing comparisons at the wrong positions does not
// supply the two-component coverage of the theorem.
#if LOCAL_PHASE_CONTACT_CYCLE_ADJACENT_GAPS
enum RejectedContactCycleAdjacentGaps: Null {
    typealias F = FourCycleUncoveredPoint<RoutingAddress00, RoutingAddress01,
        RoutingAddress10, RoutingAddress11, Lit1>
    typealias Left = F.LeftPath.Right.Left
    typealias Right = F.RightPath.Right.Left
}
#endif
