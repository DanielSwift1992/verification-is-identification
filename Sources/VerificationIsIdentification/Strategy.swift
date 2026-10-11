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
public protocol StrategyLivesInSigma: DistanceOnStructures, OrderIsOnlyFreedom {}

/// Joins a strategy description and an acceptance interface. O6's soundness
/// argument additionally restricts strategy access: it may choose readings
/// but cannot falsify evidence or bypass the fixed PASS rule. O5 checks cost
/// and completion on its listed tasks. These interfaces alone neither encode
/// those permissions nor establish class-wide performance. [Order O5–O6]
public protocol StrategyGate: StrategyLivesInSigma, PassImpliesMembership {}

/// Among the strategies passing the ``StrategyGate`` at the minimal budget, argmin
/// over (worst-case cost, ‖σ‖, structural order) has a unique minimum σ*, the
/// cheapest of the fastest, so ``ExactlyOneSurvives``. R4 is true for the refined
/// relation. Thm 2 is in force. [Order O8]
public protocol StrategyIsUnique: StrategyGate, ExactlyOneSurvives {}

/// The certified σ* (``StrategyIsUnique``) enters the library and inherits I3,
/// permanent, irreducible, resistant: it *is* ``Matter``. The IiI §2 caveat
/// ("strategy state is mutable") is true, but about the wrong level: strategy
/// STATE at level N is mutable scaffolding. The strategy OBJECT at level N+1 is
/// permanent. [Order O9]
///
/// > Note: The order, once transient scaffolding, freezes into a permanent
/// > library object. Raising the level is what turns mutable phase into matter.
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

/// The strategy library under W is an anchor graph: ``NavigationInevitable``
/// and all of NiG N1–N19 are in force on ``SkillsAreBalls`` by substitution. A new class
/// routes greedily to its nearest certified skill. Gate failure emits an addressed
/// hole naming the missing skill, the skill curriculum (N17, one level up).
/// [Order O16]
public protocol StrategyNavigation: SkillsAreBalls, NavigationInevitable {}

/// Historical name for strategy and rule geometry interfaces. Their
/// shared metric does not imply equivalent learning or routing criteria.
/// Strategy transfer needs its own application contract. [Order O18]
public protocol FourthFace: OneBoundaryThreeFaces, SkillsAreBalls {}
