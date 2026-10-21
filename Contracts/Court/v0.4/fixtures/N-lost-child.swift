protocol Digit {}
protocol Admitted {}
enum Use<T> {}
extension Use: Admitted where T: Digit {}
enum A { enum Other: Digit {} }
typealias Claim = Use<A.Leaf>
