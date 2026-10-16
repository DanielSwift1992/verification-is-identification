// ═══════════════════════════════════════════════════════
// V=I Proof Chain — §5.15 Structural Recurrence.
//
// Each interface records axes and constraints. Protocol inheritance carries
// those constraints; it does not derive every intended claim in a name.
// Generic constructions and their exact conclusions are checked separately.
//
// 22 claims from §0–§5. Dependency DAG encoded as inheritance.
//
// ROOT: Pair (distinction). Every claim is a property of
// distinction. Nothing floats free. §2.5 Unity: "PAIR is
// the sole structural primitive: the act of distinction."
//
// RULES for protocol creation:
//   1. Introduce an axis (associatedtype) → new degree of freedom
//   2. Constrain an axis (where clause) → compression
//   3. Depend on another protocol (inheritance) → logical dependency
//   A valid protocol does at least (1) or (2), not just (3).
// ═══════════════════════════════════════════════════════


// ── §0 Foundations ───────────────────────────────────────

/// Names the intended finite-structure interpretation through ``HasSigma``.
/// Σ itself is infinite (EiF EF5). This open conformance does not prove that
/// a chain terminates or that a candidate domain has a uniform bound. [EiF EF6]
public protocol StructuresFinite: Pair, HasSigma {}

/// Requires ``Pair`` on both addressed components, `Left` and `Right`.
/// The full finite-tree grammar is closed under its total pairing constructor.
/// Its constructor, admission and finite generation are further premises.
/// These component constraints alone do not establish them.
/// Under its operand-recovery, origin and finite-generation conditions,
/// EiF EF8 also gives unique decomposition for partial construction.
/// [EiF C5, Definition 1, EF8]
public protocol OperationsClosed: Pair
where Left: Pair, Right: Pair {}

// Never supplies the declared terminal interpretation. Its associated types
// point back to Never, so a traversal must recognize the terminal explicitly.
// OperationsClosed alone supplies neither a stopping rule nor a decreasing rank.
extension Never: OperationsClosed {}

/// Names the equality outcome through `Equality: Decidable`.
/// Terminating structural comparison is proved for the finite-tree interpretation.
/// This outcome axis alone supplies neither a comparison algorithm nor a proof
/// that every ``StructuresFinite`` conformer has finite depth. [EiF Thm 3, EF4]
public protocol EqualityDecidable: StructuresFinite {
    associatedtype Equality: Decidable
}


// ── §2 Constructed Invariant ─────────────────────────────

/// Requires a retaining Cache transition through the ``Permanent`` relation.
/// Fixed comparison truth alone does not provide this transition. An explicit
/// append can construct it, while decoded retention and sound inserted facts
/// require the separate compatibility conditions of V=I §2.4 GC1–GC3.
public protocol CachePermanent: StructuresFinite, OperationsClosed,
    HasCache
    where Cache: Permanent {}


// ── §5 Inner Properties ─────────────────────────────────

/// Names a step-count representation through `Steps: IntegerValued`.
/// This axis does not require an execution to decrease its count. Termination
/// needs the pipeline's explicit descent argument. [V=I §5.1, EiF EF7]
public protocol StepsTerminate: StructuresFinite {
    associatedtype Steps: IntegerValued
}

/// Names the intended total pipeline and its `Outcome: Measurable` axis.
/// The execution and its control-flow proof are stated in the paper. These
/// associated types alone do not certify an arbitrary implementation. [V=I §5.5]
public protocol PipelineTotal: StepsTerminate {
    associatedtype Outcome: Measurable
}

/// Names an intended deterministic result through `Result: Measurable`.
/// One result type does not bind every application of an evaluator to one answer.
/// Functional consistency requires an application construction or a separate proof.
/// Liquid LQ16 derives it from exact self-contact and contextual substitution.
/// Those laws are not encoded by the Result axis below.
/// ``OperationsClosed`` constrains components, not execution behavior. [V=I §5.8]
public protocol ResultDeterministic: OperationsClosed {
    associatedtype Result: Measurable
}


// ── §5 Monotonicity ─────────────────────────────────────

/// With fixed comparison keys and answers, sound retaining updates give
/// one run an inclusion chain of decoded caches. A repeated insertion can
/// leave the cache unchanged.
///
/// ``CachePermanent`` requires `Cache: Permanent`, while ``StepsTerminate``
/// names `Steps: IntegerValued`. Their use across a run needs the actual
/// transitions and a compatible interpretation of cache contents.
/// Raw recovery alone gives no decoded inclusion. [V=I §5.6, §2.4 GC2–GC3]
public protocol CacheOnlyGrows: CachePermanent, StepsTerminate {}


/// A fixed game's working candidates shrink or remain unchanged as sound facts accumulate.
///
/// These facts follow from the same examples. The exact solution set is fixed.
/// This interface constrains ``HasSolutions``' `SolutionSet` to ``Monotone``
/// beside ``CachePermanent``. Its candidate interpretation must supply membership
/// and admission by every retained sound fact. ``SystemCrystallizes`` reuses
/// this interface for IiI A1. [V=I §5.22] [IiI §5 A1]
public protocol CandidatesOnlyLeave: CachePermanent,
    HasSolutions
    where SolutionSet: Monotone {}


// ── §5 Structural ────────────────────────────────────────

/// A legacy name for closed-operation coordinates and an IntegerValued input.
/// The recursive input axis proves neither finite depth nor absence of
/// self-reference (EiF EF10). A finite description can refer to its own
/// interpreter without containing an infinite literal copy of itself.
/// V=I §5.23 instead states an actual input-access condition. This protocol
/// does not bind Input to the pipeline's complete configuration or prove
/// which parts of that configuration are accessible.
public protocol NoSelfReference: OperationsClosed {
    associatedtype Input: IntegerValued
}

