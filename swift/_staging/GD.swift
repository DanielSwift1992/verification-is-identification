// ═══════════════════════════════════════════════════════
// Proposal Is Order (GD) — paper GD
//
// Generator ⊥ discriminator, the asymmetry of inevitability.
// ═══════════════════════════════════════════════════════

/// GD1: Discriminator = cut (Z), generator = order (Y). [V=I §5.21, §5.22; InI S1, S2]
public protocol GD_GD1_CutIsDiscriminator: CandidatesOnlyLeave, InI_S1_AxisIndependence, InI_S2_YCarriesZeroBits {}

/// GD2: Two geometries — confusion-cover and loss-over-W. [InI S5b; DiC G13; GA]
public protocol GD_GD2_TwoGeometries: InI_S5b_ConfusionCover, DiC_G13_LossOverW, GA_GA3_Alpha {}

/// GD3: Discriminate-easy ⊥ generate-easy — all four quadrants inhabited.
/// [GD2; InI S1; GA4, GA7; B8a; E2 §4]
public protocol GD_GD3_Orthogonality: GD_GD2_TwoGeometries, InI_S1_AxisIndependence,
    GA_GA4_PrimesMode, GA_GA7_TwoAxes, B_B8a_Primes {}

/// GD4: The inevitability is the discriminator's. Saturation cannot manufacture α.
/// [InI S6; GA3, GA6; NiG N19; IiI §3]
public protocol GD_GD4_InevitabilityAsymmetry: InI_S6_OptimalOrdering,
    GA_GA3_Alpha, GA_GA6_AlphaCondition, NiG_N19_InevitabilityUnderClustering, LibrarySaturates {}

/// GD5: Generator power = ordering visibility = α. Three statements, one quantity.
/// [InI S4a; GA6]
public protocol GD_GD5_GeneratorPower: InI_S4a_YVisibility, GA_GA6_AlphaCondition {}

/// GD6: Two failures, two ledger terminals. G→BUDGET/EMPTY, D→AMBIGUOUS.
/// [V=I outcome corollary; E1 §4; V=I §3.5]
public protocol GD_GD6_TwoFailures: PassIsIdentification {}

/// GD7: E2's encoder/backend = generator/discriminator.
public protocol GD_GD7_EncoderBackendSplit {}

/// GD8: Both organs are COMPARE — the split is scope. Framework stays monist.
/// [V=I §2.5; InI §0; PP15]
public protocol GD_GD8_MonistSplit: OperationsClosed, InI_S1_AxisIndependence, PP_PP15_SubstrateGrounding {}

/// GD9: On a horn the generator is the only mode.
/// [Thm2; IiI §3; B8, B8b; GA; PP6]
public protocol GD_GD9_HornGeneratorOnly: PassIsIdentification, LibrarySaturates,
    B_B8_Saturability, B_B8b_Horn, GA_GA6_AlphaCondition, PP_PP6_BasisEndpoint {}
