import VerificationIsIdentification

// ═══ THE RYDBERG LADDER — hydrogen's energy as a judged integer lattice.
//
// The law is recorded, and its consequences are judged. One number per floor is
// the whole recording: the depth of floor n is 144/n² in units of R/144, and 144
// is the common denominator of the first four squares. So the four depths are
// 144, 36, 16, 9, and every jump is an integer drop: 4→3 is 7, 3→2 is 20, 4→2 is
// 27, 2→1 is 108. The drops are written below, and every one of them is held to
// the depths by a judged equality, so the two roads down from the fourth floor,
// the telescoping 7 + 20 = 27, and the unequal step sizes are consequences of
// the four recorded numbers, and a lie in any number is an addressed refusal.
//
// Two tiers carry the equalities, by what each arbiter reads. The compiler is
// nominal: it proves the ladder spellings, where both sides unfold to one
// written form (the LadderStep witness below). The second judge carries the
// counting canon (swift run Tools judge where): it folds any spelling of a
// number to the number itself, so 9 + 7 == 16 is judged even where the compiler
// sees two different types. What is not here is not derivable in this genre and
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

/// A whole that must be the sum of its two parts. The judge folds any spelling
/// of a number to the number itself, so the equality is arithmetic, not a
/// spelling match.
public protocol EnergyClosed {}
public enum EnergySum<
    Whole: Structure,
    Left: Structure,
    Right: Structure
> {}
extension EnergySum: EnergyClosed
where Whole == Plus<Left, Right> {}

// The stitches, as typealias certificates: every drop is held to its two
// floors, and the two roads down from the fourth floor are one drop in energy.
// The judge reads each certificate against the gate above and folds both
// sides to numerals.
public typealias ThirdFloorStitch = EnergySum<FloorThreeDepth, FloorFourDepth, PaschenAlphaDrop>
public typealias SecondFloorStitch = EnergySum<FloorTwoDepth, FloorThreeDepth, BalmerAlphaDrop>
public typealias GroundFloorStitch = EnergySum<FloorOneDepth, FloorTwoDepth, LymanAlphaDrop>
public typealias TwoRoadsOneDrop = EnergySum<BalmerBetaDrop, PaschenAlphaDrop, BalmerAlphaDrop>

// ── the compile tier: the ladder spelling, proved by the nominal compiler ──

/// The third floor spelled by the ladder: the fourth floor's depth plus the
/// Paschen-α drop. This spelling and the recorded `FloorThreeDepth` name one
/// number, and the two arbiters split the two identities: the compiler proves
/// the ladder witness below nominally, and the judge folds both spellings to 16.
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
