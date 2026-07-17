// ═══════════════════════════════════════════════════════════════
// Law Is Target (Dynamics).
//
// The framework demands a fixed target (I2); a moving state violates it,
// the series' explicit boundary since PiR M6. This paper removes the
// boundary by RELOCATING the target: the state is not the target, the law
// is. A finite deterministic transition law f is a structure in Σ;
// observed transitions are examples; identifying the law is an ordinary
// V=I game with every guarantee intact. Once the law is certified, motion
// becomes substrate: planning is navigation, goals are balls, behavior is
// structure, and the whole stack composes by substitution.
//
// Pure types (§0′). Dynamics is genuinely NEW content (the framework
// excluded it before), so this paper opens a new axis: the Law. [Dyn]
// ═══════════════════════════════════════════════════════════════

/// A finite deterministic environment carries a transition law f over finite
/// states and actions. The law is a new axis: the fixed thing about a moving
/// world. Being a structure is part of the law's identity (nothing else it could
/// be), so ``Pair`` is pinned inline (§2: cuts only the impossible). [Law LT1]
public protocol HasLaw: HasSigma {
    associatedtype Law: Pair
}

/// The transition law f is a finite function, hence a finite structure in Σ
/// (pinned at ``HasLaw``): it carries a norm ‖f‖ and a distance W between
/// dynamics. Environment transfer is measurable before it is attempted. (The law
/// is also ``Measurable`` (deterministic), but that is a relaxable premise, §6,
/// not part of its identity: stochastic laws exist, so it stays out of the inline
/// pin.) [Law LT2]
public protocol LawLivesInSigma: HasLaw, DistanceOnStructures {}

/// The law is the fixed target. The state is free to move. When the target is relocated
/// from state to law, identifying f becomes an ordinary V=I game: observed
/// transitions are examples, Theorems 1–5 apply unchanged (they not referenced
/// WHEN the examples arrive). The state violates I2. The law does not. This is
/// the central move of the paper. [Law LT3, LT4]
///
/// > Note: One relocation lifts the entire dynamics stack. ``PlanningIsNavigation``,
/// > ``AmbiguityIsExperiment``, and ``LawfulDrift`` all build on a target that
/// > holds still.
public protocol LawIsTarget: LawLivesInSigma, PassIsIdentification {}

/// Exploration is the `|S|>1` diagnostic read back as an experiment plan. The
/// ambiguity holds iff some `(s,a)` cell where survivors disagree is unobserved —
/// and the diagnostic names it: WHICH state to reach, WHICH action to try. The
/// dynamics-level instance of "the failure names its own cure". [Law LT5]
public protocol AmbiguityIsExperiment: LawIsTarget, HolesCarryAddresses {}

/// Behavior is a structure: a trajectory is a finite tree in Σ unfolding over
/// discrete ticks, carrying a norm ‖T‖ and a distance W(T₁,T₂). Behavioral
/// inertia, the cost of redirecting a plan mid-flight, is structural inertia at
/// the trajectory scale: ≥ W ticks, one distinction per tick. [Law LT7, LT8]
public protocol BehaviorIsStructure: DistanceOnStructures, HasTime {}

/// Planning is navigation. Under the certified ``LawIsTarget``, the state space
/// is a finite labeled graph, a goal is a ball B(g,r) under W, and planning is
/// greedy descent: the entire navigation stack applies by substitution. The
/// gradient toward the goal *is* the W-gradient, so no reward function is needed.
/// Traps are local minima, located and named, not promised absent.
/// [Law LT10-LT12]
///
/// > Note: Goals are balls and motion is descent, so dynamics inherits geometry
/// > for free. ``MotorSkillsAreStrategies`` then certifies a finished plan as a
/// > reusable strategy object.
public protocol PlanningIsNavigation: LawIsTarget, NavigationInevitable {}

/// A certified sub-plan (states, an action sequence, a guaranteed arrival
/// region) *is* a strategy object (OiO): certifiable by the strategy gate,
/// entering the library with norm and distance. Motor skills are balls in plan
/// space. Identification, navigation, strategy, and dynamics compose on shared
/// primitives with no new axioms. [Law LT13]
public protocol MotorSkillsAreStrategies: PlanningIsNavigation, SkillsAreBalls {}

/// Any task in a finite deterministic environment decomposes into IDENTIFY the
/// law (a V=I game) → PLAN (navigation, offline) → EXECUTE (prediction =
/// execution). Each stage is certified or returns an addressed failure that
/// re-enters with strictly more information. The loop is not silently wrong,
/// only explicitly incomplete, with the gap named. [Law LT14]
public protocol InteractiveDecomposition: AmbiguityIsExperiment, MotorSkillsAreStrategies {}

/// When the law itself drifts but lawfully (parameterized by a slow
/// deterministic variable), the META-law is the fixed target, and the whole
/// construction applies one level up: recursion, the framework's standing move.
/// A world is learnable iff it is lawful at some finite level. An unlawful world
/// reports `|S|>1` persisting, not a confident wrong answer. [Law LT15]
public protocol LawfulDrift: LawIsTarget, Tower {}

// ── the presented half of the axis. ``LawIsTarget`` reaches the law from
//    observations: examples arrive until one law survives. The four protocols
//    below reach the same fixed target from the author's side: the law is
//    WRITTEN — a finite transition table as a structure in Σ — and the judge
//    checks the written claims before any step is taken. Identification and
//    presentation meet at the same object; only the direction of travel
//    differs. Lived first as the rewrite-triple medium (a button over a state
//    file is a triple, pressed and judged), then lifted here. ──

/// The law can be presented instead of identified: its author writes the
/// finite transition table as a structure in Σ, whole, and the judge verifies
/// the written claims. The same fixed target ``LawIsTarget`` reaches from
/// examples, reached from the author's side: presentation is identification
/// with the search already spent. Carries norm and distance like any structure
/// in Σ, so presented laws are comparable before either is run. [DiS 1]
public protocol PresentedLaw: HasLaw, DistanceOnStructures {}

/// One step of a presented law fires iff its written pattern IS the state's
/// term: a comparison, not a search, `|S| ≤ 1` by the pattern's linearity. A
/// chord of steps over one slot with pairwise distinct patterns keeps the
/// bound — at most one leaf matches at any state — so a key of many meanings
/// is still an identification, never a priority. [DiS 2]
public protocol PressIsIdentification: PresentedLaw, PassIsIdentification {}

/// The judgement moves from states to edges: a step with a variable is a
/// universally quantified claim, checked once for every binding, so finitely
/// many checks cover every reachable trajectory by induction from a judged
/// start. Per-state testing never reaches this bound; the presented law's
/// whole behaviour is admitted before its first step. [DiS 5]
public protocol EdgesCarryTheJudgement: PresentedLaw, BehaviorIsStructure {}

/// The form is the invariant of a presented law: a step rewrites one slot's
/// term and nothing else, so the shape of the state — its slots, its keys —
/// never moves along any trajectory, and the difference between neighbouring
/// states lives inside one term. The invariant form is itself a structure. [DiS 4]
public protocol FormIsInvariant: PresentedLaw {
    associatedtype Form: Pair
}
