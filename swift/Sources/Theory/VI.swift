// ═══════════════════════════════════════════════════════
// V=I Proof Chain — §5.15 Structural Recurrence.
//
// Each claim is a protocol. Dependencies = protocol inheritance.
// Remove any protocol → all dependents fail to compile.
// The Swift compiler IS the proof chain verifier.
//
// 20 claims from §0–§5. Dependency DAG encoded as inheritance.
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

/// Structural equality on finite structures is decidable: every comparison
/// returns a verdict.
/// Names the Equality axis (``Decidable``) — the test yields a two-sided verdict.
/// Inherits ``StructuresFinite``. [EiF Thm 3]
public protocol EqualityDecidable: StructuresFinite {
    associatedtype Equality: Decidable
}


// ── §2 Derived Invariant ─────────────────────────────────

/// The comparison graph is append-only: G' ⊇ G. Cached results stand for good.
/// Introduces the Cache axis (``HasCache``) and compresses it: `Cache` must be
/// ``Permanent``. A pure function on fixed inputs gives fixed results.
/// Inherits ``StructuresFinite`` and ``OperationsClosed``. [V=I §2.4 I3]
public protocol CachePermanent: StructuresFinite, OperationsClosed,
    HasCache where Cache: Permanent {}


// ── §5 Inner Properties ─────────────────────────────────

/// Every step operates on a finite domain (EiF C6), so every step terminates. [V=I §5.1]
/// Names the Steps axis (``IntegerValued``) — the step count is a finite chain.
/// Inherits ``StructuresFinite``.
public protocol StepsTerminate: StructuresFinite {
    associatedtype Steps: IntegerValued
}

/// The inner pipeline is total: every path terminates at a definite state. [V=I §5.5]
/// Names the Outcome axis (``Measurable``) — every path settles to one definite state.
/// Inherits ``StepsTerminate``.
public protocol PipelineTotal: StepsTerminate {
    associatedtype Outcome: Measurable
}

/// Same task + grammar + protocol yields the same result. [V=I §5.8]
/// Names the Result axis (``Measurable``) — input determines output, one value (EiF C3).
/// Inherits ``OperationsClosed``.
public protocol ResultDeterministic: OperationsClosed {
    associatedtype Result: Measurable
}


// ── §5 Monotonicity ─────────────────────────────────────

/// The cache only grows: G_n ⊆ G_{n+1}, cached comparisons stand for every step. [V=I §5.6]
/// Intersects ``CachePermanent`` with ``StepsTerminate`` — permanence indexed over
/// the terminating steps.
public protocol CacheOnlyGrows: CachePermanent, StepsTerminate {}

/// Diagnostics accumulate: collected information only grows. [V=I §5.7]
/// Intersects ``CachePermanent`` with ``ResultDeterministic``.
public protocol DiagnosticsAccumulate: CachePermanent, ResultDeterministic {}

/// Candidates only leave the solution set, never enter: |S_{n+1}| ≤ |S_n|. [V=I §5.22]
/// Compresses the solution axis (``HasSolutions``): `SolutionSet` is ``Monotone``, so
/// the set only shrinks. Inherits ``CachePermanent``. Owns this claim; IiI A1 reuses it.
public protocol CandidatesOnlyLeave: CachePermanent,
    HasSolutions where SolutionSet: Monotone {}


// ── §5 Structural ────────────────────────────────────────

/// The pipeline stays out of its own input: operations never take the pipeline
/// as argument. [V=I §5.23]
/// PROXY (§1, §4-through-negation): types can't state "X ∉ its own input".
/// Finite-depth `Input` (``IntegerValued``) excludes the infinite self-nesting that
/// self-reference would create — the closest sound expression of the bound. The
/// medium is well-founded (EiF C6): nothing contains itself.
/// Inherits ``OperationsClosed``.
public protocol NoSelfReference: OperationsClosed {
    associatedtype Input: IntegerValued
}

/// The pipeline sees only the encoded representation; scope stops at the encoding. [V=I §5.24]
/// Intersects ``OperationsClosed`` with ``ResultDeterministic``.
public protocol ScopeBoundedByEncoding: OperationsClosed, ResultDeterministic {}


// ── §3 Problem Requirement ───────────────────────────────

/// Exactly one candidate passes verification: |S| = 1. [V=I §3.5 R4]
/// Conclusion pinned (§T): the requirement *is* a fixpoint on the solution axis
/// (``HasSolutions``) — `where SolutionSet:` ``Unique``. R4 ASSUMES the collapse (a
/// decidable property of the encoding, §3.5–3.6); A4 (``SystemCrystallizes``) PROVES
/// it from A1–A3 — the requirement and the theorem meet at the SAME fixpoint,
/// `SolutionSet: Unique`, the framework's canonical encoding of |S|=1 (the gate
/// coordinate, Domains). Inherits ``StructuresFinite`` and ``EqualityDecidable``.
public protocol ExactlyOneSurvives: StructuresFinite, EqualityDecidable,
    HasSolutions where SolutionSet: Unique {}


