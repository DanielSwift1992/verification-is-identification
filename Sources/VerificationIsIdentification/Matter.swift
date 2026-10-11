// ═══════════════════════════════════════════════════════════════
// Permanence Is Resistance (Matter).
//
// A formal intersection of retained knowledge, unique answer and resistance.
// Retention requires the declared update; a unique decoded answer need not
// have a shortest or irreducible encoding. Structural consequences constrain
// every realization of their premises, including actual internal interactions.
// Concrete witnesses check selected structural relations under their premises.
// The prose separates these obligations rather than deriving them from names.
//
// Plus: the tower (each crystal is the next level's matter), discrete
// time, ignition, no-inverse (M21), convergence (M12), finite discovery.
// Pure types (§0′). Every claim ties to the existing lattice.
// ═══════════════════════════════════════════════════════════════

// ── New axes this paper introduces ──

/// An integer-valued operation-count coordinate over ``HasSigma``. The axis
/// does not exclude continuous physical time or certify execution of a clock.
/// Counting and physical duration need separate models. A counter that
/// distinguishes complete returns must carry a state difference of its own.
/// Retention at an address alone does not construct a strict order. [Matter M55]
/// Proper inclusion orders actual cuts even when infinite cuts have the same
/// abstract pattern. Their retention correspondence must remain specified.
/// A faithful continuation preserves each witnessed occurrence distinction.
/// The count does not impose a universal present on the whole. Event
/// dependencies and a traversal's list positions have different roles. [Matter M67]
/// Exact recoveries around a closed chain derive reverse recoveries on its
/// images. Such a chain cannot also contain a witnessed strict gain. [Matter M55]
/// [Matter M1, M51]
public protocol HasTime: HasSigma {
    associatedtype Time: IntegerValued
}

/// Cost is a discrete implementation count. A conversion to physical energy
/// needs explicit resource assumptions beyond this axis. [Matter M24]
public protocol HasCost: HasSigma {
    associatedtype Cost: IntegerValued
}

// ── §1 Resistance ──

/// Resistance is a *relation*, not a property of the target: it needs both the
/// invariant and the form that fails to match it. Realized at COMPARE
/// (``Decidable``) as the `not_equal` verdict, measured as distance
/// (``HasDistance``) from the invariant. [Matter §1]
public protocol Resistant: HasDistance, Decidable {}

// ── §2 Matter ──

/// The formal intersection chosen for a retained result that constrains a
/// later comparison. ``KnowledgeAccumulates`` supplies an accumulation axis.
/// ``PassIsIdentification`` supplies the identification relation. ``Resistant``
/// supplies comparison and distance interfaces. [Matter §2]
///
/// The paper's §2a states how a retained distinction constrains every
/// compatible realization. A unique answer can be forced while its carrier
/// and construction remain non-unique. Actual records and their referents
/// are distinguished within the same whole, without an external substrate.
/// M71 carries a witnessed obstruction through every enlargement preserving
/// its addressed premises. It needs no census of the rest of the whole.
/// Retaining a source alone still leaves an unconstrained new answer free.
/// M72 works backward from established recovery: every complete intervening
/// contact boundary must preserve the recovered question. A chronological
/// slice need not supply that complete boundary or a ready local decoder.
///
/// A unique decoded answer need not have a shortest representation. These
/// inherited interfaces do not by themselves implement storage or prove
/// physical permanence, representation minimality or a later agent's behavior.
///
/// **Premises**: ``KnowledgeAccumulates`` (accumulation) · ``PassIsIdentification`` (kernel) · ``Resistant`` (geometry).
public protocol Matter: KnowledgeAccumulates, PassIsIdentification, Resistant {}

// ── §4 No-inverse: the load-bearing guarantee ──

/// The library carries a structural retention witness. This constrains its
/// record relation, not invertibility of the complete physical whole. Access
/// and lifetime require the declared update premises. [Matter M21, M36–M37]
public protocol NoInverse: KnowledgeAccumulates
where Library: Permanent {}

// ── §4 Convergence ──

/// Interfaces for crystallization and retention. Finite inclusion-monotone
/// records eventually stabilize when the finite-record premises apply. This
/// neither guarantees coverage nor makes the whole state stationary. The
/// actual update and time bound need their own witnesses. [Matter M12]
public protocol Converges: SystemCrystallizes, NoInverse {}

// ── §4 Ignition ──

/// A chosen handoff interface combining saturation and matter. It does not
/// execute a successor game or prove saturation necessary for targethood:
/// an immutable partial snapshot can also be a target. [Matter M8]
public protocol Ignites: LibrarySaturates, Matter {}

// ── §4 The Tower ──

/// An interface for a supplied tower with an integer-valued level coordinate.
/// ``Ignites``, ``HasTime`` and ``HasCost`` do not synthesize its transitions.
/// Termination needs a finite height or strict rank descent with a stopping
/// rule. Finite individual games alone do not imply it. [Matter §4]
public protocol Tower: Ignites, HasTime, HasCost {
    associatedtype Levels: IntegerValued
}

// ── §4 Finite discovery ──

/// Formal tower and comparison premises for discovery. Physical expenditure
/// additionally needs finite upper operation costs and overhead, which this
/// protocol does not encode or certify. [Matter M28]
public protocol FiniteDiscovery: Tower, ComparisonsAreBounded {}
