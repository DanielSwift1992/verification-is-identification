// ═══════════════════════════════════════════════════════════════
// Form Is Gauge (Gauge).
//
// One content admits many spellings: flat bodies, folded slices, sharded files,
// directly stated coordinates. Every spelling renders the same artifact, and the
// class of spellings is the GAUGE — the parameter correctness cannot see. The move
// is §5.25's, performed on form instead of order: form is the sole freedom of the
// emission, as order is the sole freedom of the run.
//
// A standing arbiter prices the gauge through its organs (a solver superlinear in
// body size, a deserializer recursive in depth), so a cost sweep over the class
// crystallizes to the arbiter's cheapest form. An arbiter priced by the token
// (CostIsPathLength) reads a regrouping only as the grouping skeleton's own tokens,
// so under it the cost encoding joins the content encoding in refusing to
// crystallize. The knee, the fanout, the wall belong to the judge — and the second
// judge in the package (Tools, `judge`) is the standing witness: linear growth, a
// flat sweep, seated differentially beside the compiler.
//
// Pure types (§0′). A capstone over Program Is Path, the crystallization axioms,
// and the packing domain (Examples/FormCrystallization). [FiG]
// ═══════════════════════════════════════════════════════════════

/// The gauge axis opens the grouping freedom of an emitted artifact: which of the
/// forms rendering one content the artifact is in.
///
/// A generated roster can list its members flat, fold them into slices, shard them
/// across files, or state each coordinate directly, and every choice renders the same
/// pages. The theorems below dimension the choice: what it can never touch, what
/// prices it, and under which arbiter it stops costing. [FiG]
public protocol HasGauge: HasSigma {
    associatedtype Gauge
}

/// Content is fixed across the gauge class: regrouping an artifact reveals its
/// content and edits nothing.
///
/// The reading is closed over the gauge choice (``RevealsNotCreates``), so every form
/// in one class has one encoding, checked by byte comparison of the rendered
/// artifact. The packing domain's content verdict is the compiled witness. [FiG1]
public protocol ContentIsGaugeInvariant: HasGauge, HasEncoding, RevealsNotCreates {}

/// Cost is a reading of the gauge under a standing arbiter: one content has many prices.
///
/// The arbiter's organs read form-sized terms, one coordinate each (body size for
/// the solver, derivation depth for the deserializer), and no organ prices the
/// content, since the content is what every form shares. The dependency is in the axis pairing
/// (``HasDistance`` with ``HasGauge``). [FiG2]
public protocol CostReadsGauge: HasGauge, HasDistance {}

/// A cost sweep over the gauge class crystallizes, and its survivor is a constant of
/// the arbiter's cost function.
///
/// The sweep satisfies the crystallization axioms: candidates finite, the clock's
/// ordering decidable, a slower form excluded for good, one survivor
/// (``SystemCrystallizes``). A form dictionary that ships the survivor records a
/// vote, and the vote belongs to the voter: a new arbiter re-runs the election.
/// `PackingUnderCost` is the compiled witness, in `Examples` beside
/// ice. [FiG3]
public protocol GaugeFixing: CostReadsGauge, SystemCrystallizes {}

/// The linear arbiter prices by the token: one distinction per step and nothing else
/// in the bill.
///
/// Its whole work is one pass (a dictionary of names, a lookup per reference), so
/// its cost axis closes onto the artifact's own length (``CostIsPathLength``,
/// `Distance == Path`). No organ reads a form-sized term. [FiG · PiP3]
public protocol LinearArbiter: CostIsPathLength {}

/// The collapse: under the linear arbiter, cost joins content in gauge-invariance.
///
/// Priced by the token, the arbiter reads a regrouping only as the grouping
/// skeleton's own tokens, a linear term. The cost sweep goes flat, its
/// crystallization fails with it, and the refusal coincides with the content
/// encoding's (`PackingUnderContent`): cost crystallizes exactly where the arbiter
/// is superlinear. [FiG6]
public protocol GaugeCollapse: LinearArbiter, ContentIsGaugeInvariant {}

// ───────────────────────────────────────────────────────────────
// Recorded, not pinned (the house pattern: a corollary no finite axis expresses,
// kept beside Basis B8b and Gen GD7).
//
// THE VOTE EXPIRES. Gauge-fixing binds a dictionary constant to an arbiter version,
// and no type states a version. The dictionary ships with its election procedure
// (the curve command), and the procedure outlives every number it prints. [FiG3]
//
// THE SECOND JUDGE. The collapse's witness is a checker whose whole work is the
// linear pass, seated beside the standing arbiter as a second encoding of one
// verdict (§5.4). A disagreement is decidable and finite, so it bisects to a minimal
// witness naming the defect in one judge or the other. The standing arbiter stays
// external, and the small judge is auditable by reading it: the gate it must carry
// is a handful of markers, each a simple relation on Pair (Path.swift, closing
// note). [FiG6]
// ───────────────────────────────────────────────────────────────
