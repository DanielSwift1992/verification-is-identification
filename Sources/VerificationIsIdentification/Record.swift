import Notation

import Swift

/// Two justified routes retain one requested reading of the record's source.
/// Their final answers follow from that shared reference. Correctness of the
/// supplied source interpretation and renderers remains a premise. [Record SW2]
public protocol RootedRecordReadings: Pair
where Left: ReadingFactors, Right: ReadingFactors,
      Reference.Left == Root.Left,
      Left.Left == Reference, Right.Left == Reference {
    associatedtype Root: Pair
    associatedtype Reference: PredicateReading
}
