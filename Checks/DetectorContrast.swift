import VerificationIsIdentification
import Examples

enum DetectorOperandsStayBound: Null {
    typealias Left = DetectorContrast.SourcesAreTheActualCorners.Left
    typealias Right = DetectorContrast.SourcesAreTheActualCorners.Right
}
enum OriginalDetectorContrastIsZero: Null {
    typealias Left = DetectorContrast.OriginalContrastVanishes.Left
    typealias Right = DetectorContrast.OriginalContrastVanishes.Right
}
enum SquaredContrastRetainsADistinction: Null {
    typealias Left = DetectorContrast.ReadImageDifference.Left
    typealias Right = DetectorContrast.ReadImageDifference.Right
}
enum DifferentCornerOffsetsCanPreserveTheContrast: Null {
    typealias Left = DetectorContrast.ShiftedSourcesAndContrast.Left
    typealias Right = DetectorContrast.ShiftedSourcesAndContrast.Right
}

#if DETECTOR_SQUARE_PRESERVES_NULL
enum RejectedInjectiveSquaringPreservesTheOldContrast: Null {
    typealias Left = DetectorContrast.ImageDiagonalTail
    typealias Right = DetectorContrast.ImageOffDiagonalTail
}
#endif

#if DETECTOR_SHARED_CONTRAST_MEANS_SAME_OFFSET
enum RejectedContrastPreservationRequiresIdenticalOffsets: Null {
    typealias Left = DetectorContrast.Shift0.Left.Left
    typealias Right = DetectorContrast.Shift1.Left.Left
}
#endif
