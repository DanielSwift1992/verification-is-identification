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

/// Distinction is recursive: a structure's components are themselves
/// structures. Operations are closed under Σ.
/// Compresses both sides of ``Pair``: `Left` and `Right` must each be `Pair`.
/// [EiF C5]
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

/// The cache only grows: G_n ⊆ G_{n+1}, and cached comparisons are kept at every step.
/// It carries permanence (``CachePermanent``) across the terminating steps
/// (``StepsTerminate``), so the cache accumulates step by step. [V=I §5.6]
public protocol CacheOnlyGrows: CachePermanent, StepsTerminate {}

/// Names the intended accumulation of diagnostics across deterministic runs.
/// These parents alone do not encode a separate diagnostic store's update.
/// Repeated REJECTs need not add new facts. [V=I §5.7, GC2]
public protocol DiagnosticsAccumulate: CachePermanent, ResultDeterministic {}

/// The solution set only shrinks: each COMPARE can drop a candidate, and once dropped
/// it is out for good (|S_{n+1}| ≤ |S_n|).
/// It compresses the solution axis (``HasSolutions``) to a ``Monotone`` `SolutionSet`,
/// built on the permanent cache (``CachePermanent``) that makes a drop final. This
/// protocol owns the claim, and IiI A1 reuses it. [V=I §5.22]
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

/// The pipeline sees only the encoded representation: its scope stops at the encoding.
/// It joins closed operations (``OperationsClosed``) to a deterministic result
/// (``ResultDeterministic``), so the result is a function of the encoding alone. [V=I §5.24]
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

/// The preconditions guarantee a PASS: a finite space, a decidable test, and a single
/// survivor together force certification to succeed.
/// Its three parents are those three preconditions: finite space (``StructuresFinite``),
/// decidable test (``EqualityDecidable``), one survivor (``ExactlyOneSurvives``). [V=I Thm 5]
public protocol PreconditionsGuaranteePass: StructuresFinite, EqualityDecidable, ExactlyOneSurvives {}


// ── §5 Axis Alignment ────────────────────────────────────

/// For a fixed candidate set, adding constraints cannot add survivors.
/// This compatibility uses the definitions of the cache and candidate set.
/// It does not give an order on arbitrary physical or diagnostic quantities.
/// The participating structural premises are recorded by these parents.
/// Their inheritance alone does not derive every claimed information axis.
/// Retraction of redundant facts need not enlarge the survivor set.
/// [V=I §5.25, axis-alignment remark]
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

/// COMPARE reveals a pre-existing fact: its result is fixed by the inputs' structure
/// before the call, never created. The output settles to one determined value, and the
/// medium already contains it.
/// It joins closed operations (``OperationsClosed``) to a measured value (``Measurable``):
/// the call reads what the medium already fixes (EiF Part III). [V=I §5.20]
public protocol RevealsNotCreates: OperationsClosed, Measurable {}

/// Historical interface for a verification scope varying only enumeration.
/// With candidates, predicate and complete retention fixed, every ordering
/// gives the same survivor set. A fixed encoding alone supplies none of
/// those conditions. These inherited axes do not encode an enumeration or
/// prove its coverage. An invariant selected answer needs agreement over
/// the survivors, as VerdictIsInvariant expresses. [V=I §5.25, Read R3–R4]
public protocol OrderIsOnlyFreedom: AxesCoOriented, IdentityCollapse {}