/// In the paper's pure pipeline, equal encoded games and feature sets give equal outputs.
///
/// Its operations use only this input. This interface joins ``OperationsClosed``
/// and ``ResultDeterministic`` through component and result coordinates.
/// Applying the result to another pipeline requires its output to be a
/// function of the complete encoded input, with the actual input binding.
/// [V=I §5.23–5.24]
public protocol ScopeBoundedByEncoding: OperationsClosed, ResultDeterministic {}


// ── §3 Problem Requirement ───────────────────────────────

/// Requires a Unique solution coordinate beside the domain and equality axes.
/// The projection constraints of Unique do not enumerate survivors or prove
/// their cardinality. U2–U2a derives a common member and identification through
/// actual membership paths. U2b derives a schedule's forced assignment directly.
/// Neither this declaration nor SystemCrystallizes derives R4 from its name.
public protocol ExactlyOneSurvives: StructuresFinite, EqualityDecidable,
    HasSolutions
    where SolutionSet: Unique {}


// ── §5 Theorems ──────────────────────────────────────────

/// For a candidate already admitted to the declared F, agreement with every
/// example gives membership in S. Agreement alone does not admit an arbitrary
/// proposal to F. These named pipeline interfaces supply neither that membership
/// witness nor the application equations. See the covered-selection construction
/// in U2 and the explicit premises of V=I §4.7 and Theorem 1.
public protocol PassImpliesMembership: PipelineTotal, ResultDeterministic {}

/// To check the answer and to name it are the same act. When exactly one candidate
/// can pass the test, the one that passes is the one you were looking for, so passing
/// the check is already knowing which it is. This is the central theorem.
///
/// With `|S| = 1` and both the candidate and target in S, they agree.
/// This declaration joins the named interfaces and identifies Left with
/// SolutionSet. Its constraints alone supply neither membership witnesses
/// nor the singleton interpretation of that coordinate. IdentifyCoveredCandidates
/// supplies the membership-to-identity construction for the finite support
/// grammar. [V=I Thm 2, U1–U2a]
public protocol PassIsIdentification: PassImpliesMembership, ExactlyOneSurvives,
    HasSolutions
    where Left == SolutionSet {}

/// A fixed domain of N atoms has at most N² ordered comparison pairs.
/// Exhaustive coverage needs at most N² fresh comparisons, with retained results.
/// The finite atom domain is separate from the unbounded syntax Σ. [V=I Thm 3]
public protocol ComparisonsAreBounded: StructuresFinite {
    associatedtype Comparisons: IntegerValued
}

/// With a terminating membership test and a supplied finite enumeration,
/// exhaustive checking finds the candidate when exactly one member passes.
///
/// The enumeration must cover the declared candidate family.
/// This interface joins ``StructuresFinite``, ``EqualityDecidable`` and
/// ``ExactlyOneSurvives`` through representation, equality and solution coordinates.
/// Using this completeness result needs the actual enumeration, membership
/// test and singleton witness. [V=I Thm 5]
public protocol PreconditionsGuaranteePass: StructuresFinite, EqualityDecidable, ExactlyOneSurvives {}


// ── §5 Axis Alignment ────────────────────────────────────

/// For a fixed candidate set, adding constraints cannot add survivors.
/// This compatibility uses the definitions of the cache and candidate set.
/// It does not give an order on arbitrary physical or diagnostic quantities.
/// The participating structural premises are recorded by these parents.
/// Their inheritance alone does not derive every claimed information axis.
/// Retraction of redundant facts need not enlarge the survivor set.
/// [V=I §5.25, axis-alignment remark]
///
/// The same intersection names the intended accumulation of diagnostics across
/// deterministic runs. These parents alone do not encode a separate diagnostic
/// store's update. Repeated REJECTs need not add new facts. [V=I §5.7, GC2]
public protocol AxesCoOriented: StructuresFinite, CachePermanent, OperationsClosed, ResultDeterministic {}

/// The elimination score needs a fixed nonempty F and a defined survivor set.
/// These parents alone encode neither that score nor successful identification.
/// Score one means S is empty, not uniquely identified. [V=I §5.25]
public protocol SaturationIncorruptible: StructuresFinite, CachePermanent {}


// ── §5 Universality & Information (§T-generated) ──────────────

/// Legacy name for the finite-presentation and singleton premises.
/// The complete correct graph of a finite function isolates it within a supplied
/// extensional family containing it. This does not acquire the graph from an unknown
/// source or implement its law in a particular feature grammar. These parents alone
/// construct neither that graph nor the required singleton witness. [V=I §5 Thm 4]
public protocol Universality: StructuresFinite, HasEncoding, ExactlyOneSurvives {}

/// The paper's pure COMPARE reports whether its supplied finite trees
/// already agree in structure. The call makes that fixed relation explicit.
///
/// ``OperationsClosed`` constrains component types. ``Measurable`` requires
/// equal sides in the represented output. Applying this interpretation needs
/// an actual law binding the input trees to their comparison verdict.
/// The structural relation and a stored comparison record have distinct roles.
/// [V=I §5.20–5.21, EiF Thm 3, Part III]
public protocol RevealsNotCreates: OperationsClosed, Measurable {}

/// Historical interface for a verification scope varying only enumeration.
/// With candidates, predicate and complete retention fixed, every ordering
/// gives the same survivor set. A fixed encoding alone supplies none of
/// those conditions. These inherited axes do not encode an enumeration or
/// prove its coverage. An invariant selected answer needs agreement over
/// the survivors, as VerdictIsInvariant expresses. [V=I §5.25, Read R3–R4]
public protocol OrderIsOnlyFreedom: AxesCoOriented, IdentityCollapse {}
