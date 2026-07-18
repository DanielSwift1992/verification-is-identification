// ═══════════════════════════════════════════════════════════════
// Gradient Is Alignment (Search).
//
// The whole search story assumed one thing it never named: that getting
// closer in structure gets you closer to the answer. This names it. A
// domain is searchable by descent iff its loss has no spurious minima
// along W: iff loss and distance-to-solution are correlated, a measurable
// coefficient α (GA3). High α: the geometry points at solutions, descent
// is ballistic. Zero α: the geometry is real but useless, no order beats
// enumeration, exactly IiI's distribution-relativity boundary as landscape
// ruggedness (GA6). Clustering is whether the space has geometry; alignment
// is whether the geometry is FOR you (GA7).
//
// Pure types (§0′). Grounds the Alpha axis (HasAlpha) with its content. [Search]
// ═══════════════════════════════════════════════════════════════

/// The premise of every search is that loss aligns with distance. α measures whether it does.
/// α = correlation( W(R,R*), loss(R) ) names the assumption: α→1 descent
/// optimal, α→0 rugged (no signal), α<0 deceptive. Descent reaches a solution
/// iff no spurious loss-minimum is along the ``DistanceOnStructures`` metric W
/// (the premise hidden in N5's "ballistic" promise: it arrives at a solution
/// only when the landscape is aligned, else at a wall, the wall being the
/// ``GateIsZeroOfLoss`` zero it can no longer reach). α is the measured
/// alignment, encoding-relative. [Search GA1-GA3]
///
/// > Note: α is on the ``HasAlpha`` axis: a property of the (domain,
/// > encoding) pair, not of the searcher. α changes with the encoding, and
/// > only with the encoding.
public protocol AlignmentCoefficient: HasAlpha, DistanceOnStructures, GateIsZeroOfLoss {}

/// Intelligence exceeds enumeration iff α > 0. The advantage η = T_min/T_actual
/// (``IntelligenceRises``) beats brute force exactly when the ``AlignmentCoefficient``
/// loss has a usable gradient. The α=0 case is IiI's distribution-relativity
/// boundary: a rugged loss and no-free-lunch are one wall seen from two sides. [Search GA6]
///
/// > Note: α > 0 is the single hinge. Above it the loss is a map. At zero it is
/// > noise and only enumeration remains.
public protocol AlignmentEnablesIntelligence: AlignmentCoefficient, IntelligenceRises {}

/// A domain is efficiently searchable by descent iff it is BOTH clustered AND
/// aligned. Clustered (G12: hierarchical W-structure exists) and aligned (α>0:
/// that structure leads to solutions) are independent ``AlignmentCoefficient``
/// properties, both required. This sharpens the one-boundary claim
/// (``OneBoundaryThreeFaces``, N18): clustering is whether the space has
/// geometry. Alignment is whether the geometry is for you. [Search GA7]
///
/// > Tip: Two knobs, not one. A space can have geometry that leads
/// > nowhere useful (clustered, α≈0) or a clear gradient over a structureless
/// > space (aligned, unclustered), and descent pays only when both are there.
public protocol SearchableIffClusteredAndAligned: AlignmentCoefficient, OneBoundaryThreeFaces {}

// ───────────────────────────────────────────────────────────────
// GA4 (why primes are hard) and GA8 (symmetry, a third lever): recorded.
//
// GA4: primes fail in the DEEPER mode, not "graded but misaligned" (α≈0) but
// "no cheap graded loss at all": the predicate is binary, the one graded
// surrogate (distance to nearest prime) is as expensive as the problem. The
// α≈0 calibration point (Basis Is Residue's primes).
//
// GA8: clustering (amortizes), alignment (orders), and SYMMETRY (shrinks the
// space by quotient (the √n divisor-pairing) are three orthogonal levers. A
// domain's profile is a triple (cluster, align, symmetry); primes have only
// symmetry. A third axis worth its own pin in a later pass.
// ───────────────────────────────────────────────────────────────
