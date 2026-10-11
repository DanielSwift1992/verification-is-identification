import VerificationIsIdentification
import Examples

// A forged shared image: both branches declare 32 for floor two.
// Swift accepts one common Answer; the count judge must refuse both branches.
public enum ForgedFloorTwo: EncodingForgets {
    public typealias Left = TickCount<FloorTwoDepth, U32>
    public typealias Right = TickCount<Plus<FloorThreeDepth, BalmerAlphaDrop>, U32>
    public typealias Sigma = RydbergLevels
    public typealias Encoding = UnaryArithmeticEncoding
    public typealias Predicate = TickCountQuestion
    public typealias Answer = U32
    public typealias LeftSource = FloorTwoDepth
    public typealias RightSource = Plus<FloorThreeDepth, BalmerAlphaDrop>
    public typealias SharedImage = U32
}
