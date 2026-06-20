// ═══════════════════════════════════════════════════════
// Order Is Object (OiO) — paper 8
//
// Strategies as structures, cost computation,
// strategy verification, learning strategies.
// ═══════════════════════════════════════════════════════

/// O1-O3: Strategies live in Σ, are finite. [V=I §2.1, Thm3; I1]
public protocol OiO_O1_StrategiesInSigma: StructuresFinite, ComparisonsAreBounded {}

/// O2: Strategy geometry inherited from Σ. [O1; DiC G1a, G2]
public protocol OiO_O2_StrategyGeometry: OiO_O1_StrategiesInSigma, DiC_G1a_ComputableNorm, DiC_G2_WMetric {}

/// O4-O6: Cost computable, monotone, order-determined. [O1; V=I §5.5, §5.25, Thm2; I2]
public protocol OiO_O4_CostComputable: OiO_O1_StrategiesInSigma, PassIsIdentification, OperationsClosed {}

/// O7: Cost lattice — strategies partially ordered by cost. [O4; I1]
public protocol OiO_O7_CostLattice: OiO_O4_CostComputable, StructuresFinite {}

/// O8: Optimal strategy exists and is verifiable. [O7; V=I §3.7]
public protocol OiO_O8_OptimalVerifiable: OiO_O7_CostLattice, EqualityDecidable {}

/// O9: Optimal strategy is permanent (I3). [O8; I3; PiR M21]
public protocol OiO_O9_PermanentOptimal: OiO_O8_OptimalVerifiable, CachePermanent {}

/// O10: Ordering carries zero bits (InI S2). [O8; InI S2]
public protocol OiO_O10_ZeroBits: OiO_O8_OptimalVerifiable, InI_S2_YCarriesZeroBits {}

/// O11: Strategy confusion cover. [O8; InI S5b]
public protocol OiO_O11_ConfusionCover: OiO_O8_OptimalVerifiable, InI_S5b_ConfusionCover {}

/// O12: Strategy saturation. [O8, O9; IiI §3]
public protocol OiO_O12_StrategySaturation: OiO_O8_OptimalVerifiable, OiO_O9_PermanentOptimal, LibrarySaturates {}

/// O13: Strategy phase transition. [O9; IiI §3, §6]
public protocol OiO_O13_StrategyPhaseTransition: OiO_O9_PermanentOptimal, LibrarySaturates, SaturationDynamics {}

/// O14: Strategy distance ≤ modulus. [O2; DiC G10]
public protocol OiO_O14_StrategyModulus: OiO_O2_StrategyGeometry, DiC_G10_Modulus {}

/// O15: Strategy covering numbers. [O14; DiC G12]
public protocol OiO_O15_StrategyCovering: OiO_O14_StrategyModulus, DiC_G12_CoveringNumbers {}

/// O16: Strategy navigation. [O14, O15; NiG N1-N19]
public protocol OiO_O16_StrategyNavigation: OiO_O14_StrategyModulus, OiO_O15_StrategyCovering, NiG_N9_Navigability {}

/// O17: Strategy library — at saturation, optimal strategies for all classes.
/// [O12; I3; Thm2/4; IiI §3; G10-G11; NiG N18]
public protocol OiO_O17_StrategyLibrary: OiO_O12_StrategySaturation, CachePermanent, PassIsIdentification,
    DiC_G10_Modulus, DiC_G11_Clustering, NiG_N18_ClusteredNavigability {}

/// O19: Strategy as stored object — Y-axis in the library.
/// [O1-O9; InI S2, S8a; DiC G12]
public protocol OiO_O19_StoredStrategy: OiO_O9_PermanentOptimal, InI_S2_YCarriesZeroBits,
    InI_S8a_LevelInvariance, DiC_G12_CoveringNumbers {}

/// O20: Grammar restriction — affordability from bounded depth. [O1; InI S5; DiC G8, G10; I3]
public protocol OiO_O20_Grammar: OiO_O1_StrategiesInSigma, InI_S5_FeatureEntropy,
    DiC_G8_ProgramMetric, DiC_G10_Modulus, CachePermanent {}

/// O21: Grammar saturation. [O20; NiG N13; IiI §6]
public protocol OiO_O21_GrammarSaturation: OiO_O20_Grammar, NiG_N13_StructuralRouting, SaturationDynamics {}
