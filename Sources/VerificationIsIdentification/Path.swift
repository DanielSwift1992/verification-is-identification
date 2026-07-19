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
// Two readings cross here. The READ-order (Reading Is Order: the agent is the order a
// standing structure is traversed) and the WRITE-order (Proposal Is Order: the
// generator is the order candidates are proposed) are one navigation over one path,
// emission is reading run forward. And the gate that V=I built (|S|=1, the
// crystallizing cut) is exactly what an ungated generator lacks: a free generation is
// a path nothing cut to one survivor, which is what a language model does and why it
// hallucinates. The missing coordinate is named, not hidden (IiI's SystemCrystallizes
// idiom, lifted to emission).
//
// Pure types (§0′). A capstone over Basis Is Residue, Proposal Is Order, Reading Is
// Order, and Distance Is Cost. [PiP]
// ═══════════════════════════════════════════════════════════════

/// The PATH: the order in which a structure is emitted, token by token, a sub-space of Σ.
///
/// A program, a string, a numeral, a pinpad combination: each is a finite path of atoms,
/// consed the way ``Pair`` builds every structure. The axis opens the degree of freedom that
/// the order of emission *is* (``Reading`` reads it backward, a generator writes it forward).
/// It opens free here and is dimensioned by the theorems below: what the path accumulates, what
/// it costs, what its reach is. [PiP]
public protocol HasPath: HasSigma {
    associatedtype Path
}

/// Emission ACCUMULATES: the path only grows, each token consed ahead of the rest.
///
/// To emit a token is to extend the path, not to revise it: the written prefix is there for good
/// (`Path: Permanent`, after ⊇ before). So the path is its own history: drop the last token and
/// the prior state is exactly there, the cons-list the secret and the roster are. The write-order
/// is monotone, the mirror of the discriminator's shrinking candidate set. [PiP · cf. Read]
public protocol EmissionAccumulates: HasPath
where Path: Permanent {}

/// COST is the path's LENGTH: a construction pays one distinction per token, and the total is the
/// count of tokens.
///
/// In Distance Is Cost, distance is an integer count of steps. Here the steps are the tokens, so the
/// cost of a construction *is* its path length, pinned by closing the two axes onto one
/// (`Distance == Path`, a ``Null`` between cost and path). A short path is a cheap object, a long
/// one dear, and nothing else enters the price. [PiP · DiC G2c]
public protocol CostIsPathLength: HasPath, HasDistance
where Path: IntegerValued, Distance == Path {}

/// REACH is a PATH: the hollow space whose reach has no axis in Basis Is Residue is the path itself.
///
/// The HORN has a finite basis and an infinite reach (`Basis: IntegerValued`, one atom, the
/// successor) yet every reachable element is finite (`Path: IntegerValued`, a counted chain). That
/// is the whole of B8b's open point: the closure is open, each path is finite, and the compiler
/// does not build the closure, it materializes only the paths actually walked. The space is large in
/// potential and cheap in fact, hollow because its members enter by declaration, never by
/// enumeration from it. [PiP · Basis B8b]
///
/// > Note: This is why a type-level string space does not explode the compiler. The reach is
/// > inverted, the concrete path depends on the alphabet, not the alphabet on its closure, so
/// > the realized cost is the length walked, linear in use, never the cardinality of the space.
public protocol ReachIsPath: HasPath, HasBasis
where Path: IntegerValued, Basis: IntegerValued {}

/// Emission is AUTOREGRESSIVE: the space of the next token is bounded by the encoding, and the
/// encoding is the prefix already emitted, so the path is written one token at a time.
///
/// The next choice is conditioned on the path so far (`ScopeBoundedByEncoding`: the reachable scope
/// stops at the encoding), and the encoding grows with each token (`Encoding: Permanent`). The two
/// together force order: the space of step n+1 cannot be materialized until step n is in the
/// encoding, so emission is sequential by construction, not by convention. This is the generator's
/// Y-axis (Proposal Is Order: which candidate next) made dependent on its output. [PiP · Gen GD1]
public protocol EmissionIsAutoregressive: HasPath, ScopeBoundedByEncoding,
    HasEncoding
    where Encoding: Permanent {}

/// CONSTRUCTION is READING run forward: emitting a path and traversing one are the same navigation.
///
/// In Reading Is Order a reading walks a standing structure: the order is the agent, the zipper's
/// walk. Emission writes one: the order is the generator, the same walk the other way. They are
/// one navigation over one path (`Reading` met with the accumulating emission): the discriminator
/// folds μ-ward, the generator unfolds ν-ward, and the path is what both move along. So to write
/// a program and to read it are not two acts: the trace the construction leaves IS the object
/// read back. [PiP · Read]
public protocol ConstructionIsReading: Reading, EmissionAccumulates {}

/// An INVALID step FOLDS onto itself: a token that cannot validly extend the path closes the path
/// rather than branching the space.
///
/// A continuation either type-checks (the cons forms) or it does not, and the one that does not
/// has no inhabitant to branch into. So the only total option is to fold onto the path already
/// there (`Path == Left`, a ``Null`` on the path: the two sides close), sharing one length node
/// instead of opening a new subtree. This keeps a construction total without bloating Σ: invalid
/// paths self-reference, they do not multiply, the same collapse the pinpad makes when every wrong
/// combination runs onto one length line rather than a 9⁴ tree. [PiP · Nav N6]
public protocol InvalidStepFolds: HasPath, Null
where Path == Left {}

/// A GATED construction: every step is a crystallizing cut, so the path lands on one survivor, total
/// AND sound.
///
/// The discriminator gates each token (`SystemCrystallizes`: the candidate set narrows to `|S|=1`
/// and cannot be budged), and the path accumulates beneath it (`EmissionAccumulates`). So the object
/// built is the one the gate admits: verification is identification, run as a construction. Every
/// emitted path is valid because an invalid step never passed the cut. [PiP · IiI §5]
public protocol GatedConstruction: HasPath, SystemCrystallizes, EmissionAccumulates {}