// ── §5 Theorems ──────────────────────────────────────────

/// A passing candidate is a member: PASS → f' ∈ S. [V=I Thm 1]
/// Intersects ``PipelineTotal`` with ``ResultDeterministic``.
public protocol PassImpliesMembership: PipelineTotal, ResultDeterministic {}

/// Verification *is* identification: when |S|=1, a PASS pins the candidate to the
/// unique survivor, f' = f*. The central theorem. [V=I Thm 2]
/// Conclusion pinned (§T): the candidate (`Left`) collapses onto the unique
/// survivor, `where Left == SolutionSet` *is* f' = f*. Combines membership
/// (``PassImpliesMembership``) with uniqueness (``ExactlyOneSurvives``) over the
/// solution axis (``HasSolutions``).
///
/// > Note: To verify the answer and to name it are one act. Once the encoding
/// > admits a single survivor, passing the check *is* knowing which one it is —
/// > the same collapse ``Null`` makes when `Left == Right`.
public protocol PassIsIdentification: PassImpliesMembership, ExactlyOneSurvives,
    HasSolutions where Left == SolutionSet {}

/// Comparison is bounded: N atoms need at most N² COMPAREs to classify all pairs. [V=I Thm 3]
/// Names the Comparisons axis (``IntegerValued``) — the comparison count is a finite
/// integer (finite medium, EiF C6). Inherits ``StructuresFinite``.
public protocol ComparisonsAreBounded: StructuresFinite {
    associatedtype Comparisons: IntegerValued
}

/// The preconditions guarantee a PASS: F finite ∧ S decidable ∧ |S|=1 → certification
/// yields PASS. [V=I Thm 5]
/// Intersects ``StructuresFinite``, ``EqualityDecidable``, and ``ExactlyOneSurvives``.
public protocol PreconditionsGuaranteePass: StructuresFinite, EqualityDecidable, ExactlyOneSurvives {}


// ── §5 Axis Alignment ────────────────────────────────────

/// The axes are co-oriented: every monotone property points the same way
/// (info↑, rejections↑, |S|↓). [V=I §5 AX1]
/// AX3 lives in this line: AxesCoOriented depends on CachePermanent (I3) — that
/// edge *is* "permanence generates alignment". Delete CachePermanent here and the
/// alignment cannot be formed: "remove I3 → axes decouple", executable. So AX3
/// is the dependency itself, not a separate protocol (Law §1: no rename). [V=I §5 AX3]
/// Intersects ``StructuresFinite``, ``CachePermanent``, ``OperationsClosed``, and ``ResultDeterministic``.
public protocol AxesCoOriented: StructuresFinite, CachePermanent, OperationsClosed, ResultDeterministic {}

/// Saturation is an incorruptible progress metric: 1−|S|/|F| only rises. [V=I §5 AX2]
/// Intersects ``StructuresFinite`` with ``CachePermanent``.
public protocol SaturationIncorruptible: StructuresFinite, CachePermanent {}


// ── §5 Universality & Information (§T-generated) ──────────────

/// Universality (Thm 4): any finite deterministic task has an encoding under which
/// exactly one candidate passes. |S|=1 is achievable. [V=I §5 Thm 4]
/// Slots: quantities {Σ→finite, Encoding, S→Unique} · premises {finite, encoded}
/// · conclusion {``ExactlyOneSurvives``} · move {intersect}. Introduces the encoding
/// axis (``HasEncoding``); inherits ``StructuresFinite``.
public protocol Universality: StructuresFinite, HasEncoding, ExactlyOneSurvives {}

/// COMPARE reveals a pre-existing fact: its result is fixed by the inputs'
/// structure before the call, never created. The output settles to one
/// determined value — the medium holds it, the call only reads (EiF Part III). [V=I §5.20]
/// Intersects ``OperationsClosed`` with ``Measurable``.
public protocol RevealsNotCreates: OperationsClosed, Measurable {}

/// Order is the sole freedom (A12): once the encoding is fixed, the only free
/// variable is the order of COMPAREs, and correctness is order-invariant.
/// Everything else is pinned (``AxesCoOriented``); the identification fixpoint
/// (``VI_Identity``) holds atop it, so order cannot move it — order is the
/// residue left after every other collapse. [V=I §5.25]
///
/// > Tip: When every axis is co-oriented and the answer is pinned, the one thing
/// > left to choose is the sequence of comparisons — and that choice changes
/// > nothing but the path. Freedom survives only where it cannot alter the result.
public protocol OrderIsOnlyFreedom: AxesCoOriented, VI_Identity {}
