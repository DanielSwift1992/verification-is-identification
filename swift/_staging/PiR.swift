// ═══════════════════════════════════════════════════════
// Permanence Is Resistance (PiR) — paper 3
//
// Crystallized output: permanent, irreducible, resistant.
// Tower of levels, cost structure, matter from verification.
// ═══════════════════════════════════════════════════════

// ── Time ──

/// M1: Discrete time — clock = sequence of COMPAREs. [I1; V=I §2.4]
public protocol PiR_M1_DiscreteTime: StructuresFinite {}

/// M2-M3: External time independence + agent equivalence.
/// [M1; V=I §5.8]
public protocol PiR_M3_AgentEquivalence: PiR_M1_DiscreteTime, ResultDeterministic {}

// ── Ignition ──

/// M6: Unstable target — before saturation, L violates I2.
/// [I2; IiI Saturation]
public protocol PiR_M6_UnstableTarget: OperationsClosed, LibrarySaturates {}

/// M7: Stable target — after saturation, L is permanent + complete + irreducible.
/// [I3; Thm2; IiI Saturation]
public protocol PiR_M7_StableTarget: CachePermanent, PassIsIdentification, LibrarySaturates {}

/// M8: Ignition — discrete transition at |L_N| = K_N. [M6; M7]
public protocol PiR_M8_Ignition: PiR_M6_UnstableTarget, PiR_M7_StableTarget {}

/// M10: Crystal as target — L_N becomes V=I target at level N+1. [M8; I2]
public protocol PiR_M10_CrystalAsTarget: PiR_M8_Ignition {}

// ── Exhaustion and Form ──

/// M11: Information exhaustion — bounded COMPAREs, rate → 0. [I1]
public protocol PiR_M11_InfoExhaustion: StructuresFinite {}

/// M12: Convergence — every game on finite Σ converges to (L*, G*). [M11; I1; I3]
public protocol PiR_M12_Convergence: PiR_M11_InfoExhaustion, CachePermanent {}

/// M13: Emergent properties — saturated L has coverage, compression, grammar absent from any f*.
/// [M12; IiI Saturation]
public protocol PiR_M13_EmergentProperties: PiR_M12_Convergence, LibrarySaturates {}

/// M15: Predictable successor — given L_N, next level's parameters are determined.
/// [M10; M13]
public protocol PiR_M15_PredictableSuccessor: PiR_M10_CrystalAsTarget, PiR_M13_EmergentProperties {}

/// M16: Tower termination — terminates at K_M ≤ 1 if compression at every level.
/// [M15; I1]
public protocol PiR_M16_TowerTermination: PiR_M15_PredictableSuccessor, StructuresFinite {}

// ── Protocol ──

/// M18: Crystal as protocol — L is a fixed sequence of COMPAREs. [M7; I3]
public protocol PiR_M18_CrystalAsProtocol: PiR_M7_StableTarget {}

/// M19: Active existence — L participates through COMPARE only. [V=I §2.5; I3]
public protocol PiR_M19_ActiveExistence: CachePermanent {}

/// M21: Existence guarantee — no operation removes a structure from Σ or cache. [I3]
public protocol PiR_M21_ExistenceGuarantee: CachePermanent {}

/// M22: Finite work, permanent result. [M11; M21]
public protocol PiR_M22_FiniteWorkPermanentResult: PiR_M11_InfoExhaustion, PiR_M21_ExistenceGuarantee {}

/// M23: Cumulative capacity — L grows monotonically across domains. [I3; IiI §1]
public protocol PiR_M23_CumulativeCapacity: CachePermanent, KnowledgeAccumulates {}

// ── Cost ──

/// M24: Cost of permanence — each recorded distinction is irreversible. [I3; M22]
public protocol PiR_M24_CostOfPermanence: PiR_M22_FiniteWorkPermanentResult {}

/// M26: Resistance bound — total resistance per game is finite. [M11; S5_22]
public protocol PiR_M26_ResistanceBound: PiR_M11_InfoExhaustion, CandidatesOnlyLeave {}

/// M27: Cost transformation — crystallization converts dynamic resistance into static permanence.
/// [M24; M7; M26]
public protocol PiR_M27_CostTransformation: PiR_M24_CostOfPermanence,
    PiR_M7_StableTarget, PiR_M26_ResistanceBound {}
