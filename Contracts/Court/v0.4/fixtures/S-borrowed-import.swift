protocol Admitted {}
enum Match<L, R> {}
extension Match: Admitted where L == R {}
typealias Claim = Match<Never, Nothing>
