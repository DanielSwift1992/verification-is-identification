// ═══════════════════════════════════════════════════════════════
// Distance Is Cost (Gradient).
//
// Difference Is Distance gave the geometry between witnesses (agents).
// This gives the geometry between the witnessed (structures). A structure
// IS its set of distinctions (G1), and the minimal number of single-distinction
// changes from s to t is W(s,t) = |D(s) △ D(t)|, a TRUE metric on Σ (G2),
// integer-valued, with NULL as origin. Binary COMPARE is its zero test, and
// the gradient was always inside the operation, only asked for its sign.
// W × kT·ln2 is the work of re-formation: distance IS cost.
//
// Pure types (§0′). A gradient layer threading Distance, Cost, Tower,
// Resistance. Internal instances (§6 Peano/grid) and §9–§10 omitted as
// before. [DiC]
// ═══════════════════════════════════════════════════════════════

/// W(s,t) = |D(s) △ D(t)| is a TRUE metric on Σ itself: the geometry of forms,
/// sharper than the geometry of perspectives. Distance is a ``MetricProperty``
/// over a finite structure space (``StructuresFinite``): W=0 forces s=t (G1: D is
/// a bijection), and the count is integer-valued (G2b). This sharpens DiD S7, which
/// gave only a pseudometric on agents. [DiC G2]
///
/// > Note: This is the central type of the gradient layer: every other protocol
/// > here threads through ``HasDistance``. The metric exists the moment the
/// > structures are finite and distinctions are countable.
public protocol DistanceOnStructures: HasDistance, StructuresFinite
where Distance: MetricProperty {}

/// The minimal work to transform s into t is W(s,t) × kT·ln2: distance *is* cost,
/// two readings of one integer count. The ``DistanceOnStructures`` metric and the
/// thermodynamic ``HasCost`` are the same quantity. The conclusion is pinned (§T)
/// as a collapse: `where Distance == Cost`. This is the title claim. [DiC G2c]
public protocol DistanceIsCost: DistanceOnStructures, HasCost
where Distance == Cost {}

/// ``Null`` is the unique structure of norm 0: the only form that costs nothing.
/// (Σ, W, ``Null``) is a pointed metric space over ``DistanceOnStructures``:
/// distance from the origin is the norm is the cost, and the origin is the
/// boundary. [DiC G1b]
public protocol NullIsOrigin: DistanceOnStructures, Null {}

/// One traversal yields three readings of COMPARE: Z (the sign, 1 bit: is W=0?),
/// X (one frontier address: where to repair), Δ (the full magnitude W). The
/// ``Decidable`` COMPARE on a ``DistanceOnStructures`` space is the sign of the
/// gradient. The magnitude was always present, priced above the default budget.
/// [DiC G4]
public protocol GradientInComparison: DistanceOnStructures, Decidable {}

/// Ordering proposals by W (nearest first) tunes efficiency while adding zero
/// identification bits: order is the sole degree of freedom (``OrderIsOnlyFreedom``,
/// §5.25). The ``DistanceOnStructures`` metric reshuffles the order of attempts.
/// The gate is untouched (Thm 2: correctness from verification, not search). [DiC G9]
public protocol OrderByDistance: DistanceOnStructures, OrderIsOnlyFreedom {}

/// Compilation passes iff loss = 0: the gate is the zero of the W-loss. Descent
/// reduces loss (proposes, fallible: the agent). ``PassImpliesMembership``
/// certifies at zero on the ``DistanceOnStructures`` metric (exact, permanent: the
/// system). Y-axis and Z-axis of one COMPARE. [DiC G13]
public protocol GateIsZeroOfLoss: PassImpliesMembership, DistanceOnStructures {}

/// Cover the rule space by N(r) W-balls. After N(r)·H_{N(r)} tasks each is
/// anchored, and every task then resolves within 2r of an anchor. Generalization
/// is ``LibrarySaturates`` measured at radius r on the ``DistanceOnStructures``
/// metric: at r=0 this *is* the Saturation Theorem (balls are points), and
/// memoization is its degenerate case. [DiC G11]
public protocol BallSaturation: LibrarySaturates, DistanceOnStructures {}

/// The ``Tower``'s compression premise (M16, K_{N+1}<K_N, once underived) becomes
/// a MEASURABLE criterion on the ``DistanceOnStructures`` metric: compression at
/// level N iff the library is r-compressible, N_{L_N}(r) < K_N. The tower halts at
/// the first metrically uniform library, a flat W-matrix is the shape of "nothing
/// to learn". [DiC G12]
public protocol CompressionCriterion: Tower, DistanceOnStructures {}

/// Resistance acquires magnitude: it is W(candidate, target), the minimal work
/// remaining. The ``Resistant`` relation (Matter §1) gains direction on the
/// ``DistanceOnStructures`` metric: "the agent must yield" becomes yield along the
/// steepest descent the frontier reveals. Inertia is the same quantity at the
/// library scale. [DiC G15]
public protocol ResistanceHasMagnitude: Resistant, DistanceOnStructures {}
