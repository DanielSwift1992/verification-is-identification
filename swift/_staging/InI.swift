// ═══════════════════════════════════════════════════════
// Interference Is Intelligence (InI) — paper 5
//
// Three axes of COMPARE (Z/X/Y), axis independence,
// ordering as the sole free variable, interference pattern.
// ═══════════════════════════════════════════════════════

/// S1: Z/X/Y axes are disjoint — test outcome, frontier, agent choice.
/// Introduces HasEncoding (the agent's perspective).
public protocol InI_S1_AxisIndependence: StructuresFinite, OperationsClosed, HasEncoding {}

/// S2: Y-axis carries zero new information bits.
public protocol InI_S2_YCarriesZeroBits: InI_S1_AxisIndependence {}

/// S3: Interference — the three axes interact.
public protocol InI_S3_Interference: InI_S1_AxisIndependence {}

/// S3a: The interference pattern is the solve's total cost.
public protocol InI_S3a_InterferencePattern: InI_S3_Interference {}

/// S4: |S| is non-increasing (shrinkage).
public protocol InI_S4_Shrinkage: CandidatesOnlyLeave {}

/// S4a: Y-axis visibility — feedback bandwidth.
public protocol InI_S4a_YVisibility: InI_S4_Shrinkage {}

/// S5: Feature entropy governs elimination rate.
public protocol InI_S5_FeatureEntropy: InI_S4_Shrinkage {}

/// S5a: |S| bounds shrinkage per COMPARE.
public protocol InI_S5a_ShrinkageBound: InI_S4_Shrinkage {}

/// S5b: Confusion matrix / cert — the confusion cover.
public protocol InI_S5b_ConfusionCover: InI_S4a_YVisibility, InI_S5_FeatureEntropy {}

/// S6: Ordering optimal at saturation.
public protocol InI_S6_OptimalOrdering: InI_S5b_ConfusionCover, InI_S3a_InterferencePattern {}

/// S6a: Optimal ordering is computable at saturation.
public protocol InI_S6a_ComputableOrdering: InI_S5a_ShrinkageBound, InI_S6_OptimalOrdering {}

/// S6b: The dynamical mechanism for IiI §1.
public protocol InI_S6b_DynamicalMechanism: InI_S5b_ConfusionCover, InI_S6a_ComputableOrdering {}

/// S6c: Coupled dynamics — front + flow.
public protocol InI_S6c_CoupledDynamics: InI_S6a_ComputableOrdering, InI_S6b_DynamicalMechanism {}

/// S8: The three-axis picture as a whole.
public protocol InI_S8_ThreeAxes: InI_S1_AxisIndependence, InI_S5b_ConfusionCover, InI_S6_OptimalOrdering {}

/// S8a: Level invariance — the three-axis structure repeats at every level.
public protocol InI_S8a_LevelInvariance: InI_S8_ThreeAxes {}
