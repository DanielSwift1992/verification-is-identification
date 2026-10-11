import VerificationIsIdentification
import Examples

#if !LOCAL_PHASE_BORROWED_EMPTY && !LOCAL_PHASE_BORROWED_MIDPOINT
enum BorrowedPhaseReturnsUnknownModes<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias R = BorrowedPhaseBranches<A, B, C, D>.Unperturbed
    typealias Left = R.Left
    typealias Right = R.Right
}

enum BorrowedPhaseLocatesControlErrors<A: Structure, B: Structure, C: Structure, D: Structure>: Null {
    typealias R = BorrowedPhaseBranches<A, B, C, D>
    typealias Left = AddressTriple<R.MidpointZ.Left, R.MidpointX.Left, R.GapRelations.Left>
    typealias Right = AddressTriple<R.MidpointZ.Right, R.MidpointX.Right, R.GapRelations.Right>
}
#endif

#if LOCAL_PHASE_BORROWED_EMPTY
enum RejectedBorrowedWordIsEmpty: Null {
    typealias R = BorrowedPhaseBranches<Lit1, Never, Never, Never>
    typealias Left = R.Unperturbed.Left
    typealias Right = BoundaryWorking<R.S, R.S, R.S, R.S>
}
#endif

#if LOCAL_PHASE_BORROWED_MIDPOINT
enum RejectedUnmodifiedBorrowedInterleaving: Null {
    typealias R = BorrowedPhaseBranches<Lit1, Never, Never, Never>
    typealias Left = Paired<R.MidpointZ.Left.Left.Left, R.MidpointZ.Left.Right.Left>
    typealias Right = Paired<R.Z.Answer, R.Z.Answer>
}
#endif
