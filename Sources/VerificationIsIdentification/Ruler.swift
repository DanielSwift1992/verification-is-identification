import Swift

/// Names a tick in a presented-law interface. A shared declaration checks
/// notation, not uniqueness or physical calibration. [LiR LiR1]
public protocol StandardIsType: PresentedLaw {
    associatedtype Tick
}

/// The two interfaces use exactly the same declared unit type. This binds
/// the Tick axis to a comparison and does not identify its realizations.
/// Ordered-repeat calibration has the separate LiR8 premises. [LiR LiR1]
public protocol SharedDeclaredTick: Pair
where Left: StandardIsType, Right: StandardIsType, Tick == Left.Tick, Tick == Right.Tick {
    associatedtype Tick
}

/// Joins a declared unit and distance coordinates. Additivity still needs
/// an actual path-count construction and its interpretation. [LiR LiR3]
public protocol MeasureIsCount: StandardIsType, DistanceOnStructures {}
