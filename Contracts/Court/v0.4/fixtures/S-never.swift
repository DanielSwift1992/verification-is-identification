import Swift
protocol Admitted {}
enum Match<A, B> {}
extension Match: Admitted where A == B {}
typealias Claim = Match<Never, Swift.Never>
