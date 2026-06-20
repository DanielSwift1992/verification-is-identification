// ═══════════════════════════════════════════════════════
// Law Is Target (LiT) — paper 9
//
// Laws as verifiable structures, law space geometry.
// ═══════════════════════════════════════════════════════

/// LT1-LT2: Laws as structures in Σ. [I1; V=I §2.1; DiC G1a, G2]
public protocol LiT_LT1_LawsInSigma: StructuresFinite, DiC_G1a_ComputableNorm, DiC_G2_WMetric {}

/// LT3: Law composition. [LT2; I2; PiR M6-M7]
public protocol LiT_LT3_LawComposition: LiT_LT1_LawsInSigma, OperationsClosed {}

/// LT4: Law verification — Theorems 1-5 apply. [LT2; V=I §3, Thm1-5]
public protocol LiT_LT4_LawVerification: LiT_LT1_LawsInSigma, PassIsIdentification, PreconditionsGuaranteePass {}

/// LT5: Law diagnostics. [LT4; V=I §3.6]
public protocol LiT_LT5_LawDiagnostics: LiT_LT4_LawVerification {}

/// LT6: Law S-monotonicity. [LT4; V=I §5.22, §4.5]
public protocol LiT_LT6_LawSMonotone: LiT_LT4_LawVerification, CandidatesOnlyLeave {}

/// LT7: Law metric. [I1; DiC G1a, G2]
public protocol LiT_LT7_LawMetric: StructuresFinite, DiC_G1a_ComputableNorm, DiC_G2_WMetric {}

/// LT8: Law-structure distance. [LT7; DiD S19; DiC G14]
public protocol LiT_LT8_LawDistance: LiT_LT7_LawMetric, DiC_G14_SearchCost {}

/// LT9: Law certification. [LT4; Thm2; LT5]
public protocol LiT_LT9_LawCertification: LiT_LT4_LawVerification, LiT_LT5_LawDiagnostics {}

/// LT10: Law finiteness. [LT4; I1]
public protocol LiT_LT10_LawFiniteness: LiT_LT4_LawVerification, StructuresFinite {}

/// LT11: Law-grid metric. [LT7; DiC G7]
public protocol LiT_LT11_LawGridMetric: LiT_LT7_LawMetric, DiC_G7_GridMetric {}

/// LT12: Law navigation. [LT10, LT11; NiG N5-N9, N15-N17]
public protocol LiT_LT12_LawNavigation: LiT_LT10_LawFiniteness, LiT_LT11_LawGridMetric,
    NiG_N5_Geodesics, NiG_N9_Navigability, NiG_N17_FullNavigation {}

/// LT13: Law strategies. [LT12; OiO O2, O5, O14-O16, O21]
public protocol LiT_LT13_LawStrategies: LiT_LT12_LawNavigation,
    OiO_O2_StrategyGeometry, OiO_O15_StrategyCovering, OiO_O21_GrammarSaturation {}

/// LT14: Law saturation. [LT5, LT9, LT12; V=I §5.22]
public protocol LiT_LT14_LawSaturation: LiT_LT5_LawDiagnostics, LiT_LT9_LawCertification,
    LiT_LT12_LawNavigation, CandidatesOnlyLeave {}

/// LT15: Full law theory. [LT1-LT14; PiR §4; OiO O19]
public protocol LiT_LT15_FullLawTheory: LiT_LT14_LawSaturation, LiT_LT13_LawStrategies,
    OiO_O19_StoredStrategy {}
