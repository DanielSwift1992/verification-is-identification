import VerificationIsIdentification
import Examples

#if !LOCAL_PHASE_CONTACT_SUPPORT_THREE && !LOCAL_PHASE_CONTACT_SUPPORT_PLACEMENT && !LOCAL_PHASE_CONTACT_SUPPORT_FULL_Z
enum ActiveContrastPropagation<T: CycleContactImage>: Null
where T.Left.Right == T.Right.Right {
    typealias Left = ActiveContrastMerge13<T>.Left
    typealias Right = ActiveContrastMerge13<T>.Right
}

enum FixedContrastPropagation<T: SeparatingContactImage>: Null
where T.Right.Left == T.Right.Right {
    typealias Left = FixedContrastMerge23<T>.Left
    typealias Right = FixedContrastMerge23<T>.Right
}

enum SparseSupportDoesNotSupplyFullZ: Null {
    typealias F = SparseFaithfulContactImage
    typealias Left = BoundaryWorking<F.A.Right, F.B.Right, F.C.Right, F.D.Right>
    typealias Right = BoundaryWorking<F.B, F.B, F.D, F.D>
}

enum SixComparisonsAtWrongPositions: Null {
    typealias F = MisplacedSixContactImage
    typealias Left = Paired<F.TestedZ01.Left, CycleImageReturns<F>.Left>
    typealias Right = Paired<F.TestedZ01.Right, BoundaryWorking<F.A, F.B, F.A, F.A>>
}

enum ThreeActiveComparisons: Null {
    typealias F = ThreeActiveEdgesMayLoseFixed
    typealias Left = Paired<F.ActiveEdges.Left, F.Left.Left>
    typealias Right = Paired<F.ActiveEdges.Right, F.Left.Right>
}

enum ObservableReturnBeforeRecovery<T: CycleContactImage>: Null {
    typealias Left = CycleImageReturns<T>.Left
    typealias Right = CycleImageReturns<T>.Right
}

enum SameNegativeFactsDifferentPassages: Null {
    typealias F = NegativeSquaresDoNotIdentifyPassage
    typealias Left = Paired<F.SameFullFact.Left, F.SameGivenContrastEndpoints.Left>
    typealias Right = Paired<F.SameFullFact.Right, F.SameGivenContrastEndpoints.Right>
}

enum AllNegativeContactBits: Null {
    typealias F = NegativeSquaresDoNotIdentifyPassage.Faithful
    typealias Zeros = BoundaryWorking<Never, Never, Never, Never>
    typealias Left = Paired<F.Reading.Answer, F.WordTargets.Left>
    typealias Right = Paired<Paired<Zeros, Zeros>, F.WordTargets.Right>
}

enum NegativeContactRecordsKeepImages<K: Structure>: Null {
    typealias F = NegativeSquaresDoNotIdentifyPassage.FixedLoss
    typealias Path = StepBeside<F.Record, K>
    typealias Left = Paired<Path.Right.Left.Left, Path.Right.Right>
    typealias Right = Paired<F.Root, K>
}
#endif

#if LOCAL_PHASE_CONTACT_SUPPORT_THREE
enum RejectedContactSupportThree: CycleContactImage {
    typealias F = ThreeActiveEdgesMayLoseFixed
    typealias Left = F.Left
    typealias Right = F.Right
}
#endif

#if LOCAL_PHASE_CONTACT_SUPPORT_PLACEMENT
enum RejectedContactSupportPlacement: SeparatingContactImage {
    typealias F = MisplacedSixContactImage
    typealias Left = F.Left
    typealias Right = F.Right
}
#endif

#if LOCAL_PHASE_CONTACT_SUPPORT_FULL_Z
enum RejectedContactSupportFullZ: Null {
    typealias F = SparseFaithfulContactImage
    typealias Left = F.B.Right
    typealias Right = F.A
}
#endif
