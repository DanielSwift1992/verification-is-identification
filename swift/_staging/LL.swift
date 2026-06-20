// ═══════════════════════════════════════════════════════
// Learning Is Liquid (LL) — paper LL
//
// Front (discriminator) + flow (generator),
// crystal/liquid dynamics, the gate as membrane.
// ═══════════════════════════════════════════════════════

/// LQ1: Liquid phase — partial saturation is a phase, not an incomplete crystal.
/// [B8a, B8b; B6-B7]
public protocol LL_LQ1_LiquidPhase: B_B8a_Primes, B_B8b_Horn, B_B6_CertifiedBasis, B_B7_BasisSaturation {}

/// LQ2: Domain geometry in liquid phase. [DiC G11, G12; NiG N11]
public protocol LL_LQ2_DomainGeometry: DiC_G11_Clustering, DiC_G12_CoveringNumbers, NiG_N11_TreeLikeness {}

/// LQ3: Crystallization front — monotone by I3, the front never recedes.
/// [I3; InI S6b; DiC §4; PiR §3]
public protocol LL_LQ3_Front: CachePermanent, InI_S6b_DynamicalMechanism {}

/// LQ4: Front dynamics — speed proportional to coverage. [LQ3; DiC G11; NiG N14]
public protocol LL_LQ4_FrontDynamics: LL_LQ3_Front, DiC_G11_Clustering, NiG_N14_ClusterGeometry {}

/// LQ5: Generator flow — laminar where α > 0, turbulent where rugged.
/// [GA1, GA3, GA6; DiC G13]
public protocol LL_LQ5_GeneratorFlow: GA_GA1_LossLandscape, GA_GA3_Alpha, GA_GA6_AlphaCondition, DiC_G13_LossOverW {}

/// LQ6: Flow measurement. [LQ5; GA P11]
public protocol LL_LQ6_FlowMeasurement: LL_LQ5_GeneratorFlow, GA_P11_Measurement {}

/// LQ7: Compositional flow from basis. [B1, B8d; PP17]
public protocol LL_LQ7_CompositionalFlow: B_B1_Composition, B_B8d_ReachClustering, PP_PP17_CanonicalEnsemble {}

/// LQ8: Coupled dynamics — front + flow. [LQ3, LQ5; InI S6c; DiC §4]
public protocol LL_LQ8_CoupledDynamics: LL_LQ3_Front, LL_LQ5_GeneratorFlow, InI_S6c_CoupledDynamics {}

/// LQ9: Front permanence — the crystal never melts. [I3; PiR §3; DiC G3; V=I §5.25]
public protocol LL_LQ9_FrontPermanence: CachePermanent, DiC_G3_Identity {}

/// LQ10: The full field — certified self-play with both dynamics.
/// [PP7, PP15; IiI §3; GA (laminar reach)]
public protocol LL_LQ10_FullField: PP_PP7_CertifiedVsStatistical, PP_PP15_SubstrateGrounding,
    LibrarySaturates, GA_GA6_AlphaCondition {}
