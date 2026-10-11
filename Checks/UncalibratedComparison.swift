import VerificationIsIdentification
import Examples

#if !UNCALIBRATED_ODD_CLOSURE && !UNCALIBRATED_FIFTH_READING
enum FiveWordTrianglesFollowTheirActualEndpoints<A: Structure,
    B: Structure, C: Structure, D: Structure>: Null {
    typealias P = FiveContactTriangles<BoundaryWorking<A, B, C, D>>
    typealias Left = P.Left
    typealias Right = P.Right
}
enum CollapsedMarkersAdmitTheTriangle<A: Structure>: Null {
    typealias P = Paired<A, A>
    typealias Left = TriangularContactCalibration<P, P, P>.Left
    typealias Right = A
}
enum FourComparisonsCanAllBeOpposite<A: Structure, B: Structure>: Null {
    typealias V = CoarseContactViews<BoundaryWorking<A, A, B, B>>
    typealias Left = BoundaryWorking<Paired<V.I.Left.Left, V.I.Right.Right>,
        Paired<V.W.Left.Left, V.W.Right.Right>, Paired<V.Z.Left.Left, V.Z.Right.Right>,
        Paired<V.ZW.Left.Left, V.ZW.Right.Right>>
    typealias Right = BoundaryWorking<Paired<A, B>, Paired<B, A>, Paired<A, B>, Paired<B, A>>
}
enum FifthReadingBreaksTheUniformOpposition<A: Structure, B: Structure>: Null {
    typealias T = FiveContactTriangles<BoundaryWorking<A, A, B, B>>
    typealias Left = Paired<T.WW.Left.Left, T.WW.Right.Right>
    typealias Right = Paired<B, B>
}
#endif

#if UNCALIBRATED_ODD_CLOSURE
enum RejectedDistinctMarkersCloseThreeReversals: Null {
    typealias P = Paired<Never, Examples.Succ<Never>>
    typealias Q = Paired<Examples.Succ<Never>, Never>
    typealias T = TriangularContactCalibration<P, Q, P>
    typealias Left = T.Left
    typealias Right = T.Right
}
#endif

#if UNCALIBRATED_FIFTH_READING
enum RejectedFifthReadingRemainsTheOldOpposition: Null {
    typealias A = Never
    typealias B = Examples.Succ<A>
    typealias T = FiveContactTriangles<BoundaryWorking<A, A, B, B>>
    typealias Left = Paired<T.WW.Left.Left, T.WW.Right.Right>
    typealias Right = Paired<A, B>
}
#endif
