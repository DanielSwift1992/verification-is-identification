// ═══════════════════════════════════════════════════════════════
// Difference Is Distance (Space).
//
// One agent has state but no position. Multiple agents on the same
// target produce a metric space from the difference in their histories.
// Central result (S7): distance = the symmetric difference of two
// agents' comparison caches, |G₁ △ G₂|, a metric. Distance is not a
// primitive; it is the difference in what two agents have witnessed.
//
// Pure types (§0′). Grounds the Distance / MetricProperty machinery the
// markers already name. Physical instances (§9, S18–S24) are analogical
// not encoded, as with Matter §5.
// ═══════════════════════════════════════════════════════════════

// ── New axis: the grammar and its dimension ──

/// The perceptual space's dimensionality is the number of independent axes of the
/// grammar, a finite count. It is the grammar's property (``HasEncoding``), not the
/// target's or the agent's. [DiD S5, S14]
public protocol HasGrammar: HasEncoding {
    associatedtype Dimension: IntegerValued
}

// ── §0–§2 · one agent: perspective is encoding ──

/// The agent's perspective *is* its encoding: determined by E alone, gauge-
/// invariant (``HasEncoding``, bounded by ``ScopeBoundedByEncoding``). One agent
/// has only its frame, so an encoding-preserving transform is invisible to it,
/// a ``Measurable`` fact. [DiD S1, S2]
public protocol PerspectiveIsEncoding: ScopeBoundedByEncoding, HasEncoding, Measurable {}

// ── §5 · two agents: distance ──

/// Distance between two agents is the symmetric difference of their caches,
/// `|G₁ △ G₂|`. On cache states it is a true metric (identity, symmetry, triangle,
/// bounded `≤ |Σ|²`). On agents it is a pseudometric, since equal caches are at
/// distance zero. ``HasDistance`` over ``HasCache``, with `Distance` (a finite count,
/// ``IntegerValued``) here pinned ``MetricProperty``. [DiD S7]
///
/// > Note: Distance is not a primitive: it is the difference in what two agents
/// > have witnessed. Space is built from comparison history, so the metric axioms
/// > are theorems of the cache, not assumptions.
public protocol DistanceIsMetric: HasDistance, HasCache
where Distance: MetricProperty {}

/// Space is the set of all perspective-distances. One agent is a point (zero
/// distance, S1), and n agents span up to `(n−1)` dimensions. A metric
/// (``DistanceIsMetric``) over the grammar's axes (``HasGrammar``). [DiD S8]
public protocol SpaceFromDifference: DistanceIsMetric, HasGrammar {}

// ── §8 · theorems ──

/// The distinguishable qualities ("colors") of an agent are bounded by `|E|`, a
/// finite count (``IntegerValued``). Every agent perceives finitely many, fixed by
/// its encoding (``HasEncoding``). [DiD S13]
public protocol QualitiesAreFinite: HasEncoding, IntegerValued {}

/// Full agreement between two agents costs at most `|Σ|² × 2` COMPAREs, bounded
/// comparisons (``ComparisonsAreBounded``) over their caches (``HasCache``).
/// [DiD S16]
public protocol CommunicationBounded: ComparisonsAreBounded, HasCache {}

/// Maximum perceptual depth is the saturated tower height, `M ≤ K₀` (M16). Depth
/// is the grammar's reach (``HasGrammar``) through the finite ``Tower``. [DiD S17]
public protocol DepthIsBounded: Tower, HasGrammar {}
