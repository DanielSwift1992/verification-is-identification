// ═══════════════════════════════════════════════════════
// Permanence Is Resistance (PiR) — paper 3
//
// Crystallized output: permanent, irreducible, resistant.
// Tower of levels, cost structure, matter from verification.
// ═══════════════════════════════════════════════════════

// ── Time ──

/// M1: Discrete time — clock = sequence of COMPAREs. [PiR M1; V=I I1, Thm3]
/// RULE: intersect (StructuresFinite ∩ ComparisonsAreBounded) — finite + bounded COMPAREs = discrete clock
public protocol ClockIsCompareSequence: StructuresFinite, ComparisonsAreBounded {}

/// M3: External time independence + agent equivalence. [PiR M3; M1, §5.8]
/// RULE: intersect (ClockIsCompareSequence ∩ ResultDeterministic)
public protocol AgentsTimeIndependent: ClockIsCompareSequence, ResultDeterministic {}

// ── Ignition ──

/// M6: Unstable target — before saturation, L violates I2. [PiR M6; I2, IiI §3]
/// RULE: intersect (OperationsClosed ∩ LibrarySaturates)
public protocol TargetUnstableBeforeSaturation: OperationsClosed, LibrarySaturates {}

/// M7: Stable target — after saturation, L is permanent + complete + irreducible. [PiR M7; I3, Thm2, IiI §3]
/// RULE: intersect (CachePermanent ∩ PassIsIdentification ∩ LibrarySaturates)
public protocol TargetStableAfterSaturation: CachePermanent, PassIsIdentification, LibrarySaturates {}

/// M8: Ignition — discrete transition at |L_N| = K_N. [PiR M8; M6, M7]
/// RULE: intersect (TargetUnstableBeforeSaturation ∩ TargetStableAfterSaturation)
public protocol SaturationIgnites: TargetUnstableBeforeSaturation, TargetStableAfterSaturation {}

/// M10: Crystal as target — L_N becomes V=I target at level N+1. [PiR M10; M8, I2]
/// RULE: intersect (SaturationIgnites ∩ OperationsClosed) — ignition + closure = crystal IS a target
public protocol CrystalBecomesTarget: SaturationIgnites, OperationsClosed {}

// ── Exhaustion and Form ──

/// M11: Information exhaustion — bounded COMPAREs, rate → 0. [PiR M11; I1, Thm3]
/// RULE: intersect (StructuresFinite ∩ ComparisonsAreBounded) — finite space + bounded COMPAREs = exhaustion
public protocol InformationExhausts: StructuresFinite, ComparisonsAreBounded {}

/// M12: Convergence — every game on finite Σ converges to (L*, G*). [PiR M12; M11, I3]
/// RULE: intersect (InformationExhausts ∩ CachePermanent)
public protocol GameConverges: InformationExhausts, CachePermanent {}

/// M13: Emergent properties — saturated L has coverage, compression, grammar absent from any f*.
/// [PiR M13; M12, IiI §3]
/// RULE: intersect (GameConverges ∩ LibrarySaturates)
public protocol EmergentFromSaturation: GameConverges, LibrarySaturates {}

/// M15: Predictable successor — given L_N, next level's parameters are determined.
/// [PiR M15; M10, M13]
/// RULE: intersect (CrystalBecomesTarget ∩ EmergentFromSaturation)
public protocol NextLevelPredictable: CrystalBecomesTarget, EmergentFromSaturation {}

/// M16: Tower termination — terminates at K_M ≤ 1 if compression at every level.
/// [PiR M16; M15, I1]
/// RULE: intersect (NextLevelPredictable ∩ StructuresFinite)
public protocol TowerTerminates: NextLevelPredictable, StructuresFinite {}

// ── Protocol ──

/// M18: Crystal as protocol — L is a fixed sequence of COMPAREs. [PiR M18; M7, I3]
/// RULE: intersect (TargetStableAfterSaturation ∩ CachePermanent)
public protocol CrystalIsProtocol: TargetStableAfterSaturation, CachePermanent {}

/// M19: Active existence — L participates through COMPARE only. [PiR M19; V=I §2.5, I3]
/// RULE: intersect (CachePermanent ∩ OperationsClosed) — permanent cache + closed ops = existence via COMPARE
public protocol ExistenceThroughCompare: CachePermanent, OperationsClosed {}

/// M21: Existence guarantee — no operation removes a structure from Σ or cache. [PiR M21; I3, I1]
/// RULE: intersect (CachePermanent ∩ StructuresFinite)
public protocol NothingRemoved: CachePermanent, StructuresFinite {}

/// M22: Finite work, permanent result. [PiR M22; M11, M21]
/// RULE: intersect (InformationExhausts ∩ NothingRemoved)
public protocol WorkFiniteResultPermanent: InformationExhausts, NothingRemoved {}

/// M23: Cumulative capacity — L grows monotonically across domains. [PiR M23; I3, IiI §2]
/// RULE: intersect (CachePermanent ∩ KnowledgeAccumulates)
public protocol CapacityCumulative: CachePermanent, KnowledgeAccumulates {}

// ── Cost ──

/// M24: Cost of permanence — each recorded distinction is irreversible. [PiR M24; I3, M22]
/// RULE: intersect (WorkFiniteResultPermanent ∩ CachePermanent)
public protocol PermanenceHasCost: WorkFiniteResultPermanent, CachePermanent {}

/// M26: Resistance bound — total resistance per game is finite. [PiR M26; M11, §5.22]
/// RULE: intersect (InformationExhausts ∩ CandidatesOnlyLeave)
public protocol ResistanceBounded: InformationExhausts, CandidatesOnlyLeave {}

/// M27: Cost transformation — crystallization converts dynamic resistance into static permanence.
/// [PiR M27; M24, M7, M26]
/// RULE: intersect (PermanenceHasCost ∩ TargetStableAfterSaturation ∩ ResistanceBounded)
public protocol ResistanceBecomesPermanence: PermanenceHasCost,
    TargetStableAfterSaturation, ResistanceBounded {}
