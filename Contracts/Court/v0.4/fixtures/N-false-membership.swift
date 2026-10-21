protocol Digit {}
protocol Admitted {}
enum Use<T> {}
extension Use: Admitted where T: Digit {}
protocol Other {}
enum A { enum Leaf: Other {} }
typealias Claim = Use<A.Leaf>
