// ═══════════════════════════════════════════════════════════════
// Order Is Object (Strategy).
//
// V=I proved the agent's sole freedom is the order of COMPAREs (§5.25), and
// that order carries zero identification bits at its level (pure
// phase). IiI noted strategy state is mutable: a caveat. This paper
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
/// the order, the sole free parameter (``OrderIsOnlyFreedom``, §5.25), has a
/// norm ‖σ‖ and a distance W. Strategy geometry is inherited from
/// ``DistanceOnStructures``, not constructed, the moment the order enters Σ.
/// [Order O1, O2]
public protocol StrategyLivesInSigma: DistanceOnStructures, OrderIsOnlyFreedom {}

/// The strategy gate certifies an efficiency claim (PASS ∧ cost ≤ c) ON TOP OF
/// unconditional safety. Because ``StrategyLivesInSigma`` only reorders COMPAREs,
/// no strategy can produce a wrong PASS, two gates: ``PassImpliesMembership``
/// answers "is it right", the strategy gate "is it fast". A failed strategy costs
/// budget, never correctness. [Order O5, O6]
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

/// The ordering carries zero identification bits at its level (InI S2, the
/// Y-axis, pure phase) yet is the ENTIRE identified content one level up: the
/// strategy game's target is σ*. Once ``StrategyCrystallizes``, the strategy gate
/// becomes a ``PassIsIdentification``, the Y-axis of level N is the Z-axis of
/// level N+1. Phase becomes amplitude. [Order O10]
///
/// > Note: What is free phase below is identified content above, the same order,
/// > read one level up, becomes the very thing the gate certifies.
public protocol PhaseBecomesAmplitude: StrategyCrystallizes, PassIsIdentification {}

/// After rule and strategy saturation, a ``HasLibrary`` entry is the triple
/// (f*, E, σ*): WHAT the answer is, THROUGH WHICH lens (``HasEncoding``), HOW to
/// reach it fastest. Once ``PhaseBecomesAmplitude``, the object contains its
/// path: certified WHAT (Thm 2), supplied lens (R4), certified HOW (the strategy gate).
/// [Order O12]
public protocol CompleteEntry: PhaseBecomesAmplitude, HasEncoding, HasLibrary {}

/// A skill is formally a ball in strategy space: one strategy family covering
/// many rule classes, per-class adjustment bounded by r. ``BallSaturation`` over
/// ``StrategyLivesInSigma`` puts skills exactly where the strategy W-matrix is
/// compressible. A flat strategy matrix has no skills (per-class memoization).
/// [Order O15]
public protocol SkillsAreBalls: StrategyLivesInSigma, BallSaturation {}

/// The strategy library under W is an anchor graph: ``NavigationInevitable``
/// and all of NiG N1–N19 are in force on ``SkillsAreBalls`` by substitution. A new class
/// routes greedily to its nearest certified skill. Gate failure emits an addressed
/// hole naming the missing skill, the skill curriculum (N17, one level up).
/// [Order O16]
public protocol StrategyNavigation: SkillsAreBalls, NavigationInevitable {}

/// Strategy compressibility is the FOURTH face of the ``OneBoundaryThreeFaces``
/// boundary: learning, generalization, and navigation gain a sibling. Even when
/// everything transfers at the WHAT level, nothing transfers at the HOW level
/// unless the strategy matrix (``SkillsAreBalls``) clusters too. Cluster at both
/// levels → skills that route. [Order O18]
///
/// > Tip: Transfer at the WHAT level does not imply transfer at the HOW level, the
/// > strategy matrix has its clustering, and skills route only where that
/// > clustering is present.
public protocol FourthFace: OneBoundaryThreeFaces, SkillsAreBalls {}
