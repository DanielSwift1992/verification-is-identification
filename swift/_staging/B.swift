// ═══════════════════════════════════════════════════════
// Basis Is Residue (B) — paper B
//
// Composition sieve, horn trichotomy, basis vs reach.
// ═══════════════════════════════════════════════════════

/// B1: Composition — f ∘ g defined on Σ. [V=I §2.2]
public protocol B_B1_Composition: OperationsClosed {}

/// B2: Closure — iterated composition yields a finite set. [B1; I1; NiG N1]
public protocol B_B2_Closure: B_B1_Composition, StructuresFinite {}

/// B3: Sieve — identifies irreducible atoms. [B2; DiC G1a; V=I §3.7; I1, I3]
public protocol B_B3_Sieve: B_B2_Closure, DiC_G1a_ComputableNorm, CachePermanent {}

/// B4: Compositional depth — shortest decomposition into atoms. [B3; DiC G1a, G6]
public protocol B_B4_Depth: B_B3_Sieve, DiC_G6_NumberMetric {}

/// B5: Basis-to-reach metric. [B4; DiC G2; OiO O17]
public protocol B_B5_BasisReachMetric: B_B4_Depth, DiC_G2_WMetric {}

/// B6: Certified basis — atoms certified by the gate. [B3; I3]
/// Introduces HasBasis (finite basis of L).
public protocol B_B6_CertifiedBasis: B_B3_Sieve, CachePermanent, HasBasis {}

/// B7: Basis saturation — at saturation, basis is complete. [B6; IiI §3; DiC G11]
public protocol B_B7_BasisSaturation: B_B6_CertifiedBasis, LibrarySaturates, DiC_G11_Clustering {}

/// B8: Saturability — three regimes. [B6, B7; IiI §6]
public protocol B_B8_Saturability: B_B6_CertifiedBasis, B_B7_BasisSaturation, SaturationDynamics {}

/// B8a: Primes — no finite basis (singularity). [B8; Euclid]
public protocol B_B8a_Primes: B_B8_Saturability {}

/// B8b: Horn — finite basis, infinite reach. [B8, B8a; DiC G8; B5]
public protocol B_B8b_Horn: B_B8_Saturability, B_B8a_Primes, DiC_G8_ProgramMetric, B_B5_BasisReachMetric {}

/// B8c: Reach curves from basis. [B6, B7; DiC G1a]
public protocol B_B8c_ReachCurves: B_B6_CertifiedBasis, B_B7_BasisSaturation, DiC_G1a_ComputableNorm {}

/// B8d: Clustering of reach. [B8b; DiC G12]
public protocol B_B8d_ReachClustering: B_B8b_Horn, DiC_G12_CoveringNumbers {}

/// B8e: Reach curve dynamics. [B8d; PP PP5c]
public protocol B_B8e_ReachDynamics: B_B8d_ReachClustering {}

/// B9: Encoding-relative sieve. [B3; IiI §4; DiC §11]
public protocol B_B9_EncodingSieve: B_B3_Sieve, EncodingSelectionSaturates {}

/// B10: Sieve waves. [B9; I1; DiC G12]
public protocol B_B10_SieveWaves: B_B9_EncodingSieve, StructuresFinite, DiC_G12_CoveringNumbers {}
