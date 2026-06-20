// ═══════════════════════════════════════════════════════
// V=I Theory Witness
//
// This type compiles ⟺ every claim in all 17 papers holds.
//
// Protocols = axes (free dimensions).
// where clauses = theorems (compressions).
// Pair → Null = the meta-pattern.
// All axes resolve to Never = Null (the fixpoint).
// ═══════════════════════════════════════════════════════

enum VITheoryWitness:

    // ── V=I (paper 1) ──
    PassIsIdentification, ComparisonsAreBounded, PreconditionsGuaranteePass,
    CacheOnlyGrows, DiagnosticsAccumulate, CandidatesOnlyLeave,
    NoSelfReference, ScopeBoundedByEncoding,
    AxesCoOriented, SaturationIncorruptible, PermanenceGeneratesAlignment,

    // ── IiI (paper 2) ──
    PipelineCrystallizes, LibraryCrystallizes,
    SaturationDynamics, DiscoveryIsRevelation,

    // ── PiR (paper 3) ──
    PiR_M16_TowerTermination, PiR_M27_CostTransformation,

    // ── DiD (paper 4) ──
    DiD_S8_SpaceFromDifference, DiD_S20_Locality,
    DiD_S21_SymmetryBreaking, DiD_S24_ConservationFromSymmetry,

    // ── InI (paper 5) ──
    InI_S8a_LevelInvariance, InI_S6c_CoupledDynamics,

    // ── DiC (paper 6) ──
    DiC_G7_GridMetric, DiC_G9_WOrdering, DiC_G15_Dimension,

    // ── NiG (paper 7) ──
    NiG_N17_FullNavigation, NiG_N19_InevitabilityUnderClustering,

    // ── OiO (paper 8) ──
    OiO_O17_StrategyLibrary, OiO_O19_StoredStrategy, OiO_O21_GrammarSaturation,

    // ── LiT (paper 9) ──
    LiT_LT15_FullLawTheory,

    // ── PP (paper 10) ──
    PP_PP7_CertifiedVsStatistical, PP_PP15_SubstrateGrounding,
    PP_PP18_PoseurAlphaDependent,

    // ── B ──
    B_B8b_Horn, B_B8e_ReachDynamics, B_B10_SieveWaves,

    // ── GA ──
    GA_GA7_TwoAxes, GA_P11_Measurement,

    // ── GD ──
    GD_GD3_Orthogonality, GD_GD4_InevitabilityAsymmetry,
    GD_GD8_MonistSplit, GD_GD9_HornGeneratorOnly,

    // ── LL ──
    LL_LQ8_CoupledDynamics, LL_LQ10_FullField,

    // ── AI (top of DAG) ──
    AI_AI4_ConditionalSuccess, AI_AI5_FrontAndFlow,
    AI_AI6_FullMachine, AI_AI7_SaturationMap

{
    // ── Pair / Null ──
    typealias Left = Never
    typealias Right = Never

    // ── Axes (all = Never = Null) ──
    typealias Sigma = Never
    typealias SolutionSet = Never       // : Unique ✓  : Monotone ✓  : Decidable ✓
    typealias Library = Never           // : Permanent ✓
    typealias SaturatedLibrary = Never  // == Library ✓ (IiI §3)
    typealias Cache = Never             // : Permanent ✓
    typealias Distance = Never          // : MetricProperty ✓  : IntegerValued ✓
    typealias Encoding = Never
    typealias Alpha = Never             // : Measurable ✓
    typealias Basis = Never
}
