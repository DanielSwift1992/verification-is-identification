// ═══════════════════════════════════════════════════════
// Play Is Proof (PP) — paper 10
//
// Self-play, substrate, certified vs statistical,
// three grounds, the generator's wager.
// ═══════════════════════════════════════════════════════

/// PP0: Self-play premise — IiI + phase transition. [IiI §3, §6; E2 §4]
public protocol PP_PP0_Premise: LibrarySaturates, SaturationDynamics {}

/// PP1: The loop as self-play. [Thm2; V=I §4.8, §5.5]
public protocol PP_PP1_LoopAsSelfPlay: PassIsIdentification {}

/// PP2: Poser/solver — the two roles. [PP1; V=I §2.1, §3.5, §4.7, Thm2]
public protocol PP_PP2_PoserSolver: PP_PP1_LoopAsSelfPlay {}

/// PP3: Partial results — incomplete solves are informative. [PP2; LiT LT5; V=I §3.6, §5.22]
public protocol PP_PP3_PartialResults: PP_PP2_PoserSolver, CandidatesOnlyLeave {}

/// PP4: Partial + confusion cover. [PP3; InI S5b]
public protocol PP_PP4_PartialConfusion: PP_PP3_PartialResults, InI_S5b_ConfusionCover {}

/// PP5: Library as certified self-play record. [PP2; IiI §1, §3, §6; I3]
public protocol PP_PP5_CertifiedRecord: PP_PP2_PoserSolver, AgentPathCertified, LibrarySaturates, CachePermanent {}

/// PP5c: On infinite closure, sampling is incorrect → directedness necessary.
/// [PP5; B8b, B8d; DiC G8; IiI §6]
public protocol PP_PP5c_DirectednessNecessary: PP_PP5_CertifiedRecord, B_B8b_Horn, B_B8d_ReachClustering, DiC_G8_ProgramMetric {}

/// PP6: The basis endpoint. [Thm2; I3; V=I §5.25; SAT5/6]
public protocol PP_PP6_BasisEndpoint: PassIsIdentification, CachePermanent {}

/// PP7: Certified vs statistical — the contrast. [PP5, PP6; I3; V=I §5.22, Thm2]
public protocol PP_PP7_CertifiedVsStatistical: PP_PP5_CertifiedRecord, PP_PP6_BasisEndpoint, CandidatesOnlyLeave {}

/// PP8: Encoding invariance. [V=I §5.4, §5.24]
public protocol PP_PP8_EncodingInvariance: ScopeBoundedByEncoding {}

/// PP10: Game graph — V=I on games as structures. [V=I §2.3; DiC; PiR M12; InI S6a]
public protocol PP_PP10_GameGraph: DiC_G14_SearchCost, InI_S6a_ComputableOrdering {}

/// PP11: Library reuse — past solves accelerate new ones. [PP2; I3; IiI §1-§3, §7]
public protocol PP_PP11_LibraryReuse: PP_PP2_PoserSolver, CachePermanent, AgentPathCertified, LibrarySaturates, DiscoveryIsRevelation {}

/// PP12: Measured self-play — observable metrics. [PP6; Thm2; PiR; DiC G1a, G12; PiR M24]
public protocol PP_PP12_Measured: PP_PP6_BasisEndpoint, PassIsIdentification, DiC_G1a_ComputableNorm, DiC_G12_CoveringNumbers {}

/// PP13: The three grounds. [DiC G4, G13, G15; V=I §3.6]
public protocol PP_PP13_ThreeGrounds: DiC_G13_LossOverW, DiC_G15_Dimension {}

/// PP14: Multi-encoding. [PP8; V=I §5.4; IiI §4]
public protocol PP_PP14_MultiEncoding: PP_PP8_EncodingInvariance, EncodingSelectionSaturates {}

/// PP15: One given COMPARE — substrate grounding.
public protocol PP_PP15_SubstrateGrounding: PP_PP7_CertifiedVsStatistical {}

/// PP17: Canonical ensemble — λ_c = γ phase transition. [from PP context]
public protocol PP_PP17_CanonicalEnsemble: PP_PP5c_DirectednessNecessary {}

/// PP18: Poseur α-dependent ⊥ gate unconditional. [IiI §3; V=I Thm2, §5.25; GA GA3, GA6]
public protocol PP_PP18_PoseurAlphaDependent: LibrarySaturates, PassIsIdentification, GA_GA3_Alpha, GA_GA6_AlphaCondition {}
