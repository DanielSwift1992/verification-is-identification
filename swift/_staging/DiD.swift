// ═══════════════════════════════════════════════════════
// Difference Is Distance (DiD) — paper 4
//
// Distance = symmetric difference of comparison caches.
// Space from multiple agents, velocity, locality.
// ═══════════════════════════════════════════════════════

/// S1: Stationarity — one agent's perspective is invariant
/// under encoding-preserving transformations. [§5.24]
public protocol DiD_S1_Stationarity: ScopeBoundedByEncoding, HasEncoding {}

/// S2: Perspective = encoding. Same E, same τ → same f*. [S1; §5.8]
public protocol DiD_S2_Perspective: DiD_S1_Stationarity, ResultDeterministic {}

/// S3: Quality dimension — n independent encodings → n-dim quality. [S2]
public protocol DiD_S3_QualityDimension: DiD_S2_Perspective {}

/// S5: Dimensionality = independent axes of grammar. [S3]
public protocol DiD_S5_Dimensionality: DiD_S3_QualityDimension {}

/// S7: d(A₁,A₂) = |G₁ △ G₂| — symmetric difference of caches is a metric.
/// The key theorem. Distance is what two agents have witnessed differently.
/// [I1; I3]
public protocol DiD_S7_Distance: StructuresFinite, CachePermanent,
    HasCache, HasDistance where Distance: MetricProperty, Cache: Permanent {}

/// S8: Space = the set of all perspective-distances. [S7]
public protocol DiD_S8_SpaceFromDifference: DiD_S7_Distance {}

/// S10: Agreement — G₁ = G₂ → same point in space. Permanent (I3). [S7; I3]
public protocol DiD_S10_Agreement: DiD_S7_Distance {}

/// S11: Motion = encoding change. Agent doesn't move; it re-encodes. [S2; S7]
public protocol DiD_S11_Motion: DiD_S2_Perspective, DiD_S7_Distance {}

/// S19: Max velocity = 1 feature-distance per COMPARE tick.
/// Speed limit is structural: COMPARE is the sole source of new facts. [I1; §5.21]
public protocol DiD_S19_MaxVelocity: StructuresFinite {}

/// S20: Locality — effects propagate at bounded speed through agent space. [S19; S7]
public protocol DiD_S20_Locality: DiD_S19_MaxVelocity, DiD_S7_Distance {}

/// S21: Symmetry breaking — crystallization breaks grammar symmetry.
/// Before saturation all encodings equivalent; after, E* is preferred. [S7; IiI §3]
public protocol DiD_S21_SymmetryBreaking: DiD_S7_Distance, LibrarySaturates {}

/// S24: Conservation from symmetry — continuous grammar symmetry → conserved quantity.
/// [S1; I1; I2]
public protocol DiD_S24_ConservationFromSymmetry: DiD_S1_Stationarity, StructuresFinite, OperationsClosed {}
