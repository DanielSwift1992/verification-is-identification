// ═══════════════════════════════════════════════════════
// Distance Is Cost (DiC) — paper 6
//
// W-metric, clustering, confusion families, loss function.
// ═══════════════════════════════════════════════════════

/// G1: ‖s‖ = |D(s)| — maintenance cost of a structure.
public protocol DiC_G1_Norm: StructuresFinite, OperationsClosed {}

/// G1a: ‖s‖ computable by one traversal.
public protocol DiC_G1a_ComputableNorm: DiC_G1_Norm {}

/// G1b: ‖s‖ is encoding-relative.
public protocol DiC_G1b_EncodingRelative: DiC_G1a_ComputableNorm {}

/// G2: W(a,b) = |D(a) △ D(b)| — the W-metric (symmetric difference).
/// Introduces HasDistance; compresses Distance to MetricProperty (triangle inequality).
public protocol DiC_G2_WMetric: StructuresFinite, OperationsClosed,
    HasDistance where Distance: MetricProperty {}

/// G2a: W computable by one traversal.
public protocol DiC_G2a_ComputableW: DiC_G2_WMetric {}

/// G2b: W is a metric (triangle inequality).
public protocol DiC_G2b_Triangle: DiC_G2_WMetric {}

/// G2c: W is integer-valued.
/// Compresses Distance further: takes only integer values.
public protocol DiC_G2c_IntegerValued: DiC_G2_WMetric
    where Distance: IntegerValued {}

/// G3: W = 0 ⟺ structural identity.
public protocol DiC_G3_Identity: DiC_G2_WMetric, CachePermanent {}

/// G4: Three components of W — shared, a-only, b-only.
public protocol DiC_G4_Components: DiC_G2a_ComputableW {}

/// G6: W on Peano numerals = |n - m|.
public protocol DiC_G6_NumberMetric: DiC_G2_WMetric {}

/// G7: W on grid cells = taxicab distance.
public protocol DiC_G7_GridMetric: DiC_G6_NumberMetric {}

/// G8: W on programs — structural distance of ASTs.
public protocol DiC_G8_ProgramMetric: DiC_G2_WMetric {}

/// G9: Ordering by W — nearer candidates first.
public protocol DiC_G9_WOrdering: DiC_G2a_ComputableW, PassIsIdentification {}

/// G10: Modulus of continuity — nearby inputs → nearby rules.
public protocol DiC_G10_Modulus: DiC_G2_WMetric {}

/// G11: Clustering coefficient.
public protocol DiC_G11_Clustering: DiC_G10_Modulus {}

/// G12: Covering numbers — N(r) from the W-matrix.
public protocol DiC_G12_CoveringNumbers: DiC_G11_Clustering {}

/// G13: Loss over W — loss_τ(R) = Σ W(apply(R,I_k), O_k).
public protocol DiC_G13_LossOverW: DiC_G2_WMetric {}

/// G14: Search cost proportional to W-distance.
public protocol DiC_G14_SearchCost: DiC_G2_WMetric {}

/// G15: Feature-space dimension.
public protocol DiC_G15_Dimension: DiC_G12_CoveringNumbers, DiC_G13_LossOverW {}
