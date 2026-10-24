import Notation

// ═══════════════════════════════════════════════════════════════
// Interference Is Intelligence (Mechanism).
//
// V=I gives the comparison loop. This paper studies finite query policies.
// A policy uses its history and actual readings, not the unknown target index.
// Immediate information gain, an instance certificate and the optimum
// of a complete adaptive policy are different quantities.
// A uniquely most balanced first query can worsen both mean and worst cost.
// Correct optimization accounts for each possible continuation (S3).
//
// Pure types (§0′). These intersections expose shared coordinates.
// They do not encode probability independence, policy optimality, quantum
// interference or unrestricted interchangeability. Those claims need
// their own models and witnesses. [InI S1–S12]
// ═══════════════════════════════════════════════════════════════

/// Three declared roles: verdict, structural operations and query order.
/// - term Z: a ``Decidable`` verdict, with at most one bit for binary output.
/// - term X: structural feedback (``OperationsClosed``), with its own alphabet.
/// - term Y: query choice (``OrderIsOnlyFreedom``) from available history.
/// A deterministic choice adds no information conditional on that history.
/// The roles need not be statistically independent. [InI S1]
public protocol ThreeAxesOfCompare: Decidable, OperationsClosed, OrderIsOnlyFreedom {}

/// An efficiency axis beside a declared query-order axis.
/// ``IntelligenceRises`` supplies no inequality between policy costs.
/// ``OrderIsOnlyFreedom`` supplies no optimal adaptive decision tree.
/// Correct continuation costs need the finite policy model of S3.
/// Greedy gains and instance certificates do not supply it. [InI S3–S6]
public protocol InterferenceIsIntelligence: IntelligenceRises, OrderIsOnlyFreedom {}

/// PASS-to-identification beside a declared query-order axis.
/// Output agreement, represented equality and interchangeability under later
/// operations have different scopes. ``PassIsIdentification`` with
/// ``OrderIsOnlyFreedom`` does not prove equality under every context.
/// Context and encoding bridges need separate witnesses. [InI S10, VC35–VC38]
public protocol IsIsYIdentity: PassIsIdentification, OrderIsOnlyFreedom {}

// ───────────────────────────────────────────────────────────────
// S3 uses optimal continuation costs. S3a gives a unique greedy-root failure.
//
// S5b separates one certificate for each target from one policy for all targets.
// S6a separates counting information, fresh records and retained observations.
// S6b gives a relative certificate bound. S6c requires eventual separation.
// S11 proves optional capability under refinement with unchanged future costs.
// S12 shows a useful query can reveal zero immediate target information.
// The finite audit independently enumerates attainable depth vectors and
// replays policies. S7–S9 remain research boundaries rather than quantum or
// universal computational guarantees. See Research/query-strategy-2026-09-05.md.
// ───────────────────────────────────────────────────────────────
