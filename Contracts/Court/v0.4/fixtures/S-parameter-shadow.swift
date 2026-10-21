import Swift
func f<Never>() {}
protocol Admitted {}
enum Match<L, R> {}
extension Match: Admitted where L == R {}
typealias Claim = Match<Never, Swift.Never>
