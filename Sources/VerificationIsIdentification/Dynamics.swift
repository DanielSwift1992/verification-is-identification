// ═══════════════════════════════════════════════════════════════
// Law Is Target (Dynamics).
//
// I2 requires a fixed target, and a moving state is not one (PiR M6). On
// supplied finite state and action carriers, a fixed transition law is a
// finite table in Σ. Under a fixed complete state/action interpretation it
// stays fixed while the represented state changes, so it can be that target.
// Sound observations constrain a declared candidate family. Identifying the
// actual law requires its membership and separating evidence in the same
// state/action reading. A fixed whole law need not descend to an autonomous
// local one. Applying the certificate requires its law, interpretation and
// evidence connections to hold. Plans and strategies compose under their
// own navigation, search, certification and execution premises.
// [Law LT1-LT4, LT8-LT13]
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
/// dynamics. W counts edits between supplied law encodings before transfer.
/// Reading it as transfer cost requires LT8's execution premises. (The law
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

/// With multiple distinct surviving tables, an unobserved state/action cell
/// distinguishes at least two candidates in the fixed reading. Its address
/// gives an experiment question. Reaching that state and obtaining a sound
/// observation depend on the experiment's actual actions, access and preparation.
/// ``LawIsTarget`` and ``HolesCarryAddresses`` join the interfaces, with
/// comparison and a witnessed cell address supplied by the application.
/// [Law LT4–LT6]
public protocol AmbiguityIsExperiment: LawIsTarget, HolesCarryAddresses {}

/// A finite encoded trajectory has a norm and edit distance. Its edit count
/// bounds ticks only under a one-edit-per-tick interface. Compatible rounds
/// have a different count in G14a. This intersection does not determine
/// execution time or the cost of redirecting an actual process. [Law LT7–LT8]
public protocol BehaviorIsStructure: DistanceOnStructures, HasTime {}

/// Planning uses the supplied finite state graph under certified ``LawIsTarget``.
/// A goal is a ball B(g,r) under W. A greedy plan descends W without an added
/// reward function. LT12 applies navigation results with the access, routing
/// and retention premises used by each result.
/// Traps are local minima, located and named, not promised absent.
/// [Law LT10-LT12]
///
/// > Note: ``MotorSkillsAreStrategies`` treats a certified sub-plan as a
/// > strategy object. Finding and applying it for a new class retains the
/// > search, certification and execution premises of LT13 and LT8-LT9.
public protocol PlanningIsNavigation: LawIsTarget, NavigationInevitable {}

/// A certified sub-plan has a state region, an action sequence and an arrival
/// guarantee under the certified law. Its finite decision-tree encoding can
/// be certified by the strategy gate and stored with norm and distance under
/// Order's own premises. A ball in plan space can represent a family of motor
/// skills. Applying a strategy to a new class also requires the search,
/// certification and execution premises. These results compose on shared
/// primitives, with no new axioms, under those premises. ``PlanningIsNavigation`` and
/// ``SkillsAreBalls`` join the interfaces, with state/action bindings and
/// execution supplied by the application. [Law LT8–LT9, LT13] [Order O5, O15]
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
