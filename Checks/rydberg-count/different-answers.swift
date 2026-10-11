import VerificationIsIdentification
import Examples

// Two branches with different declared answers do not share one image.
// Swift itself must refuse this conformance.
public enum SplitFloorTwo: EncodingForgets {
    public typealias Left = TickCount<FloorTwoDepth, FloorTwoDepth>
    public typealias Right = TickCount<Plus<FloorThreeDepth, BalmerAlphaDrop>, U32>
    public typealias Sigma = RydbergLevels
    public typealias Encoding = UnaryArithmeticEncoding
    public typealias Predicate = TickCountQuestion
    public typealias Answer = FloorTwoDepth
    public typealias LeftSource = FloorTwoDepth
    public typealias RightSource = Plus<FloorThreeDepth, BalmerAlphaDrop>
    public typealias SharedImage = FloorTwoDepth
}
