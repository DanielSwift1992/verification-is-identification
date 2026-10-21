import Notation

// ═══════════════════════════════════════════════════════════════
// Order Is Object (Strategy).
//
// Fixed complete verification permits different comparison orders with
// the same survivor set. This does not exhaust every agent's choices.
// IiI noted strategy state is mutable: a caveat. This paper
// removes the caveat by changing its level: a strategy is a finite
// decision tree, a finite decision tree is a structure in Σ, and
// structures in Σ can be verified, identified, certified, crystallized.
// The order that is PHASE at level N is AMPLITUDE at level N+1. The
// library entry completes into (f*, E, σ*): WHAT, through which lens,
// HOW to reach it fastest. The path itself becomes a certified object.
//
// Pure types (§0′). The Y-axis was the last unowned degree of freedom, and
// it enters the library, with a proof attached, like everything else.
// ═══════════════════════════════════════════════════════════════

/// A strategy (an order-choosing decision tree) is a finite structure in Σ, so
/// an order in the restricted scope of ``OrderIsOnlyFreedom`` (§5.25) has a
/// norm ‖σ‖ and a distance W. Strategy geometry is inherited from
/// ``DistanceOnStructures``, not constructed, the moment the order enters Σ.
/// [Order O1, O2]
///
/// The same intersection is the proposal order of Distance Is Cost. Ordering
/// proposals by W (nearest first) tunes efficiency while adding zero identification
/// bits: order is the sole degree of freedom, and the ``DistanceOnStructures`` metric
/// reshuffles the order of attempts. The gate is untouched (Thm 2: correctness from
/// verification, not search). [DiC G9]
public protocol StrategyLivesInSigma: DistanceOnStructures, OrderIsOnlyFreedom {}

/// Joins a strategy description and an acceptance interface. O6's soundness
/// argument additionally restricts strategy access: it may choose readings
/// but cannot falsify evidence or bypass the fixed PASS rule. O5 checks cost
/// and completion on its listed tasks. These interfaces alone neither encode
/// those permissions nor establish class-wide performance. [Order O5–O6]
public protocol StrategyGate: StrategyLivesInSigma, PassImpliesMembership {}

/// At the minimal budget, a nonempty passing set in O1's finite strategy
/// family has one minimum under O8's order: worst-case cost, then norm,
/// then structural order. This refines acceptance to the selected strategy.
/// Theorem 2 applies under the strategy game's verification premises.
/// The ``ExactlyOneSurvives`` coordinate does not itself perform this
/// selection. [Order O1, O6, O8]
public protocol StrategyIsUnique: StrategyGate, ExactlyOneSurvives {}

/// The certified σ* (``StrategyIsUnique``) enters the library and inherits I3,
/// permanent, irreducible, resistant: it *is* ``Matter``. The IiI §2 caveat
/// ("strategy state is mutable") is true, but about the wrong level: strategy
/// STATE at level N is mutable scaffolding. The strategy OBJECT at level N+1 is
/// permanent. [Order O9]
///
/// > Note: A certified strategy retained under I3 is a permanent library object.
/// > The state of a process using that description can continue to change.
public protocol StrategyCrystallizes: StrategyIsUnique, Matter {}

/// At level N a deterministic comparison choice adds no information beyond the
/// known history (InI S1), and the same retained static evidence gives the same
/// final compatible set under every order (InI S2). One level up the strategy
/// itself can be the ENTIRE identified content: the strategy game's target is σ*.
/// Once ``StrategyCrystallizes``, the strategy gate becomes a
/// ``PassIsIdentification``, and the Y-axis of level N becomes the Z-axis of
/// level N+1. The phase name is an analogy. [Order O10]
///
/// > Note: The order chosen below becomes identified content above. Read one
/// > level up, it is the very thing the gate certifies.
public protocol PhaseBecomesAmplitude: StrategyCrystallizes, PassIsIdentification {}

/// After rule and strategy saturation, a ``HasLibrary`` entry is the triple
/// (f*, E, σ*): WHAT the answer is, THROUGH WHICH lens (``HasEncoding``), HOW to
/// reach it fastest. Once ``PhaseBecomesAmplitude``, the object contains its
/// path: certified WHAT (Thm 2), supplied lens (R4), certified HOW (the strategy gate).
/// [Order O12]
public protocol CompleteEntry: PhaseBecomesAmplitude, HasEncoding, HasLibrary {}

/// A metric ball can represent a family of nearby strategy codes. Exact
/// generic strategy reuse also depends on its actual applications and
/// can serve new inputs without a metric grouping. [Order O15]
public protocol SkillsAreBalls: StrategyLivesInSigma, BallSaturation {}

/// A finite strategy library under W and a chosen radius has an anchor graph.
/// Each navigation theorem applies under its own premises. Retaining insertion
/// preserves supplied paths for fixed starts, targets and radius. The global
/// routing threshold can increase on an expanded domain. A witnessed missing
/// improving neighbor specifies an acquisition question. Obtaining a usable
/// strategy there requires another witness.
/// ``SkillsAreBalls`` and ``NavigationInevitable`` join these interfaces.
/// Actual graph construction, routes and failure witnesses belong to the
/// application. [Order O16, O18] [NiG N16–N19]
public protocol StrategyNavigation: SkillsAreBalls, NavigationInevitable {}

/// Historical name for strategy and rule geometry interfaces. Their
/// shared metric does not imply equivalent learning or routing criteria.
/// Strategy transfer needs its own application contract. [Order O18]
public protocol FourthFace: OneBoundaryThreeFaces, SkillsAreBalls {}
