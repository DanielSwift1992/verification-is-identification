protocol Digit {}
protocol Admitted {}
enum Use<T> {}
extension Use: Admitted where T: Digit {}
enum A { struct Leaf: Digit {} }
typealias Claim = Use<A.Leaf>
