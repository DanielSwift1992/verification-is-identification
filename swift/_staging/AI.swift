// ═══════════════════════════════════════════════════════
// Architecture of Learning Machines (AI) — paper AI
//
// Projection: the framework's coordinates applied
// to any learning system. The top of the dependency DAG.
// ═══════════════════════════════════════════════════════

/// AI1: Guarantees are coordinates. Each property present exactly when its coordinate is.
/// [V=I Thm2, §5.22, SAT5/6, outcome corollary; IiI §3; B]
public protocol AI_AI1_GuaranteesAreCoordinates: PassIsIdentification, CandidatesOnlyLeave,
    LibrarySaturates, B_B6_CertifiedBasis {}

/// AI2: Projection onto LLM — pure liquid, no gate, no I3.
/// [AI1; IiI §3]
public protocol AI_AI2_LLMProjection: AI_AI1_GuaranteesAreCoordinates {}

/// AI3: Projection onto reinforcement self-play — proof traded for estimate.
/// [PP7; AI1]
public protocol AI_AI3_ReinforcementProjection: PP_PP7_CertifiedVsStatistical, AI_AI1_GuaranteesAreCoordinates {}

/// AI4: Generator without certification — success conditional on α.
/// [GA6; GD3/GA7; AI1]
public protocol AI_AI4_ConditionalSuccess: GA_GA6_AlphaCondition, GD_GD3_Orthogonality, AI_AI1_GuaranteesAreCoordinates {}

/// AI5: Every system in the liquid/crystal field with front and flow.
/// [LL LQ3, LQ5, LQ10]
public protocol AI_AI5_FrontAndFlow: LL_LQ3_Front, LL_LQ5_GeneratorFlow, LL_LQ10_FullField {}

/// AI6: Full machine — gate + I3 + certified basis = framework's own shape.
/// [V=I Thm2, I3, §5.25; PP7; GD3; LQ9; AI1]
public protocol AI_AI6_FullMachine: PassIsIdentification, CachePermanent,
    PP_PP7_CertifiedVsStatistical, GD_GD3_Orthogonality,
    LL_LQ9_FrontPermanence, AI_AI1_GuaranteesAreCoordinates {}

/// AI7: Saturation map — gate maps crystal vs liquid, measurable today.
/// [V=I §3.7, Thm2; I3; E2 C4a/ledger; LL crystal/liquid]
public protocol AI_AI7_SaturationMap: PassIsIdentification, CachePermanent, LL_LQ3_Front {}
