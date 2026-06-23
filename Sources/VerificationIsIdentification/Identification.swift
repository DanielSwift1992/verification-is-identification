// ═══════════════════════════════════════════════════════
// V=I Proof Chain — §5.15 Structural Recurrence.
//
// Each claim is a protocol. Dependencies = protocol inheritance.
// Remove any protocol → all dependents fail to compile.
// The Swift compiler IS the proof chain verifier.
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

/// Distinction terminates: every chain of ``Pair`` reaches ``Null``.
/// Introduces the Sigma axis (``HasSigma``) — the finite space of all structures.
/// [EiF C6, Thm 1]
public protocol StructuresFinite: Pair, HasSigma {}

/// Distinction is recursive: a structure's components are themselves
/// structures. Operations stay closed under Σ.
/// Compresses both sides of ``Pair``: `Left` and `Right` must each be `Pair`.
/// [EiF C5]
public protocol OperationsClosed: Pair where Left: Pair, Right: Pair {}

// §4 floor: the component recursion bottoms at Null. Never is the
// reachable base case (Never.Left, Never.Right: Pair via Null) — the
// witness that "components are Pairs" terminates, not descends forever.
extension Never: OperationsClosed {}

/// Structural equality on finite structures is decidable: every comparison returns
/// a verdict, equal or not.
/// The verdict is two-sided (`Equality: Decidable`), and the test always halts
/// because the space is finite (``StructuresFinite``). [EiF Thm 3]
public protocol EqualityDecidable: StructuresFinite {
    associatedtype Equality: Decidable
}


// ── §2 Derived Invariant ─────────────────────────────────

/// The comparison graph is append-only: G' ⊇ G. Cached results stand for good.
/// Introduces the Cache axis (``HasCache``) and compresses it: `Cache` must be
/// ``Permanent``. A pure function on fixed inputs gives fixed results, because the
/// structures are finite (``StructuresFinite``) and the operations closed (``OperationsClosed``). [V=I §2.4 I3]
public protocol CachePermanent: StructuresFinite, OperationsClosed,
    HasCache where Cache: Permanent {}


// ── §5 Inner Properties ─────────────────────────────────

/// Every step works on a finite domain, so every step terminates.
/// The step count is a finite chain (`Steps: IntegerValued`), and that finiteness
/// comes from the finite space it builds on (``StructuresFinite``). [V=I §5.1, EiF C6]
public protocol StepsTerminate: StructuresFinite {
    associatedtype Steps: IntegerValued
}

/// The inner pipeline is total: every path ends at one definite state.
/// That state is a single measured outcome (`Outcome: Measurable`), reached because
/// each step terminates (``StepsTerminate``). [V=I §5.5]
public protocol PipelineTotal: StepsTerminate {
    associatedtype Outcome: Measurable
}

/// The system is deterministic: one input has one answer, the same on every run.
/// An output could spread across many possible values. This one settles each input
/// on a single measured value (`Result: Measurable`).
/// Builds on ``OperationsClosed``: because the operations are fixed, the result is too. [V=I §5.8, EiF C3]
public protocol ResultDeterministic: OperationsClosed {
    associatedtype Result: Measurable
}


// ── §5 Monotonicity ─────────────────────────────────────

/// The cache only grows: G_n ⊆ G_{n+1}, cached comparisons stand for every step.
/// It carries permanence (``CachePermanent``) across the terminating steps
/// (``StepsTerminate``), so the cache accumulates step by step. [V=I §5.6]
public protocol CacheOnlyGrows: CachePermanent, StepsTerminate {}

/// Diagnostics accumulate: collected information only grows.
/// It joins a permanent cache (``CachePermanent``) to a deterministic result
/// (``ResultDeterministic``), so each REJECT adds a fact that later steps keep. [V=I §5.7]
public protocol DiagnosticsAccumulate: CachePermanent, ResultDeterministic {}

/// The solution set only shrinks: each COMPARE can drop a candidate, and once dropped
/// it stays out (|S_{n+1}| ≤ |S_n|).
/// It compresses the solution axis (``HasSolutions``) to a ``Monotone`` `SolutionSet`,
/// built on the permanent cache (``CachePermanent``) that makes a drop final. This
/// protocol owns the claim, and IiI A1 reuses it. [V=I §5.22]
public protocol CandidatesOnlyLeave: CachePermanent,
    HasSolutions where SolutionSet: Monotone {}


// ── §5 Structural ────────────────────────────────────────

/// The pipeline stays out of its own input: operations never take the pipeline
/// as argument. [V=I §5.23]
/// PROXY (§1, §4-through-negation): types can't state "X ∉ its own input".
/// Finite-depth `Input` (``IntegerValued``) excludes the infinite self-nesting that
/// self-reference would create — the closest sound expression of the bound. The
/// medium is well-founded (EiF C6): nothing contains itself.
/// Built on closed operations (``OperationsClosed``), which take only the encoded data.
public protocol NoSelfReference: OperationsClosed {
    associatedtype Input: IntegerValued
}

/// The pipeline sees only the encoded representation: its scope stops at the encoding.
/// It joins closed operations (``OperationsClosed``) to a deterministic result
/// (``ResultDeterministic``), so the result depends on the encoding alone. [V=I §5.24]
public protocol ScopeBoundedByEncoding: OperationsClosed, ResultDeterministic {}


// ── §3 Problem Requirement ───────────────────────────────