/// A FREE generation: a path driven by the generator alone, order without the cut. Total, not
/// sound.
///
/// It proposes and accumulates (`DiscriminatorAndGenerator`, `EmissionAccumulates`) but nothing
/// pins the survivor to one: `SolutionSet` is not ``Unique`` here, so `|S| > 1` persists and the
/// path is built on candidates the cut never touched. This is the language model: it always
/// emits (total) yet the emitted path need not be valid (unsound), and the coordinate it is
/// missing is exactly the gate ``GatedConstruction`` has. The compiler names that coordinate:
/// a free generation cannot be gated without proving the uniqueness it does not have. [PiP · Gen GD1]
///
/// > Note: Hallucination is not a defect added to generation. It is generation with the
/// > discriminator removed, the organ that carries every identification bit (Proposal Is Order) is
/// > the one absent, so what is left is order with no information to make it true.
public protocol FreeGeneration: HasPath, DiscriminatorAndGenerator, EmissionAccumulates {}

/// PROGRAM is PATH: a construction is a finite, gated, autoregressive path over a hollow space.
///
/// The capstone intersects the three readings in one object. The reach is a path (``ReachIsPath``,
/// hollow space, finite walk), the emission is sequential (``EmissionIsAutoregressive``, one token
/// at a time), and each step is gated (``GatedConstruction``, the cut that keeps it sound). A
/// program is then nothing but the path its construction walked, read back: `act ≡ write ≡ prove`
/// at the level of the token. Without the gate the same path is a free generation. Without the
/// finiteness the reach is the open HORN. This is where all three close at once. [PiP]
public protocol ProgramIsPath: ReachIsPath, EmissionIsAutoregressive, GatedConstruction {}

/// COMPLETION is the SOLUTION SET: the continuations at a node are exactly the candidates
/// verification still admits there, read forward as the path is walked.
///
/// Typing a token is a `COMPARE`, a cut, so the candidate set only shrinks (`SolutionSet:
/// Monotone`), and the list shown at the cursor IS that set at the current prefix. Authoring is
/// verifying: the suggestion is the proof state, not a second index built beside it. When the set
/// reaches one the segment crystallizes (the boundary), and the next node opens its set,
/// conditioned on the prefix. So an editor's completion is the V=I loop made visible: ``Reading``
/// over the solution axis, walked along the path. A model shows the same list ungated. The editor
/// shows it cut to the survivors, which is why a suggested path is always valid. [PiP · Read]
public protocol CompletionIsSolutionSet: Reading, HasSolutions, HasPath
where SolutionSet: Monotone {}

/// ERASURE is HEAD RECESSION: deleting the last token moves the reading head back and destroys
/// nothing: the object is in the monotone history.
///
/// The record is append-only (``NoInverse``: the system retracts no written fact), so an edit cannot
/// delete at the system level. What "erasing `hello`" does is recede the head: drop the focus and
/// the prior state is exactly there, the chain reversible by construction (``EmissionAccumulates``).
/// The object goes unreachable from the head, not gone, which is why undo costs nothing. Garbage is
/// what no path reaches from the head, not what was removed, so collecting it is a reachability sweep
/// that trades the kept history for space, deliberate, not the default. [PiP · IiI §2]
public protocol ErasureIsRecession: EmissionAccumulates, NoInverse {}

// ───────────────────────────────────────────────────────────────
// Recorded, not pinned: two extensions the type system cannot axis (the house pattern: a
// corollary the prose states is kept as a comment when no finite axis expresses it, as Basis B8b
// and Gen GD7 are).
//
// TWO INTEGERS. Every path carries a LENGTH (``CostIsPathLength``, Path: IntegerValued), the count
// of tokens, read off any path. A path carries a VALUE, the place-value fold, the digits read by
// their base, only when its tokens are themselves numerals. Length is universal, Value is gated on
// the alphabet, and that gate IS the user-visible fact that a letter-path has no integer reading
// while a digit-path does: the projection is the conformance, not a runtime test. Swift cannot
// quantify "every token is a numeral" over an open Path, so the Value fold remains prose, the
// soundest witness is the digit path (``HollowReach``), whose tokens ARE counts. [Basis B8b]
//
// NUMBER AND WORD. The numeral one and the word o·n·e are two paths over two alphabets, joined by a
// determined coercion (one settled value each way), not an identity: the numeral carries the Value
// fold, the word does not, so identifying them would erase the gate. The bridge is named and crossed
// on purpose, atoms remain distinct, relations remain explicit, the directory law. [Basis]
//
// DROP THE COMPILER? The System/Reading split answers it (Architecture §1-2). NAVIGATION is yours:
// walking the trie of realized paths (insert at a boundary, recede the head on erasure, offer the
// children as completions) is a persistent-trie operation, O(depth), immutable, structurally shared.
// A constant, pure engine, and a general compiler is overkill for it. The GATE is not yours to drop:
// the cross-axis proof (`where Head.Rank: CanAdmin`, |S|=1, the markers) is what a trie lookup cannot
// does: a lookup says "this path exists", not "this access is authorized". Drop the prover and the
// gate goes with it, and a gated editor decays into the ungated walk that IS a language model
// (``FreeGeneration``). The proof is not droppable, but it is SMALL: the whole of it is the seven
// markers, each a simple relation on ``Pair``. A checker over those seven, run on the trie, is the
// "pure constant" engine done right: keep the navigation, a tiny prover, not a full compiler
// and not none. [Basis]
// ───────────────────────────────────────────────────────────────
