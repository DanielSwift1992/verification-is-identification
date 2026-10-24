import Notation

// Proposal Is Order. Selection and checking can share inputs and records.
// The equations below name interfaces, not an information-free generator
// or an automatically optimal discriminator. See GD1–GD9 for scope.

/// Names membership beside proposal order. Reordering given candidates
/// does not create another observation. A proposer reading further task
/// structure must account for that application and its evidence. [GD GD1–GD2]
public protocol DiscriminatorAndGenerator: PassImpliesMembership, OrderIsOnlyFreedom {}

/// Connects proposal/checking and search interfaces. A fitting candidate
/// need not identify a unique rule. The intersection does not prove
/// independent complexity bounds for generation and checking. [GD GD3]
public protocol OrthogonalOrgans: DiscriminatorAndGenerator, SearchableIffClusteredAndAligned {}

/// Historical name. GD4–GD5 separate retained coverage, dispatch, actual
/// proposal cost and correlation. Retention alone does not force optimal
/// ordering, and Alpha alone does not certify a descending path.
public protocol InevitabilityIsDiscriminator: DiscriminatorAndGenerator, IntelligenceRises, AlignmentCoefficient {}

/// Names comparison beside selection and membership. Both roles are
/// internal to the whole. This interface does not identify every physical
/// mechanism with a single comparison operation. [GD GD8]
public protocol OrgansAreOneCompare: DiscriminatorAndGenerator, Decidable {}
