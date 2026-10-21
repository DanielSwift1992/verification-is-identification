import Notation

// ═══════════════════════════════════════════════════════════════
// The Architecture of Learning Machines (Projection).
//
// A projection asks what a generator, verifier and store actually guarantee.
// Soundness, completeness, retention, proposal coverage and cost are
// separate premises. Decidability alone proves neither checker soundness
// nor acceptance of every correct proposal.
//
// AI6 preserves correct-hit events only over the same processed proposals
// with a complete checking interface. Trial probability needs its own law.
// A time budget can admit fewer proposals after checking is added.
//
// These pure type intersections expose declared coordinates. They do not
// establish every premise of an implemented learning architecture.
//
// ═══════════════════════════════════════════════════════════════

/// A declared self-play relation beside a gate/membrane relation.
/// ``PlayIsProof`` and ``GateIsMembrane`` supply their type constraints.
/// The intersection is not an iff classification of learning systems.
/// Reproducibility, soundness, coverage and accessible memory have separate
/// semantic and operational premises. [Projection AI1, AI6]
///
/// > Note: Missing this declaration does not establish hallucination,
/// > forgetting or inability to abstain in a real system. Those properties
/// > must be checked for its actual implementation and task scope.
///
///
public protocol AllCoordinatesPresent: PlayIsProof, GateIsMembrane {}

/// Generator/discriminator coordinates beside a gate/membrane relation.
/// ``DiscriminatorAndGenerator`` and ``GateIsMembrane`` do not encode
/// accepted/correct-set inclusion, a proposal law or a retaining update.
/// A sound implemented checker filters scoped outputs. Preserving coverage
/// needs completeness and the same processed proposals. Comparing budgets
/// additionally counts checking cost. [Projection AI6]
///
public protocol GateWrapper: DiscriminatorAndGenerator, GateIsMembrane {}

/// A declared gate/membrane relation beside a measured-geometry axis.
/// ``GateIsMembrane`` and ``MeasuredGeometry`` specify coordinates, not an
/// evaluation run. A current coverage sample differs from a historical
/// retaining ledger. Fixed tasks, checking scope and a terminating budget
/// are required to compare either measurement. [Projection AI7]
///
public protocol SaturationMap: GateIsMembrane, MeasuredGeometry {}

// ───────────────────────────────────────────────────────────────
// AI2–AI5 classify inspection questions, not universal architecture facts.
// A neural proposal component may be composed with formal checking.
// Reinforcement learning may use formally checked outcomes.
// A retained record still needs provenance, interpretation and scope.
//
// Examples/LearningMachines.swift contains illustrative declarations.
// Its historical CertifiedSelfPlay name uses uninhabited Never axes.
// That conformance does not run a learner or certify its performance.
// The toy LanguageModel coordinate is chosen in the example. Its missing
// conformance proves no impossibility about actual language models.
//
// Checks/gate_wrapper.py verifies AI6/AI7 finite cases and a closed
// proposal-tape model with an explicit bounded recording window.
//
// ───────────────────────────────────────────────────────────────
