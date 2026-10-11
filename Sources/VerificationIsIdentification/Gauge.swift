// Form coordinates are bound to actual supplied readings, not timings.

/// A form coordinate in a declared domain. The cost and factorization
/// interfaces below bind it to their actual reading source. [FiG FiG1]
public protocol HasGauge: HasSigma {
    associatedtype Gauge
}

/// The direct question is decoded through an actual image of this form.
/// This checks the presented factorization, not every renderer or every
/// transformation. Family coverage and response semantics remain supplied.
/// Reusing its answer under a form change needs that image preserved. [FiG FiG6]
public protocol ContentIsGaugeInvariant: HasGauge, ReadingFactors
where Gauge == Observation.Left {}

/// The cost reading takes this form and returns the distance coordinate.
/// Its units, workload and environment belong to the declared interpretation.
/// Type equality does not certify physical measurements. [FiG FiG2]
public protocol CostReadsGauge: HasGauge, PredicateReading, HasDistance
where Gauge == Left, Distance == Answer {}

/// Joins a source-bound cost reading and the crystallization interface.
/// A finite unique minimum still needs actual candidate coverage and strict
/// comparisons, not an unexamined conformance. [FiG FiG3]
public protocol GaugeFixing: CostReadsGauge, SystemCrystallizes {}

/// Joins the original path/distance equality with the image factorization.
/// LinearArbiter was an unused synonym and has been removed. Neither the
/// path equality nor this join proves a complexity bound. [FiG FiG6]
public protocol GaugeCollapse: CostIsPathLength, ContentIsGaugeInvariant {}
