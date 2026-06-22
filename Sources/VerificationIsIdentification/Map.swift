// ═══════════════════════════════════════════════════════════════
// Navigation Is Geometry (Map).
//
// Distance Is Cost gave the library a metric. A metric space is not yet a
// map. The library under W is a finite metric space; a radius ρ makes it a
// graph (N1); greedy descent toward any comparable target terminates in at
// most W(start,target) hops, because W is integer-valued and every hop pays
// at least one distinction (N5); failure is an address, not a verdict (N6);
// repairs are permanent and the holes themselves are the curriculum (N17).
// Learning, generalization, and navigation are three faces of one measurable
// property — the clustering of the W-matrix (N18).
//
//   "The metric was the map all along. A library you can search is a cache.
//    A library you can navigate is a territory."
//
// Pure types (§0′). Builds entirely on the gradient (Distance Is Cost). [Nav]
// ═══════════════════════════════════════════════════════════════

/// For a library and radius ρ, the anchor graph Γ has entries as nodes and pairs
/// with W ≤ ρ as edges: the library drawn as a map. A ``HasLibrary`` under the
/// ``DistanceOnStructures`` metric becomes a graph: finite (I1), computed from the
/// W-matrix. The metric was the map all along. [Nav N1]
public protocol AnchorGraph: DistanceOnStructures, HasLibrary {}

/// A greedy walk toward any comparable target terminates in at most W(s,τ) hops.
/// On the ``AnchorGraph``, W is integer-valued (DiC) and every hop strictly
/// decreases it by ≥1, bounded below by 0. The descent is ``Monotone`` and its
/// floor is W=0 — arrival, which *is* identification (G2b: W=0 forces s=t). [Nav N5]
///
/// > Note: This is the central navigation result — search becomes a downhill
/// > walk with a counted bound. Integer distance plus monotone descent is all
/// > termination needs — no heuristic, no backtracking.
public protocol GreedyDescentTerminates: AnchorGraph, Monotone {}

/// A stuck walk's failure carries an address: the triple (s, τ, ρ) names the
/// blank region where the ``AnchorGraph`` has no anchor. The failure says WHERE,
/// with coordinates: a ``Decidable`` verdict that localizes itself rather than
/// reporting "lost". [Nav N6]
public protocol HolesCarryAddresses: AnchorGraph, Decidable {}

/// Holes are repairable by insertion, and repairs are permanent: inserted anchors
/// never leave (I3, ``NoInverse``), and insertion can never strand a node that
/// already had a closer neighbour. Stuckness only shrinks as the ``AnchorGraph``
/// grows — the map only ever improves. [Nav N15, N16]
public protocol RepairsPermanent: AnchorGraph, NoInverse {}

/// The set of current holes *is* the acquisition agenda. Every routing failure has
/// an address (``HolesCarryAddresses``), the address is actionable, and acting on
/// it is monotone progress (``RepairsPermanent``) — so the router's failures are
/// the curriculum. The navigation-level instance of the series' one pattern: the
/// failure names its own cure. [Nav N17]
public protocol FailureCurriculum: HolesCarryAddresses, RepairsPermanent {}

/// Learning, generalization, and navigation are three consumers of ONE measurable
/// property: whether the domain's W-matrix clusters. Compression
/// (``CompressionCriterion``), anchored balls (``BallSaturation``), and the map
/// (``AnchorGraph``) are three faces of that one number, not three assumptions.
/// A flat matrix denies all three at once. A clustered one offers all three. [Nav N18]
///
/// > Tip: One boundary governs the whole layer, and it is a number you can
/// > compute — measure the clustering of the W-matrix and all three faces follow.
///
/// **Premises** — ``CompressionCriterion`` (learning) · ``BallSaturation`` (generalization) · ``AnchorGraph`` (navigation).
public protocol OneBoundaryThreeFaces: CompressionCriterion, BallSaturation, AnchorGraph {}

/// Under a populating stream, navigation converges and stays converged. Every ball
/// eventually receives an anchor (coupon collector), stuck-sets shrink
/// monotonically (``LibrarySaturates``), and ρ_nav is non-increasing — reached and
/// KEPT, because I3 forbids regression. The ``OneBoundaryThreeFaces`` clustering
/// makes navigation inevitable for the same reason intelligence is: append-only
/// accumulation over a finite clustered space. [Nav N19]
public protocol NavigationInevitable: OneBoundaryThreeFaces, LibrarySaturates {}
