// ═══════════════════════════════════════════════════════════════
// The Architecture of Learning Machines (Projection).
//
// PiR §5 projects the framework onto physical systems. This is the same
// move on LEARNING MACHINES. A learning system is an instance of the
// framework located by which COORDINATES it has — gate (decidable
// verifier), I3 (append-only record), basis (certified vs pseudo), organ
// (generator/discriminator), phase (liquid/crystal), α (alignment). The
// theorems are conditional: each guarantee holds exactly when its
// coordinate is present (AI1). An LLM has no gate (→ hallucination), no I3
// (→ forgetting), an uncertified basis — yet α>0, so it astonishes. The
// instance with all coordinates present is the framework's own shape:
// certified self-play. The projection derives, never assesses.
//
// Pure types (§0′). The coordinate system, applied to machines. [Projection]
// ═══════════════════════════════════════════════════════════════

/// The framework's guarantees ARE coordinates. Each holds exactly when its
/// coordinate is present. A system can CERTIFY iff it has a ``GateIsMembrane``
/// gate (Theorem 2), does NOT FORGET iff it has I3 (else §5.22 breaks), is
/// REPRODUCIBLE iff gate+I3 (SAT5/6), has IRREDUCIBLE transferable knowledge iff
/// its basis is certified (B). A missing coordinate removes exactly its
/// guarantee. The instance with ALL coordinates present is the framework's own
/// shape — certified self-play (``PlayIsProof``). [Projection AI1, AI6]
///
/// > Note: This is a coordinate system, not a scorecard. Locate any learning
/// > machine by which coordinates it has. The theorems it earns and the failures
/// > it suffers both fall out of that placement.
public protocol AllCoordinatesPresent: PlayIsProof, GateIsMembrane {}

/// Wrap any generator with a ``GateIsMembrane`` gate and an append-only store and
/// it gains three guarantees: (i) never emits a wrong answer (0 false positives,
/// Theorem 2), (ii) preserves the generator's coverage (errors filtered, reach
/// untouched), (iii) monotonically accumulates (I3, the crystal only grows). A
/// better ``DiscriminatorAndGenerator`` generator moves coverage. The gate moves
/// correctness, orthogonal (GD3). Not a new learner, a wrapper: the AlphaProof
/// shape, generalized. [Projection AI6]
public protocol GateWrapper: DiscriminatorAndGenerator, GateIsMembrane {}

/// A ``GateIsMembrane`` gate maps any system's CRYSTAL (the tasks it passes)
/// against its LIQUID (the rest): certified-here / uncertain-there. The crystal
/// fraction is the system's effective saturation: a measurable scalar
/// (``MeasuredGeometry``), comparable across systems, monotone under improvement
/// (I3). The system need not be modified. The gate is external. The ledger
/// machinery (E2) projected onto any box. [Projection AI7]
public protocol SaturationMap: GateIsMembrane, MeasuredGeometry {}

// ───────────────────────────────────────────────────────────────
// AI2–AI5 — the projection table, recorded. (Domains/LearningMachines.swift
// makes the gate live: a machine WITH the coordinates conforms; an LLM
// WITHOUT them is rejected by the compiler, which names the missing one.)
//
//   tablebase       gate ✓ I3 ✓ basis(r=0) → exact, never wrong; doesn't scale
//   LLM             gate ✗ I3 ✗ pseudo, generator, pure liquid → hallucinate,
//                   forget, irreproducible — yet strong where α>0 (AI2, AI4)
//   reinforcement   reward ≠ gate → label is an estimate, seed-dependent (AI3)
//   AlphaProof      gate ✓ (checker) generator+gate → the framework's shape
//   certified play  all coordinates → exact where gated, honest silence where not
//
// AI5: every system is a front-and-flow configuration (Liquid). The LLM is flow
// without a front (no I3 → nothing freezes): its power (flows anywhere) and its
// fragility (solidifies nowhere) are one fact.
// ───────────────────────────────────────────────────────────────
