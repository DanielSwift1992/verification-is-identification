// ═══════════════════════════════════════════════════════════════
// Permanence Is Resistance (Matter).
//
// What the crystallized output IS. Three properties define matter:
//   permanent   (I3,   append-only library)
//   irreducible (Thm2, each entry is the unique f*)
//   resistant   (I2,   fixed target; COMPARE returns not_equal)
// "One structural fact from three angles", so Matter is their intersect.
//
// Plus: the tower (each crystal is the next level's matter), discrete
// time, ignition, no-inverse (M21), convergence (M12), finite discovery.
// Pure types (§0′). Every claim ties to the existing lattice.
// ═══════════════════════════════════════════════════════════════

// ── New axes this paper introduces ──

/// Time is discrete: the clock is a sequence of COMPAREs indexed by ℕ. A finite
/// count within a finite game over ``HasSigma``, inline, like Distance (``Law``
/// §2). [Matter M1]
public protocol HasTime: HasSigma {
    associatedtype Time: IntegerValued
}

/// Cost is thermodynamic: irreversible bits, each `≥ kT·ln2` (Landauer). A finite
/// discrete count over ``HasSigma``, inline (``Law`` §2). [Matter M24]
public protocol HasCost: HasSigma {
    associatedtype Cost: IntegerValued
}

// ── §1 Resistance ──

/// Resistance is a *relation*, not a property of the target: it needs both the
/// invariant and the form that fails to match it. Realized at COMPARE
/// (``Decidable``) as the `not_equal` verdict, measured as distance
/// (``HasDistance``) from the invariant. [Matter §1]
public protocol Resistant: HasDistance, Decidable {}

// ── §2 Matter ──

/// Matter is what a settled system leaves behind: a result that can no longer change.
/// Three faces of one fact: it is permanent (it only accumulates), irreducible (it is
/// the unique survivor, so nothing simpler is correct), and resistant (the next system
/// meets it as something fixed). A conforming type certifies all three at once.
///
/// The three are pinned by ``KnowledgeAccumulates`` (permanent, I3),
/// ``PassIsIdentification`` (irreducible, Thm 2, each entry the unique `f*`), and
/// ``Resistant`` (resistant, I2), so the type is exactly their intersection. [Matter §2]
///
/// **Premises**: ``KnowledgeAccumulates`` (accumulation) · ``PassIsIdentification`` (kernel) · ``Resistant`` (geometry).
public protocol Matter: KnowledgeAccumulates, PassIsIdentification, Resistant {}

// ── §4 No-inverse: the load-bearing guarantee ──

/// Distinction has no inverse: no operation removes from Σ or the cache. The
/// library, like the cache (``KnowledgeAccumulates``), is append-only, this sits
/// beneath all three properties of ``Matter``. [Matter M21]
public protocol NoInverse: KnowledgeAccumulates
where Library: Permanent {}

// ── §4 Convergence ──

/// Every V=I game on finite Σ converges to a fixed point `(L*, G*)`. Finite
/// monotone sequences must converge: S shrinks (``SystemCrystallizes``), while G
/// and L grow and cannot retract (``NoInverse``). The fixed point is the crystal.
/// [Matter M12]
public protocol Converges: SystemCrystallizes, NoInverse {}

// ── §4 Ignition ──

/// At saturation `|L_N| = K_N`, the crystal becomes a valid V=I target for level
/// N+1, a discrete transition. A saturated library (``LibrarySaturates``) *is*
/// ``Matter``, hence the next level's target. [Matter M8]
public protocol Ignites: LibrarySaturates, Matter {}

// ── §4 The Tower ──

/// Each level's crystal is the next level's matter: the tower recurses by ignition
/// (``Ignites``) over discrete time (``HasTime``) and bounded cost (``HasCost``),
/// terminating at `K_M ≤ 1`, finite `Levels`. (Termination assumes compression at
/// every level, a premise stated in the paper, not derived from I1–I3.) [Matter §4]
public protocol Tower: Ignites, HasTime, HasCost {
    associatedtype Levels: IntegerValued
}

// ── §4 Finite discovery ──

/// The total thermodynamic cost of the ``Tower`` is bounded: finite levels (M16) ×
/// bounded COMPAREs per level (M5, M11, ``ComparisonsAreBounded``) × finite cost
/// per COMPARE (M24) = finite. [Matter M28]
public protocol FiniteDiscovery: Tower, ComparisonsAreBounded {}
