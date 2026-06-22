// ═══════════════════════════════════════════════════════════════
// Proposal Is Order (Generation).
//
// V=I built the DISCRIMINATOR — the certified cut, |S|=1, never a wrong
// PASS. The other organ, the GENERATOR that proposes candidates to cut, was
// always delegated. This derives it and proves it orthogonal. A solve is
// iterate(discriminate ∘ generate), and the two have disjoint inputs: the
// discriminator is the cut (Z-axis, the sole source of identification bits,
// §5.21-22); the generator is the order (Y-axis, zero new bits, InI S2). The
// deepest result is an asymmetry: the inevitability the series proved is the
// DISCRIMINATOR's; the generator is conditional on alignment α, which
// saturation cannot manufacture. The organ carrying all the information is the
// one proved inevitable; the organ carrying none is where domains are hard.
//
// Pure types (§0′). The cut's silent twin. [Gen]
// ═══════════════════════════════════════════════════════════════

/// A solve is iterate(DISCRIMINATE ∘ GENERATE): two organs with disjoint inputs.
/// The discriminator is the CUT — the Z-axis, each COMPARE eliminates survivors,
/// the sole source of identification bits (``PassImpliesMembership``). The
/// generator is the ORDER — the Y-axis, which candidate next, zero new bits yet
/// it sets the total count (``OrderIsOnlyFreedom``). Information enters only
/// through D. G only chooses where D looks. [Gen GD1-2]
///
/// > Note: The split is the whole paper. Every identification bit comes from the
/// > cut. The generator spends none yet fixes how many cuts you pay — all the
/// > information in one organ, all the cost in the other.
public protocol DiscriminatorAndGenerator: PassImpliesMembership, OrderIsOnlyFreedom {}

/// Discriminate-easy and generate-easy are INDEPENDENT: all four quadrants of
/// ``DiscriminatorAndGenerator`` inhabited. Primes: cheap gate (√n), rugged
/// generator (α≈0). Under-specified tasks: cheap descent, |S|>1 discriminator.
/// Neither easiness implies the other — this completes
/// ``SearchableIffClusteredAndAligned`` by adding the discriminator's separation
/// axis, independent of clustering and alignment. [Gen GD3]
public protocol OrthogonalOrgans: DiscriminatorAndGenerator, SearchableIffClusteredAndAligned {}

/// The inevitability the series proved is the DISCRIMINATOR's, not the generator's.
/// At saturation the library teaches the optimal ordering, η→1
/// (``IntelligenceRises``), on structural premises alone (I1, I3). The GENERATOR
/// of ``DiscriminatorAndGenerator`` is conditional on the ``AlignmentCoefficient``
/// α, which saturation NEVER manufactures: α is a property of (domain, encoding),
/// invariant under accumulation. Generator-power = ordering-visibility = α: three
/// statements, one quantity. The one precondition intelligence's own engine
/// cannot produce is its generator's alignment. [Gen GD4-5]
///
/// > Note: The asymmetry is the deepest result. The organ that carries every
/// > bit is the one the series proved inevitable. The organ that carries none is
/// > exactly where domains stay hard — α is given, never grown.
public protocol InevitabilityIsDiscriminator: DiscriminatorAndGenerator, IntelligenceRises, AlignmentCoefficient {}

/// The two organs are ONE mechanism: both are COMPARE (§2.5). The
/// ``DiscriminatorAndGenerator`` D is COMPARE read for its outcome (Z). G is the
/// choice of which COMPARE next (Y). The split is scope on one ``Decidable``
/// primitive — the framework stays monist, consistent with PP15: both run on the
/// one given COMPARE, neither certifies it. [Gen GD8]
public protocol OrgansAreOneCompare: DiscriminatorAndGenerator, Decidable {}

// ───────────────────────────────────────────────────────────────
// GD7 / GD9 — connections, recorded.
//
// GD7: E2's encoder/backend split IS generator/discriminator. The backend (D)
// is proven-safe and inevitable; the encoder (G) is the open problem. C2
// (discrimination) is the D-condition; C1/C3/C4/C5 are G-conditions. All
// irreducible difficulty localizes to G because D is proven (see Spec.swift).
//
// GD9: on a HORN (K=∞, Basis Is Residue) the generator is the ONLY mode — no finite
// library stores the confusion matrix, so learned-optimal ordering is
// unreachable; generation from the certified basis with per-task certification
// is forced. Intelligence strips to generation-from-basis.
// ───────────────────────────────────────────────────────────────
