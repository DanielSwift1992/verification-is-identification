// THE LAW names how every protocol in Σ must be written.
//
// The canonical statement is the doc-comment below: it renders as the ``Law``
// page and is the single source of truth. Primitive, Core, VI, IiI: every
// Theory file enacts it. The compiler enforces the checkable subset. `Tools
// grammar` carries §0′/§S4/§S22 per file, per scope. `Tools lint` checks the
// cross-file rest (§1 RENAME, §2 OPEN AXIS, PROVENANCE), run automatically by
// the LawCheck plugin on Organization and by hand elsewhere. What neither
// reaches is checked by review. The law is written in the thing it governs,
// it is itself Pair and Null all the way down (§6).

/// The rules for stating relations and deriving consequences in the chosen
/// type grammar.
///
/// Add an axis to expand a protocol. Close, pin or intersect relations to
/// compress it. Every protocol must make one of these moves and express its
/// relation through the types (§1–§3).
///
/// - term Seed: ``Pair`` has two addressed roles whose contents can agree.
///   ``Null`` equates those sides. Its conformers need not be `Never` (§0).
/// - term Proof: state quantities, premises and conclusion. Supply the related
///   axes in a generic construction requiring only the premises, and check its
///   conformance for every admitted substitution (§T). A named refusal tests
///   the attempted incompatible construction under its constraints (§0′, §T).
/// - term Floor: total structural comparison uses finite trees in a stated
///   constructor grammar. Exhaustive finite search also needs a sufficient
///   obtainable bound for its candidate carrier. ``Pair``/``Null`` conformance
///   alone supplies neither termination argument (§0′, §4).
/// - term Application: using the result for its intended task needs a justified
///   link to the actual source and original question (§0′).
///
/// The sections below retain the pure-type and writing rules (§0′–§0″),
/// the roots, the law's own expression and the dependency order (§5–§7).
///
/// ## §0 · The seed and its fixpoint
///
/// The lattice grows from one act, ``Pair`` (a distinction), and closes at its
/// fixpoint ``Null``. Everything reduces to them. They are primitive here, the
/// lattice starts from them. Existence Is Finite now states the finiteness and
/// constructor premises required for its representation theorem. A term reducing
/// to neither is foreign to this chosen grammar, and the law rejects it (§6).
///
/// - ``Pair``: two addressed roles in one type relation
///   (`associatedtype Left`, `associatedtype Right`).
/// - ``Null``: the equality constraint on ``Pair``'s sides, `Left == Right`.
///   `Never` conforms, but other conformers need not equal that syntax leaf (EiF EF4).
///
/// The two roles of ``Pair`` need not have different contents. A realized
/// distinction needs a separating relation, such as the explicit constructor
/// boundary of ZeroSuccessorDistinction. Its name or Pair conformance alone
/// supplies no refusal. The Cut takes encountered contrast as given at Step 2,
/// rather than deriving it from Step 1's bare happening. Matter M71 locates
/// the corresponding obstruction in the relations a proposed identification
/// would have to preserve.
/// Existence C4 distinguishes these compared roles from an exhaustive binary
/// partition, a physical transmission, or the birth of two participants.
///
/// A side can carry another structured pair. Two constructor fields do not
/// restrict the medium to binary predicates on Boolean variables. Verdict
/// VC23a proves that this narrower grammar cannot express ternary parity,
/// even with hidden bits, while a structured carrier can express it.
/// Liquid LQ16 recovers roles from exact self-contact and contextual
/// substitution, for any positive finite number of input places. It does
/// not derive binary arity. A recombination can return its source on the
/// diagonal. A fresh retained constructor creates another form. State which
/// relation is intended before treating a pair expression as either one.
/// ReversedCutAgreement derives equal source fields when both recombination
/// orders give one result. Symmetric joint assembly instead has LQ15's union
/// law, which can be associative while retaining higher joint refusals.
/// Equality of separate contact profiles does not determine that whole law.
///
/// ## §0′ · Pure types
///
/// The medium is the type system and nothing else. There is no runtime, no
/// values, ever. You read a fact by asking the type checker: *does `X`
/// conform? what is `X.SolutionSet`?*, not by computing a value.
///
/// > Important: A method that *returns* the claim is a value, that is runtime,
/// > and it is wrong here. The claim **is** the conformance. Reading it is the
/// > type checker's job, not a function's. That purity fixes where the claim
/// > is expressed. Total comparison follows for the stated finite constructor
/// > grammar, not for every recursive Swift requirement system.
///
/// > Tip: State the relation before translating a procedure. If projection,
/// > equality or composition already supplies the result, its execution loop
/// > and bookkeeping need no separate axes. Introduce a coordinate when the
/// > relation must distinguish it, rather than to mirror an implementation.
/// > Moving an iteration into generic types does not by itself remove that
/// > iteration from the theory. First ask whether shared fields and their
/// > constraints already force the requested answer. LQ16 reconstructs the
/// > roles of an admitted joining from contextual substitution. It needs no
/// > prescribed schedule that discovers or adjusts those roles. A checking
/// > procedure can still have a cost without becoming an axis of that form.
///
/// A finite derivation can force an answer without enumerating the medium.
/// Matter M71 states its extension rule: adding forms cannot undo an identity
/// consequence while preserving the addressed premises. A positive source
/// distinction can therefore exclude a joining throughout those extensions.
/// Establishing the premises about an actual contact remains a source relation,
/// which the existence of their type inscription alone does not provide.
/// An operation and a change of representation have different obligations.
/// Under a new representation, the question must still address the same content.
/// Space S25 derives that agreement and separates an invariant reading from
/// the stronger identification of every transported form with its source.
/// A description can also retain a change through a derived change of its
/// answers. Requiring each answer to remain constant is an extra contract.
/// Reducing symmetric roles separately can erase their joint distinction.
/// Verdict §2 retains the common context before making that identification.
///
/// The object checked here is a type and its addressed relations. A caseless
/// enum has no runtime inhabitants. That does not make its conformance false.
/// ``Null`` identifies its two sides, not all conformers or all their readings.
/// Failure to establish a conformance is not a conformance to its negation.
/// A named refusal checks that attempted construction under those premises.
/// It does not decide every other construction or the physical whole.
/// Coexisting records need not supply one invariant answer (Verdict VC43).
/// Equal images do not identify sources or license every continuation. A
/// continuation through the common image needs its supplied reading at that
/// image. Lifting the equality to sources needs a separately established
/// recovery. Equality transported through a supplied decoder proves neither
/// completeness of that decoder nor determinacy of the underlying contact.
/// LQ16 instead derives determinacy from exact self-contact and contextual
/// substitution. Those laws must be derived for the construction in use.
/// Naming its types or observing one matching answer does not supply them.
/// Equality of source types checks the represented addresses. If several
/// physical occurrences have the same representation, this equality alone
/// does not identify those occurrences or establish a physical connection.
/// Such identification requires a source relation preserved by that encoding.
/// System §1b applies the same derivation obligation to the modeling step.
/// Its U4 rule transports the source premises into a related description,
/// applies the inner proof and returns its claim to the original question.
/// A logical existence proof may support that inference without providing an
/// executable translation. Composed translations must share their actual
/// intermediate witness and carry the premises needed by the next one.
/// Changing a description, acting on the source and revising the requirement
/// therefore have different application obligations. The metarule is itself
/// conditional. It does not certify an arbitrary encoding or its own physical
/// implementation from the checker's acceptance of a named conformance.
///
/// | Allowed | Forbidden |
/// | --- | --- |
/// | `protocol`, `extension` (conformance only) | `func`, `case` |
/// | `typealias`, `associatedtype` | stored or computed `var` |
/// | `where` clauses | `init`, `subscript`, `operator` |
/// | `enum` whose only members are `typealias` | `struct`, `class` (instantiable) |
///
/// ## §0″ · Concrete types
///
/// A concrete type is always an `enum`: caseless (`Close`) when it is a phantom
/// point in the lattice, or with a `Body` (`Open`) when it composes other types.
/// `struct` and `class` are forbidden: they can be instantiated.
///
/// - term This grammar puts `<>` on `enum` only. Protocol axes are declared with
///   `associatedtype`. Swift also permits primary associated type lists in
///   angle brackets. Those name associated types and are not concrete generic
///   constructors ([SE-0346](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0346-light-weight-same-type-syntax.md)).
/// - term Name over angle brackets. If you use a generic instantiation more than once,
///   give it a `typealias`. Write `Never` instead of `Cell<Never, Never>` when the
///   Pair floor suffices. Raw `<>` is allowed only when no simpler name exists.
/// - term Angles open like a tree. One bare argument is inline (`Succ<Prev.Length>`).
///   From the second argument, or the first constraint in the list, the angles open:
///   each argument on its own line, the closing `>` on its own. The nesting is then in the
///   indent, the way it is already in a `body`'s braces, and the opened brackets are the
///   tree, uniform for any eye, whatever language it came from.
/// - term Supplementary information has one home. `where` is on its own line, always,
///   after a generic list, after a conformance list, in a `for`, and so are `var` and
///   `typealias` inside a declaration. What may be in two places is hunted in both
///   by the reader. One home ends the hunt, and the eye lands where it expects.
///   Modifiers (`public`, `static`) are transparent: they are before the word, and
///   the line is still the word's. A `body`'s statements are free: nobody hunts
///   inside a body, §S7 reads it whole, and packed leaves are why a long spell is
///   not one-story sprawl. The grammar enforces the home as a name: an atom out of
///   place is carried as `Midline` and `Midline` is granted nothing.
///
/// ## §1 · Two moves, and you must make one
///
/// ```swift
/// associatedtype Distance   // EXPAND:   open a degree of freedom
/// where X == Y              // COMPRESS: close it to a point   (→ Null)
/// where X: SomeMarker       // COMPRESS: pin it to a property  (→ partial Null)
/// protocol P: A, B          // COMPRESS: intersect, keep only what A and B share
/// ```
///
/// There is no third move. Close, pin, and intersect are all forms of compress:
/// each narrows the space. Every protocol is one or more of these two moves.
///
/// > Warning: The **rename** is forbidden: one parent, no axis, no `where`:
/// > `protocol Renamed: Parent {}` makes no move and adds nothing (`Renamed`
/// > and `Parent` are one space under two names). Test it: delete the protocol.
/// > If nothing breaks that a parent did not already guarantee, it was a rename.
/// > The linter rejects this form on every build.
///
/// The equal-opposite pair rule does not normalize every multi-phase sum.
/// IiS2-IiS3 give its conserved amplitude and a nonempty zero-sum residue.
/// The retired Wave coordinates supplied no equation for that question.
/// This law requires an actual relation before such coordinates return. [IiS IiS2–IiS3]
///
/// ## §2 · Every axis gets a dimension
///
/// A bare `associatedtype X` is a *free* axis: dimensionless, hence infinite.
/// To give it a dimension is to constrain it with `where`. Every axis opened by
/// *expand* must be closed by *compress* in at least one protocol. Opening and
/// closing may be apart. The place of the pin is the claim's
/// **status**:
///
/// - term Inline (`associatedtype X: M`): *definitional*, true by what `X` is.
///   It opens and dimensions in one act.
/// - term Theorem (`where X: M`): the *conclusion to check*, at the protocol
///   that states the relation. A derivation also needs the witness of §T.
///
/// This placement records the author's intended role. Swift enforces an inline
/// bound and the corresponding `where` bound alike. Moving the same constraint
/// cannot by itself turn an assumption into a derivation.
///
/// > Tip: **The placement test.** A constraint is definitional (inline) if no
/// > valid inhabitant of the axis *could* violate it, it cuts only the
/// > impossible. It is derived (theorem) if a valid inhabitant *could* violate
/// > it and the dynamics prove it does not. `Law: Pair` (every law is a
/// > structure) → inline. `Cache: Permanent` (a cache could be mutable, I3
/// > forbids it) → theorem.
///
/// ## §3 · A relation is expressed, never tagged
///
/// A marker presents a relation between addressed roles. A function additionally
/// requires one output for each admitted complete input. A `where` clause can
/// express a contact without establishing that uniqueness. A constructor can
/// derive its output from the input fields, and Liquid LQ16 gives conditions
/// under which a contact relation itself forces determinacy.
/// To derive an answer from a source, fix that source's contract independently
/// of the particular answer claimed.
/// Appending that answer makes it a projection of the resulting record.
/// Matter §6 shows why this alone derives no function on the original source.
/// A marker with no additional relation is a tag: a rename of ``Pair``, forbidden.
/// ``Permanent`` and ``Monotone`` are mirror images, and the `where` is the only
/// thing that tells them apart:
///
/// ```swift
/// protocol Permanent: Pair where Right: Pair, Right.Left == Left {}  // after ⊇ before
/// protocol Monotone:  Pair where Left: Pair,  Left.Left  == Right {} // after ⊆ before
/// ```
///
/// Without the `where` they state the same field contract. Their nominal names
/// remain distinct. `Permanent` still allows different retained extensions of
/// one source, so that relation alone is not a single-valued update rule.
///
/// > Tip: **Parent or pin.** There are two ways to attach a marker, and the choice is itself a
/// > claim. Make it a *parent* (`protocol P: Decidable`) when the protocol itself is
/// > that thing: P *is* the decision, the measurement. Make it a *pin*
/// > (`where Axis: Decidable`) when P itself is not, but one of its axes is. The
/// > test: does the marker name the protocol's own ``Pair``, or one of its axes?
///
/// ## §4 · Finite = width × depth
///
/// Finite names both bounds, not just one. Width is bounded by the shape
/// itself: a ``Pair`` has exactly two sides, never infinitely many. Depth also
/// needs a floor: each chain in the interpreted tree must reach its declared
/// terminal. Swift permits recursive associated types, so `Left = Self` can
/// compile under ``StructuresFinite``. That protocol alone does not prove the
/// descent ends. Finite expressions in a stated constructor grammar provide
/// one scoped witness. Arbitrary conformances do not inherit that argument.
/// Width and depth must both close, and the certificate must name how.
/// Recursion can still establish an exclusion without proving finite depth.
/// EmptyCandidateSupport binds CandidateNode.Leaf to Never at each node and
/// requires empty children. Every finite child path retains that constraint,
/// so it cannot reach CandidateLeaf, whose original Leaf witness is itself.
/// A leafless cycle is admitted. A leaf with empty payload is not empty.
/// VC31 distinguishes this source-bound safety property from termination.
/// EiF EF10 derives the exclusion from complete child closure and original
/// node tags. VC23 separately retains jointly required proof premises and
/// the dependencies of a given whose internal support is being examined.
/// A finite tree does not make the space of all such trees finite. EiF EF5–EF6
/// separates finite members from a uniformly bounded candidate space. Total
/// free pairing cannot close on a finite carrier. Each finite game must state
/// its own bound, and a tower of finite games needs a separate height argument.
///
/// ## §5 · Nothing floats
///
/// Trace any protocol up its parents: it must reach ``Pair``. Trace any structure
/// down: it must reach ``Null``. Markers are rooted in ``Pair`` or ``Null``. Axes are rooted
/// in the one space-root ``HasSigma``. Theorems are rooted in markers and axes.
/// The law rejects a protocol that reaches neither.
///
/// ## §6 · The law obeys the law
///
/// The law is written in ``Pair`` and ``Null``:
///
/// | Construct | Reading |
/// | --- | --- |
/// | `associatedtype` | ``Pair``, two sides: the name and its protocol |
/// | `where X == Y` | ``Null``, the two sides close |
/// | `where X: M` | partial ``Null``, the side is pinned |
///
/// Even the two moves are a ``Pair`` (expand or compress) whose ``Null`` is
/// "no net change": the forbidden rename of §1. The test for any *new* rule:
/// state it in ``Pair``/``Null``. If it cannot be said in those terms, it is
/// foreign, do not add it.
///
/// ## §T · Translation: any theorem → types
///
/// The algorithm that turns a published theorem into a protocol. A theorem is
/// *premises ⟹ conclusion*. Fill four slots, then render.
///
/// | Slot | Becomes |
/// | --- | --- |
/// | **quantities**: what it is about | one axis each (`associatedtype`), pinned by a marker |
/// | **premises**: what it assumes | parent protocols (intersect) |
/// | **conclusion**: what it proves | a `where` pinning the fixpoint where the freedom collapses |
/// | **move**: at least one, per §1 | expand / compress (close, pin, or intersect) |
///
/// > Important: The conclusion is **mandatory**. A theorem without its
/// > conclusion-fixpoint is only its premises, half-stated. Worked example: ``AtomBasis`` pins
/// > `where CompositionalNorm == Distance`, the equation that *is* "an atom is
/// > where the two norms coincide."
///
/// How a freedom is related to its collapse names the marker:
///
/// | Marker | The freedom… |
/// | --- | --- |
/// | ``Unique`` / ``Null`` | is *at* the fixpoint (`Left == Right`) |
/// | ``Monotone`` | shrinks *to* it (toward ``Null``) |
/// | ``Permanent`` | grows *from* it (accumulating) |
/// | ``Measurable`` | resolves to one point (a determined value) |
/// | ``Decidable`` | forks: two fixpoints (in \| out) |
/// | ``IntegerValued`` | a ladder of fixpoints (Peano, floored at ``Null``) |
/// | ``MetricProperty`` | two legs joined at their shared endpoint |
///
/// These slots record the stated relation when every quantity is pinned by its
/// marker, the premises are parents, the conclusion-fixpoint is present, and the
/// protocol makes at least one move. The compiler checks a presented conformance
/// against that relation. Recording the conclusion here does not derive it from
/// the premises. That requires the construction below.
///
/// **The derivation witness.** To establish *premises ⟹ conclusion*, also give a
/// generic type constructor whose parameters require only the premises and whose
/// conformance satisfies the conclusion. Its body must supply the related axes.
/// The conclusion must not be added again as a caller's premise. For example,
/// `ReversedVerdict<C: VerdictIsInvariant>` exchanges C's readings and conforms
/// to ``VerdictIsInvariant`` without asking for a second certificate. The
/// compiler checks that generic body for every C allowed by its constraints.
/// `EqualityContactCut<X>` similarly requires the two resident contacts and
/// one crossed contact. Its complementary contact follows from those three
/// actual equalities, and its second application recovers the source fields.
/// The corresponding vacancy contact rejects the complementary contact.
/// Replacing it with a shared-equality tag would change the theorem's domain.
/// Matter M70 uses ReadyLawState and RecordedLawState for a closed exchange
/// around a supplied local successor. Its generic inverse recovers preparation
/// from the recorded fields. That return also undoes the local result. It does
/// not establish repeated use of the local law. An unrestricted internal record
/// admits every finite local law over a prepared finite horizon. Constraints on
/// the actual carrier and its reuse are needed to exclude such completions.
/// IiS20-IiS21 instead fix relations between preparations. Every proper
/// subfamily can have a realization while their shared cycle has none,
/// even with arbitrary output memory. ResidentTransportContact binds each
/// actual transport to two fields of one source. JointEvidence preserves
/// that source across contacts. Separately fitting witnesses do not supply
/// the common assignment. The preparation geometry carries the phase rule.
///
/// **The refusal witness.** Present a nearby incompatible conformance and require the
/// compiler to refuse the named broken relation. Together with an accepted
/// witness this distinguishes a checked boundary from an unconnected label.
/// `bash Checks/verdict.sh` checks this distinction for the verdict fragment.
/// A declared reading's meaning, coverage of a candidate class, and termination
/// beyond the constructor grammar remain separate obligations of the encoding.
/// VC23 distinguishes a finite set of conflicting ground contacts from a
/// finite generic proof about a whole family. Its finite-carrier argument
/// gives finite conflict support for locally specified assignments, without
/// a uniform size bound or a solver for arbitrary Swift conformances.
/// Naming a composed theorem shortens a proof without removing its premises.
/// ZeroInputClaimTail admits mutually supporting claims on an all-zero input.
/// The actual input reading cannot supply a positive WitnessedOccurrence.
/// Conversely, AnswerWithItsEvidence derives a recovered answer beside its
/// actual evidence through that same observation. VC9 applies this to the
/// source-image graph when the answer identifies the source. Including the
/// reading in a question does not itself require another acquisition.
/// VC23 excludes exact unbounded existence readings in any countable network
/// of finite-valued local constraints, including additional hidden fields.
/// A finite generated witness supplies a different admission requirement.
///
/// **Admission from the source.** When the required output can be derived
/// directly from the actual input fields, compare a proposed result with that
/// construction. A supplied proof's endpoint labels need not be trusted.
/// `FirstDiscoveryDecision` derives a binary table from three actual source
/// rows and refuses the forged completion accepted by an endpoint-only gate.
/// A correct bare table passes without a traversal certificate. This removes
/// a proof-input obligation for that finite shape, not for every open protocol.
/// Compiler failure to build a rewrite system is also distinct from a checked
/// contradiction. The general equality problem is undecidable, as detailed
/// in [Swift Generics, §16.4](https://download.swift.org/docs/assets/generics.pdf).
///
/// ## §T′ · Translation: everyday constructs → types
///
/// §T translates theorems. This table translates the constructs an ordinary
/// programmer reaches for. Each row is exhibited in this package, not proposed. The test
/// before writing any runtime: does the construct *decide* something? Then its
/// home is types. Does it only *carry* bytes across the world's edge? Then its
/// home is a named door.
///
/// | Ordinary construct | Becomes | Exhibited by |
/// | --- | --- | --- |
/// | `class` / instance | an empty `enum`: the type is the value | every atom |
/// | a stored field | an `associatedtype`, pinned by conformance | `Person`'s axes |
/// | `if` on data | a conditional conformance: the branch is a `where` | `Login`, `SecretPage` |
/// | `switch` over cases | one marker protocol per case (SurfaceLaw §S25) | the scope tokens |
/// | an `\|\|` of rules | two overloads: resolution is the disjunction (§S27) | `buildExpression` pairs |
/// | a runtime validation | a constraint at a builder door | the grammar's schema |
/// | a mutable flag | a recorded fact carried as a name | `Midline`, `Declares` |
/// | a lookup table / array | a census body the reader walks | `Alphabet.lexemes` |
/// | a loop that builds | a result-builder fold | `StructureBuilder` |
/// | a string identity | `typeName`, read off the type | every rendered page |
/// | a pure function's call | a generic type applied to its argument | `Succ<N>`, `PageSlug<X>` |
///
/// What never translates: contact with the world. The medium is the type
/// system (§0′), so a compiler run, bytes and a physical act lie outside its
/// carrier, and each needs one named door. The first is the given judge: §0′
/// assigns every reading to the type checker, so the medium presupposes it.
/// Inspecting that checker from inside is relative to a stated transition
/// and reference (Play Is Proof PP21). A judge moved outside the medium meets
/// the same bound on its own codes: no total evaluator represents the
/// complement of its own diagonal (PP15). The second is a program that
/// carries an external byte grammar into atoms and classifies nothing, a
/// transcriber. The third is the physical act. Each door must record its
/// relation, carrier and grounds. A reader that decides which bytes matter
/// carries domain logic. Its relation must then be declared as types. A
/// court, a checker with a declared calculus, must check the derivation the
/// reader emits over every input byte. Any other code outside the medium
/// needs a proof, in the form of Verdict VC23a, that the type grammar cannot
/// express its relation. Code without that proof needs a recorded task that
/// removes it. Such code is debt.
/// The census counts each declaration kind per target, with runtime functions
/// in their own column.
///
/// ## §7 · The tree obeys the law
///
/// The lattice's page branches by the same move the lattice
/// makes. §6 forces it: the law is written in ``Pair`` and ``Null``, so the *tree of
/// the law* is too. Every node (a Topics group, a page, a route) earns its
/// place by the move it makes, never by a hand-picked theme (that is the §1
/// rename, read one level up).
///
/// | A node that… | is a… | and its place is… |
/// | --- | --- | --- |
/// | opens an axis (`associatedtype`), axis-only lineage | generator | on the **spine**, the landing |
/// | pins one axis (`where` on one) | theorem | under that axis |
/// | intersects two or more axes | bridge | in the **web**, listed by its paper |
/// | makes no move | rename | nowhere, the linter rejects it |
///
/// The generators are the only clean partition: a thin **spine** of axes
/// (*Basis Is Residue*, turned on the framework). The bridges are a **web**, most
/// of the lattice, and they are a *cone*: the deeper a theorem is, the more
/// axes it intersects, until the capstones intersect nearly all of them at once. A web is
/// *ordered*, not branched: premise before conclusion, by distance from the seed.
/// It is *carried*: each paper lists the bridges it proves, because a walk
/// through the lattice is itself a certified object (*Order Is Object*). Territory
/// on the landing. Routes in the papers.
///
/// > Note: This organization is *induced*, not arranged. The checker reads the spine and the routes
/// > off the types, each symbol at the place its move earns, and holds the page
/// > equal to that reading, as the linter holds every protocol to §1. The
/// > tree is ``Pair`` and ``Null`` all the way up, as a protocol is all the way down.
public enum Law {}
