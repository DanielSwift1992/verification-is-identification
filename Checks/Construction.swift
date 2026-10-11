import VerificationIsIdentification
import Examples

typealias ConstructionZero = Never
typealias ConstructionOne = Paired<Never, Never>
typealias ConstructionTwo = Paired<ConstructionOne, ConstructionOne>
typealias ConstructionThree = Paired<ConstructionTwo, ConstructionTwo>

// Distinct contexts and local outcomes, one operand answer. Only the input
// boundary is shared. No equality of reconstructed answers is a premise.
enum ConstructionAnswerAcrossRealizations<H: Structure, K: Structure, A: Structure, B: Structure, E: Structure, F: Structure>: Null {
    typealias P = RetainedConstruction<H, A, B, E>
    typealias Q = RetainedConstruction<K, A, B, F>
    typealias Derived = SameBoundaryForcesOperands<P, Q>
    typealias Left = Derived.Left
    typealias Right = Derived.Right
}

// A second layout presents the same record fields in reversed order. Decode
// using that layout's actual address, not the old left-address convention.
enum ConstructionAnswerAcrossLayouts<R: Permanent>: Null
where R.Left: Pair, R.Left.Right: Pair,
      R.Left.Right.Left: Structure, R.Left.Right.Right: Structure,
      R.Right.Right: Structure {
    typealias Wire = Paired<R.Right.Right, R.Right.Left>
    typealias Left = Paired<Wire.Right.Right.Left, Wire.Right.Right.Right>
    typealias Right = RecordedOperands<R>
}

typealias ConstructionP = RetainedConstruction<Never, ConstructionZero, ConstructionOne, Never>
typealias ConstructionQ = RetainedConstruction<ConstructionOne, ConstructionZero, ConstructionOne, ConstructionOne>
typealias ConstructionInvariant = SameBoundaryForcesOperands<ConstructionP, ConstructionQ>

// A local first-coordinate result merges distinct ordered operand pairs.
// Their predecessor and the differing second operand remain in the whole.
typealias ConstructionLocal00 = RetainedConstruction<Never, ConstructionZero, ConstructionZero, ConstructionZero>
typealias ConstructionLocal01 = RetainedConstruction<Never, ConstructionZero, ConstructionOne, ConstructionZero>

enum ConstructionLocalOutputsAgree: Null {
    typealias Left = ConstructionLocal00.Right.Right
    typealias Right = ConstructionLocal01.Right.Right
}

enum ConstructionResidualSeparates: Null {
    typealias Left = Paired<RecordedOperands<ConstructionLocal00>.Right, RecordedOperands<ConstructionLocal01>.Right>
    typealias Right = Paired<ConstructionZero, ConstructionOne>
}

enum ConstructionActualContextRetained<H: Structure, A: Structure, B: Structure, E: Structure>: Null {
    typealias Left = RetainedConstruction<H, A, B, E>.Right.Left.Left
    typealias Right = H
}

enum ConstructionActualOperandsRetained<H: Structure, A: Structure, B: Structure, E: Structure>: Null {
    typealias Left = ConstructionRecoversOperands<RetainedConstruction<H, A, B, E>>.Left
    typealias Right = Paired<A, B>
}

// A later event retains the earlier construction, at a deeper address.
enum ConstructionSurvivesLaterEvent<H: Structure, A: Structure, B: Structure, E: Structure, F: Structure>: Null {
    typealias First = RetainedConstruction<H, A, B, E>
    typealias Later = RetainedWhole<First.Right, F>
    typealias Left = Paired<Later.Right.Left.Left.Right.Left, Later.Right.Left.Left.Right.Right>
    typealias Right = RecordedOperands<First>
}

// A supplied output equality suffices for input equality, even for different
// retention witnesses. Neither operand nor context equality is assumed.
enum ConstructionOutputRecovery<P: Permanent, Q: Permanent>: Null
where P.Right == Q.Right {
    typealias Left = RetainedOutputIdentifiesSource<P, Q>.Left
    typealias Right = Q.Left
}

enum AlternateConstructionRetention: Permanent {
    typealias Left = ConstructionP.Left
    typealias Right = ConstructionP.Right
}
typealias ConstructionRecoveredAlias = RetainedOutputIdentifiesSource<ConstructionP, AlternateConstructionRetention>

// Never itself can satisfy the open retention equations. Thus those
// equations do not independently certify that a fresh node was constructed.
enum ConstructionStationaryFloor: Permanent {
    typealias Left = Never
    typealias Right = Never
}
enum ConstructionRetentionDoesNotForceOccurrence: Null {
    typealias Left = ConstructionStationaryFloor.Right
    typealias Right = Never
}

