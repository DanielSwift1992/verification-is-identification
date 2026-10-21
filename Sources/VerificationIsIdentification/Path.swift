import Notation

// ═══════════════════════════════════════════════════════════════
// Program Is Path (Path).
//
// Basis Is Residue named the HORN: finite basis, infinite reach, "ℕ-under-+: one
// atom, every numeral", and left it as prose: "the unbounded Pair-type itself, not
// expressible as a finite axis" (B8b). This expresses it. The HORN's reach is a
// PATH: a chain of atoms whose every element is finite (the path has a length) while
// the closure remains open (the alphabet is a hollow space). One mechanism carries
// strings, numbers, pinpads, and programs: each is a path of token-atoms, the same
// cons the roster and the secret are built from.
//
// A retained emission can be represented as a path. Reading that path needs
// an actual decoder. The fold/unfold distinction alone equates neither
// writer and reader nor their orders. V=I identifies a member of a supported
// singleton. Admissibility alone can allow several choices. These interfaces
// do not classify language-model behavior by a missing Unique coordinate. PiP7
// separates membership, identification and invariant preservation along a path.
//
// Pure types (§0′). A capstone over Basis Is Residue, Proposal Is Order, Reading Is
// Order, and Distance Is Cost. [PiP]
// ═══════════════════════════════════════════════════════════════

/// The PATH: the order in which a structure is emitted, token by token, a sub-space of Σ.
///
/// A program, a string, a numeral, a pinpad combination: each is a finite path of atoms,
/// consed the way ``/Notation/Pair`` builds every structure. The axis opens the degree of freedom that
/// the order of emission is. A ``Reading`` interface alone supplies no inverse writer.
/// It opens free here and is dimensioned by the theorems below: what the path accumulates, what
/// it costs, what its reach is. [PiP]
public protocol HasPath: HasSigma {
    associatedtype Path
}

/// Names a path transition with a recoverable predecessor projection.
/// RetainedWhole supplies an explicit append. PrefixMemoryAnswer transports
/// an earlier reading through that projection. Permanent alone also admits
/// stationary coordinates and does not supply fresh emission. [PiP PiP2–PiP2a]
public protocol EmissionAccumulates: HasPath
where Path: Permanent {}

/// Equates the represented Distance and Path coordinates. Token length needs
/// a finite list interpretation. Tree-edit distance W uses a different unit:
/// one retaining append can change three tree addresses. Physical cost needs
/// its implementation model. These equalities do not supply it. [PiP PiP3, DiC G2c]
public protocol CostIsPathLength: HasPath, HasDistance
where Path: IntegerValued, Distance == Path {}

/// Gives Path and Basis recursive numeral axes. Finite lists over a declared
/// basis can describe individual members of an unbounded reach. These axes
/// alone specify neither finite depth, token membership nor compiler cost.
/// The explicit grammar supplies that interpretation. [PiP PiP1, EiF EF7, EF10]
public protocol ReachIsPath: HasPath, HasBasis
where Path: IntegerValued, Basis: IntegerValued {}

/// Names a retaining Encoding beside a Path. It does not equate them or supply
/// a next-token rule. SequentialReading binds actual applications when their
/// intermediate source matches. A represented chain alone does not rule out
/// parallel preparation or another construction of the same output. [PiP PiP4]
public protocol EmissionIsAutoregressive: HasPath, ScopeBoundedByEncoding,
    HasEncoding
    where Encoding: Permanent {}

/// Joins reading and retained emission interfaces. A reader can recover an
/// addressed prefix, while another reader may return a coarse answer. This
/// intersection does not equate a writer with an inverse reader. [PiP PiP5]
public protocol ConstructionIsReading: Reading, EmissionAccumulates {}

/// Equates Path with both sides of a Null coordinate. There is no attempted
/// transition or failure condition here. A stationary response is one policy
/// an enclosing system can construct, without being forced by refusal or by
/// closure of the whole. [PiP PiP6, Matter M58]
public protocol InvalidStepFolds: HasPath, Null
where Path == Left {}

/// Joins the declared crystallization and path-retention coordinates.
/// Per-step membership and a supported singleton need their own construction.
/// These inherited interfaces alone do not prove that every emitted step
/// was checked or that a runtime path is valid. [PiP · V=I U1–U2]
public protocol GatedConstruction: HasPath, SystemCrystallizes, EmissionAccumulates {}

/// A generation interface with a represented path and accumulating emission.
/// It does not require or forbid a uniqueness relation. Omitting Unique
/// proves no candidate cardinality and does not prevent a richer conformer
/// from providing a verifier. Runtime totality and soundness likewise need
/// their own implementation evidence. [PiP · Gen GD1, V=I U1]
public protocol FreeGeneration: HasPath, DiscriminatorAndGenerator, EmissionAccumulates {}

/// Joins the proposed reach, emission and construction interfaces. The finite
/// path interpretation needs its constructor grammar, and path validity needs
/// an admitted initial state and preservation by actual steps. The intersection
/// alone does not establish those semantic properties. [PiP PiP7–PiP8]
public protocol ProgramIsPath: ReachIsPath, EmissionIsAutoregressive, GatedConstruction {}

/// Names a reading beside a path and a monotone solution coordinate. A displayed
/// completion list needs admissibility and coverage of the current prefix's
/// domain. The next prefix has a different question context, so its token list
/// need not be a subset of the previous list. Several valid choices may remain.
/// These interfaces alone do not provide that list or its proof. [PiP PiP9]
public protocol CompletionIsSolutionSet: Reading, HasSolutions, HasPath
where SolutionSet: Monotone {}

/// Joins retained emission with the NoInverse interface. An explicit retained
/// prefix supports predecessor recovery, but these parents contain no editing
/// head, archive capacity, allocation cost or reclamation policy. PiP10 states
/// the separate head-recession interpretation and its relation to PiP2a.
public protocol ErasureIsRecession: EmissionAccumulates, NoInverse {}

// ───────────────────────────────────────────────────────────────
// Recorded, not pinned: two extensions the type system cannot axis (the house pattern: a
// corollary the prose states is kept as a comment when no finite axis expresses it, as Basis B8b
// and Gen GD7 are).
//
// LENGTH AND VALUE. Finite lists have length under their tokenization. A value
// decoder needs its admitted representation grammar. Digits and spelled words
// can answer the same number question under different readers while remaining
// distinct paths. Path alone supplies no decoder or token membership proof.
// This does not establish an impossibility of a type-level digit grammar. [PiP §10]
//
// DROP THE COMPILER? The System/Reading split answers it (Architecture §1-2). NAVIGATION is yours:
// walking the trie of realized paths (insert at a boundary, recede the head on erasure, offer the
// children as completions) is a persistent-trie operation, O(depth), immutable, structurally shared.
// A constant, pure engine, and a general compiler is overkill for it. The GATE is not yours to drop:
// a lookup establishes recorded presence. Authorization needs the corresponding
// relation to the current action and context, for example Head.Rank: CanAdmin.
// That condition need not identify one authorized action. A small checker is an
// implementation option, but a small vocabulary does not bound solving cost. [PiP7]
// ───────────────────────────────────────────────────────────────
