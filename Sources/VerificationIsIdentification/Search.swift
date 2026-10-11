// Gradient Is Alignment. A correlation statistic and a supplied descending
// transition are different relations. GA6–GA7 state the relevant boundaries.

/// Names Alpha beside the distance and zero-test interfaces. A correlation
/// requires a specified candidate domain, loss and weighting law. It does
/// not alone certify a descending path or the absence of local minima.
/// This protocol also does not compute that statistic. [GA GA3, GA6]
public protocol AlignmentCoefficient: HasAlpha, DistanceOnStructures, GateIsZeroOfLoss {}

/// Names the statistic beside efficiency. Actual proposal ranks, checking
/// costs and transition access determine the comparison with enumeration.
/// GA6 permits information at zero correlation. A generic performance
/// implication is not supplied by this intersection. [GA GA6, G10a]
public protocol AlignmentEnablesIntelligence: AlignmentCoefficient, IntelligenceRises {}

/// Historical name for combined search interfaces. GA7 separates descent
/// from representative approximation and exact reuse. Clustering alone
/// supplies no descending transition, and efficient constructive solutions
/// need not search a metric hierarchy. No universal iff follows here.
public protocol SearchableIffClusteredAndAligned: AlignmentCoefficient, OneBoundaryThreeFaces {}
