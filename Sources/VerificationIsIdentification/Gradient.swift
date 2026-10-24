import Notation

// ═══════════════════════════════════════════════════════════════
// Distance Is Cost (Gradient).
//
// Difference Is Distance gave the geometry between witnesses (agents).
// This gives the geometry between the witnessed (structures). A structure
// IS its set of distinctions (G1), and the minimal number of single-distinction
// changes from s to t is W(s,t) = |D(s) △ D(t)|, a TRUE metric on Σ (G2),
// integer-valued, with NULL as origin. Binary COMPARE is its zero test, and
// the gradient was always inside the operation, only asked for its sign.
// W counts edits. A physical energy conversion needs an implementation model.
//
// Pure types (§0′). A gradient layer threading Distance, Cost, Tower,
// Resistance. Internal instances (§6 Peano/grid) and §9–§10 omitted as
// before. [DiC]
// ═══════════════════════════════════════════════════════════════

/// Names a distance axis and two legs with a shared endpoint over structures.
/// G2 proves that the specified W(s,t) = |D(s) △ D(t)| is a metric, using
/// G1's injective address-set representation. This declaration does not bind
/// an arbitrary Distance conformer to W or encode its triangle inequality.
/// That binding remains a type-level proof obligation. [DiC G2]
///
/// > Note: This is the central type of the gradient layer: every other protocol
/// > here threads through ``HasDistance``. Finitude and a count do not alone
/// > identify this axis with the particular metric proved in G2.
public protocol DistanceOnStructures: HasDistance, StructuresFinite
where Distance: MetricProperty {}

/// An implementation chooses to charge the edit count as ``HasCost``.
/// The equality is a declared identification of discrete axes, not a proof
/// of a joule conversion or a Landauer charge for every edit. It is pinned
/// as `where Distance == Cost` under that cost model. [DiC G2c]
public protocol DistanceIsCost: DistanceOnStructures, HasCost
where Distance == Cost {}

/// Combines the distance interface with equality of this Pair's own sides.
/// G1b identifies the syntax leaf NULL as the unique zero-norm finite tree.
/// A Null conformance alone does not identify its carrier with that leaf.
/// G2f binds zero distance to actual endpoints in its constructor grammar.
public protocol NullIsOrigin: DistanceOnStructures, Null {}

/// Names the decision interface beside the distance axis. G4 separates a
/// zero question, a frontier address and the magnitude of W. G2f constructs
/// the zero relation directly from source-bound partitions, without reading
/// a numerical cardinality first. This intersection alone provides neither
/// that construction nor a terminating comparator. [DiC G4]
public protocol GradientInComparison: DistanceOnStructures, Decidable {}


/// Names membership beside the distance axis. G13 proves zero loss exactly
/// when every actual output equals its declared target, for a fixed finite
/// family of defined applications. This protocol alone binds neither those
/// applications nor their coverage. G2f and G2h supply scalar-free zero and
/// strict-progress constructions for finite output trees. [DiC G13]
public protocol GateIsZeroOfLoss: PassImpliesMembership, DistanceOnStructures {}

/// G11 bounds covered rules within 2r of retained anchors in the same balls.
/// Recovery needs a suitable dispatcher or search over all anchored balls.
/// Cover time depends on the arrival law, as in Intelligence §6. This
/// interface alone constructs neither the cover nor its anchors. [DiC G11]
public protocol BallSaturation: LibrarySaturates, DistanceOnStructures {}

/// Names a tower beside the distance axis. G12 proves the minimum number
/// of representatives under a specified approximation error. An arbitrary
/// tower need not implement that assignment, and exact generic reuse
/// does not require a nontrivial metric grouping.
public protocol CompressionCriterion: Tower, DistanceOnStructures {}

/// Names resistance beside a distance axis. G15 distinguishes the edit
/// count from duration, rule-discovery cost and physical response. Actual
/// transitions and resource laws must bind those interpretations. G2h can
/// certify addressed progress without choosing a steepest step. [DiC G15]
public protocol ResistanceHasMagnitude: Resistant, DistanceOnStructures {}
