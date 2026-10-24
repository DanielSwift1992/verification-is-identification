import Notation

// Navigation Is Geometry. The metric, a radius graph, actual access
// and the routing policy have distinct obligations. N18 rejects their
// identification with a single clustering number.

/// Names a library beside the distance axis. N1 defines the graph by
/// actual W-distances and a chosen radius. This intersection alone does
/// not bind Distance to W, select the radius or construct the edges.
public protocol AnchorGraph: DistanceOnStructures, HasLibrary {}

/// A sequence of actual strict W-decreases on finite trees has a finite
/// bound. G2h supplies addressed strict-progress witnesses. Monotone
/// alone only constrains a projection and does not require strictness,
/// construct a route or rule out stopping away from the target. [NiG N5]
public protocol GreedyDescentTerminates: AnchorGraph, Monotone {}

/// N6 names a start, target and radius lacking a closer accessible node.
/// A Decidable interface alone does not enumerate the relevant neighbors
/// or compute this negative verdict.
public protocol HolesCarryAddresses: AnchorGraph, Decidable {}

/// Under retaining insertion, previous edges and supplied paths remain
/// available. N19 shows that a global score over an expanded set of starts
/// and targets need not improve. This interface does not implement an update.
public protocol RepairsPermanent: AnchorGraph, NoInverse {}

/// A witnessed missing transition can define an acquisition question.
/// Obtaining a usable rule for that transition requires another witness,
/// and expanding the graph can add new routing obligations. [NiG N15–N19]
public protocol FailureCurriculum: HolesCarryAddresses, RepairsPermanent {}

/// Historical name for three interfaces using a metric. G12, G11 and N18
/// separate representative approximation, anchored recovery and navigation.
/// A common W-matrix does not make their premises equivalent or establish
/// that every form of reuse requires clustering.
public protocol OneBoundaryThreeFaces: CompressionCriterion, BallSaturation, AnchorGraph {}

/// N19 requires actual population and acquisition premises. Retention
/// preserves supplied paths. The global threshold on a growing domain can
/// increase, so this intersection does not prove universal improvement.
public protocol NavigationInevitable: OneBoundaryThreeFaces, LibrarySaturates {}
