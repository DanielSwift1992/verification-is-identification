import VerificationIsIdentification
import Examples

enum ExposureRetainsOldCache<T: Pair>: Null
where T.Left: Structure, T.Right: Pair,
      T.Right.Left: Structure, T.Right.Right: Structure {
    typealias Left = ExposeNext<T>.Left.Left
    typealias Right = T.Left
}

enum ExposureReadsResidentField<T: Pair>: Null
where T.Left: Structure, T.Right: Pair,
      T.Right.Left: Structure, T.Right.Right: Structure {
    typealias Left = ExposeNext<T>.Left.Right
    typealias Right = T.Right.Left
}

enum RewindingRestoresCache<T: Pair>: Null
where T.Left: Structure, T.Right: Pair,
      T.Right.Left: Structure, T.Right.Right: Structure {
    typealias Left = RewindExposure<ExposeNext<T>>.Left
    typealias Right = T.Left
}

enum RewindingRestoresHead<T: Pair>: Null
where T.Left: Structure, T.Right: Pair,
      T.Right.Left: Structure, T.Right.Right: Structure {
    typealias Left = RewindExposure<ExposeNext<T>>.Right.Left
    typealias Right = T.Right.Left
}

enum RewindingRestoresTail<T: Pair>: Null
where T.Left: Structure, T.Right: Pair,
      T.Right.Left: Structure, T.Right.Right: Structure {
    typealias Left = RewindExposure<ExposeNext<T>>.Right.Right
    typealias Right = T.Right.Right
}

typealias PreparedExposure = Paired<ExperimentSignal, Paired<Never, ExperimentSignal>>
typealias ExposureCacheSurvives = RewindingRestoresCache<PreparedExposure>
typealias ExposureSourceSurvives = RewindingRestoresTail<PreparedExposure>

#if EXPOSURE_ERASES_OLD_CACHE
enum RejectedExposureCacheLoss: Null {
    typealias Left = ExposeNext<PreparedExposure>.Left.Left
    typealias Right = Never
}
#endif

#if EXPOSURE_INVENTS_NEW_READING
enum RejectedInventedExposure: Null {
    typealias Left = ExposeNext<PreparedExposure>.Left.Right
    typealias Right = ExperimentSignal
}
#endif
