import VerificationIsIdentification
import Examples

enum RawAppendMatchesReading<Before: Pair, Event: Pair>: Null
where Before.Left: Structure, Before.Right: Structure,
      Event.Left: Structure, Event.Right: Structure {
    typealias Left = RetainedWhole<Before.Left, Event.Left>.Right
    typealias Right = AppendedCacheReading<Before, Event>.Left
}

enum DecodedAppendRecoversOld<Before: Pair, Event: Pair>: Null
where Before.Left: Structure, Before.Right: Structure,
      Event.Left: Structure, Event.Right: Structure {
    typealias Left = AppendedCacheReading<Before, Event>.Right.Left
    typealias Right = Before.Right
}

enum ConstructedCacheMatchesDecoder<
    Frame: StructuresFinite,
    Before: Pair,
    Event: Pair
>: Null
where Frame: OperationsClosed,
      Before.Left: Structure, Before.Right: Structure,
      Event.Left: Structure, Event.Right: Structure {
    typealias Left = CacheByAppending<Frame, Before, Event>.Cache.Right
    typealias Right = CacheByAppending<Frame, Before, Event>.Reading.Right
}

// The fixed structural frame and a declared decision can compile with a
// retracting cache. CachePermanent needs the actual retaining relation.
enum PureFrameWithRetractingCache: EqualityDecidable, OperationsClosed, HasCache {
    typealias Left = Never
    typealias Right = Never
    typealias Sigma = Never
    typealias Equality = Never
    typealias Cache = Paired<ExperimentSignal, Never>
}

typealias OldCacheReading = Paired<ExperimentQuiet, ExperimentSignal>
typealias EmptyCacheEvent = Paired<Never, Never>

// This alternative decoder receives the same raw append, yet returns only
// the empty latest event. The retained raw history still contains the old one.
enum LatestOnlyCacheReading: Pair {
    typealias Left = AppendedCacheReading<OldCacheReading, EmptyCacheEvent>.Left
    typealias Right = EmptyCacheEvent.Right
}

#if PURE_TRUTH_IMPLIES_RETENTION
extension PureFrameWithRetractingCache: CachePermanent {}
#endif

#if RAW_APPEND_IMPLIES_DECODED_RETENTION
enum RejectedLatestOnlyRetention: Null {
    typealias Left = LatestOnlyCacheReading.Right.Left
    typealias Right = OldCacheReading.Right
}
#endif
