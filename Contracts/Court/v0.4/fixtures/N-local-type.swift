protocol Digit {}
protocol Admitted {}
enum Use<T> {}
extension Use: Admitted where T: Digit {}
func local() { enum Leaf: Digit {} }
typealias Claim = Use<Leaf>
