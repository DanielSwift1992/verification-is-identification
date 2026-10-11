import VerificationIsIdentification
import Examples

#if !JOINT_READOUT_INDEPENDENT && !JOINT_READOUT_PROJECTION
enum TwoFreeCodesRespectActualJointContacts<A: Structure, B: Structure>: Null {
    typealias V = TwoOrbitReadout<A, B>.Views
    typealias Left = Paired<V.I, V.I>
    typealias Right = Paired<V.W, V.Z>
}
enum JointConstructionRetainsBothActualCodes<A: Structure, B: Structure>: Null {
    typealias T = TwoOrbitReadout<A, B>
    typealias P = JointInvariantPairReadout<T.R0, T.R1, T.R2, T.R3>
    typealias Left = Paired<P.Left.Left.Left.Left.Left, P.Left.Left.Left.Left.Right>
    typealias Right = Paired<A, B>
}
enum MovingOneArgumentChangesTheSelfReading<A: Structure, B: Structure>: Null {
    typealias V = TwoOrbitReadout<A, B>.Views
    typealias Left = Paired<V.I.Left.Left.Left.Left, V.FirstW.Left.Left.Left.Left>
    typealias Right = Paired<A, B>
}
enum AReframedProjectionCanCompensateTheSourceMove<A: Structure,
    B: Structure, C: Structure, D: Structure>: Null {
    typealias RA = BoundaryWorking<A, A, A, A>
    typealias RB = BoundaryWorking<B, B, B, B>
    typealias RC = BoundaryWorking<C, C, C, C>
    typealias RD = BoundaryWorking<D, D, D, D>
    typealias Original = PairReadoutViews<RA, RB, RC, RD>
    // Inverse W reframes the readout: rows D,B,A,C. Applying W to
    // both new source arguments restores the old table, for any A–D.
    typealias Reframed = PairReadoutViews<RD, RB, RA, RC>
    typealias Left = Reframed.W
    typealias Right = Original.I
}
enum ConstantReadoutAdmitsIndependentMovement<A: Structure>: Null {
    typealias Left = IndependentReadoutCollapse<A, A>.Left
    typealias Right = A
}
#endif

#if JOINT_READOUT_INDEPENDENT
enum RejectedIndependentMovementPreservesDistinctReadoutCodes: Null {
    typealias P = IndependentReadoutCollapse<Never, Examples.Succ<Never>>
    typealias Left = P.Left
    typealias Right = P.Right
}
#endif

#if JOINT_READOUT_PROJECTION
enum RejectedCoordinateCovarianceIsFixedReadoutInvariance: Null {
    typealias A = Never
    typealias B = Examples.Succ<A>
    typealias C = Examples.Succ<B>
    typealias D = Examples.Succ<C>
    typealias P = JointInvariantPairReadout<BoundaryWorking<A, A, A, A>,
        BoundaryWorking<B, B, B, B>, BoundaryWorking<C, C, C, C>,
        BoundaryWorking<D, D, D, D>>
    typealias Left = P.Left
    typealias Right = P.Right
}
#endif
