import VerificationIsIdentification
import Examples

// A false direct drop: 28 instead of 27 from floor four to floor two.
// Swift accepts the binding's shape; the count judge must refuse 9 + 28 as 36.
public typealias FalseBalmerBetaDrop = Plus<U16, Plus<U8, Plus<U2, Plus<U1, U1>>>>
public typealias FalseBalmerBetaBinding = LevelDrop<FloorTwoDepth, FloorFourDepth, FalseBalmerBetaDrop>
