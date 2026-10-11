import VerificationIsIdentification

// ═══ THE RYDBERG LADDER — hydrogen's energy as a judged integer lattice.
//
// The law is recorded, and its consequences are judged. One number per floor is
// the whole recording: the depth of floor n is 144/n² in units of R/144, and 144
// is the common denominator of the first four squares. So the four depths are
// 144, 36, 16, 9, and every jump is an integer drop: 4→3 is 7, 3→2 is 20, 4→2 is
// 27, 2→1 is 108. The drops and depths are independently written below.
// Each stitch retains both sides of the proposed count equality. The tests
// read those sides through their actual Structure.count implementations.
//
// The compiler proves the ladder spelling where both sides unfold to one
// written type (the LadderStep witness below). Equal counts do not identify
// those types. The where judge therefore refuses the numerical stitches as
// type equalities; RydbergCountTests checks their distinct count question.
// What is not here is not derivable in this genre and
// is recorded as written law where it is used: the selection rule Δℓ = ±1
// (Hydrogen.swift), the transition rates, and the Rydberg constant itself.
// ═══════════════════════════════════════════════════════════════

// ── the recording: one depth per floor, 144/n². The numerals U1…U128 are the
//    lattice's own ladder (Primitive.swift), read from their one written home. ──

/// The depth of the ground floor: 144 of R/144, the whole Rydberg well.
public typealias FloorOneDepth = Plus<U128, U16>
/// The depth of the second floor: 36.
public typealias FloorTwoDepth = Plus<U32, U4>
/// The depth of the third floor: 16.
public typealias FloorThreeDepth = U16
/// The depth of the fourth floor: 9.
public typealias FloorFourDepth = Plus<U8, U1>

// ── the consequences: each jump's energy, held to the depths ──

/// The Paschen-α drop, floor four to floor three: 7.
public typealias PaschenAlphaDrop = Plus<U4, Plus<U2, U1>>
/// The Balmer-α drop, floor three to floor two: 20.
public typealias BalmerAlphaDrop = Plus<U16, U4>
/// The Balmer-β drop, floor four to floor two: 27.
public typealias BalmerBetaDrop = Plus<U16, Plus<U8, Plus<U2, U1>>>
/// The Lyman-α drop, floor two to the ground: 108.
public typealias LymanAlphaDrop = Plus<U64, Plus<U32, Plus<U8, U4>>>

/// Conditional type identity, stronger than agreement of the count readings.
public protocol EnergyClosed {}
public enum EnergySum<
    Whole: Structure,
    A: Structure,
    B: Structure
>: Pair {
    public typealias Left = Whole
    public typealias Right = Plus<A, B>
}
extension EnergySum: EnergyClosed
where Whole == Plus<A, B> {}

// Proposed count equalities with both endpoints in the same construction.
// Naming these applications does not grant their conditional EnergyClosed
// conformance. Their count readings are checked in RydbergCountTests.
public typealias ThirdFloorStitch = EnergySum<FloorThreeDepth, FloorFourDepth, PaschenAlphaDrop>
public typealias SecondFloorStitch = EnergySum<FloorTwoDepth, FloorThreeDepth, BalmerAlphaDrop>
public typealias GroundFloorStitch = EnergySum<FloorOneDepth, FloorTwoDepth, LymanAlphaDrop>
public typealias TwoRoadsOneDrop = EnergySum<BalmerBetaDrop, PaschenAlphaDrop, BalmerAlphaDrop>

// ── the compile tier: the ladder spelling, proved by the nominal compiler ──

/// The third floor spelled by the ladder: the fourth floor's depth plus the
/// Paschen-α drop. This spelling and the recorded `FloorThreeDepth` name one
/// number under the count reading. The compiler proves the separate nominal
/// ladder witness below without identifying these different constructions.
public typealias FloorThreeByLadder = Plus<FloorFourDepth, PaschenAlphaDrop>

public protocol LadderStitched {}
public enum LadderStep<
    A: Structure,
    B: Structure
> {}
extension LadderStep: LadderStitched
where A == B {}

/// The compiled witness: both sides unfold to one written form, so the
/// conformance is granted by the compiler itself. The same equality is also
/// judged, so the two arbiters answer for one stitch.
public let thirdFloorByLadder: LadderStitched.Type = LadderStep<FloorThreeByLadder, Plus<FloorFourDepth, PaschenAlphaDrop>>.self
