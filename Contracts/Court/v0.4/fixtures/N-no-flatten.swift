protocol Digit {}
protocol Admitted {}
enum Use<T> {}
extension Use: Admitted where T: Digit {}
enum Leaf {}
enum A { enum Leaf: Digit {} }
typealias Claim = Use<Leaf>
