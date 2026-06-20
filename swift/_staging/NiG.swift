// ═══════════════════════════════════════════════════════
// Navigation Is Geometry (NiG) — paper 7
//
// N-geometry, geodesics, navigability.
// ═══════════════════════════════════════════════════════

/// N1: W-ball defined — B_r(x) = {y : W(x,y) ≤ r}. [I1; DiC G2a]
public protocol NiG_N1_WBall: StructuresFinite, DiC_G2a_ComputableW {}

/// N2: Ball containment monotone. [N1]
public protocol NiG_N2_Monotone: NiG_N1_WBall {}

/// N3: Ball cardinality bounded. [N1; DiC G2a]
public protocol NiG_N3_CardinalityBound: NiG_N1_WBall {}

/// N4: Ball growth rate. [N1; DiC G2a]
public protocol NiG_N4_GrowthRate: NiG_N1_WBall {}

/// N5: Geodesics in Σ — shortest W-paths. [N3; DiC G2]
public protocol NiG_N5_Geodesics: NiG_N3_CardinalityBound, DiC_G2_WMetric {}

/// N6: Geodesic computation. [N5]
public protocol NiG_N6_GeodesicComputation: NiG_N5_Geodesics {}

/// N7: Finite diameter. [N5; I1]
public protocol NiG_N7_FiniteDiameter: NiG_N5_Geodesics, StructuresFinite {}

/// N8: W-ball decomposition. [N3]
public protocol NiG_N8_BallDecomposition: NiG_N3_CardinalityBound {}

/// N9: Navigability — greedy routing success. [N7, N8]
public protocol NiG_N9_Navigability: NiG_N7_FiniteDiameter, NiG_N8_BallDecomposition {}

/// N10: Local structure. [N3; DiC G2a]
public protocol NiG_N10_LocalStructure: NiG_N3_CardinalityBound {}

/// N11: Tree-likeness — Gromov δ-hyperbolicity. [N1; DiC G11-G12]
public protocol NiG_N11_TreeLikeness: NiG_N1_WBall, DiC_G11_Clustering, DiC_G12_CoveringNumbers {}

/// N12: W-ordered search beats baseline. [N11]
public protocol NiG_N12_WOrderedSearch: NiG_N11_TreeLikeness {}

/// N13: Routing by structure. [N10]
public protocol NiG_N13_StructuralRouting: NiG_N10_LocalStructure {}

/// N14: Cluster geometry. [DiC G10-G11; IiI §1]
public protocol NiG_N14_ClusterGeometry: DiC_G10_Modulus, DiC_G11_Clustering, AgentPathCertified {}

/// N15: Geodesics inside Σ. [N6; DiC G2]
public protocol NiG_N15_InternalGeodesics: NiG_N6_GeodesicComputation {}

/// N16: Navigation is permanent. [N15; I3; PiR M21]
public protocol NiG_N16_PermanentNavigation: NiG_N15_InternalGeodesics, CachePermanent {}

/// N17: Full navigation — geodesics + permanence + computation. [N6, N15, N16]
public protocol NiG_N17_FullNavigation: NiG_N6_GeodesicComputation, NiG_N15_InternalGeodesics, NiG_N16_PermanentNavigation {}

/// N18: Navigability under clustering. [from N9 context]
public protocol NiG_N18_ClusteredNavigability: NiG_N9_Navigability, DiC_G12_CoveringNumbers {}

/// N19: Inevitability under population/clustering. [DiC G11; IiI §6]
public protocol NiG_N19_InevitabilityUnderClustering: DiC_G11_Clustering, SaturationDynamics {}