// These three steps witness the finite diagonal grammar's admissible nodes.
// Its finite members have unique decomposition, although mixed pairing is
// not admitted by the constructor family. The mathematical induction is EF8.
typealias ConstructionDiagonal1 = DiagonalConstruction<Never, ConstructionZero>
typealias ConstructionDiagonal2 = DiagonalConstruction<ConstructionDiagonal1.Right, ConstructionOne>
typealias ConstructionDiagonal3 = DiagonalConstruction<ConstructionDiagonal2.Right, ConstructionTwo>

enum ConstructionDiagonalCoordinates<A: Structure, H: Structure>: Null {
    typealias Record = DiagonalConstruction<H, A>
    typealias Left = RecordedOperands<Record>.Left
    typealias Right = RecordedOperands<Record>.Right
}

enum ConstructionDiagonalResultFollows<A: Structure, H: Structure>: Null {
    typealias Record = DiagonalConstruction<H, A>
    typealias Left = Record.Right.Right
    typealias Right = RecordedOperands<Record>
}

typealias ConstructionAt<S, R: Pair> = R where R.Left == S

#if CONSTRUCTION_LOCAL_RESULT_IS_COMPLETE
typealias RejectedConstructionLocalAsWhole = RetainedOutputIdentifiesSource<ConstructionLocal00, ConstructionLocal01>
#endif

#if CONSTRUCTION_LOCAL_RESULT_RECOVERS_BOTH
enum RejectedConstructionLocalRecovery: Null {
    typealias Left = ConstructionLocal01.Right.Right
    typealias Right = RecordedOperands<ConstructionLocal01>
}
#endif

#if CONSTRUCTION_OTHER_OPERAND_BOUNDARY
typealias RejectedConstructionBoundary = SameBoundaryForcesOperands<ConstructionLocal00, ConstructionLocal01>
#endif

#if CONSTRUCTION_REVERSES_OPERANDS
enum RejectedConstructionOrder: Null {
    typealias Left = RecordedOperands<ConstructionP>
    typealias Right = Paired<ConstructionOne, ConstructionZero>
}
#endif

#if CONSTRUCTION_DROPS_ACTUAL_CONTEXT
typealias RejectedConstructionContext = ConstructionAt<Paired<Never, Paired<ConstructionZero, ConstructionOne>>, ConstructionQ>
#endif

#if CONSTRUCTION_EQUAL_ANSWER_IDENTIFIES_OUTPUT
enum RejectedConstructionOutputIdentity: Null {
    typealias Left = ConstructionP.Right
    typealias Right = ConstructionQ.Right
}
#endif

#if CONSTRUCTION_EQUAL_ANSWER_IDENTIFIES_SOURCE
enum RejectedConstructionSourceIdentity: Null {
    typealias Left = ConstructionP.Left
    typealias Right = ConstructionQ.Left
}
#endif

#if CONSTRUCTION_FRESH_RECORD_IS_FLOOR
enum RejectedConstructionFreshFloor: Null {
    typealias Left = RetainedConstruction<Never, Never, Never, Never>.Right
    typealias Right = Never
}
#endif

#if CONSTRUCTION_EQUAL_CHILDREN_ARE_FLOOR
enum RejectedConstructionDiagonalFloor: Null {
    typealias Left = ConstructionDiagonal1.Right.Right
    typealias Right = Never
}
#endif

#if CONSTRUCTION_PARTIAL_BECOMES_TOTAL
typealias RejectedConstructionTotalPairing = ConstructionAt<Paired<Never, Paired<ConstructionZero, ConstructionOne>>, ConstructionDiagonal1>
#endif

#if CONSTRUCTION_LATER_RECORD_IS_EARLIER
enum RejectedConstructionOccurrenceCollapse: Null {
    typealias Left = RetainedWhole<ConstructionP.Right, ConstructionP.Right.Right>.Right
    typealias Right = ConstructionP.Right
}
#endif

#if CONSTRUCTION_LAYOUT_USES_OLD_ADDRESS
enum RejectedConstructionLayoutAddress: Null {
    typealias Wire = Paired<ConstructionP.Right.Right, ConstructionP.Right.Left>
    typealias Left = Paired<Wire.Left.Right.Left, Wire.Left.Right.Right>
    typealias Right = RecordedOperands<ConstructionP>
}
#endif
