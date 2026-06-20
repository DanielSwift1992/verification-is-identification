// ═══════════════════════════════════════════════════════
// Gradient Is Alignment (GA) — paper GA
//
// α coefficient, searchability, alignment regimes.
// ═══════════════════════════════════════════════════════

/// GA1: Loss landscape defined over W-metric. [NiG N4-N6; DiC G2]
public protocol GA_GA1_LossLandscape: DiC_G2_WMetric {}

/// GA2: Loss gradient from GA1. [GA1; DiC G10]
public protocol GA_GA2_LossGradient: GA_GA1_LossLandscape, DiC_G10_Modulus {}

/// GA3: α = corr(W(R,R*), loss(R)) — the alignment coefficient. [GA1; DiC §11]
/// Introduces HasAlignment; compresses Alpha to Measurable.
public protocol GA_GA3_Alpha: GA_GA1_LossLandscape,
    HasAlignment where Alpha: Measurable {}

/// GA4: Primes — α ≈ 0, binary predicate, no cheap loss. [GA3; B]
public protocol GA_GA4_PrimesMode: GA_GA3_Alpha {}

/// GA4a: Sieve waves. [GA4; B10]
public protocol GA_GA4a_SieveWaves: GA_GA4_PrimesMode {}

/// GA5: Loss landscape structure from α and W. [GA3, GA4; DiC G13]
public protocol GA_GA5_LandscapeStructure: GA_GA3_Alpha, GA_GA4_PrimesMode, DiC_G13_LossOverW {}

/// GA6: α > 0 ⟺ descent beats enumeration. [GA3; IiI §3-§4; InI S5]
public protocol GA_GA6_AlphaCondition: GA_GA3_Alpha, LibrarySaturates, InI_S5_FeatureEntropy {}

/// GA7: Clustered ∧ aligned — two orthogonal axes of searchability. [GA6; DiC G12; NiG N18]
public protocol GA_GA7_TwoAxes: GA_GA6_AlphaCondition, DiC_G12_CoveringNumbers {}

/// GA8: Structural symmetry and α. [GA3]
public protocol GA_GA8_Symmetry: GA_GA3_Alpha {}

/// P11: Measurable prediction — autocorrelation of α. [GA3, GA7, GA8]
public protocol GA_P11_Measurement: GA_GA3_Alpha, GA_GA7_TwoAxes, GA_GA8_Symmetry {}
