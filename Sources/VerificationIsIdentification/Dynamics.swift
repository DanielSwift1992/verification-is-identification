// ═══════════════════════════════════════════════════════════════
// Law Is Target (Dynamics).
//
// The framework demands a fixed target (I2), and a moving state violates it,
// the series' explicit boundary since PiR M6. This paper removes the
// boundary by RELOCATING the target: the state is not the target, the law
// is. A finite deterministic transition law f is a structure in Σ.
// Observed transitions are examples, and identifying the law is an ordinary
// V=I game with every guarantee intact. Once the law is certified, motion
// becomes substrate: planning is navigation, goals are balls, behavior is
// structure, and the whole stack composes by substitution.
//
// Pure types (§0′). Dynamics is genuinely NEW content (the framework
// excluded it before), so this paper opens a new axis: the Law. [Dyn]
// ═══════════════════════════════════════════════════════════════

/// A finite deterministic environment has a transition law f over finite
/// states and actions. The law is a new axis: the fixed thing about a moving
/// world. Being a structure is part of the law's identity (nothing else it could
/// be), so ``Pair`` is pinned inline (§2: cuts only the impossible). [Law LT1]
public protocol HasLaw: HasSigma {
    associatedtype Law: Pair
}

/// The transition law f is a finite function, hence a finite structure in Σ
/// (pinned at ``HasLaw``): it has a norm ‖f‖ and a distance W between
/// dynamics. Environment transfer is measurable before any attempt. (The law
/// is also ``Measurable`` (deterministic), but that is a relaxable premise, §6,
/// not part of its identity: stochastic laws exist, so it is outside the inline
/// pin.) [Law LT2]
///
/// The same intersection is the presented law. Its author can write the finite
/// transition table as a structure in Σ, whole, and the judge verifies the written
/// claims. Presentation reaches the target of ``LawIsTarget`` from the author's
/// side: identification with the search already spent. The written table has norm
/// and distance like any structure in Σ, so presented laws are comparable before
/// any step. [DiS 1]
public protocol LawLivesInSigma: HasLaw, DistanceOnStructures {}

/// A fixed law on an adequate state/action representation can be the target
/// while states change. Identification still requires a declared family
/// containing the actual law and evidence that separates it. A fixed whole
/// law need not descend to an autonomous local one. [Law LT3–LT4, Matter M70]
///
/// The same intersection is the press of a presented law. One step fires iff its
/// written pattern IS the state's term: a comparison, not a search, `|S| ≤ 1` by
/// the pattern's linearity. A chord of steps over one slot with pairwise distinct
/// patterns keeps the bound: at most one leaf matches at any state, so a key of
/// many meanings is still an identification, never a priority. [DiS 2]
///
/// > Note: ``PlanningIsNavigation``, ``AmbiguityIsExperiment`` and
/// > ``LawfulDrift`` retain their own acquisition and availability premises.
public protocol LawIsTarget: LawLivesInSigma, PassIsIdentification {}

/// Exploration is the `|S|>1` diagnostic read back as an experiment plan. The
/// ambiguity is present iff some `(s,a)` cell where survivors differ is unobserved,
/// and the diagnostic names it: WHICH state to reach, WHICH action to try. The
/// dynamics-level instance of "the failure names its own cure". [Law LT5]
public protocol AmbiguityIsExperiment: LawIsTarget, HolesCarryAddresses {}

/// A finite encoded trajectory has a norm and edit distance. Its edit count
/// bounds ticks only under a one-edit-per-tick interface. Compatible rounds
/// have a different count in G14a. This intersection does not determine
/// execution time or the cost of redirecting an actual process. [Law LT7–LT8]
public protocol BehaviorIsStructure: DistanceOnStructures, HasTime {}

/// Planning is navigation. Under the certified ``LawIsTarget``, the state space
/// is a finite labeled graph, a goal is a ball B(g,r) under W, and planning is
/// greedy descent: the entire navigation stack is in force, by substitution. The
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

/// Identify, plan and execute form one sufficient route under the actual
/// acquisition, model and navigation premises. A contradicted prediction can
/// refute the candidate family or its continued interpretation. This
/// intersection alone does not detect every such failure. [Law LT14]
public protocol InteractiveDecomposition: AmbiguityIsExperiment, MotorSkillsAreStrategies {}

/// A changing local rule can have a fixed law on a larger internal state.
/// That larger law can be a target under its own model and access premises.
/// A fixed finite level alone supplies neither a bounded candidate family nor
/// attainable distinguishing evidence. This open intersection does not prove
/// that a learner can reach or identify such a level. [Law LT15, Matter M70]
public protocol LawfulDrift: LawIsTarget, Tower {}
