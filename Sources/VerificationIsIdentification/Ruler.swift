import Swift

// ═══════════════════════════════════════════════════════════════
// RULER pins the two claims of Light Is a Ruler: a unit of measure is the tick
// of a presented law with one survivor, and measuring is counting those ticks
// along a path. The paper's worked instance is light — the second's definition
// already counts an atomic transition's periods — but the claims stand for any
// standard over any structure, so they live here, beside the distance axis.
// ═══════════════════════════════════════════════════════════════

/// A standard is a type, never a stored value: the unit is the tick of a
/// presented law whose repetition admits one trajectory, so any two
/// realizations of the tick are the same tick and the unit reproduces wherever
/// the law can be written. An artifact standard is an instance (kept, worn,
/// and singular), and the history of metrology is the move from the instance
/// to the type. Builds on ``PresentedLaw``: the law is written whole, so the
/// unit needs no keeping. [LiR 1]
public protocol StandardIsType: PresentedLaw {
    associatedtype Tick
}

/// Measuring is counting: a length is the tally of standard ticks along a
/// path, so measurement reads a magnitude and never creates one. Counts add
/// where paths concatenate, which makes the ruler a homomorphism from paths to
/// counts, and every arithmetic identity of measurement is inherited from
/// addition. Builds on ``StandardIsType`` and ``DistanceOnStructures``: the
/// tick gives the unit, the distance axis receives the count. [LiR 2]
public protocol MeasureIsCount: StandardIsType, DistanceOnStructures {}
