import Notation

// ═══════════════════════════════════════════════════════════════
// Difference Is Distance (Space).
//
// One form can already contain distinctions and internal references.
// S7 derives a metric on finite caches of commonly addressed records.
// S8 separates this count from an ambient Euclidean space. Section 5a
// asks which geometry is already expressed by the contact relations.
// Sections 5c–5e test Einstein's premises against internal comparisons:
// invariant readings under transport and clock content beyond light incidence.
//
// Pure types (§0′). These legacy coordinates do not construct that
// metric or derive its physical interpretation. The actual finite-tree
// distance constructors and their generic consequences are in Distance.
// ═══════════════════════════════════════════════════════════════

// ── New axis: the grammar and its dimension ──

/// Names a proposed dimension. S3 requires joint freedom of coordinate roles.
/// Pairwise nondetermination is insufficient. A metric, a topology or an actual
/// product interpretation must establish the intended meaning of this count.
/// The recursive numeral interface alone establishes none of them. [DiD S5, S14]
public protocol HasGrammar: HasEncoding {
    associatedtype Dimension: IntegerValued
}

// ── §0–§2 · one agent: perspective is encoding ──

/// Joins scope and encoding coordinates with Measurable. S1 requires equal
/// actual encoded inputs to the same reading. An unchanged encoder can receive
/// different inputs.
/// Internal references and records can already belong to one form. [DiD S1, S2]
public protocol PerspectiveIsEncoding: ScopeBoundedByEncoding, HasEncoding, Measurable {}

// ── §5 · two agents: distance ──

/// S7 proves that finite cache symmetric difference is a metric, and a
/// pseudometric on holders through their caches. Records need common source,
/// question and context addresses. A uniform bound needs a finite vocabulary.
/// This interface pins only a MetricProperty endpoint seam. It neither
/// computes the cache difference nor supplies the metric inequalities.
public protocol DistanceIsMetric: HasDistance, HasCache
where Distance: MetricProperty {}

/// Joins a distance coordinate and a proposed grammar dimension. Two cache
/// classes supply two points, not a whole line. S8's four-cache example has
/// no Euclidean embedding preserving its unmodified distances. Contact roles
/// and their actual relations supply the earlier structural question. [DiD S8]
public protocol SpaceFromDifference: DistanceIsMetric, HasGrammar {}

// ── §8 · theorems ──

/// Names an encoding and a numeral coordinate. S13 bounds a joint image by
/// the product of its finite answer-set sizes. A count of encoding names or
/// a finite constructor alphabet does not supply that bound.
public protocol QualitiesAreFinite: HasEncoding, IntegerValued {}

/// Names comparison and cache coordinates. S16's exact transfer count uses
/// an interface that delivers and retains one missing record per transfer.
/// These inherited coordinates do not supply that interface or its costs.
public protocol CommunicationBounded: ComparisonsAreBounded, HasCache {}

/// Names a tower and grammar. S17's finite bound requires a strictly decreasing
/// nonnegative integer across the relevant levels, as in Matter M16. These
/// coordinates alone do not prove that every possible tower terminates.
public protocol DepthIsBounded: Tower, HasGrammar {}
