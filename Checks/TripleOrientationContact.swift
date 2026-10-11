import VerificationIsIdentification
import Examples

#if !TRIPLE_ORIENTATION_MERGER && !TRIPLE_ORIENTATION_STALE_CONTACT
enum DirectPairsDoNotReadTheTripleOrientation<A: Structure, B: Structure>: Null {
    typealias T = TwoOrbitReadout<A, B>.Table
    typealias Left = Paired<Paired<T.Left.Left.Left.Right, T.Left.Right.Right.Left>,
        Paired<T.Right.Left.Left.Left, Paired<T.Left.Right.Left.Left,
            Paired<T.Left.Left.Right.Left, T.Right.Left.Left.Right>>>>
    typealias Right = Paired<Paired<B, B>, Paired<B, Paired<B, Paired<B, B>>>>
}
enum ActualOrientationWordsReadAndReturn<A: Structure, B: Structure>: Null {
    typealias P = TripleOrientationContact<A, B>.ReturnedTableAndAcquiredAnswers
    typealias Left = P.Left
    typealias Right = P.Right
}
enum CommonReframingCarriesTheEffectiveContact<A: Structure, B: Structure>: Null {
    typealias P = TripleOrientationContact<A, B>.ReflectionConjugatesTheContact
    typealias Left = P.Left
    typealias Right = P.Right
}
enum TransportedContactRestoresTheRelativeAnswer<A: Structure, B: Structure>: Null {
    typealias P = TripleOrientationContact<A, B>
    // Reflecting (0,1,2) gives (1,0,2). Its response under the
    // transported q is at row 1, column 0 of the reflected table.
    typealias Left = Paired<P.ForwardProbe.Answer, P.Reflected.Left.Right.Left.Left>
    typealias Right = Paired<A, A>
}
enum ACollapsedComparatorDoesNotWitnessOrientation<A: Structure>: Null {
    typealias P = TripleOrientationContact<A, A>
    typealias Left = P.ForwardPath.Right.Right.Answer
    typealias Right = P.ReversePath.Right.Right.Answer
}
#endif

#if TRIPLE_ORIENTATION_MERGER
enum RejectedOppositeTripleContactsHaveTheSameAnswer: Null {
    typealias P = TripleOrientationContact<Never, Examples.Succ<Never>>
    typealias Left = P.ForwardPath.Right.Right.Answer
    typealias Right = P.ReversePath.Right.Right.Answer
}
#endif

#if TRIPLE_ORIENTATION_STALE_CONTACT
enum RejectedReflectedInputUsesTheUntransportedContact: Null {
    typealias P = TripleOrientationContact<Never, Examples.Succ<Never>>
    typealias Left = P.ReverseProbe.Answer
    typealias Right = P.Reflected.Left.Right.Left.Left
}
#endif