/// Exactly one candidate passes verification: |S| = 1. [V=I §3.5 R4]
/// Conclusion pinned (§T): the requirement *is* a fixpoint on the solution axis
/// (``HasSolutions``) — `where SolutionSet:` ``Unique``. R4 ASSUMES the collapse (a
/// decidable property of the encoding, §3.5–3.6). A4 (``SystemCrystallizes``) PROVES
/// it from A1–A3 — the requirement and the theorem meet at the SAME fixpoint,
/// `SolutionSet: Unique`, the framework's canonical encoding of |S|=1 (the gate
/// coordinate, Domains). Inherits ``StructuresFinite`` and ``EqualityDecidable``.
public protocol ExactlyOneSurvives: StructuresFinite, EqualityDecidable,
    HasSolutions where SolutionSet: Unique {}


// ── §5 Theorems ──────────────────────────────────────────

/// A passing candidate is a member of the solution set: PASS → f' ∈ S.
/// It joins a total pipeline (``PipelineTotal``) to a deterministic result
/// (``ResultDeterministic``), so every PASS is a definite membership fact. [V=I Thm 1]
public protocol PassImpliesMembership: PipelineTotal, ResultDeterministic {}

/// To check the answer and to name it are the same act. When exactly one candidate
/// can pass the test, the one that passes is the one you were looking for, so passing
/// the check is already knowing which it is. This is the central theorem.
///
/// Formally, with `|S| = 1` a PASS pins the candidate to the unique survivor, `f' = f*`.
/// Conclusion pinned (§T): `where Left == SolutionSet` *is* that collapse, the same one
/// ``Null`` makes when `Left == Right`. It joins membership (``PassImpliesMembership``)
/// to uniqueness (``ExactlyOneSurvives``) on the solution axis (``HasSolutions``). [V=I Thm 2]
public protocol PassIsIdentification: PassImpliesMembership, ExactlyOneSurvives,
    HasSolutions where Left == SolutionSet {}

/// Comparison is bounded: N atoms settle in at most N² COMPAREs, classifying every pair.
/// The comparison count is a finite integer (`Comparisons: IntegerValued`), bounded
/// because the medium is finite (``StructuresFinite``, EiF C6). [V=I Thm 3]
public protocol ComparisonsAreBounded: StructuresFinite {
    associatedtype Comparisons: IntegerValued
}

/// The preconditions guarantee a PASS: a finite space, a decidable test, and a single
/// survivor together force certification to succeed.
/// Its three parents are those three preconditions: finite space (``StructuresFinite``),
/// decidable test (``EqualityDecidable``), one survivor (``ExactlyOneSurvives``). [V=I Thm 5]
public protocol PreconditionsGuaranteePass: StructuresFinite, EqualityDecidable, ExactlyOneSurvives {}


// ── §5 Axis Alignment ────────────────────────────────────

/// The axes are co-oriented: every monotone property points the same way
/// (info↑, rejections↑, |S|↓). [V=I §5 AX1]
/// AX3 lives in this line: AxesCoOriented depends on CachePermanent (I3) — that
/// edge *is* "permanence generates alignment". Delete CachePermanent here and the
/// alignment cannot be formed: "remove I3 → axes decouple", executable. So AX3
/// is the dependency itself, not a separate protocol (Law §1: no rename). [V=I §5 AX3]
/// It meets the four monotone axes: ``StructuresFinite``, ``CachePermanent``, ``OperationsClosed``, and ``ResultDeterministic``.
public protocol AxesCoOriented: StructuresFinite, CachePermanent, OperationsClosed, ResultDeterministic {}

/// Saturation is an incorruptible progress metric: 1−|S|/|F| only rises.
/// It joins the finite space (``StructuresFinite``) to the permanent cache
/// (``CachePermanent``), so each gain in saturation is permanent. [V=I §5 AX2]
public protocol SaturationIncorruptible: StructuresFinite, CachePermanent {}


// ── §5 Universality & Information (§T-generated) ──────────────

/// Universality: any finite deterministic task has an encoding under which exactly one
/// candidate passes, so |S|=1 is always achievable.
/// It opens the encoding axis (``HasEncoding``) over a finite space (``StructuresFinite``)
/// and meets ``ExactlyOneSurvives``: pick the encoding, and the single survivor exists. [V=I §5 Thm 4]
public protocol Universality: StructuresFinite, HasEncoding, ExactlyOneSurvives {}

/// COMPARE reveals a pre-existing fact: its result is fixed by the inputs' structure
/// before the call, never created. The output settles to one determined value, and the
/// medium already holds it.
/// It joins closed operations (``OperationsClosed``) to a measured value (``Measurable``):
/// the call reads what the medium already fixes (EiF Part III). [V=I §5.20]
public protocol RevealsNotCreates: OperationsClosed, Measurable {}

/// Order is the sole freedom (A12): once the encoding is fixed, the only free variable
/// is the order of COMPAREs, and correctness holds whatever the order.
/// Everything else is pinned (``AxesCoOriented``), and the identification fixpoint
/// (``IdentityCollapse``) holds atop that, so order is the residue left after every
/// other collapse. [V=I §5.25]
///
/// > Tip: When every axis is co-oriented and the answer is pinned, the one thing
/// > left to choose is the sequence of comparisons, and that choice changes only the
/// > path. Freedom survives only where it cannot alter the result.
public protocol OrderIsOnlyFreedom: AxesCoOriented, IdentityCollapse {}
